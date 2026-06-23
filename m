Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585FC38C433
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240128; cv=none; b=kOsSAVrfnWYHrkuEtjRNRnV8PI2Z1fFgI4jl72LSo/Epo2KLIFk+YzpOD68l3yMLURB14h6rnAI39Km7KIj6W8em6ghJa81mfe/8g7UatP2Dk5spig5Uevm0DpUjrCtKY/p5SIZXQIc/q9EBq8t0mOvSv/TswFBj7O977XKnvyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240128; c=relaxed/simple;
	bh=BTevusimSo3PIcQIdAC6RhEyguyUF84dtcgbPxpW3U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dew7TRuENn3PmpxpFflpuFxUPe75Frq1eE9Ijw3NP185lPGqsh4xwQgd5tVZLS/mbrLsVt1sXjAMBrVfYxaoZVqnf063w+UapoxbCXANUVBjKDPN/h1GVi/dDN9UKNC6QOfTgkhkYRoSvdiXi8SpZry4Dxx0d/v6zh8cQhJh+9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5Q7Y47t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5Q7Y47t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028681F00A3A;
	Tue, 23 Jun 2026 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240127;
	bh=Ud0bKlxtwNjyETTkKy9hBe8Yu4V9FJdUCLm/TjUc++U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5Q7Y47tbDlt2W//DwE1pCV8QEZQSS/GtCr/kYfSEfoZGgCc1PDFyEc9es9onRPXf
	 r9HvGXKntqpZuHDSUuc5Hz/rnX6rFrWOyirn4YNti5ovZHtiQNFATHi3m73ZwCYioS
	 Q0iqTGI7niglDNBONEKMwM5CezrbMnQ0+WRgXqIIvQpOONsRahlj9waJpokGiijusc
	 lNNhbPC30N1FhBFFED2pvz8iW9PaIAYJf09gnA490ZFeX4nYp5xyP/pKSILgJiLP0Y
	 SJsc4jFhtOvjOG2vSIZ77gkgkwSJ0PoPvl24w/mRZiz5JzT7qe2NxAth+tUvGOQ+uH
	 vRGCj6nrczuuQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 09/22] KVM: arm64: Compute S1 permissions as part of s1_walk()
Date: Tue, 23 Jun 2026 11:41:48 -0700
Message-ID: <20260623184201.1518871-10-oupton@kernel.org>
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

Implementing support for hardware dirty state means that the table
walker needs to have visibility into the permissions on the final
translation.

Compute the S1 permissions as part of s1_walk() and initialize
s1_walk_result before checking all fault conditions. The appropriate
fields will be reinitialized if the walk happens to fail at a later
point.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 083014e9d86a..6930bc3bc86b 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -461,6 +461,10 @@ static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
 	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
 }
 
+static void compute_s1_permissions(struct kvm_vcpu *vcpu,
+				   struct s1_walk_info *wi,
+				   struct s1_walk_result *wr);
+
 static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		   struct s1_walk_result *wr, u64 va)
 {
@@ -590,6 +594,20 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (check_output_size(baddr & GENMASK(52, va_bottom), wi))
 		goto addrsz;
 
+	va_bottom += contiguous_bit_shift(desc, wi, level);
+
+	wr->failed = false;
+	wr->level = level;
+	wr->desc = desc;
+	wr->pa = baddr & GENMASK(52, va_bottom);
+	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
+
+	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
+	if (wr->nG)
+		wr->asid = get_asid_by_regime(vcpu, wi->regime);
+
+	compute_s1_permissions(vcpu, wi, wr);
+
 	if (wi->ha)
 		new_desc |= PTE_AF;
 
@@ -615,18 +633,6 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		return -EACCES;
 	}
 
-	va_bottom += contiguous_bit_shift(desc, wi, level);
-
-	wr->failed = false;
-	wr->level = level;
-	wr->desc = desc;
-	wr->pa = baddr & GENMASK(52, va_bottom);
-	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
-
-	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
-	if (wr->nG)
-		wr->asid = get_asid_by_regime(vcpu, wi->regime);
-
 	return 0;
 
 addrsz:
@@ -1365,8 +1371,6 @@ static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
 	if (ret)
 		goto compute_par;
 
-	compute_s1_permissions(vcpu, &wi, &wr);
-
 	switch (op) {
 	case OP_AT_S1E1RP:
 	case OP_AT_S1E1R:
@@ -1690,15 +1694,10 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (wr->level == S1_MMU_DISABLED) {
 		wr->ur = wr->uw = wr->ux = true;
 		wr->pr = wr->pw = wr->px = true;
-	} else {
-		ret = walk_s1(vcpu, wi, wr, va);
-		if (ret)
-			return ret;
-
-		compute_s1_permissions(vcpu, wi, wr);
+		return 0;
 	}
 
-	return 0;
+	return walk_s1(vcpu, wi, wr, va);
 }
 
 struct desc_match {
-- 
2.47.3

