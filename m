From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 2/6] arm: Move firmware function
Date: Tue,  4 Dec 2018 11:14:29 +0000
Message-ID: <1543922073-55530-3-git-send-email-julien.thierry@arm.com>
References: <1543922073-55530-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B2694A342
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:14:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0cNrfdVAlSQr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 06:14:43 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3208A4A2BD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:14:43 -0500 (EST)
In-Reply-To: <1543922073-55530-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Sami.Mujawar@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Firmware loading/setup function are in fdt file while it is not very
related to this.

Move them to the file that does the main init/setup for memory.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 arm/fdt.c | 10 ----------
 arm/kvm.c | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 980015b..664bb62 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -14,16 +14,6 @@
 #include <linux/sizes.h>
 #include <linux/psci.h>
 
-bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
-{
-	return false;
-}
-
-int kvm__arch_setup_firmware(struct kvm *kvm)
-{
-	return 0;
-}
-
 static void dump_fdt(const char *dtb_file, void *fdt)
 {
 	int count, fd;
diff --git a/arm/kvm.c b/arm/kvm.c
index b824f63..c6843e5 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -168,3 +168,13 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 
 	return true;
 }
+
+bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
+{
+	return false;
+}
+
+int kvm__arch_setup_firmware(struct kvm *kvm)
+{
+	return 0;
+}
-- 
1.9.1
