Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B50217F4EB
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038034; cv=none; b=jun+TDSzpRYZhWZDuN94OQ68MBlG8wawaW44eMlLgc+XxZ+y3f9QylKRzbVKMc6tkvr/JhatF8Ru6YlAMWWRctPXf7+PF5HwxOjR5hw2M2OdtEukkg15dZuRxk6JhPLTGAfuwE7RSs2NzFZe8BA9PPLPsyDMRcB3oWIWQEiUh18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038034; c=relaxed/simple;
	bh=DtXqKMMIismcR5Jrwgm9yWaU7DBxhq5zzlFfV1KGA1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aexWwsoLnh97flOvo19yRHH54viZAQte+V0E1cOZYpsTl3TjA5YoQTzIj+nRkpcs/byBlkNeEPKGpWzNNjETIPn7ob3UF8FzV7ki7WRO/2T06EUWFJCPTHPidOeaNGVyNZ0a+DuLK5KwjhNYhjrhSZa+S6Uv0VjotPTGLqQsqyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s8+O8ldH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s8+O8ldH"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb63abe6f7so1690411a91.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038032; x=1722642832; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4+b7zhduK4lVkLFwoy0UCXuK8f7LQragdXHyxQERLss=;
        b=s8+O8ldHz1HEX3IomLpLhym89LmMr5eLKEG0bYYCJqdXjep7pjlE89aWs5YGjl/9HM
         H0gkZCzezjWFjFCri0OIx4LhY+hylqKn54tahKjCedhZsvC04EKm//n6ide2pZyCMtz2
         OB9rZqV8kvuysrFqM7I2VqbnTX0F0P/CcVROxdqrLd9KbyYe4XUxf8i/qRITM1kakrNd
         i8a5q7Kk+upnVQGVk2iiAaQ9OwzRqkoya/XTkxBbq60kq3RKJ+0nY48xpF/taWmpU4Jh
         EQP6sjrFzJzsM/flt7mzYDzSbVN3LZn5XHPC2O8a/G00jBoiuHzwOF2HY6uc6MRifdqn
         oqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038032; x=1722642832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+b7zhduK4lVkLFwoy0UCXuK8f7LQragdXHyxQERLss=;
        b=GVjEobDfhZ5Ipt3WeE7AMjlNXfpDlBlnRE8ovHErgRR9psp/z28sXnyScS/wx5DwC+
         j/H1dKZgD18a8y4ieAwNy3btB7MudA4v/67E27n8hCvbh9bboR73mhijU5OIEvL+1B1X
         QDvfPoLJZ2uzLM7yaVAxScgT730kHvTSQEfiS2vIguSwbiZSSJcPWBkZTnXO7Oc3d9eS
         mLwHxhoh+5Iruwfpiohvj9jmSfdupOdUQVYBglsQVoxaG+14jwmtxe308jNCxA8XzJyj
         qFennzgd7Snl/kCPhJcoQpqP0aoXa0ZeLJ/UXXAPWRsv+ngpxgnBpW1NhnZs0DI6sWn4
         SF0w==
X-Forwarded-Encrypted: i=1; AJvYcCXhDQ007+PJqMMpoUvWVkEv+qmagSd5dKh7Zw1DdlTOlmPiap1ZIU4gSJ99+W3O113sJMpcmiLHCH11lbdvR+RcK6SZeFXu
X-Gm-Message-State: AOJu0YzfeuI/BRaN9EiAOtlBSHpkfktJZW4D65ln45hJQwHvYfyicE8b
	lU/ft4LZFNCE7n1zP8teZN9dCyvMZY3LjqaEyDWH1bxuZKqMTSC5KSZ5QcTbuD57mT98hCBL3A2
	9sQ==
X-Google-Smtp-Source: AGHT+IH83fBTCbgjCdiYRsrBHzQDSmPEXzxw/dBUECcFBZL6/864S5lAdfsy5Zb31ECaUXnMa239gb1WZDE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4f8b:b0:2c9:759f:a47d with SMTP id
 98e67ed59e1d1-2cf7e84e558mr8570a91.4.1722038031713; Fri, 26 Jul 2024 16:53:51
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:45 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-37-seanjc@google.com>
Subject: [PATCH v12 36/84] KVM: x86: Use kvm_lookup_pfn() to check if APIC
 access page was installed
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

Use kvm_lookup_pfn() to verify that the APIC access page was allocated and
installed as expected.  The mapping is controlled by KVM, i.e. it's
guaranteed to be backed by struct page, the purpose of the check is purely
to ensure the page is allocated, i.e. that KVM doesn't point the guest at
garbage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6d65b36fac29..88dc43660d23 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2612,8 +2612,8 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 
 int kvm_alloc_apic_access_page(struct kvm *kvm)
 {
-	struct page *page;
 	void __user *hva;
+	kvm_pfn_t pfn;
 	int ret = 0;
 
 	mutex_lock(&kvm->slots_lock);
@@ -2628,17 +2628,16 @@ int kvm_alloc_apic_access_page(struct kvm *kvm)
 		goto out;
 	}
 
-	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (!page) {
-		ret = -EFAULT;
-		goto out;
-	}
-
 	/*
 	 * Do not pin the page in memory, so that memory hot-unplug
 	 * is able to migrate it.
 	 */
-	put_page(page);
+	pfn = kvm_lookup_pfn(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	if (is_error_noslot_pfn(pfn)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
 	kvm->arch.apic_access_memslot_enabled = true;
 out:
 	mutex_unlock(&kvm->slots_lock);
-- 
2.46.0.rc1.232.g9752f9e123-goog

