Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED45439908
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567742; cv=none; b=QIcrjXj5VlX8d2czhPAuTTw2SMkbRjb5rA6Q5C/IRdwaRNg0LCj4XOCA2T/yP7aseUuxzZn9LUpjAj51Md+ajxVnYZuDjnyUHrQ6vHnaKUAdnuPCQN8SAi16lT9+38H8851OPUlestX0xg6kjOmYM7bZjK7sIgAZWrxj+HZpcCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567742; c=relaxed/simple;
	bh=5ljGmNk5Rzp480zpa0DvhJQ3jrU5L7LVbs83wPcRmpk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f+yPSuSHClvFjAqMWYeekLlugI6Mhu65H2yZyFNe8DeHav1nlx4VAkFlzKIWsLGRc6OqFblH+fUJoPKJt8nGNrIJ/EKpSoBe8uQYnpaBZQb7rFm/tt+XB3dKe6NQkrIlkui4fz5fZnhz16A/1OZkRvPT5l0vlnhCuSyMKlG9r9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t5CtG/FX; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t5CtG/FX"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49545071724so43461105e9.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567734; x=1785172534; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kG24nThS7TFwTpAIqI2B3tJQSHw8Yio3iFIh6/HIGgg=;
        b=t5CtG/FXAiyQWeUOHJMUZ3copS/bSzlAy8ET7IPDCnWwu2Fms58uCmq5O52RzFrs3D
         RsTzW+haIrWkKBaxcz4GKm8YbIKF0RgRX3h3JJFjZzbmZQIn7xQ0Pm9XROX6vcs5T8tK
         qI5TcYDC+JL1koxkhv2hnmS/hq+WDJMPpkxJ8iSceEewq4ZE8Er2PGal5YMI14HSq0vO
         YMCBdp2NcAAWG5VAQsXKIe2g/dRj5ncufB9gHmA4O0ztPSF3zfEu5HwAxtsFZzv4HjWq
         kjr/3DtesnW37/KBYSmlhEFBxONHEAoWNoF9Cl2Qjsxn5xgPDMMLB14UcjHvMOyvZT4k
         CV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567734; x=1785172534;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kG24nThS7TFwTpAIqI2B3tJQSHw8Yio3iFIh6/HIGgg=;
        b=nncqCmS2vrq//tlhU2CeXhaex3YpwnFvzKTVPy4+sIaoytiZCJV3DYOYnHObLriaqI
         f6MzjkT7y6tkWNX6fpI7fq8aGDGsZKKpTzq/pm+/i6WY1E+I+ycXF90M1ePR8Odw2eCA
         p3g9pxEqavWJrGuXTo5Oryps/zk/sHn6oVW8sllqoJsZAYNy/c9iwIb9PdOYSWITVFel
         E85Ysq7op1/aCtnmFgmYziT/U40k2MN0OYbzdFws4Hc/6/fIHvab++cOr8TUo7lCa9LH
         z551rCCdtHfwSvn9iBx5SA0e4wV1HkEeXntpIAVBBlF0YsABcgqh3odBidKo2lJJrbqs
         IQWQ==
X-Forwarded-Encrypted: i=1; AHgh+RoPOTh349NUfODOyxAoCrGrFWVc7SlllwLOkrw+7m8xeS8gRuoxNBEiQQRqxQXSiHLsX6b/y0k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxS4fd/wJnmXYZsUOvOU+mdPPvOp9NzxX7raZt3cF78DCeBvqod
	bL6VMmnIRqOUjW7Y3FH4VeAR7HvtxyQrKSD+1BkHPGAyUr1IKCjuJP3Zf61u7Sp//sUF0+TRDXU
	N/pQlmGLt8x6kt2BfJbWiRw==
X-Received: from wmpj5.prod.google.com ([2002:a05:600c:4885:b0:493:b328:830b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:45d5:b0:490:9782:3eb8 with SMTP id 5b1f17b1804b1-4954a40843dmr163830585e9.25.1784567733458;
 Mon, 20 Jul 2026 10:15:33 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:15:08 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-13-vdonnefort@google.com>
Subject: [PATCH v3 12/17] KVM: arm64: Move hyp_vm refcount into the structure
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"

In preparation for allocating hyp_vm using the pKVM heap allocator
(hyp_alloc()), move its reference count out of the page metadata
(vmemmap) and place it into the structure itself. This transition is
necessary because hyp_alloc() allows multiple small objects to share the
same physical page.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

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
2.55.0.229.g6434b31f56-goog

