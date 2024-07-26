Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEA715B11F
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037980; cv=none; b=OeKQPskWeXM2VN7oC76XxEK2xubtzAAB1UfPAheoPAFp1UxVjmRNX8sUNVznwuZfKOyZYKfcrTzmV5hfSBVwB2S6MqRhvv2SEkWWgt2CpUIU8XGnMfSF/ExcXCsasHu2uJrRDfr1YX6PdVvDkLWcIGQQeq+d/R+wlx68PkIBZAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037980; c=relaxed/simple;
	bh=eYPpE7SnzshOjYhzmXkcsAp87ERqXcDPZzZJ9L8u3ZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CbCWT1aivE6RcBY9o9ysljWDQE1QNu7B0Yo7cjTzyaCr3LvdDD+VjahY+T9W4Ws0u20QCQdV0AZl4Y3gvuTeoVtefIzTQ70D2ZyqodvcGUINFhaTQbC2FGu5xXzuzATteFuQSxcEKtXvewXJP8vjdSTqVzrgW75YuxzoctI+NQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QD6gkmM1; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QD6gkmM1"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfa7a8147c3so389705276.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037978; x=1722642778; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=e1uaEfwlbucR9PkkwcUB/hlZrD43F2tYkTCYXf9cR5U=;
        b=QD6gkmM15zARXWGw9OmpXevfyA/9/Zs6/DnBP7B0DTcpFifQrkEtYKRgZ+IMV7I1iJ
         Dm/J6fvDVCUbFvFYvzT5oFrpTuMo3NpYyGczDjNaARiVlVsv/5dDKE6EuUyhwI8/hNkI
         beunzykb9IZG/1LzFSdGuyg18s3EMyEfREX6suA4tk31HW2vsDRQKu1DBtfZFnVU69bk
         sJNQQqiOeCLMT91+eBGOwIBIpCz5b5zWZwL8LIEmQUBqqhqDaWD/ry8p9t9/PGQPwURO
         GbZNRTXrPWiQyoxOmsP6ik4V15d0Gy56KBU6Qklk2jA/OzEAYap4p8Uhv0q7Aay82Nbs
         YNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037978; x=1722642778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1uaEfwlbucR9PkkwcUB/hlZrD43F2tYkTCYXf9cR5U=;
        b=qM69BtCEYPgb0n41AyVBvkMJL26GxfVUVlofQnuPDHVozODiXvtnCUK6hV2HT1EbKa
         wg0kxnlSqAFhwT9oYwnnb5soN4aRQVSe4ixIrFc/mroVsYWgNw//GTwrwiuhZG5L45MU
         S6bZszCh+Uz7PFWbM+qxhGLNiKQVh93tRRoGR75bfo2TArSeHzJxsW/Yl1raZvoD3vlU
         4ncGuaxp2xUDx7hHUnS3vFvWpR3Xi1RuwOiMnN2u1aWrbx9TnuLFae0qW2dmVmVWf+2z
         YZaYcK3tlw8ws+rc4bYA0hRc6mEH78dF8RQPR/jMj6I7XtZiYkV98dSUEoKa5gjoloVM
         E5WA==
X-Forwarded-Encrypted: i=1; AJvYcCWe/eAXzXCzeoXaN9XSAMsDJvj4E6sI9JicYShoxEXbicrYRyb3DHPucbd2TQg6CASoo4pGjiClPq34/Fvb2Q5gPB4zZAtn
X-Gm-Message-State: AOJu0Yy3rdBPRZmoBurzm6xsqVC9UFR3JuIYVMKDGRaC7VF//1NY1tmC
	WaUwXX8Tgum2JmY0LqY2IKkcjsCtnnhnt/x0Hw4nvonI1Sp8USZ2vGe1VLiQCBuU1DmnGTIo5Im
	Hgw==
X-Google-Smtp-Source: AGHT+IG4XdyN3FgjZWItv/Lgg5QEKJKUQifoplgps87wy/mf6q3lv4u9rcIn8zN490p0nZ8TWmWhP2C2xyU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1081:b0:e0b:1407:e357 with SMTP id
 3f1490d57ef6-e0b543f0dc9mr70203276.3.1722037977844; Fri, 26 Jul 2024 16:52:57
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:19 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-11-seanjc@google.com>
Subject: [PATCH v12 10/84] KVM: x86/mmu: Use gfn_to_page_many_atomic() when
 prefetching indirect PTEs
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

Use gfn_to_page_many_atomic() instead of gfn_to_pfn_memslot_atomic() when
prefetching indirect PTEs (direct_pte_prefetch_many() already uses the
"to page" APIS).  Functionally, the two are subtly equivalent, as the "to
pfn" API short-circuits hva_to_pfn() if hva_to_pfn_fast() fails, i.e. is
just a wrapper for get_user_page_fast_only()/get_user_pages_fast_only().

Switching to the "to page" API will allow dropping the @atomic parameter
from the entire hva_to_pfn() callchain.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ef0b3b213e5b..6b215a932158 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -535,8 +535,8 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 {
 	struct kvm_memory_slot *slot;
 	unsigned pte_access;
+	struct page *page;
 	gfn_t gfn;
-	kvm_pfn_t pfn;
 
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
@@ -549,12 +549,11 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (!slot)
 		return false;
 
-	pfn = gfn_to_pfn_memslot_atomic(slot, gfn);
-	if (is_error_pfn(pfn))
+	if (gfn_to_page_many_atomic(slot, gfn, &page, 1) != 1)
 		return false;
 
-	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, pfn, NULL);
-	kvm_release_pfn_clean(pfn);
+	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, page_to_pfn(page), NULL);
+	kvm_release_page_clean(page);
 	return true;
 }
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

