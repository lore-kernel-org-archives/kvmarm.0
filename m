Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5F81E3771
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584707; cv=none; b=JiZQphgOMYlwPwG0oApcs5VQNsG13vCtZRUSVZvfd+KxGR0ecw9SpFCh/OtN5kJmOo9Nt+i8VZ9Pz8R5S7Hqfa3rTP0lL52Ytm1bmXAblRsLRYXMO2SSQmGB+DurrbrniKr6V4KHaVraOCVScDUOInb5Ofj1ofdl0dVcxTgD86I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584707; c=relaxed/simple;
	bh=V8Pz/YRM4TKMSvyoWeXbxNdYc7yxSwxWSxDHm25abTE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D4323BWlNDUSce7u8kPBJCAXE8YnUSePpl1h9PHKJZqMXPBZd7DA6Oq2iVArI95fFhvxOvjoGUQ6qBaeEwS0DczX1Xpy+iV8Y2Xv/6XzeCPGzELkEukjPeN0W8f92ahTpqzi7+OVk4RRN7b55fR0m6bx0OduN8MgEjCuDvy50M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IJ1DG+cO; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IJ1DG+cO"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e28fea2adb6so1485166276.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584704; x=1729189504; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zmCOkT+wuJeT9H1MjXHCrAkGhLQoiMWK376kHF4kwCg=;
        b=IJ1DG+cOlSEV9yANgRpmCLs/5DxYKLv6kdabe52BHvmPenXM3FAg1cxWI1epmPptys
         X3FujXVIQdVIPejSMEHlMlC9TTsYczx3BNQcmFKyUVSj3UNkEQL+fzt/APmycXYAgukC
         eMb29OHWIQWYTlifM1fgo3y27wxWE4Mvh7fvNpTwYfYPO5p0LDZ3T41U+lAip4KCHhaW
         HwSFuxY0stsAj/tjZKxZj44H2FKtiHI/Rkqoe1Oa21OZw9lGDj1CFyV90SkSX8RYpSgI
         t4fxx0m54eXV1eJMjfTpmrnBgJ9px25noCdRF/CFd4c4TsKrgy+GDcp/gZBkqTLMugIc
         Id7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584704; x=1729189504;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zmCOkT+wuJeT9H1MjXHCrAkGhLQoiMWK376kHF4kwCg=;
        b=Puo+MHb4/iaA4KM10lwNQS/b5vmStvvL/PpVVej4hBMDwKH/7VQi6fjxxzBsLOWWEG
         lwxSSLmArs4yKP5l0FK5QrwEPmK9ePhc5Gqi+q6ZCq+IQvWK1dMPWVIqm4Ia0kkX5Xj7
         ThU7MYtj8ZTGZs7R4D1W46nBE+s4bNjzdVddVHQzqJi+U30VU8U3tacXPSYy4+VwPj06
         B6CkOnF+e/m44o769lD3HfLNich1LtzUKedflpq7Q7FeJBycil++YiGgIdLln4g6+263
         5Yb15xRpFQktSOkLkvZAc+X5EKjB0WlAX/hHXZItddu5qVPFD7CMParUL5dcAJUq70EU
         Zvfg==
X-Forwarded-Encrypted: i=1; AJvYcCWylvl6dz09OqtvO/rmLQurct2+2zaYgM1OojdZe41ZTBf5dhksQstl1Pfh8YdWmONPeBvIhpo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOlbBqOO6fyfeL1qBQS2/YeiSLMUnj9mpqOqvqoc0W45uc6KiY
	8agdSFjdwKP0heNYp/xhMYShcWP4ni5Uik46ODlHuANdwHYde4Fo+z+4woP61xNNFGHstiMouih
	WHg==
