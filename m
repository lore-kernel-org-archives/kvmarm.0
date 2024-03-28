Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3880017984
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 02:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711593222; cv=none; b=YWjfg3c2/mxIrmcQGpAvqCciRONlel0hNv1LUcXwXMQt0Ugs7SwIW5Eiqopq2LhwOgqf0gw2GqZLoY83ETruL8minjEz6fa1i74at328DhfWIg7Yguav9FFpTybyPZfraH3+ZUyGV4mb0IvLaRO5FCKbEgDXoX+QpMlNx1DCWMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711593222; c=relaxed/simple;
	bh=OFojCwZ6v5ziBtsIk9oLLAj/dEaiopLScBLdXXXv8Ts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GgxQFNU5XX1vYQxF72tdIsg+M9eS8BAN6W1mduUsdm1qyJzrDWuYWzgaz5NP4+5wBs0+WUkcAmpqBfUnRsCcYa1m302mnI+V80PQgUygY3vFa7jVeDkIhqLvvqFpGs1HQS1mQfg7z5rjLV1SGSQaVHh0oan8LeYQpYZz/tcJFKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V7wXNhF3; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V7wXNhF3"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a03635590so9866887b3.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 19:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711593220; x=1712198020; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UkoXrrgQLG0OC6iY0Ar2KtEiFjbb+Lcngub56vU+bHo=;
        b=V7wXNhF35YCBlsmpENOqliF9I5+FPmRyjaqq0eEPJFwWUl53I6nZ+usuKtR1lACoUg
         3AoyTRBnlPvWSeL78asbh9+YS+3H/O1XhWm580ul93M5nXB5GUuPJSJRuofSYVE+dIHh
         6VIaCFFNxVo+qD0p4JKM08aEI8ODzp0DsUYruzFeTSEgN2vAEqNe9ThbyX9s+oq26f2a
         MixuIlhvb4ninm+uqInHOrBqI7b/Xr/S0TJKbwa54ATvxsZGCfiNgpunqVYq1wWP/HQI
         tdvwtWdmJEfOoliTlAUvokkq6cyguBdZOf4OTRjZsjDKCVFsyRp3XdSBu0Ia9yumvm5L
         mWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711593220; x=1712198020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UkoXrrgQLG0OC6iY0Ar2KtEiFjbb+Lcngub56vU+bHo=;
        b=ag6+Pd8YVCQ+6xRbPFG0AK0GJ5llK0H/6eXERYjLnjjAuq/tVfJtlhXhAnHYVqFy2v
         fMFv0rafAvHnoZbX/qIhbWY8AYpkHdohYosKcmW2tw2Ev9qTa6+3xkD21V1oZ51s1lIb
         ddjOFisC6a8Dibd3lHNhRs46s4SN75LYvQFtopYz8ttn5JIqGUCEGQhoIF/ChdlZuKTa
         NKYdUWAYj+Urxx8u6neclSsetF7VBZQNFauBT+P1RKFYn9eVnr89w+1RTm5C8MkBrcIr
         amaZmcRxdDI7k7ZB9UDeN5RRReJN1SNy8YaSPunXEb6CCpi6eoAaL1abld2eRcGVrAhN
         hhYA==
X-Forwarded-Encrypted: i=1; AJvYcCV4Lx0abYntyUjtswtuJbNOE6KLCR4W94R2XU32jYmLZJ1I1VOlHDcUJwOUTSQD4WXkAHMI2omnHu0o5VjrAiTNhWTFYZU1
X-Gm-Message-State: AOJu0YywzfUgjPsER1duQT+bvpYrfnfheXdXQyPio9fHF4rnnZ6/8QSt
	DENe5qKW4O9Dp81cUCz50jfBMn7FoNWlPgpCaUG7ymXmTrAhMhX0sNLSFAxiXtiSQNZ9cva6r/v
	Sjz55G5YT5SQiYUlH2//1eg==
X-Google-Smtp-Source: AGHT+IHG+Q0Rs/vnujOAAu0Ep0Ci2zjwBo/RrccQVLVpOf2JlGdWJkUk21aGZnHKjC8iP2W+VnN97KkaXY/g7E7Z7w==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:690c:d8f:b0:611:9268:b63a with
 SMTP id da15-20020a05690c0d8f00b006119268b63amr350712ywb.9.1711593220342;
 Wed, 27 Mar 2024 19:33:40 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:33:36 +0000
In-Reply-To: <20240314232637.2538648-13-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-13-seanjc@google.com>
Message-ID: <diqz4jcrm6f3.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 12/18] KVM: selftests: Allocate x86's GDT during VM creation
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

> Allocate the GDT during creation of non-barebones VMs instead of waiting
> until the first vCPU is created, as the whole point of non-barebones VMs
> is to be able to run vCPUs, i.e. the GDT is going to get allocated no
> matter what.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index f4046029f168..8547833ffa26 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -518,9 +518,6 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  
>  static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
>  {
> -	if (!vm->arch.gdt)
> -		vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> -
>  	dt->base = vm->arch.gdt;
>  	dt->limit = getpagesize() - 1;
>  }
> @@ -644,6 +641,7 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  	extern void *idt_handlers;
>  	int i;
>  
> +	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	/* Handlers have the same address in both address spaces.*/
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
