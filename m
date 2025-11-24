Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA352D29D6
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010920; cv=none; b=MK658b8iaxO7I5l6qIUYMdB5AsyCkGY2iOviEuyNmSxSIgODioaeb9usNK00s1Mzse7aachzc8PqCQj9uHPyHFD/P0OknJWpjcrhbDA9DIcxM51tp3QKTplnte5k5KJOwsLLl35h3RuQYuYmaFkbkncIOE1AUUfSO3LqPpnPTso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010920; c=relaxed/simple;
	bh=DnUmI+5gqSb4//+MMZrWP6GRYm6f/cwHn5cJaDnFl80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSnhThN7mW89a08AABMIN9UFs2XTOUIayjZExsCe93aoWBSfPyopR1hP024vGE0i4t0GWd4VU9Ifw9GJlAJcYc3oblDu+zDacDO02Bs2YIhzbd/xJ/EbemH00a9U2wzFjOTWfH3jHtJ0oqwkWACs6m0sqOsNvfLerjTRNV18c+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HURKxMWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HURKxMWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB02FC4CEFB;
	Mon, 24 Nov 2025 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010920;
	bh=DnUmI+5gqSb4//+MMZrWP6GRYm6f/cwHn5cJaDnFl80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HURKxMWeupwzo/2okENT3ogEm9CbUqZs35o6iPQfBqDaF65BnQDC0LiH6HUYfSImg
	 J6Yrc2cUf4plsZesKd2M0VJm+tPIh322XeOUnfuiMwqI736N3VvX9RumWbThPQPz4U
	 kh62Eem85JoHI87vGkZX3jMpIkyxWkEZ4ZNqVBTj4H+bQ9B25bZzsS0HF4UrrHyLZT
	 dLOh0+qEaXIysUI0MbDwr8T+WVxP95P92TmoZalPr/O7iRXnCuqNmS59fXjJE9f4kY
	 /PkoNjvhr9VnT0PcTxOy5d6jizA6Z/OZTl8l/fz8C5r3mAUwqD6Qk8wxiGgle+DBua
	 DKZ2dBEi23DBg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 02/15] KVM: arm64: Add support for FEAT_XNX stage-2 permissions
Date: Mon, 24 Nov 2025 11:01:44 -0800
Message-ID: <20251124190158.177318-3-oupton@kernel.org>
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

FEAT_XNX adds support for encoding separate execute permissions for EL0
and EL1 at stage-2. Add support for this to the page table library,
hiding the unintuitive encoding scheme behind generic pX and uX
permission flags.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 17 ++++----
 arch/arm64/kvm/hyp/pgtable.c         | 58 ++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2888b5d03757..c72149a607d6 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -89,7 +89,7 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
 
-#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
+#define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
@@ -251,12 +251,15 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_SW3:	Software bit 3.
  */
 enum kvm_pgtable_prot {
-	KVM_PGTABLE_PROT_X			= BIT(0),
-	KVM_PGTABLE_PROT_W			= BIT(1),
-	KVM_PGTABLE_PROT_R			= BIT(2),
-
-	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
-	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
+	KVM_PGTABLE_PROT_PX			= BIT(0),
+	KVM_PGTABLE_PROT_UX			= BIT(1),
+	KVM_PGTABLE_PROT_X			= KVM_PGTABLE_PROT_PX	|
+						  KVM_PGTABLE_PROT_UX,
+	KVM_PGTABLE_PROT_W			= BIT(2),
+	KVM_PGTABLE_PROT_R			= BIT(3),
+
+	KVM_PGTABLE_PROT_DEVICE			= BIT(4),
+	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(5),
 
 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c351b4abd5db..e1d75f965027 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -661,11 +661,37 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 
 #define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
 
+static int stage2_set_xn_attr(enum kvm_pgtable_prot prot, kvm_pte_t *attr)
+{
+	bool px, ux;
+	u8 xn;
+
+	px = prot & KVM_PGTABLE_PROT_PX;
+	ux = prot & KVM_PGTABLE_PROT_UX;
+
+	if (!cpus_have_final_cap(ARM64_HAS_XNX) && px != ux)
+		return -EINVAL;
+
+	if (px && ux)
+		xn = 0b00;
+	else if (!px && ux)
+		xn = 0b01;
+	else if (!px && !ux)
+		xn = 0b10;
+	else
+		xn = 0b11;
+
+	*attr &= ~KVM_PTE_LEAF_ATTR_HI_S2_XN;
+	*attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, xn);
+	return 0;
+}
+
 static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
 				kvm_pte_t *ptep)
 {
 	kvm_pte_t attr;
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
+	int r;
 
 	switch (prot & (KVM_PGTABLE_PROT_DEVICE |
 			KVM_PGTABLE_PROT_NORMAL_NC)) {
@@ -685,8 +711,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 		attr = KVM_S2_MEMATTR(pgt, NORMAL);
 	}
 
-	if (!(prot & KVM_PGTABLE_PROT_X))
-		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
+	r = stage2_set_xn_attr(prot, &attr);
+	if (r)
+		return r;
 
 	if (prot & KVM_PGTABLE_PROT_R)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
@@ -715,8 +742,19 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
 		prot |= KVM_PGTABLE_PROT_R;
 	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
 		prot |= KVM_PGTABLE_PROT_W;
-	if (!(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN))
-		prot |= KVM_PGTABLE_PROT_X;
+
+	switch (FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, pte)) {
+	case 0b00:
+		prot |= KVM_PGTABLE_PROT_PX | KVM_PGTABLE_PROT_UX;
+		break;
+	case 0b01:
+		prot |= KVM_PGTABLE_PROT_UX;
+		break;
+	case 0b11:
+		prot |= KVM_PGTABLE_PROT_PX;
+		break;
+	default:
+	}
 
 	return prot;
 }
@@ -1290,9 +1328,9 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 				   enum kvm_pgtable_prot prot, enum kvm_pgtable_walk_flags flags)
 {
-	int ret;
+	kvm_pte_t xn = 0, set = 0, clr = 0;
 	s8 level;
-	kvm_pte_t set = 0, clr = 0;
+	int ret;
 
 	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
 		return -EINVAL;
@@ -1303,8 +1341,12 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_W)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
-	if (prot & KVM_PGTABLE_PROT_X)
-		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
+	ret = stage2_set_xn_attr(prot, &xn);
+	if (ret)
+		return ret;
+
+	set |= xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
+	clr |= ~xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
 	if (!ret || ret == -EAGAIN)
-- 
2.47.3

