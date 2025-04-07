Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AC822A1ED
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 08:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014460; cv=none; b=aRWuhWhXWu3yFd7gUcOmpJPZs3E3TarhEuKeaSJVtkpSBs6RHlTwa2yZC4+R3CawiCAJakuL7vfLb/15rZe18ZllwnwdNXvnroNBS2CY71XpKvn6jXyniknTsgaJe624dpHpY45qdh+o5gk3+PqvyYkP1dnZc/tiEZeqYOLgeKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014460; c=relaxed/simple;
	bh=eKDE74HFrEZkw4ae4hxApkSppF5mW45ydhlKywdh9sw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JblJCMYfA3VDtZCOV3ynLplmFqqvwMJOpqJ+EiaL57/uNI0Ibvp+FVcZLu2uJ7bivHAXPArlM7D0D728gwjgIUN+l+Y+2uRDLPNUtcRU+LXS6ngFh1wTJmupX6yD4xoUvE1+ROM87DtJTXd7D4s0ssNo9c2gWTQEUXJoBx8wwL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vzN6l4aW; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vzN6l4aW"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43ce8f82e66so26262905e9.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 01:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744014457; x=1744619257; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Fucuhr9dizyg89eT+HA/IrugXy5DABtvkENtK6O2wY=;
        b=vzN6l4aWa12+eu7GJEw8ozUe3qrwRxFEAsH8nf/5CFnt4ECUg//Q6eLK1gyEjuWgXV
         yTXklSu8VQlyNgT50aiCX3jPRqBDn22pWf1Ba1mYqCvpremohiLgMZ2QvNpIPtTW6Lpf
         HuEwayHfsrOomLljB1UwZtfWPFiAkgsqAs+sqWZE9pMtKNzr0DF+RHPEpeV1gcmVvhAm
         LgnIXIwIlVSRDzbu2el6MjK4zUbMMppP1hIyP4N6P9T9aF3rE7qxWicMZp79DHmUTZSb
         AJLyRW/+h7IVo8ZCwlZ8g5xa4tI6sMKT3GNvow6lsUb7Y0RL3ArmpiqM0hSmbzSANcsh
         xYFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744014457; x=1744619257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Fucuhr9dizyg89eT+HA/IrugXy5DABtvkENtK6O2wY=;
        b=FCbS9FFoKrRA+iK++JsoH+vcATYYLPMaUruQQ7rNPr2L5XUTdMEGe55AFMMiS+lg2r
         nhSAV+5nOi1iFoIMkelRZyO4l1Wq96vOPoG/p+eHkW0UueYo51FEcjSU4TAjLkNBztYe
         2ba8i1OD19Mj6k5wud2CX6yWlAv9JepsvQBH3bC2Oqv2SSJU5B7fiwwS2slfR5YR2GGK
         3ebxIlMWIUiCb5cU8v+hXd9uQi1UbAv/uuS+CktTWcfMMa2sqeo8ELqA/R77Xj2LktXZ
         e2AQKk6d2LK5CxCNRV7nodkVeMZt3/KHkXlcyckuQ6b/+/zKy6P+Y8qc5umNaSZc1PjQ
         Yuaw==
X-Forwarded-Encrypted: i=1; AJvYcCW5XlVbFi7lDocm5gKWf5LvINwFWWVrRLnIbOJ3e/fbufIxWXHq7xmIAXHsrQayj+5WIt5Rh58=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRdfJnudC9YLMVKBMO61U7opMdRJJNQ+6mnfLZXBxpubCLgrKT
	RqmUSsQtXC0KoAe/2SdqR+4QcBmGBB4a3P+sWR6tzR12EVpxV/p7LHiNU0uZY7y7xHrbFTLi23X
	eocMiWtKTeM+h8tcjkQ==
