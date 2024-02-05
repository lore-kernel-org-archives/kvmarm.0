Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE2E1755E
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129287; cv=none; b=OP8yNcxG91rGHZsecK7zRS9VWQ39atw5jQEUdjUJsdr3ZcolPQ94AKPb9sfZGwE4/WH96m4yk0uzj9gB/duxJGEsHu5H7/VHBByPCeHeToAgsjIicjB1S1dEEzXld0Hj3iVg1lyS7gqummqFG9+JJkJrYGyYORQfwhzUJDtMTRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129287; c=relaxed/simple;
	bh=zAn9W2FF0W8qabLuUpsfbfwMJlihGUj+bnHo/MG53YE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BWFJ+nRPjdaLbzTwtG7AhCL4/LafQpCS7GjrXVRsS4MWMTm0hr+7PF9MEbUDp5Uyo00RqwX8BuLBC/swqfYCZTssqVE8GI0y0M0sdheTrH8AvvSVsP3OScXr7Q56nvuCB9vj2Mc/Y0bTsTuj+FZvv1PMVspQQEJradst24kUowQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TXMM+Doz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TXMM+Doz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E01C43390;
	Mon,  5 Feb 2024 10:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129287;
	bh=zAn9W2FF0W8qabLuUpsfbfwMJlihGUj+bnHo/MG53YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXMM+DozRtKip5UOZcFoc1qfWK9Y48w60wpLkT7OcxSlA0u8zSsSR9ytT8ZBODMf2
	 M38BaWi9GSDHXCFa/VY1u4EHbx6sZnAdH1zplE6/gDMw132JwMsnsQAqyD66s5N0b4
	 GJvjFEB+hYWqEszVCYf869csqHJkbc9ohCKRA1zYrAB9P45OJm9r++n1yvPxwqq2vC
	 23osD3Ksz3i5fsSFm3c2IuWxEksiDlybYdAxlPO8GCJATNlsh8VaOmMsflQbL4uh30
	 uz12MAFD3y1MDRhuWk2ZATbjo1j/kIcn+LYHdvBMbe/I/wQqE69JocKDdVM5mXpy+3
	 +yDmttVd0qkvQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJJ-000Nc3-9i;
	Mon, 05 Feb 2024 10:34:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 02/26] KVM: arm64: Add feature checking helpers
Date: Mon,  5 Feb 2024 10:34:07 +0000
Message-Id: <20240205103431.1104133-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to make it easier to check whether a particular feature
is exposed to a guest, add a new set of helpers, with kvm_has_feat()
being the most useful.

Let's start making use of them in the PMU code (courtesy of Oliver).
Follow-up changes will introduce additional use patterns.

