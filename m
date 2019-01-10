From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 3/6] builtin-run: Do not look for default kernel
 when firmware is provided
Date: Thu, 10 Jan 2019 14:20:43 +0000
Message-ID: <1547130046-14729-4-git-send-email-julien.thierry@arm.com>
References: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0DC44A3F9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:21:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K9IAoCMreTi1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:20:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB9844A486
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:20:58 -0500 (EST)
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

When a firmware file is provided, kvmtool is not responsible for loading
a kernel image.

There is no reason for looking for a default kernel image when loading
a firmware.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
---
 builtin-run.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 443c10b..82e2b2e 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -512,12 +512,13 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	kvm->nr_disks = kvm->cfg.image_count;
 
-	if (!kvm->cfg.kernel_filename)
+	if (!kvm->cfg.kernel_filename && !kvm->cfg.firmware_filename) {
 		kvm->cfg.kernel_filename = find_kernel();
 
-	if (!kvm->cfg.kernel_filename) {
-		kernel_usage_with_options();
-		return ERR_PTR(-EINVAL);
+		if (!kvm->cfg.kernel_filename) {
+			kernel_usage_with_options();
+			return ERR_PTR(-EINVAL);
+		}
 	}
 
 	kvm->cfg.vmlinux_filename = find_vmlinux();
@@ -639,10 +640,17 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	kvm->cfg.real_cmdline = real_cmdline;
 
-	printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
-		kvm->cfg.kernel_filename,
-		(unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
-		kvm->cfg.nrcpus, kvm->cfg.guest_name);
+	if (kvm->cfg.kernel_filename) {
+		printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
+		       kvm->cfg.kernel_filename,
+		       (unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
+		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
+	} else if (kvm->cfg.firmware_filename) {
+		printf("  # %s run --firmware %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
+		       kvm->cfg.firmware_filename,
+		       (unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
+		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
+	}
 
 	if (init_list__init(kvm) < 0)
 		die ("Initialisation failed");
-- 
1.9.1
