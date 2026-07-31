Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E757742CB0A
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508571; cv=none; b=rwUtPuh7lA8QJQN8uh/iMNZT3TSVALTI7BgNeBLPFy9vxwmOnShyAoUBgFbfHp/vC/Oa90iwaJxHuPjVH/lWt4TaIsovrAwK1STjVYxiuOUioLde1ghcZ/tIa25EI3PyIZD5VKM0sgEP0cQTOTYpFbqVz1a7B81fxAyO9aCeZKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508571; c=relaxed/simple;
	bh=rCkhMd+PzR1UuSZW3Br41ygacCebjBB1RpraNebGI8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=opseQpKUG5R7LLIupDpGeK0+CRaNqlSuAHC+swFXuf/8MuNB7vpWv7tYGAIh0Eyb/al397xhsXIVvwM9Q4VcfVJz+/Ody2MFL4zpamz2J2+zfQcTel8x/SC8ofJ9FQhxJODWG56SkiLg6J2NVvmWRlaz8/f/Oz3mcNvbHIMGHtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qIgUC3oU; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qIgUC3oU"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-698aa6fe074so1173459a12.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508568; x=1786113368; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TUrCEvTbKAGmr6hHuL01zVzxyA5gPy2dUcoI8nsTLg4=;
        b=qIgUC3oUPhUQ6RzsoNIpETjie5WHv1jmXSkEUjYfQ6nZfJWiHiYN5p6fjAf8YcTtpt
         jYPre8Gnjz9LvzqwNRLg+6AmmjxeAeVVaDwy9qq72GCzrXvVdes49l5l9NETTrWOEnE/
         EQIsJWFx9xM+0RfKxjDZ7qBx2HS4eFOw2Nc/6jtKbnEKqEOZS0ggDSih0kYmbPRETXjn
         EiyJF5qEmsNLbTS8yMCaTqMJ5tDsPH8Ysj9UE9ilBFRRoQcklZRa9CRMm1j8PeMkdWXD
         PIw5apnJSeTtHL6gVZik+uRi3IhHIjhoz+QZ8aDp6oWJRm5mZCzJIQIQWcOC/ODCB6rA
         YEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508568; x=1786113368;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TUrCEvTbKAGmr6hHuL01zVzxyA5gPy2dUcoI8nsTLg4=;
        b=q2kAN8m03hXKsZF4CMND4cpU5klRz4ThSbrcsLYnrJXIsuIRx3Ob+aBxO5Z02OC6y3
         MCuUXBos12iphQEqVnKJYKo6DdEkylvMKjIF7RaN2iJERtwIHzC0ZoNppaQfEj74FshC
         xQg1SKBqQnkmw+z19fHJdVQEwKcbz3RJ6vBAKU49HlYCQpD1FBrwaVvDmLCJXEJJojOe
         N1itIDLu4R5/8U8gQQwZPWwavNkz0DobOa46+ofa2BHVvnzmefOEYH6Ubezz1QjC4ttT
         6bNsifbWWyazDiBxRKcqBv3Ojyp9b3DjHAs6iXQMwG3vRJ5XbqHhqrTTFwWnF4efZQSW
         eOjg==
X-Forwarded-Encrypted: i=1; AHgh+RqPa6MduqN93I3Z4tz0/RVr8d/wam/SmoCKHT5ZLi84dqBDvZ/tp46fxTAkTdqQJCem1eOJnak=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGq+kd3ntpPtXXeuabhdKbO0LIYnvyEjnJCYZ8bEZSEZIid7KF
	OQ0lGpSjVnT9SBf6PwQgvkjoZQlwnk4/a857F8IruA6mwbl4ML0edUK162PGfCmjKwkUlZ9iZdZ
	uCNzMGgsmAQZiHOghTE11Iw==
X-Received: from edor14.prod.google.com ([2002:aa7:d14e:0:b0:698:c0bc:3a7f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:52d5:b0:6a0:1e6:df05 with SMTP id 4fb4d7f45d1cf-6a098d05b57mr1376170a12.32.1785508568193;
 Fri, 31 Jul 2026 07:36:08 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:36 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-13-vdonnefort@google.com>
Subject: [PATCH v4 12/17] KVM: arm64: Move hyp_vm refcount into the structure
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for allocating hyp_vm using the pKVM heap allocator
(hyp_alloc()), move its reference count out of the page metadata
(vmemmap) and place it into the structure itself. This transition is
necessary because hyp_alloc() allows multiple small objects to share the
same physical page.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
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
index 24d6f164129a..079d6f397893 100644
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
2.55.0.508.g3f0d502094-goog

