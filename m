Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85736C43219
	for <kvmarm@archiver.kernel.org>; Sun, 13 Nov 2022 16:46:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3086F4B91B;
	Sun, 13 Nov 2022 11:46:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LlBA5aElxxOn; Sun, 13 Nov 2022 11:46:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC9DA4B936;
	Sun, 13 Nov 2022 11:46:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADB224B921
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Nov 2022 11:46:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OM8JzCriqio3 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Nov 2022 11:46:37 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AA6F4B8EB
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Nov 2022 11:46:37 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2229960B3F;
 Sun, 13 Nov 2022 16:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADD5C433D7;
 Sun, 13 Nov 2022 16:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668357996;
 bh=kKl2XC0PDXMcd2Ng8cFD+2p598EXWOG4M9MrPEmgdqY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Vx3Oht6rgBDvY7PBSHFA7++0gIETJYj3eKqSlZOX08wvhDqNTaHSM4rOy/n3zcp0j
 X4mca+wK42FbAjBeBKNMopQjL6bm9YQJJSpCOk/P4Uouvvr8LaXa3g3wGukXIAfWVC
 5VMe4/q0yq3AFSsfnn1gIz5OPXaC6lPoh5a+e9Y7dB5NQF25LN+GlK5ZM52Iy0VGSB
 WqbBeECQ9gH3TiHG0XBOykLrHV/C0cgn35plGQwMBXzBTrmYgJBEmcWj1x4BqFKx8z
 9ptDvWxiMYB0U5UMzpwwLQeX4oBOZJ5t5QQS0EQQ0hiZo1N6AGDhPIkzCuIfKsDrhu
 WU2FZ9kYVkIxA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ouG0Q-005oYZ-Fy;
 Sun, 13 Nov 2022 16:38:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, <kvmarm@lists.cs.columbia.edu>,
 <kvmarm@lists.linux.dev>, kvm@vger.kernel.org
Subject: [PATCH v4 13/16] KVM: arm64: PMU: Implement PMUv3p5 long counter
 support
Date: Sun, 13 Nov 2022 16:38:29 +0000
Message-Id: <20221113163832.3154370-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221113163832.3154370-1-maz@kernel.org>
References: <20221113163832.3154370-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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
 include/kvm/arm_pmu.h     | 7 +++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 4320c389fa7f..c37cc67ff1d7 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -52,13 +52,15 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
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
index dc201a0557c0..615cb148e22a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -654,6 +654,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
 	if (!kvm_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
+	if (!kvm_pmu_is_3p5(vcpu))
+		val &= ~ARMV8_PMU_PMCR_LP;
 	__vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
@@ -703,6 +705,8 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
+		if (!kvm_pmu_is_3p5(vcpu))
+			val &= ~ARMV8_PMU_PMCR_LP;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
 		kvm_vcpu_pmu_restore_guest(vcpu);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 812f729c9108..628775334d5e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -89,6 +89,12 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 
+/*
+ * Evaluates as true when emulating PMUv3p5, and false otherwise.
+ */
+#define kvm_pmu_is_3p5(vcpu)						\
+	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
 #else
@@ -153,6 +159,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
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
