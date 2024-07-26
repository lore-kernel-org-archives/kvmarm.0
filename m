Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5499192B82
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038134; cv=none; b=TT/QuGwr/pMR6M3rcc8elQPGDRlRzAJYeMzpqoKw16+VWuJ6od6zckNvf4zikNBrpq3x4P8CWluYo49jwijY+pVu1r9Xo9c8jU7atJjbEpfCYSOKbnVr2G3TwfKzMeJ2Tc8sojZ4b0V+a+yEdRelA8fOl1IZGbFmzk2vS5mKUG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038134; c=relaxed/simple;
	bh=Q7iFhysn4W1WfxP0+7u3aZ05Q3iDxPLY40ZQrSBaHTY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZZ0hy8WSKcnHvRn2aMmbr0P4aRwScgY7FJgkRsirO6LJDHbVzdDYbjF81aGsVs7OiRpEofPzrZaIo1+m1R476ynAgCe5oaUwrweeXJsWECOGLxcO9nM3Pb7iKUtXZjfG8NCy+YKm6U85UYtWkxIbdkoGKiuMKKO/KbcZcfWU/+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0U+bRk1d; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0U+bRk1d"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d26115cd5so1194218b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038132; x=1722642932; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=diuq/5OTzA7KvKsX4AEile2HlGAF4SgNWi1szy67iaM=;
        b=0U+bRk1dPT5/Bp14MOm67Ur6tYG95RjyFLHp4dHZRBJPMB6y94TTyMT5uxYd5iqZ1c
         Kcs6/l4vsb4B8lY9665EmDeQl0yrV0B3m9zIJ3+FMESFww/9IT1vUf49OeY7ROZJ8gmC
         uLHXB8NHhTUvrkAFwW4fxzoKa0dijW7Gph98IJc5jMXbkRf1HXPP9JUpHloztJoY5Z8N
         dIZ+6ninMpfH0YHLgIiixn3YJP7Y+0FXLWCn/XS2kb56808NVwmqVLDamr7TnDJVczGu
         4gAjpHsI43basiBFI5kDGgMtsb6pRnC66/BZSb5xcWqWBwHaTWfyQ9QLWettfA/zXg+7
         ivXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038132; x=1722642932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=diuq/5OTzA7KvKsX4AEile2HlGAF4SgNWi1szy67iaM=;
        b=nr4P3qRnnsw+dx61piJn/00EAId65oyOdrRrZE0N4X9pDy5SC50VKLFmshNVHiHopc
         XlSpgzB+/4ZyXskvLo4rn2XMuEUM1XqROciBvWhyNkBCf/bSt1+wH1/+fylHQ2Uf+SZY
         rIBK88EF2mz9r6MzoZJ87fOUrAnz1OQlCRtU3A6i3nK4dIm+UvBV0eN8wutItC+Uaqrs
         Sumlih+Q5/JPhB99knHfRoTAKrx2l7hI8AVOl5eLTGlUwaCfs4VZZcKIUIDx3GztReXY
         BYYXfUwg5ompK2vVS6DZoKGsHCYoBNl9jV4c/auJnucioZWyzPBQGw/DWVnsqS9ybiSm
         T23Q==
X-Forwarded-Encrypted: i=1; AJvYcCUA8YAGoXnuMHJisS8YhYBd+41pB3P0FWWAej8+pzALSsGJPKcEZ3QqYedp++wG8gJIJiLXPfI9zLBjtgZLGSYX8aDzBupT
X-Gm-Message-State: AOJu0YyPg0sFABUOBFISIs6YTZp5KUimPDGqsusPk5VkGxie2xvoJHMM
	wJGKMH2hRnObGPx77vKGTdZL8yuU5HYY34wSKT3LO3KItDSK3ZVDlvnPWwBmpIROeJGgSO9nUy4
	AnQ==
X-Google-Smtp-Source: AGHT+IHhZHDOMBimQWMolk5T4YvfOEDeWobwSpVEA59XfGWHoVcD5oY/zbLuHzkbg8Phg0CxGQdxohIyYms=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:66e5:b0:70d:27ca:96b8 with SMTP id
 d2e1a72fcca58-70ece926ad1mr25428b3a.0.1722038131828; Fri, 26 Jul 2024
 16:55:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:33 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-85-seanjc@google.com>
