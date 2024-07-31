Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C611799F
	for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722443020; cv=none; b=k2+Rg/98bQhi6drsdjnD0Wg4MXVXnDjorAfDcKlLbKC3Lbyk6Zr9sPKDliI9Rup6uFx89kWRVUpbqTBrhAqTnk7nv48rXxieZE1zcryikQpmJYuS9Gzn2y79jsQHoSXqjco39QatL3a/rHDWQhG/VvinijZqmPCWkcW99N5RK1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722443020; c=relaxed/simple;
	bh=2HhUeVKAqujM6tGjz7xY7eoGDJF2k6V8JCfwVRNXp0M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MaaQSeSH4voP/75Rh5MvXepo6tTe//+vGVkClh/kk4wHXeW2CCWUC6SNdwIp28KhOnFp4aKG+PIIL/wjFZQn72FPTFuGW564wkpirPMrI3F3mU6FlxRElE3hyumEtmFCMkS/k53I1dpNj+rWyYoKXVV7O/ainbapxzR1XVmlKoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GAA5B0xL; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GAA5B0xL"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a7aa086b077so529244566b.0
        for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 09:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722443016; x=1723047816; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Jy3Eo6Gu+vhJFsd2nEOfkihTm91GOS2uDXcn/bR1Cs=;
        b=GAA5B0xLMxei9D/hOLh0U6AKzRakAwvFJRuUal+08LdYjBpP+Q51vdU1sCPm+AJVmH
         xJSAj8eVqZT/Hbo8OlQALRjAuyg0V7BSg/nLZamSmJLKsEUXQ183WCY+9NFI3Mpm2MFV
         Slk7sMauS0mXx+mi9lpt/sxRxoAu6Ks2Ale3hSDgsif1ucD/2CnjvTunFR9ZuhZ82znR
         yZAGtnEnaYZBVXShzEzr0LX/ZrskkslmHRBVcT3bG4AYGCso26pkqr0sHUr/DhF/d3cE
         oTzuex03bAxD8HMDC2DUwA7xuxdUgyhgR1wLS4V5nStJjH4+/hQfR8m6iaUY/9za2PBT
         wWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722443016; x=1723047816;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Jy3Eo6Gu+vhJFsd2nEOfkihTm91GOS2uDXcn/bR1Cs=;
        b=MdzAKSLY+H52OwFVT58mrixwhcF9dX5zd77NO3CJx53kS98DYZt9LkMBNwXfsyzjBc
         RtWAvdXniULwUeXdfJBvpVfPchL8MrhjWNv0vzbvjSdWai0mJM/XCLmlbDlzzctIOYcV
         /RZnvbupvi71bfj+0iTxSiI6sFG5O+4hHGDL1ttLtWE5JfuEcttykEVmTVavHmDC0vnk
         /ZGucq6SUPoMgp8YLoJcKcZlGhe8qrym7+CuCkdZnpQCaPpNc7bTaBaDkr22Ro51xMnt
         eLpG19lfCZiyUPojEmMim+jJZkJqMArE2OlzFn6gIxui0rZx849jiQGApoV2u27YTWVZ
         4MlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTHfkgpfhUggDNXVQ4QcySs6pwbBjmqsg/3XPMkHBEXg2YiTsoZhO8lCs0/qoO0Mn6e6n/29HTPapg0Wr6Ue82jozI8rd0
X-Gm-Message-State: AOJu0YwV/Eyo0lZKNEsOOkYZxANvP2qS8STL5JGe+tozQ1vxMw+/1Ed8
	BtnJWMZ0b907AlFkanLphRKMjKR9IyIVkI08JJpyIH26igWszv80t0xDEy1/VRE=
X-Google-Smtp-Source: AGHT+IFaeuLsqXvHIvwNkMOmXQ/kk95KnaHAVzfZZFY2rJSwrdZANzuSfUeE19U50MBeGB1J/TbUHg==
X-Received: by 2002:a17:907:a0d5:b0:a7a:b070:92c6 with SMTP id a640c23a62f3a-a7d40116a4bmr801926666b.50.1722443015967;
        Wed, 31 Jul 2024 09:23:35 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acad416basm784769266b.104.2024.07.31.09.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 09:23:35 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 614DC5F8CB;
	Wed, 31 Jul 2024 17:23:34 +0100 (BST)
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
Subject: Re: [PATCH v12 01/84] KVM: arm64: Release pfn, i.e. put page, if
 copying MTE tags hits ZONE_DEVICE
In-Reply-To: <20240726235234.228822-2-seanjc@google.com> (Sean
	Christopherson's message of "Fri, 26 Jul 2024 16:51:10 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-2-seanjc@google.com>
Date: Wed, 31 Jul 2024 17:23:34 +0100
Message-ID: <87a5hxfs3d.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> Put the page reference acquired by gfn_to_pfn_prot() if
> kvm_vm_ioctl_mte_copy_tags() runs into ZONE_DEVICE memory.  KVM's less-
> than-stellar heuristics for dealing with pfn-mapped memory means that KVM
> can get a page reference to ZONE_DEVICE memory.
>
> Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a gues=
t")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/kvm/guest.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 11098eb7eb44..e1f0ff08836a 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1059,6 +1059,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  		page =3D pfn_to_online_page(pfn);
>  		if (!page) {
>  			/* Reject ZONE_DEVICE memory */
> +			kvm_release_pfn_clean(pfn);

I guess this gets renamed later in the series.

However my main comment is does lack of page always mean a ZONE_DEVICE?
Looking at pfn_to_online_page() I see a bunch of other checks first. Why
isn't it that functions responsibility to clean up after itself if its
returning NULLs?

>  			ret =3D -EFAULT;
>  			goto out;
>  		}

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
