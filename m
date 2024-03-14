Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B860554FA0
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458830; cv=none; b=CNYrxWLOOOHdljcvNl7Ry952NaYWvljJE1DVbjbM+ebTm65VOjuuR8DY7120M0BMB5APQXLeqfJT1lJXiaYJoMyRPjbXV64gGcTs1tiXeMeUPJ2pITexT6eCW6Z+bFm6QzbdjuJZtN/Wa7wXwZx25SE8pcvTpinTH6FsnzH2gzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458830; c=relaxed/simple;
	bh=jUV1XZXOApDn8WUrRGJsIujEhPRAE62JvDa/WRT16zw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I9Hwntw52di28OYqoXRa9Tj/cNYkqgimCG95MyBYdOhaV7zALR1/FIWQP6MxvjaykR+YdMbDM8KDswaCsvtp4Oo9+TDxJdjkIZDKvg+qGIXwRbSAdfz+vmbqhb5OhJjzgEXnQnvpkPfNDIJQLFd0Pr3RCqt5pjKrO/MXrTwEOEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nV3kY/v6; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nV3kY/v6"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a2b53b99eso33273527b3.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458828; x=1711063628; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uF6G18lAXQi7SGjNgTcxotaL8n8pv6tjDstW0Eyh3/8=;
        b=nV3kY/v6FigfAJDslhY0nqERxMldLAKrpV96yomdLs/P7UIuTH1GB3nZZ9q0L/RDX6
         +UEUKq4JcMqbR02/y4sM5Y1IN1qrJ6VKbdBrg8LLxY8jrdRt5nw2kJT3IjCcLK6NaixO
         ZTbl+srB3IuwlxwHjInG+WAeaZeyKz9pcaXYdb0ViNCBCF7vk6Ecr317iIrntHtBqCDl
         PM3DbrHo11oIRMJvTFMSMGptwEYJX5P9RNxNxg/t6caVYAoUmV/hOlHMPyCcusQRJ8s0
         mRCBeSE4z30ZS6MplEB71Gp8VhfjDso0lMKwySkzJtUJYPj51fP/O2TGXXxO5DSI5Qm5
         GGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458828; x=1711063628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uF6G18lAXQi7SGjNgTcxotaL8n8pv6tjDstW0Eyh3/8=;
        b=eHHfyxqfzrJ/sLT5JNIQJM4o1z1QjoSuysmnROMf6gVy2D4UcHNBSRAVS1fC9KHvW9
         X8sWC0OaDr7EW5wXax6EwhhGXA3yPvM+ttcvTJqXR7///MJsqCP6OmKXGVhKWmVRWuhd
         xYc5EQpVQF0mSevVdGqBk6uQ19Tx/Z+m/0TiplDZUD6lUFT+G/RX1jmod0gaTPYi6ziX
         2CROh/DX/dqnB7TvrqVv5RUUCsGnheez4qQ6MALgmatexO6R18gQZTRXWZG+AOmjrs5/
         JHbXNl7eecZRiOHlwA8zKHsJqVtU/+7B/CB4/2CBEn3n9+uWZaEs7JJ3wuKd0UHB59G8
         PmgA==
X-Forwarded-Encrypted: i=1; AJvYcCXVbTNqmOS2nJRojPx7gpMBRuezuD7IEw2pYpoQFx08HmphqlWOcN3LufFRXiNKKtapCWXlYcUglOXWhWxxaD698UY6xtpr
X-Gm-Message-State: AOJu0YwZI6HUxMK8fiGE5S/VxlLdqqorMsrkEo+LfDZG4n/lc9UI9ex7
	YXQgiY9lXdHupf92Y2liH1E95vQWd3AIAPk3tJw94PWeQrS2PYVSTUUP0bX2b4k2m3XUstaaxju
	8aA==
X-Google-Smtp-Source: AGHT+IGMAa0pMvN41GmLVswUQh74G2T7pDQzvawBbi03BR+h8KyfNdFr8QIGXJ12aJ6DdfK8GuReLQ77fHo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d5:b0:dc7:68b5:4f21 with SMTP id
 ck21-20020a05690218d500b00dc768b54f21mr168369ybb.9.1710458827844; Thu, 14 Mar
 2024 16:27:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:34 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-16-seanjc@google.com>
Subject: [PATCH 15/18] KVM: selftests: Allocate x86's TSS at VM creation
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

Allocate x86's per-VM TSS at creation of a non-barebones VM.  Like the
GDT, the TSS is needed to actually run vCPUs, i.e. every non-barebones VM
is all but guaranteed to allocate the TSS sooner or later.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 5cf845975f66..03b9387a1d2e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -519,9 +519,6 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 				int selector)
 {
-	if (!vm->arch.tss)
-		vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
-
 	memset(segp, 0, sizeof(*segp));
 	segp->base = vm->arch.tss;
 	segp->limit = 0x67;
@@ -619,6 +616,8 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
 	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
 	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
+	vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
+
 	/* Handlers have the same address in both address spaces.*/
 	for (i = 0; i < NUM_INTERRUPTS; i++)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
-- 
2.44.0.291.gc1ea87d7ee-goog

