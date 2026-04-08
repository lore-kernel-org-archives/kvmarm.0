Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A78A21CA03
	for <kvmarm@lists.linux.dev>; Wed,  8 Apr 2026 07:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775634453; cv=none; b=OD6M0laR+hR3vjyu7zxXNFnkbxIfzwQ0FKCgD/9qxWtAaWmxM5jjR0NRk4ZFoB8V0vYw6/rTUhGpzG0h82KfjJkIuWh5+N6saG28qbe7rzY/NRNdtGybR2IS7lZxQBXWDVrNPJvXxSeGQ6OCdWDFCxHGvP8i5yeYODp5xmRb3ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775634453; c=relaxed/simple;
	bh=6FGBj6R+3TxRy3lV+rTYpY2sUBGm3uINry4jtIg9hmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WK8p9Y10IlCBF6fbCMmVn4/ZGFaRV5DZsSY3YErATbajYqlk6n/SAZFEICoanknwt0aSnEbc/UjfsH5ultpbzBxzcsTJkp1Zm/dY+xxaU0jiE7Pjzix1rY98USHO0aylQl00lBq+9H/5FfCSfUu6rl7zlpCOURi6GCoZ3gLKuYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rXQ4q2UL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rXQ4q2UL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2578CC2BCB0
	for <kvmarm@lists.linux.dev>; Wed,  8 Apr 2026 07:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775634453;
	bh=6FGBj6R+3TxRy3lV+rTYpY2sUBGm3uINry4jtIg9hmo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rXQ4q2ULZrTR194/yg/YQc05sJXt8dCgV0yeKGyulNkmqpXy+tCd2qNDRyg8WzBYc
	 WVlQDBQauUo/4kcKlC4qaQJp+gXOzJubLk7Um48P/KR/vDL6+Zqp/T9UbqJuuQ7yS7
	 GGlTUYB9hWjyS0ATsxb5q4lIglsc0/GYBjKSEzAS2ndsjDZmuV7Cqq3tITdzES4Ohf
	 eEYavR2JHvowp7jmF7oM/mAECQ1LEVJaGUk7wxSaUGBfe0+nV9k0IR7GDylLbSN/Mz
	 X1HlBf8CwDzwutz2jBtrv+90Oi0tUSEZ7XFBonRTGLVSAJPrxHzovMyJPTq+f9JB/8
	 D1ZKOzhZrRYrg==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-79885f4a8ffso55923327b3.3
        for <kvmarm@lists.linux.dev>; Wed, 08 Apr 2026 00:47:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXYk+eHHdHPIcA/76I3ngtfO4H/WMh33Rn0mfbqSKu25tX+VYPIEr4VvY4YgECR5J0QIdhu3Ng=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/pdXDdSeuJa+pGp3mX7DXTCMvz1zi7se1HS+4FZUKC8/R6JUF
	OX580dWuQQfzMGhYdLjpMM7bn5UA4lpquO211VL6SxyzTcqWyxl293F/kuu2ahsulqieyzuIu8E
	J4Y5xcJqmTn6njARHVPDTrBs5tqIXmVY=
X-Received: by 2002:a05:690c:102:b0:79a:40fb:9346 with SMTP id
 00721157ae682-7a4d6d26cf8mr204354257b3.20.1775634452513; Wed, 08 Apr 2026
 00:47:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260306-aarch64-clear-pages-c-v1-1-77c1bb0f1c21@kernel.org>
 <ac7YJPo4Np2zxxEp@arm.com> <CAD++jL=G81=ueo7djqUETToE459kpFGniWvBwnYbJtmXrm8MFw@mail.gmail.com>
 <adULAT2xus5z3HdQ@arm.com>
In-Reply-To: <adULAT2xus5z3HdQ@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 8 Apr 2026 09:47:20 +0200
X-Gmail-Original-Message-ID: <CAD++jLmMxj1C7sGz-Yt8Y+NC1CbrUTTSH4QvcZfYuJAcNoYYCQ@mail.gmail.com>
X-Gm-Features: AQROBzCKD15vLZOPpJlr1WJAhz9pR_gLMWe3rxqqBD2IrNa8GJfdGMWD0iaN0Lk
Message-ID: <CAD++jLmMxj1C7sGz-Yt8Y+NC1CbrUTTSH4QvcZfYuJAcNoYYCQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: clear_page[s] using memset
To: Catalin Marinas <catalin.marinas@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 3:47=E2=80=AFPM Catalin Marinas <catalin.marinas@arm=
.com> wrote:
> On Tue, Apr 07, 2026 at 11:25:55AM +0200, Linus Walleij wrote:
> > Quoting my own commit message hehe:
> >
> > > No performance regressions can be seen, the fastpath
> > > benchmarks differences are in the noise.
> >
> > This was tested on hardware with Ryan Robert's fastpath tool.
>
> BTW, have you tried the perf bench mmap test again with the new
> clear_page? Both with single page and multiple pages scenarios. And
> ideally on more than one platform.
>
> Will pointed out (in a private chat) that current clear_page() uses
> non-temporal stores while memset() doesn't. It may not make any
> difference in practice but it would be good to have some numbers.

Hm interesting point, the perf bench mmap test isn't specifically
in fastpath but since it tends to come up I guess we can add it?

Ryan: is it easy to add this test to fastpath? Or easy for me to do
myself? I looked at the instructions but they were a bit intimidating...

The test is the following:

    We boot the kernel with cmdline like this:
    "default_hugepagesz=3D1G hugepagesz=3D1G hugepages=3D32" to make sure
    we have ample hugepages. This was then tested with the same
    cmdline as the original series:

    perf bench mem mmap -p 1GB -f demand -s 32GB -l 5

    The first run was discarded as the memory hierarchy is cold on
    the first run. Then I ran the above command 5 times and averaged
    the throughput

The x86 commit cb431accb36e51b64ce34b5cc4d5ed292895fd84
also mentions this test:

perf bench mem memset -k 1GB -f default -s 16GB

I tried it on QEMU, no real benefits with either the previous or this
patch, and no regressions either. (x86 passes -f x86-64-stosq
which are some optimized memset instructions)

Yours,
Linus Walleij
