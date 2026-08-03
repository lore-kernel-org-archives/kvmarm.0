Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C779E34027B
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751872; cv=none; b=NhEyVj7XTf13hZe9TN/wRsm0PcoJbTkc4xEF1dzwOe0HW9CYSclDxQ4/y696IF4csADSsoK8YN8Xtc+ctH1K5sWnSOG9Yh5LRN+dzUtw/alUSHn+aOuHFOojeWdXaX2FEtWv5p/BkpBUhubylPNgHhTTyPbDFLRM7Q4bRYA+2To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751872; c=relaxed/simple;
	bh=SjwesZRHtwFWOBzK4JMMcj/0PlqF41IjlHqjPjyx2Ug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SBb2KApVid3wGbbX6XJivhF3+4JkhwOW2218gR9GBnY0WYTyJba6byYNOUzyq0w7bKH1igcPbDS38GLl9H5PktWKcx8QHaXnIxif+CygO+6EJz1NfOtpSisjBRJO1yMim0M+X73dTtrMhg6TmsEfbmhCfcrYvfwCV2QiYmzoVi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LoY35Mg2; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LoY35Mg2"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49564d4b849so6869845e9.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751869; x=1786356669; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=reLJB9mcLy59APOd1H3LrMYSyYzRkBhNQ7m/o5SPKAo=;
        b=LoY35Mg2NBxUyGmAc6RWkrJdGY5Cl6oYL1cselqrLjZXTMxgxVFp1YRkUSxW9Es+5C
         qBbPfL1wR6laNMBTMx7OLOV4/wmNaIzuaaPeSAFzzRGhKtk03kCgBAgymVIVaqRjDRsY
         e22mjlPAdyFu7Xv4m312ct6AHZeI9cNBtgik/si8u1yKvI4JLA1T7kQcmBTZqrrWEHxQ
         4v3+d1tyoAsItguYbhlJkhjC5dKyKjHwIdkpHIN7TKaEQbwxZAchJypKUiOGdoBm5Y2G
         hubUhuz9GkcUr8AZbBB2PcZfxm6ZiuDVhDN2aKtqb6E376pbcosmCaUD9Y6a4GjZBVBw
         dfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751869; x=1786356669;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=reLJB9mcLy59APOd1H3LrMYSyYzRkBhNQ7m/o5SPKAo=;
        b=kyrav//WTcdD12M/QVeqHoP2tzjtDXdPGJPU12gbBW2lOwlK2e8QbRhQ5HckkoezGi
         Z52/FeNlAL8uCNoHm6e/JOrMaKZ/1VrOOcQdBmrO54RDa3V90Vgtx7PjtxkN9eQLvai0
         y+mEqv2KmbAwMrqgqd7aR++DA0Awp9mDfNS2rRrS+jsbRK88L4KogensPwXmk3v6eKF5
         1IRR/x6OIbK+grW4v1h9VIgAGguw7AvKSJTJfaKly+m+txVrO8rkcOMJqkRIHcb13qxH
         Qve1kYAXX8/FVfyC8M8a3eJK3Z5B1BPmLMfqMd0/JgdlcYe9L3DRKl9FX9xtiJg0uEKF
         p5JA==
X-Forwarded-Encrypted: i=1; AHgh+Rrv4/RHzucG6t4u7Xn2GavlXKDwQAD86JZ4QPXTS8KR7f3+4BAKyKMWZZ4v1u7ykz63gdH7p4Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVE3leM7wAlAa3JIOvCSHEkJq1G17E0Ys8YS2HdDnS8Tt4oGWJ
	Cm/cO0yw0yKnWJ3eTvFZ/YgS33nzALsxDdTEVAkhughvQclQh7JiK3glM7SROnTZbKMcd8LTA/E
	f66+uJERbVpbZI4RGNx1fyw==
X-Received: from wmfu14.prod.google.com ([2002:a05:600c:138e:b0:493:fb57:3896])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4454:b0:493:bd2a:93bb with SMTP id 5b1f17b1804b1-4980c64b6cdmr210376905e9.3.1785751868662;
 Mon, 03 Aug 2026 03:11:08 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:56 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-13-vdonnefort@google.com>
