Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789008;
	b=4ohZifJPFgRrk6Gkig/IFyD3SyFyqVL5vGrFsF6Sk/SfXXapiTvUI6QjDTIgTGL0UfV0
	 TgrGpVC5oaiTuEL6DmmT4tSGZ5gId3mQJdhv6Ux1MeB6u4KB4MS6+wDeG/pbInbaigxNv
	 rFK6u5tcQfuE5PbmBNHuPMHzyh6hLV5G2HtgQKpAwvzrZv5prkkn4mi0/UGevma1hlzlA
	 +BZwt80wpDsV6Wv5CgPvnMOyyIBr3Vf1SvBrdD//shPA6PNisnWjJvFQlJ7WZVZMrsZfS
	 6I/Zs7DNW913KXAICZXAvx/uQkLqrXQiOk711+2gb7mBX8HI0F2Hh5fFbELb1giFzyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CnRX1d72fSAMR51ATKMjI11B+ejkm7mR/T1sfQzC4T8=;
	b=RyIuXcT62qN3MfxmYnQ4jHdgRT2wAjaH2eNqkoUTDwzByvwP11wBpzNP3g5rsGPKVhmm
	 05mEQJudFibfe2TOkJZZraQCPD7YHFSDzJ6dhiSlbKYEOj83flL6SJnxBQLkThdgCMftE
	 aBfH+AujWw7w853hjEwIZATyoLpsLtVVgzA5/OFnKCTcBcgysv1JOj+wgEJZpusOcHHdz
	 NKYd5ydxrmbGgBOO49gCgpl7Aa+iisSthZLJvUX8EXK/2LJAyKL0dH0Hz2QKVZYgU+3gP
	 ymfkfAzhnfFzfle0UhPXXSXnMignf67yEo77nY2T4CZ+PeGJsg0ps6ijhxl2CT3JOrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cvw6UqHg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15E9606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cvw6UqHg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE2D1F01828;
	Fri, 23 Oct 2026 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789008;
	bh=CnRX1d72fSAMR51ATKMjI11B+ejkm7mR/T1sfQzC4T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cvw6UqHgba57RU8ADae4chkJnU2ROA+UngclbC0Am9qQxt2MTwHI8wjFowHyPvhLo
	 Mr2s4oGNZCNPHdzxZHeamTGrFLAwODpxHvJH647lM0RNvbDAP18WYJM8F6f3MENaXC
	 wF/RfvNJAlx87e3FdB2oEFqEA5BUPTnWCcf3vywiH8TGxjSevZCuTsw7GRFbqn9+xz
	 izJfEVgkqUVYUlZbcF4NiGDC4zSOwv0djzwgXri9NTUIoMLWFEgkQs0LDaBriT/XLI
	 j/MvFgUdkbsVAv8d5792hghDs38vCzZiU1v6FSuBMxM9rmZKSdfPsA1NNlsPTf+HbW
	 bCSu3OSc3ZSGw==
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
Subject: [PATCH v2 10/28] KVM: arm64: Plumb through access descriptor for stage-1
Date: Fri, 23 Oct 2026 13:55:52 -0700
Message-ID: <20261023205610.1044532-11-oupton@kernel.org>
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

Pass sufficient context to the stage-1 walk such that access-dependent
features like FEAT_HAFDBS can implement the correct behavior.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  4 +++-
 arch/arm64/kvm/at.c                 | 32 ++++++++++++++++++++++-------
 arch/arm64/kvm/nested.c             | 10 ++++++---
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 89a860b92826..d7c1fa66f029 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -118,6 +118,8 @@ struct kvm_walk_access {
 		WALK_ACCESS_CMO,
 		WALK_ACCESS_AT,
 		WALK_ACCESS_S1PTW,
+		WALK_ACCESS_NV2,
+		WALK_ACCESS_NONARCH,
 	} type;
 
 	u64	ia;
