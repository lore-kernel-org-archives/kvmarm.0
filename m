Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8228B235358
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753790426; cv=none; b=eXbn7bGJRdQvefbHhRZEvAbnm/CQSTW1VNpNJKBHMNjJ3OF3eKJq5Mo4mkbHii1HhmWa6n5utUaCQwGUXSaStIVajQn5yKub7FgPym3Led3Omr8mFzIy5785hx9b7+XClHiTVg2itU3usI5gedaJom17UtkJ5ou4EseyZlwFD/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753790426; c=relaxed/simple;
	bh=kOLJsjEZ89fxvW5K+Gpc/ooxja9Fbdd2tEuXsTTu/YE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fQgxdnpmeZ2xKZS4S3oh5ZwbFE2ruUd5x06L8EXWQ8clNFbQ0gZAnYoHAtOgc1NCqDVF9SufJ+D0V51Vtq9F78rxeQ0racEi7dxYEsDXItySQjCxgSMSrEM6WH/lSxk3Tip1hq0RXbobexHUbpcOexF6w9n6oahhXJ/3hmy2VB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XQgBtIU0; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XQgBtIU0"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b78329f180so2255321f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 05:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753790423; x=1754395223; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wc32r+Sr4v5L+Ca8aCOg8fbvHCgq9dLI3RBtx8Gb/FQ=;
        b=XQgBtIU0Uz0JYvNRGFmi2ux+lgrAB7JTgenZ4uHQ3BH078SNAL0XXgqwtZr9os6VHB
         J+uWhEkm0L3QLlst+es1LGUi3rLIFYOrSLfKwh4fho/lBVpvNHFAd1LozObP0veT/X6j
         o4fLl1hFIO1PlgOQxNCGah4v3dCRJJJwfNll24Yix0odV8/ecGmR/uz9Sn9tczHIdJtf
         t0nVymfym1Zk23io3dV2IS6Karu42fwQ/Ba2+lhhs+7AKwwnoLVrWbCbsRjE50xTjTHU
         QUbBUPs61NNIYY67fQNLCOhEb8PkZ/XlSdyVZQ2IwwXnSJBtcst1eHKpAJJKzyBNkmvi
         vINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790423; x=1754395223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wc32r+Sr4v5L+Ca8aCOg8fbvHCgq9dLI3RBtx8Gb/FQ=;
        b=fGpRW0j29imVr6hIqKZFtJgXmbrqE/q9t2S7ANvNDvEe5EZ1ZQNmNMqjqI49DMx2H3
         bm+KRhh5lKAtvXvk8ij1QEK4uB3KcRPu6BBRKZXYJmABcW1uCirxsuxHeRqwjZxi1xVN
         ANFLBtAxgV7XOIZuK2bC3KL8BgNEKjk3x/ujPGeJ5jfZ8riJcE4zLu4Oy6CodgTmMbx4
         un6v3/r7Z4JayejCE75YOKdwlr26kjibhzusjCrdNTNQg8E5+xUAvjKwgiHjYGiT6Z4i
         wukWCkqXykjNBXOpPXzag5Ina9nRpt3TtMGYT7gS48fAIHjeyI0Cy+m0iv/EOlA0X3Ss
         I08A==
X-Gm-Message-State: AOJu0YwClEEBcJWN1dQ5tPdsrG3mVBMq9CIx8aTcm2ti3qztzdu9dv9s
	Hx3l2Qoirf6Mi33Aw+tXxt20kpW920EmSbRcxnmc9ByXaY2lyuMfedRvrajuBeQsUd5nGkzGW5e
	9wYdwguWphMaRw4E1CmMFkDZc1K/9W1CDhFlchzNFx/dBM1KW9i7feWQfJtlU1AvMjkmcoK0U1S
	ijFKMT8dC8nx8MH+36ZVogQPPmkmvEAfw=
X-Google-Smtp-Source: AGHT+IHshwCE8IqYx0ORc/k7xUPcgW5nHiUDPd0fso9nQoGkAFVilNJEmB5BScri8HCBRNzCI/VA4IFRcw==
X-Received: from wmbej12.prod.google.com ([2002:a05:600c:3e8c:b0:453:5f7b:74b9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2883:b0:3b6:1630:9204
 with SMTP id ffacd0b85a97d-3b77673274cmr10850444f8f.19.1753790422877; Tue, 29
 Jul 2025 05:00:22 -0700 (PDT)
Date: Tue, 29 Jul 2025 13:00:13 +0100
In-Reply-To: <20250729120014.2799359-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729120014.2799359-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250729120014.2799359-9-tabba@google.com>
Subject: [PATCH v1 8/8] KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()
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
index 23dd3f3fc3eb..acf8ad68c6bb 100644
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
2.50.1.487.gc89ff58d15-goog

