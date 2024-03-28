Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2502C6A3
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 02:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594298; cv=none; b=RdpssbDoNJFkC+d/0lYZtzC6+sfDEM0eXFsr+HPaGtiay3partTbP1L4x9RfTOVAyxkYdOZgobaRNbkj5hsqnhtFzvplzf7MR6wpTBz1zbUIin8zdXnIFrig/UPCVkyrQar/tJyfpX+5/HOwrHAOzgW/qC5XUdwXCJwsjldSnnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594298; c=relaxed/simple;
	bh=eA5JpppvJ6kceU+mSDaXLnkO1NxsMOe5o4POmWSCqQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g1UdeckX6E1yxKfrznHezLprkwhIdRtm1NNwdsKOFuBYQD5lRUgkmeJsqQWCQBb8gYBbf9OUKV/qvk58fJbXN3I1xKXKjTRYd/ladgNVLpPPSHZ0z/VZHBRoC1UjX1KNor7qYb85dNFn7EvOQVwYKS0GMPdpE+Frah2UHBkSoy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QX/Xjvyz; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QX/Xjvyz"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so702212276.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 19:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594296; x=1712199096; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GPqMDjWy6wn0n2FZzL74JwLmXN+yXA5I0HEhcS2w7RY=;
        b=QX/XjvyzgmEXk1Aarnm1U8YwgT20h9ju7XbQUguSwcmeQ1JaCFuS6hSuJv8FWOcKxT
         qHQI4KwHtcSBfYZa0upBRfPlRy7uhfChYyaM7/+0rYR89Iru/SeAX4QLfCOEXlvl7zRn
         w6pqrt971bgXVWmO0pWcGt1bavW3njS64EIwXG3WmrLbIyEh7aLenOdgQaqCf7s38/XH
         gqLTSh8/Is24g9gOH4Nrec3tTp93y+aESx2WauX0i1CoYHD3EUYe5afp/1VkvPwpkwzr
         WEFOVn5yhKVCgdZ1wD6RBUn3TGY3D/V794HEz32TWPyxrK4eWUU2nxeiR82x25/Td0z3
         EPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594296; x=1712199096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GPqMDjWy6wn0n2FZzL74JwLmXN+yXA5I0HEhcS2w7RY=;
        b=J3uS9am7Y+sAOe8OApfKMX0mMkWAIPo47mCGS+/sLYAFWIxer02CAeuPozEqg+FVF+
         k0kNEOjo/wszfV21BIOCBjjuzvisW17n2RIN5Q0BSGPXb8eyuUo9+eff3Ew2KT1fQlcT
         3X70lvRoshCd4uY4eRhsCgIXxm8brZJ0CPmAgQJP9grkTMqmW5EcBGQxD+LLc8QkJ1N6
         6NaNgmOE5CBBqcD7EnPi7EwhsrHZf7vETMw7+crgWBSxjBvb60zlauKBtxxX70iGsHPL
         jfGqyrZlSxdbUCuFRewVlHiTrVjfzFRl6lPvy+L/h33dBtcZ/kMMPL/Dl+3mDthfdpYJ
         704w==
X-Forwarded-Encrypted: i=1; AJvYcCXHrwECswNoJEOQwseWQp7Ak6Xy2Qkr2gffZ2rbMCyDO83qFeJp2465Ap1P7mLgSWK4BmrjSjTCi0FHJnPFsu+qmpT/Ufag
X-Gm-Message-State: AOJu0YwWYD1YEa/E6XDDQBCLx1g0ZAiTygGeoWWGY9XV0e6526Hba6IY
	FS/3x4CYu9GeaBAshOgab5t+fYIqgfUTmvM+em++tZtjcJzTTQ34lJ2V0KgoMhqU3ucEgwmd+Bf
	jyJPWQBYO+TrxUxn18w5AZw==
X-Google-Smtp-Source: AGHT+IGFZmR4DArDG/NiA9ExmfCagEMse7zkswaIi6bIPylpTBQr9g34FYNoKtBSJzzIGs2vwHFOUILMvq3sP4hMdA==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:1009:b0:dcc:8927:7496 with
 SMTP id w9-20020a056902100900b00dcc89277496mr155809ybt.5.1711594296369; Wed,
 27 Mar 2024 19:51:36 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:51:32 +0000
