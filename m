Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560281D693
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 12:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2+JZsuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB41C433CA
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 12:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699878567;
	bh=SJN5bW1ZFMyrYWdnd9oeAnUZsnaw5OVzwMsibVz4EjY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=p2+JZsucLhUAmD3WUmKkb8JW1f3UjiTXjsq9meXFLt4TGLJKsXKtHrX2+/j1YydJZ
	 QPrGQb3wvXW6pj05uOfWqyg/SbqKiKIce7o2DyHGg9qZZTjwrn1XZ3XjWPefiQ5NtX
	 +P98Mxiw03qG6VxSCp4sDwJMPY0Gtgavh8pzVve6kb47GlB9Seck15gAwyeiH+kDdO
	 AXmiT0m8Gn6PMuz+2jP6DLB43+hCgo1E0g1dJV7DWxTDwaOvRU2d9+2mFRQPaaM0t2
	 qOCBAq+WKYoUaq1Oapfh5S+hylL+uLNTgtfzUzp2og1Ggpro8WZZfEUNWMZAH+APoS
	 uyiMY0huaTZwQ==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2c595f5dc84so59099711fa.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 04:29:27 -0800 (PST)
X-Gm-Message-State: AOJu0Yx6gG5Rep0UJf+0rFaFYJ/IUP33XiIiOJsZ61yTQi2KM87osUbf
	N5cEv+7EVLcea/S+G9W0/UuZuLTrQCA1hqcHl+U=
X-Google-Smtp-Source: AGHT+IElvnzzqL105ftfwL5ACyTa1WR0sfR3Z1rJ2N7qkIerao4BzeZU4PPX2eXuDzShNQRQPxYVonKle26N+Ju3u14=
X-Received: by 2002:a2e:3c10:0:b0:2b9:4891:a9ad with SMTP id
 j16-20020a2e3c10000000b002b94891a9admr2245688lja.11.1699878566039; Mon, 13
 Nov 2023 04:29:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027115634.1432154-1-ryan.roberts@arm.com>
 <3800df70-73f2-44b7-a6ed-15ec0bd63f5f@arm.com> <868r7126bp.wl-maz@kernel.org>
In-Reply-To: <868r7126bp.wl-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 13 Nov 2023 22:29:14 +1000
X-Gmail-Original-Message-ID: <CAMj1kXFw1J2JgSj6MH+Y0m3VBZ_GU2=W8DtN637pOLQvwm1zwQ@mail.gmail.com>
Message-ID: <CAMj1kXFw1J2JgSj6MH+Y0m3VBZ_GU2=W8DtN637pOLQvwm1zwQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/3] Update tlb invalidation routines for FEAT_LPA2
To: Marc Zyngier <maz@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Mark Rutland <mark.rutland@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Kees Cook <keescook@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Nov 2023 at 22:20, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 13 Nov 2023 11:55:01 +0000,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
> >
> > On 27/10/2023 12:56, Ryan Roberts wrote:
> > > Hi All,
> > >
> > > As raised yesterday against Ard's LPA2 series [1], we need to address the TLBI
> > > changes to properly support LPA2 before Ard's changes get merged. So far those
> > > changes have been part of my KVM LPA2 series [2]. So this is an attempt to split
> > > the TLBI changes to make them independent. The idea is that this series would go
> > > in first, then Ard's and the rest of my series can race eachother and it doesn't
> > > really matter who wins.
> > >
> > > I've attempted to address all of Marc's feedback against the versions of these
> > > patches posted at [2], including adding benchmark data (see patch 1). Although
> > > if people are still nervous that this could regress non-lpa2 performance in some
> > > cases, I could rework so that there are lpa2 and non-lpa2 variants of
> > > __flush_tlb_range_op(), and the correct version is chosen at the higher level
> > > (based on lpa2_is_enabled() / kvm_lpa2_is_enabled()).
> > >
> > > It turns out that we won't be able to key LPA2 usage off the same static key for
> > > both the kernel and kvm usage because the kernel usage additionally depends on
> > > CONFIG_ARM64_LPA2 being enabled. So I've introduced 2 stub functions
> > > (lpa2_is_enabled() and kvm_lpa2_is_enabled()) to advertise it. Ard already
> > > defines and implements lpa2_is_enabled() in his series, so there will be a minor
> > > conflict to resolve there. I plan to define kvm_lpa2_is_enabled() to be the
> > > static key for kvm in my series. Marc, would you be happy with this approach?
> > >
> > > Anyway, I wanted to put this out there as an RFC. If we are happy with it, then
> > > I'll re-post on 6.7-rc1.
> >
> > Marc, All,
> >
> > I polite bump; I never heard back on this. I'm planning to post my LPA2/KVM
> > series on top of v6.7-rc1 in the next day or 2. By default, these 3 patches will
> > be the first 3 of the series. But if you have an issue with the approach it
> > would be good to work out an alternative plan to avoid wasting effort preparing
> > the series.
>
> No specific concern on the approach. Having a static-key for the KVM
> side is good, and the uplift on the range stuff seems compelling.
>

OK, I'll put these at the start of my ++v as well.

Thanks,
