Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4D12BAF0
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 02:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594366; cv=none; b=FzSCOBY8ej5KCfdsufcbWPA1gHm1RUsVL48y2CJRhM6PGrWMTKlOSk+AwEpJ+NoMDc5QdmWawqAohPOQG8q8rlySj0LsZkYghihx9cU0uyy3j42my9OiyHArtfikSCiXz56RVQpLqE+ga3zqOSQIl3p1FDLJuQGlVicMiCUhvos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594366; c=relaxed/simple;
	bh=ykf7Ad9a1dePCbqY5SnqMxWyPGzdcdR0pVcX9fx1Jrc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CvNORA/2pT2zWHI97xa7C7kHOv7KPdMobck2TY9EMLueFCi5GM8qkLK6s7OcGlVHfjZ/80iTv/P5uEr0DmrT4KUP+NcjRZZxnnnD7qMtm3FfHAEVIxAZb3TOnecImltHxr34h+uHXoGbha8HBCoiaP4PVmdMHSeeKj0MwuaRQFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LPJRcxXR; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LPJRcxXR"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ddaf165a8d9so729017276.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 19:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594364; x=1712199164; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pg1Koe+Yskb8UPW0Ibn6wgFaDBKMELyCNXaqBSGpiIg=;
        b=LPJRcxXRkCSuUiQxwSSGthpve6mwMJHCxfCTTvZITSYZvuAC8jEM65B/L2M5Ja8Pbb
         S1lXBqNarHU18qiF4XwW24h0UF4TRqPwxo3OHlKJg6p05U9/t/RwHtG3/qqDUkbss763
         dhSf6SEUIgnzCL9E61XApRYPsn41wDRCwgYWxw9x29Mzhnc8Fvi6xBceTJ1bikWnEoTO
         eMRKXVooR7SkfqRsj8UTt1tQjpvjZ4VRFoRiJL32HgBrhRvg4dGhm1V+yhfyucQF8qc3
         48S7nRP1l0c2PJbHCyrCTNR+m/xcRsPwefQvulwUoEwqTiwgdE3i+L8H6TuT6m4c1hhU
         xCPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594364; x=1712199164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pg1Koe+Yskb8UPW0Ibn6wgFaDBKMELyCNXaqBSGpiIg=;
        b=afYuGWWWytpoVQbfLoSzYENWir7/Try/TeDFggOkKPmKA1fxn3nSqfTino1Ksmp8Jh
         16TOV/S50wOObvAaoaD8zxAz2Wk+qleqUpD3DvvTJ4oBKbC49/OkUvC4Wq3Bm+stbHf8
         YTJ3uyN7nzBaskT7FwB8FQh9yU1Iwqk0/BM8XH0NBFU8UZB1/63Qg4Y6Rqqt3TuIgehm
         3ZXMgmR9/rGnvxNlM3Toh4IbRwKQrJTfoVhJBmx5k3q8MYdQy4rMevCmj7VqawUMEkTU
         ArFiWDUdRCTCUdSdELW8w78JNrZ8GT3+P+i7H5pmWmGyw3umcvFDPn9vjZNBjSectop3
         YN4g==
X-Forwarded-Encrypted: i=1; AJvYcCVp3VMyvsJzEQ9N3tzUkB6VHF/14KoEJEygonpcsYa7FCf7NfCSwPCMclY9Q+k2AW9iC1My6qOhQtAuFWpqMR6wxbM7DoSk
X-Gm-Message-State: AOJu0YzxZ+Fjc4pIUweXcJPvV4bIMgu/k75NUyjUMOHheBT4Le4/qpZT
	A0hRHH1utiEt6RTnegZcsCfJ+XSGAJI+duTFpzrmV+G/Ibd6YMeWL2oHoYLSsweS1WKr6cLuCde
	CbHSVAWZCxqKKlCQlnxKY4w==
X-Google-Smtp-Source: AGHT+IGamct0CFbVaOo18kFqPCJIWWo6VB9ZmUglKKzir5OBthVLSFpJRBv0Ez69oxdAsU/6PDiZ+aH4G55jCyDSpg==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:124c:b0:dcc:8be2:7cb0 with
 SMTP id t12-20020a056902124c00b00dcc8be27cb0mr125722ybu.0.1711594363911; Wed,
 27 Mar 2024 19:52:43 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:52:39 +0000
In-Reply-To: <20240314232637.2538648-17-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-17-seanjc@google.com>
Message-ID: <diqz4jcrkqyw.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 16/18] KVM: selftests: Add macro for TSS selector, rename
 up code/data macros
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

> Add a proper #define for the TSS selector instead of open coding 0x18 and
> hoping future developers don't use that selector for something else.
>
> Opportunistically rename the code and data selector macros to shorten the
> names, align the naming with the kernel's scheme, and capture that they
> are *kernel* segments.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c       | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 03b9387a1d2e..67235013f6f9 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -15,8 +15,9 @@
>  #define NUM_INTERRUPTS 256
>  #endif
>  
> -#define DEFAULT_CODE_SELECTOR 0x8
> -#define DEFAULT_DATA_SELECTOR 0x10
> +#define KERNEL_CS	0x8
> +#define KERNEL_DS	0x10
> +#define KERNEL_TSS	0x18
>  
>  #define MAX_NR_CPUID_ENTRIES 100
>  
> @@ -547,11 +548,11 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
>  
>  	kvm_seg_set_unusable(&sregs.ldt);
> -	kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
> -	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
> -	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
> -	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
> -	kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
> +	kvm_seg_set_kernel_code_64bit(vm, KERNEL_CS, &sregs.cs);
> +	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.ds);
> +	kvm_seg_set_kernel_data_64bit(vm, KERNEL_DS, &sregs.es);
> +	kvm_seg_set_kernel_data_64bit(NULL, KERNEL_DS, &sregs.gs);
> +	kvm_setup_tss_64bit(vm, &sregs.tr, KERNEL_TSS);
>  
>  	sregs.cr3 = vm->pgd;
>  	vcpu_sregs_set(vcpu, &sregs);
> @@ -620,8 +621,7 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  
>  	/* Handlers have the same address in both address spaces.*/
>  	for (i = 0; i < NUM_INTERRUPTS; i++)
> -		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
> -			DEFAULT_CODE_SELECTOR);
> +		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0, KERNEL_CS);
>  
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
