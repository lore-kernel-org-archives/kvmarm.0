Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50101F30A4
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757402685; cv=none; b=kZMi96R+fFktHcxdiX9V/te18CXKd6aC7Pq8CMXW42zVOCzYNWm3PZ5RzwO51BxrzUr4oIK1orE3kPlnkkPh1wB7bXOdVmpiPMU0RE6CM4j77jv2IYTzq7SCy689gCiXKUBUqNaU3FzA8M4zSxBOS45DLRKXyraN4DPjdbNzLOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757402685; c=relaxed/simple;
	bh=NNTpI0u22oVkD7h+kLi+/tr1S1zVt1I28+NqnEvbbSw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SemcKJgxt9X6zMYa0Xu3QNP7UOlysJoB0t6R9DlhaC0+ZH9jl5dNZXOaJJXDmgl5SuC6gYSP/aYBUQ0kzyK9vdVlc0QcwiUIC5vt4vAZADbRgaTGlRTYTUFy/KLMII31ch0uNy7F92nC4gstdgdVui9XatBvuEpkkCH/9Vb37Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bpQ0r3wO; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bpQ0r3wO"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so40844555e9.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 00:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757402682; x=1758007482; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XvS7suGai3RogclrAtRQ2NtllrH/ITXs0daVVO19SRk=;
        b=bpQ0r3wOf5JCafvo31trWOg3EJaStDLFSywY6LO4vN+9NsE8/DFCuTKfLJWNJ7/eYg
         8PEZ+idSRSYhK59oyBYQZ3W0abb5udSs2FNqlI4JBmUGmHv5mmszg9rNBI9ZDHJGTW2a
         f70pLfZxZWx3Z7Ft00ZDXlq88mck2+f1XlM5X9rqSN6tUNmpJCfNFxllW5/WdDDz+9Pm
         dnjhhkEYs41TazpPqFOoEO9MvIG9QVUD9VwE7e5aWYZ0pcJSNimorcNMK4OuVb8jAO4E
         2FTf79NRzyQsgfgmriQHPKpMlevf7XY1cOrr4eTMBlDO8cnkhN+sSZip6zQJD4/0Q2DA
         k+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757402682; x=1758007482;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XvS7suGai3RogclrAtRQ2NtllrH/ITXs0daVVO19SRk=;
        b=kyUz+MfAiLeprQV30wuPqmAjWlrM46lEbjl/zlWTE9TRsD/Ia7GKlbewBL1IIp0ks5
         tlm17W255jX+nyHq9fezUu75XQIPYG2o7y1AX2m9R4KoScAeTrEBs+TMutuLzMQG0P6H
         /8f7B3jb+71MxGBV9NpUZmTnVJPQFdI7PzEs4ednmeHTAY2EOm0NY11Vh5kNGiiMrTrS
         JLq11CXdtsj3VW4ax9Pcn6Ygc9xHPDmkzk/OzwuXOBAtHypkNhlVUx+Z+YUOMrt3DA7B
         pHiu1lEf+uq03zZrgwZorGdkkqx6hB8KKeJXCzJwYrp/fvNycxN/L8v4Da37nd2F5Hn2
         rEIw==
X-Gm-Message-State: AOJu0YywhnUW0aBe4ivSzlUPwYAOANg/4f4Nx9IHOXt5cfLEfejItwsO
	eTq2aAxcDqMiR6cdB2HHQijLsj7EfVqcc/mAfukk08R8u776nsHN0/3UEwRTxslowhOIYkytayu
	f8qH6Vl8RlFeGpTz78C6FdMOXXbk1K1dOfCxOyM10jHWkCLZvJ/buuEwVfimUkHmutH2KDzW0c3
	W7KcX+PvLG64wtWtc41Qf8Hj+RZAXZhV4=
X-Google-Smtp-Source: AGHT+IGCQIIQO3QV9jVW7Oz8ZQmopDoADhxOWLjQ3E53XncqD6Lg+ss+CmkgZdMZsNfhbiDRQEOa0wFZjQ==
X-Received: from wmbes11.prod.google.com ([2002:a05:600c:810b:b0:458:bf93:f0e1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1987:b0:458:b01c:8f
 with SMTP id 5b1f17b1804b1-45ddde8a55cmr115788295e9.8.1757402682154; Tue, 09
 Sep 2025 00:24:42 -0700 (PDT)
Date: Tue,  9 Sep 2025 08:24:32 +0100
In-Reply-To: <20250909072437.4110547-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250909072437.4110547-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909072437.4110547-6-tabba@google.com>
Subject: [PATCH v4 5/9] KVM: arm64: Decouple hyp VM creation state from its handle
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com, tabba@google.com
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
index 7ad997dabddb..8ede884f091d 100644
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
index 35f9d9478004..0aecd4ac5f45 100644
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
index 358168572482..2138dbfcb04b 100644
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
2.51.0.384.g4c02a37b29-goog

