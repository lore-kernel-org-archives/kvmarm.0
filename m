Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CFC2FA0F2
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 10:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756290004; cv=none; b=HJ4IjHdLu3e6nCEtk/eIQah0ilm/Yo9+N1PZJvz5LClvDPvbjcWvoA4N4WgPaEH1JPG79OA+R8wr/yosyt4h7KqoHY08+gQRJ0lIIoB2KN7j53tpWrtfzdR+BWCaFHKeK1uS9z7eteC7+v5vqAmspgzVSOnu3jFoKe58/2vlcMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756290004; c=relaxed/simple;
	bh=v2pSTFJDyNZblheDEFHo6zb4GitxGdkmFoEIbY/A5xQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FpWHTX7vR8huH2fSIJrsdyR/+Vy/fvOolc/MM9OdMlxtwu0BSz0XBT+fFqa+voetwQrBO+UnZcYqEIcPgCkBnf5crK+o8nHqKG0Ewb1n72KPodUNvGC0n/PMbw725iwHUdcyjtz4ag6dl3XCEO+WPqpt9hv1KXyuDeibju8RjKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vJ6eDsvw; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vJ6eDsvw"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0b2b5cso47720805e9.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 03:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756290001; x=1756894801; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nuCz5egXktmZGwWbzUOHComq39t7Vinsnw70AcEB24I=;
        b=vJ6eDsvwEKMamBf5injMTZnFlOnPl9geFnnpPWj+BYrJNOLAcOHJFrKh1QE4NY3E1a
         9rSdawcec7wgesLBRVooqEeSbIdUwudSWfga5GoLlhZHpbyplBIec9T4Z6zjUc6KdaXI
         J42a1a6o2ZwUWLG6GcQxGpWU9Gx41uFIfPcfRA5EFIcvQrdfSPEck5Ns+7v7J3g52vJO
         dBXv+JUp7H2TW/j+4kn2OAGGVm+9DqZHJfVAsxnzfen3JveVBX54OR4wP6rlWs5VYxYM
         78+oDchxOG5hftPeOI/OKb0NA2lakULfIlwRl4sWXMoYsDkKiF1aqyNMAt/2NreYLMmf
         Q/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756290001; x=1756894801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nuCz5egXktmZGwWbzUOHComq39t7Vinsnw70AcEB24I=;
        b=I/nFYZxRqkder04/dTU6wTd396fSKn4FpJq1wA8pF2BRD/UTc7Vw6C1edy7OJn88NG
         CaVWD7W6fZQSZsKhq8AknkIoNeY4vGxsVMUGsTX4lJfddPW04aMGugbg9r+Mxs+n/Buj
         MbyGDRZY1ZTWTghGdSvPlY4pJz3ZPvqqKCsdJrK072sgAKt0LJXWTNRpstDQp3gZycxT
         CER3d/ZGW3GJXWj6KcDzONMv7G5oFWcT26vuABcVcmaMO5w70jPSznDskW9XI9PPJZ2n
         beGyaYmMyvQd3ErXdQsSSzMRZsUbJxwS8H+S0G6JoIsQWmcwY7SXB1LRKlvhUcrLWcCG
         IiMg==
X-Gm-Message-State: AOJu0Yxqr+zOQalajLfFRZxX1U4He4XZvR+AwTTGSSDbBl6E/3qL8pEm
	ZHYgP1z6S23/IbD8gJzDeQ6GBo43ICOFklyXeO+I+vH11MoTzyw8gRbYbF0eZ6sDdYVRzb/majp
	p19IPhqRKBxjsGKIbYXquXC3eoJAANzXwZqWDUTbAm5W1NzC1D4R6eVavl+1zIQQ89CeTjVxh+R
	bPU7P3m8nnorr+5hY540SzZ4Qt3q2C/Nk=
X-Google-Smtp-Source: AGHT+IEOQLpBwftS3XTIfWvMVc8KCrkmcTWprSbLkzguiMao4KsAhSZA//2vOVdXK5qUkUe1Vh2eIeZMWQ==
X-Received: from wmbdt7.prod.google.com ([2002:a05:600c:6307:b0:459:df20:248e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1881:b0:3c9:28f1:d858
 with SMTP id ffacd0b85a97d-3c928f1dd27mr8198451f8f.22.1756290000977; Wed, 27
 Aug 2025 03:20:00 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:19:49 +0100
In-Reply-To: <20250827101949.4089456-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250827101949.4089456-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250827101949.4089456-10-tabba@google.com>
Subject: [PATCH v3 9/9] KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()
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
2.51.0.261.g7ce5a0a67e-goog

