// @ts-check
const path = require("path");
const fs = require("fs");
const loader = require("csv-load-sync");
const config = { path: "", header: [] };

const dataPadding = 100;

const base = "./SensorRecordings";

const xFiles = [
  "Accelerometer.csv",
  "AccelerometerLinear.csv",
  "Gravity.csv",
  "Gyroscope.csv",
  "RotationVector.csv",
  "Compass.csv"
];

const yFile = "GPS.csv";

getDirectories(base).forEach(folder => {
  // load X
  let matrix = xFiles.map(file => loadFile(folder, file)).map(normalize);

  // load y
  matrix.push(loadFile(folder, yFile));

  // min length of all csv files
  const length = Math.min(...matrix.map(a => a.length));

  // remove first and last values
  matrix = matrix.map(a => a.slice(dataPadding, length - dataPadding));

  const merged = [];
  // merge all files
  matrix[0].forEach((_, i) =>
    merged.push({
      ...matrix[0][i],
      ...matrix[1][i],
      ...matrix[2][i],
      ...matrix[3][i],
      ...matrix[4][i],
      ...matrix[5][i],
      ...matrix[6][i]
    })
  );
  // @ts-ignore
  config.header = matrix
    .reduce((keys, curr) => keys.concat(Object.keys(curr[0] || {})), [])
    .map(key => ({ id: key, title: key }));

  const outPath = "output";
  config.path = path.join(outPath, folder + ".csv");
  if (!fs.existsSync(outPath)) {
    fs.mkdirSync(outPath);
  }

  // write to csv
  write(config.path, merged);
});

function getDirectories(source) {
  return fs
    .readdirSync(source, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name);
}

function loadFile(folder, file) {
  const p = path.join(base, folder, file);
  if (!fs.existsSync(p)) {
    return [];
  }

  // load csv
  const contents = loader(p);

  switch (file) {
    case "Accelerometer.csv": {
      return contents.map(c => ({
        timestamp: c.Milliseconds,
        AccX: c.X,
        AccY: c.Y,
        AccZ: c.Z
      }));
    }
    case "AccelerometerLinear.csv": {
      return contents.map(c => ({ AccLinX: c.X, AccLinY: c.Y, AccLinZ: c.Z }));
    }
    case "Gravity.csv": {
      return contents.map(c => ({ GravX: c.X, GravY: c.Y, GravZ: c.Z }));
    }
    case "Gyroscope.csv": {
      return contents.map(c => ({ GyrX: c.X, GyrY: c.Y, GyrZ: c.Z }));
    }
    case "RotationVector.csv": {
      return contents.map(c => ({
        RotVX: c.X,
        RotVY: c.Y,
        RotVZ: c.Z,
        RotVcos: c.cos,
        RotVacc: c.headingAccuracy
      }));
    }
    case "Compass.csv": {
      return contents.map(c => ({ CompX: c.X, CompY: c.Y, CompZ: c.Z }));
    }
    case yFile: {
      return contents.map(c => ({ GravX: c.X, GravY: c.Y, GravZ: c.Z }));
    }
  }
}

function write(path, content) {
  const batch = 20;
  const lines = [];

  const datalines = content.map(c =>
    Object.keys(c)
      .map(k => c[k])
      .join(" ")
  );

  for (let i = 0; i < datalines.length - batch; i++) {
    lines.push(...datalines.slice(i, i + batch).concat(""));
  }

  fs.writeFileSync(path, lines.join("\n"));
}

function normalize(all) {
  return all;
  const blacklist = ["timestamp"];
  const map = {};
  Object.keys(all[0] || {})
    .filter(key => !blacklist.includes(key))
    .map(k => {
      const vals = all.map(v => parseFloat(v[k]));
      let max = Math.max(...vals);
      let min = Math.min(...vals);
      max *= 0.1;
      min *= 0.1;

      map[k] = { max, min };
    });

  return all.map(line =>
    Object.keys(line).map(key => {
      if (blacklist.includes(key)) {
        return line[key];
      }
      const m = map[key];
      const a = parseFloat(line[key]);
      return 2 * (a - m.min / (m.max - m.min)) - 1;
    })
  );
}
