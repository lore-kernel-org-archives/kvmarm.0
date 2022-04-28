Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32837C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 15:56:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFB724B260;
	Thu, 28 Apr 2022 11:56:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nH73PGlZpAkV; Thu, 28 Apr 2022 11:56:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B46114B2AA;
	Thu, 28 Apr 2022 11:56:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B934B291
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p5D7IjiRcRuf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 11:56:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78CD64B2AD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 473121474;
 Thu, 28 Apr 2022 08:56:30 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D750B3F774;
 Thu, 28 Apr 2022 08:56:28 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: julien.thierry.kdev@gmail.com, will@kernel.org, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH kvmtool 14/15] arm/arm64: Treat --firmware-address when no
 --firmware as an error
Date: Thu, 28 Apr 2022 16:56:01 +0100
Message-Id: <20220428155602.29445-15-alexandru.elisei@arm.com>
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

It makes little sense for the user to specify the firmware address when
loading a kernel instead of a firmware image. Treat it as an error.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch32/kvm.c                 | 2 +-
 arm/aarch64/kvm.c                 | 2 +-
 arm/include/arm-common/kvm-arch.h | 3 +++
 arm/kvm.c                         | 8 ++++++++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arm/aarch32/kvm.c b/arm/aarch32/kvm.c
index 768a56bbb5b4..a7bb3b79db8c 100644
--- a/arm/aarch32/kvm.c
+++ b/arm/aarch32/kvm.c
@@ -1,6 +1,6 @@
 #include "kvm/kvm.h"
 
-void kvm__arch_validate_cfg(struct kvm *kvm)
+void kvm__arm_validate_cfg(struct kvm *kvm)
 {
 	if (kvm->cfg.ram_size > ARM_LOMAP_MAX_MEMORY) {
 		die("RAM size 0x%llx exceeds maximum allowed 0x%llx",
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 581c836eb6ae..8fb44a924aa4 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -10,7 +10,7 @@ u64 kvm__arch_default_ram_address(void)
 	return ARM_MEMORY_AREA;
 }
 
-void kvm__arch_validate_cfg(struct kvm *kvm)
+void kvm__arm_validate_cfg(struct kvm *kvm)
 {
 	if (kvm->cfg.arch.aarch32_guest &&
 	    kvm->cfg.ram_size > ARM_LOMAP_MAX_MEMORY) {
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index cbe2bb2381ef..1d1ccc8bb172 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -88,6 +88,9 @@ static inline bool arm_addr_in_ioport_region(u64 phys_addr)
 	return phys_addr >= KVM_IOPORT_AREA && phys_addr < limit;
 }
 
+struct kvm;
+void kvm__arm_validate_cfg(struct kvm *kvm);
+
 struct kvm_arch {
 	/*
 	 * We may have to align the guest memory for virtio, so keep the
diff --git a/arm/kvm.c b/arm/kvm.c
index 83df1c9a0cde..3edc6fdbcb5f 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -31,6 +31,14 @@ int fw_addr_parser(const struct option *opt, const char *arg, int unset)
 	return 0;
 }
 
+void kvm__arch_validate_cfg(struct kvm *kvm)
+{
+	if (kvm->cfg.arch.fw_addr && !kvm->cfg.firmware_filename)
+		die("--firmware-address is only valid when loading a firmware image");
+
+	kvm__arm_validate_cfg(kvm);
+}
+
 bool kvm__arch_cpu_supports_vm(void)
 {
 	/* The KVM capability check is enough. */
-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
