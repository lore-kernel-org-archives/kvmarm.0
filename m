Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716DC1E1C3A
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584793; cv=none; b=tEv+2LUz7hFe/GuI0+mrT6jwDWZwGFENOSyQoZtkJbn30mt0metpT+T5wb+U/CEoyz+TJ7miYsKxKrKO+7fVnshVhFCmgu5KrHhVOMBwO9DI9mQUECYaN6ZiMCy9Siyox2K88Yhw0SQL8lc2ZOsh1Q5cOZvsB1EA0NNQYk+y+Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584793; c=relaxed/simple;
	bh=P6yv0TC0koYnkFHtfd6W3SlzMlk4IripfIbi6+Lm/9A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a2d/+odCzFeksHpyNQhqv38jZHmozDSH1rHR4NV+3KZlPbSrjx+Sgns7Eq4BV1FROU4Z+1T2GYv7djoFOfxgvAIJh1NL2Swcrw3ruKsTnQMe9nAotO2yaHdTpHtRPtSXex1OZh2kTlq4xTP/RkOHY+yPxNYN/d0dIrzGI4/Xe6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ykj8FNgw; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ykj8FNgw"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e123d3d22so1429113b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584792; x=1729189592; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4aL9ye2ZxrCnqTpLqQlinT65BUul16gfmDzid4NN5Y=;
        b=Ykj8FNgwbjCHfhPJp9mcdAgHvIKiNg7n0K2CwJeUVFKU6/B0H0VgbrfblYsIqUuoBS
         ILBTsXo1QtlXht8micjjrx5xsO4e1tPdSS1+3xX2cjaZxAN1MO5DEBe+uEgVA+SALRqe
         GzZPgu1LaGpkrEiKPE3hdPfvusr51A+dsnpLYeScyWDRPbVmmzx933vtOHjZ0eTwLY4y
         kd8H1wt51tHVd1QouRoPAO+6ozxPNoqVkz3+h4/+I0LKCTlmF+n8NSjho92NfhWI6PLB
         mVlGFn00CmuiYucPQTC/eCs69DHMNzJ3pLaoML4pzc1x89/CjWXTCGfF004bwLxLo8Pd
         nKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584792; x=1729189592;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l4aL9ye2ZxrCnqTpLqQlinT65BUul16gfmDzid4NN5Y=;
        b=OPTEnLCEFOujN+u6mHi5yCf715y38bntvVPhI2XXz7DaT91wpkhr72CA1s1GdR1g0r
         +QLYQvQxt7/ppaGB2bUBqoFRmNXjQ7PhZ5IPvN7YxrvVQcyUJ37zxSvSkrszGBavo7lU
         LDCLT7UY9DitZ5LUpJ3ye+jKC8t7xEZVQP5qWSoXtxzUsgbiuDGWQQTw5bgHpHlIeI0b
         4/yOFmIoFhQ/w2Fp5g4vI+7BlyY8gmG8ATTZMJMqThC5egBs57Bd3xdJBXfBU7wIBOiG
         zUXWtqFchrA9uCkb0DYw2P3tidJ2XZ7FJJ3t/Be3DoRmMXAZzVlvQAD4iTuQR5t6c5hJ
         wK9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWu1RunVBJUyq1oNXuZVoplVSwvrqcho6cvoazmyxl5au6dIqAF4SQEALRbVyG/aT8bw8gdKXw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwH60iLWwNYwplKjldmqsbJwd3k7vgvHE0HcVbcLIHn9Jf4v7O0
	xz2wZu+NEXbDZ54roYXGCxasJLRnRSMAzQwd9nf6YhFzwDJg4q84KgQxSRXb+c8ci29Q+txsotd
	fLg==
X-Google-Smtp-Source: AGHT+IFunsAHL0GYDEyxrwNnSExkBiXOv88aJkEgjVxw5ZDXOBsEr4Eha3ByEK4QIBQ4extfr7SnAz+Fl/s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:aa7:9184:0:b0:71d:f7c9:8cb3 with SMTP id
 d2e1a72fcca58-71e1dbf1ab5mr7799b3a.5.1728584790633; Thu, 10 Oct 2024 11:26:30
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:49 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-48-seanjc@google.com>
Subject: [PATCH v13 47/85] KVM: x86/mmu: Put refcounted pages instead of
 blindly releasing pfns
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

Now that all x86 page fault paths precisely track refcounted pages, use
Use kvm_page_fault.refcounted_page to put references to struct page memory
when finishing page faults.  This is a baby step towards eliminating
kvm_pfn_to_refcounted_page().

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a038cde74f0d..f9b7e3a7370f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4373,6 +4373,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu=
 *vcpu,
 	lockdep_assert_once(lockdep_is_held(&vcpu->kvm->mmu_lock) ||
 			    r =3D=3D RET_PF_RETRY);
=20
+	if (!fault->refcounted_page)
+		return;
+
 	/*
 	 * If the page that KVM got from the *primary MMU* is writable, and KVM
 	 * installed or reused a SPTE, mark the page/folio dirty.  Note, this
@@ -4384,9 +4387,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu=
 *vcpu,
 	 * folio dirty if KVM could locklessly make the SPTE writable.
 	 */
 	if (!fault->map_writable || r =3D=3D RET_PF_RETRY)
-		kvm_release_pfn_clean(fault->pfn);
+		kvm_release_page_clean(fault->refcounted_page);
 	else
-		kvm_release_pfn_dirty(fault->pfn);
+		kvm_release_page_dirty(fault->refcounted_page);
 }
=20
 static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
--=20
2.47.0.rc1.288.g06298d1525-goog

