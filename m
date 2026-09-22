Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06EF3C1D78
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082511; cv=none; b=WZn7mOawNiBQD4L3m5MIkJKtGRCCxI+b6vmP3DszKZgQQtkDS2kN7jmNO8SvX8vBKi6QbhQVq+dS1LYjzWXCnrVXyvfaTb9tu7fX3XxYKPvzr7Hl9onCKsRlOQ6HNj0IKpEoDXssedXIFoYk/AbUkAT6Qgam9S5MEuDV9BmX3KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082511; c=relaxed/simple;
	bh=1k9aPgIrhWVz7kyI+MbaJLM88saK4NRG7GeaISzNm84=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=itBQB30qLynVLyhkQmRJaaVf8I7pGyirh0alOO7uZsKeei++o250Whmx0ieOnZOaFmi7r1TIkYljbKTYvTNZk0tXyGdBpGSmVuPo0GLOfGZrWOWjQsKd9tzCrZ+K90XD29ZZuuTaPwvz/iSuYPu+KdZQ6jZ7MVmHu5N1lYDO7cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kqUbS9+I; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kqUbS9+I"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e6862e924so30298565e9.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082508; x=1790687308; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NiGAzCGrKNlXiWDXOy73S85m7H6z+aGxCerVB6vGef0=;
        b=kqUbS9+IldFnX8rhRL8uabgwkAFVLKcMTRe1RuFaGuiYoBNXCtLClJ9P5I2FyjzfHR
         0RbjqDYoRvM8j3qPD9kvLnblr9RyvF6Jl9RlhLToLDLQZU8tnyj73YCfy/13xqgq6yn8
         BnIO4+wEyy9w6PXW6iBELs9X+HwT4gWV070uo8tq844IbU4Cp92MDCBexlXkQujMbIrf
         aZCxMJBexyukjB59d1e+ywgTSlyDiLm6FdAcB5/yc3lxkU0uAlSKVTwoHUwyZyM0rkDS
         GIgUb3NsJlPOQN8MToJfoo6pHCX756Qi3ia8rex94JRIYFc9VmYMsHHEEE2N/Ltn+JHq
         jv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082508; x=1790687308;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NiGAzCGrKNlXiWDXOy73S85m7H6z+aGxCerVB6vGef0=;
        b=FfIQIxDuPTYAcEr5CpDLN1Da7j++wN0NAfS0gBC3GJ8KvyOBiPJ8gpI6IFdWrRJW0B
         TAW9hkCn2uRTdJVWxjFWKWnfvtD64SxnEgwPr/LGbOaol2/RM8yHdrF7xd1Oh0UjLP+F
         Ylx+9YM2DYCK0neuGkyC1fJ1VU5Xq7XpMuxrHOLWzIen2XuRSN8q09agnjPX3m/yy1Dc
         Npntuuy1q5kM7zIklU/nI0+gNhT/mqlvIwZA441fjpqVlbgOqmU+24pSId11rzRxBV15
         xQFo9HWBEtQCtzjAeIv4w3M5u1O9+FSakWgrVCOFATS+i0ZqXO6KWzanX5FJSTfzaiYi
         f7Dg==
X-Forwarded-Encrypted: i=1; AKwUvByKX36JihN5u/OuwrFi76PBVUSZcYaFb+MRmveu5sDRyCDaAvjKmv6ZIg6jQJI4gIyqrSRT0uo=@lists.linux.dev
X-Gm-Message-State: AFuF++mcNV6IM2iU/DK/K9zKndZQQnAqrVVkT1shYhVRfhTvP4tep16/
	rN5tMhPvJ0UCnB9eOfl6BDNHOMeAmY1EjdXTZ7SJjNpYG7eGiTW4YwrSA35xRGy5ZZ/e6J9zpE2
	+4GKMjObmMSkfBdzh22F8bQ==
