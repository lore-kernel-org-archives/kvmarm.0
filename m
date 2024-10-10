Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA741CEADC
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584694; cv=none; b=ak01PRLh71N7cmC8yN8PZzuyrRuDRhAvZ/1WIBIPDBYOi6upRaMXJuQ6eU7mRvjsFm1CqG7GL8tn2i6icq8/f0nHEyaBG04rxRfpux9MZH/B7rSuoVo9ApXQGJvGooocpe02QBn0Q65B30zCMN6kbGMEOnziU/KxcK0p5CC/aCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584694; c=relaxed/simple;
	bh=VeqAt9xsRyQYjwTyqnYEHFfSJqQO2zWoId1ssBiaEMk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kSje79zMQFCPB2r2sJiqpyg97p1BIYfHR7+t0eqhEJ2uHpVoh/iRHufwpr51CbMrXjzEDOfsddyhNY4d13EYPLBGG4aiNwqj7gqX3VobGvJJUwhNZiXEKFb3oozfkW4q9lqn2tNJGkHCCgP/mikiAmDHg+/uc6jpkIyS46gsrrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QlG0I/XN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QlG0I/XN"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2ebab7abfso157718a91.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584691; x=1729189491; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Om/x5O1cFoCu45xFQlZl7muX4OGvvwFhFfu/OqGssvQ=;
        b=QlG0I/XN4EvXbG2a0m7H12TaQM7e2QhXYXT47hD8NB2S87WgNsQ0AEn9GcVY3F2S8v
         TV3CIpSn1yqcNOins6XIAxS3pPGwKkPJkJfeku1gNNuvn9Xbv9tFonKsxjVa1LIbRJCH
         4HSW8EKj1B8dcA7EWOAXZrqK/OF3Rd19DRRoF4/WgANpZT4VcQR94QLUPcmZD//HPdMf
         iO80HmG1NBaWiuMIrjPkJjIMe+YS+feC5t699moBJz5OZeYQm10YJSgH0iuGtkp1K4UV
         nYps7Qr4RBMeqmIAr6o3machW0yzPkcN5L1J72nGb+2kQG5PaBJA1HrVnCKoXI4huk7l
         5u+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584691; x=1729189491;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Om/x5O1cFoCu45xFQlZl7muX4OGvvwFhFfu/OqGssvQ=;
        b=dK0SdgV7vDEOIZLItrh311B6/saSCHGi9WD59Z6LneBkJKBy8WyKnjTv2yuMno1Tm4
         4d2pNF3k/hAj0NKsOIYdgO1U/n2vg7x4VFG+iRUPtZYyd8JDCOhlYrvP/w7DimyqVSD3
         1ef/vzsfXn2Bu3bZ2oB/7cAo2Hb6RVjd2RYwYZ+UiFpEqiYL9KLNbzGGkMQhupVmX2VR
         zH2e9AWWXwUlftBKh1PyFa2Ai9RsMZn/rIJTzTVY89GHzehnJxzxCruKEnVINV0pbKq/
         MZ9cpmETV9iDKDHL9Aul3Cst95suAw3j0pq5h5ZbGUxWSOXFjUkziQuD2P2e4QUBZTtR
         kvpw==
X-Forwarded-Encrypted: i=1; AJvYcCX61mN564ie1ux0TOIgMi1nyuh+dDz4D95g3Mo+sgie7/nTOZYF1AJeqV1ug2UBcg20mnzNKpQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfmvOuN6TU/+VF8yyjFxe7/Hb6I1Z6lRvLruhgFUAtVRLRYSHX
	mJjlI8GsDY6ToWvKgpPAKQhV4zqBmquMtphNZn52FxVPndwg3877eAcFD0PcHqYHmkQBNHRIJFS
	vWQ==
X-Google-Smtp-Source: AGHT+IG89v4lIFRhnNqxe9hFvIIxqDvldHGwH//6ib2L4odxYyk8SJA2JGOjXIHuxBeh8ylp7HgA6abaBbM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:eac4:b0:2e2:8f4d:457 with SMTP id
 98e67ed59e1d1-2e2c80b5015mr7266a91.2.1728584689990; Thu, 10 Oct 2024 11:24:49
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:03 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-2-seanjc@google.com>
Subject: [PATCH v13 01/85] KVM: Drop KVM_ERR_PTR_BAD_PAGE and instead return
 NULL to indicate an error
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

