From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 2/6] arm: Move firmware function
Date: Thu, 10 Jan 2019 14:20:42 +0000
Message-ID: <1547130046-14729-3-git-send-email-julien.thierry@arm.com>
References: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50B784A47A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:20:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EMqraqs-fiqX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:20:57 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C254A48D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:20:57 -0500 (EST)
In-Reply-To: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
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
Cc: andre.przywara@arm.com, Sami.Mujawar@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Firmware loading/setup function are in fdt file while it is not very
related to this.

Move them to the file that does the main init/setup for memory.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
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
