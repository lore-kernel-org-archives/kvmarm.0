Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5541C38D3F3
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240127; cv=none; b=kgxy7IhJyH5O5dAip3fW6bXYZSQjqEwmbbsLVQs8hCxXcyVtzCIULGOgArcFL5hsMsw72X5uCjsoBw56TCJOhNFVSD6bKs8dak5bHACkJ3CruH2ZcZQ020LHKDpPGxIE6caOVUDed4pTVGIOX7VTF3IIteDCnJQL9uCFNxklZC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240127; c=relaxed/simple;
	bh=g36SmZZOhKkBswl5j4i7g4Pbk2GSDDB3XDDOtdNuy4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsIrgKwbzMpPBuOEOh0pJ6p+BsVI5nVfoPVHw4Otx9IeO3VfwH75p2CjjVayHPpEzKhzBSq6BgLNJtg6v9g8Zg/cJvTkOs9YHVgARn2IVGBoELTWjRnJlvb4zmyzJa4GmxDKTYGYwXsbVgRx24Rn+yzEbNZijuR2d+p4/Zf4eAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PB6PyCMD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PB6PyCMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE47F1F00A3F;
	Tue, 23 Jun 2026 18:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240126;
	bh=pBY5M3jWWzWbYJbqTz75rFFHKh3Jk4JO+QYdK8OgyOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PB6PyCMDxMwT9c9YeVDSJufeHUmrxWEd4YJgrc8lWCh+nB1eIF1oEztjvlBPLqR23
	 MPQYtlgcRZau8ac20DSNEmhMOKULnLDZESVbV2GVH6jlT5h0QCjeMowIW6X1SjSzX8
	 5E/4wJgL4eOjksg13CK611McqT3yt9RgKP9gqRNzGqWV7ZXWbEy3d52YO7N6r8lGXd
	 Rvbz4iUAclmB9qDOgaJvIP3GHr5GTY3wTU/8qV7UiBEcxsPL2X6+nvA9L3CZYcGaOd
	 SrVt6u+6HbbLpg4XZSxq9x5DtrZJiOUrmBEXS01NlogZVuc301w3dHl4VE2oTQnREw
	 KNytYii0nc3UA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 04/22] KVM: arm64: nv: Only shadow writable-dirty guest descs as writable
Date: Tue, 23 Jun 2026 11:41:43 -0700
Message-ID: <20260623184201.1518871-5-oupton@kernel.org>
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

KVM will soon add support for hardware dirty state management for nested
guests. In order to emulate dirty state transitions on the guest
desciptor, KVM will need to use read-only hardware mappings and re-walk
the guest page tables upon taking a permission fault.

Prepare by limiting shadow stage-2 and shadow VNCR translations to
read-only for writable-clean guest translations.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 2 ++
 arch/arm64/kvm/at.c                 | 1 +
 arch/arm64/kvm/mmu.c                | 2 +-
 arch/arm64/kvm/nested.c             | 4 +++-
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 3b36ed7c7608..7fe6fb56c187 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -94,6 +94,7 @@ struct kvm_s2_trans {
 	u32		esr;
 	bool		writable;
 	bool		readable;
+	bool		dirty;
 	bool		px;
 	bool		ux;
 };
@@ -323,6 +324,7 @@ struct s1_walk_result {
 			bool	pr;
 			bool	pw;
 			bool	px;
+			bool	dirty;
 		};
 		struct {
 			u8	fst;
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 86b499e7a9a0..7a84495a2e6d 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1317,6 +1317,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 			  (pan3_enabled(vcpu, wi->regime) && wr->ux));
 	wr->pw &= !pan;
 	wr->pr &= !pan;
+	wr->dirty = !(wr->desc & BIT(7));
 }
 
 static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 07bd1e3ae9fb..f35c4ce95473 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1572,7 +1572,7 @@ static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
 static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 						       enum kvm_pgtable_prot prot)
 {
-	if (!nested->writable)
+	if (!(nested->writable && nested->dirty))
 		prot &= ~KVM_PGTABLE_PROT_W;
 	if (!nested->readable)
 		prot &= ~KVM_PGTABLE_PROT_R;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index b247bc1d83fa..dcc7d0cc7c95 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -269,6 +269,8 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
 
 	trans->readable = s2ap & BIT(0);
 	trans->writable = s2ap & BIT(1);
+
+	trans->dirty = ws->desc & BIT(7);
 }
 
 /*
@@ -1603,7 +1605,7 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
 
 	vt->cpu = smp_processor_id();
 
-	if (vt->hpa_writable && vt->wr.pw && vt->wr.pr)
+	if (vt->hpa_writable && vt->wr.pw && vt->wr.dirty && vt->wr.pr)
 		prot = PAGE_KERNEL;
 	else if (vt->wr.pr)
 		prot = PAGE_KERNEL_RO;
-- 
2.47.3

