Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305FB2C6A8
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 02:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594258; cv=none; b=gxH244B1uLev3ABbPrC1aHioah6B0//67YLtPJh0MYXg6fx0JqlSd6Xat/6Ue44a6mZ+IO8jClEdU/JE/iklOFvMK4B7bDYM8Id6DcgB5WP6IfCI3Fu1EE/i3MOkMtZ8DsZDZfNftEy9q751gDlD5KtkeuJP+rG72VCBL23v7Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594258; c=relaxed/simple;
	bh=6kiqhJKQshLo/BjwdEMSoc1e4fwgvGXzMhgJJcB1bNc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jd6yGD403c2lcT2OYNY8iSN46a7j7mhIkxFrmn4tpWXjGkBJYEF6yZ2JzMZFFt+dweBdc1eGHxbPc+5eQ42bTWjDk2ESpF2seUdxdIBBk7i+FLGBUtttVBh97tJYnFS+t2lvEUTwUUxmDS8GnL6L12sHY+ZmVwMuhsb868eYRnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aXwAWS65; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aXwAWS65"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dd944567b6cso678754276.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 19:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594256; x=1712199056; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=seKwScTc9wqkrhGrgx5tr+y5GeB++CIZke1OsGxBUZc=;
        b=aXwAWS65NhzhyAeUFiOOlNk0KojMHEchfjgWCJxKSufTuyjhl0r7ovMX7EP4+894rE
         tPy35usrgpC6+3j2vMWzY8NCt5GY9UNZECFtYANEfhFdZ0/uq86465Pzc1aFMryEwqic
         lriPQJ301GLMgqs00YiWaZpvMVZsgNSz/JrCrdVLPSzjTZol63isKmn3NFG8FkhLkCzG
         l2JYI4QABarEGpB1O+pf4EKNVJKkEy2Iv5cU/ZQQJWuT08OzkFszsyQzjk7KE1eQWKha
         Iq+Eq/f5zNOdQeihXjWpXEZyXY/tAgcnIuycZCujrq3nMIbDNR/+lX0pi2cBGT52dBVj
         4n9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594256; x=1712199056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=seKwScTc9wqkrhGrgx5tr+y5GeB++CIZke1OsGxBUZc=;
        b=Kn5YlsGFis1IyyCcwG7vTwCoahulaF/mNDu+pJdMNWP/ZcdJPdwWdif9mWtWZP3Sgc
         fshWtbEqeCgYR7Tt0iPyOLYoDW6sczoyOn9N1yqoxH6KcVhD4ie1Y2gU6X9IMTKi/Pyj
         njvjB2n7u393KipREaI/cx1vt8N28+jwGeqIEzazpit8vRKyEzu/i9/XwesYt4AQ0M+m
         lpEKEyUf4B6XloUafEf1kVVv+xZzxSeMCJmkIMGf0D1p1oSGztLjj79gcrxy1osH9MW5
         HSqlzNOjJy2x1dqWcBseGJ5mSnxku20fu/9QebHt9EmFsydqLcjs4PvQmaaDnUDckiHH
         dsFw==
X-Forwarded-Encrypted: i=1; AJvYcCWfAAJwJyuMiDzfNJnjlaIsTJQoxoHKwAuksy32Y9YZIIAlvLZN7iHXi6Ng7SOpj027Q+dvjWx/AzDz1uyrRxRxBQ1OPrPm
X-Gm-Message-State: AOJu0YzHHkiS4q3kZ807gd+Cgd51PXM9GPTm0kzAEBaRql2iyT6W6dZA
	I6AhLdUsAhA0bZSMGFGiYKYxKYvqiuUeUzAP4pbVPiAjEcRCVsTd35ugh0EX9cH9wEKypqskKgF
	tczKOlE1SwgIF/rENEw385A==
X-Google-Smtp-Source: AGHT+IEO9/kWiBlfm+yWQ+WCwdKpSW8LEFVaawt8sTBofKxrZN8NZmXedY9jk9Xhy7bDK1Xf3oVmIhdKSvQRsIc+mA==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:160f:b0:dcc:79ab:e522 with
 SMTP id bw15-20020a056902160f00b00dcc79abe522mr160235ybb.11.1711594255835;
 Wed, 27 Mar 2024 19:50:55 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:50:52 +0000
In-Reply-To: <20240314232637.2538648-16-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-16-seanjc@google.com>
Message-ID: <diqzcyrfkr1v.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 15/18] KVM: selftests: Allocate x86's TSS at VM creation
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

> Allocate x86's per-VM TSS at creation of a non-barebones VM.  Like the
> GDT, the TSS is needed to actually run vCPUs, i.e. every non-barebones VM
> is all but guaranteed to allocate the TSS sooner or later.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 5cf845975f66..03b9387a1d2e 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -519,9 +519,6 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
>  				int selector)
>  {
> -	if (!vm->arch.tss)
> -		vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> -
>  	memset(segp, 0, sizeof(*segp));
>  	segp->base = vm->arch.tss;
>  	segp->limit = 0x67;
> @@ -619,6 +616,8 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> +	vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> +
>  	/* Handlers have the same address in both address spaces.*/
>  	for (i = 0; i < NUM_INTERRUPTS; i++)
>  		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
