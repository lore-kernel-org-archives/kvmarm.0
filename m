Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C56D1E909A
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584718; cv=none; b=pd1KlHPpAB7f9nZ2LomGAFjkuRGjXDu1LK2SoXI178rUox3yNEsfbrnudQSAIodd8HHfup/KCucbCsU9nP9O4j+K0SSCEoa1wbCJgijA8TKvjzfiqnlsRloXk7UX545P8M6cqGk7YM4XT1UJ/rNRpbxyO2F28NDWOU5zYP+XKmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584718; c=relaxed/simple;
	bh=bXBvqUXIo6rFfz7xJp3m3CL9RbZG3WivseimjKRiNcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fk0SCoUi1jnvEh9LNTGHD2Zvy2/juqq0o5piLwDCKmmwOPcivMAJYf7X3q3MbhLzPAkIOs8EKhs9bZnBPwmTcuhBxg48kjduSasoLGNwEVdcx/+KZGDJtc4vYNO3ziXs3AA/mCNVFaPQRCVzbG3uhRWSrguH2VRNhVUJcy7cy3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q/po81Do; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q/po81Do"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-206b912491eso23149755ad.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584715; x=1729189515; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDoARMTIexYqUKDMQLAC2OQWFTeknat7PpvqQx990/M=;
        b=q/po81DomIf2j+I8KEA8xtCcA40kkwH4lUL4O4oDsF8aLrDc7htyFvajkI/6GBCFQ6
         tWprbt7UDPIVqv1Z7UsF9gW7By9xSItF2XKFUqtH2rztcPS1ELM+d+u0ktSF9ZT2KwHb
         NL5FDPmMqYRWsoYQHFesYkuS4h/g5LSDOZKdVilb4m1Se9AEOY9QH8cGvi8K8XbtkSGw
         4XIU+s8JnqzK9Dcr8IbzaQanbQG0KHl9RN1K4s0iY5EUoYsCPL97mAjcUlv4LzJuWify
         65wwEMEMyls1wVEI65+HDlynfeFSDHX9BLBbqaGQd9vNQhUoLdVhPyoYtIFhGHjbKQgY
         5tcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584715; x=1729189515;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WDoARMTIexYqUKDMQLAC2OQWFTeknat7PpvqQx990/M=;
        b=U95V27v/nPnIhGIdauXaTJXgS6AtbPZr2whm56lW31a+p3+2wNEEojq3tfb7iEZypv
         NX+WTUpxUiQWyRjlEM2bg5GhE4Uuvf20q8DbocBSHten2yhCpxm62wMl7iMLjYbO+zhB
         t7B6QYS8fIg2jt4nMsMuAzd+zkEbqsz9OcRuwPkC800ky7mEGSFpRlOse/4yYuKW2677
         eIhmoyli8jR0we6rBNjll6albn8J6BDK+6WniKvIPmu9/hz7ja99suqNpWq0kycVFbJA
         t3Qe6Ck95hBUxGgLUjcvLsyb/VQ+4/sfZsoBEXJuicZn1iKznIBSi/tJ922qhUoIEUrM
         K3YA==
X-Forwarded-Encrypted: i=1; AJvYcCUl0zgU2PeINKncpTqzBnIundtXTf7vMJCkPx/34cbVQ/AoYI8RgyvjM/y6oM+YBJSlmjr5ZYQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxr6FAbKYDuj1gBDakLGFlnoAq8TwIqEGKmweuq7P9JRGsd7WwB
	DwefJ400WwvLkwZblG+biyadLpwzSYru6HmEt4MzEMN3bmxQmimFMzlxK3RZzOmLcqq1YLznQAY
	y4A==
X-Google-Smtp-Source: AGHT+IFdLsiMiQR9ssEjYgvfJ+TOiOlvv8h202qp7bAbI4MCMFrC9IRsz+IufRcGyfoerq3Ms7MkoMKw8Uo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:f143:b0:20c:5beb:9c6a with SMTP id
 d9443c01a7336-20c80510505mr43225ad.4.1728584715291; Thu, 10 Oct 2024 11:25:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:13 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-12-seanjc@google.com>
Subject: [PATCH v13 11/85] KVM: Rename gfn_to_page_many_atomic() to kvm_prefetch_pages()
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

Rename gfn_to_page_many_atomic() to kvm_prefetch_pages() to try and
communicate its true purpose, as the "atomic" aspect is essentially a
side effect of the fact that x86 uses the API while holding mmu_lock.
E.g. even if mmu_lock weren't held, KVM wouldn't want to fault-in pages,
as the goal is to opportunistically grab surrounding pages that have
already been accessed and/or dirtied by the host, and to do so quickly.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 include/linux/kvm_host.h       | 4 ++--
 virt/kvm/kvm_main.c            | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 04228a7da69a..5fe45ab0e818 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2958,7 +2958,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *=
vcpu,
 	if (!slot)
 		return -1;
=20
-	ret =3D gfn_to_page_many_atomic(slot, gfn, pages, end - start);
+	ret =3D kvm_prefetch_pages(slot, gfn, pages, end - start);
 	if (ret <=3D 0)
 		return -1;
=20
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.=
h
index 36b2607280f0..143b7e9f26dc 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -549,7 +549,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_=
mmu_page *sp,
 	if (!slot)
 		return false;
=20
-	if (gfn_to_page_many_atomic(slot, gfn, &page, 1) !=3D 1)
+	if (kvm_prefetch_pages(slot, gfn, &page, 1) !=3D 1)
 		return false;
=20
 	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, page_to_pfn(page), NULL);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab4485b2bddc..56e7cde8c8b8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1207,8 +1207,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
=20
-int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			    struct page **pages, int nr_pages);
+int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
+		       struct page **pages, int nr_pages);
=20
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2032292df0b0..957b4a6c9254 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3053,8 +3053,8 @@ kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, =
gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
=20
-int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
-			    struct page **pages, int nr_pages)
+int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
+		       struct page **pages, int nr_pages)
 {
 	unsigned long addr;
 	gfn_t entry =3D 0;
@@ -3068,7 +3068,7 @@ int gfn_to_page_many_atomic(struct kvm_memory_slot *s=
lot, gfn_t gfn,
=20
 	return get_user_pages_fast_only(addr, nr_pages, FOLL_WRITE, pages);
 }
-EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
+EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
=20
 /*
  * Do not use this helper unless you are absolutely certain the gfn _must_=
 be
--=20
2.47.0.rc1.288.g06298d1525-goog

