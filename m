Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A59117D36F
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038012; cv=none; b=JpSHsThPiafeNTUGjfP8UIyZSwMuf7jI89ssQPuECbohITXpecpuJkSYoab6oe9QLF3+VB8k62OmUFe4hoDsYi51jkxiuyUm1lt2ZQLNEM13sau0v14N9tDJCXLUmUxHLIjJhg9503RXxrjiHrjIJTqgVQJDjAqwfUmHmWhtTBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038012; c=relaxed/simple;
	bh=Y9QuoXap+Xm28J95f/mEAStkkiyjgU4taMMEcAGhDr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kQg6CSbZRg9xuxXFoOXqOaowHeJgj0gKRsYQFSFq0T1uIBrfzZn3IodZDJ6O1uCWOn2ZEF3LoX+8ux7JbiJwvL2BnuJNpxKIB2PoKx4+/xSefOZDvTn5yEVVV3zb0R/4DBO5sqmsPgLZqzF5m+6yJRN3TSssWajro4nc5KNb1As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uH/4ExQ9; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uH/4ExQ9"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d1df50db2so1367927b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038010; x=1722642810; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tUI1d5PvM6nQSFLRYt7w7bGZCStWjtac1YnX2jIYbCg=;
        b=uH/4ExQ9GuEuW3ia4xsf8iY5aAnWVYXCBiCBwraGVqEoftpmZ2rjPiFd7+YcKs0eZQ
         J0DXA8ni97BkNGCeIHH/WlD8aL2Nnm9y2/ka4VrWqmP5/Ofkhmx3eJZkQ+ow/zEQVNIG
         DRWAN4wO8z63srdIlKndaNG+CG+F4C6jV6AxJoIsQWUHJgAlR9q/oHs0iYKxicaU7S+a
         2izKni4hbBebgdcwUiSwKiCVqncO7kAevvsyNKR2QH0QIIvXzq9WS25G5y4kkHWkz53k
         GfY1anTzeiHfAgSg24KDlv/7BqXkz6r8cOLSplHW5BYF1bKHc62fmU9bZrzXgQQhHzOd
         JCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038010; x=1722642810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tUI1d5PvM6nQSFLRYt7w7bGZCStWjtac1YnX2jIYbCg=;
        b=ird6rLUWDL6aFu7EhJDfWwhLr0ZjOrK5i3pV3mGLPnFLnfCqTQAuLAOWgwZ8O1dPrK
         RZYy8Bp//RDrSZvFNLflqeRNRgxkiR/0kSgYw9HE5mnCxtllwPC39peI1LFSIhzp5DxT
         1z8LDFoFbcSkDJa7g1VistE+fzQWBgImG93F+rPyQ3I8pzhqkeWNWpvGaLus7kbAM47o
         vVC3CKIjZJWwqIBaSHH5VF6Goc2xj4aww/RSAIiqUiP9faWDEsJZRqZt1bGTa71N2j6I
         yDKtXgBi6FyZmnxTWlD4rGX5V8DCRn6GK0WlaopqtePP1tSEl7khfwwX4b1tY+xApaEv
         G2Vg==
X-Forwarded-Encrypted: i=1; AJvYcCU8wNW2DZFPvTwmIeycBnLUw7EzSf4bj3LckUPKlWNbsyAby7ADxq/l2igR0FwIcHyL0czsRAXYsIpfNbUaRglRY/NnKjrc
X-Gm-Message-State: AOJu0YwQ3+gZ1fYxAI20AC6gccPCq4El2BrFIsoERJkMBsbPlTOeMkmS
	RrH+BhvUswfBGus9jwl6MEya3EGvoH7QNuHsfgxdaaAzjeRAbVhiLZid122hl0Bp2tXZyUH03xg
	+qw==
X-Google-Smtp-Source: AGHT+IGIDN5ccGIB3cs8xyjoNBA33aBwY8OuaAQU+QnM7LAxDHF+KLZuhqGJARF7orYR9wXwPpBL0fgCScs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8593:b0:70d:3466:2f1a with SMTP id
 d2e1a72fcca58-70ece63fd2emr7784b3a.1.1722038009466; Fri, 26 Jul 2024 16:53:29
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:34 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-26-seanjc@google.com>
Subject: [PATCH v12 25/84] KVM: Provide refcounted page as output field in
 struct kvm_follow_pfn
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

Add kvm_follow_pfn.refcounted_page as an output for the "to pfn" APIs to
"return" the struct page that is associated with the returned pfn (if KVM
acquired a reference to the page).  This will eventually allow removing
KVM's hacky kvm_pfn_to_refcounted_page() code, which is error prone and
can't detect pfns that are valid, but aren't (currently) refcounted.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 100 +++++++++++++++++++++-----------------------
 virt/kvm/kvm_mm.h   |   9 ++++
 2 files changed, 56 insertions(+), 53 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8e83d3f043f1..31570c5627e3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2756,6 +2756,46 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 	return rc == -EHWPOISON;
 }
 
