Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0EFC433E6
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 12:25:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C19B64F53
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 12:25:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C19B64F53
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C5D34B77F;
	Thu, 18 Mar 2021 08:25:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aX8wJeZl68X1; Thu, 18 Mar 2021 08:25:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFD674B72B;
	Thu, 18 Mar 2021 08:25:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 768ED4B752
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 08:25:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nDPXfTLYXuDT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 08:25:48 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0F0A4B74E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 08:25:47 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E0D0E64F6C;
 Thu, 18 Mar 2021 12:25:46 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lMrij-002OZW-3G; Thu, 18 Mar 2021 12:25:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH v2 04/11] KVM: arm64: Introduce vcpu_sve_vq() helper
Date: Thu, 18 Mar 2021 12:25:25 +0000
Message-Id: <20210318122532.505263-5-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210318122532.505263-1-maz@kernel.org>
References: <20210318122532.505263-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, dave.martin@arm.com,
 daniel.kiss@arm.com, will@kernel.org, catalin.marinas@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 broonie@kernel.org, ascull@google.com, qperret@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 broonie@kernel.org, Will Deacon <will@kernel.org>, dave.martin@arm.com,
 daniel.kiss@arm.com
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

The KVM code contains a number of "sve_vq_from_vl(vcpu->arch.sve_max_vl)"
instances, and we are about to add more.

Introduce vcpu_sve_vq() as a shorthand for this expression.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 4 +++-
 arch/arm64/kvm/guest.c                  | 6 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fb1d78299ba0..e59b16008868 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -375,6 +375,8 @@ struct kvm_vcpu_arch {
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
 			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
 
+#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
+
 #define vcpu_sve_state_size(vcpu) ({					\
 	size_t __size_ret;						\
 	unsigned int __vcpu_vq;						\
@@ -382,7 +384,7 @@ struct kvm_vcpu_arch {
 	if (WARN_ON(!sve_vl_valid((vcpu)->arch.sve_max_vl))) {		\
 		__size_ret = 0;						\
 	} else {							\
-		__vcpu_vq = sve_vq_from_vl((vcpu)->arch.sve_max_vl);	\
+		__vcpu_vq = vcpu_sve_max_vq(vcpu);			\
 		__size_ret = SVE_SIG_REGS_SIZE(__vcpu_vq);		\
 	}								\
 									\
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 9bbd30e62799..c763808cacdf 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -299,7 +299,7 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	memset(vqs, 0, sizeof(vqs));
 
-	max_vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
+	max_vq = vcpu_sve_max_vq(vcpu);
 	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
 		if (sve_vq_available(vq))
 			vqs[vq_word(vq)] |= vq_mask(vq);
@@ -427,7 +427,7 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
 			return -ENOENT;
 
-		vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
+		vq = vcpu_sve_max_vq(vcpu);
 
 		reqoffset = SVE_SIG_ZREG_OFFSET(vq, reg_num) -
 				SVE_SIG_REGS_OFFSET;
@@ -437,7 +437,7 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 		if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
 			return -ENOENT;
 
-		vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
+		vq = vcpu_sve_max_vq(vcpu);
 
 		reqoffset = SVE_SIG_PREG_OFFSET(vq, reg_num) -
 				SVE_SIG_REGS_OFFSET;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d762d5bdc2d5..fb68271c1a0f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -268,7 +268,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	if (sve_guest) {
 		__sve_restore_state(vcpu_sve_pffr(vcpu),
 				    &vcpu->arch.ctxt.fp_regs.fpsr,
-				    sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
+				    vcpu_sve_vq(vcpu) - 1);
 		write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 	} else {
 		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
