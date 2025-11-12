Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750C935388A
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972451; cv=none; b=ChYrqVFFNJdXsHjZ8oDTlfF7xgajjDYeAXO61jPBK341L/5suI3wxM+YgeQJIjKaymEM90kGluNmoTw1w64gmCnhsIYtRC2qKH2zIW7kMdUKd+cIj1UGwHyEidBHExdQbXESmN47wCY9+HS4A9wOaZ7M3SEdZx8B98V21X1eWxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972451; c=relaxed/simple;
	bh=c+7ijd3XehpA5TcOC9WUGtH4UCbxLXxr9wnUGamEeV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhVIeVbKIsNb2KwveLAdDUn9pBNQzifWGxlFgXiBoCSwrXOKqzAJMEBemRcmamkK5xhZnkXzNR7nNauHhtwB4QVjkcBEvawv7Adi2ICUiVy9Ws50Lj9zblJHXBaV+7i+8flqb8cKym/8Su85itoAxInkAfkh4CHQHypwK7GSmMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNULLzPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNULLzPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5642C4CEF1;
	Wed, 12 Nov 2025 18:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972450;
	bh=c+7ijd3XehpA5TcOC9WUGtH4UCbxLXxr9wnUGamEeV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNULLzPAPcr+AxsZJZg8CzLmt+ClkTLbPV9TZv7g9uXxj7iqEbXsDVtK7AMDXeuFP
	 V2ghUNnnySjiSNm21VLnHbYzkqxqMGKkEN7VaaodJHwpP8zAnay/Cx41LRwcJVZaSu
	 OqBdEDE/pEvOITWVtase5Xvo4UE6S5sgt/7urag8TRQ59EDjAkm8Nhc5/sGYzx6FSm
	 8Q4k8VNaqBbbhb3vZZvZJ7Tzfja1w6g7d42Dk7cdV3L70NvLfae+e1I+vSexlab27r
	 ARIt+WCzcXc7K5QuzS/eNWj1lysUdXIoLkIpOLdFFemNSw+Z6mml6IP5BaaO/h40MY
	 sZNFx0UWWu0zw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 02/12] KVM: arm64: Add support for FEAT_XNX stage-2 permissions
Date: Wed, 12 Nov 2025 10:33:56 -0800
Message-ID: <20251112183406.2118981-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112183406.2118981-1-oupton@kernel.org>
References: <20251112183406.2118981-1-oupton@kernel.org>
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
 arch/arm64/include/asm/kvm_pgtable.h | 17 +++++----
 arch/arm64/kvm/hyp/pgtable.c         | 54 ++++++++++++++++++++++++----
 2 files changed, 58 insertions(+), 13 deletions(-)

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
index c351b4abd5db..8c813bf70b38 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -661,11 +661,36 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 
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
@@ -685,8 +710,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 		attr = KVM_S2_MEMATTR(pgt, NORMAL);
 	}
 
-	if (!(prot & KVM_PGTABLE_PROT_X))
-		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
+	r = stage2_set_xn_attr(prot, &attr);
+	if (r)
+		return r;
 
 	if (prot & KVM_PGTABLE_PROT_R)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
@@ -715,8 +741,19 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
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
@@ -1293,6 +1330,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	int ret;
 	s8 level;
 	kvm_pte_t set = 0, clr = 0;
+	kvm_pte_t xn;
 
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

