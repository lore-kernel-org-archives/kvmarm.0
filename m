Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEC9250E0
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 02:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594282; cv=none; b=prqHQrfcQ5IvmfB+nH126LS15Zlp8KAmskdN6lf2VDzi5MbJ6TpFfnV+xcGzQXkBh+EyCEAzI1OQMKjA/KBLj3gkW6VWEuHDcMGhmCNJpDyGH8C+NZ/cMe1t+tLzJdMJHjIDYlqdQns6VC3SC+cOv0q3ObIRRkONyHzHQBK5blU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594282; c=relaxed/simple;
	bh=XIZ4f6D2msngrjo5E1BaCoNab5/MCdBimgyNp63AH30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WUKmpZBaUW3ltq+5bAdWCspGxXIpoPmfYASDDCD93Um86ibmtjh/ORLA8N+mdvsTRIhlrk0WZNOu3FasPMvdRYljhaTRFo0txanpFQCapJ/YSR6LBO9KZ8dD1EVt3zDGM4tZAsxhairdVEDFuLpWhKGZIkWV+XGCpPaapw1cqJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hu/vm8iU; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hu/vm8iU"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-613f563def5so8614377b3.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 19:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594280; x=1712199080; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/4Ns6gaSo4Qq0IcoiML7N509X1eCvl6xcmeeJxScUyE=;
        b=Hu/vm8iUMMy+XCjRkatEtb5evO3N7S4oBqBoaxajbF3aeimdLQiTqAUCAv9Gu11vqL
         cwUYIFcKYepgjWurFzFSnPyA6+3HN4R0rhrnfbErp8+Mo6nm+YTNDj27kxMnR8V4NpbX
         3xb2GKedK7XvfT1cHRB+dZb0DAUckHTpmRwC0F8h+FzTwxOOAZv02PYYVuch4rSnvzyY
         /LfMMd3qvNV/WK1939DaeAZXIXJKiwpMuZBOE/LB7/7OhwIhqnpAQADdSd3Gyq2TkMN2
         1mQcOR1mWXHRu03MnTsVfRNFIz0YvvlTRYGcJmOG+lb57uhzkiLcME68Cz6V5bpKwFfG
         R/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594280; x=1712199080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/4Ns6gaSo4Qq0IcoiML7N509X1eCvl6xcmeeJxScUyE=;
        b=hQ20M2n/tNl8/Un0GnXT9ifG7Tpl8ve5QJMEKHOB9CAerS6iqYtEx/cx1j4uuskLDH
         DAwmRD6w3nWjK2uYtK3wnHecMlywNv3aol5egeqhgdxA9QsNkl1jldm+wd1hWL1MATIh
         RSbfm9hUVZWHZMCZhluBcT1YwzqGVfMIlqtj2RwGZuvhKFZCXbm3HVhvSNOli4tVKw2S
         4HHcI+DFGQEj1WzF3SC/svbAPWF8ttLnvV05hg+XV0t2ESt6XvSy4065wgakc4/k9JOd
         fMU25yEJMCKmkULk/g+1sIxKIF8tB24Y3SPx4lS7QXe2MSWMyU+MgRr8qOx3VHYqf/8c
         U1nw==
X-Forwarded-Encrypted: i=1; AJvYcCX1w5XEiOQUNdYtSUWcUT9iRitbjXdZD6FXxbmT4g6acAv/eq+hxTX7pFGp9wLjoD2PEssCAGZfbWSpb5qzrwlM2ay6pYOK
X-Gm-Message-State: AOJu0YzLe+e03n94/zK33mSTKY1G5k8Hzh1AhVX9CrJqfksdb5OkJkPt
	llsNpBTfWkEug6Y5mIO3/F77IgIMHaP9evOj7DuHyh6QUbEZxDA1f+NIFoHAkMONR0eiN8XZsvs
	VLXzRmJAl5YwbxGDDH3uCfw==
X-Google-Smtp-Source: AGHT+IFq6RvNgKKDrmQGX8FbWbPutEMqrYZ/mRuBwk+vhXh9Fho0CVv4hcycTp/A4TYnzMSkOeSkeap9+3BP7uh0Rw==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a81:6d43:0:b0:611:7358:6fa9 with SMTP
 id i64-20020a816d43000000b0061173586fa9mr298635ywc.0.1711594279878; Wed, 27
 Mar 2024 19:51:19 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:51:15 +0000
In-Reply-To: <20240314232637.2538648-19-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-19-seanjc@google.com>
Message-ID: <diqza5mjkr18.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 18/18] KVM: selftests: Drop @selector from segment helpers
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

