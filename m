Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA918351FC0
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972452; cv=none; b=ll7bz5yALOmJGY3sIAAB1YdXo47JHtjyulDNCpABXCLFQjfphH5RbtQ8egF+1aTqNiI2rnQyrCDBRum1vfvTl+63M31E7J8z6npL1Z4dx0UXstzojicMS8jnr5aEdLh9ybJE3s8cyf1bv2IPULIHRX5Dv1+V+n7UeDYCStVEnzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972452; c=relaxed/simple;
	bh=WnKrJVZ49IHXqTfxjuDkPKIq6P0Svx08uk5zUAu4a6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sd6oC0lVV47qwKmzMiu5zao9cFyI8r925x0DBBGMSfLE9H8TqPJgRvksK3H0+BwCAQHBDC3o9w2+wmkk8kJStDn6W5mAkWaKlylxbyEfzaqH+j5JfndZxiNAFqaxK8RuSxjamSrQaY5uFy+75Ub8W04BJL13lo/z4WG/94HAjlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enCrD49X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enCrD49X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8504AC19422;
	Wed, 12 Nov 2025 18:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972452;
	bh=WnKrJVZ49IHXqTfxjuDkPKIq6P0Svx08uk5zUAu4a6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enCrD49XKiKU2+DyiDWcdHBbrp1b1hIhpNQRCd10KKRXxRi/xTFKAGIqvFyBNzR+j
	 /ruZ0Ds1h3MHH8tKutlpO3gieaCmu8onEuirlPfT+1B12932ZUwTDiTIl1MtX7HR5M
	 RYj52rqinA/hqBCTdvBsejQHhWBVRsO4Ug6K3U0I5Qwthp42tr9dYSURlQXIzCuTMY
	 cmjMM7EjyhT35lOVlEv/uokfWTPb07BoUB1RO1wGXGtsbecHBliuC57HrPLGXTsiLw
	 9Ym0ZJT//AMwCx/yinAcbxeCaurnfBkMZcMX2gwYY65XtRwX2u/vKSgkRKn2KyXDsx
	 earKow0fJzDPg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 10/12] KVM: arm64: Implement HW access flag management in stage-1 SW PTW
Date: Wed, 12 Nov 2025 10:34:04 -0800
Message-ID: <20251112183406.2118981-11-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112183406.2118981-1-oupton@kernel.org>
References: <20251112183406.2118981-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Atomically update the Access flag at stage-1 when the guest has
configured the MMU to do so. Make the implementation choice (and liberal
interpretation of speculation) that any access type updates the Access
flag, including AT and CMO instructions.

Restart the entire walk by returning to the exception-generating
instruction in the case of a failed Access flag update.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h    |  6 +--
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/at.c                 | 74 +++++++++++++++++++++++------
 arch/arm64/kvm/sys_regs.c           |  9 ++--
 4 files changed, 69 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9da54d4ee49e..090f7b740bdc 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -246,9 +246,9 @@ extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 extern int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
-extern void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
-extern void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
-extern void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern int __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 6dbc2908aed9..905c658057a4 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -353,6 +353,7 @@ struct s1_walk_info {
 	bool	     		be;
 	bool	     		s2;
 	bool			pa52bit;
+	bool			ha;
 };
 
 struct s1_walk_result {
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 74f3be46fa66..9778a4241c19 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -346,6 +346,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	wi->baddr &= GENMASK_ULL(wi->max_oa_bits - 1, x);
 
+	wi->ha = tcr & TCR_HA;
+
 	return 0;
 
 addrsz:
@@ -380,10 +382,24 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
 	return 0;
 }
 
