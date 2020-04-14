Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7E8C2BB1D
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 21:31:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00B1B20644
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 21:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXyTve68"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00B1B20644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEFDF4B226;
	Tue, 14 Apr 2020 17:31:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GfGA96tOJPVY; Tue, 14 Apr 2020 17:31:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FEF34B231;
	Tue, 14 Apr 2020 17:31:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A1404B254
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 17:31:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7wbcwLlDHgCm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 17:31:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19B154B262
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 17:31:32 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 654082076C;
 Tue, 14 Apr 2020 21:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586899891;
 bh=85jy7wXfONn6y57hNNcgHLb3OEzrojviwms+zej2GhA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=mXyTve68vOAkNGMPS/ZK1beKlSOiszrQ0y8zDamGMovsT1ZmEMAf09kQcN3UrGWGs
 ZnfIpkXNhflG5FrYCYwdgiVn4Fwv2W9rYes+wCWdVgXQCtdftQ2FRdNfruCXaVs9nU
 YbYECOB9hfi7qQ4va+cYk0HLQOMjuVW9bFYlnws4=
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/8] arm64: cpufeature: Add CPU capability for AArch32 EL1
 support
Date: Tue, 14 Apr 2020 22:31:09 +0100
Message-Id: <20200414213114.2378-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414213114.2378-1-will@kernel.org>
References: <20200414213114.2378-1-will@kernel.org>
MIME-Version: 1.0
Cc: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
 kernel-team@android.com, Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Doug Anderson <dianders@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Although we emit a "SANITY CHECK" warning and taint the kernel if we
detect a CPU mismatch for AArch32 support at EL1, we still online the
CPU with disastrous consequences for any running 32-bit VMs.

Introduce a capability for AArch32 support at EL1 so that late onlining
of incompatible CPUs is forbidden.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/include/asm/sysreg.h  |  1 +
 arch/arm64/kernel/cpufeature.c   | 12 ++++++++++++
 arch/arm64/kvm/reset.c           | 12 ++----------
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8eb5a088ae65..c54c674e6c21 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -61,7 +61,8 @@
 #define ARM64_HAS_AMU_EXTN			51
 #define ARM64_HAS_ADDRESS_AUTH			52
 #define ARM64_HAS_GENERIC_AUTH			53
+#define ARM64_HAS_32BIT_EL1			54
 
-#define ARM64_NCAPS				54
+#define ARM64_NCAPS				55
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 139cd24c181b..3d8e2f0347c4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -653,6 +653,7 @@
 #define ID_AA64PFR0_ASIMD_NI		0xf
 #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
 #define ID_AA64PFR0_EL1_64BIT_ONLY	0x1
+#define ID_AA64PFR0_EL1_32BIT_64BIT	0x2
 #define ID_AA64PFR0_EL0_64BIT_ONLY	0x1
 #define ID_AA64PFR0_EL0_32BIT_64BIT	0x2
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b143f8bc6c52..838fe5cc8d7e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1535,6 +1535,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64PFR0_EL0_SHIFT,
 		.min_field_value = ID_AA64PFR0_EL0_32BIT_64BIT,
 	},
+#ifdef CONFIG_KVM
+	{
+		.desc = "32-bit EL1 Support",
+		.capability = ARM64_HAS_32BIT_EL1,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64PFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64PFR0_EL1_SHIFT,
+		.min_field_value = ID_AA64PFR0_EL1_32BIT_64BIT,
+	},
+#endif
 	{
 		.desc = "Kernel page table isolation (KPTI)",
 		.capability = ARM64_UNMAP_KERNEL_AT_EL0,
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 30b7ea680f66..102e5c4e01a0 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -46,14 +46,6 @@ static const struct kvm_regs default_regs_reset32 = {
 			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
 };
 
-static bool cpu_has_32bit_el1(void)
-{
-	u64 pfr0;
-
-	pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
-	return !!(pfr0 & 0x20);
-}
-
 /**
  * kvm_arch_vm_ioctl_check_extension
  *
@@ -66,7 +58,7 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
 	switch (ext) {
 	case KVM_CAP_ARM_EL1_32BIT:
-		r = cpu_has_32bit_el1();
+		r = cpus_have_const_cap(ARM64_HAS_32BIT_EL1);
 		break;
 	case KVM_CAP_GUEST_DEBUG_HW_BPS:
 		r = get_num_brps();
@@ -288,7 +280,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-			if (!cpu_has_32bit_el1())
+			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
 				goto out;
 			cpu_reset = &default_regs_reset32;
 		} else {
-- 
2.26.0.110.g2183baf09c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
