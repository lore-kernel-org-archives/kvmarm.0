Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A783738D3F3
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240128; cv=none; b=GL6zYYmRJdLju879u+/v6SSq6mgnDa4OgglM/gevIG/rCRxGv2rao88uYm48x+cWDwmFwf/Rtj0/Qrdg+ztR4f1zApMiE+ai/B7/J33/8ML1N5yRjil9Sg73AmOoXWW+UyVY/ghkyq6wDGn5uMA/bOkXdU08Xn9Qz409vSNNXbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240128; c=relaxed/simple;
	bh=iJd2Il8tQu9S0EoamdUM0HHGjHeSj7A2SmDD0UJApbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNmh9E0NpdS88YakbUFylsle+futk2mEuiWrs08q0qhXPWgOAz5KxfQT3J2frxDlfhvK86adNByVfAty5bDlpFrA0GHCCpDrfuTAHKxO5OdBEruY5yVbAw8jeKSzLp2PxITKbDKgsTvMy6G3KGDIziSTo0xNudFFTedzf9AnQ3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXdP1F2A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXdP1F2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7900A1F00A3D;
	Tue, 23 Jun 2026 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240127;
	bh=N7olPhl77CeC7BNb6XgBexyBk3u6+eHAaHAgDUjQtaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXdP1F2AGLD9JODWR4WwpbOZ9QEpGemMSlVAjzodpLc3px5paz7GmYQ7a0BoFuMgG
	 Y/IzKtcoRGLjjN64qzz1/uEb6IjZ1arxxUnbyCM1PHTqfTKdQSmMJ2nN/9EWrvZZo7
	 JL1ms6uofm0qJyPTz0YnXdkvjFRBJFBrVwmXt9gf7FNCnSFwoDsoNPwMC+qpfjoiFy
	 v8TX3sYk1xOiWrtUovgP1mupmlmpUWybBwyUkbeBBAleHkFcI7TiaGxqpiwoJlQ3vL
	 QBcrqF2T6bn6CtWHW+rs6eGZ4yYLPuIFPRDsjZO7t9dkphckF6cW031yoY26evE1Yl
	 VJDcTIaJuIxYw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 11/22] KVM: arm64: Use a struct for stage-1 walk context
Date: Tue, 23 Jun 2026 11:41:50 -0700
Message-ID: <20260623184201.1518871-12-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623184201.1518871-1-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate the current walk step in a struct such that helpers can be
spun off from the core implementation.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 94 ++++++++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 597e9cddfc7e..816d23e7752d 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -429,6 +429,14 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	return -EFAULT;
 }
 
