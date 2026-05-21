Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10EA3DB318
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374194; cv=none; b=jG1nCRJY/HW2sCaPiuPVexqfXf12NLLSJ2DMeZUZUgP9eOzwLSplUBntr5a22JgDSm1iclO9p6t0YleWuTBzGk2qKHaphKm7LiYRJ0WWrSllGOZK43cDmARr2ObTG1vnBW20wlMljHsgRu5GEdX7wNv8vFFzWwm2wLZsaDnjIwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374194; c=relaxed/simple;
	bh=Hw+mRmK5UoBsRDHW8D7M2o2vjD46UN2hkws/mC0yMt0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a3aniEDW92A14MS2AMtKBQqwBYym0P433xQmBy/5xLM/qQDATICjCJmT7FSULS/zyqC+vgoGniAJ8SiiGo0YcyTRRLtQmUXQVABzIqomao7vqJDypK3+NuS/Xt+/1J36udURbdBsjAXMofoSz5olatQ4EcUvtgntj5C0DaAn6v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F/s4kQ7H; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F/s4kQ7H"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fe6894f3fso36647235e9.2
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 07:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779374191; x=1779978991; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5cUmhlK4FYcog/fUBeDAbFbwd3xA/tYCb3LFp8+JmDw=;
        b=F/s4kQ7H3WaOQNYMomwPvcEKSdsHa5L+qcXbKUZLTc9kO/NXsDWl/bMpO8HiH+xhyL
         qAVngo5HE7pcwySD0o+4THIWusWr688dm6fegofwHUMOp/U5nbXf4/aZbGsq/xEiwDdg
         QRa36AWHs4/H1wuup6G4iARWLAlz7SXHDWcEwh+PDX2Jv2wp8Prf8wYx3cUBgsgXJivw
         aFsgunsSec+4Ea1jZbpHHLOHlhf3fzXYWxQSLBOqlsXSLkiM5QOAGOoInAOYEcijwgDG
         4kzZohaWAF60ezdbP3OhB7R5J96nZeUxrKrwtznn5L7xef7Qbr1+Y2Oq3Zlgi/coGFIm
         sCZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779374191; x=1779978991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5cUmhlK4FYcog/fUBeDAbFbwd3xA/tYCb3LFp8+JmDw=;
        b=WRBgtz0HJnsWCyZiHh468iE4fktXTQwMGn/YbhsnQoqphR5IT+E48FP2ur0dXWTb8l
         w4R48IRIc/Q6Hcuu0OWoI0TY2t12nlR4NL/QqvTJhw5w+++KZh8swIfyWXO3+CwTt2Cv
         jForuoEBrS+BptThYk+Vzlmzc6IhNW9xIgxzfmcDKCfZBdQMfZb9AaEKD/XlOG84MdA8
         krNUual4Dokoqm9psAFnIQVdguh1dWLMbb89w/q3qPHAXhWG0Q6jX5QMnIqIEk/CnDLM
         a27wtgF1/e0JWGuma9ih+eB6wAklidjz/fXH0S7QZz7qzyeHY7Xtya+ExoPtAYWbn7SW
         itLQ==
X-Forwarded-Encrypted: i=1; AFNElJ93C/+EqgVPhfSY46Goj+qW5X9nNm+mmfzD0SzCFS2SNtgu3G/QijnAMqCuL29O800RdWSx5KY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYdqgzia+h89lxv9NvL94/vO+n8qBXWwaIxtHq6IqT8MnVJeu1
	O9/Cq0wg6NHQPFnsrIspBoV7bipXwZJKbleiiBO30LJa10JIgI/A7+SaOqpnILQ0raEmyE+LPeY
	ycfGlrxL9IBw5Oz1HEnY39A==
X-Received: from wmsl5.prod.google.com ([2002:a05:600c:1d05:b0:486:fca5:7a8d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:620f:b0:485:3abe:ab86 with SMTP id 5b1f17b1804b1-4903604cc8dmr41280105e9.4.1779374191238;
 Thu, 21 May 2026 07:36:31 -0700 (PDT)
Date: Thu, 21 May 2026 15:36:25 +0100
In-Reply-To: <20260521143626.1005660-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521143626.1005660-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521143626.1005660-3-vdonnefort@google.com>
Subject: [RESEND v3 2/3] KVM: arm64: Fix __pkvm_init_vm error path
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
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
index fa447d400b71..986e0ac1f2d8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -305,16 +305,21 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
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

