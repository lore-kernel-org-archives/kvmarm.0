Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E24139FCC6
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 08:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779351189; cv=none; b=EWVVfVeW8i6dyhYezp74P4OfEQIDqMph27nu7MaqGlUgTn6IZDEUoWz/53m7u7Mehm0aZvog3ZRQPz/6Kr+04kDQkb3esEN82066YWc3aRdwCyKstbqzop6mdqO+3slF4SUjQc5zMlK76xaSCHq6WJJY58FyVSsIXytFkkUtgM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779351189; c=relaxed/simple;
	bh=KDMCU+WBrFuyxMUw3LnwsgBIPz3p2Oot4AM+JiycN3A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HrE9F+lfIaIPZeVccv7agxZyR5+QWUDaJc3GkPyroOFjiaBc43qXrzmkM881ycgqAzBeLgGKjfK9vDH5O7zeTILkgeCY3QBGLKXNXizCsRe97hrnfxYsqOZ/Mr/7Ovfn7vEJbzQvmZOCIXIpYhu120VJ3aUV6Yf4GS/IiQ4O4vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lJ505pyd; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lJ505pyd"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45e78dd7baaso4443258f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 01:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779351186; x=1779955986; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PQMzmovdG7+4lL/KhHHhQHCE1YeHiXnOvUJr1FLlhyg=;
        b=lJ505pyd8fX7X8x3yconMz3xpVBHuRVrNnPhhf7nLVj2PxKn2Rfdfm89NaKpHUlvku
         G642PD0HtehtpizVhjsTnV6vrq6wxmYvSg9kOwtt3w9G/tyZFePSk2LmCq8bwn7+vz5g
         NlY0IxwrRce9nJbk/xX1UQq6A641E1qZSnUsII15kg2EGWA/pDC7t18xzETK6w0jeC35
         cfICQac67CuSLolFXfGe8HevZIt0FrIz8TMbAFpr0BPww5gYgnha/Fz3HsJsqxuZqJu7
         61sE+lv9NYwVcvDoruMbhHV1sz8T/uj5UsuNZtGUUyuuXqWldQVmuoiIEn/rM01Ip7Gb
         zZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779351186; x=1779955986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PQMzmovdG7+4lL/KhHHhQHCE1YeHiXnOvUJr1FLlhyg=;
        b=d0lf6+gkCNCipoyPkaCorsktOsLxNwdN6cRnPjdB7OW5FIskBbQTzOP6rXUWGHTeoj
         qzIEtzQczfjSgHen4zK7LUfxbbAiOvo4exBQaYk5cnXZ4Mci9eYdoSk7JHWHqI2Emasx
         EGwUPmCpDmje75xdaRPHBNml879FQP8oZzEL2fMGBucFnMgxHlwnRns79ffH6t1QrlAA
         QC+kpKLf3Fol1EXC98B26c9onHllVOG6uo8A7wsbIOfzvI+qZuBEIL9XOe1AKXaVrajt
         p/k0tSRN8WIClT3B0+rgimZDbtuuuHnEB8CJiRt2V/HyAMBsvm889xK2J37pNn+b4yh0
         Mtsw==
X-Forwarded-Encrypted: i=1; AFNElJ+ajaDuq81DSCj0qnNRkdZJ/9WNHeSrCUDIroS8sa5D/oKmnHPgjSqhAySjIWItS8W35HVTpE0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxc058P0qG1wb34MNMusFwz3s+q59g//0t5KwRlIuzyKvdnhLQm
	bXl0N7l34NWdBhSO7XNbq6W6YKufEVfmt+0oEBge93gzGM0E2tZVstVU5za/dbeUcDSoZD7o3/Y
	G/TV9UQccCSIdDnei65ofAQ==
X-Received: from wrqp13.prod.google.com ([2002:a5d:458d:0:b0:451:1d01:f982])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:46d3:b0:43f:ea04:dcc7 with SMTP id ffacd0b85a97d-45ea3ae6975mr2045405f8f.24.1779351185700;
 Thu, 21 May 2026 01:13:05 -0700 (PDT)
Date: Thu, 21 May 2026 09:12:49 +0100
In-Reply-To: <20260521081250.655226-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521081250.655226-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521081250.655226-2-vdonnefort@google.com>
Subject: [PATCH 1/2] KVM: arm64: Fix __pkvm_init_vm error path
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
index 25f04629014e..1e17973f24bb 100644
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