X-Received: from wmoo4.prod.google.com ([2002:a05:600d:104:b0:49c:d71f:ccaa])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6612:b0:49f:dc8e:6211 with SMTP id 5b1f17b1804b1-49fdc8e6c34mr15259695e9.16.1790082507824;
 Tue, 22 Sep 2026 06:08:27 -0700 (PDT)
Date: Tue, 22 Sep 2026 14:08:17 +0100
In-Reply-To: <20260922130821.1666713-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922130821.1666713-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922130821.1666713-3-vdonnefort@google.com>
Subject: [PATCH v1 2/6] KVM: arm64: Pass kvm_s2_fault_desc to fault_supports_stage2_huge_mapping()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Pass the fault descriptor to fault_supports_stage2_huge_mapping() instead
of passing memslot and hva separately so it can access other s2fd
members such as vcpu.

No functional change intended.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/mmu.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4a..9dfaf4f277b5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1353,12 +1353,21 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }
 
-static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
-					       unsigned long hva,
+struct kvm_s2_fault_desc {
+	struct kvm_vcpu		*vcpu;
+	phys_addr_t		fault_ipa;
+	struct kvm_s2_trans	*nested;
+	struct kvm_memory_slot	*memslot;
+	unsigned long		hva;
+};
+
+static bool fault_supports_stage2_huge_mapping(const struct kvm_s2_fault_desc *s2fd,
 					       unsigned long map_size)
 {
-	gpa_t gpa_start;
+	struct kvm_memory_slot *memslot = s2fd->memslot;
+	unsigned long hva = s2fd->hva;
 	hva_t uaddr_start, uaddr_end;
+	gpa_t gpa_start;
 	size_t size;
 
 	/* The memslot and the VMA are guaranteed to be aligned to PAGE_SIZE */
@@ -1427,9 +1436,9 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  * Returns the size of the mapping.
  */
 static long
-transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			    unsigned long hva, kvm_pfn_t *pfnp, gfn_t *gfnp)
+transparent_hugepage_adjust(const struct kvm_s2_fault_desc *s2fd, kvm_pfn_t *pfnp, gfn_t *gfnp)
 {
+	struct kvm *kvm = s2fd->vcpu->kvm;
 	kvm_pfn_t pfn = *pfnp;
 	gfn_t gfn = *gfnp;
 
@@ -1438,8 +1447,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
-		int sz = get_user_mapping_size(kvm, hva);
+	if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE)) {
+		int sz = get_user_mapping_size(kvm, s2fd->hva);
 
 		if (sz < 0)
 			return sz;
@@ -1597,14 +1606,6 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
 	return prot;
 }
 
-struct kvm_s2_fault_desc {
-	struct kvm_vcpu		*vcpu;
-	phys_addr_t		fault_ipa;
-	struct kvm_s2_trans	*nested;
-	struct kvm_memory_slot	*memslot;
-	unsigned long		hva;
-};
-
 static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool write_fault, exec_fault;
@@ -1791,7 +1792,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PUD_SIZE))
+		if (fault_supports_stage2_huge_mapping(s2fd, PUD_SIZE))
 			break;
 		fallthrough;
 #endif
@@ -1799,7 +1800,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 		vma_shift = PMD_SHIFT;
 		fallthrough;
 	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PMD_SIZE))
+		if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE))
 			break;
 		fallthrough;
 	case CONT_PTE_SHIFT:
@@ -2049,9 +2050,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		if (perm_fault_granule > PAGE_SIZE) {
 			mapping_size = perm_fault_granule;
 		} else {
-			mapping_size = transparent_hugepage_adjust(kvm, s2fd->memslot,
-								   s2fd->hva, &pfn,
-								   &gfn);
+			mapping_size = transparent_hugepage_adjust(s2fd, &pfn, &gfn);
 			if (mapping_size < 0) {
 				ret = mapping_size;
 				goto out_unlock;
-- 
2.55.0.1082.g2b9226bbc0-goog

