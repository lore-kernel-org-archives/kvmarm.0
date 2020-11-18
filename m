Return-Path: <SRS0=VMV7=EY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A868EC5519F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 19:44:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F316246A6
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 19:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="de/zY21N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F316246A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1804B991;
	Wed, 18 Nov 2020 14:44:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8P7Akhh0qT7l; Wed, 18 Nov 2020 14:44:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 415FF4B9D3;
	Wed, 18 Nov 2020 14:44:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3880D4B98F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 14:44:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TJQ2gbHMOF91 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2020 14:44:11 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 030224B9C1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 14:44:11 -0500 (EST)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 01100246B1;
 Wed, 18 Nov 2020 19:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605728650;
 bh=dP7NEoeqisFZtBTjVHrS7+Zh9/f3VWC0VFFA0oh+61c=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=de/zY21N9lSe76x4sEXUUjhUkjHrmRoj3H8CzjQK5vXtq6Bfisg2MG5d4gtbThoRt
 TKJ+1OcqG26lyzULu2ebnctSJcrW0Xhc20t1e+HykEW/bsQJ49ATTW1ni3GGqbIPK+
 yPT8CKSW5Z9skcLKLuugQSvjPFFz+j8I1H9US3UI=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	maz@kernel.org
Subject: [PATCH 2/3] KVM: arm64: Remove kvm_arch_vm_ioctl_check_extension()
Date: Wed, 18 Nov 2020 19:44:01 +0000
Message-Id: <20201118194402.2892-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201118194402.2892-1-will@kernel.org>
References: <20201118194402.2892-1-will@kernel.org>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 Will Deacon <will@kernel.org>
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

kvm_arch_vm_ioctl_check_extension() is only called from
kvm_vm_ioctl_check_extension(), so we can inline it and remove the extra
function.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  5 +++
 arch/arm64/include/asm/kvm_host.h   |  1 -
 arch/arm64/kvm/arm.c                | 31 +++++++++++++++--
 arch/arm64/kvm/reset.c              | 52 -----------------------------
 4 files changed, 34 insertions(+), 55 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index da250e4741bd..461277ae7a48 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -699,6 +699,11 @@ static inline bool system_supports_generic_auth(void)
 		cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH);
 }
 
+static inline bool system_has_full_ptr_auth(void)
+{
+	return system_supports_address_auth() && system_supports_generic_auth();
+}
+
 static __always_inline bool system_uses_irq_prio_masking(void)
 {
 	return IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) &&
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 24cb00ce30dd..eee58fdee705 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -58,7 +58,6 @@ int kvm_arm_init_sve(void);
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
-int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
 struct kvm_vmid {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c0ffb019ca8b..68c0cd320a7b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -198,6 +198,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
 	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
+	case KVM_CAP_SET_GUEST_DEBUG:
+	case KVM_CAP_VCPU_ATTRIBUTES:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
@@ -229,10 +231,35 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_STEAL_TIME:
 		r = kvm_arm_pvtime_supported();
 		break;
-	default:
-		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
+	case KVM_CAP_ARM_EL1_32BIT:
+		r = cpus_have_const_cap(ARM64_HAS_32BIT_EL1);
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_BPS:
+		r = get_num_brps();
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_WPS:
+		r = get_num_wrps();
+		break;
+	case KVM_CAP_ARM_PMU_V3:
+		r = kvm_arm_support_pmu_v3();
+		break;
+	case KVM_CAP_ARM_INJECT_SERROR_ESR:
+		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
+		break;
+	case KVM_CAP_ARM_VM_IPA_SIZE:
+		r = get_kvm_ipa_limit();
 		break;
+	case KVM_CAP_ARM_SVE:
+		r = system_supports_sve();
+		break;
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+		r = system_has_full_ptr_auth();
+		break;
+	default:
+		r = 0;
 	}
+
 	return r;
 }
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f32490229a4c..c7985f4607a9 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -42,58 +42,6 @@ static u32 kvm_ipa_limit;
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
-static bool system_has_full_ptr_auth(void)
-{
-	return system_supports_address_auth() && system_supports_generic_auth();
-}
-
-/**
- * kvm_arch_vm_ioctl_check_extension
- *
- * We currently assume that the number of HW registers is uniform
- * across all CPUs (see cpuinfo_sanity_check).
- */
-int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
-{
-	int r;
-
-	switch (ext) {
-	case KVM_CAP_ARM_EL1_32BIT:
-		r = cpus_have_const_cap(ARM64_HAS_32BIT_EL1);
-		break;
-	case KVM_CAP_GUEST_DEBUG_HW_BPS:
-		r = get_num_brps();
-		break;
-	case KVM_CAP_GUEST_DEBUG_HW_WPS:
-		r = get_num_wrps();
-		break;
-	case KVM_CAP_ARM_PMU_V3:
-		r = kvm_arm_support_pmu_v3();
-		break;
-	case KVM_CAP_ARM_INJECT_SERROR_ESR:
-		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
-		break;
-	case KVM_CAP_SET_GUEST_DEBUG:
-	case KVM_CAP_VCPU_ATTRIBUTES:
-		r = 1;
-		break;
-	case KVM_CAP_ARM_VM_IPA_SIZE:
-		r = kvm_ipa_limit;
-		break;
-	case KVM_CAP_ARM_SVE:
-		r = system_supports_sve();
-		break;
-	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
-	case KVM_CAP_ARM_PTRAUTH_GENERIC:
-		r = system_has_full_ptr_auth();
-		break;
-	default:
-		r = 0;
-	}
-
-	return r;
-}
-
 unsigned int kvm_sve_max_vl;
 
 int kvm_arm_init_sve(void)
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