+static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
+			    struct s1_walk_info *wi)
+{
+	if (wi->be) {
+		old = cpu_to_be64(old);
+		new = cpu_to_be64(new);
+	} else {
+		old = cpu_to_be64(old);
+		new = cpu_to_be64(new);
+	}
+
+	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
+}
+
 static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		   struct s1_walk_result *wr, u64 va)
 {
-	u64 va_top, va_bottom, baddr, desc;
+	u64 va_top, va_bottom, baddr, desc, new_desc, ipa;
 	int level, stride, ret;
 
 	level = wi->sl;
@@ -393,7 +409,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	va_top = get_ia_size(wi) - 1;
 
 	while (1) {
-		u64 index, ipa;
+		u64 index;
 
 		va_bottom = (3 - level) * stride + wi->pgshift;
 		index = (va & GENMASK_ULL(va_top, va_bottom)) >> (va_bottom - 3);
@@ -490,6 +506,17 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (check_output_size(baddr & GENMASK(52, va_bottom), wi))
 		goto addrsz;
 
+	if (wi->ha)
+		new_desc |= PTE_AF;
+
+	if (new_desc != desc) {
+		ret = kvm_swap_s1_desc(vcpu, ipa, desc, new_desc, wi);
+		if (ret)
+			return ret;
+
+		desc = new_desc;
+	}
+
 	if (!(desc & PTE_AF)) {
 		fail_s1_walk(wr, ESR_ELx_FSC_ACCESS_L(level), false);
 		return -EACCES;
@@ -1234,7 +1261,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 	wr->pr &= !pan;
 }
 
-static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
 {
 	struct s1_walk_result wr = {};
 	struct s1_walk_info wi = {};
@@ -1259,6 +1286,11 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
+	/*
+	 * Race to update a descriptor -- restart the walk.
+	 */
+	if (ret == -EAGAIN)
+		return ret;
 	if (ret)
 		goto compute_par;
 
@@ -1292,7 +1324,8 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		fail_s1_walk(&wr, ESR_ELx_FSC_PERM_L(wr.level), false);
 
 compute_par:
-	return compute_par_s1(vcpu, &wi, &wr);
+	*par = compute_par_s1(vcpu, &wi, &wr);
+	return 0;
 }
 
 /*
@@ -1420,9 +1453,10 @@ static bool par_check_s1_access_fault(u64 par)
 		 !(par & SYS_PAR_EL1_S));
 }
 
-void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+int __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	u64 par = __kvm_at_s1e01_fast(vcpu, op, vaddr);
+	int ret;
 
 	/*
 	 * If PAR_EL1 reports that AT failed on a S1 permission or access
@@ -1434,15 +1468,20 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	 */
 	if ((par & SYS_PAR_EL1_F) &&
 	    !par_check_s1_perm_fault(par) &&
-	    !par_check_s1_access_fault(par))
-		par = handle_at_slow(vcpu, op, vaddr);
+	    !par_check_s1_access_fault(par)) {
+		ret = handle_at_slow(vcpu, op, vaddr, &par);
+		if (ret)
+			return ret;
+	}
 
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+	return 0;
 }
 
-void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	u64 par;
+	int ret;
 
 	/*
 	 * We've trapped, so everything is live on the CPU. As we will be
@@ -1489,13 +1528,17 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	}
 
 	/* We failed the translation, let's replay it in slow motion */
-	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
-		par = handle_at_slow(vcpu, op, vaddr);
+	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par)) {
+		ret = handle_at_slow(vcpu, op, vaddr, &par);
+		if (ret)
+			return ret;
+	}
 
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+	return 0;
 }
 
-void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	struct kvm_s2_trans out = {};
 	u64 ipa, par;
@@ -1522,13 +1565,13 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		return;
+		return 0;
 	}
 
 	__kvm_at_s1e01(vcpu, op, vaddr);
 	par = vcpu_read_sys_reg(vcpu, PAR_EL1);
 	if (par & SYS_PAR_EL1_F)
-		return;
+		return 0;
 
 	/*
 	 * If we only have a single stage of translation (EL2&0), exit
@@ -1536,14 +1579,14 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	 */
 	if (compute_translation_regime(vcpu, op) == TR_EL20 ||
 	    !(vcpu_read_sys_reg(vcpu, HCR_EL2) & (HCR_VM | HCR_DC)))
-		return;
+		return 0;
 
 	/* Do the stage-2 translation */
 	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
 	out.esr = 0;
 	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
 	if (ret < 0)
-		return;
+		return ret;
 
 	/* Check the access permission */
 	if (!out.esr &&
@@ -1552,6 +1595,7 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	par = compute_par_s12(vcpu, par, &out);
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+	return 0;
 }
 
 /*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e67eb39ddc11..61830eb3607c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3767,7 +3767,8 @@ static bool handle_at_s1e01(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u32 op = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 
-	__kvm_at_s1e01(vcpu, op, p->regval);
+	if (__kvm_at_s1e01(vcpu, op, p->regval))
+		return false;
 
 	return true;
 }
@@ -3784,7 +3785,8 @@ static bool handle_at_s1e2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return false;
 	}
 
-	__kvm_at_s1e2(vcpu, op, p->regval);
+	if (__kvm_at_s1e2(vcpu, op, p->regval))
+		return false;
 
 	return true;
 }
@@ -3794,7 +3796,8 @@ static bool handle_at_s12(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u32 op = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 
-	__kvm_at_s12(vcpu, op, p->regval);
+	if (__kvm_at_s12(vcpu, op, p->regval))
+		return false;
 
 	return true;
 }
-- 
2.47.3

