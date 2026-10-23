Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789042;
	b=HHiiEIgciYwqI93WoqAF246BPxhjNpUAH8ub2ZLHLea++8A1XxVc+xuHQavvXBqYfkB0
	 5JGTweVgYC1GgmIsouG+a0zsghr6Q4zsw+7ETSSNREYiVsmZfoB+Bz/3w5lBx/eccsGKW
	 CzPMWa8i/BJWgzLx2GvYHwn1GetDf0gyuWdMQTsVWTUS6CdLGtdpFHUSLtTpZOSUhvasv
	 bFw2a/Tx7yTytFnduHXA6dxkUjRpSwViz6GCdzdkyOZEDlocLsNT2zqqMy4lCEzB/vNMW
	 rq1TlT1qoTq8sviEw2uY5Yvn2TAB4lrWlmj7meBVqnVPVo+RW0+bhfAHDFDjMlHM9NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AH3GH4Mz1wZkE5uk7LiSdSBCZ+BAbP3kiPJD27VF1lo=;
	b=oKm1o1lb9LFSIn3A/V+DZB6aBWAetGvqR8RZp8E7gTlkgg3xOZ7qCKaEQTvmziCgUPzW
	 8nb8v9uCorfZiV4sL5wUqeJC9nibT9h1oloXheS+jEQ4bZ+H2xNH/J00kz4SAeTA1e7sy
	 MrQ1qiuEI62teCBnghCzxh8EQB7YlCRz5tOSM7XgXE5YEXEG4FiqlWAErtnX2X9xWhjfC
	 uPsOXigV8jRggtel0UrBuYfe6RC5ZNMiPpgVGuiHtNH6Rix7l9RQG2RHRHxcB4xRvnUN0
	 TFyEJB/EY8zXlv9QsvsQ+GouYAHz0TGyHTPj8EXsT17ABf4O4+yW9Eli2dK4rKb89ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bCtb8xf3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BF2606A31E
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bCtb8xf3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6C01F031E3;
	Fri, 23 Oct 2026 20:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789041;
	bh=AH3GH4Mz1wZkE5uk7LiSdSBCZ+BAbP3kiPJD27VF1lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCtb8xf3bmZgddSajQV4mgwUIQwYZglc2n5Nb6bBNea9blV3l33FarV4vF3X5TgNa
	 9b5Nb8I5B+gXKXIBdv3VGiqBpPnbB377jHq33z+rAcCcXi1iHzL5ARWLhMpJZBgd4C
	 gLBK/IhAi9oAz69slMDNdtEeEcdFUDmh43voojcPcbQJGxOmHMk5MqDslL0ePCQP9h
	 a+BAl2uW9FmkjVmzGN9FZ6I+FdDZ0CQaXEHHPgh0o9oA25hFVq14SgQqW/MQQIZ6Yv
	 DHN3bCsRd4Pq7Smn+HrNC8pnnGQArdIYu6BDVFz+O1wk8fs4sajmCIl4Fl70hzTb8V
	 DK+znw3y7jk3A==
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
Subject: [PATCH v2 22/28] KVM: arm64: Set Access flag on table descriptors at stage-1
Date: Fri, 23 Oct 2026 13:56:04 -0700
Message-ID: <20261023205610.1044532-23-oupton@kernel.org>
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

Implement access flag updates on table descriptors as required by
FEAT_HAFT. Note that unlike leaf descriptors, access flags on table
descriptors never generate a fault.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h  |  1 +
 arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
 arch/arm64/kvm/at.c                  | 23 ++++++++++++++++-------
 arch/arm64/kvm/hyp/pgtable.c         | 11 -----------
 4 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 11944dfb204c..81d8b1676fe4 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -340,6 +340,7 @@ struct s1_walk_info {
 	bool			pa52bit;
 	bool			ha;
 	bool			hd;
+	bool			haft;
 };
 
 struct s1_walk_result {
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 23e93f14af7b..0912987ea21a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -139,6 +139,17 @@ static inline bool kvm_pte_valid(kvm_pte_t pte)
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
index 2ce34af3b9f2..8f1be3af64e8 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -414,6 +414,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wi->hd &= (wi->regime == TR_EL2 ?
 		  FIELD_GET(TCR_EL2_HD, tcr) :
 		  FIELD_GET(TCR_HD, tcr));
+	wi->haft  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, HAFT) && wi->ha &&
+		    FIELD_GET(TCR2_EL1_HAFT, effective_tcr2(vcpu, wi->regime));
 
 	return 0;
 
@@ -463,7 +465,7 @@ static bool should_set_access_flag(struct s1_walk_info *wi, struct s1_walk_step
 	if (access->type == WALK_ACCESS_NONARCH)
 		return false;
 
-	return wi->ha;
+	return kvm_pte_table(ws->desc, ws->level) ? wi->haft : wi->ha;
 }
 
 static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step *ws,
@@ -471,6 +473,9 @@ static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step
 {
 	bool perm = wi->as_el0 ? wr->uw : wr->pw;
 
+	if (kvm_pte_table(ws->desc, ws->level))
+		return false;
+
 	switch (access->type) {
 	/* R_RKMHW */
 	case WALK_ACCESS_CMO:
@@ -621,6 +626,16 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		if (ws.level == 3)
 			break;
 
+		baddr = desc_to_oa(wi, ws.desc);
+
+		/* Check for out-of-range OA */
+		if (check_output_size(baddr, wi))
+			goto addrsz;
+
+		ret = handle_desc_update(vcpu, wi, &ws, wr, access);
+		if (ret)
+			return ret;
+
 		/* Table handling */
 		if (!wi->hpd) {
 			wr->APTable  |= FIELD_GET(S1_TABLE_AP, ws.desc);
@@ -628,12 +643,6 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			wr->PXNTable |= FIELD_GET(PMD_TABLE_PXN, ws.desc);
 		}
 
-		baddr = desc_to_oa(wi, ws.desc);
-
-		/* Check for out-of-range OA */
-		if (check_output_size(baddr, wi))
-			goto addrsz;
-
 		/* Prepare for next round */
 		va_top = va_bottom - 1;
 		ws.level++;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c83837b184d..fc22dc70f167 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -72,17 +72,6 @@ static u32 kvm_pgd_pages(u32 ia_bits, s8 start_level)
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

