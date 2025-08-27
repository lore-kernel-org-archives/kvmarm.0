Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D02322774
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 10:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756289998; cv=none; b=kmENbsSemG61bXDuRx17roN3tXI3PRV6ZlycpZnH6Sruodr7r4syyDp7jjnzAuM9PCE3SxH8J/OsWHJRTK6qdrtor7LFRpk2aUUod2t1lrbuvwn7vFAdABjY8p0qOBWMxQGuTHbtEtAocX4yHeD2uzQAVDHHgdsQiSlM4icVbzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756289998; c=relaxed/simple;
	bh=yMsqCFuY+bR+U5tG1FCkdWbnnAT9z6AX/ZiyaHJIuZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eTQU4ET5YUgHIFrtAwa8J7hzLaMERf5rdtc+w2/xyQDmvoRXa5i8UnXbNowzsyOK+XMCI4dfvQNhJSZ8DJJc6pLn0euN4F9aeoFy1uyn/1kRd/Stvw3R8cg0nCw/8HqczKiXPDc0RsbwidoXqIj8veEOxvzIs5OQhbZuHkgGEOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vhyXP4ZZ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vhyXP4ZZ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b05a59cso46477455e9.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 03:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756289994; x=1756894794; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zEQqwcT97w0z8I5SOWtyA7yrJCXJDofviZgO0hF3uqc=;
        b=vhyXP4ZZE/wTHhb62BmXw9WUIUJPBvC3d8ti53nmryS0iVG9YYSdLlcA41JWrbxDRg
         SVmQbD3qXBOAmXBuA0JFkQczerU1x/2PevxpayiUKnEBLseCAjAwfb2HltpJPqhJtk1f
         TU2jCxMgdq9etzJH04Ml+HysM6VhxgOflxaymofTdKWaen8pnv+eU9YZflLXeTlPvYe8
         sJC0W/sXOg+0hOwGWA0JEEay55ecN+Tes49vTuI4X9o3KixYWnDC6SN47sBezlE1IzwF
         XmgzzvflKyE+7WPwQZrgzVYmaI0Wea/qdwEJ7lNExOe/cdZrXw9ffhjtFEl1YAuQbLI0
         CV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756289994; x=1756894794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zEQqwcT97w0z8I5SOWtyA7yrJCXJDofviZgO0hF3uqc=;
        b=URlUXVTfly8uFj5MMKzTVDzdIEu3yus4IJbQfJLAcgf7v4ltHmvW/j6HwTiCpEBkFZ
         YjIlJW2/7F/LlYuQKed6D6l3iuqdzRYokyz0s+DfT3rArVIjAM28xriJTq08bxtTw681
         Gt9peZRXp6mRqTC83MN5BZ4B9pOG7d/kstZlXGPC6dvLu+EA0DdItOFcjPjy0W41L/6G
         U9wmLEh55S6ncuy7/zOL1rP8+wGIH+AKMIeXPqQtVqQtXm2KuRN1eLnmlWrQ/6k/8QWn
         VsPLcgR336BoIE8lZ7DDbS7r9I2GQxODeqjOXO99rkqcxBHJRCqRdoFg7NUMKCsiiz3f
         f8lw==
X-Gm-Message-State: AOJu0YxaSaQOOXuww36NmYLeEvsuQawRqjtIwG+PLH7YhxzeS6FJQsXr
	1E9guY0YwH0KYmJd+lVLr0WB+Y5bA8Yp+qSMzv8fckRQexKj59qsejdXVGiMMu00ybAl5+oLCbS
	K2GqrulQ2VFSkDv481Ula02OPmM2+JTsIHr4mTwAw+uF77HKyGWmM/88kgFrpaVPhDGUtD2RzEY
	jA3FIwHtiURxHsm7vmQjXDQbIq3La0tTI=
X-Google-Smtp-Source: AGHT+IEiDh/fn7CkNKdOfyZg3Aa0XfGGtFGJ1J2wMvbUhdBD/7OWpd1B72/rLsUyXcwASIaZmkTDklZqfg==
X-Received: from wmtg2.prod.google.com ([2002:a05:600c:8b52:b0:45b:6360:643f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:444f:b0:458:a847:671e
 with SMTP id 5b1f17b1804b1-45b517d402cmr167116105e9.23.1756289994396; Wed, 27
 Aug 2025 03:19:54 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:19:43 +0100
In-Reply-To: <20250827101949.4089456-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250827101949.4089456-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250827101949.4089456-4-tabba@google.com>
Subject: [PATCH v3 3/9] KVM: arm64: Rename 'host_kvm' to 'kvm' in pKVM host code
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

In hypervisor (EL2) code, it is important to distinguish between the
host's 'struct kvm' and a protected VM's 'struct kvm'. Using 'host_kvm'
as variable name in that context makes this distinction clear.

However, in the host kernel code (EL1), there is no such ambiguity. The
code is only ever concerned with the host's own 'struct kvm' instance.
The 'host_' prefix is therefore redundant and adds unnecessary
verbosity.

Simplify the code by renaming the 'host_kvm' parameter to 'kvm' in all
functions within host-side kernel code (EL1). This improves readability
and makes the naming consistent with other host-side kernel code.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 46 +++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index fcd70bfe44fb..7aaeb66e3f39 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -85,16 +85,16 @@ void __init kvm_hyp_reserve(void)
 		 hyp_mem_base);
 }
 
