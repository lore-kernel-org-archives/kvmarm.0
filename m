Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B417851CF78
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864963; cv=none; b=OHx0s1iEWnPIyTdd6XrNHKfG/fRTsHKrwVEAtbBcpClJPmXq2l6kjRCthTikRGPa4WI3Ac59U9+NnEikvQNq2Gvq35VqIenB8ww+EJc5G1DWpE73q2XxJTwUVhhoqTfwOhqeUIc+CXsf5FSeyeLXVKSyoJh4iLkm90/xLP3FmVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864963; c=relaxed/simple;
	bh=2wy4cMYoF8inKyCjdEl4DP8z6/Td8acJjvU/kk2A4to=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WrntIMvjCOEAKOhVE9hNLNDrMOCguS4QGlz3iQvtZRxO5djm2PzhPLzjaJcHyttNCkirWLi9IeKyI1UTrW5tZotJSKdo0oRZCfBWi5Y9jywlBRy/L/8n9qvbtbooReCim00q9KPrC7DOjXZ0kYBWl6Yfj/kEAjAxTae5WcvuaoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NHq0Y1GO; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NHq0Y1GO"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48b02d63407so1222080f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864952; x=1791469752; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TuL/trC6ai3Kh0aIJd/3xh1DmywKzy5BGHO8nv2ShpM=;
        b=NHq0Y1GOfNCiNp/VM/+vJ1duG5XY8prTbKC3Uj+a6zqtqIjucRDRQ1fdlG5sZml2yR
         Ti9pDWkF2zOEBi/l5n71Zfse/Ncmz11JoWbKhHvGjHOdf3Za/czhzMUrAcpowyt3y/be
         sAvEg7Z2lr3q50kiH8Ozj1vH9Uk46yTxFhWHA9EQeDca6k0pfKaytm83CPm/SWTtW0mp
         JW1FIPUCTP8SQJRDnQYhr5kG6OECUbKpU/LdeDWiVyDAgR1cfAz+SnNfuRDD4La5W1wY
         ISxSdpxrHQUYmlZnpILIFH9E1db+id5/Fah9+gldoXQFxh7AZHVcX49NSW8PR4AX5lpo
         XZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864952; x=1791469752;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TuL/trC6ai3Kh0aIJd/3xh1DmywKzy5BGHO8nv2ShpM=;
        b=A78Igj7aQG86sLnXOoIzChxMlnoV1i7nB75qQQg/zh6I3nAT5j9rH3ghDyeSfa8yNv
         +PmxoKVEvkOz2qljcw8I2puO9UasOhcxNV5XR+P47rCj9HkdgegUTNdQ0MBKQ2xePSPn
         bUI0pK8iGcBQYlP/a62jsvc3HBKpvul/y1pkzVv9/avtUe/mmqj956H3ElmJIkId8NML
         EmOIWlyxSxEOd9T6Hrt0pRsh8/0vs9PLlSt0IBZmBIio+MrOado+x8S/va0imaxGS0/D
         x75yw1NaFpFbL8Sn/9skZZ0KMp+oviDazOF668XAaDPa3w2w9DPMloEH4Ox0qqeQGa7Z
         vfeA==
X-Forwarded-Encrypted: i=1; AKwUvBzgeTO+5MvC0yu4DfWZqWEZ1f9DfjKxv5TH98bKLUEYOAHGJrYi45h33eD5XM7wApfu2QWo5CM=@lists.linux.dev
X-Gm-Message-State: AFq9FYJDKqq+98dR0RGIS/Hrzi9oA9otrzOHkgAFofQVLJws6XWuvX5k
	dHxk871yEGnFtAMPeLXGIbh9w3p5alJvmoCCbuh74fjt+/AiSqkN9P/cjuJh7iHZJLhNkPV0CZL
	gkrmcIx+jBavfA0WPsjvFyA==
X-Received: from wrbhe34.prod.google.com ([2002:a05:6000:15e2:b0:47f:74c9:84ee])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4914:b0:487:1646:8740 with SMTP id ffacd0b85a97d-48b02525c39mr9358682f8f.29.1790864951846;
 Thu, 01 Oct 2026 07:29:11 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:43 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-13-vdonnefort@google.com>
Subject: [PATCH v6 12/18] KVM: arm64: Move hyp_vm refcount into the structure
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for allocating hyp_vm using the pKVM heap allocator
(hyp_alloc()), move its reference count out of the page metadata
(vmemmap) and place it into the structure itself. This transition is
necessary because hyp_alloc() allows multiple small objects to share the
same physical page.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h | 13 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 10 +++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index c1171451e1be..b208544141c0 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -42,6 +42,7 @@ struct pkvm_hyp_vm {
 	struct kvm_pgtable pgt;
 	struct kvm_pgtable_mm_ops mm_ops;
 	struct hyp_pool pool;
+	unsigned short refcount;
 	hyp_spinlock_t lock;
 
 	/* Array of the hyp vCPU structures for this VM. */
@@ -66,6 +67,18 @@ static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
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
index 5cdb0318fa7b..98db5bd28dde 100644
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
 
@@ -979,7 +979,7 @@ static struct pkvm_hyp_vm *get_pkvm_unref_hyp_vm_locked(pkvm_handle_t handle)
 	hyp_assert_lock_held(&vm_table_lock);
 
 	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm || hyp_page_count(hyp_vm))
+	if (!hyp_vm || hyp_vm->refcount)
 		return NULL;
 
 	return hyp_vm;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

