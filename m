Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DC23D301E
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682541; cv=none; b=NUKmMLofYJMvmxDOHtXDccqvgjRi6l2Is3nj/tpw7WtK9v4Wrb+eHLmR0Mcn1mQKVOwdNHtY54nW8Rfqx+m9rbtrSF6dyBBdqStew/w4Aane4luUSJJ7TphVFxed7z/ZOGGSoUj5ZU6W2NGbIc7X9xPv6DojRS7d1djirG4eUyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682541; c=relaxed/simple;
	bh=iv21fNrm1yVCcrQj6JMF7U6IPCudWrvUh7tyZZVzSWQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kDq6ePaoPFHw+X3eGBWujm8i0y3bxDFU00L7rSOXKuJjCG5ZSXndsutAOdbexT15GN7VdMXQyFPEmGqkNzKNJWaZH0XX23teLaiXCvSHLDAJlBniTcXaqofZg1cjQiUChlX3bqRpk8NSZ8ziNffZl/CN2JT7OlfEmqkl3/L/C8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Asp26Dy0; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Asp26Dy0"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853b5b0fafso59890045e9.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682535; x=1774287335; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CpR3ACqU07aVtibziRIGQBdLLRT1jdd+Sta0uM61LtQ=;
        b=Asp26Dy0M89rW9KHrCLO9GaXzIqsW0YIukcoJv+RHzX2pitZcrjrW+ERmdqP5uQkW8
         J5n3NB7BJ92I2cOk4aAbA4k/l+Ze//k7AmiEXZ7pd5q3HEZ3e2Wq/v/yJaxkmzU9V4q+
         lUMTolFNjTbdJIaj/D/lgQNAYfJLSQ3t260zK1s90gL8OO8mcMXASaz2OfuGsjbB8HxT
         IbGY8LzEJYFxGKb4PhYNVnujZoshLzYQBLd8uqAxloXeKywWPDfqf+28AMEGhRbkRr3i
         //UGyQdfr7tEk/MT+jTSnFixcrsf3cd12FM6AYS2Kv2wEOoQu27ENTRQeWypBwg8cJxK
         tUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682535; x=1774287335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CpR3ACqU07aVtibziRIGQBdLLRT1jdd+Sta0uM61LtQ=;
        b=TTTxVy6Q+s8uvl5R/lVg1Ks+WCyuSvUVypT/n/zTwxswBBSH1pMHdBW1vRCu2ziiSJ
         BuREIzscm0Hx7HBzgDkpDAkrfjV5vcE0pMJ77TorpwxltPdkv/mESwfTie0j1ZOtiZ/E
         2/G5kIJQTfI4bLUmxDSh61pPAMF6RUO+VVVFSQQ+wdYpfQEKYgCA2EtrItzzbp4zjrey
         3wF1pNf9+TBLVSogho6WAjeg9N/SkuOBqRi6FTJaKE2SmTv+ylpkIYSfSZh6vF9d2rsL
         YHQRhK/lSQuTUkVeQ6cfOsHDTiXvoVu2FUGg9NYlbuHNB5HjfJBtebwV3I5FdwVmXj10
         bcXg==
X-Forwarded-Encrypted: i=1; AJvYcCUvno31ZVeATewY2h/7WbpbPN1aszAzSAo95ADT5r5NerAfTy9/KMQSlMgBglQK8DpQTd82/+c=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnIzGuFqu+/eymRmiNn9k6JAafxBOb3dG3L4XBawOBfzx44Fev
	hmPXk54pR7sS+m4KVnp/tOgu9MguvmXdvnpqnkGsT6TBkh8WWm05kohICB8Y+xMDbRIhaWoKABu
	LrA==
X-Received: from wmsl29.prod.google.com ([2002:a05:600c:1d1d:b0:485:3659:1508])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a45:b0:485:4006:960c
 with SMTP id 5b1f17b1804b1-48556702a7dmr250396775e9.16.1773682534732; Mon, 16
 Mar 2026 10:35:34 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:27 +0000
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-6-456875a2c6db@google.com>
Subject: [PATCH 06/10] KVM: arm64: Use guard(mutex) in mmu.c
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"

Migrate manual mutex_lock() and mutex_unlock() calls managing
kvm_hyp_pgd_mutex and hyp_shared_pfns_lock to use the
guard(mutex) macro.

This eliminates manual unlock calls on return paths and simplifies
error handling by replacing unlock goto labels with direct returns.
Centralized cleanup goto paths are preserved with manual unlocks
removed.

Change-Id: Ib0f33a474eb84f19da4de0858c77751bbe55dfbb
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 95 ++++++++++++++++++++--------------------------------
 1 file changed, 36 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ec2eee857208..05f1cf839c9e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -388,13 +388,12 @@ static void stage2_flush_vm(struct kvm *kvm)
  */
 void __init free_hyp_pgds(void)
 {
-	mutex_lock(&kvm_hyp_pgd_mutex);
+	guard(mutex)(&kvm_hyp_pgd_mutex);
 	if (hyp_pgtable) {
 		kvm_pgtable_hyp_destroy(hyp_pgtable);
 		kfree(hyp_pgtable);
 		hyp_pgtable = NULL;
 	}
-	mutex_unlock(&kvm_hyp_pgd_mutex);
 }
 
 static bool kvm_host_owns_hyp_mappings(void)
