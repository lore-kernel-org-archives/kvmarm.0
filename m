Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FA9388E68
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240126; cv=none; b=N25fp9dB6rEQWGLoTA33oDkaukPuWu/6Yjo3JkjqW1UkUv0Cj+ZSbD9w78EWqkyMnHdrijlMG8tW7kKk9CpCZ4S0iNjcGBtaakSJ7/KsEkkELHZ/eG/7KxzdNE6cFDsTUhyB6BkkGQCjyW+fM54MIgr1ek45NwM6Qy4cZi/6KPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240126; c=relaxed/simple;
	bh=tK41VLu3oX/8WFujLlEyRKsMl24XcauwCJinH2xVEk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdmfsfqLnG0RKJR+AATgIfvpaardWAf8VpDbCSLE8GKavoWG6AFMF0rzfNMbx6zHt/EG9yBHMmXEvAtLonwI/8THoqlDh6JJxZcSIFvzBTeaNospsyvDM/OS5XBlv8eNcwqaas0foAfPM36qkWxWm1rPducRNbrevtW9DKst78M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAXuSy46; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAXuSy46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BBC1F00A3E;
	Tue, 23 Jun 2026 18:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240125;
	bh=AJ4D381JvVRC3SWX792cxQLTpsMknSxbDywTdUUt4gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iAXuSy46CkSaPEbTbblpQkWS9jhT9xgyps875/d9BxhrGHzGU5pU8BLKWCG++Oj+V
	 bL1qQNPSPgMaDlhUU18scmJ3XYc/QszYeE1jUmNtUaPLJO3/JqHtVK3Ahx/uLS9Ewk
	 Nby+ZxlkkuhToIUKlGHZjsPjTTLKS0+KQ8KuCLl+B1OUjkFU1qXmBBHxmP9ffAhbrX
	 Ta4r3mAFM9aSCerhGja94Qm/5UbIkpsablr29g6EtaDTfQhC3SsRg4E9+f91YypAIz
	 QlsS3xLGtxqEJvv3ZKsDkmlRe+Q6gHbk/LXaHESWanEcKR7/S87pLyAiBO+t21r5VT
	 NKELU6nY67eiA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 01/22] KVM: arm64: nv: Introduce struct for stage-2 walk step
Date: Tue, 23 Jun 2026 11:41:40 -0700
Message-ID: <20260623184201.1518871-2-oupton@kernel.org>
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

Factoring out helpers from walk_nested_s2_pgd() will require passing the
context of the current walk step. Prepare by reorganizing the relvant
information into a struct.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 109 +++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 52 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 94df26de6990..9e60c7c822ae 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -134,6 +134,12 @@ struct s2_walk_info {
 	bool		ha;
 };
 
+struct s2_walk_step {
+	u64		desc_pa;
+	u64		desc;
+	int		level;
+};
+
 static u32 compute_fsc(int level, u32 fsc)
 {
 	return fsc | (level & 0x3);
@@ -199,13 +205,13 @@ static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
 	return 0;
 }
 
-static int read_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 *desc,
+static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
 			      struct s2_walk_info *wi)
 {
 	u64 val;
 	int r;
 
-	r = kvm_read_guest(vcpu->kvm, pa, &val, sizeof(val));
+	r = kvm_read_guest(vcpu->kvm, ws->desc_pa, &val, sizeof(val));
 	if (r)
 		return r;
 
@@ -214,9 +220,9 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 *desc,
 	 * host and the guest hypervisor.
 	 */
 	if (wi->be)
-		*desc = be64_to_cpu((__force __be64)val);
+		ws->desc = be64_to_cpu((__force __be64)val);
 	else
-		*desc = le64_to_cpu((__force __le64)val);
+		ws->desc = le64_to_cpu((__force __le64)val);
 
 	return 0;
 }
