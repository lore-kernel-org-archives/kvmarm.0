Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5322322AE75
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753790421; cv=none; b=kSD0YiC2tppljW11in1jN7EaJgNOtbdHIDuDLrRd7rtBFyXdCmQE3qYw0F90TKsLN6n5OjJ/Pn86TCkeA4oxi49TPS+wS96O2RbCrYpTwPi47dErPaTB244WG4jiCnmpLhNoMPZPeCJSVpmOJV4PrBg1xYCp2kMgenNt5LpZ2o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753790421; c=relaxed/simple;
	bh=cc+kVUk5Uq2QlDQDKvp1t+3bYSXrq01IYtI10QZT5rA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g1ZvHerNjBDhSFDmvri9tvtz8+QCcL7r5bpdMD3oCBMijJFsS2TWK9Yk6fAjcAZwweEJzSmD0r18v7ReEispNtSaDXCpV53kparStnuGWnQ+UOSwUboipQLs837Gf4X65MnU7gCxherZmFI7JKKhjFMIOMxt2EgVSUy5k7kHeR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pXm7v95U; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pXm7v95U"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4588cfda8b6so6963645e9.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 05:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753790417; x=1754395217; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JuirtAh/ooKESl5pE7Y9JWmedNomhKt4Z9655mFfFNA=;
        b=pXm7v95UEFihhnbYOlpCoD/S2wtGMxb8Es/VFg0TFde2OkCJE+FNmOhtWarEzuANF6
         HVn7h9ZK27zEBRh2tLGLYg2OU5/DS3XgVr92p9Tz0VaCCi2xg4XlbxbjkQ29hcomZ8Ku
         +8IMC+GPIRFIEqjkG2wbk+QaGVgNw0y1yXXzWpC1HPORfZAtSYRpZolP0VNyw1NRZJ9a
         6A+dGIJncqjBoQoScNQuMFfmXAVjGo54gMmhwtL/dKmaqsLPc+1gTacZsR77wnkWI13R
         PGuPl3Ir1vxlHQ2XfXnm2kp48/CLrmpHh2NhTZg5CBlLCP+nuznX5WiYR1nZB6RhL57/
         01jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790417; x=1754395217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JuirtAh/ooKESl5pE7Y9JWmedNomhKt4Z9655mFfFNA=;
        b=ntGpPh57fLaNPB8OKNipE5jWStS4lODoUqYAai6LH6I6g+5TB9GwovqUTBH9YxUtqa
         9sXOYrv+wI/ffusQgU/ZCUGfjip1NnId9ek8fM34oT+k9OjebIhnW+uxJal4iM61AAFJ
         Byeo8jkpx5uAJcHvWdI6i27n1gkbUaVraFtMg5VUWTdmisFiHvJlIDlM40brRPwzkGzb
         SRL6p/RIy/lAiXhx0l1XDSuZazHAFnXnDLT3IywPk4WDGossEK+GERgNF9qNUzFtpwez
         c1iT5qWWhyeqHdTgioALKlwSXNBfuYc1C2J0f1nvkc0er0df4BofVV56wW+owLmGdmko
         EMtg==
X-Gm-Message-State: AOJu0YzF5tPRXkjMnSAOlWWSLwveKyfIGFDDkyhawbAZbjX2YvJcsa5G
	VWtW/kX4SKaB6u81NaNj3mF4I2My2ZVan3KqO2I2zTzgS5MoBiYNztERxQbW/jqwDEcgI3UVDsG
	SNdELpTQVXyxuWLQn2Q09HVm2uTKjIY4YBinAQqBaYc00uDIPq6hxWJxNkrA7LI/4GQzykOylLB
	P49F+BYJgkGr3qfcGkaFJWRWkpigjxzos=
X-Google-Smtp-Source: AGHT+IF/ZdMy5z5w0R1oV7hxo9bt+6PmsbOiXbjNanlJOFkc2x8Z0wmo1t6KVMgsDlAwJiOArix8E6QTaQ==
X-Received: from wmrn32.prod.google.com ([2002:a05:600c:5020:b0:456:19bc:aa56])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c059:10b0:456:13d8:d141
 with SMTP id 5b1f17b1804b1-4587654aca2mr79334875e9.27.1753790416636; Tue, 29
 Jul 2025 05:00:16 -0700 (PDT)
Date: Tue, 29 Jul 2025 13:00:07 +0100
In-Reply-To: <20250729120014.2799359-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729120014.2799359-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250729120014.2799359-3-tabba@google.com>
Subject: [PATCH v1 2/8] KVM: arm64: Rename 'host_kvm' to 'kvm' in pKVM host code
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
functions within host kernel code (EL1). This improves readability and
makes the naming consistent with other host-side kernel code.

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
2.50.1.487.gc89ff58d15-goog

