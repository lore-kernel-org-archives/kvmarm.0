Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D5928504F
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419414; cv=none; b=NHHNGQl189Asc41ZtF7qeBviCpAlmQArSABVV3Z116vaZHq54qxB5QfttWDcPRGwqKeXcCOONeDZE1owkEVqxk3H2hOj1Pf8D8WGww8mH17NvbpCBwUkIEJhqTouX7osZdBND/kMR2rAJreOfxOYyj/khx66EPWoULBA73KExMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419414; c=relaxed/simple;
	bh=VPadk5X8RD2QvWYR0pkwdRMwTnKtoDtq5edH21nGzEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p11Xa1mq9jFp2U8GRWqP93pF67zhlZ2lTLLD0hABOf6nvLo3JKAvCKNzpytCBBh1CVlQQJxkhBNcvzJbvUXu7UaWPe51lSShzI1UU+W1gM7R+6gBj3t1yIhLK43Bekp3d7/Anj7Ya6l9oX2Mx/eHOzlT4S2x+v6ybRkpScw+kA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rLkf/ria; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rLkf/ria"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE6DC2BCB2;
	Mon, 17 Nov 2025 22:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419414;
	bh=VPadk5X8RD2QvWYR0pkwdRMwTnKtoDtq5edH21nGzEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLkf/riaS2EyzrzSsXqil6nMIfbJRJi1MgW6QjXBLE4YkjJnsGIkEz0YPL+jxA7d1
	 CJ7TdgLxIQnPM5Z1i9x2HL5tA2EeeUsyUJxtC5niESfdFTsqK5JnBk6aUWULJBCsZ3
	 ys3UgSIkvl0gdlLk9gvAdErwZwK5MRrGWqb8kEHMFHL6hklAMvzCX38FbN+mjvHEDU
	 /1s41xrUzd2wFOo+IFigCt6OPMcwFt5KncbAG8jF4ituDuEOT9Qqq/mK9C/hElSTC4
	 VnjcOO4bH/d88HAFTy0vO149wffC3NmfIhaA2aslvlSsJT8dayoSP9GDqByrlnBcnE
	 LobfsLLRFfpNA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 12/14] KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW
Date: Mon, 17 Nov 2025 14:43:23 -0800
Message-ID: <20251117224325.2431848-13-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
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
 arch/arm64/kvm/nested.c | 48 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 43 insertions(+), 8 deletions(-)

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
index b2fb3d7c9c19..5921b66279b8 100644
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
@@ -233,7 +250,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 	int first_block_level, level, stride, input_size, base_lower_bound;
 	phys_addr_t base_addr;
 	unsigned int addr_top, addr_bottom;
-	u64 desc;  /* page table entry */
+	u64 desc, new_desc;  /* page table entry */
 	int ret;
 	phys_addr_t paddr;
 
@@ -282,6 +299,8 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 		if (ret < 0)
 			return ret;
 
+		new_desc = desc;
+
 		/* Check for valid descriptor at this point */
 		if (!(desc & KVM_PTE_VALID)) {
 			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
@@ -326,6 +345,17 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
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
@@ -364,6 +394,8 @@ static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
 	/* Global limit for now, should eventually be per-VM */
 	wi->max_oa_bits = min(get_kvm_ipa_limit(),
 			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
+
+	wi->ha = vtcr & VTCR_EL2_HA;
 }
 
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
-- 
2.47.3

