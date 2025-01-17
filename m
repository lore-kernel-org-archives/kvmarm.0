Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AFF1BE87B
	for <kvmarm@lists.linux.dev>; Fri, 17 Jan 2025 22:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737151690; cv=none; b=Ktai30nEq/qigs0IWw1w5kDArOLHVreUCRdSkg15X6+ZJMbLVxqHvoNm0dIunArTj8g33HDMOaLzHb70091n3P07+8uSDaAcj7F3vP8TppXbGorYhqq+KK13bo71wkFhQqfafPUK6PWNl9igcDecy1ygow6tPILwj5E0DFsXo9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737151690; c=relaxed/simple;
	bh=6eMskAXrsKj+yPhrh5gsUKk0GeOs6CV2lDoAzrqp+eY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tDZ08AwBmH+HVV8SNJcbngY2tEjj02HaCjOuZ3b1GrT0kqGLre7uVgTnbt+VuuUYOvwvhN2+01+B7GmHZuO3onYtXS1S3Fi2bDuESBn7HN8Ydg+SNbtK73bvMPV8P6dgswJraapFoGY2AMyoZGOGZ19zyCn7YeXv9zFt9TMPQb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N8l/Kqq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N8l/Kqq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C02BC4CEE5
	for <kvmarm@lists.linux.dev>; Fri, 17 Jan 2025 22:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737151690;
	bh=6eMskAXrsKj+yPhrh5gsUKk0GeOs6CV2lDoAzrqp+eY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=N8l/Kqq4V9SaA8CdBa8HP/4dyleSc4jRLHY3fUjNNqrDC49X/8nR9ba78yxKm50IE
	 2YAYZvWnjmBQMedzs2D+N2qO6dU/4ZN2mymr36Tq2zXCASZlR8/Y5a2rMV47fZTF5W
	 A9RVRJgy8Z+h2pYIt0Vvn/gdcVUn4L1kpG8odH298sEC5lB1TLJ+6mNUVhPif2xJam
	 3QorP8g1IWh9kh1D0S04nU99sSjlJFiZGN3Nl8p2Ott05e0L8qcg0ia1Shvk3MA++V
	 Hezt16+AhWEcSveUT59qU/5t34dRsrqF33ZP22yU6/X+JnPiqfylInUjEQCIitpWNX
	 IEX16esO2G8aQ==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5401bd6cdb4so2693048e87.2
        for <kvmarm@lists.linux.dev>; Fri, 17 Jan 2025 14:08:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU5+cxKOBwL82N3HrI2gKuTfLQ3vrisnmjXWJut628KUZ+FTdY2fuJDJ8qf0dnX9wNtLyG8DzM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdscpzoFT4GTaLl6B4+Fnf+bJNiTX/Uu8rqIgvr+8/MgOe2twa
	qiJmW0J3RHT2Kef8G4iZJ5Zf7R+/aX+eeQNDilhvU+4ljS88FFFa1YmrOu1ORTvW+IBpKZ/p6wM
	IjJSstZvL42AaGv4EPcvUjUUIUw==
X-Google-Smtp-Source: AGHT+IEgpKi5iU2Ry8bgcFk3ypohPNuQOcWdD3eLZQ0Yrk230Xh+rHDMCHRK1H7BAsvHETXiMfMqJ+pcY/x3PQ0wC54=
X-Received: by 2002:a05:6512:12ca:b0:540:1fec:f321 with SMTP id
 2adb3069b0e04-5439c285412mr1386422e87.41.1737151688439; Fri, 17 Jan 2025
 14:08:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241220072240.1003352-1-anshuman.khandual@arm.com>
 <20250102160402.GB3990035-robh@kernel.org> <Z30adHnQ7ZFaU9UR@arm.com>
 <CAL_JsqLLnh1o4L1=PpNt5brBwZZCgp7mOygByOYakchrzc29Ow@mail.gmail.com>
 <86wmf5wo8u.wl-maz@kernel.org> <CAL_JsqKKiEOj=a1k6U-bB0F6-ht7QokDnh3bspHupp-QG=haSg@mail.gmail.com>
 <Z4kmlhnlpKjS_MII@arm.com>
In-Reply-To: <Z4kmlhnlpKjS_MII@arm.com>
From: Rob Herring <robh@kernel.org>
Date: Fri, 17 Jan 2025 16:07:56 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK1k7fG=yDZSbTbV63yRP5U9=GpuAiv=NWZJWdppUtRwA@mail.gmail.com>
X-Gm-Features: AbW1kvZCaGPAdTzQQUI5Q5j42V1TeAoCQ3yfC8Cjc8iBuIXUrThvrm6lQVxJhg4
Message-ID: <CAL_JsqK1k7fG=yDZSbTbV63yRP5U9=GpuAiv=NWZJWdppUtRwA@mail.gmail.com>
Subject: Re: [PATCH 0/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jonathan Corbet <corbet@lwn.net>, 
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 9:32=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> On Wed, Jan 08, 2025 at 07:47:16AM -0600, Rob Herring wrote:
> > On Wed, Jan 8, 2025 at 5:15=E2=80=AFAM Marc Zyngier <maz@kernel.org> wr=
ote:
> > > On Tue, 07 Jan 2025 22:13:47 +0000,
> > > Rob Herring <robh@kernel.org> wrote:
> > > > On Tue, Jan 7, 2025 at 6:13=E2=80=AFAM Catalin Marinas <catalin.mar=
inas@arm.com> wrote:
> > > > > But does KVM actually expose the feature to EL1 in ID_AA64DFR1_EL=
1 and
> > > > > than traps it at EL2?
> > > >
> > > > As Marc pointed out KVM only advertises PMUv3.8. Regardless, guest
> > > > accesses to these registers are trapped with or without this series=
.
> > >
> > > And most probably generates a nice splat in the kernel log, as nobody
> > > updated KVM to handle *correctly* PMICNTR_EL0 traps, let alone deal
> > > with the FGT2 registers.
> >
> > Isn't that this series[1]? Should that have come first, I guess I know
> > that *now*.
> [...]
> > [1] https://lore.kernel.org/all/20241210055311.780688-1-anshuman.khandu=
al@arm.com/
>
> It's not any clearer to me. Does this series depend on the 46-patch one?
> Or, if we had the other, is this no longer needed? Or none of these,
> they are independent.

They are independent. I think ideally we'd want everything landing at
the same time, but we're past ideal at this point. Without this
series, if someone uses PMU on v8.9 and firmware enabled FGT2, then
the kernel will crash. Without the above series, KVM will have
warnings in the kernel log, but otherwise function.

Rob
