Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37C83ACA42
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805764; cv=none; b=qvz4kdF23x4//0tSe2HET3Doy0VFeiHuNdrmITHYPgaiCPVeDG6CDfZlA167yYEKo3tYmMUa4GF7Wzu9rO90FT4WREeQ+kPxRedlpHbTWAsjPyrJBfOBKySkmamrhAeQwb1WVaiXaLOYW0xcvIKw94YIM3JnbXLOlcZqFNfXrR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805764; c=relaxed/simple;
	bh=EFWfxpnjqxfetJ7tbsDK4e4T3YbFsx9lD0banru7E9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mGtV58wrtaCB4fNf3HVBCPyOi9N3qgEz70AmNHfJmWsGkhm+RHx9iCy3U/YDa4Y9cuhoxUXcNjIMCDG+xXeVnQTVwHusXtdLLdexVqss1d3NUpgQbOyXoBlnYh+4FB/ZU+r1wkXv8aciMes0nf5k65RQeLO0fK1Nz/b/FM8ZogY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l9dO+SCd; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l9dO+SCd"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-661ad73d41eso1232323a12.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805758; x=1773410558; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJF5wl0idW47D9GCd6ULDgMs+egUo0RLejd/z4xiKdQ=;
        b=l9dO+SCdlvKSYQpOHliBgTfmf+gQUe9Tu+ttIEMtTpUlvIGQJYq0l8PpYXkR7mlykS
         zG85W4tSHdEf4AOR8uxz0YLA7RhLrRZ3XCbW7i1S/9CJlMNh9Fa+v6nmzWflHl+huOJw
         HBR8k7crd4VYkcTVF632IfpkQwhRlePbXsyuXU6euplOLhzqLdaPBlh+/Q6KwCHe3Irv
         7CRGrfkkBBP4mHU6HNIGPt7Z60SqiBCI0rhrk4+XXLnh/3tBKWzvEO80Y3h8x3YcmlzR
         Y0WzYP+eCIoXJ8Tm+BNMpelKsekm9CZVIuuVSNRd3tULJEyAeaaXkSuBOMCvI8IdwjkD
         Z2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805758; x=1773410558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJF5wl0idW47D9GCd6ULDgMs+egUo0RLejd/z4xiKdQ=;
        b=bfXEamD+bTzRwifZhQ4cUR5uRXDrDZwiB7J5V8RbmoyEHLukzfF+as0Nbtg5BtL7VV
         dLqaZvKzw+hdgDiXhjn5eVp42NYmeu97WUq6Bf9XKbFpXPEFWBxUz4SbB2yzV+NpFZlG
         btsW/DUW940ccC+rbTJR09QjuXzcgFNdevy3JWyWVfIxh1h1c81/9FYVQ98Ck1lkocM3
         GYq96qk2aa8hz6rwWRsYFSwpsgLQZSSJtnSgt7/N6/Cy1EyHMSE0/RydMn5pK2YcsTxH
         s68TBVscCzAUzKVLFhXr2Ys4ikiQasjFRO81rDf3ybci4PcSxqgOvEdSqEvC6UBLFCwi
         /W+w==
X-Forwarded-Encrypted: i=1; AJvYcCXNVK4CqRF40dic+SyiQImFIXnHexoov8QnacxrmyD8TM4kC7gqlNQRlYypVtuSsnkwQJGmJkY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIYvrzlAZhK1u7KcHVJq5ZMibGsqtT9eBSm5zI3bBgqe+x6d4c
	3lTJVpOlONDRY5ps5/3ODtYlIDf5jiB7p/zl9Lk7OVcehpVePsCkY5anzFDS8MrBt3c4c1Gzd3v
	O7A==
