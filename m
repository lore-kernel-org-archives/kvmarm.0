Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F87558136
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458834; cv=none; b=QBKYmNEQidKwAI1VhAi4rdl4hRS3wa7r2/rBOaADSx32XjlNq97RHWTxSxGx7Cd+Tt7r2I9M+1Z/yIs8BvyGhEhAJoigvwr7AmsTaVwyW2izbRcrWu+OxqrxaPF/+xUbGw8y7/HLuRrcqY4MNKukurw9q7vL35oEbxjjT0vgF/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458834; c=relaxed/simple;
	bh=qWhpgLuBEkNbF4sWd8Qyyuj/eXZbAUhHOG7QIgE936U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZDY9My9V5834msiSMnivj8Rf+7ev8GW9cZtyvlZPrZTygNT6HD7bthAMgPuG78TAJIssEn2/I66+u9PlCZkh8UFvpvspqIHYcEhvnR/hs7uOvmaPVuFCt8/IPvOjlZ8Q1283WimKx3eKc32WQjJD6ooDv1DCaS1HZIj5IwrXsoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KxUmME2W; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KxUmME2W"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e6b3bff094so1779375b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458831; x=1711063631; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IJnvo3GlUCWm+9Z87DTK6fPvvH2dyec9Q+4IWGvi0gE=;
        b=KxUmME2WlX8LHT9Of9ZIYNyZxX0guY8cBPjuklczphycNZr7J4at5T63S3ge+VMPwb
         3VdetecBeebxvEEGz0bGC6Wg2W4WJqzSS0PzTZwlQpoHPTgpt3mdFSYOxp8K5AQHdVMr
         gXMqHbIVyC3CVBkxTfJ4TNj5y5sA/6mOG6GOb4dOMYk+Tc6x+jfNl9hU5ExZTH65bsN1
         /r6vI8SGftCEyY4WEPWuIfpjC9m0oFznfVn1GutAeOLeBDnN757eChDTqLDqhnA32ncc
         oa6gAzxvetVcIkrnG1GiZNkirSrbMF1DkjgIbTcM3W/FNxcPjTaBNNVvh8Oa2AzLSJ4t
         Zoww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458831; x=1711063631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IJnvo3GlUCWm+9Z87DTK6fPvvH2dyec9Q+4IWGvi0gE=;
        b=GY8wE7X51MjxironCo+k2xQ3KRbF8yWJiOezpKRbkaPL05sYH2uDLMf67ucC5QUVL7
         pAttxuPNjHbfaHqfNE6YwycGL/dEXHQpumhQ2ad7h1HApmePyFrzO6/Hjqkr2DmIApvY
         xU0Nf+xiokBJ/92By3+OZny4XWAiTgF6lM8OKN/oZlRu5xwWOw2LQQYH4NuzHyHlettj
         zLP2kmui95ljdIhM8D8Vz1AzE6NCRdBSMbC35i3TOgjNQH7XoRLX66gOwbdkudpb2Ss9
         WwjeO18glfyRQicuCxSHPObngmwxjNDfFT2ZIQzrDL7NqwnC4vBZuy4NK32+AGQvobpi
         txYw==
X-Forwarded-Encrypted: i=1; AJvYcCX65yHLaS7UQ3NSFhZGLElmCA4sJDC9UuQM0bJKZXvV0upd2NI+/lNMn9XSIJrO34jy66iAWou9IbD6D7ZUzo6t49AsWbuW
X-Gm-Message-State: AOJu0YzTW8IyzGnq/syFmPKPMbIS65lMICdqJj4ct+dnAszmWdEi8+Dl
	mEuwSvxcGAwcje/EW9LNkO2FJZqVD7uX3HcVXy4FP35dwPHvezpxN+XVm3zeN0Mrq84GicEoSCj
	ttw==
X-Google-Smtp-Source: AGHT+IFXKsJZcktPEDJdv6TjhHXL21Zrt9AN04hKeTmJyyHIm5kk/8ldZSE0dO0H/MtumtcqHIdX1BiKE5Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:234c:b0:6e6:c38e:e9e3 with SMTP id
 j12-20020a056a00234c00b006e6c38ee9e3mr134457pfj.4.1710458831465; Thu, 14 Mar
 2024 16:27:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:36 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-18-seanjc@google.com>
Subject: [PATCH 17/18] KVM: selftests: Init x86's segments during VM creation
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

