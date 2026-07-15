Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C69242BC4B
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784118835; cv=none; b=ZHlvPKfPJXVrHXqMNAbB4iTHughpIVXpRqQMqaCkSAZhj4f4KRY0O32jIZmq9WbuoBpUcBZcX+S4YFMeJPrEHqJf3665aP6HOFwdJL/yw6kkfSEjZIW4fFb60THY0RXJChJ0rvj030zZXgLOr5s4LQleOQwr/BbW8fVEiJBNuck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784118835; c=relaxed/simple;
	bh=G57zKCv+spOPuY/8rVHWOOnl9/D25zYP86zPILQp1lQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ciu8fknp6nUfZIBGIqMF945efvol4FX0FApMHE4o2XZGRmN5OyZAbi+YiTAHjusWBY8y9Ta6MdTea8BHJx7xeltl90WyQBpnTz40BhwcGVpZTeDbY2YwQqAKKQ794zb8AbIHHohlTzoq+kuNGULJSueQLRQNFRzp/qqxpJ9C55g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M6gTGVQG; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M6gTGVQG"
X-Forwarded-Encrypted: i=1; AHgh+RpQLfd5OmmQ5vZWk5QiC1unZOoe2+wNyDzfYnqwojOa52lMBLEBuSQdU3fORdyjJGceNS5wBlc=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784118831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+guEC8Ex4qrqSkEdXMiwdsEhdbbOIt/n8ixzbFFm7I=;
	b=M6gTGVQGC1Fss5onHPJbjCC/Y3PJkzdqIeVjigrDJsjbgQpLXIS0R5iEiYKWv6nfvBUPB7
	D4xxPfz+AW/buDB6Fi734l3BrlxDiz8DTSWGzmd6jpyo0mbdUwx2qPuWyS8c8hVfy4DD7O
	NFBNr8PHUO3xB4jhJeVUpF6EqE7BjWo=
X-Gm-Message-State: AOJu0YzQ3GED1SgIGs2tyUyyWC1xdl2OT0Ae5IieJ0+cipJxjBIdc59m
	J7/KkR64HTwIWZ7gtU38FOPn8cmo0DDcOZ93XSSYwnhS4m7/jb+oJ1L9o8uEJA7N+KW7MGikjkf
	GqLakqqYd7DharOy0yUQ79PhsnSeDUYyIoyCwHGsC
X-Received: by 2002:ac8:6992:0:b0:51b:fe30:b8c5 with SMTP id
 d75a77b69052e-51d7bcc96e9mr20164071cf.6.1784118817577; Wed, 15 Jul 2026
 05:33:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-16-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-16-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 13:33:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzNMCMAt=VDnCuR2+Pfz9Qh5HmbEm6tdjpdcPBO+UchEg@mail.gmail.com>
X-Gm-Features: AUfX_mymo_D2O5n0ZAffEBP1RuvXf6XLBjc5Twl5xXcW05_4Gb4iBPyu-EXgdh8
Message-ID: <CA+EHjTzNMCMAt=VDnCuR2+Pfz9Qh5HmbEm6tdjpdcPBO+UchEg@mail.gmail.com>
Subject: Re: [PATCH v2 15/18] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:

...

> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -191,8 +191,8 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
>   */
>  static int __pkvm_create_hyp_vm(struct kvm *kvm)
>  {
> -       size_t pgd_sz, hyp_vm_sz;
> -       void *pgd, *hyp_vm;
> +       size_t pgd_sz;
> +       void *pgd;
>         int ret;
>
>         if (kvm->created_vcpus < 1)
> @@ -209,28 +209,15 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
>         if (!pgd)
>                 return -ENOMEM;
>
> -       /* Allocate memory to donate to hyp for vm and vcpu pointers. */
> -       hyp_vm_sz = PAGE_ALIGN(size_add(PKVM_HYP_VM_SIZE,
> -                                       size_mul(sizeof(void *),
> -                                                kvm->created_vcpus)));
> -       hyp_vm = alloc_pages_exact(hyp_vm_sz, GFP_KERNEL_ACCOUNT);
> -       if (!hyp_vm) {
> -               ret = -ENOMEM;
> -               goto free_pgd;
> -       }
> -
> -       /* Donate the VM memory to hyp and let hyp initialize it. */
> -       ret = kvm_call_hyp_nvhe(__pkvm_init_vm, kvm, hyp_vm, pgd);
> +       ret = pkvm_call_hyp_req(__pkvm_init_vm, kvm, pgd);

Sashiko might be right on the memcg point: hyp_vm used to be
GFP_KERNEL_ACCOUNT and now comes from the heap unaccounted, while pgd
next to it is still accounted, so it's inconsistent.

If we do want to fix it, would it go in pkvm_hyp_topup() to cover all
consumers rather than here?

Cheers,
/fuad
