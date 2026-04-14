Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0CACA6B
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 00:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776125052; cv=none; b=oxtU84eZxYHdvKca6Gg+WzBwP18RBA7+2k5Ft+MH36jtt6QglK3jvUSFWfeWwshVjmpM8iwDu3mvTU8NInPCL4qz1Mc8br5ZtXvRCQexiopv6H9vqSjWO+BBLn21vL1A0VDaw84HJx2Pfa+iwH9aot1SDAJsPHc34kYRsPSZZRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776125052; c=relaxed/simple;
	bh=tZ2tAOa25uPuSCYx8KzsvxrVL7umOXNLkyBbeZjsolY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0vKDOBtrgqiEIZhHxLyKItmWh6OzEWrq2jfPvTI5fqJtI6K2XZV0bswSSbpibDYoY4PhY5VEWI5cBWpOc9L4kxh5ac1PUmdHiYtdE5URDLIqDf1bO6KFZcj03bdgvrYJcxr67XbRNKnKZTnIVd+DueOAq77V5JTjdXpNCUbpJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CzH/Jwqr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CzH/Jwqr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D495B4E26;
	Mon, 13 Apr 2026 17:04:01 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC1D23F7B4;
	Mon, 13 Apr 2026 17:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776125047; bh=tZ2tAOa25uPuSCYx8KzsvxrVL7umOXNLkyBbeZjsolY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CzH/JwqrxJ4V08fqKMdmzq1KRDmQ1m1VsMU1a/HWqfnLm1O3fSUtC/h2z8hu9ZwCM
	 E3jW6NuHMwU/T40+kSmaGu+7S4GYuG1dlaLWTsrfOkj8ybkS+c8rKPgWhlAWyrEwhl
	 D6K4Qw4vh+tNDuSI95tD+Uv+kUT/OB+vZ3GUf6mw=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 4/4] KVM: arm64: Fallback to a supported value for unsupported guest TGx
Date: Tue, 14 Apr 2026 01:03:34 +0100
Message-ID: <20260414000334.3947257-5-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414000334.3947257-1-weilin.chang@arm.com>
References: <20260414000334.3947257-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When KVM derives the translation granule for emulated stage-1 and
stage-2 walks, it decodes TCR/VTCR.TGx and treats the granule as-is.
This is wrong when the guest programs a granule size that is not
advertised in the guest's ID_AA64MMFR0_EL1.TGRAN* fields.
Architecturally, such a value must be treated as an implemented granule
size. Choose an available one while prioritizing PAGE_SIZE.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/at.c     | 52 +++++++++++++++++++++-
 arch/arm64/kvm/nested.c | 98 +++++++++++++++++++++++++++++------------
 2 files changed, 121 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 927226266081..702ce531afd5 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -135,6 +135,30 @@ static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
 	wi->e0poe = (wi->regime != TR_EL2) && (val & TCR2_EL1_E0POE);
 }
 
+#define _has_tgran(__r, __sz)					\
+	({							\
+		u64 _s1, _mmfr0 = __r;				\
+								\
+		_s1 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,		\
+				    TGRAN##__sz, _mmfr0);	\
+								\
+		_s1 != ID_AA64MMFR0_EL1_TGRAN##__sz##_NI;	\
+	})
+
+static bool has_tgran(u64 mmfr0, unsigned int shift)
+{
+	switch (shift) {
+	case 12:
+		return _has_tgran(mmfr0, 4);
+	case 14:
+		return _has_tgran(mmfr0, 16);
+	case 16:
+		return _has_tgran(mmfr0, 64);
+	default:
+		BUG();
+	}
+}
+
 static unsigned int tcr_to_tg0_pgshift(u64 tcr)
 {
 	u64 tg0 = tcr & TCR_TG0_MASK;
@@ -165,8 +189,23 @@ static unsigned int tcr_to_tg1_pgshift(u64 tcr)
 	}
 }
 
