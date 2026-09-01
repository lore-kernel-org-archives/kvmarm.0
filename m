Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011A94CCDD4
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250209; cv=none; b=NZ+7J+Q367knoGKGh7erWdOo29CbnD55C2eWAmvXeoc8cZG7B005whWfUB8lZxhDSDk7N+Qnd4mERPyrkAKjJEaBDEud9o0LEqQIh3vrPfJPRYZzo5GWfj908Iqq9XvP+riqTSnynJWlcP2mi5boaH1uG0wXX7MUvp3iaG6haG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250209; c=relaxed/simple;
	bh=1Rn0m0eIbWKKZDxCVwnPd/288+A/DzwTR4sJ7oxvq38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B3korHkHGGvZn+vyZI+0skE2EmQrTMl4iLedpp/aeqm1ij9xCZfZgJNLqfvHKJdA3WPhSsu93lM7tp5yrGdCQC8KFQiZ8p1onPxjvrEOBxvbkzTINXHZ81n+iCDXzvrn4aY5ntvC+fldcjfwDpeUltel3KYDRyqyHSNbW9Fr3+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rs94tWLk; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rs94tWLk"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495689bfcc8so29637635e9.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250206; x=1788855006; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KSsAeCTnj7JowSArhdAWoJWpv0EUg3Eajoq0vBky2Ls=;
        b=Rs94tWLkQsJ6TLC7MwkN/vqMl3oYfPoNoRict/Kyznd8EISzrMklz5vCGY5orDxrbF
         CnZ7R093SCQaBcVNO4HDT6Ez7xjL/NMdN9etUVh2kcwPhJcAEznESno1XUcNvK+5aK+l
         KXrhkMR/51hlyqPo/b7B07KpB+uMWzMc9CxvE+3+lItLNhijPFOYtldkC9sT9jH4baHF
         GTOZFkapAivvsV5sBhfHs2ruQgU8uB+oY6Wjvea0CsJm4sDsEI0lPl/2gk10yTTOR3ih
         0onAGJKkrPcfg9UIc1EBhRzIomY662qYF1sTuJPgbiPl/7qpf0UzNR3yIK097tQiaXNE
         e+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250206; x=1788855006;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KSsAeCTnj7JowSArhdAWoJWpv0EUg3Eajoq0vBky2Ls=;
        b=kuQ4ILjkki7/QvJB+lFJ+GxKyGfV0NLx3/t3PpizXh+4rwBf3bbsM1F/nLnQ5fpV2I
         HtI/TVq962obfG8sEn+CFu542ayKoYmg8oUH+NkgnvGbU2cpjCE0+cGp4dfG5/vFkt7L
         A72K2UMvs7rMQfaJEDZu9VhQFGwYfOEjcAd5hoQ3kKA7A5fPCKAxpX4DSmnzDPpWzJJi
         6EYo0rr8XOy8jnEjgpWMyMGd8eynK9APLOt2uBPiAnyjeD+zak1poSG9wQAshQr91WCV
         rthG9fQCw2KVohdjBmB8dV0d53WRhZZB67xkp+SuvXsYwVvVfy1Og/GgLC1UoWNxmGgd
         BGRg==
X-Forwarded-Encrypted: i=1; AHgh+RpX9qUSQmr/JooYuAPeHJ3+luJRtY/Hy5UMzLft7YC/LtLg3mZYarAkCLDrobNi/a7myeAY6rA=@lists.linux.dev
X-Gm-Message-State: AFuF++m0WR7XF6GEa0VpQMBcyxqpdHFuCLKEqy8U595jxRK5I8ECF3DO
	vZVlOE2Gj06cnq4Jyzy6IaYXO0dASCRpLxXexgVTosMZy9KCzL/RFnDp0Kv4Ykds6fuUahvkk6k
	LfuFkDof1ijriYIfKq/VvUw==
