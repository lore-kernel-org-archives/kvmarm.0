Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2701400E
	for <kvmarm@lists.linux.dev>; Wed, 24 Sep 2025 23:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758757925; cv=none; b=PgIq7ixG/DqO+jMyn6fat5M7nl3rMVqI2uEkgauUCZahKxkJ19/s9QpNsuSG/UrkMIq9JAMRAN9FDl70L28hOTZMdaF4d1zUp8dRAiWo82a69Ltvowp7S0dOBrKI7zGJGShtfFV4kUSO5c2fXCSIVyuGGEAhWh8CHzZC/lJCJYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758757925; c=relaxed/simple;
	bh=hqvDoRE0ly0cw1VbIAj4jeXFSME1zUXr8oMWh+N1tMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTMmjmkKoK/45c0DkR/bHvydpxVgWQG4Ml3mAZyY3DCDKKFwG6BZCyVUn/Q+jjDmsVWzhmf8uj7lDD9W7Nbbf7e0znCoUe8bqXr5xpfBdGD+dq0GDR354DcsNT7BEFghLhazvi8mo4nEJ/eIgmBm87UDx82wANqfG77jIwXaPRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d2bfSA0x; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d2bfSA0x"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758757920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gWb8APsFn3QAsbd1SPovvxmqbtKMi7gf1oTNRj4Gd7s=;
	b=d2bfSA0xFkX9OnONdXV2ce22CMD3lp0SNRZER27FGkFKKHqaH8+xsDHjJNp7bR2NmsAU5I
	BEZGqzZ5AXBbCv0zV0PRZ1F9RXHKJ/RbxIL5m70Gz8svFvZZ+vaPbutPgqEogcXe5Yx2/c
	ihKobAG39JeavbdhQv3D2BHKDMHxqps=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: Compute per-vCPU FGTs at vcpu_load()
Date: Wed, 24 Sep 2025 16:51:49 -0700
Message-ID: <20250924235150.617451-2-oliver.upton@linux.dev>
In-Reply-To: <20250924235150.617451-1-oliver.upton@linux.dev>
References: <20250924235150.617451-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To date KVM has used the fine-grained traps for the sake of UNDEF
enforcement (so-called FGUs), meaning the constituent parts could be
computed on a per-VM basis and folded into the effective value when
programmed.

Prepare for traps changing based on the vCPU context by computing the
whole mess of them at vcpu_load(). Aggressively inline all the helpers
to preserve the build-time checks that were there before.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h       |  50 ++++++++
 arch/arm64/kvm/arm.c                    |   1 +
 arch/arm64/kvm/config.c                 |  82 +++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 148 +++---------------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |   1 +
 5 files changed, 151 insertions(+), 131 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8ede884f091d..fadfdac3210e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -816,6 +816,11 @@ struct kvm_vcpu_arch {
 	u64 hcrx_el2;
 	u64 mdcr_el2;
 
+	struct {
+		u64 r;
+		u64 w;
+	} fgt[__NR_FGT_GROUP_IDS__];
+
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
@@ -1599,6 +1604,51 @@ static inline bool kvm_arch_has_irq_bypass(void)
 void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
 void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
 void check_feature_map(void);
+void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu);
+
+static __always_inline enum fgt_group_id __fgt_reg_to_group_id(enum vcpu_sysreg reg)
+{
+	switch (reg) {
+	case HFGRTR_EL2:
+	case HFGWTR_EL2:
+		return HFGRTR_GROUP;
+	case HFGITR_EL2:
+		return HFGITR_GROUP;
+	case HDFGRTR_EL2:
+	case HDFGWTR_EL2:
+		return HDFGRTR_GROUP;
+	case HAFGRTR_EL2:
+		return HAFGRTR_GROUP;
+	case HFGRTR2_EL2:
+	case HFGWTR2_EL2:
+		return HFGRTR2_GROUP;
+	case HFGITR2_EL2:
+		return HFGITR2_GROUP;
+	case HDFGRTR2_EL2:
+	case HDFGWTR2_EL2:
+		return HDFGRTR2_GROUP;
+	default:
+		BUILD_BUG_ON(1);
+	}
+}
 
