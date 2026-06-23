Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D589390CB5
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240129; cv=none; b=tPx3qWsrPNUl7XdX59+gfxdeH3EQ2MzeV5se3EPIBasLWbX90duMLTbN2i86tu5luER9LSIOTImIkLencT7jKNUR70GPnzcVdcgRSqAwvPdIO8h/a/VdFLxc1z4eRNCFAdy8FYWzvxSzNz66xvcbv+Fb8IDl26tZaackvnRXWts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240129; c=relaxed/simple;
	bh=AVnm7qy1PENNPG2r40gsJ94ITRDwgEw8QKhp69OnWzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Exm6NU14TQ8MLIOEFGqWBmDCNM/0fGOF+sK1ubLvSV/1W8WhOYDAvDMm37sspPcvYpIuMw7gOVPJckK0p1R+QRDa9QJS0mor3ksubYy/jSBGL5u4Z8z9BU9ZiqqtTQ5HG/xtgZQeVUW9Ngyk1rGJ7yEUIJtHLrFXlQV8QnqYPqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSrAjUUs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSrAjUUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A361F000E9;
	Tue, 23 Jun 2026 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240128;
	bh=wnODHwDY5+4OiLQCIcElhl/nfvmiZWAt+8666Y/PQ0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSrAjUUst/pm3+eWYKYcbuF13dxZlJ7EwPU85W1fKOylYo8WW9bjQzC+bjpzN9tXh
	 +9po2jVxQVTHLfbH1+jDgSQD0XKNgfr5cWtCi8csxel+aMp51ddZRv2Gdi7nu5ZbUb
	 /zjN1gWW2hQaPUNHSuAP1oALlvMecxhOVbN2T73NYWtCvPI1Pz4IeqBufU8uYF2SRC
	 gfQot8qg6E0YiIlooCZ0488FL4oUtBeuEINstV27+lU2IutjVV228S3CAooVKswNWA
	 CB+3mLHvfiyuKlaevl1L94HzudLeIL4LiPveJak0VBJ+7Jx41h0vzNp2pRxAU5yf/l
	 MVyZ+JXcjrMZA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 13/22] KVM: arm64: Set dirty state at stage-1
Date: Tue, 23 Jun 2026 11:41:52 -0700
Message-ID: <20260623184201.1518871-14-oupton@kernel.org>
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

Mark the descriptor as dirty if the permissions are sufficient to grant
write access. Note that compute_s1_direct_permissions() already
considers the DBM bit as writable.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---

Spotted right before posting:

TCR_ELx.HD is conditioned on TCR_ELx.HA being set, which is missing from
this patch. I'll address in v2.

 arch/arm64/include/asm/kvm_arm.h    |  1 +
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/at.c                 | 23 +++++++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3f9233b5a130..3f7fa9c3e9c5 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -111,6 +111,7 @@
 #define TCR_EL2_DS		(1UL << 32)
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
 #define TCR_EL2_HPD		(1 << 24)
+#define TCR_EL2_HD		(1 << 22)
 #define TCR_EL2_HA		(1 << 21)
 #define TCR_EL2_TBI		(1 << 20)
 #define TCR_EL2_PS_SHIFT	16
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 347d79fd350c..1bb070328b1c 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -316,6 +316,7 @@ struct s1_walk_info {
 	bool	     		s2;
 	bool			pa52bit;
 	bool			ha;
+	bool			hd;
 };
 
 struct s1_walk_result {
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 0218176107b5..bfba31b270a9 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -412,6 +412,10 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wi->ha &= (wi->regime == TR_EL2 ?
 		  FIELD_GET(TCR_EL2_HA, tcr) :
 		  FIELD_GET(TCR_HA, tcr));
+	wi->hd  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, DBM);
+	wi->hd &= (wi->regime == TR_EL2 ?
+		  FIELD_GET(TCR_EL2_HD, tcr) :
+		  FIELD_GET(TCR_HD, tcr));
 
 	return 0;
 
@@ -455,6 +459,22 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
 	return 0;
 }
 
+static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step *ws,
+				   struct s1_walk_result *wr, struct kvm_walk_access *access)
+{
+	bool perm = wi->as_el0 ? wr->uw : wr->pw;
+
+	switch (access->type) {
+	/* R_RKMHW */
+	case WALK_ACCESS_CMO:
+	case WALK_ACCESS_AT:
+		return false;
+	default:
+		/* R_NSXRD */
+		return access->write && wi->hd && perm;
+	}
+}
+
 static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			      struct s1_walk_step *ws, struct s1_walk_result *wr,
 			      struct kvm_walk_access *access)
@@ -467,6 +487,9 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (wi->ha)
 		new |= PTE_AF;
 
+	if (should_set_dirty_state(wi, ws, wr, access))
+		new &= ~PTE_RDONLY;
+
 	if (new == old)
 		return 0;
 
-- 
2.47.3