@@ -421,16 +420,11 @@ static bool kvm_host_owns_hyp_mappings(void)
 int __create_hyp_mappings(unsigned long start, unsigned long size,
 			  unsigned long phys, enum kvm_pgtable_prot prot)
 {
-	int err;
-
 	if (WARN_ON(!kvm_host_owns_hyp_mappings()))
 		return -EINVAL;
 
-	mutex_lock(&kvm_hyp_pgd_mutex);
-	err = kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
-	mutex_unlock(&kvm_hyp_pgd_mutex);
-
-	return err;
+	guard(mutex)(&kvm_hyp_pgd_mutex);
+	return kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
 }
 
 static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
@@ -478,56 +472,42 @@ static int share_pfn_hyp(u64 pfn)
 {
 	struct rb_node **node, *parent;
 	struct hyp_shared_pfn *this;
-	int ret = 0;
 
-	mutex_lock(&hyp_shared_pfns_lock);
+	guard(mutex)(&hyp_shared_pfns_lock);
 	this = find_shared_pfn(pfn, &node, &parent);
 	if (this) {
 		this->count++;
-		goto unlock;
+		return 0;
 	}
 
 	this = kzalloc_obj(*this);
-	if (!this) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
+	if (!this)
+		return -ENOMEM;
 
 	this->pfn = pfn;
 	this->count = 1;
 	rb_link_node(&this->node, parent, node);
 	rb_insert_color(&this->node, &hyp_shared_pfns);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
-unlock:
-	mutex_unlock(&hyp_shared_pfns_lock);
-
-	return ret;
+	return kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
 }
 
 static int unshare_pfn_hyp(u64 pfn)
 {
 	struct rb_node **node, *parent;
 	struct hyp_shared_pfn *this;
-	int ret = 0;
 
-	mutex_lock(&hyp_shared_pfns_lock);
+	guard(mutex)(&hyp_shared_pfns_lock);
 	this = find_shared_pfn(pfn, &node, &parent);
-	if (WARN_ON(!this)) {
-		ret = -ENOENT;
-		goto unlock;
-	}
+	if (WARN_ON(!this))
+		return -ENOENT;
 
 	this->count--;
 	if (this->count)
-		goto unlock;
+		return 0;
 
 	rb_erase(&this->node, &hyp_shared_pfns);
 	kfree(this);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
-unlock:
-	mutex_unlock(&hyp_shared_pfns_lock);
-
-	return ret;
+	return kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
 }
 
 int kvm_share_hyp(void *from, void *to)
@@ -652,22 +632,20 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
 	unsigned long base;
 	int ret = 0;
 
-	mutex_lock(&kvm_hyp_pgd_mutex);
-
-	/*
-	 * This assumes that we have enough space below the idmap
-	 * page to allocate our VAs. If not, the check in
-	 * __hyp_alloc_private_va_range() will kick. A potential
-	 * alternative would be to detect that overflow and switch
-	 * to an allocation above the idmap.
-	 *
-	 * The allocated size is always a multiple of PAGE_SIZE.
-	 */
-	size = PAGE_ALIGN(size);
-	base = io_map_base - size;
-	ret = __hyp_alloc_private_va_range(base);
-
-	mutex_unlock(&kvm_hyp_pgd_mutex);
+	scoped_guard(mutex, &kvm_hyp_pgd_mutex) {
+		/*
+		 * This assumes that we have enough space below the idmap
+		 * page to allocate our VAs. If not, the check in
+		 * __hyp_alloc_private_va_range() will kick. A potential
+		 * alternative would be to detect that overflow and switch
+		 * to an allocation above the idmap.
+		 *
+		 * The allocated size is always a multiple of PAGE_SIZE.
+		 */
+		size = PAGE_ALIGN(size);
+		base = io_map_base - size;
+		ret = __hyp_alloc_private_va_range(base);
+	}
 
 	if (!ret)
 		*haddr = base;
@@ -711,17 +689,16 @@ int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr)
 	size_t size;
 	int ret;
 
-	mutex_lock(&kvm_hyp_pgd_mutex);
-	/*
-	 * Efficient stack verification using the NVHE_STACK_SHIFT bit implies
-	 * an alignment of our allocation on the order of the size.
-	 */
-	size = NVHE_STACK_SIZE * 2;
-	base = ALIGN_DOWN(io_map_base - size, size);
+	scoped_guard(mutex, &kvm_hyp_pgd_mutex) {
+		/*
+		 * Efficient stack verification using the NVHE_STACK_SHIFT bit implies
+		 * an alignment of our allocation on the order of the size.
+		 */
+		size = NVHE_STACK_SIZE * 2;
+		base = ALIGN_DOWN(io_map_base - size, size);
 
-	ret = __hyp_alloc_private_va_range(base);
-
-	mutex_unlock(&kvm_hyp_pgd_mutex);
+		ret = __hyp_alloc_private_va_range(base);
+	}
 
 	if (ret) {
 		kvm_err("Cannot allocate hyp stack guard page\n");

-- 
2.53.0.851.ga537e3e6e9-goog

