Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922C2223DFF
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 10:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907599; cv=none; b=NhUXlvs82Aq59+VTqUhFPluIzfROz/Ir3yM58Ac92J0uFUHaQnKijdNCOYWRatuwvs9nJfW7z1ASlGiREloswuA1egFwpaQtWR3sOVSWcoQO/2TVkjIEjw19+c4Pi6KvstHP5l9Wss8MJJv9Q9uh5B8tNU6321U9kv9A2SiZBQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907599; c=relaxed/simple;
	bh=CEcoTW5KcDqH7AuH2DqamX0MRA/csnl51jOhCg7OYI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ow/QYYFmRyk3YAkLk+MCPipBv+IvPM8KLRU3BBJYUO5Ro/owJA+zsh0NwzyAafOpRQie+US8UKlqAOYlvm74N7ytcevpLBeWWI+oogZgCrWF2rjdL6+kgRqraMZyvaqnEqt1rBakYAq6Hzr9TedDtPEl297yPkgRzdETpwjBTKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LhnAmInb; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LhnAmInb"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b7931d3d76so2853397f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 03:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754907595; x=1755512395; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mRLA9pRzTbDwXC6FM9b3f4CLrD1Kf3l8+kFNoeqL9OE=;
        b=LhnAmInbiquhP1DvhXP6xX3vgzg4P2cPUZkWuFUf/PxRSxu9aQeu3RtF1eD6uwiCNC
         uIE7OcgoY8CsjASS4vAnAyeFheKF6dBwKX2mde8I//5c60xYFdnMHydd8x4RkLmnfOkF
         xClcsRfbdNonAwltpw1Fs4XUGf4qqEHWFx0herlED9KiW029Kvkh15AgYjVPT+OFbQkU
         TRlM0kapac9TNF3k2I1x7Pu5eKonhzMGQ/XTbMV+hIYsLsoSEAw0TrQ1apBhFRp1H+rd
         /tIkaX7/TMleYsK/SozvTnYxm8iR4rxPnpX2hLHnCVk347qxH0I7k8Ttw326sA9Rfpie
         74qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907595; x=1755512395;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mRLA9pRzTbDwXC6FM9b3f4CLrD1Kf3l8+kFNoeqL9OE=;
        b=XBTSqzfz5YRGowlxzG+0h2Cbrvxk5mm4ISjvsic0g/sotI4c+1R3JSXe26vxcHsehg
         uxouKMKhA/DMAGPZGn3gMPtpeDPOzajlR0FXaNLWIMcbslS4RNhZUEvxmDRIZX5WUzbA
         W1/gHUxrnsRcSnZLxh9ySfw2WrvIceoRlkMiy56CW1yU89MOgeF/MAluhTYSc2/yEsHG
         FCh8PZJzHzyuFQy1OXbpAfwPLdhgXVjTKP8JXV+xyjpkK2lgpSy0uKHjyRO24fXaFw8e
         JiDrxbqsM52nFZYpIrEkVETUp67x1H2DVjO1zjCCVbWwPqtc4MTDZbVxZxpvm0KzRY6m
         i/WQ==
X-Gm-Message-State: AOJu0YzSKhdHTNEZkG+EIO6GggfWf/Lqv4mm53w4gkGk0E/7zhTVb8QI
	h5PyYS+b60QnW585m3owayIZ2tVTJ/AYqO1PBtP/ZUZnB4kwUZrCGut7MlmkJXyKjF6sHklMQQn
	BiIlH03sfzrnlPyXMHbZ9Entnez3HxGAIDeBliBgEBBa5jWHz48KCk9czT79EFC6UG1W/fbtquF
	stnPjOi5flQnO6/YMdn9IRMYeYPMf7U3Q=
X-Google-Smtp-Source: AGHT+IGa2oIGCioP6NpFjMeI/uX3zO4PAyCBOwSdx0TBdpxIs1WyiO4ChzT9I2fwrMZgmJhhOZOCVvpKOg==
X-Received: from wmbji6.prod.google.com ([2002:a05:600c:a346:b0:456:1ad9:a23a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2c03:b0:3b7:8832:fde5
 with SMTP id ffacd0b85a97d-3b900b4d7f2mr8972945f8f.13.1754907594661; Mon, 11
 Aug 2025 03:19:54 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:19:45 +0100
In-Reply-To: <20250811101947.3637632-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250811101947.3637632-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250811101947.3637632-7-tabba@google.com>
Subject: [PATCH v2 6/8] KVM: arm64: Consolidate pKVM hypervisor VM
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
2.50.1.703.g449372360f-goog