-static unsigned int tcr_tg_pgshift(u64 tcr, bool upper_range)
+static unsigned int fallback_tgran_shift(u64 mmfr0)
+{
+	if (has_tgran(mmfr0, PAGE_SHIFT))
+		return PAGE_SHIFT;
+	else if (has_tgran(mmfr0, 12))
+		return 12;
+	else if (has_tgran(mmfr0, 14))
+		return 14;
+	else if (has_tgran(mmfr0, 16))
+		return 16;
+	else
+		return PAGE_SHIFT;
+}
+
+static unsigned int tcr_tg_pgshift(struct kvm *kvm, u64 tcr, bool upper_range)
 {
+	u64 mmfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1);
 	unsigned int shift;
 
 	/* Someone was silly enough to encode TG0/TG1 differently */
@@ -175,6 +214,15 @@ static unsigned int tcr_tg_pgshift(u64 tcr, bool upper_range)
 	else
 		shift = tcr_to_tg0_pgshift(tcr);
 
+	/*
+	 * If TGx is programmed to an unimplemented value (not advertised in
+	 * ID_AA64MMFR0_EL1), we should treat it as if an implemented value is
+	 * written, as per the architecture. Choose an available one while
+	 * prioritizing PAGE_SIZE.
+	 */
+	if (!has_tgran(mmfr0, shift))
+		return fallback_tgran_shift(mmfr0);
+
 	return shift;
 }
 
@@ -222,7 +270,7 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	else
 		wi->txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
 
-	wi->pgshift = tcr_tg_pgshift(tcr, upper_range);
+	wi->pgshift = tcr_tg_pgshift(vcpu->kvm, tcr, upper_range);
 	wi->pa52bit = has_52bit_pa(vcpu, wi, tcr);
 
 	ia_bits = get_ia_size(wi);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index a732d7b0bd5d..327a6aaa45db 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -378,25 +378,83 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	return 0;
 }
 
