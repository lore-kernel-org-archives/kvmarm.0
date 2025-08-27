Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C2D3164B4
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 10:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756290002; cv=none; b=oitGfyi60xcuHACcNYEQhhYilF/nC4PxPwW20YxH6FtvfbO2rcnMZP/VGsry+ZHsZY2qL4SDeN/ErAt3Vx9tQ3Qf/PM1DCZ9ftSoBMLgY9jo9ONQGVxHDnVAF52JZjKCYXjK64ZNOabZoXffx9n9tnpWjxu3ahbsijB5gNpV/1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756290002; c=relaxed/simple;
	bh=BmyB8Qf6gCkEL65M9IDb+3IVcmw4z2T+5bNFOZhOHV0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nU5ZZukTxcYZmAzsfkA30XrHWInXWUkuDgflpHbn9WvfhdDx5zJYev2dPdvb1yo5XcMx5KNmK+OtndnuJcDzX60Knl4LcOZ9RxG4ZaSBIS58IhHGSr1LrEzdc3+8/kF3/s8xMbUMoQmfmxc9iJzv0no1BTOpodPWubJVzUukOHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pFwkXsYw; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pFwkXsYw"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0cfbafso41680675e9.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 03:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756289999; x=1756894799; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oy5TRcbxi+oKZaDA6NnkhAWnNCuFaeediLm78a2LlZE=;
        b=pFwkXsYwjp2XlMMB8K3OQlxnBHP2m0z2lgX0L6d/AFCR7to/XWl5Eo+FqvS5lOwtvl
         me+4UovYZgGaIRi/jboVfwOUdSvFqwy7XD+KCWl41k2KFrnkxQF6Vv0bl97Zw/6SO5cr
         +nFPdIuREKm4X5j0Evxl6H/5UH5oIYWg/FBKnNkVkhr7bQookRUVIFmpoE0OS58gXVY0
         EhYkgO/p8f4dYpEJS8ESH+2fJP8EQmvdHj98Bb0PgfAdOCqGpCQHiYbty5mvT4fp/uiN
         shEKXSf3EasVldbr9Gk4oG0NW4q3LhB23b/D0wHFfgN7Yzpz7Ka9hBQagyoB9UuBtJgK
         X96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756289999; x=1756894799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oy5TRcbxi+oKZaDA6NnkhAWnNCuFaeediLm78a2LlZE=;
        b=Iy/XrkcTuKlz9r+ZiEFJR8OOB4Op5RDOVyg+pbiv6gokT87OMf81DXwaXKhf6kvXYH
         M1+XubjK58M2MnXC/wnDD0g2URbrYNluLOw3GdpgpVcbX/84faFNz+P3qDb0ip9ZgUNg
         hocZP0xKrMe6rp8uEyZvd3Mgji4L/U3iZkbbUJ3A4Bm2R1Augx3ftInnG/0Z1n82hsek
         zSnCQqhmdiUiIi43/uijQIj+0Ha/Bp+oMMFqaZMB2SI1Ae6fGdCulahBETqSNGGs/+Wo
         TSVcIoyl8gNqWD/AHCVK8oktqFuLRTBsLYXrE/qNrYNQV7almGq/feKHE3mmSLk+TNHi
         /bZw==
X-Gm-Message-State: AOJu0Yy6VyPd2DnHXUQsk2TKPup0B1SxY4c1z5/SYlKdFWC9onV6Mrv6
	j5iMAGA08zfTWsBTuZT7asawq+0xim48jGILqJNlxIqzD3oE+yk/CzR+45GOILAESv70nf98N58
	bBvHPpuo+udKwCBC/LBOuCwbd6se3jnqO3OyuKNp3CkrbOtE/EW1fLuQfM2T4uOIleMZsM37A3L
	i3Fmo/ybEa95H/tauht5ranvknN3dcS08=
X-Google-Smtp-Source: AGHT+IGOTeQ1n+VZLdO73T6QTzrnDzOsSB+w2lEpuWcOhvwClk0xQJ9gvC2wzhCXaaJHljlhkSN9uHoNOw==
X-Received: from wmbdp8.prod.google.com ([2002:a05:600c:6488:b0:458:a7ae:4acf])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4715:b0:456:1923:7549
 with SMTP id 5b1f17b1804b1-45b517d294dmr152543895e9.26.1756289999079; Wed, 27
 Aug 2025 03:19:59 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:19:47 +0100
In-Reply-To: <20250827101949.4089456-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250827101949.4089456-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250827101949.4089456-8-tabba@google.com>
Subject: [PATCH v3 7/9] KVM: arm64: Consolidate pKVM hypervisor VM
 initialization logic
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The insert_vm_table_entry() function was performing tasks beyond its
primary responsibility. In addition to inserting a VM pointer into the
vm_table, it was also initializing several fields within 'struct
pkvm_hyp_vm', such as the VMID and stage-2 MMU pointers. This mixing of
concerns made the code harder to follow.