+struct s1_walk_step {
+	u64			desc;
+	u64			desc_ipa;
+	u64			desc_pa;
+	struct kvm_s2_trans	s2_trans;
+	int			level;
+};
+
 static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
 			    struct s1_walk_info *wi)
 {
@@ -468,12 +476,12 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		   struct s1_walk_result *wr, struct kvm_walk_access *access)
 {
-	u64 va_top, va_bottom, baddr, desc, new_desc, ipa, va;
-	struct kvm_s2_trans s2_trans = {};
-	int level, stride, ret;
+	u64 va_top, va_bottom, baddr, new_desc, va;
+	struct s1_walk_step ws = {};
+	int stride, ret;
 
 	va = access->ia;
-	level = wi->sl;
+	ws.level = wi->sl;
 	stride = wi->pgshift - 3;
 	baddr = wi->baddr;
 
@@ -482,15 +490,15 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	while (1) {
 		u64 index;
 
-		va_bottom = (3 - level) * stride + wi->pgshift;
+		va_bottom = (3 - ws.level) * stride + wi->pgshift;
 		index = (va & GENMASK_ULL(va_top, va_bottom)) >> (va_bottom - 3);
 
-		ipa = baddr | index;
+		ws.desc_ipa = ws.desc_pa = baddr | index;
 
 		if (wi->s2) {
 			struct kvm_walk_access s2_access = {
 				.type	= WALK_ACCESS_S1PTW,
-				.ia	= ipa,
+				.ia	= ws.desc_ipa,
 
 				/*
 				 * R_JCXVS, stage-2 dirty state can be updated
@@ -500,25 +508,25 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 				.write	= wi->ha,
 			};
 
-			ret = kvm_walk_nested_s2(vcpu, &s2_access, &s2_trans);
+			ret = kvm_walk_nested_s2(vcpu, &s2_access, &ws.s2_trans);
 			if (ret == -EAGAIN)
 				return ret;
 
 			if (ret) {
 				fail_s1_walk(wr,
-					     (s2_trans.esr & ~ESR_ELx_FSC_LEVEL) | level,
+					     (ws.s2_trans.esr & ~ESR_ELx_FSC_LEVEL) | ws.level,
 					     true);
 				return ret;
 			}
 
-			if (!s2_trans.readable) {
-				fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(level),
+			if (!ws.s2_trans.readable) {
+				fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(ws.level),
 					     true);
 
 				return -EPERM;
 			}
 
-			ipa = s2_trans.output;
+			ws.desc_pa = ws.s2_trans.output;
 		}
 
 		if (wi->filter) {
@@ -526,40 +534,40 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 					     {
 						     .wi	= wi,
 						     .table_ipa	= baddr,
-						     .level	= level,
+						     .level	= ws.level,
 					     }, wi->filter->priv);
 			if (ret)
 				return ret;
 		}
 
-		ret = kvm_read_s1_desc(vcpu, ipa, &desc, wi);
+		ret = kvm_read_s1_desc(vcpu, ws.desc_pa, &ws.desc, wi);
 		if (ret) {
-			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(level), false);
+			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(ws.level), false);
 			return ret;
 		}
 
-		new_desc = desc;
+		new_desc = ws.desc;
 
 		/* Invalid descriptor */
-		if (!(desc & BIT(0)))
+		if (!(ws.desc & BIT(0)))
 			goto transfault;
 
 		/* Block mapping, check validity down the line */
-		if (!(desc & BIT(1)))
+		if (!(ws.desc & BIT(1)))
 			break;
 
 		/* Page mapping */
-		if (level == 3)
+		if (ws.level == 3)
 			break;
 
 		/* Table handling */
 		if (!wi->hpd) {
-			wr->APTable  |= FIELD_GET(S1_TABLE_AP, desc);
-			wr->UXNTable |= FIELD_GET(PMD_TABLE_UXN, desc);
-			wr->PXNTable |= FIELD_GET(PMD_TABLE_PXN, desc);
+			wr->APTable  |= FIELD_GET(S1_TABLE_AP, ws.desc);
+			wr->UXNTable |= FIELD_GET(PMD_TABLE_UXN, ws.desc);
+			wr->PXNTable |= FIELD_GET(PMD_TABLE_PXN, ws.desc);
 		}
 
-		baddr = desc_to_oa(wi, desc);
+		baddr = desc_to_oa(wi, ws.desc);
 
 		/* Check for out-of-range OA */
 		if (check_output_size(baddr, wi))
@@ -567,23 +575,23 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 		/* Prepare for next round */
 		va_top = va_bottom - 1;
-		level++;
+		ws.level++;
 	}
 
 	/* Block mapping, check the validity of the level */
-	if (!(desc & BIT(1))) {
+	if (!(ws.desc & BIT(1))) {
 		bool valid_block = false;
 		bool lpa = kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, PARANGE, 52);
 
 		switch (BIT(wi->pgshift)) {
 		case SZ_4K:
-			valid_block = level == 1 || level == 2 || (wi->pa52bit && level == 0);
+			valid_block = ws.level == 1 || ws.level == 2 || (wi->pa52bit && ws.level == 0);
 			break;
 		case SZ_16K:
-			valid_block = level == 2 || (wi->pa52bit && level == 1);
+			valid_block = ws.level == 2 || (wi->pa52bit && ws.level == 1);
 			break;
 		case SZ_64K:
-			valid_block = level == 2 || (lpa && level == 1);
+			valid_block = ws.level == 2 || (lpa && ws.level == 1);
 			break;
 		}
 
@@ -591,19 +599,19 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			goto transfault;
 	}
 
-	baddr = desc_to_oa(wi, desc);
+	baddr = desc_to_oa(wi, ws.desc);
 	if (check_output_size(baddr & GENMASK(52, va_bottom), wi))
 		goto addrsz;
 
-	va_bottom += contiguous_bit_shift(desc, wi, level);
+	va_bottom += contiguous_bit_shift(ws.desc, wi, ws.level);
 
 	wr->failed = false;
-	wr->level = level;
-	wr->desc = desc;
+	wr->level = ws.level;
+	wr->desc = ws.desc;
 	wr->pa = baddr & GENMASK(52, va_bottom);
 	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
 
-	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
+	wr->nG = (wi->regime != TR_EL2) && (ws.desc & PTE_NG);
 	if (wr->nG)
 		wr->asid = get_asid_by_regime(vcpu, wi->regime);
 
@@ -612,35 +620,35 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (wi->ha)
 		new_desc |= PTE_AF;
 
-	if (new_desc != desc) {
-		if (wi->s2 && !s2_trans.writable) {
-			fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(level), true);
+	if (new_desc != ws.desc) {
+		if (wi->s2 && !ws.s2_trans.writable) {
+			fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(ws.level), true);
 			return -EPERM;
 		}
 
-		ret = kvm_swap_s1_desc(vcpu, ipa, desc, new_desc, wi);
+		ret = kvm_swap_s1_desc(vcpu, ws.desc_pa, ws.desc, new_desc, wi);
 		if (ret == -EAGAIN)
 			return ret;
 		if (ret) {
-			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(level), false);
+			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(ws.level), false);
 			return ret;
 		}
 
-		desc = new_desc;
+		ws.desc = new_desc;
 	}
 
-	if (!(desc & PTE_AF)) {
-		fail_s1_walk(wr, ESR_ELx_FSC_ACCESS_L(level), false);
+	if (!(ws.desc & PTE_AF)) {
+		fail_s1_walk(wr, ESR_ELx_FSC_ACCESS_L(ws.level), false);
 		return -EACCES;
 	}
 
 	return 0;
 
 addrsz:
-	fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ_L(level), false);
+	fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ_L(ws.level), false);
 	return -EINVAL;
 transfault:
-	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(level), false);
+	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(ws.level), false);
 	return -ENOENT;
 }
 
-- 
2.47.3

