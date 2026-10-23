Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789009;
	b=NkXHctg4soqL2uleghZLicHNP/hyoyhNJgQQXhv9R2QYrKiwpjLFYjLjSyYZTxiH+77P
	 leyQnI2+3zh3CI6/5fmSrMmSau4FmuAMhr3sHJOAPYRDc8vhIf+lfZb2PKudurwvET9Zj
	 QjVESXIcbhzKrx2nNPA1oFzDdLa0NtFAh6dkg1251q78vayqi7E2F1MCFGJQ8vELpOTdp
	 3XXxtfAgn08iXo9pl29W+Eg/wpw42DofSeYTLB0lnQApRPTCauuQFDQ7ZDAfp5Jjeoqjs
	 O+Pwvon6kITnwPb6Q2GWFiNFbzCTp+xGjxeToVIUOOrob7YU1TV7agx8SoH678n6hEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=t/gf+svSt3zX5Xbq29BV5Ho3II+tfnzv6kCOt2JTM5M=;
	b=iqaTM6hEkUHmemMj6vAv5urQz0OMjpR9Ty66qzxRfayIF9zbqe5nt+SK887JcFx2TZvl
	 d4XDxnZRXGgbZUDNFHV1oswjjVonqXHPT5Iw6rvLnZvfYbNHt3X809OmsUyZJUTJqsWYQ
	 wdssPNEt0HLMJKEpjLd+DWUPtv2TcCGyVEw5cJBXK+HGUzq2dtl2GwmTh/QEAfvwu0zdH
	 uamQw6/yWnvXPCKtB/w4REeC9LtNWi+JI9DOzdwQqWfeB9Z3wA2P66hbzJiCoD03VAhUw
	 lMWYMrZrwiUKSoTAzYwKiXR1ICh2Zr9zA0ZDogA3pDVyf+1qEkmJj83wr1laTBF108A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cDRYEBw2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAB4606A31D
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cDRYEBw2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603E61F031E1;
	Fri, 23 Oct 2026 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789008;
	bh=t/gf+svSt3zX5Xbq29BV5Ho3II+tfnzv6kCOt2JTM5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDRYEBw21NGJMsFpCFZYasoFRYM9VKv09pJDdpTstIly3uxsklKcr2gHEAsxOWbKU
	 qLxu0c+AGXtAQXxlbhc8kYpc4P+1zDFuqZZ214OvjWCDTy//mUI2fhZDEmLBa3qaKK
	 HYbz8O5SChx2W4PBRnqveTVnShZVGhzWV+NofeIHA8I0z/We+bQrFqrH7Iv8yLlyBH
	 BkAOGHTZ1vkwoLp0bh80kUaTQL3/sxqIy+mCLlCY1GVb7BJHVFItUsevei8fBwI3A/
	 8p5orgXasUmna4ETJgwrDSQoOFwF6RPNgtUr46uM99KlKWno+CVa9Sf4zOHVj0gq4h
	 aigR1CG+qzxaA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 11/28] KVM: arm64: Use a struct for stage-1 walk context
Date: Fri, 23 Oct 2026 13:55:53 -0700
Message-ID: <20261023205610.1044532-12-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate the current walk step in a struct such that helpers can be
spun off from the core implementation.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 94 ++++++++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index fe1d8a674d64..dcbe5563baa2 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -427,6 +427,14 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
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
@@ -466,12 +474,12 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
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
 
@@ -480,15 +488,15 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
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
@@ -498,25 +506,25 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
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
@@ -524,40 +532,40 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
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
@@ -565,23 +573,23 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
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
 
@@ -589,19 +597,19 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
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
 
@@ -610,35 +618,35 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
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

