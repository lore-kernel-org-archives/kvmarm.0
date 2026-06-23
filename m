Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E9938B7BA
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240126; cv=none; b=N/YRoRG+khRb19UrHqfvTahLRPZ7VTHYJ4+h2Xhe5JnqShNaGSkZ5L80TCmmOs6qqvStY/z7keHAjvoKidjuAaYjAFxZ5lTXCJfRxIbugLQ2W4eq133rp04eJbp2ZxFJXj0nzt9C88z0ojrhTCphFweHopbWqV7bL9WmkbZlam0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240126; c=relaxed/simple;
	bh=VWk/3oo4MC6hfXKIuACZ9bKcStC4CZ8DKT7K7GQENnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dauarvy2F/JHwV5JY3eR/qS9jVo5uUKSr4eoRchaasb9BTg9uH7YeCkWR0UlBVFyjKuzlnndeOf/fnkaudpxx/E3NvLC1Kl8UYTPqpQzDMcyWmrnV7LgEyT4dE6VEk9P99B7RLi/GC3itnzFHe00jsGzzNIa6LNH9EfIdZGjagM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYcQ02MR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYcQ02MR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E151F00AC4;
	Tue, 23 Jun 2026 18:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240125;
	bh=V8CbiSl3pCevUkPEiGd8MhsOE49pKegQKqBZsdJoYss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYcQ02MRcTM95obYmJ8SN4q3UbqvKW2B1avfQ1IYHaBhEvLQrHj5RNScED021opls
	 c3WbF9Y8iUbXo84xbTkw/I1B/hoQCfMizaCa/haseArJeS/QCk2NrTOIE1VmWTGhOK
	 vyzfxS8D1MDT5tQ+KF3ZJdpncq3OR8LHmJfH2vLYcfg0XoLxvk9kjLLOR8D28aZYJi
	 4HQ7GztplvdQI1e4NsEC4gpt4vUR3FkQsMbCbUGOIzNt8zrU97duT3IYGVOLIhOgPt
	 nZnFlHBDN40vQ7N/zWglvt/iGjW42zgoiP1JBZVpnYj4EiWvE2H9iWkOuqonEghYP4
	 bc12F3FeX4kiQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 02/22] KVM: arm64: nv: Consolidate computation of stage-2 permissions
Date: Tue, 23 Jun 2026 11:41:41 -0700
Message-ID: <20260623184201.1518871-3-oupton@kernel.org>
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

Computing the output permissions from a translation requires
contextualization, as fields in the descriptors may change depending on
the MMU context. Centralize the computation of stage-2 permissions
within the table walk rather as opposed to inspecting the descriptor in
the case of pX and uX permissions.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h  | 42 ++++++++--------------------
 arch/arm64/include/asm/kvm_pgtable.h |  5 ++--
 arch/arm64/kvm/nested.c              | 33 ++++++++++++++++++++--
 3 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index cbdaaa2a2903..aa27f12cf2d4 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -87,13 +87,15 @@ extern void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu);
 extern void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu);
 
 struct kvm_s2_trans {
-	phys_addr_t output;
-	unsigned long block_size;
-	bool writable;
-	bool readable;
-	int level;
-	u32 esr;
-	u64 desc;
+	u64		desc;
+	phys_addr_t	output;
+	unsigned long	block_size;
+	int		level;
+	u32		esr;
+	bool		writable;
+	bool		readable;
+	bool		px;
+	bool		ux;
 };
 
 static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
@@ -129,34 +131,12 @@ static inline bool kvm_has_xnx(struct kvm *kvm)
 
 static inline bool kvm_s2_trans_exec_el0(struct kvm *kvm, struct kvm_s2_trans *trans)
 {
-	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, trans->desc);
-
-	if (!kvm_has_xnx(kvm))
-		xn &= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10);
-
-	switch (xn) {
-	case 0b00:
-	case 0b01:
-		return true;
-	default:
-		return false;
-	}
+	return trans->ux;
 }
 
 static inline bool kvm_s2_trans_exec_el1(struct kvm *kvm, struct kvm_s2_trans *trans)
 {
-	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, trans->desc);
-
-	if (!kvm_has_xnx(kvm))
-		xn &= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10);
-
-	switch (xn) {
-	case 0b00:
-	case 0b11:
-		return true;
-	default:
-		return false;
-	}
+	return trans->px;
 }
 
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..22aeb2ed18d1 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -79,6 +79,8 @@ typedef u64 kvm_pte_t;
 #define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
 #define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
 #define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R |	\
+					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
 #define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
 #define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
 #define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
@@ -95,8 +97,7 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
-#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
-					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
+#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP |	\
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
 /* pKVM invalid pte encodings */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9e60c7c822ae..c9300703bd0d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -241,6 +241,36 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
 	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
 }
 
+static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
+				   struct s2_walk_step *ws, struct kvm_s2_trans *trans)
+{
+	u8 s2ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S2_S2AP, ws->desc);
+	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, ws->desc);
+
+	if (!kvm_has_xnx(vcpu->kvm))
+		xn &= 0b10;
+
+	switch (xn) {
+	case 0b00:
+		trans->px = trans->ux = true;
+		break;
+	case 0b01:
+		trans->px = false;
+		trans->ux = true;
+		break;
+	case 0b10:
+		trans->px = trans->ux = false;
+		break;
+	case 0b11:
+		trans->px = true;
+		trans->ux = false;
+		break;
+	}
+
+	trans->readable = s2ap & BIT(0);
+	trans->writable = s2ap & BIT(1);
+}
+
 /*
  * This is essentially a C-version of the pseudo code from the ARM ARM
  * AArch64.TranslationTableWalk  function.  I strongly recommend looking at
@@ -382,8 +412,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	out->output = (ws.desc & GENMASK_ULL(47, addr_bottom)) |
 		      (ipa & GENMASK_ULL(addr_bottom - 1, 0));
 	out->block_size = 1UL << ((3 - ws.level) * stride + wi->pgshift);
-	out->readable = ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
-	out->writable = ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+	compute_s2_permissions(vcpu, wi, &ws, out);
 	out->level = ws.level;
 	out->desc = ws.desc;
 	return 0;
-- 
2.47.3

