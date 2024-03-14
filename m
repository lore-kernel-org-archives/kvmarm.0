Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF6C56452
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458831; cv=none; b=MOExs3SjGB6Z7UC4PxKMRoC+aIHfMmgFlPkBWs/wvR/MT4iUXct5jwaarDzvYP3+Pmqd18Uz03fZu1cApp8zXrUmlwrlX1qCxtwL5LJqxQnWWMibZZvkItBHqplzDgPHKcyCOKm/Ty5h43A2LAQL+BTah2Ni2F4BbMLt9ol0iWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458831; c=relaxed/simple;
	bh=S54X56NK5jNme/p0rG61PtklInYwE0kYzZmEDcMwUuY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WVZxPAlJjL+4heeZ+aMbu2grTx9QmGfLMc82clqujHyEvU10LVQeP10mwynfQzJIP6bS0Pc5+19TjUhwZYX/d1LkmvE1Qeqf3gIfgQfYuBb5j3HBe+paTuu6aX4pYS4+DDxwgpvrJBY5CcJYfX1EZAQwCMD9Jaf0bltt5f5mXok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lrh4AIOB; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lrh4AIOB"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e6b3bff094so1779342b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458829; x=1711063629; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pXWQ17U6pSp+5gsIGCX5tAdB4RHln2KoUo+gy6g2jBc=;
        b=Lrh4AIOB28oW7hSn1hggkGUAyy5iEESAOVtq4YG9kgcpl/8qPydzPlH3NgalhBFxOP
         qgkEVTCtEPAyI1iwZJCXG9YpqhSpuPkF5quZt30ZMtxJhX7V8r+yI4p8mhbAo965lAIF
         jKbHRxAsUVAzJpBTFzfin1iFOP/gM4soaHhAXKnIMEkEeloa2ot1nybBe6WYTUh5v9Fc
         MH62TNW5cGcsA1JK2nCM13UEdeXn+NmjeQri/FXNzxt9ffPdOgtM7VuUd7LhHBfyhPZq
         BndUY7g3NMGT9TmEN5EGNLlLbMXQeYXXiiCdSRw4wPfJehOMxA8zjsdUOdwFk9g9THC6
         dyMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458829; x=1711063629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pXWQ17U6pSp+5gsIGCX5tAdB4RHln2KoUo+gy6g2jBc=;
        b=Alskhj905ZZdTI4gDHhuEirQFJmfqdtSHHBTsdttQsGLFK5WJOm4JYC9pPycg0Mbwu
         +6DJdv4Bz/fSM8uUHHvGNPCYdo6G9kDWbgLCVhubKqNMeenwp7IMZiDoKnDoEqqYwhbe
         3m984RDWz9oexyzLDGVS55X76F0YNZtPDVlImuIVK7ANDipbzyainatsLI/G1sBR0fno
         eSnqHivCR86o+bSkcxYb70xpUz9HRKIr2PSddDwyKaDgstcOXENsJFRtMeSZnRXVZcml
         7u7ER3tDC4dngnw3QJcgqSvawT4fPpxU54BWtwl4acU+alvh81CyctoI22TgnssgPf+1
         GN+A==
X-Forwarded-Encrypted: i=1; AJvYcCUIaOGr31JIBtaB0FGMrcDnCo+FNtCBDmDiy3NXew5mLG4dxYKgDr5rHQKD/O62vOZh7P+SfM7aRuZ8WQfPlN9hcL5VHRY7
X-Gm-Message-State: AOJu0YwF9fAadvP5tNu51AH9R1/USg4npwMfTStsdJ8d/sikODJlYLxv
	bzLnKv/ZZ9l8AQAkcZsFSXsdqi6ACh5iVcVjwAnfIpKfgjPSDzqfno0Rhok9jEPRG24F6GgBkoV
	DkA==
X-Google-Smtp-Source: AGHT+IGB88xDhOmLkYM8uO8zQxI10w4y/bqJWwoieXGYn8llJcu4nyCnZH6T1De8EEh7OBqPBXy+MKkQjwI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9298:b0:6e6:c3bc:721e with SMTP id
 jw24-20020a056a00929800b006e6c3bc721emr129688pfb.1.1710458829531; Thu, 14 Mar
 2024 16:27:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:35 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-17-seanjc@google.com>
Subject: [PATCH 16/18] KVM: selftests: Add macro for TSS selector, rename up
 code/data macros
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a proper #define for the TSS selector instead of open coding 0x18 and
hoping future developers don't use that selector for something else.

Opportunistically rename the code and data selector macros to shorten the
names, align the naming with the kernel's scheme, and capture that they
are *kernel* segments.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c       | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 03b9387a1d2e..67235013f6f9 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -15,8 +15,9 @@
 #define NUM_INTERRUPTS 256
 #endif
 
-#define DEFAULT_CODE_SELECTOR 0x8
-#define DEFAULT_DATA_SELECTOR 0x10
+#define KERNEL_CS	0x8
+#define KERNEL_DS	0x10
+#define KERNEL_TSS	0x18
 
 #define MAX_NR_CPUID_ENTRIES 100
 
@@ -547,11 +548,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
 	kvm_seg_set_unusable(&sregs.ldt);
-	kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
-	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
-	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
-	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
-	kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
+	kvm_seg_set_kernel_code_64bit(vm, KERNEL_CS, &sregs.cs);
+	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.ds);
+	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.es);
+	kvm_seg_set_kernel_data_64bit(NULL, KERNEL_DS, &sregs.gs);
+	kvm_setup_tss_64bit(vm, &sregs.tr, KERNEL_TSS);
 
 	sregs.cr3 = vm->pgd;
 	vcpu_sregs_set(vcpu, &sregs);
@@ -620,8 +621,7 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 
 	/* Handlers have the same address in both address spaces.*/
 	for (i = 0; i < NUM_INTERRUPTS; i++)
-		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
-			DEFAULT_CODE_SELECTOR);
+		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0, KERNEL_CS);
 
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
-- 
2.44.0.291.gc1ea87d7ee-goog

