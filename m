Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21332D6E67
	for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 10:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756290000; cv=none; b=QFLFdvh9JsgiuZmQ6sQhX1zD/YK0awP+liEasuorEkqFnTspYzKJPOp7qU4eqCyfNQ0GUpWyPhI1as5zjGfzh8rNVz6QYHB1RbqVOO1YsOWFlZHpZTfjxcMdLWV8gXVPvXPfYvqY5eJu1ucrfkQDbcOh8UhXcSjTOlV8cXFz+04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756290000; c=relaxed/simple;
	bh=2u7xUZAwtNIGROerZUcf9R3iLRZuycGwgphnnLEtnuU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mrXaP2HWQ5DEu0BoCHIaAVI505NKEYXny1r7xJBibsWgAjmfJc/TCW9uDU7wLcY7Gg14Ig79qrbO/5n+n/Qtiq6cann60OGwf0J3HfMq9wQ9kJMm8JPH8b+6uvIETPq1C0hDLzWPbePnr/eGItDutwsSbRsVAjrjTX9AUxM6CBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FQgB19YK; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FQgB19YK"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3c380aa1ac0so2566936f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 03:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756289997; x=1756894797; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qRapLocKqPQxV7fCh+yvdCcP71Plz13kPXNzSMAQPfM=;
        b=FQgB19YKqiWhp9dnXerZbkw1DM9cRVWr77OxEgXxcLM3NTPAxFQTOfKDwtFGq7cx5+
         v+BBqyVQSEvUYpUla6BfOef/qrendT7jCl8pn/brm+03+eoRQn7XRErXUDKXwR3Dl3c3
         zIp6kjiP++k75eMl1pmiS5AFofucU0jF3KDckNkNvHdljBclUxvC/dCWSW7RXoJVv4bj
         Q6t7Wp8upwRjwcJ8yaBU7vPgpL+aF8TFiI/+N6vkxRe59xc58iG/kSp4BwACvVJsro83
         rKkJDHMbzFP9ss0s9ViEKlLXXuSFVnLAO9St/PD/rOSHAjstr7eqpXxp9lyPgnTbF8GS
         31JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756289997; x=1756894797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qRapLocKqPQxV7fCh+yvdCcP71Plz13kPXNzSMAQPfM=;
        b=Hhv4kgFSmd4VfM2nlUu/BI2irOJQyRrN7ICrJMqtfRBsJ0+Ozgc7ZGG7MWhxknAxDL
         SYC+fExACrTnD1MRGC1MIXUBccGsVT5iKVGE+e9YtxTNLqJtWKQp7UPgbscWw+vO4W8i
         7oZT73G0YPFAfna4y9DbcY6CGRx7L9cu3h/m3Z5oA40W0Pm2z/uYWLsdwwERZGyBLUom
         Ke/0itMmhHXDO7PUbq5Jb365Muu2KrxBVT1aSiVUldDtDCabMyoS0MUyu0nNMQYVvWFa
         YPepHcZtpkoAjKs+p6gVH2v/hvgKTpGruxUnMDs7FpcLeRiYiJQfvrCZb0tDBbtZ+ejK
         RstA==
X-Gm-Message-State: AOJu0YzdAf98M/PUuJRFpe3W5TqBXaspY46U9C1I8AfY+eND4DEeeOeC
	4XCqOeH+dlYUpt2iSq2NtuoZb0DaVrAIgX0S/p+rfbCyO98df4i02KFQHNGopaIxFhqaKzi6pXC
	KOFlXntHe3qE/E6mtdYkUePnAQkANY+90uOdaCXi8AL3v5zMUe0nP65EC3Q3QjREVpXRNJyTNqd
	cSrqpND6HsX0paPwCHfNAIQ/IXkDasKjM=
X-Google-Smtp-Source: AGHT+IGMXNFuHEVLWqZbBsEXy6JKMid9YIc8LN5dBwVuR5WYPnrbYCExmUvnij73N/ExhE6hMue6DAHNNQ==
X-Received: from wrbcp41.prod.google.com ([2002:a05:6000:4029:b0:3b7:8249:b333])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f8d:0:b0:3c8:d236:26aa
 with SMTP id ffacd0b85a97d-3c8d2362b89mr9928954f8f.58.1756289996961; Wed, 27
 Aug 2025 03:19:56 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:19:45 +0100
In-Reply-To: <20250827101949.4089456-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250827101949.4089456-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250827101949.4089456-6-tabba@google.com>
Subject: [PATCH v3 5/9] KVM: arm64: Decouple hyp VM creation state from its handle
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
whether the hypervisor-side VM has been created and initialized.

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
index a4289c2f13f5..bc57749e3fb9 100644
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
2.51.0.261.g7ce5a0a67e-goog