Subject: [PATCH v12 84/84] KVM: Don't grab reference on VM_MIXEDMAP pfns that
 have a "struct page"
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

Now that KVM no longer relies on an ugly heuristic to find its struct page
references, i.e. now that KVM can't get false positives on VM_MIXEDMAP
pfns, remove KVM's hack to elevate the refcount for pfns that happen to
have a valid struct page.  In addition to removing a long-standing wart
in KVM, this allows KVM to map non-refcounted struct page memory into the
guest, e.g. for exposing GPU TTM buffers to KVM guests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  3 --
 virt/kvm/kvm_main.c      | 75 ++--------------------------------------
 2 files changed, 2 insertions(+), 76 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 87d61f16a449..d4513ffaf2e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1702,9 +1702,6 @@ void kvm_arch_sync_events(struct kvm *kvm);
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 
-struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn);
-bool kvm_is_zone_device_page(struct page *page);
-
 struct kvm_irq_ack_notifier {
 	struct hlist_node link;
 	unsigned gsi;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8b85e1130a63..e279140f2425 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -160,52 +160,6 @@ __weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
 {
 }
 
-bool kvm_is_zone_device_page(struct page *page)
-{
-	/*
-	 * The metadata used by is_zone_device_page() to determine whether or
-	 * not a page is ZONE_DEVICE is guaranteed to be valid if and only if
-	 * the device has been pinned, e.g. by get_user_pages().  WARN if the
-	 * page_count() is zero to help detect bad usage of this helper.
-	 */
-	if (WARN_ON_ONCE(!page_count(page)))
-		return false;
-
-	return is_zone_device_page(page);
-}
-
-/*
- * Returns a 'struct page' if the pfn is "valid" and backed by a refcounted
- * page, NULL otherwise.  Note, the list of refcounted PG_reserved page types
- * is likely incomplete, it has been compiled purely through people wanting to
- * back guest with a certain type of memory and encountering issues.
- */
-struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn)
-{
-	struct page *page;
-
-	if (!pfn_valid(pfn))
-		return NULL;
-
-	page = pfn_to_page(pfn);
-	if (!PageReserved(page))
-		return page;
-
-	/* The ZERO_PAGE(s) is marked PG_reserved, but is refcounted. */
-	if (is_zero_pfn(pfn))
-		return page;
-
-	/*
-	 * ZONE_DEVICE pages currently set PG_reserved, but from a refcounting
-	 * perspective they are "normal" pages, albeit with slightly different
-	 * usage rules.
-	 */
-	if (kvm_is_zone_device_page(page))
-		return page;
-
-	return NULL;
-}
-
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
  */
@@ -2814,35 +2768,10 @@ static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_pfn *kfp, struct page *page,
 	if (kfp->map_writable)
 		*kfp->map_writable = writable;
 
-	/*
-	 * FIXME: Remove this once KVM no longer blindly calls put_page() on
-	 *	  every pfn that points at a struct page.
-	 *
-	 * Get a reference for follow_pte() pfns if they happen to point at a
-	 * struct page, as KVM will ultimately call kvm_release_pfn_clean() on
-	 * the returned pfn, i.e. KVM expects to have a reference.
-	 *
-	 * Certain IO or PFNMAP mappings can be backed with valid struct pages,
-	 * but be allocated without refcounting, e.g. tail pages of
-	 * non-compound higher order allocations.  Grabbing and putting a
-	 * reference to such pages would cause KVM to prematurely free a page
-	 * it doesn't own (KVM gets and puts the one and only reference).
-	 * Don't allow those pages until the FIXME is resolved.
-	 *
-	 * Don't grab a reference for pins, callers that pin pages are required
-	 * to check refcounted_page, i.e. must not blindly release the pfn.
-	 */
-	if (pte) {
+	if (pte)
 		pfn = pte_pfn(*pte);
-
-		if (!kfp->pin) {
-			page = kvm_pfn_to_refcounted_page(pfn);
-			if (page && !get_page_unless_zero(page))
-				return KVM_PFN_ERR_FAULT;
-		}
-	} else {
+	else
 		pfn = page_to_pfn(page);
-	}
 
 	*kfp->refcounted_page = page;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

