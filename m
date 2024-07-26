Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF837191F86
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038129; cv=none; b=HwS8/8EM3gmtg/bMLKLADg47qKZjwbtMkaGu0ReEi7pZPchtKL698bfGC+AzmfZAud16nS9T4bsL1TK5+Aza9qbB5BT9RMyB3RDuEBQdIdlommTuZraZWsuIcWtih2i8EMpGKqZRYtdxHI5Goq38y5LFu6kTk5mwSiPw70wnKzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038129; c=relaxed/simple;
	bh=KB6xn4OZUICEWZrxSAqwnEMQRTZa0ja3Fgai7TvLTDQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hy355mcMcCnEYsabWRSJPrkkIvYUlJmCk6omDzbX0Q6rnGNOE998pVLz5A9LkkSzmtKoYRglxMiohD5nwQoGcg0rXfup5al4kdNf82HwvZ887NFKYvabGcoqBx9sGpSoNA8NcFjwYVXeMzxNLwQXd3D01xUplngJMnWaSrDP1/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KrICQ4qp; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KrICQ4qp"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0879957a99so418192276.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038126; x=1722642926; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4pm2gWEOx5QJNc32HyFmIStymfHzlyUTPI/gy9LPzsU=;
        b=KrICQ4qpv3xXhxx5DCa8FVrdpw33enm+6ZpEmXALQwwr7pbGp6pCV+kC98CUCYYDZ8
         gDzotqVS5MeeF0oRQbKEtpif2w+q896e4V/ZW6cckfHU/OdeVlx6Acnk+smzPuDlbRCW
         F5Qaf3k6EwzGGqOntXlnn2rhvNtVBsi6see6uAFSU6PbMffYV23K6YpJjot91iKKtjWn
         PAv+T+d0im95rVpXaNFtth5Z6WkSBF/5HISXtgwls5TCOspyfz9+IL8+u4NZJ6fQ/Zlq
         NGgKi5l/1ZH5MOCbocexrtpFSnOel079eQ4vvuq3TsgYT9PvQaTSNOtRhmLVlsoW2KwO
         tXJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038126; x=1722642926;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4pm2gWEOx5QJNc32HyFmIStymfHzlyUTPI/gy9LPzsU=;
        b=W+eWunRXZIDufTV2LT9X58efBav1F7WalTFDyxXTp8Okf9B/yhUwlxKz1OpBSBzQVD
         UgwOhzP31fnXC9/kfnWg1Ic+ByVC6aP+6lj7KtgZMncbdfECfQuKFHXNDmuGNQz64b91
         c7nGFxXuBXFFrdLQlZ+xaObQWYUD0Zb2zm7An34xNBZsj9g4yNtvCRnF0xMUAvvFIXW2
         gPgHdv8Lt6fp2rTYdSpHWZrpnblNvR5RkjWvvSfdRnD03P55y32Gmy0fGwRHnwgqESn2
         yfYkc/nZryGHks50gct7hhX5EWOys0DyUTybUv9DAjm2YHY4rzKGzP21x45oa+Yw/9CD
         tVTw==
X-Forwarded-Encrypted: i=1; AJvYcCVv+I+coziC6a4uGvPAkzd1xqqKOqvWu3uQ4nv4tnVt2NDZ6L5ioxU/WVmQTSQkiido+uYDiyNfdfxXC3pNWlEvQwcjAso6
X-Gm-Message-State: AOJu0YxYFTq7+pya+iRix2idfx/7nK4AFmtXxPWHRjluDkx7ULz2CMh1
	DVGY9tASga10cd8DohAIikDLj5ICiom4GXgEx3CC9CjXw2RuXo6TUuRem+hvYE4XWQHzk1rA34z
	9Gg==
X-Google-Smtp-Source: AGHT+IGgyahrOCg0Ix+MrKo8QCm20LiC8Zd9dP6asKSX3o/8So/b0NT46HfwZKTclpC/RfFjW09NkNDMj3A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1029:b0:e0b:9b5:8647 with SMTP id
 3f1490d57ef6-e0b544ec4ddmr2334276.8.1722038125883; Fri, 26 Jul 2024 16:55:25
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:30 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-82-seanjc@google.com>
Subject: [PATCH v12 81/84] KVM: x86/mmu: Don't mark "struct page" accessed
 when zapping SPTEs
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

Don't mark pages/folios as accessed in the primary MMU when zapping SPTEs,
as doing so relies on kvm_pfn_to_refcounted_page(), and generally speaking
is unnecessary and wasteful.  KVM participates in page aging via
mmu_notifiers, so there's no need to push "accessed" updates to the
primary MMU.

And if KVM zaps a SPTe in response to an mmu_notifier, marking it accessed
_after_ the primary MMU has decided to zap the page is likely to go
unnoticed, i.e. odds are good that, if the page is being zapped for
reclaim, the page will be swapped out regardless of whether or not KVM
marks the page accessed.

Dropping x86's use of kvm_set_pfn_accessed() also paves the way for
removing kvm_pfn_to_refcounted_page() and all its users.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 17 -----------------
 arch/x86/kvm/mmu/tdp_mmu.c |  3 ---
 2 files changed, 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2a0cfa225c8d..5979eeb916cd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -546,10 +546,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  */
 static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 {
-	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
 	int level = sptep_to_sp(sptep)->role.level;
-	struct page *page;
 
 	if (!is_shadow_present_pte(old_spte) ||
 	    !spte_has_volatile_bits(old_spte))
@@ -561,21 +559,6 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 		return old_spte;
 
 	kvm_update_page_stats(kvm, level, -1);
-
-	pfn = spte_to_pfn(old_spte);
-
-	/*
-	 * KVM doesn't hold a reference to any pages mapped into the guest, and
-	 * instead uses the mmu_notifier to ensure that KVM unmaps any pages
-	 * before they are reclaimed.  Sanity check that, if the pfn is backed
-	 * by a refcounted page, the refcount is elevated.
-	 */
-	page = kvm_pfn_to_refcounted_page(pfn);
-	WARN_ON_ONCE(page && !page_count(page));
-
-	if (is_accessed_spte(old_spte))
-		kvm_set_pfn_accessed(pfn);
-
 	return old_spte;
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d1de5f28c445..dc153cf92a40 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -861,9 +861,6 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 
-		if (is_accessed_spte(iter.old_spte))
-			kvm_set_pfn_accessed(spte_to_pfn(iter.old_spte));
-
 		/*
 		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
 		 * see kvm_tdp_mmu_zap_invalidated_roots() for details.
-- 
2.46.0.rc1.232.g9752f9e123-goog

