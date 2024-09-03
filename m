Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862692AE66
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 15:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725375883; cv=none; b=pz+ALvtCAjl9HIHMzCjrAmFlOrmmFsiYoKr4HcZi6KEaaCqZP1pnqBKDMxAJmqmaOHJnYbocCiPf8W6/P77TVUvWnmgWdtm9rIIMjfdVkk5N2Ty+gld6Y7CWGlc/utftoWiTZ1GnBb9UlZyfCnF/r0MCbMaCkqDeYouo/TcyULU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725375883; c=relaxed/simple;
	bh=lmrSBif61BRlFHCzXpca5MPMB56saeOdUQqUjYlg/Co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/9D9eqHV4429sgJEayF0k5VDgaOJo+xTuXzxVq5/OuBwJpQFxkqmlaOABBFoy82GA5wQ2OJ6TtMbLPkSgnOyKa3bFQCqVMVH1O20sgChg4rgOk38vLESmoHnRVUOys35BjSNH8deVtiaqInQCXGHXRo8nMQt0bzMQ9vKEE7UzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTnH/X/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTnH/X/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C4CC4CEC4
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725375883;
	bh=lmrSBif61BRlFHCzXpca5MPMB56saeOdUQqUjYlg/Co=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gTnH/X/xuNM8lzLUAsnru8hikmU7qWVYGdgIAlO8LjzIH2ETPBQtoK9FizzjV9je7
	 tB/LEb3g3kR6FDxGe2P4+QsOpnPvoSjtMuff6x743LBwJdysWltQXh+1zz3GNSVaIa
	 zBEALopTX/yOlUMfkKvSUgpsx0RZtcp7+gOzUGoMNOf5ZfjKnYGGfGc1FTMqMDfZgG
	 dcU7p8kiINQfuMkAgexSpJ0omfnpVXn2mV1sTc+c+rbIHTlwJ+ZsnuXamWvfMb9/tA
	 rWOwVNj4uf/U3nh3OXvq4E1ZNTB9rSfdazTpucNilBH9IQhrkAgV9oJ315nbjW/++D
	 g1YIWR9NPaEHg==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53349d3071eso7191623e87.2
        for <kvmarm@lists.linux.dev>; Tue, 03 Sep 2024 08:04:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWq1FtzmlI6v3tLT7zAbSNuQfbOMDq+xB6o31rcYfTaL19dLZHUYZwhl32Prm4vyh5e+Pu2JY4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTRAaB/T9VQ/MF2vbgnJE23u0UTEMrSeboUyt5vmhbm5+S2xUE
	WGdQwo76iZmYPYXTliEp+Ss1l6P/wlLooi5iJg+YTg25xKrtI2AHLCVYv+ZzdWrXEFvRkWjl7wG
	BplC8xcp7Yx+48/+L8SpIa9wBMnM=
X-Google-Smtp-Source: AGHT+IG7gus73VBjLSHysH1wwSV9ysu4ymNNtJXZol3arJRV6nMVPo8fAFNviB0AK2N5lnISmpZGdtR5+wtX5w0Po4Y=
X-Received: by 2002:a05:6512:3d28:b0:52c:e670:7a12 with SMTP id
 2adb3069b0e04-53546bc2c75mr8928117e87.60.1725375881495; Tue, 03 Sep 2024
 08:04:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <214e37e9-7aba-1e61-f63f-85cb10c9a878@huawei.com>
 <86zfotuoio.wl-maz@kernel.org> <CAMj1kXGocnZPe4EfzsB6xd2QZacp-a45R5f5f6FDpVtVEXCcGQ@mail.gmail.com>
 <86y14dun1f.wl-maz@kernel.org> <CAMj1kXF3JrDs=xvRmvTxS9du1F-gjSVe5qVZrPO5JLT5ho0riA@mail.gmail.com>
 <f39ccb21-cc28-b878-bf5e-e81e378a299e@huawei.com>
In-Reply-To: <f39ccb21-cc28-b878-bf5e-e81e378a299e@huawei.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 3 Sep 2024 17:04:30 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGyJSwD=ok=Ag11mMh3d6onQkN0b_-iVwVDdyrwk5rj6Q@mail.gmail.com>
Message-ID: <CAMj1kXGyJSwD=ok=Ag11mMh3d6onQkN0b_-iVwVDdyrwk5rj6Q@mail.gmail.com>
Subject: Re: Question on get random long worse in VM than on host
To: Tangnianyao <tangnianyao@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, oliver.upton@linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, "guoyang (C)" <guoyang2@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 3 Sept 2024 at 03:39, Tangnianyao <tangnianyao@huawei.com> wrote:
>
>
>
> On 9/3/2024 5:26, Ard Biesheuvel wrote:
> > On Sat, 31 Aug 2024 at 10:14, Marc Zyngier <maz@kernel.org> wrote:
> >> On Sat, 31 Aug 2024 08:56:23 +0100,
> >> Ard Biesheuvel <ardb@kernel.org> wrote:
> >>> As for RNDR/RNDRRS vs TRNG: the former is not a raw entropy source, it
> >>> is a DRBG (or CSPRNG) which provides cryptographically secure random
> >>> numbers whose security strength is limited by the size of the seed.
> >>> TRNG does not have this limitation in principle, although non-p KVM
> >>> happily seeds it from the kernel's entropy pool, which has the same
> >>> limitation in practice.
> >> Is that something we should address? I assume that this has an impact
> >> on the quality of the provided random numbers?
> >>
> > To be honest, I personally find the distinction rather theoretical - I
> > think it will be mostly the FIPS fetishists who may object to the
> > seeding of a DRBG of security strength 'n' from the kernel entropy
> > pool without proving that the sample has 'n' bits of entropy.
> >
> > For pKVM, the concern was that the untrusted host could observe and
> > manipulate the entropy and therefore the protected guest's entropy
> > source, which is why the hypervisor relays TRNG SMCCC calls directly
> > to the secure firmware in that case. The quality of the entropy was
> > never a concern here.
> >
> > .
> >
>
> Thank you for reply.
>
> In case that EL3 firmware not support SMCCC TRNG, host and guest can only
> get randomness from DRBG-based RNDRRS, right?
>

There are other, non-architected ways too to get entropy and/or
randomness. There are many hardware random number generator
peripherals that the OS can drive directly, and there are vendor
specific EL3 services too that a system might use.

RNDR/RNDRRS does not exist yet in practical terms - there are very few
SOCs that actually implement that used in the field.

> In this case, guest get DRBG-based randomness via HVC and host, but the
> randomness returned by host kvm is not really backed by EL3 SMCCC TRNG,
> and actually get from DRBG-based RNDRRS.
> Is this hvc process is redundancy?
>

I don't understand this question. How the host obtains its entropy
and/or randomness and how the guest does it are completely separate
concerns.
