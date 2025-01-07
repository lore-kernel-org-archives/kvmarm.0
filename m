Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF611CEAD6
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 22:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736288039; cv=none; b=lmAyI/z551e8V9b1XBNPVmdnMRVXcSSEx+/HUQhcaKw50JkSSu0tHfE5EmtBNuqCWvAeCxJsyMiw7CvhwaYCEzJwfpqXEYmFB4pbUvUdHHzIfnyY7tDIQ3v/5UPJ4cX76nhkohz19cSo75gfqngoxi9fma8WzA237mwx5Cm6fUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736288039; c=relaxed/simple;
	bh=HdwVvS5YRWYy+X66YIRHR2jVXTWZeiPKiRtuluGslOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AZx8LXklNVgwxy7vPcxvXHEhYpQ26zac0pJmaP2keL4S3d5OVC9R3U4/6l4t8avoo22r/O4xHVKfTK+2Z4KYM2kjrk+O9WVnGyn6u4nOCNoe2CHIGrHUHwvayr4Xl8jmvu7Xk6mCyEDDD1ObZdIBLqg6rCSw0cwoYYky6KD59qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OpgPdyoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OpgPdyoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D82C4CEE3
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 22:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736288039;
	bh=HdwVvS5YRWYy+X66YIRHR2jVXTWZeiPKiRtuluGslOM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OpgPdyoI/qXFxuUK81gR/mdcIXwSac7xdGwvvzlqkTsJ7l/XMqD8X/V4uak7N+RBH
	 w+22MTJmLffp6nc/8w+LcZgGQIcyOWBeklFCU814y1beSb2mZjEbMb4P9JL+Ub/WnI
	 +8gObIc0+nZP/apsne0U+LSf9xyhuIL1hz7lXKlP44B/pPAyV1OcMpU64Jcb2MsNTK
	 En67oY+tT0jTfLQIylts6UNtBikn9/hOWuS5gJ6mQBjkcmT9W3fyT2f5qih2eqPjeX
	 Iho/V/uK8PKVhoMPKHzwtmNy52IfuUJWscCISuTCV8QMmArMT0URbw0f9rw+z1aUpQ
	 E98VKc5MYxhYg==
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e5372a2fbddso24460952276.3
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 14:13:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVOsT3MuumnI4CaOCUmon+MVI2O/moqy4ZP4LAotFnHXJ47PXnbCI15wgI9DfEeyBRtZyUqIfc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsFkvBwdrahPA7D1zdbwnOjukmOl/ZofPz8paLXEWDS4hSFZ3s
	vdQlZ32a1P7QCFdQ10uFdZkJ1R6kdPnp9oMjexQyqZwVudqOcDG64ndhuktETj5GoWz9aFsr//8
	xvRxWirCxKlZSXzX0V7oxTx0DGw==
X-Google-Smtp-Source: AGHT+IFsh1HXmQAP2bGRyE7hz1zGs5lIpyqneBnIDxdxSA54RLNAftmVAVswBtYnrPy5s6t9RW1k/So8Ym4UnckSWiI=
X-Received: by 2002:a05:690c:4509:b0:6ef:4a57:fc98 with SMTP id
 00721157ae682-6f5312246ebmr6224027b3.16.1736288038565; Tue, 07 Jan 2025
 14:13:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241220072240.1003352-1-anshuman.khandual@arm.com>
 <20250102160402.GB3990035-robh@kernel.org> <Z30adHnQ7ZFaU9UR@arm.com>
In-Reply-To: <Z30adHnQ7ZFaU9UR@arm.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 7 Jan 2025 16:13:47 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLLnh1o4L1=PpNt5brBwZZCgp7mOygByOYakchrzc29Ow@mail.gmail.com>
X-Gm-Features: AbW1kvYLKFdW_S3KNw6GmCK3ZvUZjTNYLuDcgaEWTnLEiyEGd8fjimnTAOW_1VM
Message-ID: <CAL_JsqLLnh1o4L1=PpNt5brBwZZCgp7mOygByOYakchrzc29Ow@mail.gmail.com>
Subject: Re: [PATCH 0/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-arm-kernel@lists.infradead.org, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 7, 2025 at 6:13=E2=80=AFAM Catalin Marinas <catalin.marinas@arm=
.com> wrote:
>
> On Thu, Jan 02, 2025 at 10:04:02AM -0600, Rob Herring wrote:
> > On Fri, Dec 20, 2024 at 12:52:33PM +0530, Anshuman Khandual wrote:
> > > This series adds fine grained trap control in EL2 required for FEAT_P=
MUv3p9
> > > registers like PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 which are a=
lready
> > > being used in the kernel. This is required to prevent their EL1 acces=
s trap
> > > into EL2.
> > >
> > > PMZR_EL0 register trap control i.e HDFGWTR2_EL2.nPMZR_EL0 remains unc=
hanged
> > > for now as it does not get accessed in the kernel, and there is no pl=
an for
> > > its access from user space.
> > >
> > > I have taken the liberty to pick up all the review tags for patches r=
elated
> > > to tools sysreg update from the KVM FGT2 V2 patch series posted earli=
er.
> > >
> > > https://lore.kernel.org/all/20241210055311.780688-1-anshuman.khandual=
@arm.com/
> > >
> > > Rob had earler mentioned about FEAT_FGT2 based trap control requireme=
nt for
> > > FEAT_PMUv3p9 registers that are currently being used in kernel. The c=
ontext
> > > can be found here.
> > >
> > > https://lore.kernel.org/all/20241216234251.GA629562-robh@kernel.org/
> > >
> > > This series is based on v6.13-rc3
> > >
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: Mark Brown <robh@kernel.org>
> > > Cc: Rob Herring <robh@kernel.org>
> > > Cc: Oliver Upton <oliver.upton@linux.dev>
> > > Cc: Jonathan Corbet <corbet@lwn.net>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: kvmarm@lists.linux.dev
> > > Cc: linux-doc@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: linux-arm-kernel@lists.infradead.org
> > >
> > > Anshuman Khandual (7):
> > >   arm64/sysreg: Update register fields for ID_AA64MMFR0_EL1
> > >   arm64/sysreg: Add register fields for HDFGRTR2_EL2
> > >   arm64/sysreg: Add register fields for HDFGWTR2_EL2
> > >   arm64/sysreg: Add register fields for HFGITR2_EL2
> > >   arm64/sysreg: Add register fields for HFGRTR2_EL2
> > >   arm64/sysreg: Add register fields for HFGWTR2_EL2
> > >   arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
> >
> > In case it is not clear, this series should be applied to 6.13 as the 2
> > PMUv3p9 features already landed in 6.13 (per counter EL0 control) and
> > 6.12 (ICNTR).
>
> So is this a fix that needs backporting to 6.12 or 6.13, e.g. fix for
> d8226d8cfbaf ("perf: arm_pmuv3: Add support for Armv9.4 PMU instruction
> counter")? It's pretty late in the cycle to take the series for 6.13.

Ideally, yes. But given the state of h/w implementations, backporting
it later is probably fine if that is your preference.

> But does KVM actually expose the feature to EL1 in ID_AA64DFR1_EL1 and
> than traps it at EL2?

As Marc pointed out KVM only advertises PMUv3.8. Regardless, guest
accesses to these registers are trapped with or without this series.

Rob
