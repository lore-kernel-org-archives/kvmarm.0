Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1483F2117
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290851; cv=none; b=H67EQx/K8nrG4exgsTLtfLK6N3rOJSLCeatn9KS5I73/hXZDJF5tircLUZyyKyz+k+ADieUv2OQyqYwZArT0liGSns3fVYxVl6sCxNN25qyEEw1wwwA9HYDRWnMBr9Il+pXVjkHlJK1zhsq6pyFVyg1JA+d7qFWb76IJtfOLcDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290851; c=relaxed/simple;
	bh=8VwvTDD4Rg0UKYq3ggcELie+/mEzZq82yyDvcKvDEak=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c3a+Dwk7cS4IeZb3Tt7n7zTsze2pfnW93dVsUvuDE5Zmt/Pa6uMvkikoP7EONmk7BM1ZZvOwSCrKN5tynf4FcsvWZFYjb4R1D2Kwo0nsfbKQoBvj/dAVoQrOqRt6tB2l63f379mwQb95mGUAqsrTu50a0hPc4rlvcPupZpA57Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FBoP60Zu; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FBoP60Zu"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44dad1b938fso3117897f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290848; x=1779895648; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JVU+OuRx6v9DMwAm4TiBqZJIR2LHub0kz+4lAAqlRiM=;
        b=FBoP60Zu+zlxNkj3AAabnef8GtYhmcLEJAzBObtQrqoglRAHVYy4lUOsux0LuavImb
         fXT/oJPPoG2fPyg73U8V34Rd9IgFxnebib1pTb+NYnYXSO2ZVfqqGgfvcfy/kAP7C+8/
         H+/FyDkrVfrtXS8SMqrj2rz0zdGBeC8CgOAbMmqvqJUxQ9e5hYR1xSorkmrw5c8p62Jg
         E/KPcXiZapby/2JUaD1/NYEctQiC5SCAuZ9mQSXdombfjWAdZVDRaVnLboJOmhbfaXO4
         FbiSUDmoAY2KTz4a2rg7BO5KtUdMEo6ZvUiyssW2x4mepTZQ/SLyOGKGrdvHStKcbUCc
         DN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290848; x=1779895648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JVU+OuRx6v9DMwAm4TiBqZJIR2LHub0kz+4lAAqlRiM=;
        b=NY1hQ9VywWGeyaI2JM+QhRGRoEm0Y6eZAkGFLy5xT04cYa0MltOrp/Bw2ewfFD/MIY
         NFl3Cfv3Zg0z8AEIUikT3bmmNNHPjF+Ek2EoKC6cGjqCBwNt78WAvbAnYvweUHTyqWT+
         TOu753r3kB72zCjy8fx3hBy3+QneDeqj2E0TdIkf9LnLF4pqqimpqYT89kzP3hcX+pN+
         1I+XdWuW6Yks9pCZEbkDav1plA7GRZx7Lmahp13UJsMDCQS/Bui0Zov4CN+oE5xSAea1
         NVD/4KB7ywIrUDqcCCEc6PJrSZUQ+anO/OeW8Dw8QEeA8Bgu+0RBPTfOnh64LnFGe59E
         64Aw==
X-Forwarded-Encrypted: i=1; AFNElJ8qxtgLx1sNyAFS5lt0sAlV/sYafHIf21ZmQtCIUa55HXweLTyecnChZZUeAsC6uvxhnnHn2wU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxynqyKv/OGSndZuHQ/CVXvIdtdWBuxiryDfik/4fR+JVIhx+2a
	3J6bUw8GssunNgBfRDm5rwW+cSwT2ggJdFHYjkEtGmtHbk1TiT3Unqspfqa6ZWJUaP1zLEltqAK
	y8O8ybY1Ygo4Unmdcg1T5kQ==
X-Received: from wrnl3.prod.google.com ([2002:adf:e9c3:0:b0:44c:ef36:a65c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1086:b0:45e:653a:40df with SMTP id ffacd0b85a97d-45e653a413bmr26964465f8f.41.1779290848166;
 Wed, 20 May 2026 08:27:28 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:46 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-14-vdonnefort@google.com>
Subject: [PATCH 13/17] KVM: arm64: Move hyp_vm refcount into the structure
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
index e7496eb85628..ebdbe9c92689 100644
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
 
@@ -950,7 +950,7 @@ static struct pkvm_hyp_vm *get_pkvm_unref_hyp_vm_locked(pkvm_handle_t handle)
 	hyp_assert_lock_held(&vm_table_lock);
 
 	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm || hyp_page_count(hyp_vm))
+	if (!hyp_vm || hyp_vm->refcount)
 		return NULL;
 
 	return hyp_vm;
-- 
2.54.0.631.ge1b05301d1-goog

