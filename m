Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BE61CFEA0
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584697; cv=none; b=EoMC6X8ji9NWwGH5H4/g3Xf3cnXPuotJDkwzi1X8qteyhcgfFKP8yWau+X9yYUurxAd2f+3MGoP8SKy05gCcdGQvy948PTpkY+DRpxcIhRoMwaYnoZ3QSAikAg4Bb3nMLksRfW0gNsENKst4BXyhf2ASUIx1NeDC1DEypR7Wos0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584697; c=relaxed/simple;
	bh=iBKdL35kBHi2YuWkjigWDtnk5mPkldKXaU7GHff52mQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uonubBpkXoXIME0P0qlY+O8o75NWNYdLPCAS7MFLAhrXPympCleMrgjulSKWBNlNw9IFUJRp/Ye54OY6CPGua5hn92ozFW4IMJOv5G3jbdwrHjIII08qq9FmzhE5Mxucmq2F2CeribrWgWwigvPc3tXV3EBiB+FfqxapEHE5GYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eH0UIlND; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eH0UIlND"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e3245ed6b8so23817567b3.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584695; x=1729189495; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PiI9IzFtQVAZLsCzTZ7ta7WGdR9XnSo4A5BSh1uxRg=;
        b=eH0UIlNDOVXSo4sN/2Mp/USE76DQTnFpAu+hhMtLh3lR/GIbg6rHjOOK0XJ0rFv6sg
         XweWhaUBZISQ4tNUH0KmPU2gEpQeLpY/yS2Hqf3bOPrsUfgdswJvo3gBHSuEWleYLGUH
         6qRl0foXXzgFEFpANfWP6Si0CRJMICMOWA71kNj5zmv8aXDZdrt4TRzaw2BRGAXaX3ck
         omyJ6utGpieIi0v4x8aInD4wYQjaQgn0jlTvqx1XUAlyTv3UBQ3xpdW8HiSCTRNwUixP
         9xTs/0tPm8LofNSG2+yDJudJj5QQz0RcR0QhSF5atSP6qFIAveGwC46oi/XlSEism8bQ
         y59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584695; x=1729189495;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8PiI9IzFtQVAZLsCzTZ7ta7WGdR9XnSo4A5BSh1uxRg=;
        b=ssiiTqlT1W1sMZiNmYicdAJI+v1JXVvjDkAEeRjMVbPrIuuMuLzE/nHOAesm8GR/ro
         vMe6riaODng70WpZGtoo43euUtD4mKKdGTs51G6nf1Kx6z8Wl2RpQqXpIhNFULvR7XRG
         ndR0Y94hgJ+eePh8wdyvej5dCzEEs51BZdd8nBqnwx4Dut/DbxpXYUncvjsaBpa+5Srq
         x1Iz18g3iH9ApwERJfccweMQhmG2YfeopVmBy6PEiVfP2TwHlhBAU26TSe5fFm6Fe+Jh
         JNjVv3tPaMGmlmsiMP468cHn9Do4ROMQbYhJm+4MIh8B3O62mPgLY/6X8hVAAq2RLjrB
         +QMg==
X-Forwarded-Encrypted: i=1; AJvYcCVDUQbGmwrZFlvW1kCAwSv1BGKIh7oFMzSoffJHcMVBd09Slh5R9ZaC3poWfT70D+cpUf9xGSc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQc+sEpDT/Mc4lGxDdOzgH8A8D8UGs1BNKjq0kC5vHqRQfBOBR
	VOpBqxp898cEwdeT/Bs97H1eIncLNpYrb395Y8vqLepa9F3Oi61fR/CxO9rxgiYMAB3zu4dHStY
	61g==
X-Google-Smtp-Source: AGHT+IGz6mODxZTH5agCMYiGZey+8PwFJu50se4JqpXBNG0SwyKrN9TWGGQJqqmZYCdc2Fnc7eka1IGyLLE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a81:ad16:0:b0:6c1:298e:5a7 with SMTP id
 00721157ae682-6e3224662ffmr1632867b3.5.1728584694780; Thu, 10 Oct 2024
 11:24:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:05 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-4-seanjc@google.com>
Subject: [PATCH v13 03/85] KVM: Add kvm_release_page_unused() API to put pages
 that KVM never consumes
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

Add an API to release an unused page, i.e. to put a page without marking
it accessed or dirty.  The API will be used when KVM faults-in a page but
bails before installing the guest mapping (and other similar flows).

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ee186a1fbaad..ab4485b2bddc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1216,6 +1216,15 @@ unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t=
 gfn, bool *writable);
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t =
gfn,
 				      bool *writable);
+
+static inline void kvm_release_page_unused(struct page *page)
+{
+	if (!page)
+		return;
+
+	put_page(page);
+}
+
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
=20
--=20
2.47.0.rc1.288.g06298d1525-goog

