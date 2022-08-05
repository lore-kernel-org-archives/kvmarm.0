Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA43C25B08
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 13:58:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36C414D0D0;
	Fri,  5 Aug 2022 09:58:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JcrdzXrjiQTq; Fri,  5 Aug 2022 09:58:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCFAB4EAA9;
	Fri,  5 Aug 2022 09:58:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2837B4E9AB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 09:58:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y3BDMXd+E0f1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Aug 2022 09:58:23 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55E254E901
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 09:58:23 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id CC37C60D38;
 Fri,  5 Aug 2022 13:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CD4C43142;
 Fri,  5 Aug 2022 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1659707902;
 bh=FX8KHe9gh8du9g8SR8sMvTMXuTpe7PJm5fL6a0/3oiU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=l/In9iXTPjegCFxTKSpYKCwbd9tEqJoqqpOKDZnua4sgR8oKqWv/QV0jXBwbTGwov
 UQiLldbOGUGMEnlqw35wjRcvjMI3rO/Z7nUpEzhGVgvQ1h4KC/OYUqk7ZTAMdR59g/
 hqs1/ryfJVr/0T9fi2iGAZ+jCQFT3VsFUHT/86BYY5EqNIvFchMgGYYnVgkB/97R54
 V/yFG0goSCL99nScaOwMIhxfMgpVKdzNquCqEY+cBbgeP9BwL9nEZmNF/uxvrszlFD
 VyENyEl/fTeBe7X52S4emABSH1+doqi9kiAuYSsCwznlR37baO/hL5BbxfEPjWu63F
 He4uGRgVCH1vw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oJxqG-001AeL-Ss;
 Fri, 05 Aug 2022 14:58:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 8/9] KVM: arm64: PMU: Implement PMUv3p5 long counter support
Date: Fri,  5 Aug 2022 14:58:12 +0100
Message-Id: <20220805135813.2102034-9-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220805135813.2102034-1-maz@kernel.org>
References: <20220805135813.2102034-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 ricarkol@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

PMUv3p5 (which is mandatory with ARMv8.5) comes with some extra
features:

- All counters are 64bit

- The overflow point is controlled by the PMCR_EL0.LP bit

Add the required checks in the helpers that control counter
width and overflow, as well as the sysreg handling for the LP
bit. A new kvm_pmu_is_3p5() helper makes it easy to spot the
PMUv3p5 specific handling.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 8 +++++---
 arch/arm64/kvm/sys_regs.c | 4 ++++
 include/kvm/arm_pmu.h     | 8 ++++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 33a88ca7b7fd..b33a2953cbf6 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -50,13 +50,15 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
  */
 static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	return (select_idx == ARMV8_PMU_CYCLE_IDX);
+	return (select_idx == ARMV8_PMU_CYCLE_IDX || kvm_pmu_is_3p5(vcpu));
 }
 
 static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
-		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
+	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+
+	return (select_idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
+	       (select_idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
 }
 
 static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c0595f31dab8..2b5e0ec5c100 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -654,6 +654,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
 	if (!system_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
+	if (!kvm_pmu_is_3p5(vcpu))
+		val &= ~ARMV8_PMU_PMCR_LP;
 	__vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
@@ -703,6 +705,8 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!system_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
+		if (!kvm_pmu_is_3p5(vcpu))
+			val &= ~ARMV8_PMU_PMCR_LP;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
 		kvm_vcpu_pmu_restore_guest(vcpu);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6bda9b071084..846502251923 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -89,6 +89,13 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 
+/*
+ * Evaluates as true when emulating PMUv3p5, and false otherwise.
+ */
+#define kvm_pmu_is_3p5(vcpu)						\
+	(vcpu->kvm->arch.dfr0_pmuver >= ID_AA64DFR0_PMUVER_8_5 &&	\
+	 vcpu->kvm->arch.dfr0_pmuver != ID_AA64DFR0_PMUVER_IMP_DEF)
+
 u8 kvm_arm_pmu_get_host_pmuver(void);
 
 #else
@@ -153,6 +160,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 }
 
 #define kvm_vcpu_has_pmu(vcpu)		({ false; })
+#define kvm_pmu_is_3p5(vcpu)		({ false; })
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
