Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F5B181320
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038040; cv=none; b=XkVPZ/9uAvr2LEQcZLMlMS6ygN+cgFV13MtdXULFysNYapV7WcioPnNM5oKk2pG4WSPoHz/LJMA5hlj+nES4E9P1ifgwWCTRC11RD/YeUMh0qjspt5hnlZy1rI1cNqFq9enlc4xTBZwNgkHNZEPVwqwjjVE47dV7iRmpG0kFUL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038040; c=relaxed/simple;
	bh=wGZHvIOm+uvxUha7v63Q2rhvuGfIObXUhdqt56QjUZg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G8bL8jDn9KFpH7z6wZM++SA3S3ysXc1q/DnBLh+tow0lydvqYMFa6+K0MwZq6v5kGojUEQ8nrX3BYr2VSshiy2RWaTipyPaqQiTmDVGLPB5zMEd9uVlSGWEJIScACeAWy6hZocqBqGQ5kYce0BRt8HmYMQ6kKrcuEI1ZCQ1+U8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mzFEt+Hy; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mzFEt+Hy"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb4c2276b6so1596346a91.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038038; x=1722642838; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Qh6T21uN8n1VHf7Uf0xlt62GR+52F2/YXe/M8yozbBs=;
        b=mzFEt+HyWXpgE3R0n4RaqKuBIuXUGrz7a+9GRuitOVIX7UtvKsLFCej1UBA58GKv60
         LKffxCa6OtMFP0UU4clRePHThG33Yphwt/NkDoaQU8ha5MErL0Rx9xnB6LjeokPOjaOm
         WmOiI065EiwA6v14UipLKolzMIRpOsHLTzExWXfSLZMdc2q567aZvI3DSwCH8RpZMveq
         Fh8f9ykBvQUp+2TxqdRBzlXCNOh2vWVxkL4mMIihLAuPxau7wExiaIrDQM3P3r20lvFI
         tSiI2GM8CwGPx2pZegVrS9QIPiAN4Fl48zuBWt4ewwPaAYwUlZPcUmW3vtjoyVzBcEIz
         Uvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038038; x=1722642838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qh6T21uN8n1VHf7Uf0xlt62GR+52F2/YXe/M8yozbBs=;
        b=ho4Aklml09LnufbNbfYHRi74LMYTlLAUHcxj7vKK8ojgFVsL6DUaIxqovQv37IckJe
         sIoatXPJdZI5wu0Q83XqkeBZ4L8+xqHNH2YBYimfvNYLBu2BttR/b3TQ3NjprPMqZg+n
         PTNH4khpQzbs51o6amsg6JilpZuvzAI999RL/TNJpEfB+y/pwO5eYsq30hDN2rWZCwnH
         EoN/O/3V2zJ7nMmtGs8f6XhjAyMIONt9ElSbWKVUGqedA5cm6jqZJAmLKsLkgZZz5UZF
         JoRAf1UO4Ipw8aY5XPrjGeoY9bq3u0txeV1gDT6w3EIaV3yDlCUDyXt1p5SgLwHxPbjE
         1uSA==
X-Forwarded-Encrypted: i=1; AJvYcCUonQFvkpQx2J1vUJCCjj/0f/VGWcg+z1BM6N0OzZHCzMA+3xreFBJf45vxgTcHTwDLScjWd/u9lIxkt6jsjyRNf82pHPxz
X-Gm-Message-State: AOJu0YxwP8WZTOwewx09+TO0JM2NAuMbXXQd9C7MJB9beOpbgG8cjEHP
	XYFWTRqIpRXCg2dFSZwEMdH9pCXXgHfLn22QrGSnmHCLcEH35+rRL8xOl6qrHcf9kKbtyOY17f/
	gvA==