X-Google-Smtp-Source: AGHT+IHLS32ZnUy4bY0gdVqRjJSlR5N1zmb3UxYk5drKGwVtxhq/Y8NIZIwMp1duovDzYwXPQsOfO5WBu4o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1812:b0:e24:9f58:dd17 with SMTP id
 3f1490d57ef6-e28fe32f042mr66754276.1.1728584702932; Thu, 10 Oct 2024 11:25:02
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:08 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-7-seanjc@google.com>
Subject: [PATCH v13 06/85] KVM: x86/mmu: Invert @can_unsync and renamed to @synchronizing
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Invert the polarity of "can_unsync" and rename the parameter to
"synchronizing" to allow a future change to set the Accessed bit if KVM
is synchronizing an existing SPTE.  Querying "can_unsync" in that case is
nonsensical, as the fact that KVM can't unsync SPTEs doesn't provide any
justification for setting the Accessed bit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 12 ++++++------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/mmu/spte.c         |  4 ++--
 arch/x86/kvm/mmu/spte.h         |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 ++--
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8c64069aa89..0f21d6f76cab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2795,7 +2795,7 @@ static void kvm_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
  * be write-protected.
  */
 int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
-			    gfn_t gfn, bool can_unsync, bool prefetch)
+			    gfn_t gfn, bool synchronizing, bool prefetch)
 {
 	struct kvm_mmu_page *sp;
 	bool locked = false;
@@ -2810,12 +2810,12 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 
 	/*
 	 * The page is not write-tracked, mark existing shadow pages unsync
-	 * unless KVM is synchronizing an unsync SP (can_unsync = false).  In
-	 * that case, KVM must complete emulation of the guest TLB flush before
-	 * allowing shadow pages to become unsync (writable by the guest).
+	 * unless KVM is synchronizing an unsync SP.  In that case, KVM must
+	 * complete emulation of the guest TLB flush before allowing shadow
+	 * pages to become unsync (writable by the guest).
 	 */
 	for_each_gfn_valid_sp_with_gptes(kvm, sp, gfn) {
-		if (!can_unsync)
+		if (synchronizing)
 			return -EPERM;
 
 		if (sp->unsync)
@@ -2941,7 +2941,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
-			   true, host_writable, &spte);
+			   false, host_writable, &spte);
 
 	if (*sptep == spte) {
 		ret = RET_PF_SPURIOUS;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c98827840e07..4da83544c4e1 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -164,7 +164,7 @@ static inline gfn_t gfn_round_for_level(gfn_t gfn, int level)
 }
 
 int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
-			    gfn_t gfn, bool can_unsync, bool prefetch);
+			    gfn_t gfn, bool synchronizing, bool prefetch);
 
 void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ae7d39ff2d07..6e7bd8921c6f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -963,7 +963,7 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 	host_writable = spte & shadow_host_writable_mask;
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	make_spte(vcpu, sp, slot, pte_access, gfn,
-		  spte_to_pfn(spte), spte, true, false,
+		  spte_to_pfn(spte), spte, true, true,
 		  host_writable, &spte);
 
 	return mmu_spte_update(sptep, spte);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 5521608077ec..0e47fea1a2d9 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -157,7 +157,7 @@ bool spte_has_volatile_bits(u64 spte)
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-	       u64 old_spte, bool prefetch, bool can_unsync,
+	       u64 old_spte, bool prefetch, bool synchronizing,
 	       bool host_writable, u64 *new_spte)
 {
 	int level = sp->role.level;
@@ -248,7 +248,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
 		 */
-		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, can_unsync, prefetch)) {
+		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, synchronizing, prefetch)) {
 			wrprot = true;
 			pte_access &= ~ACC_WRITE_MASK;
 			spte &= ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 2cb816ea2430..c81cac9358e0 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -499,7 +499,7 @@ bool spte_has_volatile_bits(u64 spte);
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-	       u64 old_spte, bool prefetch, bool can_unsync,
+	       u64 old_spte, bool prefetch, bool synchronizing,
 	       bool host_writable, u64 *new_spte);
 u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
 		      	      union kvm_mmu_page_role role, int index);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3c6583468742..76bca7a726c1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1033,8 +1033,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
 		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+				   fault->pfn, iter->old_spte, fault->prefetch,
+				   false, fault->map_writable, &new_spte);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-- 
2.47.0.rc1.288.g06298d1525-goog

