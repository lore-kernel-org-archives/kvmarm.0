Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348653A3E8E
	for <kvmarm@lists.linux.dev>; Tue,  7 Apr 2026 09:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775553967; cv=none; b=n08qQ7YaVLmUr4JoO/JszXLoB7Orqo/Q/1ESwQPUz21SxmCK4D2e0bi16Fzs5HDDKyjOq2SM+hNnBeN3MhSV1cjVrCsQXaFWRJ3I0psp5IXDAq+ENKsXdQgCfy7gPbH66LNvFv74UqPFKQu0vFE9Y7OrCmnZEPCsXgIjHiYGKAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775553967; c=relaxed/simple;
	bh=35utQv1mJDn/+FVHA9rap7AYG4gs2p36qLIotZXtT0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SN4y48VVgBaYbXZac1m/ySzkd6/tw/F6D3/zjdPNDGwKYTKoQ3OkiKP2SqRy++HHVncuaPiCfXoSpfkUpkl/wx+Md0EW+WoUnxzoh4trpPOw+Ju3JCw5SZcHniRZAuja8iZZreEIY13he6siQYVtbjnHXxTjEfgiUf5S+N0l2ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kwPOA/g+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kwPOA/g+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3146C2BCB7
	for <kvmarm@lists.linux.dev>; Tue,  7 Apr 2026 09:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775553966;
	bh=35utQv1mJDn/+FVHA9rap7AYG4gs2p36qLIotZXtT0g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kwPOA/g+hTcTrDkQ3laEHU10cLlf8nRjTe2c/DeUoh57DV38a/+blLLBZSpSLjiVS
	 r7ZKEzbXxarw4uZeLSCuq3iKW2smXGmJyRUz/OX+xJzybsU7w7No+QOqxGdAqk2kdB
	 poe038axHQ+y8PtKbcWHg6z2iNz/SZM8SqvEQUD0g3nS0K6nWf6CfJKs3FtnuMYKED
	 j/191VqiOgd7PKAk614SOJTgGSTBH5sL/RO9m3nQ9vyI+QIevdr9slunsImKLiVHKJ
	 rbnA3ZuevAh8ecHFpTBGKwqSQH2eFXeoTiFzE3TfrysAvIfUV0dB8wxw4zyByijFfs
	 33ZKgUcGHH6Hw==
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7927261a3acso40425607b3.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Apr 2026 02:26:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXOhpdPTPSVnotQ7z9JE2VvzJ/5eGqFK+HN93NqGjKTXWCbYL8NtvAh2CX0Rg4hn9kUuuSvY68=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3BLJ20WlSD/DjaAQb5TNhGWbz4H5R/FgpvnRHz4AWAhHf/GtP
	0PARfjIgqaQCPu9+gZeCrcgGrBY/6inj5/vJN7nk6l09fhz0pIM7/i2R/BupnUnVvyxr0cwcFUQ
	sg+l+a7P205mIPA/fh0GMg6k3KcWdM6k=
X-Received: by 2002:a05:690c:dc9:b0:79b:e346:980c with SMTP id
 00721157ae682-7a4d625504fmr162419117b3.12.1775553966242; Tue, 07 Apr 2026
 02:26:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260306-aarch64-clear-pages-c-v1-1-77c1bb0f1c21@kernel.org> <ac7YJPo4Np2zxxEp@arm.com>
In-Reply-To: <ac7YJPo4Np2zxxEp@arm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 7 Apr 2026 11:25:55 +0200
X-Gmail-Original-Message-ID: <CAD++jL=G81=ueo7djqUETToE459kpFGniWvBwnYbJtmXrm8MFw@mail.gmail.com>
X-Gm-Features: AQROBzCOCkncZm_JCfvTszNJbimlQJbAZxhLdXzaXBoMHZTRztuKC4ciORt69b8
Message-ID: <CAD++jL=G81=ueo7djqUETToE459kpFGniWvBwnYbJtmXrm8MFw@mail.gmail.com>
Subject: Re: [PATCH] arm64: clear_page[s] using memset
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 2, 2026 at 10:57=E2=80=AFPM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
> On Fri, Mar 06, 2026 at 09:57:50AM +0100, Linus Walleij wrote:
> > There is no need to try to second-guess the compiler when
> > clearing memory. Just call memset() like everyone else.
>
> Hmm, that "like everyone else" made me think - why not move this to
> generic code and only the 1-2 platforms that need their own should
> override it? Could we do the same with copy_page()?
>
> Sorry, more work all of a sudden ;).

I actually had that planned, I just wanted to know if this would
be fine for arm64 first so that there is a user.

It seems you are on board so I will send a 2-patch series
next.

> > Since memset() already has an architecture-local MOPS
> > optimization, we do not need to do anything else to preserve
> > the MOPS optimization.
>
> The custom clear_page() had the (very small) advantage that it can skip
> the length/alignment checks as they are always page-size.

Yeah, it seems that is so fast that it doesn't really matter.

> > While at it, implement the shorthand for directly calling
> > the new prototype clear_pages() for larger page chunks.
> >
> > No performance regressions can be seen, the fastpath
> > benchmarks differences are in the noise.
>
> I assume the benchmarks ran on real hardware (had to ask, last time you
> mentioned qemu ;)).

Quoting my own commit message hehe:

> No performance regressions can be seen, the fastpath
> benchmarks differences are in the noise.

This was tested on hardware with Ryan Robert's fastpath tool.

Yours,
Linus Walleij
