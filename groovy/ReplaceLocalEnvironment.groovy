import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Paths
import java.nio.file.StandardOpenOption

/**
 * 调用时需要传入指定的文件绝对路径
 * IDEA 运行时添加一个 External Tool
 *    Program 填入 groovy 命令的执行路径D:\carl\work\script\src\main\groovy\ReplaceLocalDev.groovy $ProjectFileDir$ "cloud-service-activity"
 *    Arguments 填入 "<currentFilePath>" $ProjectFileDir$ "<moduleName>"
 *    运行的 Configuration 中 增加一个 before launch task,选择该 Tool即可
 */
final String filePath = "target/classes"

def devFileList = ["bootstrap.yml", "registry.conf"]
def test_service = "<regex>"
def local_service = "<replace>"
def test_namespace = '<regex>'
def local_namespace = '<replace>'

if (args == null || args.length == 0) {
    throw new IllegalArgumentException("未指定参数替换路径")
}

def list = new ArrayList<String>()
for (i in 1..<args.length) {
    list.add(args[i])
}
list.add(filePath)
String compileOutputPath = Paths.get(args[0], list as String[]).toString()

for (file in devFileList) {
    def path = Paths.get(compileOutputPath, file)
    if (!path.toFile().exists()) {
        continue
    }
    def fileContent = Files.readString(path, StandardCharsets.UTF_8)
    def replaced = fileContent.replaceAll(test_service, local_service)
            .replaceAll(test_namespace, local_namespace)
    println(replaced)
    path.toFile().delete()
    Files.write(path, replaced.getBytes(StandardCharsets.UTF_8),
            StandardOpenOption.CREATE_NEW, StandardOpenOption.WRITE)
}