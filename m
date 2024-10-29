Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE05E1DFE3C
	for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 08:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730191975; cv=none; b=oijgwfCXKO4Xh8v6vX2vJRWNFpcsh02aD+wc7fuRmmOn+iD2q2mvY4fnFAjk9u8vsyFwT+8bTrbDXtqYnr1S4VJAg2AYuEj+VfhzGp6+j9L6/IAXfOwAYnap6I28pPeMeHjwMKALZpfrLl3kFNL3rm45XAT93i8uFSw2OHxUdwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730191975; c=relaxed/simple;
	bh=Eq7yUIT2qNvwteaJ4TiyipPQcxNOXMFMXDaSsi1L3IE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FBF8v9exyS16V8OA+Knf04j+mbvdSdS8qsa+NMEtuloa5mPj8lY0z+phzI2ZfUJ39h8vh/SfZFNsBUj3971RrCWEuHDS7/01Bama1aXXuNJhU/5NIRIS5pQuaiOM57vN/qopH5UY5/QBAwOfeDq6m+kTuirczfLNs+4l2OB3AvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWAG37Q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWAG37Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AE6C4CEE8
	for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 08:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730191974;
	bh=Eq7yUIT2qNvwteaJ4TiyipPQcxNOXMFMXDaSsi1L3IE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EWAG37Q1/jPMEVARQaHwWgoD4IZPOBXva5IpmdjJzocLbSOznobsK4CEPiF6uCV9c
	 AJmWpDj8tiLB+miJQvdPkhQMsikJ3gbBMBH+wDrTl9zbr4QxPMvqwyt49D5L+0fa3A
	 /b2r669wDDaCKw2h5Eucs06HTrqOZType/asvgQpnKP9y7YV6DbY0Zc7x1CFtf49tf
	 gwJqf4oti+Mi6q8QSxE5/tD5R+0GcubBlwFGY0wIUxpdDultVSVoG+6sOu1Yxm3CgR
	 tuTVHBrAGjHVpWGh7Ip8wrnR9LKFU8BYgU+4GGD/WhgqyQq8TkntmMtdpJxG5kFBxX
	 kolluovqzMpsw==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fb3c3d5513so45446171fa.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 01:52:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCURuOfPDSBEppGjcJdcVNMPxrHBh6wcJJUG9IA8l2K++ds32n+IdSqTkoEuAIDPg1yzyXDCkdQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTaFDiGMNuWOIswjuNNYXhsBjVQ9lWrMuZfhbCSsPaekuro3rI
	O2ZtmbgayUspt4uAXIdeevWy0XilD0TDpSSpsdwIcYPcRswTfTCaouafeorUBVo9coXyCcAzbcQ
	/titXfVv+QF6zJr6Z7oiAPOX5RTI=
X-Google-Smtp-Source: AGHT+IGnI8jKViXA0iWd/TroHubPtwx67QuiNJEQlZ5qzLZZW3IKmHAuzNAhClw5ucQvGTKdiESCRt0pHcHTLmrSk9s=
X-Received: by 2002:a05:651c:b20:b0:2fb:51e0:951 with SMTP id
 38308e7fff4ca-2fcbdf6118cmr46645831fa.7.1730191972767; Tue, 29 Oct 2024
 01:52:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <mb61p4j4wwlap.fsf@kernel.org> <86ed4031zh.wl-maz@kernel.org>
In-Reply-To: <86ed4031zh.wl-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 29 Oct 2024 09:52:41 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEX2TLdYCn3C-AXhfhjOe6cuzOmd0h5MbgXnzi7Q94T3w@mail.gmail.com>
Message-ID: <CAMj1kXEX2TLdYCn3C-AXhfhjOe6cuzOmd0h5MbgXnzi7Q94T3w@mail.gmail.com>
Subject: Re: Supporting KVM_GUESTDBG_BLOCKIRQ or something similar on ARM64
To: Marc Zyngier <maz@kernel.org>
Cc: puranjay@kernel.org, Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>, 
	puranjay12@gmail.com, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <zenghui.yu@linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, 28 Oct 2024 at 12:23, Marc Zyngier <maz@kernel.org> wrote:
>
> [+ArdB, which I assume you really wanted to Cc on this, as well as the
> KVM/arm64 stakeholders]
>
> On Mon, 28 Oct 2024 10:53:34 +0000,
> puranjay@kernel.org wrote:
> >
> > Hi Everyone,
> >
> > I work on the BPF JIT for arm64 and regularly use Qemu with gdb for
> > debugging by single stepping parts of the code. I realized that whenever
> > I enable KVM, single stepping doesn't work as expected and it lands in an
> > interrupt handler.
>
> I disagree. Single-stepping works *exactly* as you should expect, by
> not interfering with the rest of the system.
>
> > It always worked for me on x86 so I looked in the source code and found
> > that x86 supports KVM_GUESTDBG_BLOCKIRQ that blocks IRQs when single
> > stepping.
>
> Right, and that is not an architectural behaviour, but something that
> helps the person running the debugger. I'm not saying it is not
> useful, but that this is an *additional* behaviour that the
> architecture is not supposed to cover.
>
> Also, given that KVM_GUESTDBG_BLOCKIRQ has *zero* documentation,
> nobody felt compelled to implement it. I didn't even know of its
> existence until you mentioned it.
>
> > I assume that arm64 doesn't support KVM_GUESTDBG_BLOCKIRQ because it is
> > not trivial to implement this on arm64 due to some architectural
> > limitations? There was a patch [1] posted in 2022 to solve this issue
> > but it was not merged.
>
> That patch does the wrong thing when it comes to KVM. We are not
> building a Linux-only hypervisor, and we need a solution that works
> irrespective of the guest.
>
> > Let's start a discussion about what needs to be done to support this on
> > arm64.
>
> A good start would be to define the semantics of such a flag:
>
> - what should it affect? the vcpu you are single-stepping? all vcpu?
>
> - should userspace to know that interrupts are pending?
>
> - should this result in any effect on the guest's view of time?
>
> - what of interactions on the rest of the system (such as devices)?
>

Sorry to give a handwavy answer here, but approaching this from a
usability PoV (like what Puranjay is doing), it is really about
adhering to the principle of least surprise for the user.

So in that sense, it is not really about blocking IRQs at all, as long
as we step over them rather than into them. How that is achieved is
not that relevant from the user PoV, and maybe KVM_GUESTDBG_BLOCKIRQ
is not the right solution for ARM at all.