@@ -245,22 +251,22 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
 static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 			      struct s2_walk_info *wi, struct kvm_s2_trans *out)
 {
-	int first_block_level, level, stride, input_size, base_lower_bound;
+	int first_block_level, stride, input_size, base_lower_bound;
+	struct s2_walk_step ws = {};
 	phys_addr_t base_addr;
 	unsigned int addr_top, addr_bottom;
-	u64 desc, new_desc;  /* page table entry */
+	u64 new_desc;  /* page table entry */
 	int ret;
-	phys_addr_t paddr;
 
 	switch (BIT(wi->pgshift)) {
 	default:
 	case SZ_64K:
 	case SZ_16K:
-		level = 3 - wi->sl;
+		ws.level = 3 - wi->sl;
 		first_block_level = 2;
 		break;
 	case SZ_4K:
-		level = 2 - wi->sl;
+		ws.level = 2 - wi->sl;
 		first_block_level = 1;
 		break;
 	}
@@ -270,13 +276,13 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	if (input_size > 48 || input_size < 25)
 		return -EFAULT;
 
-	ret = check_base_s2_limits(vcpu, wi, level, input_size, stride);
+	ret = check_base_s2_limits(vcpu, wi, ws.level, input_size, stride);
 	if (WARN_ON(ret)) {
 		out->esr = compute_fsc(0, ESR_ELx_FSC_FAULT);
 		return ret;
 	}
 
-	base_lower_bound = 3 + input_size - ((3 - level) * stride +
+	base_lower_bound = 3 + input_size - ((3 - ws.level) * stride +
 			   wi->pgshift);
 	base_addr = wi->baddr & GENMASK_ULL(47, base_lower_bound);
 
@@ -291,96 +297,95 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	while (1) {
 		phys_addr_t index;
 
-		addr_bottom = (3 - level) * stride + wi->pgshift;
+		addr_bottom = (3 - ws.level) * stride + wi->pgshift;
 		index = (ipa & GENMASK_ULL(addr_top, addr_bottom))
 			>> (addr_bottom - 3);
 
-		paddr = base_addr | index;
-		ret = read_guest_s2_desc(vcpu, paddr, &desc, wi);
+		ws.desc_pa = base_addr | index;
+		ret = read_guest_s2_desc(vcpu, &ws, wi);
 		if (ret < 0) {
-			out->esr = ESR_ELx_FSC_SEA_TTW(level);
+			out->esr = ESR_ELx_FSC_SEA_TTW(ws.level);
 			return ret;
 		}
 
-		new_desc = desc;
+		new_desc = ws.desc;
 
 		/* Check for valid descriptor at this point */
-		if (!(desc & KVM_PTE_VALID)) {
-			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
-			out->desc = desc;
+		if (!(ws.desc & KVM_PTE_VALID)) {
+			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
+			out->desc = ws.desc;
 			return 1;
 		}
 
-		if (FIELD_GET(KVM_PTE_TYPE, desc) == KVM_PTE_TYPE_BLOCK) {
-			if (level < 3)
+		if (FIELD_GET(KVM_PTE_TYPE, ws.desc) == KVM_PTE_TYPE_BLOCK) {
+			if (ws.level < 3)
 				break;
 
-			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
-			out->desc = desc;
+			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
+			out->desc = ws.desc;
 			return 1;
 		}
 
 		/* We're at the final level */
-		if (level == 3)
+		if (ws.level == 3)
 			break;
 
-		if (check_output_size(wi, desc)) {
-			out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
-			out->desc = desc;
+		if (check_output_size(wi, ws.desc)) {
+			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ADDRSZ);
+			out->desc = ws.desc;
 			return 1;
 		}
 
-		base_addr = desc & GENMASK_ULL(47, wi->pgshift);
+		base_addr = ws.desc & GENMASK_ULL(47, wi->pgshift);
 
-		level += 1;
+		ws.level += 1;
 		addr_top = addr_bottom - 1;
 	}
 
-	if (level < first_block_level) {
-		out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
-		out->desc = desc;
+	if (ws.level < first_block_level) {
+		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
+		out->desc = ws.desc;
 		return 1;
 	}
 
-	if (check_output_size(wi, desc)) {
-		out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
-		out->desc = desc;
+	if (check_output_size(wi, ws.desc)) {
+		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ADDRSZ);
+		out->desc = ws.desc;
 		return 1;
 	}
 
 	if (wi->ha)
 		new_desc |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
 
-	if (new_desc != desc) {
-		ret = swap_guest_s2_desc(vcpu, paddr, desc, new_desc, wi);
+	if (new_desc != ws.desc) {
+		ret = swap_guest_s2_desc(vcpu, ws.desc_pa, ws.desc, new_desc, wi);
 		if (ret == -EAGAIN)
 			return ret;
 		if (ret) {
-			out->esr = ESR_ELx_FSC_SEA_TTW(level);
-			out->desc = desc;
+			out->esr = ESR_ELx_FSC_SEA_TTW(ws.level);
+			out->desc = ws.desc;
 			return 1;
 		}
 
-		desc = new_desc;
+		ws.desc = new_desc;
 	}
 
-	if (!(desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
-		out->esr = compute_fsc(level, ESR_ELx_FSC_ACCESS);
-		out->desc = desc;
+	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
+		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ACCESS);
+		out->desc = ws.desc;
 		return 1;
 	}
 
-	addr_bottom += contiguous_bit_shift(desc, wi, level);
+	addr_bottom += contiguous_bit_shift(ws.desc, wi, ws.level);
 
 	/* Calculate and return the result */
-	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
-		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
-	out->output = paddr;
-	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
-	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
-	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
-	out->level = level;
-	out->desc = desc;
+	out->output = (ws.desc & GENMASK_ULL(47, addr_bottom)) |
+		      (ipa & GENMASK_ULL(addr_bottom - 1, 0));
+	out->block_size = 1UL << ((3 - ws.level) * stride + wi->pgshift);
+	out->readable = ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
+	out->writable = ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+	out->level = ws.level;
+	out->desc = ws.desc;
 	return 0;
 }
 
-- 
2.47.3