X-Received: from edai24.prod.google.com ([2002:a05:6402:f18:b0:660:af3b:aad3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4303:b0:65a:3526:50e0
 with SMTP id 4fb4d7f45d1cf-6619d4ff435mr1156859a12.30.1772805757678; Fri, 06
 Mar 2026 06:02:37 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:22 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-4-tabba@google.com>
Subject: [PATCH v1 03/13] KVM: arm64: Extract PFN resolution in user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Extract the section of code responsible for pinning the physical page
frame number (PFN) backing the faulting IPA into a new helper,
kvm_s2_fault_pin_pfn().

This helper encapsulates the critical section where the mmap_read_lock
is held, the VMA is looked up, the mmu invalidate sequence is sampled,
and the PFN is ultimately resolved via __kvm_faultin_pfn(). It also
handles the early exits for hardware poisoned pages and noslot PFNs.

By isolating this region, we can begin to organize the state variables
required for PFN resolution into the kvm_s2_fault struct, clearing out
a significant amount of local variable clutter from user_mem_abort().

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 105 ++++++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 419b793c5891..d56c6422ca5f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1740,55 +1740,11 @@ struct kvm_s2_fault {
 	vm_flags_t vm_flags;
 };
 
-static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-			  struct kvm_s2_trans *nested,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  bool fault_is_perm)
+static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 {
-	int ret = 0;
-	struct kvm_s2_fault fault_data = {
-		.vcpu = vcpu,
-		.fault_ipa = fault_ipa,
-		.nested = nested,
-		.memslot = memslot,
-		.hva = hva,
-		.fault_is_perm = fault_is_perm,
-		.ipa = fault_ipa,
-		.logging_active = memslot_is_logging(memslot),
-		.force_pte = memslot_is_logging(memslot),
-		.s2_force_noncacheable = false,
-		.vfio_allow_any_uc = false,
-		.prot = KVM_PGTABLE_PROT_R,
-	};
-	struct kvm_s2_fault *fault = &fault_data;
-	struct kvm *kvm = vcpu->kvm;
 	struct vm_area_struct *vma;
-	void *memcache;
-	struct kvm_pgtable *pgt;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
+	struct kvm *kvm = fault->vcpu->kvm;
 
-	if (fault->fault_is_perm)
-		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
-	fault->write_fault = kvm_is_write_fault(fault->vcpu);
-	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
-	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
-
-	/*
-	 * Permission faults just need to update the existing leaf entry,
-	 * and so normally don't require allocations from the memcache. The
-	 * only exception to this is when dirty logging is enabled at runtime
-	 * and a write fault needs to collapse a block entry into a table.
-	 */
-	fault->topup_memcache = !fault->fault_is_perm ||
-				(fault->logging_active && fault->write_fault);
-	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
-	if (ret)
-		return ret;
-
-	/*
-	 * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
-	 * get block mapping for device MMIO region.
-	 */
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, fault->hva);
 	if (unlikely(!vma)) {
@@ -1842,6 +1798,63 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (is_error_noslot_pfn(fault->pfn))
 		return -EFAULT;
 
+	return 1;
+}
+
+static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			  struct kvm_s2_trans *nested,
+			  struct kvm_memory_slot *memslot, unsigned long hva,
+			  bool fault_is_perm)
+{
+	int ret = 0;
+	struct kvm_s2_fault fault_data = {
+		.vcpu = vcpu,
+		.fault_ipa = fault_ipa,
+		.nested = nested,
+		.memslot = memslot,
+		.hva = hva,
+		.fault_is_perm = fault_is_perm,
+		.ipa = fault_ipa,
+		.logging_active = memslot_is_logging(memslot),
+		.force_pte = memslot_is_logging(memslot),
+		.s2_force_noncacheable = false,
+		.vfio_allow_any_uc = false,
+		.prot = KVM_PGTABLE_PROT_R,
+	};
+	struct kvm_s2_fault *fault = &fault_data;
+	struct kvm *kvm = vcpu->kvm;
+	void *memcache;
+	struct kvm_pgtable *pgt;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
+
+	if (fault->fault_is_perm)
+		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
+	fault->write_fault = kvm_is_write_fault(fault->vcpu);
+	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
+	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
+
+	/*
+	 * Permission faults just need to update the existing leaf entry,
+	 * and so normally don't require allocations from the memcache. The
+	 * only exception to this is when dirty logging is enabled at runtime
+	 * and a write fault needs to collapse a block entry into a table.
+	 */
+	fault->topup_memcache = !fault->fault_is_perm ||
+				(fault->logging_active && fault->write_fault);
+	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
+	if (ret)
+		return ret;
+
+	/*
+	 * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
+	 * get block mapping for device MMIO region.
+	 */
+	ret = kvm_s2_fault_pin_pfn(fault);
+	if (ret != 1)
+		return ret;
+
+	ret = 0;
+
 	/*
 	 * Check if this is non-struct fault->page memory PFN, and cannot support
 	 * CMOs. It could potentially be unsafe to access as cacheable.
-- 
2.53.0.473.g4a7958ca14-goog

