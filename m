Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B426516F825
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037990; cv=none; b=JvqzUtKH0SESNIkiYUK0NamohfPhGsUPITLIszNoTDC4NTTcB5GdvhaEf9f6ikhoDS5wwsmj6MJJMb1UJthTGG2rJMlm+NskfMahxfNJpW5IAUR3l0ca8thA2jaKFOWCSltvzAQ9g8pHBOVU/pspf9/5DGno2bJ9LBEm72s04pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037990; c=relaxed/simple;
	bh=wc/x3/oHz+A3HJ1377TECtP4A+SVRJ7qmCHuMbUKaP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G+gs9D6NTjQU75x15NXfZ8x9oDo+wLVz3OKwD5BX48IKDkIbdsAeuat3OgKRQHyOPMxbHCG9jOFeiuv4fAaKJHGJ5Q5RFNq5uF+HQ+ufcAG8ckkmCgyl405221BOSkWZBiwtXELfFTn7rgdDtznFvo+QmrJqgXt3P6WOLPBAW/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oMl6avdc; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oMl6avdc"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-76522d1dca5so1517188a12.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037988; x=1722642788; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XEii1g2QxUcfpOdmeEwY4J2sYQAHz7s0WQ4Z9lEf4mM=;
        b=oMl6avdcbdnoyr2qmM3Pg2OiQCHKGYg8zNsflb6ZIp2En1qXjsNoeYTzjCzXScjCqY
         QT2GZkzCqPGxIaGZXDh/HL5LcG3EncheEuYevf751Lgx9f5H/ZX+Oq3qQVxebN6QQlau
         trK0ZCFIJ4Qo500M8ZrMq2n7lAmgqrJbm3sGCU6LDvlyWyo5zIOCg/VR47NcHp5/1SPH
         swaLghYzDFJ4Ba9ZYmy/HIA1BLO21Jr282WA0kaY4CtKi9160ActIBOHjE6jdDwk/oJu
         zZWHkJFOLKCXysJvccmCNhfpY8W3dyeVXkdSlZnpJ9Yya72fIkZvcvKhPJe91tIaKrnO
         rXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037988; x=1722642788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XEii1g2QxUcfpOdmeEwY4J2sYQAHz7s0WQ4Z9lEf4mM=;
        b=VbLkHAoVK1i700DSMdRsyq1Wj+8jTBBgm/MpxEwR19W944NnyNhaiutJmxY5QFYhEX
         GuKCxxuBIUA0id9VKwAHMMGurYXh7dtBVlqyWE+7Ic21qY6aBOZ6xlkoQ0ywCebEJIUk
         Bi+X9tDaBMA54tcIoLrtcslGs8SNfWAZVpPYqIleyBaCGmeYeVjc7YGcOqFvGDiywcUt
         bpNiZQznrKydM5QTY4oE/U3yezvJ1kCADWd5WD7YdX/6nbH9NkFjfDP9e8LRuiR5XZfF
         luReBrII6PfSbjANRnhDamEu+1i93U5RbrgpL0PBZivZCPUBmp0zUtcgzqctrcMMNr3t
         YvOw==
X-Forwarded-Encrypted: i=1; AJvYcCUwsVusK1GzwAUVxYMZmYaAhvNKBW3oDOUfp3UWAau8y3ln1bRN5hCwDubDIeMqV++J15kvXQK0eunquCoQ4oWC80es4cGJ
X-Gm-Message-State: AOJu0YxEpcaW1DkPRbDUSijRqWnz+8YMFG6poENAnOgdESDqlfmLzhAv
	7XAcqCWeduku4cp1QwXJtXTLer4xGLnfB9Hto+RqBN+pnYbxN18xyLUnay3C3cy3glMl8ohEE3P
	vEQ==
X-Google-Smtp-Source: AGHT+IHOguM9TV1Wqy8YwTb6CBUJl4Q4k/lDzAhV2epo/9u56TnU3ou5KRwZKpMCKdXGcBYB5FJy1Mcb3zg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6556:0:b0:710:cc3c:3916 with SMTP id
 41be03b00d2f7-7ac8e0b6796mr2159a12.3.1722037987987; Fri, 26 Jul 2024 16:53:07
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:24 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-16-seanjc@google.com>
Subject: [PATCH v12 15/84] KVM: x86/mmu: Drop kvm_page_fault.hva, i.e. don't
 track intermediate hva
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

Remove kvm_page_fault.hva as it is never read, only written.  This will
allow removing the @hva param from __gfn_to_pfn_memslot().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 5 ++---
 arch/x86/kvm/mmu/mmu_internal.h | 2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eb9ad0283fd5..e0bfbf95646c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3248,7 +3248,6 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	fault->slot = NULL;
 	fault->pfn = KVM_PFN_NOSLOT;
 	fault->map_writable = false;
-	fault->hva = KVM_HVA_ERR_BAD;
 
 	/*
 	 * If MMIO caching is disabled, emulate immediately without
@@ -4333,7 +4332,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  NULL);
 
 	/*
 	 * If resolving the page failed because I/O is needed to fault-in the
@@ -4362,7 +4361,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, true,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  NULL);
 	return RET_PF_CONTINUE;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1721d97743e9..f67396c435df 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -238,7 +238,6 @@ struct kvm_page_fault {
 	/* Outputs of kvm_faultin_pfn.  */
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
-	hva_t hva;
 	bool map_writable;
 
 	/*
@@ -310,7 +309,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.is_private = err & PFERR_PRIVATE_ACCESS,
 
 		.pfn = KVM_PFN_ERR_FAULT,
-		.hva = KVM_HVA_ERR_BAD,
 	};
 	int r;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

