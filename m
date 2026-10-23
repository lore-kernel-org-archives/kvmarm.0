Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788976;
	b=Pflqp8s9DRxCPC9n84ifbUpji2TJsXVxO/u6UuItWobYvGPzZ+G/TB82GPO1pRMywXtQ
	 reSEzP4LgDxS1cCh9DwA6g5e/UT/hQw/OlZ882YjHs/ejl/5V9kl4/hq8CaWm2mDj8Viu
	 y1t/STZp8iJ2eu+MU8WKFStNwrAHUh5uQpcTxWU1OfmsXu5s3B+A4Wt6kvHXTwofQsPut
	 jyiGqrjUIFQVX4D6wkbVMkaG/M2EFle5tWSxRCCamSlZ6iWOtnHRFp5a6qrZ5F0eOKbyN
	 b8LVBWdchfMpZpcc60F68Ubb2+Vfgwev3PGgu8CAHqE9VokrlTrrBO9g39+4eeQCC7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DKDgu6XKGcb8JI7jRLaiht4lU+OEA6PEZKMK0V5Uxn4=;
	b=HN5HPbyUhLK8QBU6t3a8JFErjPuRRY0AzgfS/bo/gvyk/KA77p5SZpuKrQepGSn4Z7Kg
	 czauMb5gisN9iZXbE8i/HD1jp/oaik7XLUL8GRzwEgipGzuJpCv0sBbk+p1hWG0DP/l91
	 yAyfytr+uHr++XsBIxoyworVHokRArgPu+Eg6UuZwqdxzdzAMSiCVIkXwAHX3YzqspMGz
	 vbCfIHgRViOLzcoT70NkGgoF7Z7GMB5iBy/+MdqQj58G2PgDodbKBq8JPI+XOpusvI0j7
	 b7qRaYTfqoa5lQ2A1bdqSBCePrdCpVmCFl8yVjjBBIvrynqF4/3stEAYoCSMlUAfXKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="d0IL/s/r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17269606A31B
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d0IL/s/r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7E11F031E0;
	Fri, 23 Oct 2026 20:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788975;
	bh=DKDgu6XKGcb8JI7jRLaiht4lU+OEA6PEZKMK0V5Uxn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0IL/s/rhr7gEKUzxWmUVCuVQ0nHQxOibKuuq8CzmYqMRRYJ2rQV6gI9+C5vrYcs4
	 SoLhHjk78dM50fkCNeRfNqwZ6RZEReLlLxI53eZx/fyDg2NNgd+gbnSgDE8z0XooN6
	 XK64cvNgQBy1y9XObTF0T2jSdgmx/VLVuGoAP64ye9e8Pd5Y3Q3DJ+xY80jzDSzVX6
	 gei9n+uAnwVNopcdm5TFPnrIphtMrDwhfavC4KzK8usTOihT9HyuHv3bujZzA7RaFW
	 tAZNEVgT4YQzIHg5N6YRsyH42xDO/cV2EA/0YZfrgZkwF/rbWbdV1FtQ0BNL7QyNSD
	 PEe9bsOpKwmdg==
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
Subject: [PATCH v2 01/28] KVM: arm64: nv: Introduce struct for stage-2 walk step
Date: Fri, 23 Oct 2026 13:55:43 -0700
Message-ID: <20261023205610.1044532-2-oupton@kernel.org>
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

Factoring out helpers from walk_nested_s2_pgd() will require passing the
context of the current walk step. Prepare by reorganizing the relvant
information into a struct.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 109 +++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 52 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f0f473978d98..9ceb3a42767d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -153,6 +153,12 @@ struct s2_walk_info {
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
@@ -218,13 +224,13 @@ static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
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
 
@@ -233,9 +239,9 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 *desc,
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
@@ -264,22 +270,22 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
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
@@ -289,13 +295,13 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
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
 
@@ -310,96 +316,95 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
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

