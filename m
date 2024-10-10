Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B071E9062
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584715; cv=none; b=b2cSxF2FkI5AlNktn9dqVoIXKhp9AwOxQ7sZtvZ+UusGB+ngb3xFGFw8t5pXAPavhdZ2XdWNEaziZjLZlDYmt1BVZrB6zTLZjCe3s+6peegGzBRN+g5zZO7oHFdCATeRvIAKBYmIVhp3ji/vXT+KZw7oDC40n5C14fpF0TbBsYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584715; c=relaxed/simple;
	bh=FKY/uzFyW8/uk7MX2MD3fh26WMEEPHDBpnIM2/GXcs8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i7b2Ii3kgWz1+TdqGvBRHJGQSShkg2yEiZk9Bj3sQkEkruNYhcnkl+abc/ezSfajA2xNhPrzYN4Jyo24XgX4VltUsdV/YtfKtvuW2EO+S2uLjRxd4PvKo4Ny7wmxe3Viy0Tl8MWqL5EIV9FIDaQUkTrYTakcWNlT2QczPTShhe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RajnHFep; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RajnHFep"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e2d17b0e86so988043a91.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584713; x=1729189513; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k3/xcOX0JmpZSdxUAeDWhRU0v4mqVA9cM67JfDYoNsA=;
        b=RajnHFepB0W28VL75SGKGkRd42Lf8qdWmBZdC9500psyoBekMPRKnVhXhMb+qHdhny
         YIfPoeTafIJ9VjBkgZxQcdjfmg5Ltpmcd7bI0X5ayDqmYpSFxdG6YbhyBLHPVYmviQSY
         syECm5d3eu+oEexKXYKnZf+CiT5ZvFryLaCCnE0/LOZ5YuX26F4H+YJ8Wdjx8xC0Sckp
         ffcXKbsBEtnsWHZImjdRdVzWMhMnt8Urbk3kgLLAjKs89GcTrv7pG8UlE4ObCHQ1KqlN
         YdhMagB60PB1k/4puD7YZwy0IsfDV5tI32J0f8E+9MObEOaQ1x8Af55/T69gT9RbuWf8
         aadg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584713; x=1729189513;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k3/xcOX0JmpZSdxUAeDWhRU0v4mqVA9cM67JfDYoNsA=;
        b=PmDI1RV40GUXOToxW7N/eTsNNEZB5296UCsC11Lj6YR0//rGJMpOFeti/yW0JUdQSe
         YwhysG73ottXHA+tbyqFBCTPJG6jGIr0GUbshnMEI0IyQSL3CveK2Zi6CsgMx18mJcQ/
         Eulg5Gn5LteKbILigrc9Z3u7CB/OLT/n9DILkgF0rEN4vhu5Cf+zMgdyiBhdjwnGro++
         ak8Zi8zwQobebs9KJ3m8yRDTH1hfpRg/W3suW4mHZhtqmOj+zU+mObUMuZNS1Yr+qFhS
         euNa2vCDQOhFOu0XFn71yl3bp3afacspnmuZGvo5FuFRcBubIMbyiuo/Y1JO2Cj2kY8O
         JhuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZQgyChTqQuLsVvvTWyqx0EZeMfik8mWqlsVBsIFlpLL57DDjw6UITuj2mLLvLzv5xRz1POn4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyW47a18Blh0MPyBmzMQRgtszy4t46GvwOvNBPBri0f8xOPDL07
	7MhaM5g1GjBaBjRLYngfqxeZqSON+tKiqf9k68X/SOCZ+uHE15tL0c1+iGbYxuQNxUjeViFhq8a
	QQw==
X-Google-Smtp-Source: AGHT+IEzZdX7U43FtBqfYwOSCvhQrFRs7MoNj08p1am6l1FbD4QaVhgMc/3KfB78OlyTOzXtpjGPG3KIosU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ea0e:b0:2e2:d843:4880 with SMTP id
 98e67ed59e1d1-2e2f0c82a2fmr30a91.5.1728584713017; Thu, 10 Oct 2024 11:25:13
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:12 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-11-seanjc@google.com>
Subject: [PATCH v13 10/85] KVM: x86/mmu: Use gfn_to_page_many_atomic() when
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
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Use gfn_to_page_many_atomic() instead of gfn_to_pfn_memslot_atomic() when
prefetching indirect PTEs (direct_pte_prefetch_many() already uses the
"to page" APIS).  Functionally, the two are subtly equivalent, as the "to
pfn" API short-circuits hva_to_pfn() if hva_to_pfn_fast() fails, i.e. is
just a wrapper for get_user_page_fast_only()/get_user_pages_fast_only().

Switching to the "to page" API will allow dropping the @atomic parameter
from the entire hva_to_pfn() callchain.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.=
h
index fbaae040218b..36b2607280f0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -535,8 +535,8 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_=
mmu_page *sp,
 {
 	struct kvm_memory_slot *slot;
 	unsigned pte_access;
+	struct page *page;
 	gfn_t gfn;
-	kvm_pfn_t pfn;
=20
 	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
 		return false;
@@ -549,12 +549,11 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kv=
m_mmu_page *sp,
 	if (!slot)
 		return false;
=20
-	pfn =3D gfn_to_pfn_memslot_atomic(slot, gfn);
-	if (is_error_pfn(pfn))
+	if (gfn_to_page_many_atomic(slot, gfn, &page, 1) !=3D 1)
 		return false;
=20
-	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, pfn, NULL);
-	kvm_release_pfn_clean(pfn);
+	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, page_to_pfn(page), NULL);
+	kvm_release_page_clean(page);
 	return true;
 }
=20
--=20
2.47.0.rc1.288.g06298d1525-goog