@@ -385,7 +387,7 @@ static inline bool s1_walk_translated(struct s1_walk_result *wr)
 }
 
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
-		       struct s1_walk_result *wr, u64 va);
+		       struct s1_walk_result *wr, struct kvm_walk_access *access);
 int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa,
 			     int *level);
 
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 3031f5855316..fe1d8a674d64 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -464,12 +464,13 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 				   struct s1_walk_result *wr);
 
 static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
-		   struct s1_walk_result *wr, u64 va)
+		   struct s1_walk_result *wr, struct kvm_walk_access *access)
 {
-	u64 va_top, va_bottom, baddr, desc, new_desc, ipa;
+	u64 va_top, va_bottom, baddr, desc, new_desc, ipa, va;
 	struct kvm_s2_trans s2_trans = {};
 	int level, stride, ret;
 
+	va = access->ia;
 	level = wi->sl;
 	stride = wi->pgshift - 3;
 	baddr = wi->baddr;
@@ -1338,6 +1339,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 
 static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
 {
+	struct kvm_walk_access access = {};
 	struct s1_walk_result wr = {};
 	struct s1_walk_info wi = {};
 	bool perm_fail = false;
@@ -1355,9 +1357,21 @@ static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
 	if (wr.level == S1_MMU_DISABLED)
 		goto compute_par;
 
+	access.type = WALK_ACCESS_AT;
+	access.ia = vaddr;
+	switch (op) {
+	case OP_AT_S1E1WP:
+	case OP_AT_S1E1W:
+	case OP_AT_S1E2W:
+	case OP_AT_S1E0W:
+		access.write = true;
+		break;
+	default:
+	}
+
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
-	ret = walk_s1(vcpu, &wi, &wr, vaddr);
+	ret = walk_s1(vcpu, &wi, &wr, &access);
 
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
@@ -1681,11 +1695,11 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
  * set. The rest of the wi and wr should be 0-initialised.
  */
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
-		       struct s1_walk_result *wr, u64 va)
+		       struct s1_walk_result *wr, struct kvm_walk_access *access)
 {
 	int ret;
 
-	ret = setup_s1_walk(vcpu, wi, wr, va);
+	ret = setup_s1_walk(vcpu, wi, wr, access->ia);
 	if (ret)
 		return ret;
 
@@ -1696,7 +1710,7 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		return 0;
 	}
 
-	return walk_s1(vcpu, wi, wr, va);
+	return walk_s1(vcpu, wi, wr, access);
 }
 
 struct desc_match {
@@ -1734,6 +1748,10 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 		.as_el0	= false,
 		.pan	= false,
 	};
+	struct kvm_walk_access access = {
+		.type	= WALK_ACCESS_NONARCH,
+		.ia	= va,
+	};
 	struct s1_walk_result wr = {};
 	int ret;
 
@@ -1754,7 +1772,7 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 
 	/* Walk the guest's PT, looking for a match along the way */
 	scoped_guard(srcu, &vcpu->kvm->srcu)
-		ret = walk_s1(vcpu, &wi, &wr, va);
+		ret = walk_s1(vcpu, &wi, &wr, &access);
 	switch (ret) {
 	case -EINTR:
 		/* We interrupted the walk on a match, return the level */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index e388cefad9e5..964331dbf475 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1639,6 +1639,7 @@ static bool vncr_can_map_writable(struct vncr_tlb *vt)
 
 static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 {
+	struct kvm_walk_access access = {};
 	struct kvm_memory_slot *memslot;
 	bool write_fault, writable;
 	unsigned long mmu_seq;
@@ -1648,6 +1649,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 	int ret;
 
 	vt = vcpu->arch.vncr_tlb;
+	write_fault = kvm_is_write_fault(vcpu);
 
 	/*
 	 * If we're about to walk the EL2 S1 PTs, we must invalidate the
@@ -1674,15 +1676,17 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 
 	va =  read_vncr_el2(vcpu);
 
+	access.type = WALK_ACCESS_NV2;
+	access.ia = va;
+	access.write = write_fault;
+
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, va);
+	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, &access);
 	if (ret)
 		return ret;
 
-	write_fault = kvm_is_write_fault(vcpu);
-
 	gfn = vt->wr.pa >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (!memslot) {
-- 
2.47.3

