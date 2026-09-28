Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F1248F026
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589310; cv=none; b=fxBF2Zt3pZYq9BOf7h/JIucN0UHuO7gUD+bf7IbKrBpBkDnG3hrBx8VT4Woa2vHRiMNTW85nfs49DqBv68Ca65ArNrqcjQmg8y5ZW9ORQ5nhDDkxgKyeHVLK7XipuMTwCiVlEITwfthL3vRwcj0llvi103TrDGAFFjSjm9gLn54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589310; c=relaxed/simple;
	bh=P6aFaZdlkpemobce/+8rSE3rfqQ4iWcDacRHKYcZ/p4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MIsXg+Pw1+CggHEX3qZMOij3NHjj5IlMs8VbPfCQ9pJhwOElLAZww6JYrwAeHtl83z/yiM0fFtpuCpVNH00U2MJJo/0+RU7hsIlp1Dzc6Ej2Ft5FMqEJ9PFQ/uRm1pZTrz0MIK+6XvXscpH2cHE7xNHENydHpB9gWbXeEcUnCZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dj6J9Sz4; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dj6J9Sz4"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e6422198fso18677295e9.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 02:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790589307; x=1791194107; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VYaKfFIOED5JuoPKzS7izkx7Pd8mqCgQw5gWfRn6yUE=;
        b=dj6J9Sz4aGv1r1aaoxE2KjP+ZEwSgEdrd7SmrAN1hp6CPjKDFWo8lD8rqD15GlD6bV
         zGbiNhj2/+h7Bfq91sYIsdtWgkntSKlPiiJndlyDEtGN0eLHDNxwWkRxC/gYHiS4cJet
         GY6Y8BBfwMZB6JhDtV867WbLc1Qt4WPIlVlxiYi7ajOfqK53kVBKuvEkKefF6hSXfILf
         DHRaPJAi/xvaBOhxUUL/SLjhq3VrVLBb/lkLvVRH8xC3J5mlvLevhVlhQbpcfgvqkH5i
         PDi4X4rsn0i8hXuO9qVIzR0ZPXLsiR6lzFmp6wh+xZanZx2D4HIxm92NJKXvj3+TaCHM
         H7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790589307; x=1791194107;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VYaKfFIOED5JuoPKzS7izkx7Pd8mqCgQw5gWfRn6yUE=;
        b=XvgsD8nzMjnExLRoRpRdMuWGth5wPep415Basz2EmecEgnTfUNVdDoS5M6DGAVHmuZ
         IsZAiR0G/W0XAye04KCJxKttYwp/IVSH/owSL7EVjGkaUzv0t+pTt1UN2j6dWnHGPpEc
         tnD+UvQcDHYwcunAl6ibegxq02KCWtd05xFjGcO3oParQ3VccDC4ocWRA/sRvNm+krZI
         DG4kPi7lSmszsE9XQcSJVuqka8j3SXx97xVJly2VcB0LjuWy0WikMqIA+4GJM3OEuWyT
         ORD6C1BPRk5mVIMbwUPBy2hxAQluJyhU9VCW08OiZmFt/MPibJvsso0UZR+VnxGp0sZ3
         vAyw==
X-Forwarded-Encrypted: i=1; AKwUvByHGlweOSKNasX5eJGLir9mlRQox7FcefarEoQVuQcOTMwX/3imImNa8eYLZQqWecg7rjKywu4=@lists.linux.dev
X-Gm-Message-State: AFuF++lCM8cNRZsCawzU4n4SpA0r3N1z6rHM8sU00DSJmW5UWnAv0zd9
	MCMlBtkL6/F+EVZFw+np5ijTtfD4CYPnw75pKC1avOmEZNchJErtzCN4eoiroxpBqTBk/kEg4/G
	NECSfX+T7eDcUF99vXUk3MQ==
X-Received: from wmok24.prod.google.com ([2002:a05:600c:4798:b0:49b:8f1d:7d3a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b65:b0:49f:fe7e:dc61 with SMTP id 5b1f17b1804b1-49ffe7eddc0mr76091865e9.0.1790589306558;
 Mon, 28 Sep 2026 02:55:06 -0700 (PDT)
Date: Mon, 28 Sep 2026 10:54:51 +0100
In-Reply-To: <20260928095454.3255918-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260928095454.3255918-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928095454.3255918-3-vdonnefort@google.com>
Subject: [PATCH v2 2/4] KVM: arm64: Pass kvm_s2_fault_desc to fault_supports_stage2_huge_mapping()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Pass the fault descriptor to fault_supports_stage2_huge_mapping() instead
of passing memslot and hva separately so it can access other s2fd
members such as vcpu. This implies to pass that same s2fd argument to
transparent_hugepage_adjust().

No functional change intended.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/mmu.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2d44cd6a5aed..dc55b0792e34 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1362,12 +1362,21 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
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
@@ -1436,9 +1445,9 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
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
 
@@ -1447,8 +1456,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
-		int sz = get_user_mapping_size(kvm, hva);
+	if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE)) {
+		int sz = get_user_mapping_size(kvm, s2fd->hva);
 
 		if (sz < 0)
 			return sz;
@@ -1606,14 +1615,6 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
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
@@ -1800,7 +1801,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PUD_SIZE))
+		if (fault_supports_stage2_huge_mapping(s2fd, PUD_SIZE))
 			break;
 		fallthrough;
 #endif
@@ -1808,7 +1809,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 		vma_shift = PMD_SHIFT;
 		fallthrough;
 	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PMD_SIZE))
+		if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE))
 			break;
 		fallthrough;
 	case CONT_PTE_SHIFT:
@@ -2058,9 +2059,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
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
2.56.0.rc1.315.gc6ed9934b7-goog