X-Received: from wmfr22.prod.google.com ([2002:a05:600c:1596:b0:499:caa3:ae0f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f0e:b0:49b:9433:ea44 with SMTP id 5b1f17b1804b1-49cdc40ff56mr130922965e9.4.1788250206008;
 Tue, 01 Sep 2026 01:10:06 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:38 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-16-vdonnefort@google.com>
Subject: [PATCH v5 15/18] KVM: arm64: Rename vCPU pkvm_memcache to stage2_mc
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

With the introduction of the pKVM hyp allocator, the memcache for vCPUs
is now only used for carrying pages dedicated to the stage-2 page tables.
Rename pkvm_memcache to stage2_mc to reflect its purpose.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fe5364b507f9..7aaa139ac89b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -939,7 +939,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
 	/* Pages to top-up the pKVM/EL2 guest pool */
-	struct kvm_hyp_memcache pkvm_memcache;
+	struct kvm_hyp_memcache stage2_mc;
 
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 09ae5431ce58..fa77abf8cff6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -591,7 +591,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (!is_protected_kvm_enabled())
 		kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 	else
-		free_hyp_memcache(&vcpu->arch.pkvm_memcache);
+		free_hyp_memcache(&vcpu->arch.stage2_mc);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
 	kvm_vgic_vcpu_destroy(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index bc54f477c147..fc3a624b0c4c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -407,9 +407,9 @@ static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
-	return refill_memcache(&hyp_vcpu->vcpu.arch.pkvm_memcache,
-			       host_vcpu->arch.pkvm_memcache.nr_pages,
-			       &host_vcpu->arch.pkvm_memcache);
+	return refill_memcache(&hyp_vcpu->vcpu.arch.stage2_mc,
+			       host_vcpu->arch.stage2_mc.nr_pages,
+			       &host_vcpu->arch.stage2_mc);
 }
 
 static void handle___pkvm_host_donate_guest(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 39aa8911f62c..dadd48431036 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1023,7 +1023,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 	ret = 0;
 	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
-				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+				       &vcpu->vcpu.arch.stage2_mc, 0));
 	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
 unlock:
 	guest_unlock_component(vm);
@@ -1058,7 +1058,7 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 						      PKVM_ID_GUEST, meta));
 	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
-				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+				       &vcpu->vcpu.arch.stage2_mc, 0));
 unlock:
 	guest_unlock_component(vm);
 	host_unlock_component();
@@ -1422,7 +1422,7 @@ static int __guest_check_pgtable_memcache(struct pkvm_hyp_vcpu *vcpu)
 {
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 
-	if (vcpu->vcpu.arch.pkvm_memcache.nr_pages < kvm_mmu_cache_min_pages(vm->pgt.mmu))
+	if (vcpu->vcpu.arch.stage2_mc.nr_pages < kvm_mmu_cache_min_pages(vm->pgt.mmu))
 		return -ENOMEM;
 
 	return 0;
@@ -1456,7 +1456,7 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 						      PKVM_ID_GUEST, meta));
 	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
-				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+				       &vcpu->vcpu.arch.stage2_mc, 0));
 
 unlock:
 	guest_unlock_component(vm);
@@ -1527,7 +1527,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 
 	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
 				       pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
-				       &vcpu->vcpu.arch.pkvm_memcache, 0));
+				       &vcpu->vcpu.arch.stage2_mc, 0));
 
 unlock:
 	guest_unlock_component(vm);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index ee2060aa1131..8a8b694ca00f 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -760,7 +760,7 @@ struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
 			continue;
 		p[i].refcount = 1;
 		if (seeded < min_pages) {
-			push_hyp_memcache(&selftest_vcpu.vcpu.arch.pkvm_memcache,
+			push_hyp_memcache(&selftest_vcpu.vcpu.arch.stage2_mc,
 					  hyp_page_to_virt(&p[i]), hyp_virt_to_phys);
 			seeded++;
 		} else {
@@ -1002,7 +1002,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 		if (!hyp_vcpu)
 			continue;
 
-		vcpu_mc = &hyp_vcpu->vcpu.arch.pkvm_memcache;
+		vcpu_mc = &hyp_vcpu->vcpu.arch.stage2_mc;
 
 		while (vcpu_mc->nr_pages) {
 			void *addr = pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3163502cc7d2..afde0894ab15 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1553,7 +1553,7 @@ static void *get_mmu_memcache(struct kvm_vcpu *vcpu)
 	if (!is_protected_kvm_enabled())
 		return &vcpu->arch.mmu_page_cache;
 	else
-		return &vcpu->arch.pkvm_memcache;
+		return &vcpu->arch.stage2_mc;
 }
 
 static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 36e677e51f7d..83e18c0e30b5 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -182,7 +182,7 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 	pkvm_handle_t handle = vcpu->kvm->arch.pkvm.handle;
 	int ret;
 
-	init_hyp_stage2_memcache(&vcpu->arch.pkvm_memcache);
+	init_hyp_stage2_memcache(&vcpu->arch.stage2_mc);
 
 	ret = pkvm_call_hyp_req(__pkvm_init_vcpu, handle, vcpu);
 	if (!ret)
-- 
2.55.0.897.gb25b4bd76c-goog

