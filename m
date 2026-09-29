Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5967E51AFE9
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 10:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678246; cv=none; b=u72yRXPzAZ1Zw41PQD0AWCuLKqxiqzGiyWhjD9X3qDAjyrgQ1QzPgI9Xy6q0GS3Ec7eVq8WCDHyc//78VfVzEtMr0wANULOq5tmt5MS0/orTgOrdcyQ+2FXIV5M2bVGWvJ68es5u6dsV5f6vOld5TiyRSva+q6SjrqYP7AHig+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678246; c=relaxed/simple;
	bh=prg2yyZtoyCOPNteSz6kycE67/+Tt9YkliRbdRWoXvY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vCmXePfnTQAQlYecKSqYmE1EjoSHaPf/y8Ix3XYpF7YZ8WV7Ntxj7C9hWPwwAjgJLhxpHHGd75LNplAiyPVfo5iV15VMh86RTdea7hjBwd5cvHIzaog54VQp6H05nW8G+Z7mtl2Ur/o/Ynpz+6TVe1GbwqdExLzRr3a2QcC/4d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=d2jU1r6N; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="d2jU1r6N"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+p67nF0vU9SDVoCbM28Chml69/EYcNQ7SwyEdJPNe5I=;
	b=d2jU1r6NCztnjuRm18UqYqdywMMdUj5kzRV4m/hm+btKKdEXhuQ3pe2TFYmI32X61+RA8OoAz
	8r9dEzsvIw8hWNwScuN92X1bFXbVKkaa/oTEHGniD7lepNuJxoTh6UbYOXziCs4LijQRxP2nnPz
	pvmPjtGbX2f5rYfZVCUizb4=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hvDnY0R3MzLlTC;
	Tue, 29 Sep 2026 18:24:49 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E6F94056C;
	Tue, 29 Sep 2026 18:36:58 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 18:36:57 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<zhengtian10@huawei.com>, <leo.bras@arm.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<yangjinqian1@huawei.com>, <caijian11@h-partners.com>,
	<liuyonglong@huawei.com>, <tangchengchang@huawei.com>,
	<yezhenyu2@huawei.com>, <yubihong@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>,
	<mark.rutland@arm.com>, <seanjc@google.com>, <rdunlap@infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<skhan@linuxfoundation.org>
Subject: [PATCH v5 02/15] KVM: arm64: Add KVM_PGTABLE_PROT_DIRTY
Date: Tue, 29 Sep 2026 18:36:42 +0800
Message-ID: <20260929103655.85107-3-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260929103655.85107-1-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)

From: Leonardo Bras <leo.bras@arm.com>

Second step of changing the encoding for the Stage2 PTE descriptor,
introduce the concept of dirty page, so we can have a writable but not
dirty (WC) page, and a writable and dirty (WD) page.

With the write permission carried by DBM and the dirty state by
S2AP[1], the descriptor encodes three states, which the rest of this
series builds on and which are valid regardless of whether hardware
dirty management (FEAT_HAFDBS) is enabled:

  RO (DBM=0, S2AP[1]=0)  read-only, write -> permission fault
  WC (DBM=1, S2AP[1]=0)  writable-clean: with HD=1 hardware promotes
                         it to dirty on write with no fault, with
                         HD=0 the write faults and software installs
                         it dirty
  WD (DBM=1, S2AP[1]=1)  writable-dirty, writes do not fault

When HD is clear, DBM is ignored and S2AP[1] alone controls write
permission. A WC entry is therefore read-only, so writable pages must
be mapped WD.

On the fault paths, the two bits feed different consumers. The host
folio is marked dirty whenever the mapping grants write permission.
This is required by the kvm_release_faultin_page() contract: a WC
mapping can be promoted to dirty by hardware without a VM exit, so
releasing the folio clean could lose a guest write at reclaim.
mark_page_dirty_in_slot(), which fills the dirty bitmap, is by
contrast only called for mappings installed dirty - otherwise
pre-copy would treat every writable page as dirty.

Link: https://lore.kernel.org/all/20260901171558.2674031-3-leo.bras@arm.com/
Signed-off-by: Leonardo Bras <leo.bras@arm.com>
[zhengtian: split the folio and dirty-bitmap accounts on the fault paths]
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  9 ++++---
 arch/arm64/kvm/hyp/pgtable.c         | 23 +++++++++++++-----
 arch/arm64/kvm/mmu.c                 | 36 ++++++++++++++++++++--------
 arch/arm64/kvm/ptdump.c              |  6 +++++
 4 files changed, 55 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 37baa86d6fd8..379031c74cbc 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -265,6 +265,7 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_X:		Privileged and unprivileged execute permission.
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
+ * @KVM_PGTABLE_PROT_DIRTY:	Dirty attribute.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
  * @KVM_PGTABLE_PROT_NORMAL_NC:	Normal noncacheable attributes.
  * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
@@ -279,9 +280,10 @@ enum kvm_pgtable_prot {
 						  KVM_PGTABLE_PROT_UX,
 	KVM_PGTABLE_PROT_W			= BIT(2),
 	KVM_PGTABLE_PROT_R			= BIT(3),
+	KVM_PGTABLE_PROT_DIRTY			= BIT(4),

-	KVM_PGTABLE_PROT_DEVICE			= BIT(4),
-	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(5),
+	KVM_PGTABLE_PROT_DEVICE			= BIT(5),
+	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(6),

 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
@@ -289,7 +291,8 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_SW3			= BIT(58),
 };

