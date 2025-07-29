Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DFE235358
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753790424; cv=none; b=Q6f0pevpF5iD3Mmuyt7mIIjkGfzmOObTo+0Lo+p04q2mIGBqIipU9HPMt/LU/dSDATzk9d1buRaBylbyWFio9wrgRwn2N6udyBKdcb17CNzUohqpCk/I400GfHTLmM1Wx19frKJKO5LMf4G8YZ6FI5YXgUYigibrSiZ1lb1mKDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753790424; c=relaxed/simple;
	bh=8fuHgeSitIFjDFF/OeLoBY9WnHmz+XtORNDs/n5fabU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dH0NbOKR7Mf42q03Xnmf0Kux+7QEr38oh91F9lWVKzCZ1SPYnVw3clDXC05nDqm6eTKZv1SKoKIXz4bKjUiQ07Myy7trm1c0Qn9oCsbRXIvlHwGrdptr+wq9obiL9LTA2ebF6SanxR+Rg6j1YQuac+e2vtv5bqbjmPygj8XzN80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S989Zs/Y; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S989Zs/Y"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45626e0d3e1so34330105e9.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 05:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753790421; x=1754395221; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nzTlWySJCG78jq2IfrYfNkJ/pZ9aJEn2AikPiisxllU=;
        b=S989Zs/Y05R/gF7PjIKlO23iFSTryj8EJLhahKq0pEUbbuzAphiSYPKeWVLtwitJu5
         18EazcrDg9GcI9ijTWT6wTByIe0uPDpMqF+cuSuTe1sLMsnbuBGhzVVtmtNCFGdgJgfh
         1NY3iYcC6xtgx71FFTBZPRl/f3DO+svFUUB1PJhGcKKzqcoWVsCiC8+eKVDwCdq/8G2w
         e5ygAr8CoKrZ+aZaKvfd7U+E6h7X40EkCA8PibB8PzL2oJeN6+PEq7BPJNCgjZ/TwpCo
         lSjS0d4ImnfVP4ykkpj/2LgYCtthwRp0VcexJ92azOKmbMhW1araaMwD2UEGxdCe0yik
         HI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790421; x=1754395221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nzTlWySJCG78jq2IfrYfNkJ/pZ9aJEn2AikPiisxllU=;
        b=vTWN2d2r/tBELQMJRQH9b1JjugR9tRRGjsr4EgBVpJi1eVianuLO+MD0Z9KENlbCJm
         QA8aihCJP7MlKA9wfgMOx79POhmBfOANkLKluKJvm4odA1shn6H4cHtZEyeEINshRbqM
         3wGr8/EH2MSjPyK1gajG3QQp9IH2Eknl94lUBiYtsG4iOnjC/Q1TGj/vX4hzEHeWr1zT
         STRZN8usDUOhvZWO8Z66ksI7zhqyojJ3y5yM2Bfr26TfcCg2+3qLUgnOJ2v4DRacIovU
         7YdOW6yGIMO14J21Jss2MId9VvmDV8nKG3JPgk5t5g1t8EoiJ3ZB3nSM+6J9vgyk+X0b
         7Dsg==
X-Gm-Message-State: AOJu0YzlzkPgC+/l2OEHeoXK7sETYN0kkXZEY3duwVZeYmH/fgkS1zoq
	AtjGbF+KysTQIgKLmD9d1J67LSz4VejA0Q6LT4kIK9iC1Yp1qxTwh9mZJ1LI1zgRTwbHM8ZZxk2
	wW80wR2tWsIwW0XEUs+gDCKk/DG1dmWQ51n536tKOV6AOFZRrxCfO66agWwBn9ELOF3hHzpufW2
	y92EW6yJmQKaPC1Uuu9buqqvZAblD3xGE=
X-Google-Smtp-Source: AGHT+IFejJUgHX+Z1CtNT5C8c6rHJGlUTyHBo3o4bob1n8JrSXQa6u68mJSZfdFMtBOpsqH/b8/i4YqXXQ==
X-Received: from wmrn32.prod.google.com ([2002:a05:600c:5020:b0:456:1754:78e0])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:64ca:b0:456:11cb:b9c7
 with SMTP id 5b1f17b1804b1-458786424f8mr124021765e9.25.1753790420714; Tue, 29
 Jul 2025 05:00:20 -0700 (PDT)
Date: Tue, 29 Jul 2025 13:00:11 +0100
In-Reply-To: <20250729120014.2799359-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729120014.2799359-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250729120014.2799359-7-tabba@google.com>
Subject: [PATCH v1 6/8] KVM: arm64: Consolidate pKVM hypervisor VM
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
index ea9df0b079f1..ff974290f144 100644
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
2.50.1.487.gc89ff58d15-goog

