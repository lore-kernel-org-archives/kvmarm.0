Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAA221C16F
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584872; cv=none; b=ZoGHAvzNvF6eSQsK2fjjXOiO5rfzmJ6Ell7cd3rYp9kmasUqFgNMDx3Ez+4yT/roPKV9GhEE7j0OxJ3t7jhKBNqUo8A+cwt9BEpTG/NMLHXSCB6T0ZHXcbJbYdJfAsC+V4MoNNxsLxBnHiFddn0dvFKKDVh/bfz6FhmsVl2jr/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584872; c=relaxed/simple;
	bh=9yDh4yVl+Y5ECwKMlXFEDQ/uzUa/qYgKcVRj3mqEjek=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KnZHH8JiEXv2ODXclSpi/Je/879cpQf1AVuFkiZk1aobzNLzL4bKl1gRXQJHVtNEz+T0UWhny9o4kI+46fMlEwt0rszd2rM+Mb246EEkVVRi9Lyyy2w0+UvJwZfFOwl+s4J8FO0QTFF+UYV8/BWzfqJT3lB2/GnXogFnHhh6J+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VqvFtxQv; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VqvFtxQv"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e1fbe2a6b1so23313687b3.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584870; x=1729189670; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BeNSr3VxopvO4QfIOfKviYSPGRm8vVX1K3YR0sLhejo=;
        b=VqvFtxQvW12nMf3hTgeF8G60YySqfT6ElzII0lz+9VrMWk2y+IdUW490nntbEvWNdT
         hu4lpZkv2Ap5OgoD3NzLIKCRA/K3oxbV1RFAXZspfHugE0U74uhsCqutOf/H+TZ9HlPx
         6oVHNEujp8K9fkzm+m+ZDr5pIrY/moIne7aAAY3cAl/G9MqHb1P8IEDLmyx5+7TYPWC5
         Cbql4g0BOetQe/jo7hafYRGBL8WxGS5eSc9FrHOw/6w84KpcmgELIWN+MXP4hKQG9R7b
         gBtn4EokIH0G6d482B+qVxTEIOVaBg10miQirXvbQLFkxnn+KI0BxgbjvzsjGHj1zX4I
         KZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584870; x=1729189670;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BeNSr3VxopvO4QfIOfKviYSPGRm8vVX1K3YR0sLhejo=;
        b=HePLDkeSljo37iozr3f6c+TxdqRkth4Pn2ukOhf/LLsOYXkKySt62/iasXlNIGOAEx
         hA4zxFWlYvbx8JQ+rYHNdZi+KNXTYWo0qxv/aC0MuV1G0sFWdbEJc0FcLBKJ77hJDxiE
         BXREk4J3MPWKCz7XVHaPpgP834daZ12zCtIvaLA2r8q1TymLhKxf3LlJRSOKtb5T7Zr2
         Bg3UqC2BWOcbV2xftXmVEv4HJeOet65WMEP7BVDdm3cfJqucsoXBDIrN1Dl/nPDheK2U
         2aC5LGJWcCTX2gwBVzZaKxuk3p5v7ABCj5S61TxMxReBQyXaW4rjVksfu/5dXC93V1/2
         Dt7A==
X-Forwarded-Encrypted: i=1; AJvYcCWidVLzWh5nd8ZgFncJJV+u/8aM9JLQSXoZiWK3ml0IAXJAQ1mmuqtQYcE3hYNNK2lQDvI2M1o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQcCO18OMyeZbhymjJ4c8bOzk/Sa1cjaVhxIIw1qlssFZLIKAf
	+ckYDyubuoavHSsLr7g5EzH5Y++g5xIogzXKJLyoFvAqdJjKSwfD497b2ixw2Em7RLvudyOS1hz
	K2Q==
X-Google-Smtp-Source: AGHT+IHhmEpfdjhYs/g96WpbaMl3fao5EtfU192MAf3yyGbJNoRiDL4cTPbNYR1fq37SA+x5liddjIzSKiU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2e86:b0:6dd:bcce:7cd4 with SMTP id
 00721157ae682-6e3221404ddmr516647b3.2.1728584870148; Thu, 10 Oct 2024
 11:27:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:26 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-85-seanjc@google.com>
Subject: [PATCH v13 84/85] KVM: Drop APIs that manipulate "struct page" via pfns
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

Remove all kvm_{release,set}_pfn_*() APIs now that all users are gone.

No functional change intended.

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  5 ----
 virt/kvm/kvm_main.c      | 55 ----------------------------------------
 2 files changed, 60 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4a1eaa40a215..d045f8310a48 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1274,11 +1274,6 @@ static inline kvm_pfn_t kvm_faultin_pfn(struct kvm_v=
cpu *vcpu, gfn_t gfn,
 				 write ? FOLL_WRITE : 0, writable, refcounted_page);
 }
=20
-void kvm_release_pfn_clean(kvm_pfn_t pfn);
-void kvm_release_pfn_dirty(kvm_pfn_t pfn);
-void kvm_set_pfn_dirty(kvm_pfn_t pfn);
-void kvm_set_pfn_accessed(kvm_pfn_t pfn);
-
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset=
,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long l=
en);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a483da96f4be..396ca14f18f3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3164,61 +3164,6 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kv=
m_host_map *map)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
=20
-void kvm_release_pfn_clean(kvm_pfn_t pfn)
-{
-	struct page *page;
-
-	if (is_error_noslot_pfn(pfn))
-		return;
-
-	page =3D kvm_pfn_to_refcounted_page(pfn);
-	if (!page)
-		return;
-
-	kvm_release_page_clean(page);
-}
-EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
-
-void kvm_release_pfn_dirty(kvm_pfn_t pfn)
-{
-	struct page *page;
-
-	if (is_error_noslot_pfn(pfn))
-		return;
-
-	page =3D kvm_pfn_to_refcounted_page(pfn);
-	if (!page)
-		return;
-
-	kvm_release_page_dirty(page);
-}
-EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
-
-/*
- * Note, checking for an error/noslot pfn is the caller's responsibility w=
hen
- * directly marking a page dirty/accessed.  Unlike the "release" helpers, =
the
- * "set" helpers are not to be used when the pfn might point at garbage.
- */
-void kvm_set_pfn_dirty(kvm_pfn_t pfn)
-{
-	if (WARN_ON(is_error_noslot_pfn(pfn)))
-		return;
-
-	if (pfn_valid(pfn))
-		kvm_set_page_dirty(pfn_to_page(pfn));
-}
-EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
-
-void kvm_set_pfn_accessed(kvm_pfn_t pfn)
-{
-	if (WARN_ON(is_error_noslot_pfn(pfn)))
-		return;
-
-	if (pfn_valid(pfn))
-		kvm_set_page_accessed(pfn_to_page(pfn));
-}
-EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
-
 static int next_segment(unsigned long len, int offset)
 {
 	if (len > PAGE_SIZE - offset)
--=20
2.47.0.rc1.288.g06298d1525-goog

