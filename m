Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946303033C6
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290843; cv=none; b=QB/nUZVcQXes9cfsgDdyutP4mCDLcCDhAr1Irah5V/JKwbRPsl8sf6pIhf9dZDJPx3VfzpKlnrQJ6yfTMIYGLO8OQ2+eJob60qSa37/DJem3aR74h9B+qFHyv8KrooXd2SDdB0XoskI8Qcc/fcL3oifpYdR4CL+TLSAhtZ1vOAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290843; c=relaxed/simple;
	bh=zCZJsTMvA8E0J/9CI/NXkmNg2fmruMdUdBcmLP9jmH4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BItBmY+rx4AEnBY+26jDwfM8Q0wUE0HLXJk55AjcGWQNbxhLrs5AtiX/G0NLnNUEopjVplMKvqHTvd4A505RUtMyUFHFJN7FD8VABdGdwtijRJ6S16jJOR0IHz7qQi0KKnN6BdkHxWUk1COnxGCj9FcxvNNmW1EzCFIkA3RdL9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jyuA4ypU; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jyuA4ypU"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6852c63bd1aso6051290a12.0
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290839; x=1779895639; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AfoG+/JjS8TWGZBVrJV6lrQhcdknR5tvbiTC3bDX2tw=;
        b=jyuA4ypUI4InPa3cPKTHwvJU/BAxrbYky/wkXGA64OZ+HNoOz9j9wmaJ4xy1u+U4KC
         W812bwb992A/8OpuiMVe0RLppDrtSK0fpnHTqaGHF31PSa/Q5ytVgQ2oxuAvkOKVIC1o
         sVX2qXDohg4o+q4/9QsCZ52PFBtLv7ULLP2xvwZU2KrSzYZYPSeCXl4QgupxmdWLETMn
         R7mGyAaVOVDmlMiq/cASvUt0Pqp4NhbuDOUsXW57F+Rh1Xalaphy4Z8gumNZfwN/bxGH
         j8TTxabbMyA3xyjBGUtne1CMdkrtHnjG6OpBqYqHiziMfSbjkPkSCJXPbNPLquXB0mVp
         yANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290839; x=1779895639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AfoG+/JjS8TWGZBVrJV6lrQhcdknR5tvbiTC3bDX2tw=;
        b=GwpNEdEzS+yddA2AMs169AwiAEexsYC9BqBRf8Fv+cSVYLvrIrqgzUBR3Y36GgeoFg
         UYhPOdMWaxn01CreriK2VevQMd5zy+O8fSi+AVQWxZ/HIsbcfzJcC2IzgGvyqvtHfi9G
         dnDDavKOYr1RqkvlR9eq5iKdijHZzP2yHRwA7CFn3UVTmKnYCLygljGIcgWNX2i/oxhG
         mFbAyHIzTqi/w7Z/TD55UVNtDzSlXNKFie4R97Qs9ELeSD1x4OQMaWeLyyvIfi9kI/jt
         Mhk15CbxCMNEDKOc6kzBEYLYuzzKrnUjcp4TQLZE3UjT3HgVi6aPNafzwyvbVmoq+wqX
         yslQ==
X-Forwarded-Encrypted: i=1; AFNElJ80TUot6JoArKNjf399Jc8CwZ/Ui5Uv+/+YP8wuZiBarVQhGWcgZrQqStMIm/I12iK+ASH+cfs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxI0QkUBGKc2VH0W30YfVN8W8PqCRaRQX9o1/r/HLOHh2gZYJwH
	8eWumciDneiYqurBy9sBXibCMQE2/cgUeoeIFn8/bgymh5uu2KGHD5YMJayOPo8VSxMyh25ymbR
	rNM1z5W9CP0MCaDxzX9eAmg==
X-Received: from edqm8.prod.google.com ([2002:aa7:c488:0:b0:676:9c6b:6e9d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5241:b0:66e:6ac4:2c01 with SMTP id 4fb4d7f45d1cf-683bc9aba07mr13776206a12.2.1779290839371;
 Wed, 20 May 2026 08:27:19 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:38 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-6-vdonnefort@google.com>
Subject: [PATCH 05/17] KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
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
index 65eead8362e0..15c5378b70a0 100644
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
index d089c107d9b7..04dd442c127e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1132,9 +1132,11 @@ static void hyp_mc_free_fn(void *addr, void *mc)
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
2.54.0.631.ge1b05301d1-goog

