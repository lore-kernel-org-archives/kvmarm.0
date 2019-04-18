Return-Path: <SRS0=ZrZ1=SU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A60CC10F14
	for <kvmarm@archiver.kernel.org>; Thu, 18 Apr 2019 16:08:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08F7021479
	for <kvmarm@archiver.kernel.org>; Thu, 18 Apr 2019 16:08:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08F7021479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B644D4A550;
	Thu, 18 Apr 2019 12:08:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id adZm9Ohklxou; Thu, 18 Apr 2019 12:08:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4784E4A52A;
	Thu, 18 Apr 2019 12:08:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C486B4A51B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tcxGH7UiBeY6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Apr 2019 12:08:15 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B043B4A511
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 327791715;
 Thu, 18 Apr 2019 09:08:14 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1EDF83F5AF;
 Thu, 18 Apr 2019 09:08:11 -0700 (PDT)
From: Dave Martin <Dave.Martin@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 07/14] KVM: arm64/sve: Make register ioctl access errors
 more consistent
Date: Thu, 18 Apr 2019 17:07:04 +0100
Message-Id: <1555603631-8107-8-git-send-email-Dave.Martin@arm.com>
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
Message-ID: <20190418160704.pKb84riR4afLECkFl1Sk-RBKGv_KP0IC9QBHIlNN0uk@z>

Currently, the way error codes are generated when processing the
SVE register access ioctls in a bit haphazard.

This patch refactors the code so that the behaviour is more
consistent: now, -EINVAL should be returned only for unrecognised
register IDs or when some other runtime error occurs.  -ENOENT is
returned for register IDs that are recognised, but whose
corresponding register (or slice) does not exist for the vcpu.

To this end, in {get,set}_sve_reg() we now delegate the
vcpu_has_sve() check down into {get,set}_sve_vls() and
sve_reg_to_region().  The KVM_REG_ARM64_SVE_VLS special case is
picked off first, then sve_reg_to_region() plays the role of
exhaustively validating or rejecting the register ID and (where
accepted) computing the applicable register region as before.

sve_reg_to_region() is rearranged so that -ENOENT or -EPERM is not
returned prematurely, before checking whether reg->id is in a
recognised range.

-EPERM is now only returned when an attempt is made to access an
actually existing register slice on an unfinalized vcpu.

Fixes: e1c9c98345b3 ("KVM: arm64/sve: Add SVE support to register access ioctl interface")
Fixes: 9033bba4b535 ("KVM: arm64/sve: Add pseudo-register for the guest's vector lengths")
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/guest.c | 52 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index f5ff7ae..e45a042 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -221,6 +221,9 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	unsigned int max_vq, vq;
 	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
 
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
 	if (WARN_ON(!sve_vl_valid(vcpu->arch.sve_max_vl)))
 		return -EINVAL;
 
@@ -242,6 +245,9 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	unsigned int max_vq, vq;
 	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
 
+	if (!vcpu_has_sve(vcpu))
+		return -ENOENT;
+
 	if (kvm_arm_vcpu_sve_finalized(vcpu))
 		return -EPERM; /* too late! */
 
@@ -304,7 +310,10 @@ struct sve_state_reg_region {
 	unsigned int upad;	/* extra trailing padding in user memory */
 };
 
-/* Get sanitised bounds for user/kernel SVE register copy */
+/*
+ * Validate SVE register ID and get sanitised bounds for user/kernel SVE
+ * register copy
+ */
 static int sve_reg_to_region(struct sve_state_reg_region *region,
 			     struct kvm_vcpu *vcpu,
 			     const struct kvm_one_reg *reg)
@@ -335,25 +344,30 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 	/* Verify that we match the UAPI header: */
 	BUILD_BUG_ON(SVE_NUM_SLICES != KVM_ARM64_SVE_MAX_SLICES);
 
-	if ((reg->id & SVE_REG_SLICE_MASK) > 0)
-		return -ENOENT;
-
-	vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
-
 	reg_num = (reg->id & SVE_REG_ID_MASK) >> SVE_REG_ID_SHIFT;
 
 	if (reg->id >= zreg_id_min && reg->id <= zreg_id_max) {
+		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
+			return -ENOENT;
+
+		vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
+
 		reqoffset = SVE_SIG_ZREG_OFFSET(vq, reg_num) -
 				SVE_SIG_REGS_OFFSET;
 		reqlen = KVM_SVE_ZREG_SIZE;
 		maxlen = SVE_SIG_ZREG_SIZE(vq);
 	} else if (reg->id >= preg_id_min && reg->id <= preg_id_max) {
+		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
+			return -ENOENT;
+
+		vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
+
 		reqoffset = SVE_SIG_PREG_OFFSET(vq, reg_num) -
 				SVE_SIG_REGS_OFFSET;
 		reqlen = KVM_SVE_PREG_SIZE;
 		maxlen = SVE_SIG_PREG_SIZE(vq);
 	} else {
-		return -ENOENT;
+		return -EINVAL;
 	}
 
 	sve_state_size = vcpu_sve_state_size(vcpu);
@@ -369,24 +383,22 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 
 static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	int ret;
 	struct sve_state_reg_region region;
 	char __user *uptr = (char __user *)reg->addr;
 
-	if (!vcpu_has_sve(vcpu))
-		return -ENOENT;
-
 	/* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
 	if (reg->id == KVM_REG_ARM64_SVE_VLS)
 		return get_sve_vls(vcpu, reg);
 
-	/* Otherwise, reg is an architectural SVE register... */
+	/* Try to interpret reg ID as an architectural SVE register... */
+	ret = sve_reg_to_region(&region, vcpu, reg);
+	if (ret)
+		return ret;
 
 	if (!kvm_arm_vcpu_sve_finalized(vcpu))
 		return -EPERM;
 
-	if (sve_reg_to_region(&region, vcpu, reg))
-		return -ENOENT;
-
 	if (copy_to_user(uptr, vcpu->arch.sve_state + region.koffset,
 			 region.klen) ||
 	    clear_user(uptr + region.klen, region.upad))
@@ -397,24 +409,22 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	int ret;
 	struct sve_state_reg_region region;
 	const char __user *uptr = (const char __user *)reg->addr;
 
-	if (!vcpu_has_sve(vcpu))
-		return -ENOENT;
-
 	/* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
 	if (reg->id == KVM_REG_ARM64_SVE_VLS)
 		return set_sve_vls(vcpu, reg);
 
-	/* Otherwise, reg is an architectural SVE register... */
+	/* Try to interpret reg ID as an architectural SVE register... */
+	ret = sve_reg_to_region(&region, vcpu, reg);
+	if (ret)
+		return ret;
 
 	if (!kvm_arm_vcpu_sve_finalized(vcpu))
 		return -EPERM;
 
-	if (sve_reg_to_region(&region, vcpu, reg))
-		return -ENOENT;
-
 	if (copy_from_user(vcpu->arch.sve_state + region.koffset, uptr,
 			   region.klen))
 		return -EFAULT;
-- 
2.1.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