-static void __pkvm_destroy_hyp_vm(struct kvm *host_kvm)
+static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
-	if (host_kvm->arch.pkvm.handle) {
+	if (kvm->arch.pkvm.handle) {
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
-					  host_kvm->arch.pkvm.handle));
+					  kvm->arch.pkvm.handle));
 	}
 
-	host_kvm->arch.pkvm.handle = 0;
-	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
-	free_hyp_memcache(&host_kvm->arch.pkvm.stage2_teardown_mc);
+	kvm->arch.pkvm.handle = 0;
+	free_hyp_memcache(&kvm->arch.pkvm.teardown_mc);
+	free_hyp_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
 }
 
 static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
@@ -129,16 +129,16 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
  *
  * Return 0 on success, negative error code on failure.
  */
-static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
+static int __pkvm_create_hyp_vm(struct kvm *kvm)
 {
 	size_t pgd_sz, hyp_vm_sz;
 	void *pgd, *hyp_vm;
 	int ret;
 
-	if (host_kvm->created_vcpus < 1)
+	if (kvm->created_vcpus < 1)
 		return -EINVAL;
 
-	pgd_sz = kvm_pgtable_stage2_pgd_size(host_kvm->arch.mmu.vtcr);
+	pgd_sz = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
 
 	/*
 	 * The PGD pages will be reclaimed using a hyp_memcache which implies
@@ -152,7 +152,7 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 	/* Allocate memory to donate to hyp for vm and vcpu pointers. */
 	hyp_vm_sz = PAGE_ALIGN(size_add(PKVM_HYP_VM_SIZE,
 					size_mul(sizeof(void *),
-						 host_kvm->created_vcpus)));
+						 kvm->created_vcpus)));
 	hyp_vm = alloc_pages_exact(hyp_vm_sz, GFP_KERNEL_ACCOUNT);
 	if (!hyp_vm) {
 		ret = -ENOMEM;
@@ -160,12 +160,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 	}
 
 	/* Donate the VM memory to hyp and let hyp initialize it. */
-	ret = kvm_call_hyp_nvhe(__pkvm_init_vm, host_kvm, hyp_vm, pgd);
+	ret = kvm_call_hyp_nvhe(__pkvm_init_vm, kvm, hyp_vm, pgd);
 	if (ret < 0)
 		goto free_vm;
 
-	host_kvm->arch.pkvm.handle = ret;
-	host_kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
+	kvm->arch.pkvm.handle = ret;
+	kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
 	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
 
 	return 0;
@@ -176,14 +176,14 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 	return ret;
 }
 
-int pkvm_create_hyp_vm(struct kvm *host_kvm)
+int pkvm_create_hyp_vm(struct kvm *kvm)
 {
 	int ret = 0;
 
-	mutex_lock(&host_kvm->arch.config_lock);
-	if (!host_kvm->arch.pkvm.handle)
-		ret = __pkvm_create_hyp_vm(host_kvm);
-	mutex_unlock(&host_kvm->arch.config_lock);
+	mutex_lock(&kvm->arch.config_lock);
+	if (!kvm->arch.pkvm.handle)
+		ret = __pkvm_create_hyp_vm(kvm);
+	mutex_unlock(&kvm->arch.config_lock);
 
 	return ret;
 }
@@ -200,14 +200,14 @@ int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
+void pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
-	mutex_lock(&host_kvm->arch.config_lock);
-	__pkvm_destroy_hyp_vm(host_kvm);
-	mutex_unlock(&host_kvm->arch.config_lock);
+	mutex_lock(&kvm->arch.config_lock);
+	__pkvm_destroy_hyp_vm(kvm);
+	mutex_unlock(&kvm->arch.config_lock);
 }
 
-int pkvm_init_host_vm(struct kvm *host_kvm)
+int pkvm_init_host_vm(struct kvm *kvm)
 {
 	return 0;
 }
-- 
2.51.0.261.g7ce5a0a67e-goog