X-Google-Smtp-Source: AGHT+IEdhWgRCreLOVKcTXn9rS7GYa/xcK1Uq83ChnMioO7xrrZto43NYEH+Y3QBChsKi9UezwWvTk156uLbz8oN
X-Received: from wrnc10.prod.google.com ([2002:adf:e74a:0:b0:39a:bdcb:1ed9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4009:b0:391:40b8:e890 with SMTP id ffacd0b85a97d-39d0de28a8cmr8552695f8f.22.1744014456820;
 Mon, 07 Apr 2025 01:27:36 -0700 (PDT)
Date: Mon,  7 Apr 2025 09:27:00 +0100
In-Reply-To: <20250407082706.1239603-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250407082706.1239603-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250407082706.1239603-4-vdonnefort@google.com>
Subject: [PATCH v3 3/9] KVM: arm64: Add a range to __pkvm_host_unshare_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for np-guest. Add a
nr_pages argument to the __pkvm_host_unshare_guest hypercall. This range
supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is 512 on a
4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 96f673f42e8e..33fcf8d54aa3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -41,7 +41,7 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot);
-int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
+int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
 int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e71601746935..7f22d104c1f1 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -274,6 +274,7 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
@@ -284,7 +285,7 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 	if (!hyp_vm)
 		goto out;
 
-	ret = __pkvm_host_unshare_guest(gfn, hyp_vm);
+	ret = __pkvm_host_unshare_guest(gfn, nr_pages, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 48bc0370515f..2aa4baf728eb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -979,7 +979,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 	return ret;
 }
 
-static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ipa)
+static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ipa, u64 size)
 {
 	enum pkvm_page_state state;
 	struct hyp_page *page;
@@ -993,7 +993,7 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 		return ret;
 	if (!kvm_pte_valid(pte))
 		return -ENOENT;
-	if (level != KVM_PGTABLE_LAST_LEVEL)
+	if (kvm_granule_size(level) != size)
 		return -E2BIG;
 
 	state = guest_get_page_state(pte, ipa);
@@ -1001,43 +1001,50 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 		return -EPERM;
 
 	phys = kvm_pte_to_phys(pte);
-	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
+	ret = check_range_allowed_memory(phys, phys + size);
 	if (WARN_ON(ret))
 		return ret;
 
-	page = hyp_phys_to_page(phys);
-	if (page->host_state != PKVM_PAGE_SHARED_OWNED)
-		return -EPERM;
-	if (WARN_ON(!page->host_share_guest_count))
-		return -EINVAL;
+	for_each_hyp_page(phys, size, page) {
+		if (page->host_state != PKVM_PAGE_SHARED_OWNED)
+			return -EPERM;
+		if (WARN_ON(!page->host_share_guest_count))
+			return -EINVAL;
+	}
 
 	*__phys = phys;
 
 	return 0;
 }
 
-int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *vm)
+int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 {
 	u64 ipa = hyp_pfn_to_phys(gfn);
 	struct hyp_page *page;
-	u64 phys;
+	u64 size, phys;
 	int ret;
 
+	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = __check_host_shared_guest(vm, &phys, ipa);
+	ret = __check_host_shared_guest(vm, &phys, ipa, size);
 	if (ret)
 		goto unlock;
 
-	ret = kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);
+	ret = kvm_pgtable_stage2_unmap(&vm->pgt, ipa, size);
 	if (ret)
 		goto unlock;
 
-	page = hyp_phys_to_page(phys);
-	page->host_share_guest_count--;
-	if (!page->host_share_guest_count)
-		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_OWNED));
+	for_each_hyp_page(phys, size, page) {
+		/* __check_host_shared_guest() protects against underflow */
+		page->host_share_guest_count--;
+		if (!page->host_share_guest_count)
+			page->host_state = PKVM_PAGE_OWNED;
+	}
 
 unlock:
 	guest_unlock_component(vm);
@@ -1057,7 +1064,7 @@ static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa)
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = __check_host_shared_guest(vm, &phys, ipa);
+	ret = __check_host_shared_guest(vm, &phys, ipa, PAGE_SIZE);
 
 	guest_unlock_component(vm);
 	host_unlock_component();
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index cad25357858f..d533e898c6be 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -388,7 +388,7 @@ int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn, 1);
 		if (WARN_ON(ret))
 			break;
 		rb_erase(&mapping->node, &pgt->pkvm_mappings);
-- 
2.49.0.504.g3bcea36a83-goog

