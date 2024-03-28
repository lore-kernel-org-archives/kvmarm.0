Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFAF1EB55
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 02:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594031; cv=none; b=mODUoD23Ir8dYcDW127HCjv/HVESk1DoYxNxUUjL8BtEDi6wuh3KzaD/En/U9U4/qBdrFK1XWqQXRZU8ShB3rHZyxo1EZ/NN2M1Cg7iae2y64zdha+KtYBKvNc5uPsiaOXEW26BkLi0LIaWMVWyYPgyKDjWcrB7wTOxnTDBxwN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594031; c=relaxed/simple;
	bh=84H+cJFr0cL9Knja7weHauqkI7JHjb4wcobAfHN1EMI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mUtZOsNkeO7ftM+XpSCHSFgHzMvulRA57r8dnvtwdVAw5OJfeozmfixzAYPD0jUFNvKihiEx2mrJ47b28Tywf6OJJr8ePU1vvFaqgiqOKf/BdZf720cNJPPFzZkJFsGQEsEzFhxBWT3MpO+RcNm5zJTt0ZjwfSYexBjUJvkJlfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OsAXljsJ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OsAXljsJ"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cd073522cso8921257b3.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 19:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594029; x=1712198829; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zwKAKqKSkPlBh99CpC5Ho4X+oKbKwu1UgbqAZ4JZV3w=;
        b=OsAXljsJLbGsUJuy2MBp9mATkfN3JsuQJKyIMwJRJN94qP3Vc9osyWAmpsM4xzSnYP
         sgswHkWJUMA1i0y8T6LuEKJSSgQOgRZuUT+36ex2rLADRPXWGX9LRZ0Z+yoKbwngyWEv
         3VMv3K23gACGUsfBsdnoI2l3Amc+13s0MGlQigWxppSpMt4K8BlYagJEk0ToKLNnDOQp
         0hKtBAbgDPWzfM/p6juGF7lhN8FCU+L8N8zNvCdd4FgcJa9tFDqUP++AhNub6tO4YVJh
         ZSa6RV1bucBRZiiJMLCLI2Sc7A850eTsTdOwmZQBxwMQIQyWh3KnfIkwj0+sZhMHVVgS
         9o8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594029; x=1712198829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zwKAKqKSkPlBh99CpC5Ho4X+oKbKwu1UgbqAZ4JZV3w=;
        b=CEE0PR2bO+J6D3sgeSBVmCzR8mgbdNJzhUz9/xDatZwsIiz1iA181070U0I1FSsbAz
         ZakE45Bhg4xsO5JA0/yRv6JXgZy7ho1sxcasjcfZmxizj5MXfYYsgUkFehQdO0SMclLC
         88xI8zDzjxY01Hgec+fRfMC8nows5PA7ES3v4D4OlzONa11PJg2HVPWGl6jbhlHtA6fq
         ifd2Sr8hDCJDF6mYas3pKDBFp1X5m6oSZHJ7vs8uiBb/cy2a5ZTnuzt9WTYEIaVZip6d
         Tv6mJHfXN3ikoE+b2AvQmVu3CxT8Jw2PT/Q2XhGs/AdONbd37oZHXtA234pZLDPcelWI
         q18g==
X-Forwarded-Encrypted: i=1; AJvYcCVO+WuJQWuiPeJ6n4F5B3w2kToNUujR3QNpIkAQarWINToe/Io+lPvQfIXEL2fASWzmH2IIaXOpxoMYKfsymgwD1BVPMF7R
X-Gm-Message-State: AOJu0YxZv4Lzc5/0y/sU0UtXK3Pdi4PM9j3pA6vJY1u1zKA5zSf39v27
	oashhOrtZQTg/muhW4004dkdWT/tqCJuGU/rJpDBI5EoTrnze6tALrL8meK+JjbRYfC85U5h3Pa
	FEJdddaMSxX/ixOQjeKckwg==
X-Google-Smtp-Source: AGHT+IFuDAD4wtNUkP/2UEse7mwv3qapG5IVIY191z0pQp8MOjMKC9JPX6Ry++6lYE8vhg/RF4vUjCFCzCP7/uR5QA==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:690c:30c:b0:610:c400:9e8a with
 SMTP id bg12-20020a05690c030c00b00610c4009e8amr207011ywb.2.1711594029051;
 Wed, 27 Mar 2024 19:47:09 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:47:05 +0000
In-Reply-To: <20240314232637.2538648-10-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-10-seanjc@google.com>
Message-ID: <diqzttkrkr86.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 09/18] KVM: selftests: Rename x86's vcpu_setup() to vcpu_init_sregs()
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

> Rename vcpu_setup() to be more descriptive and precise, there is a whole
> lot of "setup" that is done for a vCPU that isn't in said helper.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 3640d3290f0a..d6bfe96a6a77 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -555,7 +555,7 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
>  
> -static void vcpu_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> +static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_sregs sregs;
>  
> @@ -716,7 +716,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
>  
>  	vcpu = __vm_vcpu_add(vm, vcpu_id);
>  	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
> -	vcpu_setup(vm, vcpu);
> +	vcpu_init_sregs(vm, vcpu);
>  
>  	/* Setup guest general purpose registers */
>  	vcpu_regs_get(vcpu, &regs);
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
