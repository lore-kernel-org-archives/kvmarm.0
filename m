Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E582E1F30A4
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402689; cv=none; b=Or9rEIF9rryy6ZCm5qx6kg8SgtjZ2E/Q9Ab+nWqjsI+G5jFwXyfxGNHLkVka5/AVArVqRUIzNmgFTMVnr0ieB67Dy4k10pRGhD2JepRyBVOUvTMy+ei+7EDhpwZ/eyOfBbw7IjEu/qt0mT9kMfi7M2utUsawUAhjGmDpFHhAt9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402689; c=relaxed/simple;
	bh=/RoyhdYukNF811eTCjhEptFo3Z3zlmtAMhc/rjNci1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g2qa6roViXolWJb7RyHCMrQsNvNC/eb91l7WGQ4Gp8JNhuuAqTQqYGwsPXGqv0BL39wBxomUIV3u92EZQEHbnLolBNfPEWix9i2fcscN1eH5+Z5Oxi2wVnFmCxYj+CzBWdZi2tgq4a/9u8IKrQHapjxcAOkvaQXgaVM0jTihyBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P0o/nAQE; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P0o/nAQE"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b0467f38c91so500110466b.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 00:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757402686; x=1758007486; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jzTBPzo1RmPhb8+X/BxESoLEFr74YKphkmy8Mb4+wuw=;
        b=P0o/nAQEQrKfdYPQeck/CT7TFegXGdSlbW5d2z59RFhAT5xtMUBsRGfpAmwleB1xKT
         lB37TyI102/d1O20X1MsiHzUdbj2ZwCiQJrNyXqff1HzFB0468Lrc5HM5WaVtNJdYIJ9
         Yl9Gw5423CKydS3BSDhUtYs6Y7nxGQnhTU3p++Ooxr7kQUs66TD673pfVgc3NYbSUbyW
         N8JKFMWnBeu2yezHEvQtlQ8FBYb7AJWVYGbSq0LZHdlqhV+EyUTGDhtHmTjLALwM7i02
         GnsgBi3V7xEKd6GevhLvDfj4DB1wfUxZgeFuSW6/HPKQeAupt0ssiN1hSRQGjh5yf3uv
         K3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757402686; x=1758007486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jzTBPzo1RmPhb8+X/BxESoLEFr74YKphkmy8Mb4+wuw=;
        b=qFg2DUdL0YaELr2Y2y1DEzMe9mLHGsbyt4Z3F6dJ+m25Lnp6+Fmzgf9TY6KcqPRtWh
         Vwcn0ph9XfC5MpHSe0TsgKO+xQvt4gDgy6QsaMZrc9l5u5kBSA9LM9P3P2CdlkKRSJoB
         Ar0qhX0lojvrCW2RhAtMi0PekdPySIbslEQPyO8YderXHh6ltrn16+DrEv/IA8+8ikac
         fSqYDVjCKjW59Dl0HgPiQPeemUML+gryZ9PX5CNeUkjGT/HtPECd4CbPc5oPPIVidgK4
         eifGAnL2KaTkyHKuG2q2ibopWjwDcI5R2V1yDnqENjVI5G6PYO9F6T848EosZ1BshgiZ
         mTxg==
X-Gm-Message-State: AOJu0YxRf1a0FMWIZjMOJuCz3NJ1kctBfRmh0fUgpC0UUDJcIelVqu5K
	sKyQFVqSAtBePQqVw0Nf+nTFR09Xqzg6YLvJy3dwJwIO3NzdjCJXyHhUBQoeKrRj60tT3i92rBk
	tuECGhSVELXjcoxdhHUygpaMEkp2SH8Dnp7SkLX2z0kjc2pJXA7osIWpzJ++qF9YSjltW3KUt7B
	tpobM7KEO5x0CffOXCMpLAIoOOStzcUkc=
X-Google-Smtp-Source: AGHT+IHmh166VNYe1I4Zw+3zEdt0B8cCwpziEei+0Qgr9xayp3BH6sGEsTZjQ1Gpk5CrVR6IZ8KwrbicDA==
X-Received: from ejcst4.prod.google.com ([2002:a17:907:c084:b0:b04:1c58:759b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:d89:b0:b04:2cc2:e49c
 with SMTP id a640c23a62f3a-b04b1408355mr1072484366b.19.1757402686150; Tue, 09
 Sep 2025 00:24:46 -0700 (PDT)
Date: Tue,  9 Sep 2025 08:24:36 +0100
In-Reply-To: <20250909072437.4110547-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250909072437.4110547-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909072437.4110547-10-tabba@google.com>
Subject: [PATCH v4 9/9] KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com, tabba@google.com
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
 arch/arm64/kvm/arm.c  | 14 ++++++++++----
 arch/arm64/kvm/pkvm.c | 33 +++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5bf101c869c9..b77ebe3aafb5 100644
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
@@ -184,6 +180,16 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto err_free_cpumask;
 
+	if (is_protected_kvm_enabled()) {
+		/*
+		 * If any failures occur after this is successful, make sure to
+		 * call __pkvm_unreserve_vm to unreserve the VM in hyp.
+		 */
+		ret = pkvm_init_host_vm(kvm);
+		if (ret)
+			goto err_free_cpumask;
+	}
+
 	kvm_vgic_early_init(kvm);
 
 	kvm_timer_init_vm(kvm);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index be3a094631b4..d7a0f69a9982 100644
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
2.51.0.384.g4c02a37b29-goog

