Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEA418E763
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038102; cv=none; b=RZnfpkLjPdTbf1kaS8UdvbTVeWP106Kui2/lva5ZFnfWh4pVj9+y2lHS3aM5SmSpjimmolLayICJnUfS0BTq5F73R7DlvE0ZhWbE4Z4lhf1/HuMe5MB8ZcgOLcKsOXphA8UzcKi+ObvWGUKoUgUCaiPLM5vJj4sPvs18hLqmyZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038102; c=relaxed/simple;
	bh=X/oocC9KK8HLcDY+BN3O4ToHUmzhhLHquCuXU7/bcMw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BoJS7oRkFNBwKX/4Kx3oCVR+wEaWg0qYfuJDulfVWwM/iLel4bZp1o46xTnazzGdzyn2TFFleLXXMuz2TIUVxqJPFklBLDj5tlqTCOVkTbGs4/yn6jzXpSBvQI9X4Twg1rl7DPtf8V+7s3r+X+jFO5hdViQDT2RtRjGiGxMNtQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JmlEuP7r; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JmlEuP7r"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a1914d0936so1308764a12.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038100; x=1722642900; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EmsAuvL8HQXwYqsGGesvXxhYre2Gu8OeDMQE+hBNppI=;
        b=JmlEuP7r/bz+XMHd26S/nok4DfmnqAf7D1uuWn2+5wVJOp3GLvadAEV8kjz//g4wt1
         /Z8WZYZnHoxCzgTXQ9G28TqpjVpy00bPOXzvoj9VPbV3j34gCcGEK8pGNPW2dVZ8a+4s
         6wrWhwOmex9lXcSXkk1eRRwwZz8k0UGnx4rFONO77Tub3tA9sV3pUOAvGmL1leqeSC/y
         VF6IUE2Rr8HGsLBXG6ZhWgC1jMfnDdwhQtE/GffEJE4RwjUm7paqUku35VWxEKnbD1n1
         MbHlVsXJZfMJWomkc3Xf2q6EnZ+93giblAdxXLBOzN3/1Jq9Rd0z7fAydIyd5bIiCxNO
         +wxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038100; x=1722642900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EmsAuvL8HQXwYqsGGesvXxhYre2Gu8OeDMQE+hBNppI=;
        b=MM3+72RUZgCDGjeu7Uxp8z/djERW3NKVL7TLItx/puA9VomEc5U+xB4gEzobdzdUTd
         wQ+yT3bjJdhAETTNK4WPo8MTH2IUuua7ssG/0weMvpPNP+XJrvQ0H9MqYAbC5rhZl16J
         VyqanTz7B69lAnxB2bDdbXeCUENuPkL2Yk2+hjyAOym92fjg2j51Npi22m9AtTCdqpdT
         lVWwXBfnXj/mPGjOtiWjunCfu0zeeWLAeeFeCoq8fCJxxaw298x2kE1WRaMjJSDQFI3h
         Imu2i2zsfX02Be1XsblDVyE4lsV/UEqjIj+tiUAojWo3lVAKDN2//3PvZW3lQpyBRh6d
         hFQg==
X-Forwarded-Encrypted: i=1; AJvYcCUcClRGmZh/ReVyV4rHtUDFWsY0KRFn07OZhTiERa7b6VdFZ5c/w7+h9B4nc/+Vg/LJU2VBIJMMl5g26RtT/2aScUQ/CcoF
X-Gm-Message-State: AOJu0Yx+OAve9DL/wMV0ZS4xoOOl7woj9TlC01483Txr9fXW9SJGOV9b
	oS396XrGHRidvGvJPhsxX5wYgbQGlFpAJvuQuUH4r9pag6MnRYWEhLSVs3J9CefypblGNM2+Cvz
	59w==
X-Google-Smtp-Source: AGHT+IFixvL6M1c2YXLcj1uim9WdRxJ+9f/3q289x5sMH5Ueo8TBf7rPuOmHjx69h4l0El/Ee2ditwF800M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:fca:b0:72b:5113:ec05 with SMTP id
 41be03b00d2f7-7ac8e39fc8dmr2096a12.5.1722038098497; Fri, 26 Jul 2024 16:54:58
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:17 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-69-seanjc@google.com>
Subject: [PATCH v12 68/84] KVM: MIPS: Mark "struct page" pfns dirty only in
 "slow" page fault path
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

Mark pages/folios dirty only the slow page fault path, i.e. only when
mmu_lock is held and the operation is mmu_notifier-protected, as marking a
page/folio dirty after it has been written back can make some filesystems
unhappy (backing KVM guests will such filesystem files is uncommon, and
the race is minuscule, hence the lack of complaints).

See the link below for details.

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index c17157e700c0..4da9ce4eb54d 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -514,7 +514,6 @@ static int _kvm_mips_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa,
 		set_pte(ptep, pte_mkdirty(*ptep));
 		pfn = pte_pfn(*ptep);
 		mark_page_dirty(kvm, gfn);
-		kvm_set_pfn_dirty(pfn);
 	}
 
 	if (out_entry)
@@ -628,7 +627,6 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 		if (write_fault) {
 			prot_bits |= __WRITEABLE;
 			mark_page_dirty(kvm, gfn);
-			kvm_set_pfn_dirty(pfn);
 		}
 	}
 	entry = pfn_pte(pfn, __pgprot(prot_bits));
@@ -642,6 +640,9 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	if (out_buddy)
 		*out_buddy = *ptep_buddy(ptep);
 
+	if (writeable)
+		kvm_set_pfn_dirty(pfn);
+
 	spin_unlock(&kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	kvm_set_pfn_accessed(pfn);
-- 
2.46.0.rc1.232.g9752f9e123-goog

