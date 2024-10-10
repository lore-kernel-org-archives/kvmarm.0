Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399AF20605A
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584796; cv=none; b=cXOuVnzsi6rTGCsq+65XZpsAomAcC+dH8+V2z0uO+n5HL+DJFZ1EsFUl8JTxylYxrXDreKVwxQmGEmgSoU7WUZgZlcEEFrnDNerdIBe/8T3XT+zPg8oyU5UeBtb5vrEVmX92nKFLjQ4RGAzSSU6oBJGty9NvHjLxaZ5lD5BUYTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584796; c=relaxed/simple;
	bh=aOhxn0fpApYS19RFll+QfwBJLF7yF1QDDa2KZCpFRDw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RsU5S5YNwF12FoGxdndYHccUQBp09hiPMKSlFIb68BtFsjljlmg7wHnbUgMCz9w2UxE76IIyaabOot1Xez7U82VFB+D7nbuEvLP69I9gCYGI2138+sGP41wNeu0RgltqsO1ijHeArp6aTrN8mHWQ/nmFyn434yK9Waa9zi1gVqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j2o7jarV; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j2o7jarV"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e2b049b64aso20314357b3.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584794; x=1729189594; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BN+hsHae4h8wzhzshUJRGKM30XxzO0F311sC9z4rUGc=;
        b=j2o7jarVtvzjp0AT5RDwQJuJvwlBpxIS/FuwYJ7Dnyj9qOUYMFHSLDjv54l7/HeA2w
         e4wExH+0+9gCmPp1kH51uwz2qCOUBfUaMp7DdIsctPKqhXt/9TqBl34Rw5x2O/svCy7r
         H3NZ/J0lnoyAlmuwHl5y2dUDqzSjKEFLOLuHrnFSiNPtDkjTEc7mI/xxB0XPIPy7aZML
         r1M55xniB6e+4hqRbti/9oleVOzRB0RvM9Puj9EH8BzyyGwqyyxnejhh3XDFz2Lpvx4n
         N+rTONu5oBa96NPSo0UE7moCSY04saInnNzWkcWvff/BvjEBF621zSVsqbddpNYvgsfg
         O93w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584794; x=1729189594;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BN+hsHae4h8wzhzshUJRGKM30XxzO0F311sC9z4rUGc=;
        b=ViBZewKikiv3ZKD99hm8CJcL6ikxNxT/8WXjAizcRTH1Gr54xS6D2mMls/xyT9JZJn
         hPM6xTHvzTIgEWBY+lmzNl0vurIv+9vkkZeb9Hzg3faep/xOM3H3G9r2hc/6x57SKLz0
         OnTzRawXTtD+iaYrjUHZSykNKZaA1L3Z6fzxtx8Jaxt3ziB3Yoexvew6IlgOPLaOwm/9
         uLXso1otT1Jctx8qtI+KmTtKJ8St+UA/9LiOlRlD/DrLZq+UT4D/5LgXL6MCqJmKOIhH
         NiVxL63rflZVcrqXjMQLTTT+Y45hU64Z+H6GOClNNsp+tmlFLrrB4g1CioACFvBKZSie
         Lypg==
X-Forwarded-Encrypted: i=1; AJvYcCU2etiQ9gaYwXIZiGQPZG0xo2exSgG1EF354RUYnnNatQKUR4q1RtRXyUCB7ffgeR7s401y098=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZ0qg2rfquB4lQEf0yZjQm2Jbhtjq5dWfxnw8oqXLuBPEwXJex
	fanqlKEhFtOq8ovG1TdnhneKtkNWYp0x+wEs0Fzo0tSrkHgijMOn15WD4/Ff77X0jrST1LZz/PQ
	dLg==
X-Google-Smtp-Source: AGHT+IEjw5s9ln5Mmco0bHKHDYNNIWwRc71SIREcZZABOz/fcRYPRAU5+BeNEqASF/uZrX6+QTap8C7eoHE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2c01:b0:6e2:3e17:1838 with SMTP id
 00721157ae682-6e3221407b0mr440167b3.1.1728584793806; Thu, 10 Oct 2024
 11:26:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:50 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-49-seanjc@google.com>
Subject: [PATCH v13 48/85] KVM: x86/mmu: Don't mark unused faultin pages as accessed
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

When finishing guest page faults, don't mark pages as accessed if KVM
is resuming the guest _without_ installing a mapping, i.e. if the page
isn't being used.  While it's possible that marking the page accessed
could avoid minor thrashing due to reclaiming a page that the guest is
about to access, it's far more likely that the gfn=3D>pfn mapping was
was invalidated, e.g. due a memslot change, or because the corresponding
VMA is being modified.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f9b7e3a7370f..e14b84d2f55b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4386,7 +4386,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu=
 *vcpu,
 	 * fault handler, and so KVM must (somewhat) speculatively mark the
 	 * folio dirty if KVM could locklessly make the SPTE writable.
 	 */
-	if (!fault->map_writable || r =3D=3D RET_PF_RETRY)
+	if (r =3D=3D RET_PF_RETRY)
+		kvm_release_page_unused(fault->refcounted_page);
+	else if (!fault->map_writable)
 		kvm_release_page_clean(fault->refcounted_page);
 	else
 		kvm_release_page_dirty(fault->refcounted_page);
--=20
2.47.0.rc1.288.g06298d1525-goog