Co-developed--by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 44 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu-emul.c         | 11 ++++----
 arch/arm64/kvm/sys_regs.c         |  6 ++---
 include/kvm/arm_pmu.h             | 11 --------
 4 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21c57b812569..527da3d2cedb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1233,4 +1233,48 @@ static inline void kvm_hyp_reserve(void) { }
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
+#define __expand_field_sign_unsigned(id, fld, val)			\
+	((u64)SYS_FIELD_VALUE(id, fld, val))
+
+#define __expand_field_sign_signed(id, fld, val)			\
+	({								\
+		u64 __val = SYS_FIELD_VALUE(id, fld, val);		\
+		sign_extend64(__val, id##_##fld##_WIDTH - 1);		\
+	})
+
+#define expand_field_sign(id, fld, val)					\
+	(id##_##fld##_SIGNED ?						\
+	 __expand_field_sign_signed(id, fld, val) :			\
+	 __expand_field_sign_unsigned(id, fld, val))
+
+#define get_idreg_field_unsigned(kvm, id, fld)				\
+	({								\
+		u64 __val = IDREG((kvm), SYS_##id);			\
+		FIELD_GET(id##_##fld##_MASK, __val);			\
+	})
+
+#define get_idreg_field_signed(kvm, id, fld)				\
+	({								\
+		u64 __val = get_idreg_field_unsigned(kvm, id, fld);	\
+		sign_extend64(__val, id##_##fld##_WIDTH - 1);		\
+	})
+
+#define get_idreg_field_enum(kvm, id, fld)				\
+	get_idreg_field_unsigned(kvm, id, fld)
+
+#define get_idreg_field(kvm, id, fld)					\
+	(id##_##fld##_SIGNED ?						\
+	 get_idreg_field_signed(kvm, id, fld) :				\
+	 get_idreg_field_unsigned(kvm, id, fld))
+
+#define kvm_has_feat(kvm, id, fld, limit)				\
+	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, limit))
+
+#define kvm_has_feat_enum(kvm, id, fld, val)				\
+	(get_idreg_field_unsigned((kvm), id, fld) == __expand_field_sign_unsigned(id, fld, val))
+
+#define kvm_has_feat_range(kvm, id, fld, min, max)			\
+	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, min) && \
+	 get_idreg_field((kvm), id, fld) <= expand_field_sign(id, fld, max))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3d9467ff73bc..925522470b2b 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -64,12 +64,11 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
 {
 	u64 mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
 		   kvm_pmu_event_mask(kvm);
-	u64 pfr0 = IDREG(kvm, SYS_ID_AA64PFR0_EL1);
 
-	if (SYS_FIELD_GET(ID_AA64PFR0_EL1, EL2, pfr0))
+	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL2, IMP))
 		mask |= ARMV8_PMU_INCLUDE_EL2;
 
-	if (SYS_FIELD_GET(ID_AA64PFR0_EL1, EL3, pfr0))
+	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL3, IMP))
 		mask |= ARMV8_PMU_EXCLUDE_NS_EL0 |
 			ARMV8_PMU_EXCLUDE_NS_EL1 |
 			ARMV8_PMU_EXCLUDE_EL3;
@@ -83,8 +82,10 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
  */
 static bool kvm_pmc_is_64bit(struct kvm_pmc *pmc)
 {
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+
 	return (pmc->idx == ARMV8_PMU_CYCLE_IDX ||
-		kvm_pmu_is_3p5(kvm_pmc_to_vcpu(pmc)));
+		kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5));
 }
 
 static bool kvm_pmc_has_64bit_overflow(struct kvm_pmc *pmc)
@@ -556,7 +557,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		return;
 
 	/* Fixup PMCR_EL0 to reconcile the PMU version and the LP bit */
-	if (!kvm_pmu_is_3p5(vcpu))
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
 	/* The reset bits don't indicate any state, and shouldn't be saved. */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 041b11825578..3c31f8cb9eef 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -505,10 +505,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, LO, IMP)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
@@ -2748,8 +2747,7 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 		return ignore_write(vcpu, p);
 	} else {
 		u64 dfr = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
-		u64 pfr = IDREG(vcpu->kvm, SYS_ID_AA64PFR0_EL1);
-		u32 el3 = !!SYS_FIELD_GET(ID_AA64PFR0_EL1, EL3, pfr);
+		u32 el3 = kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, EL3, IMP);
 
 		p->regval = ((SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr) << 28) |
 			     (SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr) << 24) |
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 4b9d8fb393a8..eb4c369a79eb 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -90,16 +90,6 @@ void kvm_vcpu_pmu_resync_el0(void);
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 
-/*
- * Evaluates as true when emulating PMUv3p5, and false otherwise.
- */
-#define kvm_pmu_is_3p5(vcpu) ({						\
-	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);		\
-	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);	\
-									\
-	pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P5;				\
-})
-
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 u64 kvm_pmu_evtyper_mask(struct kvm *kvm);
 int kvm_arm_set_default_pmu(struct kvm *kvm);
@@ -168,7 +158,6 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 }
 
 #define kvm_vcpu_has_pmu(vcpu)		({ false; })
-#define kvm_pmu_is_3p5(vcpu)		({ false; })
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
-- 
2.39.2