Subject: [PATCH 12/20] KVM: arm64: Handle huge mappings in __pkvm_host_force_reclaim_page_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs, allow
__pkvm_host_force_reclaim_page_guest() to work with PMD_SIZE mappings.
As this HVC is called from a non-preemptible context, it is not possible
to rely on the host pkvm_mappings tree to get the mapping size. Instead,
use the actual host stage-2 mapping size and compare it with the guest
stage-2.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d5ee079a5d70..47c5c6b4869e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1292,11 +1292,9 @@ static int __guest_check_transition_size(u64 phys, u64 ipa, u64 nr_pages, u64 *s
 	return 0;
 }
 
-static void hyp_poison_page(phys_addr_t phys)
+static void __hyp_poison_page(void *addr, size_t size)
 {
-	void *addr = hyp_fixmap_map(phys);
-
-	memset(addr, 0, PAGE_SIZE);
+	memset(addr, 0, size);
 	/*
 	 * Prefer kvm_flush_dcache_to_poc() over __clean_dcache_guest_page()
 	 * here as the latter may elide the CMO under the assumption that FWB
@@ -1304,19 +1302,15 @@ static void hyp_poison_page(phys_addr_t phys)
 	 * host stage-2 and would otherwise lead to a malicious host potentially
 	 * being able to read the contents of newly reclaimed guest pages.
 	 */
-	kvm_flush_dcache_to_poc(addr, PAGE_SIZE);
-	hyp_fixmap_unmap();
+	kvm_flush_dcache_to_poc(addr, size);
 }
 
 static void hyp_poison_range(phys_addr_t phys, u64 size)
 {
-	u64 offset;
-
-	for (offset = 0; offset < size; offset += PAGE_SIZE)
-		hyp_poison_page(phys + offset);
+	__apply_guest_page(__hyp_va(phys), size, __hyp_poison_page);
 }
 
-static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
+static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_hyp_vm **vm,
 				      u64 *gfn)
 {
 	enum pkvm_page_state state;
@@ -1344,34 +1338,43 @@ static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
 	if (ret)
 		return ret;
 
-	if (WARN_ON(level != KVM_PGTABLE_LAST_LEVEL))
-		return -EINVAL;
+	/* We only support either PAGE_SIZE or PMD_SIZE */
+	if (level < KVM_PGTABLE_LAST_LEVEL - 1)
+		return -E2BIG;
 
-	return host_stage2_decode_gfn_meta(pte, vm, gfn);
+	ret = host_stage2_decode_gfn_meta(pte, vm, gfn);
+	if (ret)
+		return ret;
+
+	*size = kvm_granule_size(level);
+
+	return 0;
 }
 
 int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 {
+	u64 gfn, ipa, pa, size;
 	struct pkvm_hyp_vm *vm;
-	u64 gfn, ipa, pa;
 	kvm_pte_t pte;
 	int ret;
 
-	phys &= PAGE_MASK;
-
 	hyp_spin_lock(&vm_table_lock);
 	host_lock_component();
 
-	ret = host_stage2_get_guest_info(phys, &vm, &gfn);
+	ret = host_stage2_get_guest_info(phys, &size, &vm, &gfn);
 	if (ret)
 		goto unlock_host;
 
 	ipa = hyp_pfn_to_phys(gfn);
+
 	guest_lock_component(vm);
-	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &pa);
+	ret = get_valid_guest_pte(vm, ipa, size, &pte, &pa);
 	if (ret)
 		goto unlock_guest;
 
+	phys = ALIGN_DOWN(phys, size);
+	pa = ALIGN_DOWN(pa, size);
+
 	WARN_ON(pa != phys);
 	if (guest_get_page_state(pte, ipa) != PKVM_PAGE_OWNED) {
 		ret = -EPERM;
@@ -1379,14 +1382,14 @@ int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 	}
 
 	/* We really shouldn't be allocating, so don't pass a memcache */
-	ret = kvm_pgtable_stage2_annotate(&vm->pgt, ipa, PAGE_SIZE, NULL,
+	ret = kvm_pgtable_stage2_annotate(&vm->pgt, ipa, size, NULL,
 					  KVM_GUEST_INVALID_PTE_TYPE_POISONED,
 					  0);
 	if (ret)
 		goto unlock_guest;
 
-	hyp_poison_page(phys);
-	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
+	hyp_poison_range(phys, size);
+	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HOST));
 unlock_guest:
 	guest_unlock_component(vm);
 unlock_host:
-- 
2.55.0.508.g3f0d502094-goog

