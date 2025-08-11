Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5E91DF982
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 10:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907600; cv=none; b=knPcTtr67gcaKf6K4r7N3dykibm1yoNw6RzBh44NKohj0oMpkh1d5lpSGxkFGuRpERyqxdO8fB6Jh77XMATucT8NmGJNXJMLjBbHiSY+sds5zDiva9C3V/4PiyY1m5sC/FqNNLTNSmmNpioTiSyPR0Ndj49lRIU65VWbCrPqsPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907600; c=relaxed/simple;
	bh=r4ltuEgukPGOz/jiLpAtKcxLfcjaAOKq6RHsSQ4pBGM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mrj9Ntbsp62Dc/4l02C2GDMLx9ujJufBL882uyjpp2yeUePO4QHthUO0A+GwGR+RvjS/Dv91X0hWEqCQ4o1ix2xuv278I9VpUEMR8RQlff8juXOhiS4xVcfUmEsgRgOnOwZM6cShFo6Rm/amj4n8rBzbt2BgAppnqDVfF+TSqfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0gYu3ZBE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0gYu3ZBE"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45891629648so24020245e9.0
        for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 03:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754907597; x=1755512397; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yaD4jeVNpWYFjq2A4qFeAKzDOAXMWpA17YYRVKNwrsc=;
        b=0gYu3ZBEUuJ7VpfhBZCenXCbMZIvzgExFP8AHvjuoLiWA1YeSa//nV2+KVWX54uWjA
         f1IrBIgWb4OfW/w1QSzZE1MshBCQh8nYXIMY8R77y7rrcaLHUjJwUO/7xNglbZ+6w4tw
         HXS8XGIJ824IUJzEb2VzdjvYWr63EQnxbX87WKqI0iQXIMDZqvRqLVovFB5X8IQcU4mN
         hRFRI3BPhgM0aza+RB1L9bNUGlZB3s7iJsTLkSzB6/oJ/Q21VZQfQ8uxC+mCn4pCRhRR
         lXE9KfG2NyTOZxfj5QuZUm4lfXPDknzoftXBtJ0xefwG0JOVoW4voj2YAVmU/BJ/Yy7M
         +2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907597; x=1755512397;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yaD4jeVNpWYFjq2A4qFeAKzDOAXMWpA17YYRVKNwrsc=;
        b=ANBw3x9tjSiXh0vg0seJbsLpQwac4VWBUDsBXsKJC1u3EVKQg2LhecMWuU6yGrwgPz
         4Pva7yNsK/qla5QvfIPT/XTrg4A4tQew073JnVESff6mz8Jukvl5MyuF9fpqueiyqGmM
         bEOfkXhv31goxkFC6jyF0uw6WeDy6Ym60UOc3QnEubrNAoaMjyzguE4BkmHnJslvOjtT
         GRZanmILnCTMvMbTb/6VR6Dg7RP+FnBibSY5px/5Xi0OVb/rZG7MP9CwkV2G0q0ADd06
         uO2elLoK8cFsqcUvyT9KAaveXKkH1o0wESYs0neFXcWkkVAZCuk/aWfRLIiLuHzXI9Bm
         Y7Tg==
X-Gm-Message-State: AOJu0Yx0Mc1Rvs37KLsmpimOOXoHma/R4a6Quu2WZJpN/lyUYkqf3KA+
	nj4bT7zrnefbH6m8OkPAb8vJQeD07YS/NHhf7PXGiUUNciOwqmxznJ3UxqizLwkTIJ4MDnjcYmC
	aSI0t327g+9QUK3g5xtd41zYreAn52KamrmADdFiTcEyfHfJfb1LV9BT6RZXr/UKE72nCi/OvdI
	GDCMo5Uw5DtUFCXDyW4ehO9cBmwoQaw6o=
