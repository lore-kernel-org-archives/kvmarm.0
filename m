Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1FB3B993B
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567731; cv=none; b=lDCYZrGqz9QnC2gDrZLVQpxwW24ESayHutKR9b2wBRX0GDP2dSRR41aMxHEB7XsF5pduChCmb7xVlj1eqkhm5T699JcpUVhyy5p4iRPLu3yi8+6syn9zB+8z3BiiIpjUz8DZDB95OErgj60kktdHMOPvvkKGcdrUwgyh52aYqAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567731; c=relaxed/simple;
	bh=p1muMmj/qKCzGdg0wYvbAabYSjWJ8IMl7J2O+YS+1TQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gzjz8kqHasoC5ry4dK9LQwKgqplHBaKX4hrdhHNPxEavJLFkh4EGmtf3yH40DDFI8OpEkFddI9WqeIrpj0xmzBYqNl1eoZ29Kt3uXB3i5gaIaIGAoL0LgUWfWiHdSSLwkd27CL7x8ze1JYsupyXekkmGvmbNyXir2VT9ANtxqow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W0sv6wKW; arc=none smtp.client-ip=209.85.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W0sv6wKW"
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-69c033344cdso5170799a12.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567724; x=1785172524; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=coQ8Sg2Gg4wBmuVDYw7iK7AOHNH8rxxYYghY3YcY7oQ=;
        b=W0sv6wKWoc3pklUn1diTd4eC4biqyF0+cxnvpy5ZjWz0q21Q7KY+XH1yGXmCP0OMg3
         apX5Yqvz3EamTn20aybXEa1t0lb+lBMtV2cV9DG8ZTjP2fWfTNxxvskqs3WDHb0tlUBx
         FnOJ4S9/QpLgjRZytwhK44zfH707EkjmQTcM/3wsiHmZJD+AVTjpQDtODGGC/2Vg9MCm
         5KQzWo43wfavTXnE/Yg2szmzGzXhafXCtSIrLbN6Ytjx4uvHRRzl/zaKKZESOZJsicdk
         vxTx7iY6S55Y9QmF0UH1RGpDjJ/F8Z0perLF5bTXExLf/HWlkfd2dPmCeG64OTMSnyeQ
         waRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567724; x=1785172524;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=coQ8Sg2Gg4wBmuVDYw7iK7AOHNH8rxxYYghY3YcY7oQ=;
        b=LkVnRBaWTqpl05Zr70z2kNKTga75IDpGhNKQ501tRE/pT6bAk5JbxxDlv4g1BeIzBO
         nvwmb7i2wfodUYUXXoDIsYkntUSz7azFbKfkKjDwlshH1upd4wefTaGnyIEMLhjm7gCq
         7fUqBosNj09ZmYfUIP0DkjjbBuTewv+dfpgkzAO9EKr/pcsuIXIDLNTZZySAmc5swran
         LePHSEG31+/DyUUexyTpR6e8hQAG/F6VX6zHyyypmzSYoSYdBeU08+MmZoO4ucpWE3Cd
         XjyLir0yfEcFSPBEfvUf+Id5i6HQXU164+VqkqivvaaHB30HHtztPPZi3xO8RiFwRrP+
         C/pA==
X-Forwarded-Encrypted: i=1; AHgh+RpwIa2aWEiW2AZ5LSfBUsa1YESYJJ1MyIf596gb8BSpuPDQvWnVJZNMi6ChJ9df0ZDri/Vmhxw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOZrTLoihjbAK2PBjnhF4tvvfqv6qvBvfqXkGI45khTJQ22Ak8
	YGvGPZL6ZTmu6CyogsqvmBhlXj6qAAhMgkYLYYbsQcWkkH//YJ2YahmgybmkrSrbmCqmbEO3MiW
	7qYdBIzSiGr2lovyw8ai7Uw==
X-Received: from edev9-n1.prod.google.com ([2002:a05:6402:a2c9:10b0:698:ad4b:abf5])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4409:b0:69a:9355:d1c6 with SMTP id 4fb4d7f45d1cf-69e653279b9mr5624442a12.42.1784567723872;
 Mon, 20 Jul 2026 10:15:23 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:15:01 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-6-vdonnefort@google.com>
Subject: [PATCH v3 05/17] KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Although currently limited to guest stage-2 page-table allocations,
struct kvm_hyp_memcache is a useful primitive for passing a list of
discontiguous pages between host and hypervisor.

Introduce init_hyp_memcache() to initialise a generic hyp memcache, and
init_hyp_stage2_memcache() for stage-2 specific memcaches. The generic
initialiser will be used to top up the upcoming pKVM heap allocator.

Note that the generic kvm_hyp_memcache does not account for the
allocated memory. This is expected: donations to the heap allocator are
shared and recycled, they cannot be accounted for a specific VM.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

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
index 6c941aaa10c6..1e37f2f56c68 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1160,8 +1160,10 @@ static void *hyp_mc_alloc_fn(void *mc)
 {
 	struct kvm_hyp_memcache *memcache = mc;
 	void *addr;
+	gfp_t gfp;
 
-	addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	gfp = memcache->flags & HYP_MEMCACHE_ACCOUNT_KMEMCG ? GFP_KERNEL_ACCOUNT : GFP_KERNEL;
+	addr = (void *)__get_free_page(gfp);
 	if (addr && memcache->flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
 		kvm_account_pgtable_pages(addr, 1);
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 428723b1b0f5..d2681da0b629 100644
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
2.55.0.229.g6434b31f56-goog

