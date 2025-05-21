Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB25826FDA2
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 12:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747831883; cv=none; b=Sl0Hykg3+uCUel1+195PcE1EqC5Grr8YnPiQT5wA3b5pkWb8crw+PhyyuO8cnzZuxiddhWqcwBhl7uHhJmem23EnAEo+GI0SqLWM2x6aYuG1Q/WkLRn99E5n/egUtXlnxzyqmexYtDhl+S87od+2/tguuawLRd2CahGbnr+E8Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747831883; c=relaxed/simple;
	bh=a+a+wevfv4p+oR9F4TvoqKDZh9S97aZ58/Pb/MgJ4LE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aqq9jqoHgfBvk2iiJ+kx7Q+bSMYVBjHkSr1vQnmwqkGdAtmNI7aj75jLjau9cCpYtAK5JdZzza44rvpaUFDRImQIBnUc8KmCH/JFDJmfvlAp2BfbTIuydGqc2q2adc4c/A2i0VncnR53ffK3mQQrLFzaMkIGz2rJwakdAWQdz1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oaZUQa8U; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oaZUQa8U"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a379218f6cso983211f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 05:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747831880; x=1748436680; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X5HS1MTADtzk13DQ0X8VV2YLbKPpc9rF/EQ2n6h7rrc=;
        b=oaZUQa8UZab1TwwafWbDS2yVLc5mC4V3J7KL3TOldRdHvbwiRDfLQuPnXGvxZcy63D
         u7x6lhxchBldaxHXbJFFXjP+nVPtZUYOKoeIsADMllpT12YVygS354JJA1f+5XqQSTmv
         mHfMbpyjqlMwFnB+T2jVoSdDUbhtPYYAnIL/9C1XDYUIAY+kkTiW9IgMWbXGn/hLkouj
         bNV72nXFcVOwbeaACtJV+e7wmVcufRormqAqdESuRBNQPFpPlppstO+AUEfGuUKX2QDR
         BGiiOwUpNKhnmHaHzokrQprzzD5C63n/n7BzsCpt/vXn15YmGhHX1Di0aIdG4l2I4vHS
         ip8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747831880; x=1748436680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X5HS1MTADtzk13DQ0X8VV2YLbKPpc9rF/EQ2n6h7rrc=;
        b=euIwhEX0U+egACR8M0WMVfdnbFrR9D6RvgL64oeYmoqqHFa52bX24ew9/MANbbresK
         EbbkDOEScQ8gz1hdlCJMK3m4f5XReCxcXzjNaoPyRAzJBdFbHm4qsAL79iAIIMyOeW9O
         r/oIRztmkPalzlpRTF+4JyaM6jHoFD11q+5zh5BxfIsPqE/X4AVzAzI3P5ClE4oCMU6R
         NuQRdoOLbYGWF9VDFeXpjL1jKHXRWklQuoTOR7Nji9GJfpCs7qstHsvHV2ELlUfnHUSP
         K4WiIO0VXiEbM779YcPvUkrZBSIHBrk5ujKL5MV3KeACYvpNcsRS+/x3Kq+Tf1qNiiQd
         4cKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGhKLXsB2G8DIWpgscId8e4J7b9ZWjS7QW/oWrnyYj23t/aOvegJvkhQzBUzzbm0L6V7Hzu9s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPpGsxZ0tCEbhtDEG4b/fXdaOMuAXMZJZs4CkJNYDLIdmC69EU
	7I649v3IPA3fr1TfxnR0D0IsePQXH3089jMa6QENT+YL24oLbqfinkxJhExfq96LffYcDcOjHJ0
	2408bwA2/76J0dspUCEqXOg==
X-Google-Smtp-Source: AGHT+IFn3AYms1bLCqgZr1MLXfsCQOa84rpC6sI4FufTfMFtyP2s5auBVEIM75SbnJC+p900vsvf1E3FCH0tA9RV
X-Received: from wrbei2.prod.google.com ([2002:a05:6000:4182:b0:3a3:6d1d:3837])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:186d:b0:3a3:6b0c:a8a3 with SMTP id ffacd0b85a97d-3a36b0ca9b1mr11358542f8f.17.1747831880271;
 Wed, 21 May 2025 05:51:20 -0700 (PDT)
Date: Wed, 21 May 2025 13:48:33 +0100
In-Reply-To: <20250521124834.1070650-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250521124834.1070650-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250521124834.1070650-10-vdonnefort@google.com>
Subject: [PATCH v6 09/10] KVM: arm64: Stage-2 huge mappings for np-guests
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Now np-guests hypercalls with range are supported, we can let the
hypervisor to install block mappings whenever the Stage-1 allows it,
that is when backed by either Hugetlbfs or THPs. The size of those block
mappings is limited to PMD_SIZE.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index e08c735206e0..1c18fca82209 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -166,12 +166,6 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 	return 0;
 }
 
-static bool guest_stage2_force_pte_cb(u64 addr, u64 end,
-				      enum kvm_pgtable_prot prot)
-{
-	return true;
-}
-
 static void *guest_s2_zalloc_pages_exact(size_t size)
 {
 	void *addr = hyp_alloc_pages(&current_vm->pool, get_order(size));
@@ -278,8 +272,7 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 	};
 
 	guest_lock_component(vm);
-	ret = __kvm_pgtable_stage2_init(mmu->pgt, mmu, &vm->mm_ops, 0,
-					guest_stage2_force_pte_cb);
+	ret = __kvm_pgtable_stage2_init(mmu->pgt, mmu, &vm->mm_ops, 0, NULL);
 	guest_unlock_component(vm);
 	if (ret)
 		return ret;
@@ -908,12 +901,24 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
 
 static int __guest_check_transition_size(u64 phys, u64 ipa, u64 nr_pages, u64 *size)
 {
+	size_t block_size;
+
 	if (nr_pages == 1) {
 		*size = PAGE_SIZE;
 		return 0;
 	}
 
-	return -EINVAL;
+	/* We solely support second to last level huge mapping */
+	block_size = kvm_granule_size(KVM_PGTABLE_LAST_LEVEL - 1);
+
+	if (nr_pages != block_size >> PAGE_SHIFT)
+		return -EINVAL;
+
+	if (!IS_ALIGNED(phys | ipa, block_size))
+		return -EINVAL;
+
+	*size = block_size;
+	return 0;
 }
 
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 754f2fe0cc67..e445db2cb4a4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1304,6 +1304,10 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 	if (map_size == PAGE_SIZE)
 		return true;
 
+	/* pKVM only supports PMD_SIZE huge-mappings */
+	if (is_protected_kvm_enabled() && map_size != PMD_SIZE)
+		return false;
+
 	size = memslot->npages * PAGE_SIZE;
 
 	gpa_start = memslot->base_gfn << PAGE_SHIFT;
@@ -1537,7 +1541,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active || is_protected_kvm_enabled()) {
+	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index b1a65f50c02a..fcd70bfe44fb 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -332,7 +332,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 pfn = phys >> PAGE_SHIFT;
 	int ret;
 
-	if (size != PAGE_SIZE)
+	if (size != PAGE_SIZE && size != PMD_SIZE)
 		return -EINVAL;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-- 
2.49.0.1112.g889b7c5bd8-goog