In-Reply-To: <20240314232637.2538648-18-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-18-seanjc@google.com>
Message-ID: <diqz7chnkr0r.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 17/18] KVM: selftests: Init x86's segments during VM creation
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Initialize x86's various segments in the GDT during creation of relevant
> VMs instead of waiting until vCPUs come along.  Re-installing the segments
> for every vCPU is both wasteful and confusing, as is installing KERNEL_DS
> multiple times; NOT installing KERNEL_DS for GS is icing on the cake.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 68 ++++++-------------
>  1 file changed, 20 insertions(+), 48 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 67235013f6f9..dab719ee7734 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -438,24 +438,7 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm, struct kvm_segment *segp)
>  		desc->base3 = segp->base >> 32;
>  }
>  
> -
> -/*
> - * Set Long Mode Flat Kernel Code Segment
> - *
> - * Input Args:
> - *   vm - VM whose GDT is being filled, or NULL to only write segp
> - *   selector - selector value
> - *
> - * Output Args:
> - *   segp - Pointer to KVM segment
> - *
> - * Return: None
> - *
> - * Sets up the KVM segment pointed to by @segp, to be a code segment
> - * with the selector value given by @selector.
> - */
> -static void kvm_seg_set_kernel_code_64bit(struct kvm_vm *vm, uint16_t selector,
> -	struct kvm_segment *segp)
> +static void kvm_seg_set_kernel_code_64bit(uint16_t selector, struct kvm_segment *segp)
>  {
>  	memset(segp, 0, sizeof(*segp));
>  	segp->selector = selector;
> @@ -467,27 +450,9 @@ static void kvm_seg_set_kernel_code_64bit(struct kvm_vm *vm, uint16_t selector,
>  	segp->g = true;
>  	segp->l = true;
>  	segp->present = 1;
> -	if (vm)
> -		kvm_seg_fill_gdt_64bit(vm, segp);
>  }
>  
> -/*
> - * Set Long Mode Flat Kernel Data Segment
> - *
> - * Input Args:
> - *   vm - VM whose GDT is being filled, or NULL to only write segp
> - *   selector - selector value
> - *
> - * Output Args:
> - *   segp - Pointer to KVM segment
> - *
> - * Return: None
> - *
> - * Sets up the KVM segment pointed to by @segp, to be a data segment
> - * with the selector value given by @selector.
> - */
> -static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
> -	struct kvm_segment *segp)
> +static void kvm_seg_set_kernel_data_64bit(uint16_t selector, struct kvm_segment *segp)
>  {
>  	memset(segp, 0, sizeof(*segp));
>  	segp->selector = selector;
> @@ -498,8 +463,6 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
>  					  */
>  	segp->g = true;
>  	segp->present = true;
> -	if (vm)
> -		kvm_seg_fill_gdt_64bit(vm, segp);
>  }
>  
>  vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> @@ -517,16 +480,15 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
>  }
>  
> -static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
> -				int selector)
> +static void kvm_seg_set_tss_64bit(vm_vaddr_t base, struct kvm_segment *segp,
> +				  int selector)
>  {
>  	memset(segp, 0, sizeof(*segp));
> -	segp->base = vm->arch.tss;
> +	segp->base = base;
>  	segp->limit = 0x67;
>  	segp->selector = selector;
>  	segp->type = 0xb;
>  	segp->present = 1;
> -	kvm_seg_fill_gdt_64bit(vm, segp);
>  }
>  
>  static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> @@ -548,11 +510,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
>  
>  	kvm_seg_set_unusable(&sregs.ldt);
> -	kvm_seg_set_kernel_code_64bit(vm, KERNEL_CS, &sregs.cs);
> -	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.ds);
> -	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.es);
> -	kvm_seg_set_kernel_data_64bit(NULL, KERNEL_DS, &sregs.gs);
> -	kvm_setup_tss_64bit(vm, &sregs.tr, KERNEL_TSS);
> +	kvm_seg_set_kernel_code_64bit(KERNEL_CS, &sregs.cs);
> +	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.ds);
> +	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.es);
> +	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.gs);
> +	kvm_seg_set_tss_64bit(vm->arch.tss, &sregs.tr, KERNEL_TSS);
>  
>  	sregs.cr3 = vm->pgd;
>  	vcpu_sregs_set(vcpu, &sregs);
> @@ -612,6 +574,7 @@ void route_exception(struct ex_regs *regs)
>  static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  {
>  	extern void *idt_handlers;
> +	struct kvm_segment seg;
>  	int i;
>  
>  	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> @@ -624,6 +587,15 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0, KERNEL_CS);
>  
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
> +
> +	kvm_seg_set_kernel_code_64bit(KERNEL_CS, &seg);
> +	kvm_seg_fill_gdt_64bit(vm, &seg);
> +
> +	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &seg);
> +	kvm_seg_fill_gdt_64bit(vm, &seg);
> +
> +	kvm_seg_set_tss_64bit(vm->arch.tss, &seg, KERNEL_TSS);
> +	kvm_seg_fill_gdt_64bit(vm, &seg);
>  }
>  
>  void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