-#define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
+#define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W | \
+				 KVM_PGTABLE_PROT_DIRTY)
 #define KVM_PGTABLE_PROT_RWX	(KVM_PGTABLE_PROT_RW | KVM_PGTABLE_PROT_X)

 #define PKVM_HOST_MEM_PROT	KVM_PGTABLE_PROT_RWX
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 50f4d3a74f77..357b06648418 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -731,8 +731,12 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	if (prot & KVM_PGTABLE_PROT_R)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;

-	if (prot & KVM_PGTABLE_PROT_W)
-		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+	if (prot & KVM_PGTABLE_PROT_W) {
+		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+
+		if (prot & KVM_PGTABLE_PROT_DIRTY)
+			attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+	}

 	if (!kvm_lpa2_is_enabled())
 		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
@@ -753,9 +757,13 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)

 	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R)
 		prot |= KVM_PGTABLE_PROT_R;
-	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
+	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM) {
 		prot |= KVM_PGTABLE_PROT_W;

+		if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
+			prot |= KVM_PGTABLE_PROT_DIRTY;
+	}
+
 	switch (FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, pte)) {
 	case 0b00:
 		prot |= KVM_PGTABLE_PROT_PX | KVM_PGTABLE_PROT_UX;
@@ -1288,7 +1296,6 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
-					KVM_PTE_LEAF_ATTR_HI_S2_DBM |
 					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
 					NULL, NULL,
 					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
@@ -1368,8 +1375,12 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_R)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;

-	if (prot & KVM_PGTABLE_PROT_W)
-		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+	if (prot & KVM_PGTABLE_PROT_W) {
+		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+
+		if (prot & KVM_PGTABLE_PROT_DIRTY)
+			set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+	}

 	if (prot & KVM_PGTABLE_PROT_X) {
 		ret = stage2_set_xn_attr(prot, &xn);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2d44cd6a5aed..698a87e85a6d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1221,7 +1221,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	struct kvm_pgtable *pgt = mmu->pgt;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
 				     KVM_PGTABLE_PROT_R |
-				     (writable ? KVM_PGTABLE_PROT_W : 0);
+				     (writable ?
+				      (KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY) :
+				      0);

 	if (is_protected_kvm_enabled())
 		return -EPERM;
@@ -1587,7 +1589,7 @@ static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nest
 						       enum kvm_pgtable_prot prot)
 {
 	if (!kvm_s2_trans_writable(nested))
-		prot &= ~KVM_PGTABLE_PROT_W;
+		prot &= ~(KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY);
 	if (!kvm_s2_trans_readable(nested))
 		prot &= ~KVM_PGTABLE_PROT_R;

@@ -1658,7 +1660,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	}

 	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
-		prot |= KVM_PGTABLE_PROT_W;
+		prot |= KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY;

 	if (s2fd->nested)
 		prot = adjust_nested_fault_perms(s2fd->nested, prot);
@@ -1690,10 +1692,17 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	}

 out_unlock:
+	/*
+	 * Dirty the folio for any write-permitting mapping: hardware can
+	 * promote a writable-clean entry to writable-dirty without a VM
+	 * exit, so a clean release could lose a guest write at reclaim.
+	 * The dirty bitmap is only marked for mappings installed dirty,
+	 * or pre-copy would treat every writable page as dirty.
+	 */
 	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
 	kvm_fault_unlock(kvm);

-	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
+	if ((prot & KVM_PGTABLE_PROT_DIRTY) && !ret)
 		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);

 	return ret != -EAGAIN ? ret : 0;
@@ -1993,11 +2002,14 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,

 	*prot = KVM_PGTABLE_PROT_R;

-	if (s2vi->map_writable && (s2vi->device ||
-				   !memslot_is_logging(s2fd->memslot) ||
-				   kvm_is_write_fault(s2fd->vcpu)))
+	if (s2vi->map_writable) {
 		*prot |= KVM_PGTABLE_PROT_W;

+		if (s2vi->device || !memslot_is_logging(s2fd->memslot) ||
+		    kvm_is_write_fault(s2fd->vcpu))
+			*prot |= KVM_PGTABLE_PROT_DIRTY;
+	}
+
 	if (s2fd->nested)
 		*prot = adjust_nested_fault_perms(s2fd->nested, *prot);

@@ -2028,7 +2040,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 			    void *memcache)
 {
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
-	bool writable = prot & KVM_PGTABLE_PROT_W;
+	bool dirty = prot & KVM_PGTABLE_PROT_DIRTY;
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	struct kvm_pgtable *pgt;
 	long perm_fault_granule;
@@ -2091,7 +2103,11 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	}

 out_unlock:
-	kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
+	/*
+	 * Speculative folio dirtying: W, not DIRTY, per the contract
+	 * documented in kvm_release_faultin_page().
+	 */
+	kvm_release_faultin_page(kvm, s2vi->page, !!ret, prot & KVM_PGTABLE_PROT_W);
 	kvm_fault_unlock(kvm);

 	/*
@@ -2099,7 +2115,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	 * making sure we adjust the canonical IPA if the mapping size has
 	 * been updated (via a THP upgrade, for example).
 	 */
-	if (writable && !ret) {
+	if (dirty && !ret) {
 		phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
 		ipa &= ~(mapping_size - 1);
 		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index b0cb8d84a9e9..a1251e252b4f 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -45,6 +45,12 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
 		.set	= "W",
 		.clear	= " ",
 	},
+	{
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
+		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
+		.set	= "D",
+		.clear	= "C",
+	},
 	{
 		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
 		.val	= 0b00UL << __bf_shf(KVM_PTE_LEAF_ATTR_HI_S2_XN),
--
2.43.0

