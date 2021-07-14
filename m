Return-Path: <SRS0=5+eb=MG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E834C11F66
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 09:55:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2106461040
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 09:55:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2106461040
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C84E04B087;
	Wed, 14 Jul 2021 05:55:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JTrZxvKw1dMg; Wed, 14 Jul 2021 05:55:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 975304B080;
	Wed, 14 Jul 2021 05:55:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 911C34B088
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 05:55:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TssaqC7WIVJ2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Jul 2021 05:55:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B3C5407F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 05:55:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B83921042;
 Wed, 14 Jul 2021 02:55:09 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57C8D3F774;
 Wed, 14 Jul 2021 02:55:08 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/5] KVM: arm64: Use vcpu_has_feature() to check the feature
 bits
Date: Wed, 14 Jul 2021 10:55:58 +0100
Message-Id: <20210714095601.184854-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714095601.184854-1-alexandru.elisei@arm.com>
References: <20210714095601.184854-1-alexandru.elisei@arm.com>
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

Commit 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation") added
the vcpu_has_feature() function for checking if a feature bit is set.
Replace uses of test_bit() with the vcpu_has_feature() abstraction.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
There's one place place where I opted not to replace test_bit() with
vcpu_has_feature(), in arm.c::kvm_vcpu_set_target(). The function already
manipulates the feature bits directly, so I preferred to keep it
consistent.

 arch/arm64/include/asm/kvm_emulate.h |  2 +-
 arch/arm64/include/asm/kvm_host.h    |  4 ++--
 arch/arm64/kvm/arm.c                 |  2 +-
 arch/arm64/kvm/psci.c                |  2 +-
 arch/arm64/kvm/reset.c               | 12 ++++++------
 include/kvm/arm_psci.h               |  2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 6bf776c2399c..738fb51920d2 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -70,7 +70,7 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TVM;
 	}
 
-	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
 	/*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0b087bcfcfeb..e6bdf1feb922 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -781,8 +781,8 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
 
 #define kvm_has_mte(kvm) (system_supports_mte() && (kvm)->arch.mte_enabled)
-#define kvm_vcpu_has_pmu(vcpu)					\
-	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
+
+#define kvm_vcpu_has_pmu(vcpu)	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
 
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..646c7b003a59 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1108,7 +1108,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	/*
 	 * Handle the "start in power-off" case.
 	 */
-	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_POWER_OFF))
 		vcpu_power_off(vcpu);
 	else
 		vcpu->arch.power_off = false;
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index db4056ecccfd..536f637f1e41 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -492,7 +492,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	{
 		bool wants_02;
 
-		wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
+		wants_02 = vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2);
 
 		switch (val) {
 		case KVM_ARM_PSCI_0_1:
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index cba7872d69a8..80b16984cf3a 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -157,8 +157,8 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 	 * features are requested by the userspace together and the system
 	 * supports these capabilities.
 	 */
-	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
-	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
+	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_ADDRESS) ||
+	    !vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_GENERIC) ||
 	    !system_has_full_ptr_auth())
 		return -EINVAL;
 
@@ -223,7 +223,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		kvm_arch_vcpu_put(vcpu);
 
 	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
-		if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features)) {
+		if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
 			ret = kvm_vcpu_enable_sve(vcpu);
 			if (ret)
 				goto out;
@@ -232,8 +232,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		kvm_vcpu_reset_sve(vcpu);
 	}
 
-	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
-	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_ADDRESS) ||
+	    vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_GENERIC)) {
 		if (kvm_vcpu_enable_ptrauth(vcpu)) {
 			ret = -EINVAL;
 			goto out;
@@ -247,7 +247,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	switch (vcpu->arch.target) {
 	default:
-		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
+		if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT)) {
 			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 5b58bd2fe088..8b7891d7a368 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -29,7 +29,7 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu, struct kvm *kvm)
 	 * revisions. It is thus safe to return the latest, unless
 	 * userspace has instructed us otherwise.
 	 */
-	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2)) {
 		if (vcpu->kvm->arch.psci_version)
 			return vcpu->kvm->arch.psci_version;
 
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
