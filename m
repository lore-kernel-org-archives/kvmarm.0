Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDC31849DB
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038062; cv=none; b=PtY4Su7/Nc8U/FQqywsT+GTmRZ6/1EkDY1fm+N9NlGHyP8ODe/af+L5fu89ecC95aRPtoahS2EOJf65N8K2btej+5syOrYoclAL0+jU/MwJfvkY2eN+YKXEqGgDcjZPjeB7bACCJZrFzBD81pIKMoeTEBtAVP0PJrF8GrsOFhxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038062; c=relaxed/simple;
	bh=+A4HyT5mPj7Uehr+zQRb98wKpKpbg1KoeNdaEKS53g8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kjJiDTfYH1wjcOU4bQI2OAYmtThFfi9N4fok41lUKUcf+4UK9rPnFt+Nbhu2rEzIqCX4b/mvcBlnP9RdjA35xm1fa3Ze45jOsRMioF0yN4Y2yIfiStLE+pDQFXlhj5Cj01yeE8FOglRk2N4otUjjJXqkczrK/1OtFy1QmuKW9tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V06rKIbY; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V06rKIbY"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d19a4137dso1423330b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038061; x=1722642861; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=495sZLd3sCBTMIrtoKFKEohUXAwQ30LA4hbLQQBllaM=;
        b=V06rKIbYAX1mFLFJd6Fg2W5LSIa635sFjNGNM57UL5rTkhaQjTLi11zAEdoQiycnin
         EnmEpR9dWBLIoHcZ5+ZIHjweseUjYZU3qrKSQptx7o8hY1c8Jc0PMWcdIcEgWTehl7Ug
         WbUBn3GudE8zRg7Wa0BjTenYctEx8QEXDmXdG1BV/ZH24NJrpLyWAY6F6kSU3sD6wt9U
         uQbpdVCQspV5nXoB6KtNGzXgOGeA+1he+UgLEHvwzgVfQafYW9n97PqjAcY8xJZ0Hkiv
         mykWhO37mIYCLOQtVlvNUKDWLEaX+0e80B6BgO5oMRtW0XqgK9XqBeBJY8ZZf40FlG2P
         0CrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038061; x=1722642861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=495sZLd3sCBTMIrtoKFKEohUXAwQ30LA4hbLQQBllaM=;
        b=ihBJQYsCniorCvZfqtdzAcZndWJAc0qR+6ucQdcIozlK6ou4kGIjkrq0a7lluh7mC8
         U76PjdA3lyNhF+YChwFhepklLz292X7p4dxqqsekI+1ZYrWRygeKMxY+LwYSigxSsvQP
         /mPW0IF4Fi3omnfBiD1kHkHtd74w846++wkMoO0MhwrCtA4e2xOp5sflYQ6Q+gsVN9xl
         Y+YU1zjKI6koROnavFhxQhgb3OxKqlaini4T5cwSBEDwGNUBHSXOHHG+oBrBQkN7q2RN
         oPBtdUM6igk2xHO6+ximkA+XYcmtfeDlJoHcAku6cBaFKP/8gC3i2ovhG4gnY1mI+3OQ
         x2MQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy+gAyJYpQpHL2Br2tIilyg7nf9R+B6PqXZ4KjakAja1ZlN5wYYVQ8py1OTAO9grIIzVa0g41wPIqlAWE5hgNau3MeftXH
X-Gm-Message-State: AOJu0Yzj4ftjIg3gXMP92bpA2H+Jo902yQNFKTs0hyyVO/Zhvdp1JH4s
	ftKhH6Tkw85LkqWhL6P8q/jsGJ0dvmfywBdDVR33HxW81VRi5SguCOggZ/fqQs+ljrWcLQqhJBZ
	6Tw==
X-Google-Smtp-Source: AGHT+IEX18wdLlkp+2aMf2anoWcNTpOtSr1c0ECGrHfjhmBCNZQh1f0vS16HR3FEGEctU7qtPLZbGkdGSSc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f1c:b0:70d:138a:bee8 with SMTP id
 d2e1a72fcca58-70ece533146mr8925b3a.0.1722038060383; Fri, 26 Jul 2024 16:54:20
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:59 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-51-seanjc@google.com>
Subject: [PATCH v12 50/84] KVM: VMX: Use __kvm_faultin_page() to get APIC
 access page/pfn
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

Use __kvm_faultin_page() get the APIC access page so that KVM can
precisely release the refcounted page, i.e. to remove yet another user
of kvm_pfn_to_refcounted_page().  While the path isn't handling a guest
page fault, the semantics are effectively the same; KVM just happens to
be mapping the pfn into a VMCS field instead of a secondary MMU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 30032585f7dc..b109bd282a52 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6786,8 +6786,10 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	struct kvm_memory_slot *slot;
+	struct page *refcounted_page;
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
+	bool ign;
 
 	/* Defer reload until vmcs01 is the current VMCS. */
 	if (is_guest_mode(vcpu)) {
@@ -6823,7 +6825,7 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	 * controls the APIC-access page memslot, and only deletes the memslot
 	 * if APICv is permanently inhibited, i.e. the memslot won't reappear.
 	 */
-	pfn = gfn_to_pfn_memslot(slot, gfn);
+	pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &ign, &refcounted_page);
 	if (is_error_noslot_pfn(pfn))
 		return;
 
@@ -6834,10 +6836,13 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 		vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
 
 	/*
-	 * Do not pin apic access page in memory, the MMU notifier
-	 * will call us again if it is migrated or swapped out.
+	 * Do not pin the APIC access page in memory so that it can be freely
+	 * migrated, the MMU notifier will call us again if it is migrated or
+	 * swapped out.  KVM backs the memslot with anonymous memory, the pfn
+	 * should always point at a refcounted page (if the pfn is valid).
 	 */
-	kvm_release_pfn_clean(pfn);
+	if (!WARN_ON_ONCE(!refcounted_page))
+		kvm_release_page_clean(refcounted_page);
 
 	/*
 	 * No need for a manual TLB flush at this point, KVM has already done a
-- 
2.46.0.rc1.232.g9752f9e123-goog

