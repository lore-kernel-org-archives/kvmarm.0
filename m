Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADFA250E2
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458816; cv=none; b=B3DokLdMI4lj3k6LLicdnxkz+H+IUUHrj3cjVdSAtizO3LGI0MEg3asxv1oWUPhmfydwSSFcEqqgL8LnJOPR2BAnTxbSaYGLKAcVibHIzhbq4qlVq0fM+/Yq+UmXBarDbHULR/HiXYnJW7XYzNKyh4DrnKXM99nP/O0pqYCL9Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458816; c=relaxed/simple;
	bh=D6rTKBL1Fq2w6V4jF48WMytPJlDVkKznNk4kApfQjLA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=icmBLMilkUf4blym7SSwNMLCfm9DeXT5OMaMuufQBNjL3YSeKkiA1sgmCZGQhywzlxD9EZz7hF3YBnOrWtFT34pYQ3+xKTjmalCx1KTZSbgbuQWcW4a4yBaT8lcp0F67ZrpchAe7HMz1LpU8i9cr+gy7QU4iNvnh4vFo5X/cRhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0bwL02Ql; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0bwL02Ql"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-29b8f83c027so1281160a91.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458815; x=1711063615; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cYt0UxRFPQqzYn7Vpx6g+tvPS4Iw5cklVXoJXhkYY7M=;
        b=0bwL02QlmjHOv5KEG97a1P6x/XAAQfLSY7fssOT2TpzutewyGNtI9KVYpy+446I+uT
         9U8UrIy4ntGby3sgRh/HvyKNkE/fsPuecPu2nbjruZ8uYApWjUF0dbmzvoQ8eiA5Yc94
         OjmuQqVaUnfhqeC4gBdZwXHmPEq2HEJr8LXXZwm0tSPtS0jWUdAHlmxDQWaoOB2KoZs4
         KfowNuAu1ms/efrHsKTz7rTQpwKMoFejslZAQlYSn6rbcxX3gucxY3ttSDhh1W7U2oD4
         nlEqnL+WYVLgsWgE300wbnZr7JHJYek2duBQdxy4ZEclS8XdpzLi5zNdfEI3wh14ZS/O
         +qGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458815; x=1711063615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cYt0UxRFPQqzYn7Vpx6g+tvPS4Iw5cklVXoJXhkYY7M=;
        b=HRKUWaO52iMpv3d7DYzWtOb+0NL7FoFoti22P2nxCifYsnfY/9N6aoPnc6SF0mA+OL
         xxrwld+Z1ZzBp4hy0aKNwi9eWl2PSb+ZsDvI+Dc9/p97e0V+gvfs9IEP8SW2qBZcj1uW
         w0eUR0LM3f6jBV1vr+ynW14RHpCyoOu7gyxKS9jN3PtjHvpi1qMWWlcXLH4RsJauCghc
         kIkpAO93BjXTmMA9p2WS7KlOnb7xP7X0A3OZTibMvItEK1ax2YxeVpPlFWqTzszy6tmL
         CC4Yh6+t71jW236uCo+8rSzIRYOtx29AG10aevty9BNHCIVOx2PS8LJdktYXzN9CpsrJ
         atnA==
X-Forwarded-Encrypted: i=1; AJvYcCX4utR5AbSkhCu6cl557fNY7niOzuh2PHzHJhXhpnthjT5vXbsDlS/AWj2x6PGoWMcbBqoZoVsiH/V1OtQ5/9pSb93QYALO
X-Gm-Message-State: AOJu0YxUxYJDaNFfFa3ub/bHe5de5jAQUYvYec8Eoe6KyiYLFaimlutL
	+i44GjpBC/mFLxjav8Iy1mi0fRbiz2eWybn97LBIY29FCK6GWlTyt1zxfczHZqs0AAw4Eid1BMF
	70Q==
X-Google-Smtp-Source: AGHT+IFrr0eJ7KJEPLhApMpHRts0gPRzkT9mvlTzswaB+7MaMjHLiz+sM47iUPlzqqkPyfHstCgHwuftTuc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:bc94:b0:29b:c2b7:7d29 with SMTP id
 x20-20020a17090abc9400b0029bc2b77d29mr3418pjr.9.1710458814574; Thu, 14 Mar
 2024 16:26:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:27 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-9-seanjc@google.com>
Subject: [PATCH 08/18] KVM: selftests: Move x86's descriptor table helpers
 "up" in processor.c
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

Move x86's various descriptor table helpers in processor.c up above
kvm_arch_vm_post_create() and vcpu_setup() so that the helpers can be
made static and invoked from the aforementioned functions.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 191 +++++++++---------
 1 file changed, 95 insertions(+), 96 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index eaeba907bb53..3640d3290f0a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -540,6 +540,21 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 	kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
+void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vm *vm = vcpu->vm;
+	struct kvm_sregs sregs;
+
+	vcpu_sregs_get(vcpu, &sregs);
+	sregs.idt.base = vm->arch.idt;
+	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
+	sregs.gdt.base = vm->arch.gdt;
+	sregs.gdt.limit = getpagesize() - 1;
+	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
+	vcpu_sregs_set(vcpu, &sregs);
+	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+}
+
 static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	struct kvm_sregs sregs;
@@ -572,6 +587,86 @@ static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	vcpu_sregs_set(vcpu, &sregs);
 }
 
