From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 06/12] kvm__set_dir(): avoid variable arguments call
Date: Fri, 17 Jul 2015 17:02:12 +0100
Message-ID: <1437148938-5394-7-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The clang compiler by default dislikes non-literal format strings
in *printf functions, so it complains about kvm__set_dir() in kvm.c.
Instead of suppressing this warning, lets change the code to avoid
that unneeded var_args detour and use a literal format string.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/kvm.h |  2 +-
 kvm.c             | 21 ++++++---------------
 main.c            |  9 ++++++++-
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 754e029..9818046 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -67,7 +67,7 @@ struct kvm {
 	int			vm_state;
 };
 
-void kvm__set_dir(const char *fmt, ...);
+int kvm__set_dir(const char *basedir, const char *lkvmdir);
 const char *kvm__get_dir(void);
 
 int kvm__init(struct kvm *kvm);
diff --git a/kvm.c b/kvm.c
index 78dd7c0..5222e1e 100644
--- a/kvm.c
+++ b/kvm.c
@@ -63,31 +63,22 @@ extern struct kvm_ext kvm_req_ext[];
 
 static char kvm_dir[PATH_MAX];
 
-static int set_dir(const char *fmt, va_list args)
+int kvm__set_dir(const char *basedir, const char* lkvmdir)
 {
 	char tmp[PATH_MAX];
 
-	vsnprintf(tmp, sizeof(tmp), fmt, args);
-
-	mkdir(tmp, 0777);
-
+	snprintf(tmp, PATH_MAX, "%s/%s", basedir, lkvmdir);
 	if (!realpath(tmp, kvm_dir))
-		return -errno;
+		return errno;
+
+	if (access(tmp, R_OK | W_OK))
+		return errno;
 
 	strcat(kvm_dir, "/");
 
 	return 0;
 }
 
-void kvm__set_dir(const char *fmt, ...)
-{
-	va_list args;
-
-	va_start(args, fmt);
-	set_dir(fmt, args);
-	va_end(args);
-}
-
 const char *kvm__get_dir(void)
 {
 	return kvm_dir;
diff --git a/main.c b/main.c
index 05bc82c..09ba8c1 100644
--- a/main.c
+++ b/main.c
@@ -13,7 +13,14 @@ static int handle_kvm_command(int argc, char **argv)
 
 int main(int argc, char *argv[])
 {
-	kvm__set_dir("%s/%s", HOME_DIR, KVM_PID_FILE_PATH);
+	int ret;
+
+	ret = kvm__set_dir(HOME_DIR, KVM_PID_FILE_PATH);
+	if (ret) {
+		pr_err("could not access lkvm directory \"%s/%s\"\n",
+		       HOME_DIR, KVM_PID_FILE_PATH);
+		return 1;
+	}
 
 	return handle_kvm_command(argc - 1, &argv[1]);
 }
-- 
2.3.5

