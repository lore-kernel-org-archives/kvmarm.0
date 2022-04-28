Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20D0C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 15:56:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C3C94B25C;
	Thu, 28 Apr 2022 11:56:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DOc18hgog11Y; Thu, 28 Apr 2022 11:56:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDB3E4B2B7;
	Thu, 28 Apr 2022 11:56:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7555A4B260
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6QuWkmws0US9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 11:56:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 289C04B26C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E88891477;
 Thu, 28 Apr 2022 08:56:31 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84AB93F774;
 Thu, 28 Apr 2022 08:56:30 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: julien.thierry.kdev@gmail.com, will@kernel.org, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH kvmtool 15/15] arm/arm64: Validate firmware address in
 kvm__arch_validate_cfg()
Date: Thu, 28 Apr 2022 16:56:02 +0100
Message-Id: <20220428155602.29445-16-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428155602.29445-1-alexandru.elisei@arm.com>
References: <20220428155602.29445-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

We know at user configuration time if the firmware address is outside
RAM, validate the address in kvm__arch_validate_cfg() before creating
the VM.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 3edc6fdbcb5f..79d085ab9965 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -33,8 +33,20 @@ int fw_addr_parser(const struct option *opt, const char *arg, int unset)
 
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
-	if (kvm->cfg.arch.fw_addr && !kvm->cfg.firmware_filename)
-		die("--firmware-address is only valid when loading a firmware image");
+	u64 fw_addr = kvm->cfg.arch.fw_addr;
+	u64 ram_addr = kvm->cfg.ram_addr;
+	u64 ram_size = kvm->cfg.ram_size;
+
+	if (fw_addr) {
+		if (!kvm->cfg.firmware_filename)
+			die("--firmware-address is only valid when loading a firmware image");
+
+		if (fw_addr < ram_addr || fw_addr >= ram_addr + ram_size) {
+			die("Firmware address 0x%016llx outside guest memory: "
+			    "0x%016llx - 0x%016llx",
+			    fw_addr, ram_addr, ram_addr + ram_size);
+		}
+	}
 
 	kvm__arm_validate_cfg(kvm);
 }
@@ -196,23 +208,6 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	return true;
 }
 
-static bool validate_fw_addr(struct kvm *kvm, u64 fw_addr)
-{
-	u64 ram_phys;
-
-	ram_phys = host_to_guest_flat(kvm, kvm->ram_start);
-
-	if (fw_addr < ram_phys || fw_addr >= ram_phys + kvm->ram_size) {
-		pr_err("Provide --firmware-address an address in RAM: "
-		       "0x%016llx - 0x%016llx",
-		       ram_phys, ram_phys + kvm->ram_size);
-
-		return false;
-	}
-
-	return true;
-}
-
 bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
 {
 	u64 fw_addr = kvm->cfg.arch.fw_addr;
@@ -227,9 +222,6 @@ bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
 	if (fw_addr == 0)
 		fw_addr = kvm->arch.memory_guest_start;
 
-	if (!validate_fw_addr(kvm, fw_addr))
-		die("Bad firmware destination: 0x%016llx", fw_addr);
-
 	fd = open(firmware_filename, O_RDONLY);
 	if (fd < 0)
 		return false;
-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
