Return-Path: <SRS0=3L6A=KT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477ACC04FF3
	for <kvmarm@archiver.kernel.org>; Mon, 24 May 2021 17:08:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B59FD61411
	for <kvmarm@archiver.kernel.org>; Mon, 24 May 2021 17:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B59FD61411
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F7CB4B139;
	Mon, 24 May 2021 13:08:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xjuJk7GANKBC; Mon, 24 May 2021 13:08:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 452FE4B13B;
	Mon, 24 May 2021 13:08:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC54C4B139
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 13:08:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MR5ozcmlskKq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 May 2021 13:08:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEDF54B138
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 May 2021 13:08:05 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 03D4B61404;
 Mon, 24 May 2021 17:08:04 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1llE3d-003IXQ-Us; Mon, 24 May 2021 18:08:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2] KVM: arm64: Prevent mixed-width VM creation
Date: Mon, 24 May 2021 18:07:52 +0100
Message-Id: <20210524170752.1549797-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com,
 steven.price@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, stable@vger.kernel.org,
 Steven Price <steven.price@arm.com>
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

It looks like we have tolerated creating mixed-width VMs since...
forever. However, that was never the intention, and we'd rather
not have to support that pointless complexity.

Forbid such a setup by making sure all the vcpus have the same
register width.

Reported-by: Steven Price <steven.price@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---

Notes:
    v2: Fix missing check against ARM64_HAS_32BIT_EL1 (Mark)

 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/kvm/reset.c               | 28 ++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f612c090f2e4..01b9857757f2 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -463,4 +463,9 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
 }
 
+static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
+{
+	return test_bit(feature, vcpu->arch.features);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 956cdc240148..d37ebee085cf 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -166,6 +166,25 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu *tmp;
+	bool is32bit;
+	int i;
+
+	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
+	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
+		return false;
+
+	/* Check that the vcpus are either all 32bit or all 64bit */
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
+			return false;
+	}
+
+	return true;
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
@@ -217,13 +236,14 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (!vcpu_allowed_register_width(vcpu)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1)) {
-				ret = -EINVAL;
-				goto out;
-			}
 			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
