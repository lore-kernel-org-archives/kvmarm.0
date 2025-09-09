Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CEC303A11
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402684; cv=none; b=UXgEKnuhdkv81zIzbaWDC+CrobANtoXOXz03vRg0etKU8AGbekPuLhsRiHqyX3S4K/odhTm8C0e9HopV4Fm+TAppv1moKtLHJYo45Ld0Z+hjCxdimq2oONQUnQ1tNABr8A3ZqfevjHg0zewQH1HJSSkBkdWi99dI46qeyMPGVK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402684; c=relaxed/simple;
	bh=YvYWpF/VEaT5Lnht8xKBRCWsOeSQ2vyXiqfjuv40Mu8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=je2H+Ht+y2Knj2sWEpCjzzXr1RRJjdzVqbC1nIV07smUsGTxa8/fE2InY49Q3t8UjQWLmsjwyBnNjddhMOoRdtQ+dGhrJLdSaTQQ0xFHdMo/LpPROGNiDw0FIuy2I7j0QFSxkHVxMVZsRhM5Mf35THx8fM3rwq2/3u6JttU9F5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nIxdz7no; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nIxdz7no"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3e753e78902so20949f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 00:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757402681; x=1758007481; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=34bWVVpcfIFV1+aBsQNWlTAT8wFaE3/yxrNCs42Ms9c=;
        b=nIxdz7noDwJaW6F9trT4URNhy9nIJLk8i+UpDi+v9t3ET61KY2yi3BDRYqTvlS/kfi
         V9RCsdbMW80sKaOD29q9c3KIMweAjTFszc0P6R4U+wNR/QnrtIh8+H/5cv93UvRz86tg
         jcv7BWsuWOEiTOZXIvHpiyJKDRFDchqO1Lgi3FT6qXggZg1gshLixxV8cZ/YydoWwRwf
         T0zUtzXs99Vt38a70b6fs/nrJlr2+P/hLoAfSj4dNZgCSCNduzdXv0J6yUb1h3HCcSLj
         QyuYfgBo+t0SPkdP/c4+E3hHCe/YFX7/igsArAwU4x42LQnniQFDm6I6sgcZpQQ42ZzU
         NfKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757402681; x=1758007481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=34bWVVpcfIFV1+aBsQNWlTAT8wFaE3/yxrNCs42Ms9c=;
        b=l23F/LcekW8wrcnqwh5tTa2PxboCIsn5CpCnkqXxTq7kMnH073Np2XnlaUTLx3L3n6
         afNHaMBUDmpBsH6dJP03G0jmXw5Yclxl0nF+BLKMSGWMze7g9i1BXSZq5xFLfS+UWpXp
         RVkkATEMtLT9blhP4ht3EddskaAU5u9VW6UXjtV85YpVciW4JoiP/VtagRybiQxrsPRZ
         Nlt9rnUl+oVTM4+zyNmarjcdbg2L4+QEBdaqH9D5nGH+DV7OPrwWtQyS/U/+6SQ39emr
         UHpqh+95ePQWXYmYHDFTUuTJnDKi+0wpY1Q6peHFcKT6yzKY1tYqG9VjlZSYo3R3ikcx
         jv8Q==
X-Gm-Message-State: AOJu0YxtrcmfkZ+fToWtaXHbDYdmoz6EzaGxwIObZ5EBpeAAI5r31D22
	FOPqbq6WZTpA+dYSs/SXbNNP8j48DwZIwzUCHo084yUdrBPnAT9BJWm52P5XydIKVeAptKBSs6j
	2U9l03W8g1BZkChYIqT/tBA9GePARTDfDVMx6HKI8srqsaRBDpAUmRmnXS89gGzcKErxXDZlAyq
	GT8ZbJi/DuzWsbbeOFidOapluYiYslSuo=
X-Google-Smtp-Source: AGHT+IGOjKfjXWLT99zqYiYfu8ZoWSI57jP1W8PT7WvNSC/Kd2kRGmsJ5zeutnwGBNoebSP8RPCwvycUkQ==
X-Received: from wmbev15.prod.google.com ([2002:a05:600c:800f:b0:45b:4777:8063])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1884:b0:3e7:4719:a054
 with SMTP id ffacd0b85a97d-3e74719a711mr5301655f8f.7.1757402680602; Tue, 09
 Sep 2025 00:24:40 -0700 (PDT)
Date: Tue,  9 Sep 2025 08:24:30 +0100
In-Reply-To: <20250909072437.4110547-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250909072437.4110547-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909072437.4110547-4-tabba@google.com>
Subject: [PATCH v4 3/9] KVM: arm64: Rename 'host_kvm' to 'kvm' in pKVM host code
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com, tabba@google.com
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
index 61827cf6fea4..358168572482 100644
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
2.51.0.384.g4c02a37b29-goog

