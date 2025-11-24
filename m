Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E392D5944
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010922; cv=none; b=oICALnM95FQlCHrts3/cABJNr8AWEc8K3kz6WRhLEZYhjJgsbwi7TSzSjstvqFxszDSxzI6bTOExwg6l4Z4AO2O4bXw9RqgqUhHKlbarmL4h7PHZv+6J+D+RWmt88TfmCnfFzG4ihKd5FY0gnp787d15yaiNHkJLYDTy+gOaJEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010922; c=relaxed/simple;
	bh=k281FfjyQiLiX8ngpDUZrdKqUsqBwgjldewU1rR6V5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEc081EHvHQR6avDCIXfBTdhQxh3WO18f/gYCFMAQGRZjM+kZUV81S8H9CtJXz8fl2/flM/AP/uEU07sNAbl2PGROckl711/uCm/V5Mqz7oxjYrs3r/TnDScA23cj8kpJOzSC8i+9ViaK6sU1Rj1G+5loeXtcChIVrySxWydIEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OA2ZSrrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OA2ZSrrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7D8C4CEF1;
	Mon, 24 Nov 2025 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010922;
	bh=k281FfjyQiLiX8ngpDUZrdKqUsqBwgjldewU1rR6V5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OA2ZSrrqEfYoV+0w0/yldvdAwBKmYiZjdj/6YrDSXdEaIcPAVhrAQYRYy1Nz5NfEJ
	 WZW391hfznZqqiFPvgNZtv8Jn6AGCrgtz2Ieok3UZ+tERBfB4ZQ3tq72UK2TpwYZjn
	 wiBdaFHGckDpu2D4enWj95f5oGtMTXQuMUVCXCpC6wQLL5+40ONfOvD/Bw4QF4PT4H
	 vuUc5de/1kWJS1UXwocHOOvw+yJ7RkKqEjju/OxBUK4YilWfghSyhIOT8a/a4qdvCi
	 +3GR+eTaKdM1M4xbWzbRCrIIhjQb4wpSxeBo+Vk0GcX3bO8yskF3Sv9xLb9zTSSlrZ
	 kjS0/7J7fqxvg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 13/15] KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW
Date: Mon, 24 Nov 2025 11:01:55 -0800
Message-ID: <20251124190158.177318-14-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124190158.177318-1-oupton@kernel.org>
References: <20251124190158.177318-1-oupton@kernel.org>
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
 arch/arm64/kvm/mmu.c    |  5 +++++
 arch/arm64/kvm/nested.c | 44 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 96f1786c72fe..b9aebca90f59 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2012,6 +2012,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		u32 esr;
 
 		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
+		if (ret == -EAGAIN) {
+			ret = 1;
+			goto out_unlock;
+		}
+
 		if (ret) {
 			esr = kvm_s2_trans_esr(&nested_trans);
 			kvm_inject_s2_fault(vcpu, esr);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index a096766c6ec3..6495442f400a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -124,12 +124,13 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 }
 
 struct s2_walk_info {
-	u64	     baddr;
-	unsigned int max_oa_bits;
-	unsigned int pgshift;
-	unsigned int sl;
-	unsigned int t0sz;
-	bool	     be;
+	u64		baddr;
+	unsigned int	max_oa_bits;
+	unsigned int	pgshift;
+	unsigned int	sl;
+	unsigned int	t0sz;
+	bool		be;
+	bool		ha;
 };
 
 static u32 compute_fsc(int level, u32 fsc)
@@ -219,6 +220,20 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 *desc,
 	return 0;
 }
 
+static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u64 new,
+			      struct s2_walk_info *wi)
+{
+	if (wi->be) {
+		old = cpu_to_be64(old);
+		new = cpu_to_be64(new);
+	} else {
+		old = cpu_to_le64(old);
+		new = cpu_to_le64(new);
+	}
+
+	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
+}
+
 /*
  * This is essentially a C-version of the pseudo code from the ARM ARM
  * AArch64.TranslationTableWalk  function.  I strongly recommend looking at
@@ -232,7 +247,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	int first_block_level, level, stride, input_size, base_lower_bound;
 	phys_addr_t base_addr;
 	unsigned int addr_top, addr_bottom;
-	u64 desc;  /* page table entry */
+	u64 desc, new_desc;  /* page table entry */
 	int ret;
 	phys_addr_t paddr;
 
@@ -281,6 +296,8 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 		if (ret < 0)
 			return ret;
 
+		new_desc = desc;
+
 		/* Check for valid descriptor at this point */
 		if (!(desc & KVM_PTE_VALID)) {
 			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
@@ -325,6 +342,17 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 		return 1;
 	}
 
+	if (wi->ha)
+		new_desc |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
+
+	if (new_desc != desc) {
+		ret = swap_guest_s2_desc(vcpu, paddr, desc, new_desc, wi);
+		if (ret)
+			return ret;
+
+		desc = new_desc;
+	}
+
 	if (!(desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
 		out->esr = compute_fsc(level, ESR_ELx_FSC_ACCESS);
 		out->desc = desc;
@@ -363,6 +391,8 @@ static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
 	/* Global limit for now, should eventually be per-VM */
 	wi->max_oa_bits = min(get_kvm_ipa_limit(),
 			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
+
+	wi->ha = vtcr & VTCR_EL2_HA;
 }
 
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
-- 
2.47.3

