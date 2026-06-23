Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0436F3921CE
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240131; cv=none; b=G4PMwB2hjjx27NNTGxGqoYnsBVvspmbx2afkShy0WGIzCh/Ie1F0dEZCX2Qfi0oWdWDR33zMF3ruNnMprNP+lI40/sYFV0xugQB8UEMy112nYRtyuefTb58cBCNoME9mjhNaN070jK/e8WYoLeMSk+RPl5CyYzXhrebCKQMNIVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240131; c=relaxed/simple;
	bh=1065p6rKs1+UMvBaWU1hHDuyBBL8FddXcnCAd0I2iSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3ny+8Rgc3ArHdf/LMLgoirEdSL9da6umvZw9CKP1r3S4JUpQsc4vo3XJH75di+wcd6erNCBJj/6YymUGVnbtz1Ot69mxOCeh9cU4cHpd8N+aJNlLTLQwNxR51RmE/6aTo817xyjaPh8IOAQWUAChpSqRs8Wat7OQRC6K8qmNuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MwvHwuK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MwvHwuK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7C91F00ADE;
	Tue, 23 Jun 2026 18:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240128;
	bh=l0FAE+ThP7RBR9BqzIRKXKR4PAUtPV3rCitIuwjLSy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwvHwuK3cbsUzd8FQzMlBsdmBipeQJluggSF93ssZijruVV8ry+UwgSLW4NnO7ApM
	 jGLIZn5q4xA2P5ChBD9XGbP/D4n6sNu1CWgGiqio49JWXKCUrLSvSFn4b3SCAnam2m
	 Em57Tr2QA0GWSARp7f/Ch075a4b/aCUO3MW4O+Pn0UkQMFaMhTSfENAO6nO/FPvHf5
	 IfI8K+skM6sLHb4TnfZJmU+0BddrMl6mu+PyZn2G8YC6kPkIYsxKGLmoHavt/cqD3k
	 eYaatjvgjNLEHpmwGOyidYKpSxZ+UBbw5vHYcVN+hE2ZcRy4XPgWWecTzYgf28DIeL
	 /jfHnnHzHaT6w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 17/22] KVM: arm64: Set Access flag on table descriptors at stage-1
Date: Tue, 23 Jun 2026 11:41:56 -0700
Message-ID: <20260623184201.1518871-18-oupton@kernel.org>
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

Implement access flag updates on table descriptors as required by
FEAT_HAFT. Note that unlike leaf descriptors, access flags on table
descriptors never generate a fault.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---

Same comment as TCR_ELx.HD, will fix in v2.

 arch/arm64/include/asm/kvm_nested.h  |  1 +
 arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
 arch/arm64/kvm/at.c                  | 11 ++++++++++-
 arch/arm64/kvm/hyp/pgtable.c         | 11 -----------
 4 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 1bb070328b1c..b52cf869333c 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -317,6 +317,7 @@ struct s1_walk_info {
 	bool			pa52bit;
 	bool			ha;
 	bool			hd;
+	bool			haft;
 };
 
 struct s1_walk_result {
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 6ae36973686c..67601ed6370d 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -131,6 +131,17 @@ static inline bool kvm_pte_valid(kvm_pte_t pte)
 	return pte & KVM_PTE_VALID;
 }
 
+static inline bool kvm_pte_table(kvm_pte_t pte, s8 level)
+{
+	if (level == KVM_PGTABLE_LAST_LEVEL)
+		return false;
+
+	if (!kvm_pte_valid(pte))
+		return false;
+
+	return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
+}
+
 static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
 {
 	u64 pa;
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8d76eaf463c9..31a55b9d3385 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -416,6 +416,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wi->hd &= (wi->regime == TR_EL2 ?
 		  FIELD_GET(TCR_EL2_HD, tcr) :
 		  FIELD_GET(TCR_HD, tcr));
+	wi->haft  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, HAFT) &&
+		    FIELD_GET(TCR2_EL1_HAFT, effective_tcr2(vcpu, wi->regime));
 
 	return 0;
 
@@ -465,7 +467,7 @@ static bool should_set_access_flag(struct s1_walk_info *wi, struct s1_walk_step
 	if (access->type == WALK_ACCESS_NONARCH)
 		return false;
 
-	return wi->ha;
+	return kvm_pte_table(ws->desc, ws->level) ? wi->haft : wi->ha;
 }
 
 static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step *ws,
@@ -473,6 +475,9 @@ static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step
 {
 	bool perm = wi->as_el0 ? wr->uw : wr->pw;
 
+	if (kvm_pte_table(ws->desc, ws->level))
+		return false;
+
 	switch (access->type) {
 	/* R_RKMHW */
 	case WALK_ACCESS_CMO:
@@ -620,6 +625,10 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		if (ws.level == 3)
 			break;
 
+		ret = handle_desc_update(vcpu, wi, &ws, wr, access);
+		if (ret)
+			return ret;
+
 		/* Table handling */
 		if (!wi->hpd) {
 			wr->APTable  |= FIELD_GET(S1_TABLE_AP, ws.desc);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0c1defa5fb0f..173135ea1d0c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -71,17 +71,6 @@ static u32 kvm_pgd_pages(u32 ia_bits, s8 start_level)
 	return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
 }
 
-static bool kvm_pte_table(kvm_pte_t pte, s8 level)
-{
-	if (level == KVM_PGTABLE_LAST_LEVEL)
-		return false;
-
-	if (!kvm_pte_valid(pte))
-		return false;
-
-	return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
-}
-
 static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
 {
 	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
-- 
2.47.3