+#define _has_tgran_2(__r, __sz)						\
+	({								\
+		u64 _s1, _s2, _mmfr0 = __r;				\
+									\
+		_s2 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
+				    TGRAN##__sz##_2, _mmfr0);		\
+									\
+		_s1 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
+				    TGRAN##__sz, _mmfr0);		\
+									\
+		((_s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_NI &&		\
+		  _s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz) || \
+		 (_s2 == ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz && \
+		  _s1 != ID_AA64MMFR0_EL1_TGRAN##__sz##_NI));		\
+	})
+
+static bool has_tgran_2(u64 mmfr0, unsigned int shift)
+{
+	switch (shift) {
+	case 12:
+		return _has_tgran_2(mmfr0, 4);
+	case 14:
+		return _has_tgran_2(mmfr0, 16);
+	case 16:
+		return _has_tgran_2(mmfr0, 64);
+	default:
+		BUG();
+	}
+}
+
+static unsigned int fallback_tgran2_shift(u64 mmfr0)
+{
+	if (has_tgran_2(mmfr0, PAGE_SHIFT))
+		return PAGE_SHIFT;
+	else if (has_tgran_2(mmfr0, 12))
+		return 12;
+	else if (has_tgran_2(mmfr0, 14))
+		return 14;
+	else if (has_tgran_2(mmfr0, 16))
+		return 16;
+	else
+		return PAGE_SHIFT;
+}
 
-static unsigned int vtcr_to_tg0_pgshift(u64 vtcr)
+static unsigned int vtcr_to_tg0_pgshift(struct kvm *kvm, u64 vtcr)
 {
 	u64 tg0 = FIELD_GET(VTCR_EL2_TG0_MASK, vtcr);
+	u64 mmfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1);
+	unsigned int shift;
 
 	switch (tg0) {
 	case VTCR_EL2_TG0_4K:
-		return 12;
+		shift = 12;
+		break;
 	case VTCR_EL2_TG0_16K:
-		return 14;
+		shift = 14;
+		break;
 	case VTCR_EL2_TG0_64K:
 	default:	/* IMPDEF: treat any other value as 64k */
-		return 16;
+		shift = 16;
 	}
+
+	/*
+	 * If TGx is programmed to an unimplemented value (not advertised in
+	 * ID_AA64MMFR0_EL1), we should treat it as if an implemented value is
+	 * written, as per the architecture. Choose an available one while
+	 * prioritizing PAGE_SIZE.
+	 */
+	if (!has_tgran_2(mmfr0, shift))
+		return fallback_tgran2_shift(mmfr0);
+
+	return shift;
 }
 
-static size_t vtcr_to_tg0_pgsize(u64 vtcr)
+static size_t vtcr_to_tg0_pgsize(struct kvm *kvm, u64 vtcr)
 {
-	return BIT(vtcr_to_tg0_pgshift(vtcr));
+	return BIT(vtcr_to_tg0_pgshift(kvm, vtcr));
 }
 
 static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
@@ -405,7 +463,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
 
 	wi->baddr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 	wi->t0sz = vtcr & VTCR_EL2_T0SZ_MASK;
-	wi->pgshift = vtcr_to_tg0_pgshift(vtcr);
+	wi->pgshift = vtcr_to_tg0_pgshift(vcpu->kvm, vtcr);
 	wi->sl = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	/* Global limit for now, should eventually be per-VM */
 	wi->max_oa_bits = min(get_kvm_ipa_limit(),
@@ -524,7 +582,8 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
 	u64 tmp, sz = 0;
 	kvm_pte_t pte;
 	u8 ttl, level;
-	size_t tg0_size = vtcr_to_tg0_pgsize(mmu->tlb_vtcr);
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	size_t tg0_size = vtcr_to_tg0_pgsize(kvm, mmu->tlb_vtcr);
 
 	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
 
@@ -608,7 +667,7 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 
 	if (!max_size) {
 		/* Compute the maximum extent of the invalidation */
-		switch (vtcr_to_tg0_pgsize(mmu->tlb_vtcr)) {
+		switch (vtcr_to_tg0_pgsize(kvm, mmu->tlb_vtcr)) {
 		case SZ_4K:
 			max_size = SZ_1G;
 			break;
@@ -1504,21 +1563,6 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
 	}
 }
 
-#define has_tgran_2(__r, __sz)						\
-	({								\
-		u64 _s1, _s2, _mmfr0 = __r;				\
-									\
-		_s2 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
-				    TGRAN##__sz##_2, _mmfr0);		\
-									\
-		_s1 = SYS_FIELD_GET(ID_AA64MMFR0_EL1,			\
-				    TGRAN##__sz, _mmfr0);		\
-									\
-		((_s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_NI &&		\
-		  _s2 != ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz) || \
-		 (_s2 == ID_AA64MMFR0_EL1_TGRAN##__sz##_2_TGRAN##__sz && \
-		  _s1 != ID_AA64MMFR0_EL1_TGRAN##__sz##_NI));		\
-	})
 /*
  * Our emulated CPU doesn't support all the possible features. For the
  * sake of simplicity (and probably mental sanity), wipe out a number
@@ -1600,15 +1644,15 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		 */
 		switch (PAGE_SIZE) {
 		case SZ_4K:
-			if (has_tgran_2(orig_val, 4))
+			if (_has_tgran_2(orig_val, 4))
 				val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4_2, IMP);
 			fallthrough;
 		case SZ_16K:
-			if (has_tgran_2(orig_val, 16))
+			if (_has_tgran_2(orig_val, 16))
 				val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16_2, IMP);
 			fallthrough;
 		case SZ_64K:
-			if (has_tgran_2(orig_val, 64))
+			if (_has_tgran_2(orig_val, 64))
 				val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN64_2, IMP);
 			break;
 		}
-- 
2.43.0