As another preparatory step towards allowing a VM table entry to be
reserved before the VM is fully created, this logic must be cleaned up.
By separating table insertion from state initialization, we can control
the timing of the initialization step more precisely in subsequent
patches.

Refactor the code to consolidate all initialization logic into
init_pkvm_hyp_vm():

- Move the initialization of the handle, VMID, and MMU fields from
  insert_vm_table_entry() to init_pkvm_hyp_vm().

- Simplify insert_vm_table_entry() to perform only one action: placing
  the provided pkvm_hyp_vm pointer into the vm_table.

- Update the calling sequence in __pkvm_init_vm() to first allocate an
  entry in the VM table, initialize the VM, and then insert the VM into
  the VM table. This is all protected by the vm_table_lock for now.
  Subsequent patches will adjust the sequence and not hold the
  vm_table_lock while initializing the VM at the hypervisor
  (init_pkvm_hyp_vm()).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 47 +++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 64b760d30d05..a9abbeb530f0 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -410,15 +410,26 @@ static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
 }
 
 static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
-			     unsigned int nr_vcpus)
+			     unsigned int nr_vcpus, pkvm_handle_t handle)
 {
+	struct kvm_s2_mmu *mmu = &hyp_vm->kvm.arch.mmu;
+	int idx = vm_handle_to_idx(handle);
+
+	hyp_vm->kvm.arch.pkvm.handle = handle;
+
 	hyp_vm->host_kvm = host_kvm;
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
-	hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
 	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
 	hyp_vm->kvm.arch.pkvm.is_created = true;
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
+
+	/* VMID 0 is reserved for the host */
+	atomic64_set(&mmu->vmid.id, idx + 1);
+
+	mmu->vtcr = host_mmu.arch.mmu.vtcr;
+	mmu->arch = &hyp_vm->kvm.arch;
+	mmu->pgt = &hyp_vm->pgt;
 }
 
 static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *host_vcpu)
@@ -532,29 +543,19 @@ static int allocate_vm_table_entry(void)
 }
 
 /*
- * Insert a pointer to the new VM into the VM table.
+ * Insert a pointer to the initialized VM into the VM table.
  *
  * Return 0 on success, or negative error code on failure.
  */
-static int insert_vm_table_entry(struct kvm *host_kvm,
-				 struct pkvm_hyp_vm *hyp_vm,
-				 pkvm_handle_t handle)
+static int insert_vm_table_entry(pkvm_handle_t handle,
+				 struct pkvm_hyp_vm *hyp_vm)
 {
-	struct kvm_s2_mmu *mmu = &hyp_vm->kvm.arch.mmu;
 	unsigned int idx;
 
 	hyp_assert_lock_held(&vm_table_lock);
-
 	idx = vm_handle_to_idx(handle);
-	hyp_vm->kvm.arch.pkvm.handle = idx_to_vm_handle(idx);
-
-	/* VMID 0 is reserved for the host */
-	atomic64_set(&mmu->vmid.id, idx + 1);
-
-	mmu->arch = &hyp_vm->kvm.arch;
-	mmu->pgt = &hyp_vm->pgt;
-
 	vm_table[idx] = hyp_vm;
+
 	return 0;
 }
 
@@ -668,8 +669,6 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	if (!pgd)
 		goto err_remove_mappings;
 
-	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus);
-
 	hyp_spin_lock(&vm_table_lock);
 	ret = allocate_vm_table_entry();
 	if (ret < 0)
@@ -677,19 +676,21 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 
 	handle = idx_to_vm_handle(ret);
 
-	ret = insert_vm_table_entry(host_kvm, hyp_vm, handle);
-	if (ret)
-		goto err_unlock;
+	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle);
 
 	ret = kvm_guest_prepare_stage2(hyp_vm, pgd);
+	if (ret)
+		goto err_remove_vm_table_entry;
+
+	ret = insert_vm_table_entry(handle, hyp_vm);
 	if (ret)
 		goto err_remove_vm_table_entry;
 	hyp_spin_unlock(&vm_table_lock);
 
-	return hyp_vm->kvm.arch.pkvm.handle;
+	return handle;
 
 err_remove_vm_table_entry:
-	remove_vm_table_entry(hyp_vm->kvm.arch.pkvm.handle);
+	remove_vm_table_entry(handle);
 err_unlock:
 	hyp_spin_unlock(&vm_table_lock);
 err_remove_mappings:
-- 
2.51.0.261.g7ce5a0a67e-goog

