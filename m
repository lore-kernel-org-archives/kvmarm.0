Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A86721645A
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584853; cv=none; b=Rl+B4m27fwjYSUMf/1wgZash95jCK+H1JJ+n5uyAKvq+cKgV1QFkDXeyADw5wAa0wSJdgsdBHBiIdvHoXNyLx1qqKoVqZzMXT3Viea4i/YJUwuS3drHua1irw9t29Yaey25D9cw7f5QfQj6LjptNweCHMbEXBp5aCf26V8xdvUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584853; c=relaxed/simple;
	bh=6VFC6ZQ3q9XjUbMWhh1JwxOVsy5FNZVXQFKK9OKSZCE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=raM/Wy5zWfZPTi/8+lTWw+kYLGtT+usVoxdh4KoRyaNvu+OUQgYdDi56rbYRiHQpTwhmka+mEqi7D8j7cKiXYqLT1oMmK8dyjOzUpIlLOPcRZNtuQX8rP5b5YJrjdGNNgFN28Dhrxi7lYPHyzYQarT0+XC5fRxto4sEh3lDsZdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SYYPPSf+; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SYYPPSf+"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e0228d71dso1226091b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584852; x=1729189652; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZpnWf51XalE5JTpUzeqj9xBy85lPuBTlHLH/3crpzM=;
        b=SYYPPSf+y7KpVu0qPkDLVTrVbkN9LtRhLZyQhvGjGvwGhNO/3dQ7UDtI90kccJ8sS7
         08KaiD9WO4Ynp7MAKwl6ywgDJO0H33Wxqc0Ai42duHW776XShxyxS9mehZX3/8g2OrEC
         CAPIQn1VW7mhTS6b+RboxjHA1fFDtwXhAV9zWmN0h4F1SeeMtM6b2KCEQaMN1B9pBLyO
         ZqPzA773OcrVShOjAnygv1M2/4JhRygp7MlDYJIHWGlztHioqSiyRR1zadDwv+CToSpR
         Rh8hrZPCNumSTQOjcgQpbQBlCM5cXNLAE7k37K1hDQrti9xI/a4bqxRNeElN2LhW6YuJ
         3BrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584852; x=1729189652;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fZpnWf51XalE5JTpUzeqj9xBy85lPuBTlHLH/3crpzM=;
        b=LaNZc1PaFFjeIAG2QL59WkqOfktU4m0PB0/j0ke3+QPBdtlkPez0W4kBIhbFhchcZ4
         dtiT6Y5sUR//ul6xHFunsFQzBmhmf65lVqdfy0tQtqd/PwGMfB9oA4zvVHAYIk6lfBJa
         7YUJJdEP0R5xJUd85BGNfAQSx13T+VGNzDsVPjAiUYKPgARLzI06v7yzSVNvpKUoaAPX
         wpsXDQMV2cVElC8+TE4lstnAq8zl9edHEvQ1TvfVpVM6k5kMNXfV7AXVFGELbR9ffpn+
         +ncMbVYxt8sxtMHyRBTzTLdWtfA7faBN2OGv25pO6u0L3mJKrME8+5mJcAydiH8KlLRp
         fQig==
X-Forwarded-Encrypted: i=1; AJvYcCV+NuPyOwWjiWNwsPBERaBv0i9JSRV8sRu7wL4oQAGMTVrbWhVbbrr7HjBZRkSN/iWy1Ob3d3M=@lists.linux.dev
X-Gm-Message-State: AOJu0YznjvXJ0v+UuMew2grCkiD2cY96ajHqtrMOZNkpnbKxD6biIffW
	5k7M5nDQE4QNK4B9Hnx0JZrchF8jAU/s7glgL524bOXLmwUi975Qy5oKZkijRt5luG6d/CTTmWW
	vjQ==
X-Google-Smtp-Source: AGHT+IHVUYgAS8Gi1OfHaumBjOVs/68U//Xc3NGlK2wEye9l2w1SuCdDQ/WQfsMbBzqgGqsCESzcy3AUxv4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:aa7:93b4:0:b0:71d:f64d:712c with SMTP id
 d2e1a72fcca58-71e1db65a16mr7365b3a.1.1728584851459; Thu, 10 Oct 2024 11:27:31
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:17 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-76-seanjc@google.com>
Subject: [PATCH v13 75/85] KVM: Convert gfn_to_page() to use kvm_follow_pfn()
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

Convert gfn_to_page() to the new kvm_follow_pfn() internal API, which will
eventually allow removing gfn_to_pfn() and kvm_pfn_to_refcounted_page().

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 696d5e429b3e..1782242a4800 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3145,14 +3145,16 @@ EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
  */
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
-	kvm_pfn_t pfn;
+	struct page *refcounted_page =3D NULL;
+	struct kvm_follow_pfn kfp =3D {
+		.slot =3D gfn_to_memslot(kvm, gfn),
+		.gfn =3D gfn,
+		.flags =3D FOLL_WRITE,
+		.refcounted_page =3D &refcounted_page,
+	};
=20
-	pfn =3D gfn_to_pfn(kvm, gfn);
-
-	if (is_error_noslot_pfn(pfn))
-		return NULL;
-
-	return kvm_pfn_to_refcounted_page(pfn);
+	(void)kvm_follow_pfn(&kfp);
+	return refcounted_page;
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
=20
--=20
2.47.0.rc1.288.g06298d1525-goog

