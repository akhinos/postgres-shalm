load("@ytt:base64", "base64")
def init(self, ca=None):
  self.team = "c21s"
  self.clusterName = "postgresql"
  self.deploymentName = "{}-{}".format(self.team, self.clusterName)
  self.service = "{}.{}.svc.cluster.local".format(self.deploymentName, self.namespace )
  self.port = 5432
  self.databases = {}
  if ca != None:
    self.cert = certificate("cert",signer=ca,domains=[self.service])
  else:
    self.cert = None

def apply(self,k8s):
  k8s.delete(kind="Job",name="postgresql-extension-job", ignore_not_found=True, timeout=60, namespace=self.namespace, namespaced=True)
  self.__apply(k8s)
  k8s.wait(kind="Job",name="postgresql-extension-job",condition="condition=Complete", timeout=180, namespace=self.namespace, namespaced=True)

def create_database(self, database):
  self.databases[database] = database + "-user"

def secret_name(self, database):
  return "{user}.{team}-{clusterName}.credentials.postgresql.acid.zalan.do".format(user=self.databases[database], team=self.team, clusterName = self.clusterName)

def credentials(self,database,k8s):
  secret = k8s.get(kind="Secret", name=self.secret_name(database),namespaced=True, namespace=self.namespace)
  return struct(port=self.port,host=self.service,database=database,user=self.databases[database],password=base64.decode(secret.data.password))