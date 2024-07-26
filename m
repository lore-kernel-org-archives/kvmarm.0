Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B1C17DE13
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038016; cv=none; b=WamnzbU+MFVpRDk+y9BOqvvuOWWNYfd4b8uilyTlpB2eqRiiCzuilKvURZ/Y0ux8cDbJUfJXNVMV2uP8uMPslRpz4AftmdLctOCVFekTM7kEoA3FfdVpzgKzqXJ3R9Z+80ZCEfJnSo7Vt4zgIkTPZKjUdyKp3gyYd8lypzDK/nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038016; c=relaxed/simple;
	bh=fPqYasQ0wmQSuuDUgdf/AR1cBeWS8t9kkwoIJqSn1qM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jjtJYtYpKyST8m7gbHOZq5DKuFndlky1Uipssk9sEctCN0tjneb91SNgqVYadsEQKR9vSWgwHYuxf4me78FpWx8v9A7oKkSqNHxRLRp4hNK7P73Wq3vqg6UyTRZuQiq1buYGVuBm8mk8ktlp/cNcBM0T0/4hzDSSOPRGQ8JN2EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iMck5OLt; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iMck5OLt"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc47634e3dso10321675ad.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038014; x=1722642814; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=o1vHCUb6CZ680r+o/spGyfXDOmfamym0Nonz9UARGME=;
        b=iMck5OLtcIWi+Srlc/6b4udkVFU+YYhOLIuCXkJQRcWhxE4t8wed2eUcHhBvGwFU5o
         HVn+h2xRzHGVTVrSMqDf+vMqRcu8VFf/yrETypvYDQMGu8vCSw/RNFQVJBNpIeLyaw1n
         NJJZZrnXMk2a6yAnVhvoOtVa7zP9V1JBEItDrUYp2PXjMrofQVhc2VIzT4VbI3X7JxCX
         uKXGQ0UaKFFZnbnlBK3dWaECOExbF2SwMbjARUkK6dMD+VzmnKdIHpd0AvXms+a1iZOy
         eGzVxtyR9ZLeGdqpanVTaAUCJxi1g04aNTkPq8/k4WiQoAoHUaHpZwrk857UQ6bAC+vR
         pTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038014; x=1722642814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o1vHCUb6CZ680r+o/spGyfXDOmfamym0Nonz9UARGME=;
        b=nNQsHFEuvMaqzTZpTDgGFG/2LqjBeLn7U9ve//N1tbTeAoGEq3kBvnWqOohFZKMqpt
         CPK9kF+K3kn5KDegKki/PUsXDigtjSvH8BhraWMkbFZG2qLoYh9dRHOh8xCefNlkEZk+
         GGbC/rguTqx+jetSQD4d+dnw9Z2uWVPS8HX83Qc3PCQ7KaP4g1FOF5VbXXCL3OZXFUHH
         4wfJKGWd9gO1Wpz1xG88la62D22g5WGR7X3A03dvt8cXl8u4p0b0ctNY60S0de+FxmBC
         XmmtxFaTeS81UPE0PuqaAKdJoi+wa6OeVdmrFTiuvV8I0vk1XFHKf38SLAX/TyRznNBs
         yBdw==
X-Forwarded-Encrypted: i=1; AJvYcCXElQU25zE+q1gjRNMX5rCZiCcAp/vH/QZ33ON5TCsTC4gc0k9a662nCBmx1GInsBzMGV61/iEQAJYePpUIjVwz+s1OxIXx
X-Gm-Message-State: AOJu0Yw+cMX1j46AnzXkIZPPDkUxOKRQNh+yK4zQX91o+0ondXXBmWys
	npEk2x33W7AXcJg8ZauwifoqVbTEOdbee4T8qOGdZ46RxE+GN2QXhMKLbBxww5SezEBRnGFS7yP
	8QQ==
X-Google-Smtp-Source: AGHT+IEBaNygerYKF4xG2tivsYC4I+4KiNqX7pDiMNbM1xexlfLGsv92ykpFMstIuclC7BO9j6NqEQXsK1A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c5:b0:1f9:b35f:a2b6 with SMTP id
 d9443c01a7336-1ff047dce33mr22915ad.1.1722038013079; Fri, 26 Jul 2024 16:53:33
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:36 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-28-seanjc@google.com>
Subject: [PATCH v12 27/84] KVM: pfncache: Precisely track refcounted pages
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

Track refcounted struct page memory using kvm_follow_pfn.refcounted_page
instead of relying on kvm_release_pfn_clean() to correctly detect that the
pfn is associated with a struct page.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 067daf9ad6ef..728d2c1b488a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -159,11 +159,14 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
 	unsigned long mmu_seq;
+	struct page *page;
+
 	struct kvm_follow_pfn kfp = {
 		.slot = gpc->memslot,
 		.gfn = gpa_to_gfn(gpc->gpa),
 		.flags = FOLL_WRITE,
 		.hva = gpc->uhva,
+		.refcounted_page = &page,
 	};
 
 	lockdep_assert_held(&gpc->refresh_lock);
@@ -198,7 +201,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			if (new_khva != old_khva)
 				gpc_unmap(new_pfn, new_khva);
 
-			kvm_release_pfn_clean(new_pfn);
+			kvm_release_page_unused(page);
 
 			cond_resched();
 		}
@@ -218,7 +221,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			new_khva = gpc_map(new_pfn);
 
 		if (!new_khva) {
-			kvm_release_pfn_clean(new_pfn);
+			kvm_release_page_unused(page);
 			goto out_error;
 		}
 
@@ -236,11 +239,11 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	gpc->khva = new_khva + offset_in_page(gpc->uhva);
 
 	/*
-	 * Put the reference to the _new_ pfn.  The pfn is now tracked by the
+	 * Put the reference to the _new_ page.  The page is now tracked by the
 	 * cache and can be safely migrated, swapped, etc... as the cache will
 	 * invalidate any mappings in response to relevant mmu_notifier events.
 	 */
-	kvm_release_pfn_clean(new_pfn);
+	kvm_release_page_clean(page);
 
 	return 0;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

