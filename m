Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BC32500CD
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739888288; cv=none; b=P5zMAQHeboYrR4iE1P/C5AFtE4MxB3GOXQ+w33hcGx+pxx6pSouwSg9HZXg2x56/Xb/suO40C5er2drqoqRY3kCj6iewjSx0Gczx6EN9EblPMOVfw1+BMXbJ3tHUkl19x9tTpRmik3NvFFppbr8skSESTsIBF7G8HvABFWEeCoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739888288; c=relaxed/simple;
	bh=D8kZnHjA1rXfyapCTwJZXFhgI2zAmDfKIad3GOdpWqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IvJiJH+GafzGa5mbmXAs/9YPA4RjthadnnRn9iJ2c9KygaVlnVh87SsD3t4Q98tFHxKT26s5SZVswPBXHA0zsrYioLAEHeiK+Lhhgnkk01gZu7hkCxG78MveRO/BNXGXDnzdOlMy0bVIZFG3o3vmruMLP+dLG5whIgkmuRstKIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pJR2eL0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pJR2eL0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A46DC4CEED
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 14:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739888288;
	bh=D8kZnHjA1rXfyapCTwJZXFhgI2zAmDfKIad3GOdpWqA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pJR2eL0DvjA01+7CE7zYyDceU2Zqyou6TZvX9c/+zyYfoFJHbq2zBTFr6N3ODf6ws
	 g1GopUwmjiNjDBgXwU9ByvlDuciZMbe8H2/mRccrpL7p9W2r3zXaUj65/RrTtBVUST
	 1uKHaNW6eFDK1qWVRSep/QtMbtLG5p3AyinM5LIdYlk0/05CVIu3rIpSsqMzNPn85j
	 zuiFQLeD/fLZOBS3m/JkfVyISZ+Q0yP6g/CcTk73oCczf3+NmLVxUtnQMRx+m2eIsd
	 1BAzUHMlZoxPLSEryMluCuy1Gvp7vGWr0LTVnXzdjxbPC9T/oY9jjlVU6n7CrqIn/3
	 /q6m4Mx1FRBDg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-abbb12bea54so239962766b.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 06:18:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWO+iHLovSGG4Ww6ViOZfRGXKhGvK2dhMvCLRjECeNpFvsXlMI3whFGidqo3MtD7lY+yd+1iCM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzF2qRSQF6djvpgrVxsg5NcHTV6kZWz1DDVozNlZmqdtaboyTmu
	fZj74gsvDclxFvrRhJwoYZ7DGh73Zpk7zs0oA0tEhb5YxIFXI0sckcAUjQ/AeOmw2NqwkpRM4is
	DX4MW5YJ/eepkfTrVPiSW9jcnJA==
X-Google-Smtp-Source: AGHT+IFQE4oOobZPiWrftCcgo9BjOEPo3oua0op7T6iVGDLGZJBO05pjxcR+PzST0w0ODcyv2rXV4Db+HB2amm1Z//Y=
X-Received: by 2002:a17:906:395b:b0:abb:b12b:e103 with SMTP id
 a640c23a62f3a-abbb12be1fbmr459701166b.34.1739888286742; Tue, 18 Feb 2025
 06:18:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-10-1c1300802385@kernel.org> <20250213170316.GG235556@e132581.arm.com>
 <CAL_JsqLG4gu6c6=x_wG6XT0WaCC_ahH5eWHk3K9RcF0ZQrDR=A@mail.gmail.com> <20250214095512.GI235556@e132581.arm.com>
In-Reply-To: <20250214095512.GI235556@e132581.arm.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 18 Feb 2025 08:17:54 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK1EThLB3uc+udfOP8cbjMFn_peoW2CBk9D-yRF3sQStg@mail.gmail.com>
X-Gm-Features: AWEUYZlO5g0ZR9Ma_W5K7w398a_T1PS6uFZonzgnuMJwLsaDJ9E3LMdaxbe1kkA
Message-ID: <CAL_JsqK1EThLB3uc+udfOP8cbjMFn_peoW2CBk9D-yRF3sQStg@mail.gmail.com>
Subject: Re: [PATCH v19 10/11] KVM: arm64: nvhe: Disable branch generation in
 nVHE guests
To: Leo Yan <leo.yan@arm.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	James Clark <james.clark@linaro.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 3:55=E2=80=AFAM Leo Yan <leo.yan@arm.com> wrote:
>
> On Thu, Feb 13, 2025 at 05:16:45PM -0600, Rob Herring wrote:
>
> [...]
>
> > > > +static void __debug_save_brbe(u64 *brbcr_el1)
> > > > +{
> > > > +       *brbcr_el1 =3D 0;
> > > > +
> > > > +       /* Check if the BRBE is enabled */
> > > > +       if (!(read_sysreg_el1(SYS_BRBCR) & (BRBCR_ELx_E0BRE | BRBCR=
_ELx_ExBRE)))
> > > > +               return;
> > > > +
> > > > +       /*
> > > > +        * Prohibit branch record generation while we are in guest.
> > > > +        * Since access to BRBCR_EL1 is trapped, the guest can't
> > > > +        * modify the filtering set by the host.
> > > > +        */
> > > > +       *brbcr_el1 =3D read_sysreg_el1(SYS_BRBCR);
> > > > +       write_sysreg_el1(0, SYS_BRBCR);
> > > > +}
> > >
> > > Should flush branch record and use isb() before exit host kernel?
> >
> > I don't think so. The isb()'s in the other cases appear to be related
> > to ordering WRT memory buffers. BRBE is just registers. I would assume
> > that there's some barrier before we switch to the guest.
>
> Given BRBCR is a system register, my understanding is the followd ISB
> can ensure the writing BRBCR has finished and take effect.  As a result,
> it is promised that the branch record has been stopped.
>
> However, with isb() it is not necessarily to say the branch records have
> been flushed to the buffer.  The purpose at here is just to stop record.
> The BRBE driver will take care the flush issue when it reads records.
>
> I agreed that it is likely barriers in the followed switch flow can assur=
e
> the writing BRBCR to take effect.  It might be good to add a comment for
> easier maintenance.
>
> > > I see inconsistence between the function above and BRBE's disable
> > > function. Here it clears E0BRE / ExBRE bits for disabling BRBE, but t=
he
> > > BRBE driver sets the PAUSED bit in BRBFCR_EL1 for disabling BRBE.
> >
> > Indeed. This works, but the enabled check won't work. I'm going to add
> > clearing BRBCR to brbe_disable(), and this part will stay the same.
>
> Seems to me, a right logic would be:
>
> - In BRBE driver, the brbe_disable() function should clear E0BRE and
>   ExBRE bits in BRBCR.  It can make sure the BRBE is totally disabled
>   when a perf session is terminated.
>
> - For a kvm context switching, it is good to use PAUSED bit.  If a host
>   is branch record enabled, this is a light way for temporarily pause
>   branch record for the switched VM.

We have to read BRBCR to see if it is enabled as PAUSED is unknown out
of reset and the driver may not exist to initialize it. Either way, it
is a register read and write, so same overhead for both.

Rob
