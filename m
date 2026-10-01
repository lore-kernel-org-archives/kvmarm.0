Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DDE51C32F
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864951; cv=none; b=Gilbx5pqxy0P9KHk8JvH5zKkTXRiz0y1I7SW9hIJu4AMgLacOGP+MJgU9xGQoTbcaseyrPfS0TsnNCD9UxBM6f0CtWBjmnZySF0VA/w5srDrSa8Hl4K/rhDQNrvlJbLb/CzLNKREA4GoTrw2akrlRq22LL5+vDcpkFuIQFnTftU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864951; c=relaxed/simple;
	bh=NjDrcrtQ4IWF3Tl2/+QyStQRL25hAuF7YhIHR3PtCJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZpZhokZN9gEq2KOtWIyC18LZKGpAbjvhIghws0xOsuIlu6UJAbjC+kE5XnYkYsE0N/uJbR9ozx1iNAEJFqn1+gABhIca2Y0H11wbo3BIFlslAr5yC2cB+L98KNkLpC22eVUSlhmIdfTea/6KFihA907y+rf5YFB2YUtBlFuZdXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r41M2B9/; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r41M2B9/"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6af9a90e40fso113765a12.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864941; x=1791469741; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VdKdmYQa5IF5pNpKkb7vq3XA/j7YuaBLx3jNXDvjAXQ=;
        b=r41M2B9/cQrW0OSe2iAhKfFdQOd1wQn3zkCIBoopBu6xIKGQl+iRYK7zpi2PXsUp0D
         SVPx2p2WufwZloxPm/qbJ0I1nhV4ayErmHR+v0gO8JjFU4u4Ys0gXmUy+EwfSWEIQB7+
         XirU9J+/0EENqKwXrn697Gb2n8KAtOmehQ2wC9I0IuBvFuLZnwfbtswA2WBUQVSasfZC
         rxJ5DlsEKQ3GuI76NWLqY20i3VwPRBhgOF2tVWyNeqlecTi2sJVY8bWNZCr0M9HUJ78q
         Ya+k7EWm6BpRyc2RVtL9NMfJ9Be0opAJBJ+4KN56hx4L/sGopTZb/U8LFwRm20sCk2wm
         tJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864941; x=1791469741;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VdKdmYQa5IF5pNpKkb7vq3XA/j7YuaBLx3jNXDvjAXQ=;
        b=zsFV+Ukz3q4or0dAz8wD88tGMI6+f3F8r8rjj+NQWHFir2M+82kfn66FgikOmdbnh+
         DNLClI/mJszxLmXFHDgVYVTkiEyXPmmIDenjyvQcuSwJTDqUI6nxpbPvonIA08/f0ruj
         qI6eq7ivnE4Ws46gTYw2+rxvF+B+yFGcEfwL/eB0Xg508d+2oN+jAxqiU5khPmA48E9E
         LUfZkXiZeXnZRC3Kl4swqOHSbfqwCI150wtzwWxUKkXZrJrzdn45fKBe4tlxjmX5p72V
         VivbyvWwbDKGqd1Dpzuyk+Z0g28X3igvnbPyANI3oGEgCF8mWQTe3xKo+/mKo4p0GbX5
         wSFQ==
X-Forwarded-Encrypted: i=1; AKwUvBxWBwCPqdpR9j7RkRbjfrISOnNLq8YAfe79BJl4tGSC3ZulR8uklnE6jj02GuNVturjJ6abkVk=@lists.linux.dev
X-Gm-Message-State: AFq9FYLqA0MtE+f/KyTSPb/dXjIH9iO3qMeiL1Sfv26NQzV/3uqRle2H
	6tbHWYv/1VhynHLtfyVmjwSdk7kY34WXDzCK917RdAW1K5m40yT9uju0LIBy3ZqGpA6h+WIyK7a
	fYEIda0mDXu/rOxs7EK0XCw==
X-Received: from edpg12.prod.google.com ([2002:aa7:d1cc:0:b0:6ac:7d1d:721f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:270d:b0:6ac:bccf:7c2a with SMTP id 4fb4d7f45d1cf-6ae198649f5mr3903585a12.2.1790864940795;
 Thu, 01 Oct 2026 07:29:00 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:36 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-6-vdonnefort@google.com>
Subject: [PATCH v6 05/18] KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
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
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++
 arch/arm64/kvm/mmu.c              |  4 +++-
 arch/arm64/kvm/pkvm.c             |  4 ++--
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fc1a82777ed4..64cd6233b439 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -92,9 +92,22 @@ struct kvm_hyp_memcache {
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
index 9ba86450fe4a..3163502cc7d2 100644
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
index 8e4c6e4bec12..e5200731a45b 100644
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
2.56.0.rc1.315.gc6ed9934b7-goog

