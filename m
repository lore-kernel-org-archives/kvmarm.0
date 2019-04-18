Return-Path: <SRS0=ZrZ1=SU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A740C282DD
	for <kvmarm@archiver.kernel.org>; Thu, 18 Apr 2019 16:08:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD93A2171F
	for <kvmarm@archiver.kernel.org>; Thu, 18 Apr 2019 16:08:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD93A2171F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 866664A532;
	Thu, 18 Apr 2019 12:08:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1pAWIFZt7arv; Thu, 18 Apr 2019 12:08:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E0044A54B;
	Thu, 18 Apr 2019 12:08:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F7014A54A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ptphqw9KTTdC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Apr 2019 12:08:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44D264A547
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4CE216A3;
 Thu, 18 Apr 2019 09:08:11 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C111B3F5AF;
 Thu, 18 Apr 2019 09:08:09 -0700 (PDT)
From: Dave Martin <Dave.Martin@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 06/14] KVM: arm64/sve: Miscellaneous tidyups in guest.c
Date: Thu, 18 Apr 2019 17:07:03 +0100
Message-Id: <1555603631-8107-7-git-send-email-Dave.Martin@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190418160703.SIYOQN6kkcOR2hq2xfb-b2k9B79JT1d8tVGIz80_z7U@z>

 * Remove a few redundant blank lines that are stylistically
   inconsistent with code already in guest.c and are just taking up
   space.

 * Delete a couple of pointless empty default cases from switch
   statements whose behaviour is otherwise obvious anyway.

 * Fix some typos and consolidate some redundantly duplicated
   comments.

 * Respell the slice index check in sve_reg_to_region() as "> 0"
   to be more consistent with what is logically being checked here
   (i.e., "is the slice index too large"), even though we don't try
   to cope with multiple slices yet.

No functional change.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/guest.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2e449e1..f5ff7ae 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -290,9 +290,10 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 #define KVM_SVE_PREG_SIZE KVM_REG_SIZE(KVM_REG_ARM64_SVE_PREG(0, 0))
 
 /*
- * number of register slices required to cover each whole SVE register on vcpu
- * NOTE: If you are tempted to modify this, you must also to rework
- * sve_reg_to_region() to match:
+ * Number of register slices required to cover each whole SVE register.
+ * NOTE: Only the first slice every exists, for now.
+ * If you are tempted to modify this, you must also rework sve_reg_to_region()
+ * to match:
  */
 #define vcpu_sve_slices(vcpu) 1
 
@@ -334,8 +335,7 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 	/* Verify that we match the UAPI header: */
 	BUILD_BUG_ON(SVE_NUM_SLICES != KVM_ARM64_SVE_MAX_SLICES);
 
-	/* Only the first slice ever exists, for now: */
-	if ((reg->id & SVE_REG_SLICE_MASK) != 0)
+	if ((reg->id & SVE_REG_SLICE_MASK) > 0)
 		return -ENOENT;
 
 	vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
@@ -520,7 +520,6 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 {
-	/* Only the first slice ever exists, for now */
 	const unsigned int slices = vcpu_sve_slices(vcpu);
 
 	if (!vcpu_has_sve(vcpu))
@@ -536,7 +535,6 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 				u64 __user *uindices)
 {
-	/* Only the first slice ever exists, for now */
 	const unsigned int slices = vcpu_sve_slices(vcpu);
 	u64 reg;
 	unsigned int i, n;
@@ -555,7 +553,6 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 	reg = KVM_REG_ARM64_SVE_VLS;
 	if (put_user(reg, uindices++))
 		return -EFAULT;
-
 	++num_regs;
 
 	for (i = 0; i < slices; i++) {
@@ -563,7 +560,6 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
 			if (put_user(reg, uindices++))
 				return -EFAULT;
-
 			num_regs++;
 		}
 
@@ -571,14 +567,12 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 			reg = KVM_REG_ARM64_SVE_PREG(n, i);
 			if (put_user(reg, uindices++))
 				return -EFAULT;
-
 			num_regs++;
 		}
 
 		reg = KVM_REG_ARM64_SVE_FFR(i);
 		if (put_user(reg, uindices++))
 			return -EFAULT;
-
 		num_regs++;
 	}
 
@@ -645,7 +639,6 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_CORE:	return get_core_reg(vcpu, reg);
 	case KVM_REG_ARM_FW:	return kvm_arm_get_fw_reg(vcpu, reg);
 	case KVM_REG_ARM64_SVE:	return get_sve_reg(vcpu, reg);
-	default: break; /* fall through */
 	}
 
 	if (is_timer_reg(reg->id))
@@ -664,7 +657,6 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
 	case KVM_REG_ARM_FW:	return kvm_arm_set_fw_reg(vcpu, reg);
 	case KVM_REG_ARM64_SVE:	return set_sve_reg(vcpu, reg);
-	default: break; /* fall through */
 	}
 
 	if (is_timer_reg(reg->id))
-- 
2.1.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