X-Google-Smtp-Source: AGHT+IFipUgUa7LKvrcYC+2VEEmZ9gCItoCPzDiG6XR8wPDrdCYY2snSght6oq/lyyVF2mg5llIkCBWIog==
X-Received: from wmbes9.prod.google.com ([2002:a05:600c:8109:b0:458:be13:ea6d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f4c:b0:439:4b23:9e8e
 with SMTP id 5b1f17b1804b1-459f5181aabmr114050575e9.3.1754907597102; Mon, 11
 Aug 2025 03:19:57 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:19:47 +0100
In-Reply-To: <20250811101947.3637632-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250811101947.3637632-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250811101947.3637632-9-tabba@google.com>
Subject: [PATCH v2 8/8] KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When a pKVM guest is active, TLB invalidations triggered by host MMU
notifiers require a valid hypervisor handle. Currently, this handle is
only allocated when the first vCPU is run.

However, the guest's memory is associated with the host MMU much
earlier, during kvm_arch_init_vm(). This creates a window where an MMU
invalidation could occur after the kvm_pgtable pointer checked by the
notifiers is set but before the pKVM handle has been created.

Fix this by reserving the pKVM handle when the host VM is first set up.
Move the call to the __pkvm_reserve_vm hypercall from the first-vCPU-run
path into pkvm_init_host_vm(), which is called during initial VM setup.
This ensures the handle is available before any subsystem can trigger an
MMU notification for the VM.

The VM destruction path is updated to call __pkvm_unreserve_vm for cases
where a VM was reserved but never fully created at the hypervisor,
ensuring the handle is properly released.

This fix leverages the two-stage reservation/initialization hypercall
interface introduced in preceding patches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c  | 12 ++++++++----
 arch/arm64/kvm/pkvm.c | 33 +++++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 888f7c7abf54..7f9ebe38fdd2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -170,10 +170,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		return ret;
 
-	ret = pkvm_init_host_vm(kvm);
-	if (ret)
-		goto err_unshare_kvm;
-
 	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL_ACCOUNT)) {
 		ret = -ENOMEM;
 		goto err_unshare_kvm;
@@ -184,6 +180,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto err_free_cpumask;
 
+	/*
+	 * If any failures occur after this is successful, make sure to call
+	 * __pkvm_unreserve_vm to unreserve the VM in the hypervisor.
+	 */
+	ret = pkvm_init_host_vm(kvm);
+	if (ret)
+		goto err_free_cpumask;
+
 	kvm_vgic_early_init(kvm);
 
 	kvm_timer_init_vm(kvm);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 082bc15f436c..24f0f8a8c943 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -90,6 +90,12 @@ static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 	if (pkvm_hyp_vm_is_created(kvm)) {
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
 					  kvm->arch.pkvm.handle));
+	} else if (kvm->arch.pkvm.handle) {
+		/*
+		 * The VM could have been reserved but hyp initialization has
+		 * failed. Make sure to unreserve it.
+		 */
+		kvm_call_hyp_nvhe(__pkvm_unreserve_vm, kvm->arch.pkvm.handle);
 	}
 
 	kvm->arch.pkvm.handle = 0;
@@ -160,25 +166,16 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 		goto free_pgd;
 	}
 
-	/* Reserve the VM in hyp and obtain a hyp handle for the VM. */
-	ret = kvm_call_hyp_nvhe(__pkvm_reserve_vm);
-	if (ret < 0)
-		goto free_vm;
-
-	kvm->arch.pkvm.handle = ret;
-
 	/* Donate the VM memory to hyp and let hyp initialize it. */
 	ret = kvm_call_hyp_nvhe(__pkvm_init_vm, kvm, hyp_vm, pgd);
 	if (ret)
-		goto unreserve_vm;
+		goto free_vm;
 
 	kvm->arch.pkvm.is_created = true;
 	kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
 	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
 
 	return 0;
-unreserve_vm:
-	kvm_call_hyp_nvhe(__pkvm_unreserve_vm, kvm->arch.pkvm.handle);
 free_vm:
 	free_pages_exact(hyp_vm, hyp_vm_sz);
 free_pgd:
@@ -224,6 +221,22 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm)
 
 int pkvm_init_host_vm(struct kvm *kvm)
 {
+	int ret;
+
+	if (pkvm_hyp_vm_is_created(kvm))
+		return -EINVAL;
+
+	/* VM is already reserved, no need to proceed. */
+	if (kvm->arch.pkvm.handle)
+		return 0;
+
+	/* Reserve the VM in hyp and obtain a hyp handle for the VM. */
+	ret = kvm_call_hyp_nvhe(__pkvm_reserve_vm);
+	if (ret < 0)
+		return ret;
+
+	kvm->arch.pkvm.handle = ret;
+
 	return 0;
 }
 
-- 
2.50.1.703.g449372360f-goog

