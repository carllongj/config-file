import java.nio.channels.FileChannel
import java.nio.file.Paths
import java.nio.file.StandardOpenOption

final String filePath = "target/classes"

if (args == null || args.length < 2) {
    throw new IllegalArgumentException("未指定参数替换路径")
}

def list = new ArrayList<String>()
list.add(args[1])
list.add(filePath)

String compileOutputPath = Paths.get(args[0], list as String[]).toString()
for (i in 2..<args.length) {
    def path = args[i]
    def file = new File(path)
    if (!file.exists()) {
        throw new IllegalArgumentException("文件路径${path}不存在")
    }
    def filename = path.substring(path.lastIndexOf((int) File.separatorChar) + 1)
    def targetFile = Paths.get(compileOutputPath, filename).toFile()
    if (targetFile.exists()) {
        targetFile.delete()
    }
    try (def writeChannel = FileChannel.open(targetFile.toPath(), StandardOpenOption.CREATE_NEW, StandardOpenOption.WRITE)
        def readChannel = FileChannel.open(file.toPath(), StandardOpenOption.READ)
    ) {
        readChannel.transferTo(0L, file.length(), writeChannel)
    }
}