Initialize x86's various segments in the GDT during creation of relevant
VMs instead of waiting until vCPUs come along.  Re-installing the segments
for every vCPU is both wasteful and confusing, as is installing KERNEL_DS
multiple times; NOT installing KERNEL_DS for GS is icing on the cake.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 68 ++++++-------------
 1 file changed, 20 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 67235013f6f9..dab719ee7734 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -438,24 +438,7 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm, struct kvm_segment *segp)
 		desc->base3 = segp->base >> 32;
 }
 
-
-/*
- * Set Long Mode Flat Kernel Code Segment
- *
- * Input Args:
- *   vm - VM whose GDT is being filled, or NULL to only write segp
- *   selector - selector value
- *
- * Output Args:
- *   segp - Pointer to KVM segment
- *
- * Return: None
- *
- * Sets up the KVM segment pointed to by @segp, to be a code segment
- * with the selector value given by @selector.
- */
-static void kvm_seg_set_kernel_code_64bit(struct kvm_vm *vm, uint16_t selector,
-	struct kvm_segment *segp)
+static void kvm_seg_set_kernel_code_64bit(uint16_t selector, struct kvm_segment *segp)
 {
 	memset(segp, 0, sizeof(*segp));
 	segp->selector = selector;
@@ -467,27 +450,9 @@ static void kvm_seg_set_kernel_code_64bit(struct kvm_vm *vm, uint16_t selector,
 	segp->g = true;
 	segp->l = true;
 	segp->present = 1;
-	if (vm)
-		kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
-/*
- * Set Long Mode Flat Kernel Data Segment
- *
- * Input Args:
- *   vm - VM whose GDT is being filled, or NULL to only write segp
- *   selector - selector value
- *
- * Output Args:
- *   segp - Pointer to KVM segment
- *
- * Return: None
- *
- * Sets up the KVM segment pointed to by @segp, to be a data segment
- * with the selector value given by @selector.
- */
-static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
-	struct kvm_segment *segp)
+static void kvm_seg_set_kernel_data_64bit(uint16_t selector, struct kvm_segment *segp)
 {
 	memset(segp, 0, sizeof(*segp));
 	segp->selector = selector;
@@ -498,8 +463,6 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
 					  */
 	segp->g = true;
 	segp->present = true;
-	if (vm)
-		kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
@@ -517,16 +480,15 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
 }
 
-static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
-				int selector)
+static void kvm_seg_set_tss_64bit(vm_vaddr_t base, struct kvm_segment *segp,
+				  int selector)
 {
 	memset(segp, 0, sizeof(*segp));
-	segp->base = vm->arch.tss;
+	segp->base = base;
 	segp->limit = 0x67;
 	segp->selector = selector;
 	segp->type = 0xb;
 	segp->present = 1;
-	kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
 static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
@@ -548,11 +510,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
 	kvm_seg_set_unusable(&sregs.ldt);
-	kvm_seg_set_kernel_code_64bit(vm, KERNEL_CS, &sregs.cs);
-	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.ds);
-	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.es);
-	kvm_seg_set_kernel_data_64bit(NULL, KERNEL_DS, &sregs.gs);
-	kvm_setup_tss_64bit(vm, &sregs.tr, KERNEL_TSS);
+	kvm_seg_set_kernel_code_64bit(KERNEL_CS, &sregs.cs);
+	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.ds);
+	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.es);
+	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.gs);
+	kvm_seg_set_tss_64bit(vm->arch.tss, &sregs.tr, KERNEL_TSS);
 
 	sregs.cr3 = vm->pgd;
 	vcpu_sregs_set(vcpu, &sregs);
@@ -612,6 +574,7 @@ void route_exception(struct ex_regs *regs)
 static void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
 	extern void *idt_handlers;
+	struct kvm_segment seg;
 	int i;
 
 	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
@@ -624,6 +587,15 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0, KERNEL_CS);
 
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+
+	kvm_seg_set_kernel_code_64bit(KERNEL_CS, &seg);
+	kvm_seg_fill_gdt_64bit(vm, &seg);
+
+	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &seg);
+	kvm_seg_fill_gdt_64bit(vm, &seg);
+
+	kvm_seg_set_tss_64bit(vm->arch.tss, &seg, KERNEL_TSS);
+	kvm_seg_fill_gdt_64bit(vm, &seg);
 }
 
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
-- 
2.44.0.291.gc1ea87d7ee-goog

