Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8334C235358
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753790422; cv=none; b=pWj91TDrMvpHkTzHCjqcfqBOIFQiopc+bS4zapMEVyXpXoOTPMx68oSk0S50AP3Mr0ewo4VRb3WMaKPkbg/4+HPl+AmW+vvJlmsdPkBzcI80BVUv6n5OXW2he3E6XQlUQmwNg44hmXaMfgjJtOq31Nhc4QTyxnF3peImFEJTbQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753790422; c=relaxed/simple;
	bh=KXx/wnnImZ/mTS59eX7i99A8gvVjI1DMiKUPAPtLkXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g6QnthS9YtFR9ejASmsynRlFXVUOmrDvuFeqbmURjHMkUzUkw19P6CkM1xt8Zor6Cp0CmQei2lFcuIzfmd7ETNiqkPWXLyAUvVM/YAK72TJLCdAMzP6WRM4UA66y5bGbNRZ48nL96jQmMAMAbXCvdGtfpId8Hu0X09ggSxTf/A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2mNrj4bN; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2mNrj4bN"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ae401eba66aso360616166b.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 05:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753790419; x=1754395219; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X+RC2G5i+r7lX7kvetU9fTffg9bEuD+WjxuGHJdH+ak=;
        b=2mNrj4bN90sC2LoRRMGvRrebcymYIxKtqPtbuI7BZv0LfDZY7lnJH3/xdfWn5SVbwo
         aWnqm+jdKuVdd9ckwFI5EYgEV3Jr3JGxOxoJGRoA54NG+xaPvRduXjxDhBKFzs9lY6Vc
         MrA+DpHpPcmKYen8ZjcAyD02sTS385wjDA1LUl6ZOpEuGsZ/LKOZXtf1QRzrGf61i+fA
         glRYKt/iENVfLRvH6Dz4jVucH8QMWPV0RmOIYVYnI8iQNsrEKNjV9c85g6+4+dFQqRbU
         mUKPSH5iIRFL/HqSqPwZjGhWy7QCKNqWJx31JULw6cneTxKAZ4zLTM2fePzTWmEluGyT
         am1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790419; x=1754395219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X+RC2G5i+r7lX7kvetU9fTffg9bEuD+WjxuGHJdH+ak=;
        b=CITOt8RnYl5Be/kkFyAOW2MfRQruwgr2D7YbGzlP1Gm0h0vGmbXoidcP2D8UW4ruhx
         3NLp2t8qxjbn1sFkZ6ZibHEgfLZMXjVan2yhbaV5bOuUGAA8ag0esV681F2gZrUJnF4H
         qIgMGi/kKDPgEp3IErtn4YXz++VEaJIrRSuFKB8p+b15/jW0r85jmTjDMk8lb2RGXCVf
         XbaheVzufLRmQzI6YyyHEorDVrLnMD7x3atIDmEYdvSVTHuFz+CQ/nOPrS5wqlF+tjDV
         UzN2CO7KeXCPFEs+cq9hZED7xVcrsamTv4KYxYFsO/z7t1ftgRip1kt73FR+5c2RtaSK
         uWdw==
X-Gm-Message-State: AOJu0YyOK5Ed8iPhJ9JTv6XwBvoxNDEFSyQ+WosFDs+gch3MLTV/ru6k
	4P58xO+KET9XS4sPBMoxDDyg+lmkuagefFIMl343tYxXvTpBAs5bnb5Zy3vsFmU8GotXKYMVJvL
	h62FpOMx/ak8gF+rjk+Wl/LLnc5dwZGsQrrdkFcdiy4hovIUUi0PueDpMyW/9VTRBEXgAvjOv9f
	3nwfnqYZ4j3TMOigzvaR/wjP0xuf8+8vE=
X-Google-Smtp-Source: AGHT+IGlPUB2Q7OOgU/4rOub32/DQVY8ckIbgBq169+TSPDC2hzDpvacIFK83TMGJHQLAOsh0rnZtO3BiQ==
X-Received: from ejcvx10.prod.google.com ([2002:a17:907:a78a:b0:ade:3281:2981])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:948d:b0:ae3:6744:3680
 with SMTP id a640c23a62f3a-af61e43b5ddmr1781870866b.42.1753790418601; Tue, 29
 Jul 2025 05:00:18 -0700 (PDT)
Date: Tue, 29 Jul 2025 13:00:09 +0100
In-Reply-To: <20250729120014.2799359-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729120014.2799359-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250729120014.2799359-5-tabba@google.com>
Subject: [PATCH v1 4/8] KVM: arm64: Decouple hyp VM creation state from its handle
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Currently, the presence of a pKVM handle (pkvm.handle != 0) is used to
determine if the corresponding hypervisor (EL2) VM has been created and
initialized. This couples the handle's lifecycle with the VM's creation
state.

This coupling will become problematic with upcoming changes that will
allocate the pKVM handle earlier in the VM's life, before the VM is
instantiated at the hypervisor.

To prepare for this and make the state tracking explicit, decouple the
two concepts. Introduce a new boolean flag, 'pkvm.is_created', to track
whether the hypervisor-side VM has been initialized.

A new helper, pkvm_hyp_vm_is_created(), is added to check this flag. All
call sites that previously checked for the handle's existence are
converted to use the new, explicit check. The 'is_created' flag is set
to true upon successful creation in the hypervisor (EL2) and cleared
upon destruction.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/kvm_pkvm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  1 +
 arch/arm64/kvm/pkvm.c             | 11 +++++++++--
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 55dc7cd83e40..622b45532457 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -253,6 +253,7 @@ struct kvm_protected_vm {
 	struct kvm_hyp_memcache teardown_mc;
 	struct kvm_hyp_memcache stage2_teardown_mc;
 	bool is_protected;
+	bool is_created;
 };
 
 struct kvm_mpidr_data {
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ea58282f59bb..08be89c95466 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -18,6 +18,7 @@
 
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
+bool pkvm_hyp_vm_is_created(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
 int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index abe173406c88..969f6b293234 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -407,6 +407,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
 	hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
 	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
+	hyp_vm->kvm.arch.pkvm.is_created = true;
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 }
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 7aaeb66e3f39..45d699bba96a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -87,12 +87,13 @@ void __init kvm_hyp_reserve(void)
 
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
-	if (kvm->arch.pkvm.handle) {
+	if (pkvm_hyp_vm_is_created(kvm)) {
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
 					  kvm->arch.pkvm.handle));
 	}
 
 	kvm->arch.pkvm.handle = 0;
+	kvm->arch.pkvm.is_created = false;
 	free_hyp_memcache(&kvm->arch.pkvm.teardown_mc);
 	free_hyp_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
 }
@@ -165,6 +166,7 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 		goto free_vm;
 
 	kvm->arch.pkvm.handle = ret;
+	kvm->arch.pkvm.is_created = true;
 	kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
 	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
 
@@ -176,12 +178,17 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 	return ret;
 }
 
+bool pkvm_hyp_vm_is_created(struct kvm *kvm)
+{
+	return READ_ONCE(kvm->arch.pkvm.is_created);
+}
+
 int pkvm_create_hyp_vm(struct kvm *kvm)
 {
 	int ret = 0;
 
 	mutex_lock(&kvm->arch.config_lock);
-	if (!kvm->arch.pkvm.handle)
+	if (!pkvm_hyp_vm_is_created(kvm))
 		ret = __pkvm_create_hyp_vm(kvm);
 	mutex_unlock(&kvm->arch.config_lock);
 
-- 
2.50.1.487.gc89ff58d15-goog

