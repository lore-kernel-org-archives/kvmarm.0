Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A3F3BB9F5
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360479; cv=none; b=sIZDQvMjxpJHkxkD/JCmEvAG6igdhlkY5QlCDXFSfiy88yoCm8GfPg1qZ7qpmUrod/DfXKCCWLrro2kUU2fSlvb58NYHcXukd72I2xCSjEpbgnjRJIb/iU9/GgorhIA5O5ODzq6pC7X+zCY8LRPsiRgIA+rHfqRMWZEQ/4wzXh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360479; c=relaxed/simple;
	bh=Osb/ylZfwyjWDEisZI2pDZAlN1JmjUXD/V2WoJ8BCJA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CY1w5nOGBtBWNghealHF//Wbn0SvMHofVm4+yH/MKAP16pBQaq4AfrxreI2kPy3crdD0NQpwwtimUlXreLLKZZAvxNx76Mgskcuhc3ZstTtF5ZyXe9EXvqXppKChmED/PDiko04gPhdxF2zf4zPpcUoyjRjC3WVQRT8K6sSokBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BtH5CNFQ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BtH5CNFQ"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493b0fe95b6so18642385e9.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360477; x=1783965277; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yu4+3TruU2ZdgZgDqYZqtnMk3zkmalS4vgdcsnIH7N8=;
        b=BtH5CNFQTbjlq9NrzGeGjH8bgor++rtH4JqebF89dkh/WiZh3afYL4U3nimDsTzsy0
         tnCsq0iQPItaBZ+esKsT4veYlIu31GY0Z+yPYgul0Y5FhMx3d5q8C76oi2ECx3aY4Ovq
         4ciAMahh0T/McSPjerwDMG/7ST0mK2dTMiJMCFy3Lh3wze4F7c4Ma05FhK7wGuMcPs7N
         lBu95sNh1G9qIwbCSlCkPq2V2JmkpEcS3hkFgDEtQuoblWql+b0IiaGE5deMwFB2sGAt
         GTLlMr0d46vvUEzv4x0+VKrXf9pNmRzFlp8IBXhV50y7E4PbYirsqipsc5mFytTkCGUO
         IYQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360477; x=1783965277;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yu4+3TruU2ZdgZgDqYZqtnMk3zkmalS4vgdcsnIH7N8=;
        b=bdCjDMSFr6OYNQ/bY1XhVawBesL+gO3AWp0PPtQYtq12aVUEXj4RJ5PljXuQwkbJHt
         aVF4flFF0AbafvSfuuihYrZ29ec6rANkgjViU917XekAEMCWtr+uQu1mBZpF143mD7k/
         CNohiYu+cwhoQihS+MSGsP8FlSVXBzvrRW/95K3h4yJSkXojJQYzonzfUJYSqJIuUVON
         677ZRYj995d4Q6fe5zAlQd7hEQc5Zbzz2nFcNlS/OS9fp33HhicYg87DU4iLVrKP9ITE
         kfcmHiuc+ZDreRjmgKLZ4FzpTzg14/JpgtJaDoBEkKZzFK/q6QN18XxNeiCwvMKcuusF
         /WQg==
X-Forwarded-Encrypted: i=1; AHgh+RpPiHaklwjSYRLUCD6mKbaRsTi9JsMfoD9Ig4bk/3ExVGGbILKFZYSAtZiW6xx2XK10ILqBOgc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbBRP3OO133qZ6BbN5umf3/fGKE2gNsg+fw52v7FH9kpMq5GOo
	XmE/oZcMEt+pQgNwGiebNTlPpcVePqJltkr2RJS9tPfn1DG4sVoRQMNILJKCV11Qss31XTCEZHL
	Pv21aG/kuEO3O0ZHKUzH/eg==
X-Received: from wmbil23.prod.google.com ([2002:a05:600c:a597:b0:490:b258:4672])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5303:b0:492:4e1c:120 with SMTP id 5b1f17b1804b1-493df0988e6mr17102515e9.32.1783360476518;
 Mon, 06 Jul 2026 10:54:36 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:10 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-14-vdonnefort@google.com>
Subject: [PATCH v2 13/18] KVM: arm64: Move hyp_vm refcount into the structure
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for allocating hyp_vm using the pKVM heap allocator
(hyp_alloc()), move its reference count out of the page metadata
(vmemmap) and place it into the structure itself. This transition is
necessary because hyp_alloc() allows multiple small objects to share the
same physical page.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index c904647d2f76..624367d0ef5b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -41,6 +41,7 @@ struct pkvm_hyp_vm {
 	struct kvm_pgtable pgt;
 	struct kvm_pgtable_mm_ops mm_ops;
 	struct hyp_pool pool;
+	unsigned short refcount;
 	hyp_spinlock_t lock;
 
 	/* Array of the hyp vCPU structures for this VM. */
@@ -65,6 +66,18 @@ static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
 	return kvm_vm_is_protected(&hyp_vm->kvm);
 }
 
+static inline void pkvm_hyp_vm_ref_inc(struct pkvm_hyp_vm *hyp_vm)
+{
+	BUG_ON(hyp_vm->refcount == USHRT_MAX);
+	hyp_vm->refcount++;
+}
+
+static inline void pkvm_hyp_vm_ref_dec(struct pkvm_hyp_vm *hyp_vm)
+{
+	BUG_ON(!hyp_vm->refcount);
+	hyp_vm->refcount--;
+}
+
 void pkvm_hyp_vm_table_init(void *tbl);
 
 int __pkvm_reserve_vm(void);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3b2c4fbc34d8..d9ab58226889 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -278,7 +278,7 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 	}
 
 	hyp_vcpu->loaded_hyp_vcpu = this_cpu_ptr(&loaded_hyp_vcpu);
-	hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
+	pkvm_hyp_vm_ref_inc(hyp_vm);
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
 
@@ -294,7 +294,7 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_spin_lock(&vm_table_lock);
 	hyp_vcpu->loaded_hyp_vcpu = NULL;
 	__this_cpu_write(loaded_hyp_vcpu, NULL);
-	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
+	pkvm_hyp_vm_ref_dec(hyp_vm);
 	hyp_spin_unlock(&vm_table_lock);
 }
 
@@ -311,7 +311,7 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
 	hyp_spin_lock(&vm_table_lock);
 	hyp_vm = get_vm_by_handle(handle);
 	if (hyp_vm)
-		hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
+		pkvm_hyp_vm_ref_inc(hyp_vm);
 	hyp_spin_unlock(&vm_table_lock);
 
 	return hyp_vm;
@@ -320,7 +320,7 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
 void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm)
 {
 	hyp_spin_lock(&vm_table_lock);
-	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
+	pkvm_hyp_vm_ref_dec(hyp_vm);
 	hyp_spin_unlock(&vm_table_lock);
 }
 
@@ -966,7 +966,7 @@ static struct pkvm_hyp_vm *get_pkvm_unref_hyp_vm_locked(pkvm_handle_t handle)
 	hyp_assert_lock_held(&vm_table_lock);
 
 	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm || hyp_page_count(hyp_vm))
+	if (!hyp_vm || hyp_vm->refcount)
 		return NULL;
 
 	return hyp_vm;
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