Remove KVM_ERR_PTR_BAD_PAGE and instead return NULL, as "bad page" is just
a leftover bit of weirdness from days of old when KVM stuffed a "bad" page
into the guest instead of actually handling missing pages.  See commit
cea7bb21280e ("KVM: MMU: Make gfn_to_page() always safe").

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_pr.c          |  2 +-
 arch/powerpc/kvm/book3s_xive_native.c |  2 +-
 arch/s390/kvm/vsie.c                  |  2 +-
 arch/x86/kvm/lapic.c                  |  2 +-
 include/linux/kvm_host.h              |  7 -------
 virt/kvm/kvm_main.c                   | 15 ++++++---------
 6 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 7b8ae509328f..d7721297b9b6 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -645,7 +645,7 @@ static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, st=
ruct kvmppc_pte *pte)
 	int i;
=20
 	hpage =3D gfn_to_page(vcpu->kvm, pte->raddr >> PAGE_SHIFT);
-	if (is_error_page(hpage))
+	if (!hpage)
 		return;
=20
 	hpage_offset =3D pte->raddr & ~PAGE_MASK;
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3=
s_xive_native.c
index 6e2ebbd8aaac..d9bf1bc3ff61 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -654,7 +654,7 @@ static int kvmppc_xive_native_set_queue_config(struct k=
vmppc_xive *xive,
 	}
=20
 	page =3D gfn_to_page(kvm, gfn);
-	if (is_error_page(page)) {
+	if (!page) {
 		srcu_read_unlock(&kvm->srcu, srcu_idx);
 		pr_err("Couldn't get queue page %llx!\n", kvm_eq.qaddr);
 		return -EINVAL;
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 89cafea4c41f..763a070f5955 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -661,7 +661,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, h=
pa_t *hpa)
 	struct page *page;
=20
 	page =3D gfn_to_page(kvm, gpa_to_gfn(gpa));
-	if (is_error_page(page))
+	if (!page)
 		return -EINVAL;
 	*hpa =3D (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
 	return 0;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2098dc689088..20526e4d6c62 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2664,7 +2664,7 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 	}
=20
 	page =3D gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (is_error_page(page)) {
+	if (!page) {
 		ret =3D -EFAULT;
 		goto out;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index db567d26f7b9..ee186a1fbaad 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -153,13 +153,6 @@ static inline bool kvm_is_error_gpa(gpa_t gpa)
 	return gpa =3D=3D INVALID_GPA;
 }
=20
-#define KVM_ERR_PTR_BAD_PAGE	(ERR_PTR(-ENOENT))
-
-static inline bool is_error_page(struct page *page)
-{
-	return IS_ERR(page);
-}
-
 #define KVM_REQUEST_MASK           GENMASK(7,0)
 #define KVM_REQUEST_NO_WAKEUP      BIT(8)
 #define KVM_REQUEST_WAIT           BIT(9)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 05cbb2548d99..4b659a649dfa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3078,19 +3078,14 @@ EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
  */
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
-	struct page *page;
 	kvm_pfn_t pfn;
=20
 	pfn =3D gfn_to_pfn(kvm, gfn);
=20
 	if (is_error_noslot_pfn(pfn))
-		return KVM_ERR_PTR_BAD_PAGE;
+		return NULL;
=20
-	page =3D kvm_pfn_to_refcounted_page(pfn);
-	if (!page)
-		return KVM_ERR_PTR_BAD_PAGE;
-
-	return page;
+	return kvm_pfn_to_refcounted_page(pfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
=20
@@ -3184,7 +3179,8 @@ static void kvm_set_page_accessed(struct page *page)
=20
 void kvm_release_page_clean(struct page *page)
 {
-	WARN_ON(is_error_page(page));
+	if (WARN_ON(!page))
+		return;
=20
 	kvm_set_page_accessed(page);
 	put_page(page);
@@ -3208,7 +3204,8 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
=20
 void kvm_release_page_dirty(struct page *page)
 {
-	WARN_ON(is_error_page(page));
+	if (WARN_ON(!page))
+		return;
=20
 	kvm_set_page_dirty(page);
 	kvm_release_page_clean(page);
--=20
2.47.0.rc1.288.g06298d1525-goog

