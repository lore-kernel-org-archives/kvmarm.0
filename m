Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDFF189B86
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 09:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504067; cv=none; b=IFheBiXxP27WUNrNlzAE4pa0cpZxvf7pkBK7ZFeOWs/JEZ/+fcFj6LXT+MSRuIuCd8rYQTiiKZF9mtMxozckQmkPEJ/fcYvXeWVTd9mnX47Fmw7gEgB8o1RU30y44B4ujchqpO6+XnRSV3SGVkYwzjmNxdKLpmq8id4buTyw9Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504067; c=relaxed/simple;
	bh=3Io79nUQn8ypd8PwwL4q+T1yD0diA5Tfaz6TUlMiA8c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nC6WOyU/W/mrjcsNHKt8nb/80pW/wBvhe3Z6MiSVeeJGu2277UfiaL9G1D7fmPH6ssaKFVrn+DvTMKOK3UXZEESo2VDoG9neZS7DXqGO8MtZSSUNwQqvyd2aEIzPgR+KcSTIAq6aKGTh8IJoiP9UjBmAbJRifW/yHS/LUuAg0Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k+hRirx7; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k+hRirx7"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5a1337cfbb5so11113068a12.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Aug 2024 02:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722504063; x=1723108863; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GQVA9z2jkUPxM3dqZI0KDPVXgKoffaizeXmufcNkJbk=;
        b=k+hRirx75p63pZ1NcxRnMLXTMbwGjy1m7Ea9y6KsJ4sKKV6X0cmhKpxd0HZDWF43jt
         G+MspIogmsECHInIvzsax+2UTDAtN5caG/PDnJXf2otirYmFqxqjQSLs550AA2/Ow3oD
         vwLHgZnZNxwgVOHPtNF4+r0EPerbl1OEQDMETProkfRdtYluL/sxY2dCkbnu4OFEpvXA
         vJg+MTAADM0NLtNEms0davGk7rOj5STjHp8Dok0RQl0CABf9OXMaHC7raO/0UNPUmfq2
         eczkUrW5K+3XftQNLH/apXxBwzKKFw7/f/LHYz1FNA95y0/uEDIrSyCVI/XBfmfVAItc
         Mg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722504063; x=1723108863;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GQVA9z2jkUPxM3dqZI0KDPVXgKoffaizeXmufcNkJbk=;
        b=OuBjMwZp9x4QvViIRPe1UmBeCs1TDKpOL0Swur9PcXCwsZx6VZKWaxCBj1rCA6+jp+
         Aq4YVoGHETEC6+17sku+eja21r8rRoNNkF8cwlQotKVWVDNqaATOjM+aHjT6lYPTdQLy
         5s6cypDp8JecWQEIwCmBJNKFyJve0fHP7OjnoyU2wnhJVjzu+ibhuBDug3FiGdAm8N9k
         /5opf1VHNosVaJf9mdCmpAQUfuOBsL/KAxjisImifyiar4lt4PEl3uK4+n4TUxfm0j5g
         7Ws1jFxYjzdNHw+ZYyDXFi8nC2xHZNaTvY9oUZIsNYc8hEjb4+pHNOY75+zB45BAbciK
         MAmw==
X-Forwarded-Encrypted: i=1; AJvYcCXFa0QQFnJfDXuE5GFgbrYJvxn4EKCop049gu4EvE4nuPpYCl8yVdtJHTFYd9fUAi+i2cdyy1Z1Iok2wUF5dksN/IEUHgg4
X-Gm-Message-State: AOJu0YwPJwBIqoSYHS0Rl112FLWvJg9oaLYNE37JTm5ExsNEjFZ7LPDw
	yUg4JHIuBBVG4wVtKTvcrJp02CDY3ihBt2NnWSDvUxaIeYqmBcCeKGyrzv26lEk=
X-Google-Smtp-Source: AGHT+IG4an2mFFKr4wz3Z9DFgeOmmND21A8Rbh3YvwoLKrs/2dCx443xl5h3j8lRXM2FS1yhxPSg2w==
X-Received: by 2002:a50:ee82:0:b0:5a3:3062:36d6 with SMTP id 4fb4d7f45d1cf-5b6fe72ddc6mr1090738a12.1.1722504062925;
        Thu, 01 Aug 2024 02:21:02 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5b017787967sm7857844a12.9.2024.08.01.02.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 02:21:01 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 51C785F80C;
	Thu,  1 Aug 2024 10:20:59 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Marc Zyngier <maz@kernel.org>,
  Oliver Upton <oliver.upton@linux.dev>,  Tianrui Zhao
 <zhaotianrui@loongson.cn>,  Bibo Mao <maobibo@loongson.cn>,  Huacai Chen
 <chenhuacai@kernel.org>,  Michael Ellerman <mpe@ellerman.id.au>,  Anup
 Patel <anup@brainfault.org>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,  Janosch Frank
 <frankja@linux.ibm.com>,  Claudio Imbrenda <imbrenda@linux.ibm.com>,
  kvm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.linux.dev,  loongarch@lists.linux.dev,
  linux-mips@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org,  David Matlack <dmatlack@google.com>,
  David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 05/84] KVM: Add kvm_release_page_unused() API to put
 pages that KVM never consumes
In-Reply-To: <20240726235234.228822-6-seanjc@google.com> (Sean
	Christopherson's message of "Fri, 26 Jul 2024 16:51:14 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-6-seanjc@google.com>
Date: Thu, 01 Aug 2024 10:20:59 +0100
Message-ID: <87wml0egzo.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> Add an API to release an unused page, i.e. to put a page without marking
> it accessed or dirty.  The API will be used when KVM faults-in a page but
> bails before installing the guest mapping (and other similar flows).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/kvm_host.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3d9617d1de41..c5d39a337aa3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1201,6 +1201,15 @@ unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn=
_t gfn, bool *writable);
>  unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn=
);
>  unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_=
t gfn,
>  				      bool *writable);
> +
> +static inline void kvm_release_page_unused(struct page *page)
> +{
> +	if (!page)
> +		return;
> +
> +	put_page(page);
> +}

I guess it's unfamiliarity with the mm layout but I was trying to find
where the get_pages come from to see the full pattern of allocate and
return. I guess somewhere in the depths of hva_to_pfn() from
hva_to_pfn_retry()? I think the indirection of the page walking confuses
me ;-)

Anyway the API seems reasonable enough given the other kvm_release_
functions.

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
