Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218BB19069C
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038124; cv=none; b=Wvaev5Eae2ON1pYKCU/HFtckREa2XPPaGMfA+Bj6+dmQR/o0vJJ4pZhDfkGN1fmqS8tOb/cVT/GFarYgyD7ddpRUFYxwLQK2XX3lAblj3WDnrMDqtlI5hTDv1JD8ynoiGs6f2yZrJk4C8lCD+q2tmQdx+81lSnAqVNtdInPpDNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038124; c=relaxed/simple;
	bh=7Hftste+MoYv6vvr7E6Hei8BDRxdZZ0dk5NIAY9vDsg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mKmHrMB1X/Nd3S80sRB/eiUNv/uUNMj93iPMnAEuOBzjPZRDKXSxXNiQvUFz9fzhwhJQjyWBKHrGAF7vH1JUz4D55q/j69nCxrvi/Zrh/4605pVVEYEEFSiLoNUB8CbUH2nDp00RNqxbOcztj+7mzGhdlgzhi+fOlHcemUiRnPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bv3DvZnG; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bv3DvZnG"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-650ab31aabdso5353377b3.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038122; x=1722642922; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dTOlfH+mhloY9mYg+/p0IQai80b+6RXS/WhBEV7av3U=;
        b=Bv3DvZnGMp6Pk1yAm+xpbcG0mcMn9swYRDGdrLOZCMeUtDQjePedY151dikoVM5b6m
         NQlZS6Y6x36qNdOMtAp0XPlGBnzCTGNll5lcD+4w6vz9iJShttCTIve6xXHqSRlKCyrH
         +0/P4FjJSrPOPa95z6ODwuTafuyqH9EZZQVe+zY/BeCVJIPTpgEeayRYWA2I8KHCsYnE
         1MJ5vAOwgThQ1DqdtDVHH0hVO1Q7pOOQHpHjMdVMkEYUB3oemfaXdtJf1L/OPTdAh/Ji
         QS5pyWawiv5Q0LbN/hka5lcFWZ/hlcSpK9QJavfqhvsUw21LXjNX3d0h0bL+GHLgqRMC
         bZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038122; x=1722642922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dTOlfH+mhloY9mYg+/p0IQai80b+6RXS/WhBEV7av3U=;
        b=TV+r5HP4oeL9qTFMM0fW4ZfY7/LxiDFISzOiah6ZVjv9hfQYG/8l3ELVzn3ZdSbXNO
         QRydtf1E6li2LuKpufBUgA27WH8JZlHJuP249glZDufa9WYOE6S9dcsS1I4hQbrsGWRI
         g1/azfy2FYhuxisGMDh78j5bgHDQm8uQhjN260673QHIq991HDF0VbwwqPl2VnYG3gN0
         lxQYimRPkm5/RhCjnFw35iVwuWvzvTECyUWF6Qz6uQpqueWZMEExEIQJDpi9tzhbddRA
         1kCloPFZUUpMBMyIuOI6UvgO18bVlKw0V1ge/Q6M1cIfHNlLvMJBx9XKJvakPD+ZsPRA
         3QYw==
X-Forwarded-Encrypted: i=1; AJvYcCXorjlHacNn6YNN+2YZgb4r4eJwud34FShOWoO2PZTksadfmmh3Si9aDL6MN3LIjQbLDGK1tDJebg+iuIiZ+YyJqwZnWM1x
X-Gm-Message-State: AOJu0YxBssfg0iW5HQQxWFyrUGBLHttOh56tnKJuZOwAMwltBhpVRvz/
	0C19mPxbCDzVqNtDA92LJZ+bPosiSfUaoR/KomaWnP3vUi6JfHkf0+bHHGUt6lVgjFcGJquWgoo
	MuA==
X-Google-Smtp-Source: AGHT+IGgifSFTGz9fVU5jdzVocA5wMp2MITnk/v5MkueXs++Udesz0kCsEkHm8VEDJpbtR+Hv7uv12YKgg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f0a:b0:62f:1f63:ae4f with SMTP id
 00721157ae682-67a052e5dccmr429907b3.1.1722038121721; Fri, 26 Jul 2024
 16:55:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:28 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-80-seanjc@google.com>
Subject: [PATCH v12 79/84] KVM: s390: Use kvm_release_page_dirty() to unpin
 "struct page" memory
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

Use kvm_release_page_dirty() when unpinning guest pages, as the pfn was
retrieved via pin_guest_page(), i.e. is guaranteed to be backed by struct
page memory.  This will allow dropping kvm_release_pfn_dirty() and
friends.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/vsie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 566697ee37eb..f6f1569be1cc 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -670,7 +670,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
 /* Unpins a page previously pinned via pin_guest_page, marking it as dirty. */
 static void unpin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t hpa)
 {
-	kvm_release_pfn_dirty(hpa >> PAGE_SHIFT);
+	kvm_release_page_dirty(pfn_to_page(hpa >> PAGE_SHIFT));
 	/* mark the page always as dirty for migration */
 	mark_page_dirty(kvm, gpa_to_gfn(gpa));
 }
-- 
2.46.0.rc1.232.g9752f9e123-goog

