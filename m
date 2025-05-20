Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA003268C62
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 08:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747731200; cv=none; b=XLmAmeXnlV0F+JqEXVkbd/kNmSho/Wqzd5KRxp125mmszO7GSQfIu2z5oMhrVg9tfre4zT2NY17tE5SX4zNaIJC6UAzZxaj36hdMVhYRIpF/fSXcqt+PH4nU9xDZgLs12V9fIl7ya26/E8K9gwMsjxub5rYHix9sLnMM22duHU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747731200; c=relaxed/simple;
	bh=fKyfGQakCHdtjnwXmnpo6PcZIvIiLxTvpbrQEFntiX8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jHmKt8hWXOfgC1Q2lx6I5v6hvbv5jc2JmdG7Stah3WUuFg8Gu6E/i/ua7JrAOlrTLMqcdEiPw7vmFqha6twoRNqps82HeSnZoBG5QOI10OA12/MLDPEBn1o4M93xOAHPF7ONZMLjZ6G2SBiD0SncMVy4K/hujYY3hLyBa5O7Lf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iCBVt/aU; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iCBVt/aU"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d5ca7c86aso33639635e9.0
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 01:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747731197; x=1748335997; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6RhcZhtCDaS8NkJIeedFdZ107qBBIN26D1SVsvDpNZ8=;
        b=iCBVt/aU5vnx/71joMhOPn5LacknLiLPHYzg85dLIDAFH/R4xbOLPcVv5cIBJTHkEE
         Pwg90Wj6YWvJaiK4PJdksDXcce3LeuGMMrpOl9emGHPaoqislq3UONF31FundFPW0aaq
         qpUKyvxmIa2akW+J+b3+Z73QbVu+EGDNNGcV4d+vJq4KSl5rffEDqF5Sl2oxQoyTk4N+
         e1ieIUK79tTdSq2vp4zetVzNC0vmbfFfJl3mnqJyAnbep3bhjPuQ1bKmee2cUtAvwNMO
         KEfwyijoGfnlvlbCtVk/OZGVmMhPV0aAtZulB8je2ie6jqJb62aYk43mVV8JHhpVak2h
         vF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747731197; x=1748335997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6RhcZhtCDaS8NkJIeedFdZ107qBBIN26D1SVsvDpNZ8=;
        b=GbTMKyHIZe2vf0JaJHfONvLJi+GDxGruH1zFehP88Rhg/XAkfvqY8gw7s6Ar6VFcfF
         nJy2e2al92jcE1/LGo0c6EMifsnuvny/oElfsUXjqxusUbAqtj14p/hkNtljSk3rzfrE
         cFfWq648CgmSY8uPttc2PEh/TUlyvG97vkNO7BivZDxYyHq1j3DOZy1eN8HAbvypz24t
         f8djXBGqLcb3wrOScpy+z+tF+HxAxfdu483UVL8Gt0NySdMPB4SLyhxPCQ733gEpPwCi
         nLXxwef6LUyqrXRNDRzE6soPa5VV4lcrEs/gaXNIoiU622M6mwBj1d7nGHHzaklvwhqn
         sjHw==
X-Forwarded-Encrypted: i=1; AJvYcCVG6gshlic11PoBE2jS0VVnpvlCzk4VGg4qy8VdX1rjTqUdYjsMdvdveHL3aqPb0MxwnMnpC4E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/Pv+EsBg8RWPjmCMCFnhrPvAbJ372zcz8zkDof4bqSRxasxFB
	lX4m2YNWX8RFxs5zsvGs51UObM0wRVcMs8FRzmtGv56GLdERz2VjJgChR2XTzEwPqiVx3DdrGuy
	YlR1q/kNXmrvVZqZpuNzqKg==
X-Google-Smtp-Source: AGHT+IFEFnMn+5WqEzWmxQGG8vmhM7+5mi+63YjdjHfeO/BUWq/ciG944KxWrfJB4c3YAkUdS5M6ZuY5i48SqhBo
X-Received: from wrbfu10.prod.google.com ([2002:a05:6000:25ea:b0:3a3:659e:161])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f4a:0:b0:3a3:6c61:9d52 with SMTP id ffacd0b85a97d-3a36c619e19mr6952768f8f.18.1747731197095;
 Tue, 20 May 2025 01:53:17 -0700 (PDT)
Date: Tue, 20 May 2025 09:52:00 +0100
In-Reply-To: <20250520085201.3059786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250520085201.3059786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1143.g0be31eac6b-goog
Message-ID: <20250520085201.3059786-10-vdonnefort@google.com>
Subject: [PATCH v5 09/10] KVM: arm64: Stage-2 huge mappings for np-guests
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
index 5a7a38c5d67c..1490820b9ebe 100644
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
2.49.0.1143.g0be31eac6b-goog

