Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88431F30A4
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402687; cv=none; b=Q/ljMPM4Apy2NJr3/4tk3hjheI6LVkb5aPQuQFE7Zi9nviwFmbjylsMezGwgM0Xbz7B92h3bfBt/SCQj+4XoAKQE4PamnaloiIotGrToOAXx4h8op0GfPQl3t+absAiQvjILFZAyhG6Qd8u+/NwJb+inLumaF+dtkBn0DUMNqsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402687; c=relaxed/simple;
	bh=hgd7060jQX1MLyymFp3iE8XS3BVAofmnyRqYx86QH00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bSgzaWQxA+Jl1wPIDhY12PI1xjhWB7lXLJDaj9KXKBcBEC26eM0pkF6KogsqedmkoAaSzcXjtn+POaAxtDnnUKylTSbAjoaiTxSKPQ9/2FSu4723HYdhE8nlhir1M63x3VY6Yfrux1+xMm1fm1759jpWQy7u3wolgp32LhhG/k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GgmK2OHB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GgmK2OHB"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45de18e7eccso14925525e9.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 00:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757402684; x=1758007484; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vkpi67qOMp/uiAz2TC5dAbuoUorHcaS9iLgtzkJSQco=;
        b=GgmK2OHBbRIUY7Hw2zTCaCl10ub9RrkF7IQFntAOiDjRXazia8h6gFMGmFZTi4ykbR
         frquBCd7FZnPD5qCaDLbQ9m2EIY6dWqUSmOro9CowgpfkAPwzJ2Rdz+uPfTirytWscAa
         G0+knkdi9VxhT8/XXuQjQDkZuHAJ61+1XHkdqbZ/KJ47Xhhc71CXP5YZ+5HEdEYdPwYb
         irhctPyeimATm9XyVOZ1B7vWBOeLhDTzfdaUNfFbsvYXaHFZ0g7VUXjXzoYwLkV3dI8D
         WjPTXQyikCkQRXAsoyli138MVETV/8t7GSfnG8/uJ2FEIuqe6PmaKP0rsAgoMBVcw5i9
         X++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757402684; x=1758007484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vkpi67qOMp/uiAz2TC5dAbuoUorHcaS9iLgtzkJSQco=;
        b=mkEjjSN44NwnhEZGfC/d5XGBOCOrlJb2kkuPsloHAUH9ivN9VnLntQwfy3QfFWpVOn
         kRooLmkAUwsZz13ktLYVAi4J9VlY+aGXCS1VdiUnSInNih9sh2l7leKlTPw3+8v5HtOz
         IQZdgqg/a+Lq0BDNG949qR7FkYuFOKG+hQoa+M6wP8h1oq54+F88+/PjglmKyGYgJP6Z
         ADk7NZ2+kw42j5ZOkaaPH/SAWJoFuAAPYITXtyVDr2AMvVJNnyASL+mokbc9nf7g53is
         6VtKBupr430pdx8qMiWbBeU9fxQ8Zt/56l4jcZstRc6q6lTivORKfoH+G3c1KuF2TUHQ
         vBjA==
X-Gm-Message-State: AOJu0YzYgpNeS3+7wv1U4VPqrtQPDG5+Xmqha2xtcBYMSmr5NDv90iNT
	suhItBnBI3O/QVtKK3tZr3MH1kLXKwtRZzLT1AmLfndM1If4RcLf1UqfPbElvUSvtaiBA7LW1Xs
	E4ziQilqWnXsjeTw7G8MGzSucAUKCOU8qdE2GJAq2E+zYtrRQkFGoqmYfrsKrayl3Nv94A5VbKq
	OfFUKRvlicn9ndtNdzAEyXAZDwAktcGh0=
X-Google-Smtp-Source: AGHT+IGXGlhvO/Gry5KuVU8JDkyeu45vdQr6fz8ahI5MK/ozUtoBR1pAMbkxHLqtlX/EpdjqL8+Q5vnnKg==
X-Received: from wmer2.prod.google.com ([2002:a05:600c:4342:b0:45d:d1f2:48ba])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b8e:b0:45d:d9ab:b85a
 with SMTP id 5b1f17b1804b1-45def87ee0bmr7641885e9.7.1757402684215; Tue, 09
 Sep 2025 00:24:44 -0700 (PDT)
Date: Tue,  9 Sep 2025 08:24:34 +0100
In-Reply-To: <20250909072437.4110547-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250909072437.4110547-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909072437.4110547-8-tabba@google.com>
Subject: [PATCH v4 7/9] KVM: arm64: Consolidate pKVM hypervisor VM
 initialization logic
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com, tabba@google.com
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
2.51.0.384.g4c02a37b29-goog

