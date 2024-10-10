Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D211EF935
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584726; cv=none; b=Z/mDegedr6UJL13vTI8MZ9ub4B7WgqhuWjQyw8ves2UYSE+ZPPu1W+IBFzLOy7OYdufD5aLvOmfedfx7eKRWIBEsP5ZnExtWdQcs0sDRkXydtGnyi2i/LSXm36GGC1SKslQ999Smczmr7CGp96mGuy0joyZbIzODm8LNxfk7X4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584726; c=relaxed/simple;
	bh=xKxLUn1wM/pJucT4/ZxvVNmNhzhyHMbiLj3YVf1FNHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hIF4vwXmjczPA+1dll0kHaeh5kgazP1q6uL3i5pTc0MzEgKw6quKNj9hT3KWnJ6Z6zrQGfRxL9FMEEMJqtGz1nBJWStdRnb39ECFAqVQKEtm84uIvXkT2bTvuAMnUi6SAARTMNPmYukZuOsQi+M3wcGT/d+dZmqE6+a9QFRjMjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WnEEChNM; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WnEEChNM"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e2d287f944so24066027b3.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584724; x=1729189524; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=86tNdlyX8HXR/WHFYCj/131p34DPDBwWgQrhOuSjETM=;
        b=WnEEChNML0i+2Pm79LHDzrObFzzujV1aFChHlRR6Dl3iJtmmxx1q0swB/KK/GtOUeA
         sayy0+jVrkqAPLtg9p67snN9cVO4OCg2P8b/qv2sQZiTxVnV/xJg3HaRRJO8S5rmf8z4
         guS4mjYDPdmdSfVCKzQIe88IVEWWZaHO8+m3PDd/ZjU/J8RgV6bWwObAtwO+PcU5anlX
         ByNMygCRxOJHTK5UuKJbzOyqv/q1n6QuJoGJ4ZPeAtFJ+CZ1xJQ/+bHn3kGcazXZXirx
         vM7LMnLV6VEYZpHXIiGK8eQEpi21teybwlx24aDcNYRVWLj4i4GZze+rQoFSXvlisiwb
         mubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584724; x=1729189524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=86tNdlyX8HXR/WHFYCj/131p34DPDBwWgQrhOuSjETM=;
        b=rzBU8S9RxTtk11pPOQ6QD5whxWBNs3K4qmEwSR9SFBQcpDC7jKkUPMLtAgxPfobeB8
         gNLzg1SQlbVk9VYtLjxi780BX2A6zEHWa1K6v1W28tpY1lwldCjkK2A4NyTLlLNu4Xmt
         TUzcZEJ466eptnXjlE7a6ZZKsFXqOgD3uZhSmZ3JkX3oCvS/jkWiPedg0Qb7EXQRyK0D
         rqNbq6syDzPsXm84dgV1uYxL+NVDarC+9ylhK0Un4k6WGEHjj3aWXRinuKXan4BLAHcr
         WCvxGkJlgr04TaMJQtzObeXLFS87NVR437k6HuDQk3WT7GE1yIn9uFPU26L4r2IhBX+A
         Vkig==
X-Forwarded-Encrypted: i=1; AJvYcCV6Y1iagYTSGQqjPqu1whgDs2iTR8/ar0GcRUdNEYrfQrWEYR8um2fMya5+sKDeLWSIxM8fIws=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSU+W8U9uKg6SPUrARiKhmkmqHKa95xt98WSIj374RMSB4PARv
	aP0C9ewCRiAWfNMg0w7uci6ioGc0nHKr92VKZl3xZqgtrUPkHwnks8NANyRZJiCS8OfVZu+0QPR
	rOw==
X-Google-Smtp-Source: AGHT+IGf82b/hxj2IWFe54/TAnEDS4XyhakmYGUWxryxrCLTzb83+cUU5J1DZhSXbLBNZQvipdjBbhmVkR8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:8e09:0:b0:e28:ef25:5f13 with SMTP id
 3f1490d57ef6-e28fe0e7352mr200743276.0.1728584723790; Thu, 10 Oct 2024
 11:25:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:17 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-16-seanjc@google.com>
Subject: [PATCH v13 15/85] KVM: Drop extra GUP (via check_user_page_hwpoison())
 to detect poisoned page
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

Remove check_user_page_hwpoison() as it's effectively dead code.  Prior to
commit 234b239bea39 ("kvm: Faults which trigger IO release the mmap_sem"),
hva_to_pfn_slow() wasn't actually a slow path in all cases, i.e. would do
get_user_pages_fast() without ever doing slow GUP with FOLL_HWPOISON.

Now that hva_to_pfn_slow() is a straight shot to get_user_pages_unlocked(),
and unconditionally passes FOLL_HWPOISON, it is impossible for hva_to_pfn()
to get an -errno that needs to be morphed to -EHWPOISON.

There are essentially four cases in KVM:

  - npages == 0, then FOLL_NOWAIT, a.k.a. @async, must be true, and thus
    check_user_page_hwpoison() will not be called
  - npages == 1 || npages == -EHWPOISON, all good
  - npages == -EINTR || npages == -EAGAIN, bail early, all good
  - everything else, including -EFAULT, can go down the vma_lookup() path,
    as npages < 0 means KVM went through hva_to_pfn_slow() which passes
    FOLL_HWPOISON

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ebba5d22db2d..87f81e74cbc0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2746,14 +2746,6 @@ unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *w
 	return gfn_to_hva_memslot_prot(slot, gfn, writable);
 }
 
-static inline int check_user_page_hwpoison(unsigned long addr)
-{
-	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
-
-	rc = get_user_pages(addr, 1, flags, NULL);
-	return rc == -EHWPOISON;
-}
-
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.
@@ -2948,14 +2940,10 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
 		return pfn;
 	if (npages == -EINTR || npages == -EAGAIN)
 		return KVM_PFN_ERR_SIGPENDING;
+	if (npages == -EHWPOISON)
+		return KVM_PFN_ERR_HWPOISON;
 
 	mmap_read_lock(current->mm);
-	if (npages == -EHWPOISON ||
-	      (!async && check_user_page_hwpoison(addr))) {
-		pfn = KVM_PFN_ERR_HWPOISON;
-		goto exit;
-	}
-
 retry:
 	vma = vma_lookup(current->mm, addr);
 
@@ -2972,7 +2960,6 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
 			*async = true;
 		pfn = KVM_PFN_ERR_FAULT;
 	}
-exit:
 	mmap_read_unlock(current->mm);
 	return pfn;
 }
-- 
2.47.0.rc1.288.g06298d1525-goog

