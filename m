Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7321836E2
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038057; cv=none; b=hNLIjdKJeSdXAIB1eDRnC+OyiTsm2pALmbX2tqax7YkkR9QnEWoW0UHfaaqXzW9RTrtz8b2X21v90URXTgroV/r79lQdSLtNsnAM5h7oNJBqzlU73qgEV7jsYAbyHMDmgyiBamwkvMiHNLUl7c8Y0UbCyHGH+ATC6huHb7FWDu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038057; c=relaxed/simple;
	bh=irQbhT8vq6NMlHJubauhZeuUKNqR9u7Db5+BI1KIaQc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P/QRvHZ1Cwfp4NW9AFn7L/5Act0D8gqLWI4RMcyrrEgR9ifRe2/qtTyPsUrh/yXtiXOsYjvq6T6otQqyCX+IdvnFW+7V4cSkYhWPMdcCTCRCrF+0DlO4sKf1dzISzru17lJ4rUbYvNKJhR8zFjT73Se4lx4Wk/0PuTnOKE9Pzgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hr8E4xV+; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hr8E4xV+"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-654d96c2bb5so6811787b3.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038055; x=1722642855; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gyzdwZRgQhOlsIfYTCemvzcmHdUAJy3wvQe/vDjl5Fg=;
        b=hr8E4xV+fn5FHxyPU2E6ZCdYfll7MF5yiKG1PgHtgdwn5hGtHeg3U6OyMF1DjKtnT7
         Fp9lzRDjdrUuEq5LNyt4MPmTUWFPnCrN8bQMaoQbN95///gaXgzrhgDyknLLiOu70Tfq
         ONRrEIIyhXRDJeKOB/JEmlSF1BGrKtiGlIwyeuB/fm0XKUbo8arM+ZYd1hP5HDqkpTfy
         nNRd+DGnXO11Y5V38zbBHgnKPM0FVkhNX+85oqsfqEE9qnGUCcv8sBSsBthCGq0qbPDj
         fkDZ14UaBytju06UTkUC/rt+Q+2gpwDbRHtHmtsVtFHa72gJ8YWXIpZ12p3NG34Q2g2M
         4nhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038055; x=1722642855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gyzdwZRgQhOlsIfYTCemvzcmHdUAJy3wvQe/vDjl5Fg=;
        b=WgoI7XoGIbHXuOPR3aodfyMsibgR31HZDr4SBU7AstiozhfC50+tLs0LMt4vnbjHVU
         Co2v85IPFnSlRJptWMObdp63TeGq9zVmrN4R+h3+Ia90H6HrgSM8P7+JSMzGgKuxKb+2
         UnASQzBtVPsSB9JSGBxvzsYCAk450qa4S+oJZtEdX3fG4x8oCNUkjtjoAvs2+k6Ze6fu
         6j7CTyWAxqyIhQf2uwu/eKzZ0wKG+u7JhvH9oyTyuEuUaMeF8a5o3MwhaTXbB4Ly7yUj
         OTfp7HcWiBxsI17iiHXBaR0eJgVxVqpK9FxSxj+H1Hh55xpT/x05is9Zz42teyCf/TR4
         xsvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj/4e3myPDyphfFogDWc2YIS/lMtTMF8cgaV2iUBtH8J7EfN1Fias0srklHnQ8Cb+DQsfeubXf58pBuPe8YyeQWW3kiLW1
X-Gm-Message-State: AOJu0YyaOTs5zCXmfhvXSKUQlgx8VcfwYod15bKfxBvci5lQwP4tzw6R
	67f9ppLEWuKXdsVJNV7SoRccsNwLuLx13UezohfENXYvOH9eq7YInTY2PYgjR/JMIkz5rlooaTE
	jSw==
X-Google-Smtp-Source: AGHT+IFpeG9OHD4NFko0QV+s2bLKC/mOPhRZ2kdDMQUp9/Z6e7qKWnbHym6UcCLJKsXB8YuZDTrWfSN5tHI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:14:b0:66a:764f:e57f with SMTP id
 00721157ae682-67a0abd50e9mr49107b3.7.1722038055008; Fri, 26 Jul 2024 16:54:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:56 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-48-seanjc@google.com>
Subject: [PATCH v12 47/84] KVM: x86/mmu: Don't mark unused faultin pages as accessed
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

When finishing guest page faults, don't mark pages as accessed if KVM
is resuming the guest _without_ installing a mapping, i.e. if the page
isn't being used.  While it's possible that marking the page accessed
could avoid minor thrashing due to reclaiming a page that the guest is
about to access, it's far more likely that the gfn=>pfn mapping was
was invalidated, e.g. due a memslot change, or because the corresponding
VMA is being modified.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3cdb1bd80823..95beb50748fc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4339,7 +4339,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 	 * fault handler, and so KVM must (somewhat) speculatively mark the
 	 * folio dirty if KVM could locklessly make the SPTE writable.
 	 */
-	if (!fault->map_writable || r == RET_PF_RETRY)
+	if (r == RET_PF_RETRY)
+		kvm_release_page_unused(fault->refcounted_page);
+	else if (!fault->map_writable)
 		kvm_release_page_clean(fault->refcounted_page);
 	else
 		kvm_release_page_dirty(fault->refcounted_page);
-- 
2.46.0.rc1.232.g9752f9e123-goog

