Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437E5C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA80349F24;
	Fri, 15 Apr 2022 17:59:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Y+xCxOU0nEN; Fri, 15 Apr 2022 17:59:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 822174B14D;
	Fri, 15 Apr 2022 17:59:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6C264A4BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AU2uoQGRpWp1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:23 -0400 (EDT)
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com
 [209.85.161.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 90E9249F11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:20 -0400 (EDT)
Received: by mail-oo1-f73.google.com with SMTP id
 t19-20020a4a96d3000000b003295d7ce159so4873278ooi.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=22i24DLcyXUieSnW3PAwQCkjoUnvyMWdp2sKJnAUF64=;
 b=VPtHgLB2eymVJQjQSElXFQ0Zv2gLUgxLry175CS0FCPH1QdUk/jXMMBoPOrHmGBwoq
 eWdmwHWefSkyKrTkoNNUmWeZAwfQOesyHQ/c4F+nNUh1RnLeH6LvowZHB8nX3nwQ6l3L
 GEUKEunrQWJsjT9PH9meExTOYNHH3hU7S6IfE1PLsiTpOqRRkTbel/mLpuqamcBbNfG9
 GoFAe3BQFqD1GHm76/Rdvr36nNdmSstr6rfNRpwHof4KzfU+AjgBiLREY1NzMY207hNQ
 sxhnRfFngtq2kuNUX0v2DKU0e2znK8YIUUSoecH7YVoHWITRrIMv7LGu6/DrG+fBMRUD
 Iqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=22i24DLcyXUieSnW3PAwQCkjoUnvyMWdp2sKJnAUF64=;
 b=iKkRjh8blXNLDV+xO2atoPEu4OCbY1vpy/j2gBVeh7897UfItD8bxFz5e9posjpKxX
 xds8W3nRPY0TN53jQAJdKVrORodpg2iN/1/0y6zpfMjrcbz3Z3vY2ZJIenflVQCiEfU6
 4GXdDM+cAW8GfmiJjH2XVCABY1tfWnJdFlMPnxKH+wDN+oVkvdKsWr9P3UpkKfvRWAQD
 LeOyc6vrHLevM+VWahhiTXBiZnsxEr5MpYrHR189A3DAGp/HXLNpuPO/wLnI/jBxvc1g
 YDxNDzcIrUxx3bE8TnGfnWPaJ1E1ie4IbfGrHHNGhI2Pr1ANzvS7MdUqGLqImn5yBLpN
 uR5Q==
X-Gm-Message-State: AOAM5310zaLHKj2f86MS0GxJnV3Zi4e/1DwP5y4gse7OsGGgJTgF/ibf
 LEb/Abg8hfKhL64Hi6uEe3bbCB4KgJhZIy7VwmLfBGNKgXGzovKEZAJF3Uai33RQ0vz3v6+TRcp
 nc2AnJ6cUAIMrrF7siQX05e25zNA4atC49TvlGW6evOOFL2pZQQhDDTiDOULbMhC8ND5ngw==
X-Google-Smtp-Source: ABdhPJya0hEPL3+v3IGSw82KDihmFFDLjFiBSt27i0G11hzjmjLYmOhkEY2+c79aK0bz4MZlGmwNEBfJ24k=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6870:639e:b0:e2:ab7c:d868
 with SMTP id
 t30-20020a056870639e00b000e2ab7cd868mr373366oap.108.1650059959809; Fri, 15
 Apr 2022 14:59:19 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:56 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-13-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 12/17] KVM: arm64: Stuff mmu page cache in sub struct
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

We're about to add another mmu cache. Stuff the current one in a sub
struct so its easier to pass them all to ->zalloc_page().

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  4 +++-
 arch/arm64/kvm/mmu.c              | 14 +++++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 94a27a7520f4..c8947597a619 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -372,7 +372,9 @@ struct kvm_vcpu_arch {
 	bool pause;
 
 	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
+	struct kvm_mmu_caches {
+		struct kvm_mmu_memory_cache page_cache;
+	} mmu_caches;
 
 	/* Target CPU and feature flags */
 	int target;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f29d5179196b..7a588928740a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -91,10 +91,10 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 
 static void *stage2_memcache_zalloc_page(void *arg)
 {
-	struct kvm_mmu_memory_cache *mc = arg;
+	struct kvm_mmu_caches *mmu_caches = arg;
 
 	/* Allocated with __GFP_ZERO, so no need to zero */
-	return kvm_mmu_memory_cache_alloc(mc);
+	return kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
 }
 
 static void *kvm_host_zalloc_pages_exact(size_t size)
@@ -1073,7 +1073,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool shared;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	struct kvm_mmu_caches *mmu_caches = &vcpu->arch.mmu_caches;
 	struct vm_area_struct *vma;
 	short vma_shift;
 	gfn_t gfn;
@@ -1160,7 +1160,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
 	if (fault_status != FSC_PERM || (logging_active && write_fault)) {
-		ret = kvm_mmu_topup_memory_cache(memcache,
+		ret = kvm_mmu_topup_memory_cache(&mmu_caches->page_cache,
 						 kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			return ret;
@@ -1273,7 +1273,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
-					     memcache);
+					     mmu_caches);
 	}
 
 	/* Mark the page dirty only if the fault is handled successfully */
@@ -1603,12 +1603,12 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 
 void kvm_mmu_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+	vcpu->arch.mmu_caches.page_cache.gfp_zero = __GFP_ZERO;
 }
 
 void kvm_mmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_caches.page_cache);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
