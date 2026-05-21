Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EED381B14
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 10:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779358930; cv=none; b=Np5okMtvaUzihrd19xfRzg8tf8bBBFDU7p7LjLb0W0jRwJ+4ZxsudQjyEa64mbGDcVsYKqPZRlu8/R2EDiRdGbnWnUg0HDra1Tho+dmAT/d4WpAk0g5ZvL1s7PbZ6pmUK3wNOT4FAvO3wJTq1fiR+G5gZWf46bQBe5uw7vG+pGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779358930; c=relaxed/simple;
	bh=eAQB5VwbB65SBPWhGd+r2YtIywmTm6IuBlF2FCtTbqg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TYINjBJ61SExD92DwvGr5kofN/b2pTDcA/+dzYlwfqhDoB7eUB5AxbXpe/W2eFb1WlZxEMs+8BgJLttDzDNjSPxQyHhL/MEjZq7BqKrMauo9kOrz22+gcQHGskjc2GPWWMrHGdUW5n8UjIqHTbSqyOerVn4UGuH8Y/vvlUvraN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gLfL5K51; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gLfL5K51"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48feb0298d7so46238745e9.1
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 03:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779358927; x=1779963727; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B1ZaR4aeOW4G4LqthsB0Y48avAr3yH4xQi2y5KNIRGM=;
        b=gLfL5K5115AxrlII7Pat6iF60jzvfF4A6hsujGS3gPLHg+quUmz+HdHisNg3VxhujT
         5CnyQxSGhcadMIZsaRt1YgcOnXCcjBZOwg9jo60a3O/yF1Lfz1pxJO7tyfnaIEX1OTjx
         2HLajLSYPeooKWPvL1yP7sUsRCRMXdZMSdepLIz0qdaIOmXNLIokD1Hxjj8oVKk+P+gQ
         qTakPn6UT+Y99Qmi5HzNdbf43g63UpYsj2fjRSCd4lPmR2MCltpTXbv3G2W+tDDB3np9
         g+MppSQjyP6dndhRo44lTGLoaxdgmjSHkoH3Zwon+jd7GaFeIpOeH0U388O3AL1krvdv
         AXuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779358927; x=1779963727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B1ZaR4aeOW4G4LqthsB0Y48avAr3yH4xQi2y5KNIRGM=;
        b=X6lvRTA2yQShwGa5+1x4/y/I+nvexs2vP4PbhD+ZqOzsowb1MUD7lM1yXY3HIp6cU1
         YFgIokureVVZgSpz9HNy7RNGEmG8Uhmo6uUqmPts8n+uqdkR6xYwFIuODd06lzGNZ72S
         zUUKxtcm2iV3Id41U8/9vy45KIpx9TjVFVvvv/dVXi6tHKELoYd41K9diGVH7HdVZIpJ
         zA+FOscemVgDFAw56wjhtQz/a+2SmKPfRXjchdvMJPqXLRs+4WT6nSO5vXqWUwlKcbqk
         b4tdNhP+4ZL90uaTui25GB2I468SdgBZuL4pJPqBIvnvcHtG4iZ+nTonKlecT1t5u9W3
         xs0w==
X-Forwarded-Encrypted: i=1; AFNElJ8xv7tCB6SlTxt1N/lqLCkEES5BrejNvgyh3PZhN9BKkFmebzVHeU6OxpmZMYFEBycxLHzvW28=@lists.linux.dev
X-Gm-Message-State: AOJu0YziN9cKwmTI33AZ2JVVzdTD//mgn5mtK4rZeclsYYQ9knMiUfnl
	HYcw1HtC3shx4IQ71YIa72Ql89HCs9lwyENkMSCXvYCqLshRT48BA44o/stJdz82X1udz8ge4i0
	m9+iuM5pyJHXsw9PdrJ2hlw==
X-Received: from wmjx6.prod.google.com ([2002:a05:600c:21c6:b0:488:9c2a:aeba])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:2e55:b0:48f:d0f1:ed28 with SMTP id 5b1f17b1804b1-4903604d391mr20275735e9.1.1779358927075;
 Thu, 21 May 2026 03:22:07 -0700 (PDT)
Date: Thu, 21 May 2026 11:21:48 +0100
In-Reply-To: <20260521102149.804874-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521102149.804874-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521102149.804874-3-vdonnefort@google.com>
Subject: [PATCH v2 2/3] KVM: arm64: Fix __pkvm_init_vm error path
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

In the unlikely case where insert_vm_table_entry fails, __pkvm_init_vm
release the memory donated by the host for the PGD, but as the stage-2
is still set-up the hypervisor keeps a refcount on those pages,
effectively leaking the references.

Fix the rollback with the newly added kvm_guest_destroy_stage2().

Fixes: 256b4668cd89 ("KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and initialization")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 3cbfae0e3dda..4f2b871199cb 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -56,6 +56,7 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot p
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
 int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd);
+void kvm_guest_destroy_stage2(struct pkvm_hyp_vm *vm);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
 int hyp_pin_shared_mem(void *from, void *to);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 89eb20d4fee4..42b0b648f32f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -306,16 +306,21 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 	return 0;
 }
 
+void kvm_guest_destroy_stage2(struct pkvm_hyp_vm *vm)
+{
+	guest_lock_component(vm);
+	kvm_pgtable_stage2_destroy(&vm->pgt);
+	vm->kvm.arch.mmu.pgd_phys = 0ULL;
+	guest_unlock_component(vm);
+}
+
 void reclaim_pgtable_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
 {
 	struct hyp_page *page;
 	void *addr;
 
 	/* Dump all pgtable pages in the hyp_pool */
-	guest_lock_component(vm);
-	kvm_pgtable_stage2_destroy(&vm->pgt);
-	vm->kvm.arch.mmu.pgd_phys = 0ULL;
-	guest_unlock_component(vm);
+	kvm_guest_destroy_stage2(vm);
 
 	/* Drain the hyp_pool into the memcache */
 	addr = hyp_alloc_pages(&vm->pool, 0);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index eb1c10120f9f..3b2c4fbc34d8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -853,10 +853,12 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	/* Must be called last since this publishes the VM. */
 	ret = insert_vm_table_entry(handle, hyp_vm);
 	if (ret)
-		goto err_remove_mappings;
+		goto err_destroy_stage2;
 
 	return 0;
 
+err_destroy_stage2:
+	kvm_guest_destroy_stage2(hyp_vm);
 err_remove_mappings:
 	unmap_donated_memory(hyp_vm, vm_size);
 	unmap_donated_memory(pgd, pgd_size);
-- 
2.54.0.746.g67dd491aae-goog

