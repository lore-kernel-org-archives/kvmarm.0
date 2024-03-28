Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3321D18C31
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 02:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711593350; cv=none; b=PgqOIZMMZ2FORMeyq1rqyXlZuG9j3c3kmlwA3xGYF2ZxYSV42xbYDVhfS8DSoI64EA5TFq657b0JMB11DQXIxHb0vo2vPW5hTelij90sUf3ATMmsiJMG07SAl+7zrcQKI5uc4R37dFZxXqcJwusj/XlzUU7DPvWROUKaVYhX6iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711593350; c=relaxed/simple;
	bh=0R24u452LaT2qzR1G87IGAYBRmr17XS5Gu2jDvqLnd4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k3MMGZHplbOkvY5ZUJt91ndcx2vqIwEtg+/gRtc7q9GM6E5AgD8CRZJxqf8Chs8Ex6DBKO0lyXs2JnROMMoaUG2o4df9FphlOck2N39FH25hNCcIMiJ9CNs3L+e1sP+vNilqMerYu7zxSFKTpWBHhaqS1BfsahWnOvpwgnU014w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sKVo/bkG; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sKVo/bkG"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6ceade361so997400276.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 19:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711593348; x=1712198148; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tn1V7cT0/uugUJxaDzYA8tibaw31zbYQ1co3qQTHee4=;
        b=sKVo/bkGvwaGJHGoA3WDFU1vOwt+QxVoS7IXXf2/Lhy+vRdqhvNb1p1k2LLuin+DV6
         oXSG+mglH6ZDDjnpyWrTRYXJXo9GWKje3tzr6H11cau+LgllxuyPuGIHMvFXNcEksRZN
         0dLyZpnPHUkcldC4SueL6C1lGPSmJ5AUUkqph5LNtAsjZkG24x7rXCEPJXi4/CyDkipN
         viGT5qnmtREvSfTRvgApI2HcgVAfgVTKF10xhUaJ7fal8fq36GzSi795Aw/HDrtw0b2h
         FTGgaNDhOf0/6aznz4XJ4Xss70VBkcjqL8Owf91CjQxjoisfYw+ZsLQHoi13lsQF92I2
         mGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711593348; x=1712198148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tn1V7cT0/uugUJxaDzYA8tibaw31zbYQ1co3qQTHee4=;
        b=u1DwUscvv/MEA4bSMX21yuKHWPt91OtCTj56s9TFPSk7LzwGx8h51nXesHoeouKqCf
         MOqiuYapKcH+F4CYwNikH5KdOj+YbzrI1nyxoX8WbWkEFXxV/xF2MFkpqeMlMJTiFfOu
         3lY/RD1hjy7Lq3xFVkzpABIp+IIvPlL4X9ExbRLEjNt46h+vSs4t8Ph2XFQz7Adv9pMy
         TyztcRk3GdwngYskiFQgl0XnrGoktyjnzbyMJpyf++pTSa9WyV7IsDy/nOZL3zHq90cS
         7mu8wdfgF0WBZc4/bX3wKwvbDl/fkdryLKRpGc+XGA8fAexO/CAjL6OQ0vDnQTjfJWho
         oMow==
X-Forwarded-Encrypted: i=1; AJvYcCX1NWo42u4eOExSCcihDO3uF4FJix1rwiBz7OiS484ti0Ku/gQWiHJlYpbMArNPAdXyWYh7STu0GKM+uyu5KOXXDH5Y3US5
X-Gm-Message-State: AOJu0Yxtkr8ww34QtrSQ088QYMY3o7GL12ATVgPLcwTfFbUL9l5f9owx
	DEnM0jxHau9qgAld6f01LMTM6a4e3DLHMKXcxNkNDVtX0Cf5pjiV6JMtJo+UEj5100eZoUapatt
	RY3lNFBb/qsFNkvzzMLdocg==
X-Google-Smtp-Source: AGHT+IFmu/wyvjPJ86C2YpqmMzCjCxqoKynwb/5895KHOEbiGTXB3f51zjw8tqW3FQ608rm4NQTJd4dFZkDKVH6OPw==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:1007:b0:dcd:ad52:6932 with
 SMTP id w7-20020a056902100700b00dcdad526932mr540194ybt.5.1711593348331; Wed,
 27 Mar 2024 19:35:48 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:35:44 +0000
In-Reply-To: <20240314232637.2538648-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-12-seanjc@google.com>
Message-ID: <diqz1q7vm6bj.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 11/18] KVM: selftests: Map x86's exception_handlers at VM
 creation, not vCPU setup
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

> Map x86's exception handlers at VM creation, not vCPU setup, as the
> mapping is per-VM, i.e. doesn't need to be (re)done for every vCPU.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 5813d93b2e7c..f4046029f168 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -552,7 +552,6 @@ static void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
>  	sregs.gdt.limit = getpagesize() - 1;
>  	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
>  	vcpu_sregs_set(vcpu, &sregs);
> -	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
>  
>  static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
> @@ -651,6 +650,8 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  	for (i = 0; i < NUM_INTERRUPTS; i++)
>  		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
>  			DEFAULT_CODE_SELECTOR);
> +
> +	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
>  
>  void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
