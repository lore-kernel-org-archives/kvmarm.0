Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788977;
	b=SR+/lr+GxueKKi4vY356k7hEkzHqtiGI72Jqm8QmAmHDz/f2iE6wd7Gr7xGPF5U9KvAo
	 dWYVd3jajT12Z3skFSsqWsskB/GaTv3dxpUUk+m38nfERSaP5zGvsDJYXiHTp1m/Bwy3Q
	 C36/6ZKp4xobmUP9ToWQXSXo8vmEocnnJo3VyYOEafCgxcLYPVyAKEeW0HuuXSNhc7Knb
	 Xcfa5YPElwZo25P3oD4zV6Az5IZHOJdt2gF8oqOvk7/Zbye0AdInpycobJpCaXpthiO7b
	 1/DElOa6wXXlBRRi9/bPLniLd3JgcwRLI97vmCUHItOBxDa5+m4VanYx4IFWEbyDbjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wDItg1saNbAn4R+JrF8K/Rvp7cAK2gQg//sSJCaXu1M=;
	b=CjOcyalUR0uaVrpeHC1n5f6i7R8eB5buCxl5EJtzhg4/fjemdrE+AcCnHKepWLw8/b0S
	 2rY5PgBkY1iio9jd/bpIRct8FR1ymP8vKGtiGAQHc14PrqaH4D2xShwILNgU5WKkVu1yp
	 AAqIt0zyZMSjRrdVN5LcRz4iaO9aXfdDPR0J/pKRXjHw6lVj2Bxj24/nucpev58W1Ei5l
	 wTSFZKjTISp3Gl9mdMz9lole8jsKBwpuZ/FjXSFEa+aDWymJONVOu6yW65oQX8nk/naIW
	 wEvmwATHa2hx06/H23CUR7JAXz1dDxCgujdfDK6oGe4xhA02SyLVZ7lWPWfWs0CDuQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AIdYt8+n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDC5606A321
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AIdYt8+n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804F51F031E0;
	Fri, 23 Oct 2026 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788976;
	bh=wDItg1saNbAn4R+JrF8K/Rvp7cAK2gQg//sSJCaXu1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIdYt8+nVq5AKjHTzQG/u6W5hbr0aEAx+WbgkZx/vzJONlKdn0z9zCOXEh4R2slBj
	 ujgTxp95F49+s6O+LshkI3psjWwXEN9dnpFP0pjoxp6OzFdIAcnhmmF8JTzL6bIOSw
	 5bQydGbv3iEUBfJyD3LOCf+Jor9dWl+O8iCszD+I+0n36JTghy2AV7ue0vkrw3NMTR
	 iBhn6df1Uo10viB73JhoCbLeCnzM4Y0vVq3TgTvRXZsR87UkmFPEQIxs3hTmxwIxGE
	 ktngtSBAGWadII6EzKfL8nIGZKqIewLEnEy2o5lGU+cbeegr1istU+9ENN5Si7IpNS
	 9NUaRIKmsmJHQ==
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
Subject: [PATCH v2 04/28] KVM: arm64: nv: Only shadow writable-dirty guest descs as writable
Date: Fri, 23 Oct 2026 13:55:46 -0700
Message-ID: <20261023205610.1044532-5-oupton@kernel.org>
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

KVM will soon add support for hardware dirty state management for nested
guests. In order to emulate dirty state transitions on the guest
desciptor, KVM will need to use read-only hardware mappings and re-walk
the guest page tables upon taking a permission fault.

Prepare by limiting shadow stage-2 and shadow VNCR translations to
read-only for writable-clean guest translations.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/at.c                 |  2 ++
 arch/arm64/kvm/mmu.c                |  2 +-
 arch/arm64/kvm/nested.c             | 15 +++++++++++----
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 01645a5b224f..e8d5ae7afb9a 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -100,6 +100,7 @@ struct kvm_s2_trans {
 	u32		esr;
 	bool		writable;
 	bool		readable;
+	bool		dirty;
 	bool		px;
 	bool		ux;
 };
@@ -344,6 +345,7 @@ struct s1_walk_result {
 			bool	pr;
 			bool	pw;
 			bool	px;
+			bool	dirty;
 		};
 		struct {
 			u8	fst;
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 12ffd54be2b8..4e505433299b 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1315,6 +1315,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 			  (pan3_enabled(vcpu, wi->regime) && wr->ux));
 	wr->pw &= !pan;
 	wr->pr &= !pan;
+	wr->dirty = !(wr->desc & BIT(7));
 }
 
 static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
@@ -1673,6 +1674,7 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (wr->level == S1_MMU_DISABLED) {
 		wr->ur = wr->uw = wr->ux = true;
 		wr->pr = wr->pw = wr->px = true;
+		wr->dirty = true;
 	} else {
 		ret = walk_s1(vcpu, wi, wr, va);
 		if (ret)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cbf3cfb426ba..84aa1bb31095 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1703,7 +1703,7 @@ static int topup_mmu_memcache(struct kvm_s2_mmu *mmu, void *memcache)
 static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 						       enum kvm_pgtable_prot prot)
 {
-	if (!nested->writable)
+	if (!(nested->writable && nested->dirty))
 		prot &= ~KVM_PGTABLE_PROT_W;
 	if (!nested->readable)
 		prot &= ~KVM_PGTABLE_PROT_R;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 15c22a218609..9b2ea83aeccd 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -288,6 +288,8 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
 
 	trans->readable = s2ap & BIT(0);
 	trans->writable = s2ap & BIT(1);
+
+	trans->dirty = ws->desc & BIT(7);
 }
 
 /*
@@ -1587,6 +1589,11 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
 }
 
+static bool vncr_can_map_writable(struct vncr_tlb *vt)
+{
+	return vt->wr.pw && vt->wr.dirty && vt->hpa_writable;
+}
+
 static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 {
 	struct kvm_memory_slot *memslot;
@@ -1683,10 +1690,10 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 		atomic_set(&vt->cpu, -1);
 
 		kvm_make_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu);
-		kvm_release_faultin_page(vcpu->kvm, page, false, vt->wr.pw && vt->hpa_writable);
+		kvm_release_faultin_page(vcpu->kvm, page, false, vncr_can_map_writable(vt));
 	}
 
-	if (vt->wr.pw && vt->hpa_writable)
+	if (vncr_can_map_writable(vt))
 		mark_page_dirty(vcpu->kvm, gfn);
 
 	return 0;
@@ -1781,7 +1788,7 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 		kvm_inject_nested_sync(vcpu, esr);
 		break;
 	case 0:
-		perm = kvm_is_write_fault(vcpu) ? vt->wr.pw && vt->hpa_writable : vt->wr.pr;
+		perm = kvm_is_write_fault(vcpu) ? vncr_can_map_writable(vt) : vt->wr.pr;
 		if (!perm)
 			handle_vncr_perm(vcpu);
 		break;
@@ -1824,7 +1831,7 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
 	if (vt->wr.nG && get_asid_by_regime(vcpu, TR_EL20) != vt->wr.asid)
 		return;
 
-	if (vt->hpa_writable && vt->wr.pw && vt->wr.pr)
+	if (vncr_can_map_writable(vt) && vt->wr.pr)
 		prot = PAGE_KERNEL;
 	else if (vt->wr.pr)
 		prot = PAGE_KERNEL_RO;
-- 
2.47.3