+static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
+			  int dpl, unsigned short selector)
+{
+	struct idt_entry *base =
+		(struct idt_entry *)addr_gva2hva(vm, vm->arch.idt);
+	struct idt_entry *e = &base[vector];
+
+	memset(e, 0, sizeof(*e));
+	e->offset0 = addr;
+	e->selector = selector;
+	e->ist = 0;
+	e->type = 14;
+	e->dpl = dpl;
+	e->p = 1;
+	e->offset1 = addr >> 16;
+	e->offset2 = addr >> 32;
+}
+
+static bool kvm_fixup_exception(struct ex_regs *regs)
+{
+	if (regs->r9 != KVM_EXCEPTION_MAGIC || regs->rip != regs->r10)
+		return false;
+
+	if (regs->vector == DE_VECTOR)
+		return false;
+
+	regs->rip = regs->r11;
+	regs->r9 = regs->vector;
+	regs->r10 = regs->error_code;
+	return true;
+}
+
+void route_exception(struct ex_regs *regs)
+{
+	typedef void(*handler)(struct ex_regs *);
+	handler *handlers = (handler *)exception_handlers;
+
+	if (handlers && handlers[regs->vector]) {
+		handlers[regs->vector](regs);
+		return;
+	}
+
+	if (kvm_fixup_exception(regs))
+		return;
+
+	ucall_assert(UCALL_UNHANDLED,
+		     "Unhandled exception in guest", __FILE__, __LINE__,
+		     "Unhandled exception '0x%lx' at guest RIP '0x%lx'",
+		     regs->vector, regs->rip);
+}
+
+void vm_init_descriptor_tables(struct kvm_vm *vm)
+{
+	extern void *idt_handlers;
+	int i;
+
+	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
+	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
+	/* Handlers have the same address in both address spaces.*/
+	for (i = 0; i < NUM_INTERRUPTS; i++)
+		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
+			DEFAULT_CODE_SELECTOR);
+}
+
+void vm_install_exception_handler(struct kvm_vm *vm, int vector,
+			       void (*handler)(struct ex_regs *))
+{
+	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
+
+	handlers[vector] = (vm_vaddr_t)handler;
+}
+
+void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	if (get_ucall(vcpu, &uc) == UCALL_UNHANDLED)
+		REPORT_GUEST_ASSERT(uc);
+}
+
 void kvm_arch_vm_post_create(struct kvm_vm *vm)
 {
 	vm_create_irqchip(vm);
@@ -1087,102 +1182,6 @@ void kvm_init_vm_address_properties(struct kvm_vm *vm)
 	}
 }
 
-static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
-			  int dpl, unsigned short selector)
-{
-	struct idt_entry *base =
-		(struct idt_entry *)addr_gva2hva(vm, vm->arch.idt);
-	struct idt_entry *e = &base[vector];
-
-	memset(e, 0, sizeof(*e));
-	e->offset0 = addr;
-	e->selector = selector;
-	e->ist = 0;
-	e->type = 14;
-	e->dpl = dpl;
-	e->p = 1;
-	e->offset1 = addr >> 16;
-	e->offset2 = addr >> 32;
-}
-
-
-static bool kvm_fixup_exception(struct ex_regs *regs)
-{
-	if (regs->r9 != KVM_EXCEPTION_MAGIC || regs->rip != regs->r10)
-		return false;
-
-	if (regs->vector == DE_VECTOR)
-		return false;
-
-	regs->rip = regs->r11;
-	regs->r9 = regs->vector;
-	regs->r10 = regs->error_code;
-	return true;
-}
-
-void route_exception(struct ex_regs *regs)
-{
-	typedef void(*handler)(struct ex_regs *);
-	handler *handlers = (handler *)exception_handlers;
-
-	if (handlers && handlers[regs->vector]) {
-		handlers[regs->vector](regs);
-		return;
-	}
-
-	if (kvm_fixup_exception(regs))
-		return;
-
-	ucall_assert(UCALL_UNHANDLED,
-		     "Unhandled exception in guest", __FILE__, __LINE__,
-		     "Unhandled exception '0x%lx' at guest RIP '0x%lx'",
-		     regs->vector, regs->rip);
-}
-
-void vm_init_descriptor_tables(struct kvm_vm *vm)
-{
-	extern void *idt_handlers;
-	int i;
-
-	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
-	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
-	/* Handlers have the same address in both address spaces.*/
-	for (i = 0; i < NUM_INTERRUPTS; i++)
-		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
-			DEFAULT_CODE_SELECTOR);
-}
-
-void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
-{
-	struct kvm_vm *vm = vcpu->vm;
-	struct kvm_sregs sregs;
-
-	vcpu_sregs_get(vcpu, &sregs);
-	sregs.idt.base = vm->arch.idt;
-	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
-	sregs.gdt.base = vm->arch.gdt;
-	sregs.gdt.limit = getpagesize() - 1;
-	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
-	vcpu_sregs_set(vcpu, &sregs);
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
-}
-
-void vm_install_exception_handler(struct kvm_vm *vm, int vector,
-			       void (*handler)(struct ex_regs *))
-{
-	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
-
-	handlers[vector] = (vm_vaddr_t)handler;
-}
-
-void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
-{
-	struct ucall uc;
-
-	if (get_ucall(vcpu, &uc) == UCALL_UNHANDLED)
-		REPORT_GUEST_ASSERT(uc);
-}
-
 const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
 					       uint32_t function, uint32_t index)
 {
-- 
2.44.0.291.gc1ea87d7ee-goog

