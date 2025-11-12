Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068F63538BB
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972453; cv=none; b=sE6FAQtHZvkhDr7SsfrMp7MeiF4CJLk0+ReQeqyURPovANex2/62dJkV/Q/5iyhyK3GBr5Fkz8Hvfqe9p9DkEx0DymRaAxr/kGxq6G+wTHPE6GvCKryCGIL09RlGqgrDegXecmSZBttRUSdR2xh0J7enoTFURbgAQTDBvBA4ZuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972453; c=relaxed/simple;
	bh=WNB8ZhiBHu3cCT8HeFlfMFYGtu0Qd8Uyow/cD8EpOI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6I9z/DukzNdXJeAqS/82FymFOzP96+IqeTXxMfclnHxbYFKzbq07jkrMf/4zKvsV+ZEu7EssK2RMfnPtsBkKWx5TygLN5cd6gbJx9rHJdHz0jQ4b/6o8ldSLutlSjQKstFgl1bn41TvABntlJvAxRCVYwY3aTX4aL34vgwMVaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbSb59t1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbSb59t1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FDBC16AAE;
	Wed, 12 Nov 2025 18:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972452;
	bh=WNB8ZhiBHu3cCT8HeFlfMFYGtu0Qd8Uyow/cD8EpOI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbSb59t1ZY6qi3snBe3eGyzWdhm4NN2D1gRdU5AdOqPfhpdYBq3t43qtCiyx88M2+
	 ZtePv1CjBR2KzRH940sjklmdH2fTvW0AEZgKFTqp/kQGYvdt+SWow2TdY6zbn4e/sF
	 4cUlEf9HYiDv6jqYy2BM+JM87ZtSar4PBG/egMl+FWyNtIAov8y4Ir1rMuKvAS9Bu/
	 2sbW+W+bXH21Vv9ybmOWjsleGwbEILOPxhCFkwAQOAtLCpwQ4fpJCdjyCZ+LKRrde4
	 9i9I6sguX1GqD9s+yuv9sGzyHxkD81uIW/tb5qAeff5Nab+O+FQkH+0L0aMVXX+vfm
	 LtQedsYp5P4RQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 11/12] KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW
Date: Wed, 12 Nov 2025 10:34:05 -0800
Message-ID: <20251112183406.2118981-12-oupton@kernel.org>
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

Give the stage-2 walk similar treatment to stage-1: update the access
flag during the table walk and do so for any walk context.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/mmu.c    |  3 +++
 arch/arm64/kvm/nested.c | 46 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 96f1786c72fe..b23d3dc8865e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2012,6 +2012,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		u32 esr;
 
 		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
+		if (ret == -EAGAIN)
+			return 1;
+
 		if (ret) {
 			esr = kvm_s2_trans_esr(&nested_trans);
 			kvm_inject_s2_fault(vcpu, esr);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index b2fb3d7c9c19..7293769dacf5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -124,13 +124,14 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 }
 
 struct s2_walk_info {
-	void	     *data;
-	u64	     baddr;
-	unsigned int max_oa_bits;
-	unsigned int pgshift;
-	unsigned int sl;
-	unsigned int t0sz;
-	bool	     be;
+	void		*data;
+	u64		baddr;
+	unsigned int	max_oa_bits;
+	unsigned int	pgshift;
+	unsigned int	sl;
+	unsigned int	t0sz;
+	bool		be;
+	bool		ha;
 };
 
 static u32 compute_fsc(int level, u32 fsc)
@@ -220,6 +221,22 @@ static int read_guest_s2_desc(phys_addr_t pa, u64 *desc, struct s2_walk_info *wi
 	return 0;
 }
 
+static int swap_guest_s2_desc(phys_addr_t pa, u64 old, u64 new,
+			      struct s2_walk_info *wi)
+{
+	struct kvm_vcpu *vcpu = wi->data;
+
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
 /*
  * This is essentially a C-version of the pseudo code from the ARM ARM
  * AArch64.TranslationTableWalk  function.  I strongly recommend looking at
@@ -233,7 +250,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 	int first_block_level, level, stride, input_size, base_lower_bound;
 	phys_addr_t base_addr;
 	unsigned int addr_top, addr_bottom;
-	u64 desc;  /* page table entry */
+	u64 desc, new_desc;  /* page table entry */
 	int ret;
 	phys_addr_t paddr;
 
@@ -326,6 +343,17 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 		return 1;
 	}
 
+	if (wi->ha)
+		new_desc |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
+
+	if (new_desc != desc) {
+		ret = swap_guest_s2_desc(paddr, desc, new_desc, wi);
+		if (ret)
+			return ret;
+
+		desc = new_desc;
+	}
+
 	if (!(desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
 		out->esr = compute_fsc(level, ESR_ELx_FSC_ACCESS);
 		out->desc = desc;
@@ -364,6 +392,8 @@ static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
 	/* Global limit for now, should eventually be per-VM */
 	wi->max_oa_bits = min(get_kvm_ipa_limit(),
 			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
+
+	wi->ha = vtcr & VTCR_EL2_HA;
 }
 
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
-- 
2.47.3

