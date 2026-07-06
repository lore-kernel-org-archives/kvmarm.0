Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F833ED5A1
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360470; cv=none; b=Lb263IITMlM4dH1kPQLOuCTDfLkQ1J1WuajE9KwMs9slhqFjLeEXEM+xpCjbxgRoMyrNVzJz/KemLtH6t+hhdGigfWXQ0dsjD//Y3jqYqvo9n3vlWWg+c2DVc8jijjtwITrjiFtQw1qd824HSAyqb3a7NS+yaGNTXH0glqnVmFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360470; c=relaxed/simple;
	bh=xRXbhUlZTS9hupDRaTnCaM8kpKbNHhy2knItX95dO5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qr3t/53ARqLvwZ2lqMwr4gcJqWG/XTOxbNmQMA66HRi/FIX3gJcfKC0giLZl3niLf+ZozREVOJJpsjRKtJjfvPc/VYx5yoqEVxkXLNZtOF3lpITw9k8Uft77s4K2DtNK6MAF0XSRSHlfTJGD/CqT/tRLrp8J1nAP8Fg/4nT5XT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iPZY+XAn; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iPZY+XAn"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490c56e2576so22127965e9.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360467; x=1783965267; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bTOOUtsfqb4l+gJAMFgunehBcfSR/NR1FIZMjayX2WY=;
        b=iPZY+XAnuhWjo1/51aZXp0Z9u7SF5xpNgXe1unn/REsRrOwojmncNq3ZLhlgS2SXqh
         P6s9mRJT4eTkhus5ZuyU4+JwGPW7hWEP8PEqwkyT0Y68+SFYYyYZG5I/7Tml+WPVqtiY
         spvW5paGtt+EIEP3+sF8f1TGow4hdBhde4Vc+d86a6/5I6gyuEfr8/fWX6x1RKLSGiAw
         W37H6W5+Ja5+XW/3lwHPf6SS3haMrFhM0Ja77CeYet+k46phwPzfrb7kp5Zbr1paANH0
         JgN4K84YN3ZdBMbmXXcfwrHZ50i+kLcE2HLm8S9YfSz+Pr727/uHF9Hnndnb+rG9SQM/
         ROYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360467; x=1783965267;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bTOOUtsfqb4l+gJAMFgunehBcfSR/NR1FIZMjayX2WY=;
        b=F4SNGodXmq1/RPqo5OQOc3L+n5yubGmsO/lPV7NbAQGDh/eTP4EOx8QmksGErdEr+B
         qyk+uKijlq0Er341BnCGiN73JaZT7mX/JRiUSG2dviy6OtyRmAs/GdONoBXlZszcdU8h
         4W4uIYu2y4JxdK+470jX6QCHNgwOg2QM7KvRV6ZU8C8KkzEjTMt/ogriaSRVABsIkwJ7
         aIReEsJ2nwmIvarjAoInr5WqaM3XriA4348OsDuUingL9T/MToG6YEoJztI9pWr0O/Qk
         2eDiNCCPI0CP68XaESGdwYvwEjBPX4wwvbtSZoJLnSlS+oLZ1R8jkOPyEVE6i3dpw7vq
         tFbg==
X-Forwarded-Encrypted: i=1; AHgh+Roo2mBSCzxSxnB2Bia5XIDfAHnal0yuRa9HVI58LsKAMtOFRYhttsLNsGqi+jaSlfhwkigumgQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoS5L031JUjsgTgrGdURGh3d2IfuoEIvDBlcj0JB7wBo1/fjxP
	3pbrQD+X6kx9DJYQJSM3TAtSy4nsWs1RhMuIgeAvM06PExJ9Xzr4urwdpK8ezeTVJwN2mV3sGlD
	/K85RgGGjPInlP/bfdN9Fzg==
X-Received: from wmng10.prod.google.com ([2002:a05:600c:308a:b0:493:c8aa:3616])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3153:b0:493:de4b:de17 with SMTP id 5b1f17b1804b1-493df06b036mr19445045e9.14.1783360467395;
 Mon, 06 Jul 2026 10:54:27 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:02 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-6-vdonnefort@google.com>
Subject: [PATCH v2 05/18] KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Although currently limited to guest stage-2 page-table allocations,
struct kvm_hyp_memcache is a useful primitive for passing a list of
discontiguous pages between host and hypervisor.

Introduce init_hyp_memcache() to initialise a generic hyp memcache, and
init_hyp_stage2_memcache() for stage-2 specific memcaches. The generic
initialiser will be used to top up the upcoming pKVM heap allocator.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..caea8e9986d1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -91,9 +91,22 @@ struct kvm_hyp_memcache {
 	struct pkvm_mapping *mapping; /* only used from EL1 */
 
 #define	HYP_MEMCACHE_ACCOUNT_STAGE2	BIT(1)
+#define	HYP_MEMCACHE_ACCOUNT_KMEMCG	BIT(2)
 	unsigned long flags;
 };
 
+static inline void init_hyp_memcache(struct kvm_hyp_memcache *mc)
+{
+	memset(mc, 0, sizeof(*mc));
+	mc->mapping = ZERO_SIZE_PTR; /* Prevent allocation, solely useful for stage2 memcache */
+}
+
+static inline void init_hyp_stage2_memcache(struct kvm_hyp_memcache *mc)
+{
+	memset(mc, 0, sizeof(*mc));
+	mc->flags = HYP_MEMCACHE_ACCOUNT_STAGE2 | HYP_MEMCACHE_ACCOUNT_KMEMCG;
+}
+
 static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
 				     phys_addr_t *p,
 				     phys_addr_t (*to_pa)(void *virt))
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..fb38821f2037 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1159,9 +1159,11 @@ static void hyp_mc_free_fn(void *addr, void *mc)
 static void *hyp_mc_alloc_fn(void *mc)
 {
 	struct kvm_hyp_memcache *memcache = mc;
+	gfp_t gfp = (memcache->flags & HYP_MEMCACHE_ACCOUNT_KMEMCG) ?
+		    GFP_KERNEL_ACCOUNT : GFP_KERNEL;
 	void *addr;
 
-	addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	addr = (void *)__get_free_page(gfp);
 	if (addr && memcache->flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
 		kvm_account_pgtable_pages(addr, 1);
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4b..8324a6a1bc48 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -111,7 +111,7 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 	void *hyp_vcpu;
 	int ret;
 
-	vcpu->arch.pkvm_memcache.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
+	init_hyp_stage2_memcache(&vcpu->arch.pkvm_memcache);
 
 	hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
 	if (!hyp_vcpu)
@@ -172,7 +172,7 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 		goto free_vm;
 
 	kvm->arch.pkvm.is_created = true;
-	kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
+	init_hyp_stage2_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
 	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
 
 	return 0;
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

