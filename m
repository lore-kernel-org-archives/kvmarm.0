Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7056615CD6E
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037982; cv=none; b=lqKqReZyoA51n8gUqU4ReStBNQQ328+TdYgYKUmgnj60WZwmoUR39Q+G2KCWRHPbZ2qNaRKfpyekfabTvGbRKiE+Ny8+YxXv4sCY0zsoo4TJq6im1zd8uY0+daDWK6isS/7o33E9Cr02T9SPk8wAl1AsZkln5NzD14Aon7I6fOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037982; c=relaxed/simple;
	bh=66rQYSeeqJfCAKMkX7WI4GHJ+JHcgyOho5Y4s7cGJ3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GlmgcP6suKBMzjptp0Bjm2vJeB9Xty1OxjxRKJ4yfeBajXeoGIbwlySXzzjaHZmcTMOSN/3DtS4Ug2f9hoYH5NqQjUetFE3htJGvyMmZX0Rbit+Oa818NCxUsAmx+1iqzCRNmZdYNDEKlrZiKMOjE8fszBRpbJ/Qk7pKdD0ouo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o+IHlZ6G; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o+IHlZ6G"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc6ac9a4aaso11370105ad.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037980; x=1722642780; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OCfqpOOOZn7LpwpHWWHUZjndC9uE6mObDYxnDRBBpAY=;
        b=o+IHlZ6GuyfxJtQGztPXIiOgsLKV1I5VPxdBYATcuj7ZxE2gqLUJOT6L3jmk3jpSZD
         1HqZHoF5PHI32SxmyZpNjaBHz2eKhOjGxX05Cb8pd9cd8IH7gqT892Z6SxWRmVe+hCiG
         mXtn249q0/AwJnf5lLeE6Fs2Qt4IcNFcOhIPZ1Wa9CLVI4bmk6cCKyUbmQc0KoYi8HX8
         KhoauyLjzx1v5hv8kLtJxT5qYIfSFBLEtizp8+kUzOL9IXAsSPNZwPAwhrGPl+iDAKFk
         7sRCN6ObBo1DMg1coJ6KLTQwQXgS7g91wdK6Myfymfiefqzp2nLbiVKqErUCORD7y9UN
         DaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037980; x=1722642780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OCfqpOOOZn7LpwpHWWHUZjndC9uE6mObDYxnDRBBpAY=;
        b=CyLI0gmH7hUhDw+Y4QOR+HmUx9IdMPNZ77k9499Q76muD3RLu3oSUBLi+9qbW3aLI3
         waUbGFsl9eLF6XlOeTdc/nLR9un/2h/xIS6AdP7rHN5VzrOXDGUpWjWSbN7Y9jVV9j3h
         Kenq4cp+cfdnhaJ+vKT1qGuBlAmxySLF7VXxEzzIC+hqpU4XenxHsNXxL+/cXKXmDUB4
         YNokGEC0o05mn0Kx+QmKUv/xB6bbVBX/il5RLmy30a44RpYUZ8IrzlwR9qZe3ZU609RZ
         p/wzc2lsHUjtyh0tXW+vlr1qNtaXJxbEznDcJ8p1xtVAntTZEfdKdCqPJo9mtF65D2aE
         WEgg==
X-Forwarded-Encrypted: i=1; AJvYcCVuayMY/4x5fY2m45ELyRvYBXNpsaBJG7cPEHrcDtl5Qjm5eTFfVqh3EyoyaajU/ygW9HGPARprYYzbRSuopjUmwaK5TC4f
X-Gm-Message-State: AOJu0YwMYB231VP37HRcWcf8NePRcvkuH8oirwyvJ3GLR4GjWqMZi77E
	tVnIW+Q6y/ZydqkZcg7c+PGhcwZCRTC7csFfYa5oGh7UXyA9H03pRN5n7tlmnZUAErDpqBUNwdF
	xGg==
X-Google-Smtp-Source: AGHT+IGEij7x5iOOrUuL0BYhT5Dm9YFKfO4AZ5nK1acS0T3wJ2KiuANG5aiKSF+tpPt4GoCINPA3jjFDrnM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2341:b0:1fd:d740:b1e5 with SMTP id
 d9443c01a7336-1ff04850898mr447825ad.6.1722037979718; Fri, 26 Jul 2024
 16:52:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:20 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-12-seanjc@google.com>
Subject: [PATCH v12 11/84] KVM: Rename gfn_to_page_many_atomic() to kvm_prefetch_pages()
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

Rename gfn_to_page_many_atomic() to kvm_prefetch_pages() to try and
communicate its true purpose, as the "atomic" aspect is essentially a
side effect of the fact that x86 uses the API while holding mmu_lock.
E.g. even if mmu_lock weren't held, KVM wouldn't want to fault-in pages,
as the goal is to opportunistically grab surrounding pages that have
already been accessed and/or dirtied by the host, and to do so quickly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 include/linux/kvm_host.h       | 4 ++--
 virt/kvm/kvm_main.c            | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b7642f1f993f..c1914f02c5e1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2912,7 +2912,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	if (!slot)
 		return -1;
 
-	ret = gfn_to_page_many_atomic(slot, gfn, pages, end - start);
+	ret = kvm_prefetch_pages(slot, gfn, pages, end - start);
 	if (ret <= 0)
 		return -1;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 6b215a932158..bc801d454f41 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -549,7 +549,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (!slot)
 		return false;
 
-	if (gfn_to_page_many_atomic(slot, gfn, &page, 1) != 1)
+	if (kvm_prefetch_pages(slot, gfn, &page, 1) != 1)
 		return false;
 
 	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, page_to_pfn(page), NULL);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c5d39a337aa3..79fed9fea638 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1192,8 +1192,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
 
-int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			    struct page **pages, int nr_pages);
+int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
+		       struct page **pages, int nr_pages);
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 656e931ac39e..803299778cf8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3060,8 +3060,8 @@ kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
 
-int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			    struct page **pages, int nr_pages)
+int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
+		       struct page **pages, int nr_pages)
 {
 	unsigned long addr;
 	gfn_t entry = 0;
@@ -3075,7 +3075,7 @@ int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 
 	return get_user_pages_fast_only(addr, nr_pages, FOLL_WRITE, pages);
 }
-EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
+EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
 
 /*
  * Do not use this helper unless you are absolutely certain the gfn _must_ be
-- 
2.46.0.rc1.232.g9752f9e123-goog

