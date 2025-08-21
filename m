Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3BC2EAB82
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810058; cv=none; b=AGdjOLXIlTL8+PgGlRp0Ce+ZffFF/MOUNYU1A/Pr6PhKTSlWc7+KGEX5aql0BQUZEQOgrVJ42Yh5DnX++GjlV6fB2GQGNw7dBGPeGC45iri8iiTgCjv9JWsbVWf5kM154iZz0LBHNk2OhrjptiJ9GhNqSCUVMWwSA3EN9BTCyCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810058; c=relaxed/simple;
	bh=O97tgp5t9/0u9T/cM2oyRaSjhATuyjcKvcGSgt6Pzfo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HUz7fzWZK1UNQs0biMHc2rBK0incGCHGsR33DOAfSybouZQxu48JkanrCgRb1mH6NXpOjxOBM7g0pIOaEpVZgPJDwJm2rNR/bxcrV+qA7HRiy5AkUWLpGTPKc7GCI14xuenEdB5djka2/Vk7eCTsi5/EbDqDtiarhye3qgugdOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s369OeHw; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s369OeHw"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b474b68cff7so1173730a12.1
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810056; x=1756414856; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vioVXt2ZZgg7NeYPZVOuYjJyML9DfewAFD4Lo8ICLyI=;
        b=s369OeHw5nyE2NehuuYU2ofh+vvfeDG5yzAF3gf7lGfq4eFPQifYYUMRP+/OBLjqFM
         is4ti/zQkTWZzIwo0qyg/icxlCg2ieo9vQufe0tlTffpS95Gv/57ArOLQDAvpvLCbMJr
         hjyhMf5zjTY3wvRr8AEH51V1Bt/PrL9wZy8lQgzGp1uGmIK5x9KkQQQhuMjU3m7QIDjA
         PYt/D/6y2CCSLBLdxTGcte/E9MQ/2tf4QQStJnyUyv/OX6aTQtGISFPunwjNnUN0qxmw
         XgjKGhehPWWxL+57mqq6dnh5XbvvjvMfG7mxyZ1fYrfuxhvdwAtdU6O9dMI3B93jfPiE
         obiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810056; x=1756414856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vioVXt2ZZgg7NeYPZVOuYjJyML9DfewAFD4Lo8ICLyI=;
        b=blqmejldIuA8e0x0rmc/EfF0GndFDS+HdRyct4aMGkzY/jxyKwL05PHx8rEvAwo1U9
         xSvCB46C+FhUSitCoecjrltGkaHmJlSeRpnZ8/2mLmlaSAlM2cJVqs9427oO1JilLAI0
         W0yYcGXmkcZS3hNl/SrJ8h7meAKCqeozr4eIx6Tfu7VTZYhzqRC8Hwqj0fZBI3qPRBVA
         AiEo8r5hPQPtb0V7up4BCd0Juf3HsE4BHCDg72R3kI78ym/d+Nldu2gA+X7x/8wgC0Vg
         WmOcGf+hR7E7GRapBqG8LmfDjR2kz45OCOtNBQRU2vr8mGik16sTZniog3r5wj7QzMya
         jUug==
X-Forwarded-Encrypted: i=1; AJvYcCXaU7O39PhvR/E71OhmF7Q9ozhvGZu2T3PkAjBPDEMWqlJ0UuFgD5kAg/8bQtHQ5S1ACskxlic=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywu+0J2uyycvMb7dA039oCRfFiT0KLsRoQnwyZYrmRKaHYCFXoM
	raoe3N/UK6ZTrcpli13PPPDyMbFkIiL19swLwOhYWSalHVTz+PL+fyAb7xEzYXqaSVeNBlHS+gu
	p8TMIZA==
X-Google-Smtp-Source: AGHT+IFMAoySLGWaBGxxLE7EGe5/JK70vfGurcQkwXtR0YxVIkKbRYcB3XHf65NsmmZ5Hb+78WjJ0WrD9XU=
X-Received: from pjbee15.prod.google.com ([2002:a17:90a:fc4f:b0:321:c3cc:2574])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c45:b0:324:e96a:2ada
 with SMTP id 98e67ed59e1d1-3251774ac2emr940105a91.21.1755810055944; Thu, 21
 Aug 2025 14:00:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:32 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-7-seanjc@google.com>
Subject: [RFC PATCH 06/16] KVM: arm64: Pass kvm_page_fault pointer to transparent_hugepage_adjust()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Use the local kvm_page_fault structure to adjust for transparent hugepages
when resolving guest aborts, to reduce the number of parameters from 5=>2,
and to eliminate the less-than-pleasant pointer dereferences.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ca98778989b2..047aba00388c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1361,19 +1361,15 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  * Returns the size of the mapping.
  */
 static long
-transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			    unsigned long hva, kvm_pfn_t *pfnp,
-			    phys_addr_t *ipap)
+transparent_hugepage_adjust(struct kvm *kvm, struct kvm_page_fault *fault)
 {
-	kvm_pfn_t pfn = *pfnp;
-
 	/*
 	 * Make sure the adjustment is done only for THP pages. Also make
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
-		int sz = get_user_mapping_size(kvm, hva);
+	if (fault_supports_stage2_huge_mapping(fault->slot, fault->hva, PMD_SIZE)) {
+		int sz = get_user_mapping_size(kvm, fault->hva);
 
 		if (sz < 0)
 			return sz;
@@ -1381,10 +1377,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		if (sz < PMD_SIZE)
 			return PAGE_SIZE;
 
-		*ipap &= PMD_MASK;
-		pfn &= ~(PTRS_PER_PMD - 1);
-		*pfnp = pfn;
-
+		fault->ipa &= PMD_MASK;
+		fault->pfn &= ~(PTRS_PER_PMD - 1);
 		return PMD_SIZE;
 	}
 
@@ -1724,9 +1718,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (fault->is_perm && fault_granule > PAGE_SIZE)
 			vma_pagesize = fault_granule;
 		else
-			vma_pagesize = transparent_hugepage_adjust(kvm, fault->slot,
-								   fault->hva, &fault->pfn,
-								   &fault->fault_ipa);
+			vma_pagesize = transparent_hugepage_adjust(kvm, fault);
 
 		if (vma_pagesize < 0) {
 			ret = vma_pagesize;
-- 
2.51.0.261.g7ce5a0a67e-goog