+static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_pfn *kfp, struct page *page,
+				 pte_t *pte, bool writable)
+{
+	kvm_pfn_t pfn;
+
+	WARN_ON_ONCE(!!page == !!pte);
+
+	if (kfp->map_writable)
+		*kfp->map_writable = writable;
+
+	/*
+	 * FIXME: Remove this once KVM no longer blindly calls put_page() on
+	 *	  every pfn that points at a struct page.
+	 *
+	 * Get a reference for follow_pte() pfns if they happen to point at a
+	 * struct page, as KVM will ultimately call kvm_release_pfn_clean() on
+	 * the returned pfn, i.e. KVM expects to have a reference.
+	 *
+	 * Certain IO or PFNMAP mappings can be backed with valid struct pages,
+	 * but be allocated without refcounting, e.g. tail pages of
+	 * non-compound higher order allocations.  Grabbing and putting a
+	 * reference to such pages would cause KVM to prematurely free a page
+	 * it doesn't own (KVM gets and puts the one and only reference).
+	 * Don't allow those pages until the FIXME is resolved.
+	 */
+	if (pte) {
+		pfn = pte_pfn(*pte);
+		page = kvm_pfn_to_refcounted_page(pfn);
+		if (page && !get_page_unless_zero(page))
+			return KVM_PFN_ERR_FAULT;
+	} else {
+		pfn = page_to_pfn(page);
+	}
+
+	if (kfp->refcounted_page)
+		*kfp->refcounted_page = page;
+
+	return pfn;
+}
+
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
@@ -2774,9 +2814,7 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 		return false;
 
 	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, &page)) {
-		*pfn = page_to_pfn(page);
-		if (kfp->map_writable)
-			*kfp->map_writable = true;
+		*pfn = kvm_resolve_pfn(kfp, page, NULL, true);
 		return true;
 	}
 
@@ -2808,23 +2846,15 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 	if (npages != 1)
 		return npages;
 
-	if (!kfp->map_writable)
-		goto out;
-
-	if (kfp->flags & FOLL_WRITE) {
-		*kfp->map_writable = true;
-		goto out;
-	}
-
 	/* map read fault as writable if possible */
-	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, &wpage)) {
-		*kfp->map_writable = true;
+	if (!(flags & FOLL_WRITE) && kfp->map_writable &&
+	    get_user_page_fast_only(kfp->hva, FOLL_WRITE, &wpage)) {
 		put_page(page);
 		page = wpage;
+		flags |= FOLL_WRITE;
 	}
 
-out:
-	*pfn = page_to_pfn(page);
+	*pfn = kvm_resolve_pfn(kfp, page, NULL, flags & FOLL_WRITE);
 	return npages;
 }
 
@@ -2839,20 +2869,9 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 	return true;
 }
 
-static int kvm_try_get_pfn(kvm_pfn_t pfn)
-{
-	struct page *page = kvm_pfn_to_refcounted_page(pfn);
-
-	if (!page)
-		return 1;
-
-	return get_page_unless_zero(page);
-}
-
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       struct kvm_follow_pfn *kfp, kvm_pfn_t *p_pfn)
 {
-	kvm_pfn_t pfn;
 	pte_t *ptep;
 	pte_t pte;
 	spinlock_t *ptl;
@@ -2882,38 +2901,13 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	pte = ptep_get(ptep);
 
 	if (write_fault && !pte_write(pte)) {
-		pfn = KVM_PFN_ERR_RO_FAULT;
+		*p_pfn = KVM_PFN_ERR_RO_FAULT;
 		goto out;
 	}
 
-	if (kfp->map_writable)
-		*kfp->map_writable = pte_write(pte);
-	pfn = pte_pfn(pte);
-
-	/*
-	 * Get a reference here because callers of *hva_to_pfn* and
-	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
-	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
-	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
-	 * simply do nothing for reserved pfns.
-	 *
-	 * Whoever called remap_pfn_range is also going to call e.g.
-	 * unmap_mapping_range before the underlying pages are freed,
-	 * causing a call to our MMU notifier.
-	 *
-	 * Certain IO or PFNMAP mappings can be backed with valid
-	 * struct pages, but be allocated without refcounting e.g.,
-	 * tail pages of non-compound higher order allocations, which
-	 * would then underflow the refcount when the caller does the
-	 * required put_page. Don't allow those pages here.
-	 */
-	if (!kvm_try_get_pfn(pfn))
-		r = -EFAULT;
-
+	*p_pfn = kvm_resolve_pfn(kfp, NULL, &pte, pte_write(pte));
 out:
 	pte_unmap_unlock(ptep, ptl);
-	*p_pfn = pfn;
-
 	return r;
 }
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index d5a215958f06..d3ac1ba8ba66 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -35,6 +35,15 @@ struct kvm_follow_pfn {
 	 * Set to true if a writable mapping was obtained.
 	 */
 	bool *map_writable;
+
+	/*
+	 * Optional output.  Set to a valid "struct page" if the returned pfn
+	 * is for a refcounted or pinned struct page, NULL if the returned pfn
+	 * has no struct page or if the struct page is not being refcounted
+	 * (e.g. tail pages of non-compound higher order allocations from
+	 * IO/PFNMAP mappings).
+	 */
+	struct page **refcounted_page;
 };
 
 kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp);
-- 
2.46.0.rc1.232.g9752f9e123-goog

