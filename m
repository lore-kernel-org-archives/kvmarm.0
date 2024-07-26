Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FB2190059
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038118; cv=none; b=p66xEazvETi2+EuQ/lYSJsq5uY0XEFgoQs2BgcCah+aBXYDPxV3PcoSkvp5EFOPAMdhugOSFfumqMU7AdSbREfE4t7QQ9LV48sfMG7AzZkDAnUn7kQR0UfMjlMoAtNZ0GNxL4DevnqUIInHVYOJiQ1KU9piPuCMt2d16jwyAUSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038118; c=relaxed/simple;
	bh=SUUzhrURtkDY8ACwtRZFtnUrMpf+i7jwgURG3Mw5oko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JBelSfQuj4w2atLVuWu31u2hsItFERegj9Vi/izmwFvmEnoGidt7D8MUg4kUvZt9iRET/LV7NnC1PyT2ixRJaczK7NJSaMX5CUK3fwKNfFRr2yqk1RL/J7J/YfG+vNmIYuKttaEft4r5AgD4HN85JlZFhenT++x0jfdq0moeV+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kq2AT0qb; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kq2AT0qb"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc658a161bso8414765ad.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038116; x=1722642916; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gSJgbeqW0EjFVjI/rvx0LQaQxVZn1dW4kzDKJHwZpGY=;
        b=Kq2AT0qbZxL3TKTDuuXV42k7Mn/iUI2UE5Seo/Pe6lCChMavqY+rdRTpBky94liYj2
         H48IwD1A9J8Sc0zDAbIdhiHF0BFYoizaEOUatw46eo7Q6I3M+GX6zhOgTYh2OT5ro34H
         xGmjoHYNAAK/rYDYHe/4L4C1Ha6s8dZqjdWa8CUqwNZfpXR7zviusoxcEv6Gc0MwRxXM
         44lsIGs6y/AE/Q6d8JXmoJMf2C5SFisWf25+1T34a4CQ9fPO5c3buPKWKmJ92QDwJ8bd
         tWxh7HgLnp9/y3tvApuzUb/DQbr7Er+rxmrKgbsKJz+JCyVse14i2am4XLHPssTFQpEr
         Ei0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038116; x=1722642916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gSJgbeqW0EjFVjI/rvx0LQaQxVZn1dW4kzDKJHwZpGY=;
        b=WtxjGYI5d03yNrygxwrlGNkuAyI7taHPijWggbCncFU1l7cuinPC1OwMvutGvPC+4v
         GzvZxzkqbN5JNtMtMz9jQPYo43JYF+0RgG3XMdijy2NIq4rNgLNeusb1wlFEi/G0Wy69
         TPX3yZv3dI/LVJfPIj0uSpzhqbTaxaxbOHKRRwwYXGL/JiBoPrV1kaZgDWxaIxSflfh2
         wWVzhXvsVA/3YhpbL0Fc8Szykb4Vo6GHF4HBEdrphqIv0FUD+P5uS4gBrlOA3XL0VtJu
         jPoNZdUEE9uJCCrgEIAbT/gI9SKDujb9HxXVk8ZIoNqNiDzrrkBrbEgKQslJtWQmqkBr
         QuwA==
X-Forwarded-Encrypted: i=1; AJvYcCXokbtiyoEgXE5g/PGkrhshXWUd0eHTpGmkQMBrRiASS5U3aeO3jqMS2/eJ09yCQKsDWEYPkZ7GaIGZDpAOkdH2SOfqjidY
X-Gm-Message-State: AOJu0YzXn8Y/0CqGBKLQkSdvL7CLmWV6rU6vkZxnE2I1bk5XfZxfdgiq
	43q+hV6e8CGdN/mCu7+AwpGunlbRnVT77/16/E7m1BHHcbsCdo/9lvmNHvIm+mITnmRMq1dUuOb
	Qbw==
X-Google-Smtp-Source: AGHT+IHxrkKUWCeUEpiaW8aWqxkJkE+eVd4nhH8cGKa9NS3y3LrlRDBQyz/B78NptpquvhhjWf0asoH4ivY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c945:b0:1fc:733d:8465 with SMTP id
 d9443c01a7336-1ff0488cadamr599925ad.8.1722038115596; Fri, 26 Jul 2024
 16:55:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:25 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-77-seanjc@google.com>
Subject: [PATCH v12 76/84] KVM: arm64: Use __gfn_to_page() when copying MTE
 tags to/from userspace
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

Use __gfn_to_page() instead when copying MTE tags between guest and
userspace.  This will eventually allow removing gfn_to_pfn_prot(),
gfn_to_pfn(), kvm_pfn_to_refcounted_page(), and related APIs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/guest.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 962f985977c2..4cd7ffa76794 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1051,20 +1051,18 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 	}
 
 	while (length > 0) {
-		kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
+		struct page *page = __gfn_to_page(kvm, gfn, write);
 		void *maddr;
 		unsigned long num_tags;
-		struct page *page;
 
-		if (is_error_noslot_pfn(pfn)) {
-			ret = -EFAULT;
-			goto out;
-		}
-
-		page = pfn_to_online_page(pfn);
 		if (!page) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (!pfn_to_online_page(page_to_pfn(page))) {
 			/* Reject ZONE_DEVICE memory */
-			kvm_release_pfn_clean(pfn);
+			kvm_release_page_unused(page);
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1078,7 +1076,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				/* No tags in memory, so write zeros */
 				num_tags = MTE_GRANULES_PER_PAGE -
 					clear_user(tags, MTE_GRANULES_PER_PAGE);
-			kvm_release_pfn_clean(pfn);
+			kvm_release_page_clean(page);
 		} else {
 			/*
 			 * Only locking to serialise with a concurrent
@@ -1093,8 +1091,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			if (num_tags != MTE_GRANULES_PER_PAGE)
 				mte_clear_page_tags(maddr);
 			set_page_mte_tagged(page);
-
-			kvm_release_pfn_dirty(pfn);
+			kvm_release_page_dirty(page);
 		}
 
 		if (num_tags != MTE_GRANULES_PER_PAGE) {
-- 
2.46.0.rc1.232.g9752f9e123-goog