X-Google-Smtp-Source: AGHT+IHJ/uNdZAPdurru3IzCEMezhYQEvGsVQTc+qIu+wSY9S108IorpvBbDocczOA6aFsvKzrBA+JBrX4Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4495:b0:2c9:61e2:ce26 with SMTP id
 98e67ed59e1d1-2cf7e1c639emr12819a91.2.1722038038053; Fri, 26 Jul 2024
 16:53:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:48 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-40-seanjc@google.com>
Subject: [PATCH v12 39/84] KVM: x86/mmu: Add common helper to handle
 prefetching SPTEs
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
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Deduplicate the prefetching code for indirect and direct MMUs.  The core
logic is the same, the only difference is that indirect MMUs need to
prefetch SPTEs one-at-a-time, as contiguous guest virtual addresses aren't
guaranteed to yield contiguous guest physical addresses.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 40 +++++++++++++++++++++-------------
 arch/x86/kvm/mmu/paging_tmpl.h | 13 +----------
 2 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0def1444c01c..e76f64f55c4a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2897,32 +2897,41 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	return ret;
 }
 
-static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
-				    struct kvm_mmu_page *sp,
-				    u64 *start, u64 *end)
+static bool kvm_mmu_prefetch_sptes(struct kvm_vcpu *vcpu, gfn_t gfn, u64 *sptep,
+				   int nr_pages, unsigned int access)
 {
 	struct page *pages[PTE_PREFETCH_NUM];
 	struct kvm_memory_slot *slot;
-	unsigned int access = sp->role.access;
-	int i, ret;
-	gfn_t gfn;
+	int i;
+
+	if (WARN_ON_ONCE(nr_pages > PTE_PREFETCH_NUM))
+		return false;
 
-	gfn = kvm_mmu_page_get_gfn(sp, spte_index(start));
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
 	if (!slot)
-		return -1;
+		return false;
 
-	ret = kvm_prefetch_pages(slot, gfn, pages, end - start);
-	if (ret <= 0)
-		return -1;
+	nr_pages = kvm_prefetch_pages(slot, gfn, pages, nr_pages);
+	if (nr_pages <= 0)
+		return false;
 
-	for (i = 0; i < ret; i++, gfn++, start++) {
-		mmu_set_spte(vcpu, slot, start, access, gfn,
+	for (i = 0; i < nr_pages; i++, gfn++, sptep++) {
+		mmu_set_spte(vcpu, slot, sptep, access, gfn,
 			     page_to_pfn(pages[i]), NULL);
 		kvm_release_page_clean(pages[i]);
 	}
 
-	return 0;
+	return true;
+}
+
+static bool direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
+				     struct kvm_mmu_page *sp,
+				     u64 *start, u64 *end)
+{
+	gfn_t gfn = kvm_mmu_page_get_gfn(sp, spte_index(start));
+	unsigned int access = sp->role.access;
+
+	return kvm_mmu_prefetch_sptes(vcpu, gfn, start, end - start, access);
 }
 
 static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
@@ -2940,8 +2949,9 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 		if (is_shadow_present_pte(*spte) || spte == sptep) {
 			if (!start)
 				continue;
-			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
+			if (!direct_pte_prefetch_many(vcpu, sp, start, spte))
 				return;
+
 			start = NULL;
 		} else if (!start)
 			start = spte;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b02d0abfca68..e1c2f098d9d5 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -533,9 +533,7 @@ static bool
 FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     u64 *spte, pt_element_t gpte)
 {
-	struct kvm_memory_slot *slot;
 	unsigned pte_access;
-	struct page *page;
 	gfn_t gfn;
 
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
@@ -545,16 +543,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
-	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, pte_access & ACC_WRITE_MASK);
-	if (!slot)
-		return false;
-
-	if (kvm_prefetch_pages(slot, gfn, &page, 1) != 1)
-		return false;
-
-	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, page_to_pfn(page), NULL);
-	kvm_release_page_clean(page);
-	return true;
+	return kvm_mmu_prefetch_sptes(vcpu, gfn, spte, 1, pte_access);
 }
 
 static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
-- 
2.46.0.rc1.232.g9752f9e123-goog

