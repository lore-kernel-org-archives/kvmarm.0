Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4841C62DD
	for <kvmarm@lists.linux.dev>; Mon,  2 Sep 2024 21:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725312405; cv=none; b=u/BMYJUyPwI3rX0pxkcuYIavk22HSogFfkksOgZKsyeM183M0IifSZ5S3GS9q0gQjA7sDx94aZBGdUT3dD29gs/kgO6e02nCgZfCiwkqhl4ycG28PMLAGqtvA++lDofZcVozTqUnmXF44CKe+XC34B2QNOxABGbsw7JnfFovVb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725312405; c=relaxed/simple;
	bh=7D0+ujGNxr/oMLWxk9V90KOD2exXKgfiR9FgcDqVboU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OEXgdKLwbcPHbS84BGvCyal631C9L4sYyMjiKll9YZmGY4Itc0F+6rBnE1upXs4NLK+E+tzxnVMkH7sLF1F9VzsD7PAxI05cT77xyORBuNEamN/zt/HdmOQ0Fv0HxDjN2A/sfCSSYu8Yf36f2qLYQCZawYiQx+/mgpzc+CJmUP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkDyK867; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkDyK867"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06E4C4AF0C
	for <kvmarm@lists.linux.dev>; Mon,  2 Sep 2024 21:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725312404;
	bh=7D0+ujGNxr/oMLWxk9V90KOD2exXKgfiR9FgcDqVboU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BkDyK867kTHgEfXmbrcJCW70zLjfOxxfR3fXEJsHS6kE2lmeBjzH6Pnq5sEHKj6pP
	 iFpjomPYZYrKDtpSbzKTuTBzlET1KnNMqau9DPLd3kuvJP0WMf7ZQog74ORZbDadYl
	 b8F9I1ef86N6Ecp4BstoOnfEEF6lY5qZkKgwbgUEdwbOElqY3b3jV9m/k/vNN4kGYP
	 o8qT+v5B5E7ijESr+c2z6X/GzNBrPhT79eHeoGISd0m84zUmYNJWHedeOpfMPW91zP
	 sxWOBXt3je9esqmVR50KZwJNg7fS3IiRn1l+N3w3HW5pVMQ/nIRuLOr8BBtuv7gsvU
	 2OyGUw7Gsu0eg==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53351642021so4949729e87.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Sep 2024 14:26:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVNDovDyGLLzkMAKSsBpwkLssKl+gEWQbPjbcdrOJajzEE20/ViAqY85BlOv8aTvWh+xjZ6m5k=@lists.linux.dev
X-Gm-Message-State: AOJu0YzzJvC0m305QM/ZcUu+leQ2Ma1iriYquBcQWGdXCkGDXZ1V5X30
	l3B0Ryf2ccuN8WDeftkAVypb33ohGIn05LZ9C/s8ucvhHV5T2wm//cYbmtoUoQmkYSqwYFlVdyN
	/XB6JG9a8de3EZBss46PKrvXDZjg=
X-Google-Smtp-Source: AGHT+IGm8eIOeLca63f83AqImC+zVqFGI93UuBfBZ5xueBxTEARESEtsHEq22J09YaHER9vhHPJ4rDa/9u3scuSd9Qc=
X-Received: by 2002:a05:6512:238d:b0:531:4c6d:b8ef with SMTP id
 2adb3069b0e04-53546aef19fmr9277332e87.6.1725312403293; Mon, 02 Sep 2024
 14:26:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <214e37e9-7aba-1e61-f63f-85cb10c9a878@huawei.com>
 <86zfotuoio.wl-maz@kernel.org> <CAMj1kXGocnZPe4EfzsB6xd2QZacp-a45R5f5f6FDpVtVEXCcGQ@mail.gmail.com>
 <86y14dun1f.wl-maz@kernel.org>
In-Reply-To: <86y14dun1f.wl-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 2 Sep 2024 23:26:32 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF3JrDs=xvRmvTxS9du1F-gjSVe5qVZrPO5JLT5ho0riA@mail.gmail.com>
Message-ID: <CAMj1kXF3JrDs=xvRmvTxS9du1F-gjSVe5qVZrPO5JLT5ho0riA@mail.gmail.com>
Subject: Re: Question on get random long worse in VM than on host
To: Marc Zyngier <maz@kernel.org>
Cc: Tangnianyao <tangnianyao@huawei.com>, Will Deacon <will@kernel.org>, oliver.upton@linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, "guoyang (C)" <guoyang2@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 31 Aug 2024 at 10:14, Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 31 Aug 2024 08:56:23 +0100,
> Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > As for RNDR/RNDRRS vs TRNG: the former is not a raw entropy source, it
> > is a DRBG (or CSPRNG) which provides cryptographically secure random
> > numbers whose security strength is limited by the size of the seed.
> > TRNG does not have this limitation in principle, although non-p KVM
> > happily seeds it from the kernel's entropy pool, which has the same
> > limitation in practice.
>
> Is that something we should address? I assume that this has an impact
> on the quality of the provided random numbers?
>

To be honest, I personally find the distinction rather theoretical - I
think it will be mostly the FIPS fetishists who may object to the
seeding of a DRBG of security strength 'n' from the kernel entropy
pool without proving that the sample has 'n' bits of entropy.

For pKVM, the concern was that the untrusted host could observe and
manipulate the entropy and therefore the protected guest's entropy
source, which is why the hypervisor relays TRNG SMCCC calls directly
to the secure firmware in that case. The quality of the entropy was
never a concern here.
