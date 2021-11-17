Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE93C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8AB0961BFB
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8AB0961BFB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 409254B0EC;
	Wed, 17 Nov 2021 10:37:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dqyvoaKsrS8q; Wed, 17 Nov 2021 10:37:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 379C94B1B6;
	Wed, 17 Nov 2021 10:37:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2FF24B119
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SmrwgSm0ebb4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FF254B174
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:31 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43BC4106F;
 Wed, 17 Nov 2021 07:37:31 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAB603F5A1;
 Wed, 17 Nov 2021 07:37:29 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 17/38] KVM: arm64: Allow userspace to set the SPE
 feature only if SPE is present
Date: Wed, 17 Nov 2021 15:38:21 +0000
Message-Id: <20211117153842.302159-18-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
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

Check that KVM SPE emulation is supported before allowing userspace to set
the KVM_ARM_VCPU_SPE feature.

According to ARM DDI 0487G.a, page D9-2946 the Profiling Buffer is disabled
if the owning Exception level is 32 bit, reject the SPE feature if the
VCPU's execution state at EL1 is aarch32.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/include/asm/kvm_spe.h  |  7 +++++++
 arch/arm64/kvm/reset.c            |  8 ++++++++
 arch/arm64/kvm/spe.c              | 16 ++++++++++++++++
 4 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0ebdef158020..8b3faed48914 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -815,6 +815,9 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
 
+#define kvm_vcpu_has_spe(vcpu)					\
+	(test_bit(KVM_ARM_VCPU_SPE, (vcpu)->arch.features))
+
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 8f8b7dd7fd90..d33a46a74f78 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -13,8 +13,15 @@ static __always_inline bool kvm_supports_spe(void)
 {
 	return static_branch_likely(&kvm_spe_available);
 }
+
+int kvm_spe_vcpu_enable_spe(struct kvm_vcpu *vcpu);
 #else
 #define kvm_supports_spe()	(false)
+
+static inline int kvm_spe_vcpu_enable_spe(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 #endif /* CONFIG_KVM_ARM_SPE */
 
 #endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 426bd7fbc3fd..8198156978bc 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -27,6 +27,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_spe.h>
 #include <asm/virt.h>
 
 /* Maximum phys_shift supported for any VM on this host */
@@ -251,6 +252,13 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
+	if (kvm_vcpu_has_spe(vcpu)) {
+		if (kvm_spe_vcpu_enable_spe(vcpu)) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 6cd0e24ddeec..7c6f94358cc1 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -7,6 +7,7 @@
 #include <linux/kvm_host.h>
 #include <linux/perf/arm_spe_pmu.h>
 
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_spe.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_spe_available);
@@ -26,3 +27,18 @@ void kvm_host_spe_init(struct arm_spe_pmu *spe_pmu)
 
 	mutex_unlock(&supported_cpus_lock);
 }
+
+int kvm_spe_vcpu_enable_spe(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_supports_spe())
+		return -EINVAL;
+
+	/*
+	 * The Profiling Buffer is disabled if the owning Exception level is
+	 * aarch32.
+	 */
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT))
+		return -EINVAL;
+
+	return 0;
+}
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