+#define vcpu_fgt(vcpu, reg)						\
+	({								\
+		enum fgt_group_id id = __fgt_reg_to_group_id(reg);	\
+		u64 *p;							\
+		switch (reg) {						\
+		case HFGWTR_EL2:					\
+		case HDFGWTR_EL2:					\
+		case HFGWTR2_EL2:					\
+		case HDFGWTR2_EL2:					\
+			p = &(vcpu)->arch.fgt[id].w;			\
+			break;						\
+		default:						\
+			p = &(vcpu)->arch.fgt[id].r;			\
+			break;						\
+		}							\
+									\
+		p;							\
+	})
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a59b4046617c..c74ad097a681 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -643,6 +643,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vcpu->arch.hcr_el2 |= HCR_TWI;
 
 	vcpu_set_pauth_traps(vcpu);
+	kvm_vcpu_load_fgt(vcpu);
 
 	if (is_protected_kvm_enabled()) {
 		kvm_call_hyp_nvhe(__pkvm_vcpu_load,
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index fbd8944a3dea..b1cf7660efe1 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -5,6 +5,8 @@
  */
 
 #include <linux/kvm_host.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
 #include <asm/sysreg.h>
 
 /*
@@ -1428,3 +1430,83 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
 		break;
 	}
 }
+
+static __always_inline struct fgt_masks *__fgt_reg_to_masks(enum vcpu_sysreg reg)
+{
+	switch (reg) {
+	case HFGRTR_EL2:
+		return &hfgrtr_masks;
+	case HFGWTR_EL2:
+		return &hfgwtr_masks;
+	case HFGITR_EL2:
+		return &hfgitr_masks;
+	case HDFGRTR_EL2:
+		return &hdfgrtr_masks;
+	case HDFGWTR_EL2:
+		return &hdfgwtr_masks;
+	case HAFGRTR_EL2:
+		return &hafgrtr_masks;
+	case HFGRTR2_EL2:
+		return &hfgrtr2_masks;
+	case HFGWTR2_EL2:
+		return &hfgwtr2_masks;
+	case HFGITR2_EL2:
+		return &hfgitr2_masks;
+	case HDFGRTR2_EL2:
+		return &hdfgrtr2_masks;
+	case HDFGWTR2_EL2:
+		return &hdfgwtr2_masks;
+	default:
+		BUILD_BUG_ON(1);
+	}
+}
+
+static __always_inline void __compute_fgt(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
+{
+	u64 fgu = vcpu->kvm->arch.fgu[__fgt_reg_to_group_id(reg)];
+	struct fgt_masks *m = __fgt_reg_to_masks(reg);
+	u64 clear = 0, set = 0, val = m->nmask;
+
+	set |= fgu & m->mask;
+	clear |= fgu & m->nmask;
+
+	if (is_nested_ctxt(vcpu)) {
+		u64 nested = __vcpu_sys_reg(vcpu, reg);
+		set |= nested & m->mask;
+		clear |= ~nested & m->nmask;
+	}
+
+	val |= set;
+	val &= ~clear;
+	*vcpu_fgt(vcpu, reg) = val;
+}
+
+static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HFGWTR_EL2);
+
+	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
+		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
+}
+
+void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
+{
+	if (!cpus_have_final_cap(ARM64_HAS_FGT))
+		return;
+
+	__compute_fgt(vcpu, HFGRTR_EL2);
+	__compute_hfgwtr(vcpu);
+	__compute_fgt(vcpu, HFGITR_EL2);
+	__compute_fgt(vcpu, HDFGRTR_EL2);
+	__compute_fgt(vcpu, HDFGWTR_EL2);
+	__compute_fgt(vcpu, HAFGRTR_EL2);
+
+	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
+		return;
+
+	__compute_fgt(vcpu, HFGRTR2_EL2);
+	__compute_fgt(vcpu, HFGWTR2_EL2);
+	__compute_fgt(vcpu, HFGITR2_EL2);
+	__compute_fgt(vcpu, HDFGRTR2_EL2);
+	__compute_fgt(vcpu, HDFGWTR2_EL2);
+}
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 84ec4e100fbb..3562e265134c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -195,123 +195,6 @@ static inline void __deactivate_cptr_traps(struct kvm_vcpu *vcpu)
 		__deactivate_cptr_traps_nvhe(vcpu);
 }
 
-#define reg_to_fgt_masks(reg)						\
-	({								\
-		struct fgt_masks *m;					\
-		switch(reg) {						\
-		case HFGRTR_EL2:					\
-			m = &hfgrtr_masks;				\
-			break;						\
-		case HFGWTR_EL2:					\
-			m = &hfgwtr_masks;				\
-			break;						\
-		case HFGITR_EL2:					\
-			m = &hfgitr_masks;				\
-			break;						\
-		case HDFGRTR_EL2:					\
-			m = &hdfgrtr_masks;				\
-			break;						\
-		case HDFGWTR_EL2:					\
-			m = &hdfgwtr_masks;				\
-			break;						\
-		case HAFGRTR_EL2:					\
-			m = &hafgrtr_masks;				\
-			break;						\
-		case HFGRTR2_EL2:					\
-			m = &hfgrtr2_masks;				\
-			break;						\
-		case HFGWTR2_EL2:					\
-			m = &hfgwtr2_masks;				\
-			break;						\
-		case HFGITR2_EL2:					\
-			m = &hfgitr2_masks;				\
-			break;						\
-		case HDFGRTR2_EL2:					\
-			m = &hdfgrtr2_masks;				\
-			break;						\
-		case HDFGWTR2_EL2:					\
-			m = &hdfgwtr2_masks;				\
-			break;						\
-		default:						\
-			BUILD_BUG_ON(1);				\
-		}							\
-									\
-		m;							\
-	})
-
-#define compute_clr_set(vcpu, reg, clr, set)				\
-	do {								\
-		u64 hfg = __vcpu_sys_reg(vcpu, reg);			\
-		struct fgt_masks *m = reg_to_fgt_masks(reg);		\
-		set |= hfg & m->mask;					\
-		clr |= ~hfg & m->nmask;					\
-	} while(0)
-
-#define reg_to_fgt_group_id(reg)					\
-	({								\
-		enum fgt_group_id id;					\
-		switch(reg) {						\
-		case HFGRTR_EL2:					\
-		case HFGWTR_EL2:					\
-			id = HFGRTR_GROUP;				\
-			break;						\
-		case HFGITR_EL2:					\
-			id = HFGITR_GROUP;				\
-			break;						\
-		case HDFGRTR_EL2:					\
-		case HDFGWTR_EL2:					\
-			id = HDFGRTR_GROUP;				\
-			break;						\
-		case HAFGRTR_EL2:					\
-			id = HAFGRTR_GROUP;				\
-			break;						\
-		case HFGRTR2_EL2:					\
-		case HFGWTR2_EL2:					\
-			id = HFGRTR2_GROUP;				\
-			break;						\
-		case HFGITR2_EL2:					\
-			id = HFGITR2_GROUP;				\
-			break;						\
-		case HDFGRTR2_EL2:					\
-		case HDFGWTR2_EL2:					\
-			id = HDFGRTR2_GROUP;				\
-			break;						\
-		default:						\
-			BUILD_BUG_ON(1);				\
-		}							\
-									\
-		id;							\
-	})
-
-#define compute_undef_clr_set(vcpu, kvm, reg, clr, set)			\
-	do {								\
-		u64 hfg = kvm->arch.fgu[reg_to_fgt_group_id(reg)];	\
-		struct fgt_masks *m = reg_to_fgt_masks(reg);		\
-		set |= hfg & m->mask;					\
-		clr |= hfg & m->nmask;					\
-	} while(0)
-
-#define update_fgt_traps_cs(hctxt, vcpu, kvm, reg, clr, set)		\
-	do {								\
-		struct fgt_masks *m = reg_to_fgt_masks(reg);		\
-		u64 c = clr, s = set;					\
-		u64 val;						\
-									\
-		ctxt_sys_reg(hctxt, reg) = read_sysreg_s(SYS_ ## reg);	\
-		if (is_nested_ctxt(vcpu))				\
-			compute_clr_set(vcpu, reg, c, s);		\
-									\
-		compute_undef_clr_set(vcpu, kvm, reg, c, s);		\
-									\
-		val = m->nmask;						\
-		val |= s;						\
-		val &= ~c;						\
-		write_sysreg_s(val, SYS_ ## reg);			\
-	} while(0)
-
-#define update_fgt_traps(hctxt, vcpu, kvm, reg)		\
-	update_fgt_traps_cs(hctxt, vcpu, kvm, reg, 0, 0)
-
 static inline bool cpu_has_amu(void)
 {
        u64 pfr0 = read_sysreg_s(SYS_ID_AA64PFR0_EL1);
@@ -320,33 +203,36 @@ static inline bool cpu_has_amu(void)
                ID_AA64PFR0_EL1_AMU_SHIFT);
 }
 
+#define __activate_fgt(hctxt, vcpu, reg)				\
+	do {								\
+		ctxt_sys_reg(hctxt, reg) = read_sysreg_s(SYS_ ## reg);	\
+		write_sysreg_s(*vcpu_fgt(vcpu, reg), SYS_ ## reg);	\
+	} while (0)
+
 static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
 
-	update_fgt_traps(hctxt, vcpu, kvm, HFGRTR_EL2);
-	update_fgt_traps_cs(hctxt, vcpu, kvm, HFGWTR_EL2, 0,
-			    cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38) ?
-			    HFGWTR_EL2_TCR_EL1_MASK : 0);
-	update_fgt_traps(hctxt, vcpu, kvm, HFGITR_EL2);
-	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR_EL2);
-	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR_EL2);
+	__activate_fgt(hctxt, vcpu, HFGRTR_EL2);
+	__activate_fgt(hctxt, vcpu, HFGWTR_EL2);
+	__activate_fgt(hctxt, vcpu, HFGITR_EL2);
+	__activate_fgt(hctxt, vcpu, HDFGRTR_EL2);
+	__activate_fgt(hctxt, vcpu, HDFGWTR_EL2);
 
 	if (cpu_has_amu())
-		update_fgt_traps(hctxt, vcpu, kvm, HAFGRTR_EL2);
+		__activate_fgt(hctxt, vcpu, HAFGRTR_EL2);
 
 	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
 	    return;
 
-	update_fgt_traps(hctxt, vcpu, kvm, HFGRTR2_EL2);
-	update_fgt_traps(hctxt, vcpu, kvm, HFGWTR2_EL2);
-	update_fgt_traps(hctxt, vcpu, kvm, HFGITR2_EL2);
-	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR2_EL2);
-	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR2_EL2);
+	__activate_fgt(hctxt, vcpu, HFGRTR2_EL2);
+	__activate_fgt(hctxt, vcpu, HFGWTR2_EL2);
+	__activate_fgt(hctxt, vcpu, HFGITR2_EL2);
+	__activate_fgt(hctxt, vcpu, HDFGRTR2_EL2);
+	__activate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
 
 #define __deactivate_fgt(htcxt, vcpu, reg)				\
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 05774aed09cb..43bde061b65d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -172,6 +172,7 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 		/* Trust the host for non-protected vcpu features. */
 		vcpu->arch.hcrx_el2 = host_vcpu->arch.hcrx_el2;
+		memcpy(vcpu->arch.fgt, host_vcpu->arch.fgt, sizeof(vcpu->arch.fgt));
 		return 0;
 	}
 
-- 
2.47.3

