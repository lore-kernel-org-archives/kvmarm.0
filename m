Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE48B214812
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 10:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907593; cv=none; b=CCw8ap/ackBzxoAyoIFx5dULfKIi8jsW78mbpKk0vg/VeTou+tDrX2vgfEsXDPLIYWxEMl0+XPd09edmluWW54RPQpaUglc52Bageznlj90UhsyRfmtVEBlFx47fv63hPIKneqxU9xgdUp37DdVra8aMuChWIQj7u0blP0tShCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907593; c=relaxed/simple;
	bh=aeJFvbc2dT0vb+bAKQuFZYhntD8U0ti1oGfnCznmkeA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kkv3lwL3cAyMCUhoMsbn+flJlMeBMng1rQo8daoQC9BpiscATs06K6LZnvJJuOans8fPdS3sbeSNts1QS7IyxRu7CAzLeAXu/lra8g/2QmfeE0l7i8WqIhmWKRHa0ToGazwn7OJqbquIaF7YnxT0aji7ylkqtZm/bFH5iV6CQro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UMyk9tNr; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UMyk9tNr"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-615a9403e17so4008598a12.0
        for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 03:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754907590; x=1755512390; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fMPI0KfDFQZoDbV9gU7g+JMTY6H4n5QM5OKNzo1w9wU=;
        b=UMyk9tNrbZ1NR2D6pNsYvxfZ3eD/BkuS6I/myg60YqBfNssGFuY3Pkd3Md3ot8niU4
         EFtsDlLjDPcHLAsiN/DodcNq8NiMkjJR0legEr8AogVcyzv6gFF4oEmGoBA/9muNHmvQ
         fXWGtKlwRKAXYlKgj2lgmaqgb2xKycPyKdmrnMRXVVI34b5ISe7FC+bppHHqKur7Pin0
         dEeeJx2ByhynXCx/HKQW91SIPbWM/RaW7q9Kjde1Kcu2a3QnXXUL8l0o8K7/GflDYdpr
         Ni7yjWvkm2q3mj8JmsE6sF/rswMdsc2QH+pPgN0lr78V0bMNGzaRWBCc9VHqQ1Ju3Z0e
         jiZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907590; x=1755512390;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fMPI0KfDFQZoDbV9gU7g+JMTY6H4n5QM5OKNzo1w9wU=;
        b=hweeyeXJQ059l3GVdXumB+ObkfXxDF7TUkqjJwTEEB2RhADDzpkSbdCXkvsEO7qgxI
         H2Bt0PKjz95eD0UeBHW3783/k6z2yjKJnbLFseXJkmPnyjjjHMsiUksh+9BdeLNRViDg
         miwWO85PB6TKNOrdkTCQ5PmLN4ZbCgjzWxFMBx2qu3ZnF0TX+tQPt/VLlY7/kycqqB7Z
         VRWoDExC4MvljXuMt8VtpgUK16d18AywAzu+Bmy6lqGt60NxuKR9F8iyFY39B43by/PK
         WBigbpGiYoXF8o4ZINpvV3+i0WKMMbQotovKGBiO0GY0sBJZQR9KGC3AnwskF97awcGx
         Y6vQ==
X-Gm-Message-State: AOJu0YwDqHCmAh7iXhZ9/tgoagShw18uPUSLu6CQKuQo2V5/vY4ng+WF
	5FllgUkGJvZeEF7Ephblb402eZHtpKWADuIHCQdVrwxofXyZBFHX+JtqbIHSdECwS1lhHcweW1r
	4BqJgvj/L0lmHEvpZ4+yBPXgTasGSmoQYVI9q6uMJXtUNg3GG/Jv2YMfwIjlRTT6i9ghPCiih0I
	Ah4rdMKSm4ne7fyBl2xlSw7BC3Y/ou+wc=
X-Google-Smtp-Source: AGHT+IFUZ0WiEg4bHvCBVE7aArkXQiDPFm0FyTeTbJOVOXcKuE5+ecYtvtbIYFOCpXOeW6roXWnhHXRB5w==
X-Received: from edbfj7.prod.google.com ([2002:a05:6402:2b87:b0:615:5526:ba13])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:d08:b0:618:2011:caae
 with SMTP id 4fb4d7f45d1cf-6182011ce2fmr4190364a12.4.1754907590160; Mon, 11
 Aug 2025 03:19:50 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:19:41 +0100
In-Reply-To: <20250811101947.3637632-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250811101947.3637632-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250811101947.3637632-3-tabba@google.com>
Subject: [PATCH v2 2/8] KVM: arm64: Rename 'host_kvm' to 'kvm' in pKVM host code
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
2.50.1.703.g449372360f-goog

