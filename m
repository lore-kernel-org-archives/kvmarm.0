Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A1118FC94
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038114; cv=none; b=HvgMmI/2uIkq85L4GmcD6Fo6syVXKrq/2m6bvTxWx6oqnunrdNvapgu0mXIqRJTPC5doylRMzyifAEGv1lfb2SKulgSjDCV6plbXRJw9gl+7I7B9A4cNskCfxImz0kfhrRB35dOKUUf+PZE1SSYKmbqa+aNe+zBaK+YBOo18W1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038114; c=relaxed/simple;
	bh=O9N2pQ58zHOs8mA5SBdaAy+6THp9s1eg8+6wg1nEqWw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hD3Nl065qO/gsz19B2IZOxD2tn4YUG7Se0QHj5I4JhviXLbaCsrtk95+Rj70NQ9w7UtssRwItm1yqYrefm15XmsAtxUhrF/OyCglHWgsN7KcUj7ssxHFuuH605+1MeoG+hq/KKIF+CeNGGsJCDnmrmGTeIixMWWCKDLiPLiY1N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w95j+gfN; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w95j+gfN"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e05e9e4dfbeso401927276.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038112; x=1722642912; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4Hy7goaarUlwaWZyx1m4yCokRE7UoQ8eGBMKWJ4Hgr8=;
        b=w95j+gfNjnl6cDLsp4soEI/fiGSMk+qKtHqsVpPHtC/8dZd0K+FQy0rk49qLDYw9Ht
         aXam4NaOvC94ytXGWi/2ux27kSEOdSDlrhVSuk4frsiNbYRZDuI26ZMHq8qVMMv8SW8F
         aTCHRROUkVOx2AemuOK77FphvHHcCs0WMfw7tsvqjOsIfDW4oTnENum6tKWqeIeiUohd
         HowP4q7A0/CtpT95z8Bn6PW9cpOgqZygr0vmnw+HhPx3DNpTlH3agZ+ju6HPvoxQreSf
         /B0gEDklXg/qGnSoLPcG3YzIHZ00Un8pdVOHnNaCKPXfyh0hoTDJVoBufr686tMBZ11y
         5ukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038112; x=1722642912;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Hy7goaarUlwaWZyx1m4yCokRE7UoQ8eGBMKWJ4Hgr8=;
        b=TGl8XcFOC57G5JweePsiGdDg65TwHipvUXZohaMcEvNRqvWy7LX6PyUNgWu3ZDjgvd
         euqa18gVsS753tGgUMFdty8/BciWJS9xiCkEy97zPDGRziZQeXaGxDC3FIqkefAarEXk
         zSOTtNvLad6wXAipy2J5Kc6PWcoJsVCkrsRa4J1sWaEm5lonj/mULyvgSOSWgofgiQvM
         VvMtcats9j7P3z03DQtK/+Z18p6vlcK9GQK0iwRNUJHo8haOODEQi+2jt2mZclze6Nwg
         WnOlk4khAXU1kaKoZ8eRtcTaQ8urckSFMRoaCapx3OsMVIta978uqjjnPb235QT9yZ3o
         MzNw==
X-Forwarded-Encrypted: i=1; AJvYcCVliYCeGo7kVjGsrPlZefN1v3WHmnndWlm7irZdBkKCV0OO06Wr3ecQlVCkcBlGbkjYkNv2tYDEQjokrxrxDoMaw/VUmZFj
X-Gm-Message-State: AOJu0Yx6KKJ4ex+K+lHhK0JT918CSXU40E+9zVZPc1lNWNQVZuCLGWoj
	HpmMfrDpTSJ8W0Ok8uVjJ8J2gWXaTugdbNzfmvG4z9UEQnB57KSkMBbz4SvG1Mz2wxWARFgyV8l
	8Lw==
X-Google-Smtp-Source: AGHT+IH925MpsiY9ahug77TjXa70fcvLwqDVLsDqA/3N0vd70sZBQGqqpgNL91Lx+sGl/PSva06bFRo6+6A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b8c:b0:e03:b0b4:9456 with SMTP id
 3f1490d57ef6-e0b5454ca99mr43273276.7.1722038111873; Fri, 26 Jul 2024 16:55:11
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:23 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-75-seanjc@google.com>
Subject: [PATCH v12 74/84] KVM: Convert gfn_to_page() to use kvm_follow_pfn()
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

Convert gfn_to_page() to the new kvm_follow_pfn() internal API, which will
eventually allow removing gfn_to_pfn() and kvm_pfn_to_refcounted_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6dc448602751..d0f55a6ecb31 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3181,14 +3181,16 @@ EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
  */
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
-	kvm_pfn_t pfn;
+	struct page *refcounted_page = NULL;
+	struct kvm_follow_pfn kfp = {
+		.slot = gfn_to_memslot(kvm, gfn),
+		.gfn = gfn,
+		.flags = FOLL_WRITE,
+		.refcounted_page = &refcounted_page,
+	};
 
-	pfn = gfn_to_pfn(kvm, gfn);
-
-	if (is_error_noslot_pfn(pfn))
-		return NULL;
-
-	return kvm_pfn_to_refcounted_page(pfn);
+	(void)kvm_follow_pfn(&kfp);
+	return refcounted_page;
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