> Drop the @selector from the kernel code, data, and TSS builders and
> instead hardcode the respective selector in the helper.  Accepting a
> selector but not a base makes the selector useless, e.g. the data helper
> can't create per-vCPU for FS or GS, and so loading GS with KERNEL_DS is
> the only logical choice.
>
> And for code and TSS, there is no known reason to ever want multiple
> segments, e.g. there are zero plans to support 32-bit kernel code (and
> again, that would require more than just the selector).
>
> If KVM selftests ever do add support for per-vCPU segments, it'd arguably
> be more readable to add a dedicated helper for building/setting the
> per-vCPU segment, and move the common data segment code to an inner
> helper.
>
> Lastly, hardcoding the selector reduces the probability of setting the
> wrong selector in the vCPU versus what was created by the VM in the GDT.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 29 +++++++++----------
>  1 file changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index dab719ee7734..6abd50d6e59d 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -438,10 +438,10 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm, struct kvm_segment *segp)
>  		desc->base3 = segp->base >> 32;
>  }
>  
> -static void kvm_seg_set_kernel_code_64bit(uint16_t selector, struct kvm_segment *segp)
> +static void kvm_seg_set_kernel_code_64bit(struct kvm_segment *segp)
>  {
>  	memset(segp, 0, sizeof(*segp));
> -	segp->selector = selector;
> +	segp->selector = KERNEL_CS;
>  	segp->limit = 0xFFFFFFFFu;
>  	segp->s = 0x1; /* kTypeCodeData */
>  	segp->type = 0x08 | 0x01 | 0x02; /* kFlagCode | kFlagCodeAccessed
> @@ -452,10 +452,10 @@ static void kvm_seg_set_kernel_code_64bit(uint16_t selector, struct kvm_segment
>  	segp->present = 1;
>  }
>  
> -static void kvm_seg_set_kernel_data_64bit(uint16_t selector, struct kvm_segment *segp)
> +static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
>  {
>  	memset(segp, 0, sizeof(*segp));
> -	segp->selector = selector;
> +	segp->selector = KERNEL_DS;
>  	segp->limit = 0xFFFFFFFFu;
>  	segp->s = 0x1; /* kTypeCodeData */
>  	segp->type = 0x00 | 0x01 | 0x02; /* kFlagData | kFlagDataAccessed
> @@ -480,13 +480,12 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
>  }
>  
> -static void kvm_seg_set_tss_64bit(vm_vaddr_t base, struct kvm_segment *segp,
> -				  int selector)
> +static void kvm_seg_set_tss_64bit(vm_vaddr_t base, struct kvm_segment *segp)
>  {
>  	memset(segp, 0, sizeof(*segp));
>  	segp->base = base;
>  	segp->limit = 0x67;
> -	segp->selector = selector;
> +	segp->selector = KERNEL_TSS;
>  	segp->type = 0xb;
>  	segp->present = 1;
>  }
> @@ -510,11 +509,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
>  
>  	kvm_seg_set_unusable(&sregs.ldt);
> -	kvm_seg_set_kernel_code_64bit(KERNEL_CS, &sregs.cs);
> -	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.ds);
> -	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.es);
> -	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &sregs.gs);
> -	kvm_seg_set_tss_64bit(vm->arch.tss, &sregs.tr, KERNEL_TSS);
> +	kvm_seg_set_kernel_code_64bit(&sregs.cs);
> +	kvm_seg_set_kernel_data_64bit(&sregs.ds);
> +	kvm_seg_set_kernel_data_64bit(&sregs.es);
> +	kvm_seg_set_kernel_data_64bit(&sregs.gs);
> +	kvm_seg_set_tss_64bit(vm->arch.tss, &sregs.tr);
>  
>  	sregs.cr3 = vm->pgd;
>  	vcpu_sregs_set(vcpu, &sregs);
> @@ -588,13 +587,13 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  
> -	kvm_seg_set_kernel_code_64bit(KERNEL_CS, &seg);
> +	kvm_seg_set_kernel_code_64bit(&seg);
>  	kvm_seg_fill_gdt_64bit(vm, &seg);
>  
> -	kvm_seg_set_kernel_data_64bit(KERNEL_DS, &seg);
> +	kvm_seg_set_kernel_data_64bit(&seg);
>  	kvm_seg_fill_gdt_64bit(vm, &seg);
>  
> -	kvm_seg_set_tss_64bit(vm->arch.tss, &seg, KERNEL_TSS);
> +	kvm_seg_set_tss_64bit(vm->arch.tss, &seg);
>  	kvm_seg_fill_gdt_64bit(vm, &seg);
>  }
>  
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
