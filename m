Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7299D2753F5
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 23:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739488618; cv=none; b=o3lAovpgk5wMgS6hornKlqMw3oDgDRl9ybbUgYtmVF7EyEITdr+BZkrtP8uYl9nDKS+4Mgc354+eturqoGa1lvL/F6Qg0QLJOmqrvlWlidDKOwxzgC0zUSH+syywciLX/EdxVBuGfE+HEl84yXKlvEkNrnC6cioHjX48kIA3h28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739488618; c=relaxed/simple;
	bh=PbaotEZP+m8XRdqTM1LVCryKI8mpwAv32w3xxrZJ6bY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GlBnCUZvIIIVUCBn5YCYCqcm1xF7vmCO8vCwcuHTEwRJwP4QhegrRxg1BcS5Yr0hXGawhI6awdL0K4Rqe1F5TZQFzONN8zKDGsFr7xesSSaIUSYBnNJPMjCcI6+Za6LDt1XrTNcQdRJ+ck28SJir+Jt8tCHLxniduNUk9oVIxLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4DX/p8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4DX/p8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FA3C4CEE5
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 23:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739488618;
	bh=PbaotEZP+m8XRdqTM1LVCryKI8mpwAv32w3xxrZJ6bY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=q4DX/p8YgONWF7jft3QA2zVg9bpHaWiEjzj1Lk5a7HJTwGrMuSN5ZSk7axKPE5pSO
	 Gg6k34cRunocqRdktHghHjD8KEAf7VXXbuQMAYjvpf/60/ME3MDH660qBhLO1MM7p7
	 fuULtg3lCK9tUr8UP9j+E8Yum/wP6+i3XYXfCDHCEKKzuFQXnFjW3Jc3GIHSiWEMJV
	 qr5bJANPiopabQ9YXQrMzXriIXaI+6/kaMHRln48X5ZJuH8txC5dZy5MKwH0WkmlxB
	 iXXbkHdEBcFuBQdNR37Uo3Gd7dmD2aqT8XWxnMwhGpL8L4haCQDUElZ1TNSe4yTJNf
	 TRrvnSauK5k9g==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab7f76aeedbso178488966b.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 15:16:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUmDfjJmcBFqvGj/F/YAqo5GxIL7XRvH9V9jXSsmmsA9EPX4couQPA1ADa/o2jbl5YQN+o6gh0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMqGo6S8du4vSHEsZ8Eoq4nFtK9OrEplL14sBH5tK27z0hTwzH
	1Zs1AjIY4K/QWzOtpHuwWDiccPYkFuAlVsqMpeTq21+GE84f9tnUxO4yOp3r46lTzrcoXHSb8Qr
	yM8cE4oScR77F7gIVecxgR4/xKg==
X-Google-Smtp-Source: AGHT+IGLrIInhW0p35GiI23AsyVIN74+uSLw8U4olfJQyjWCTit8hu/L8OG/iKoT6DsuxRq4cMhDCBZc2Okeg3yqD4I=
X-Received: by 2002:a05:6402:194b:b0:5de:b947:b22a with SMTP id
 4fb4d7f45d1cf-5dec9d393e8mr13551333a12.11.1739488616517; Thu, 13 Feb 2025
 15:16:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-10-1c1300802385@kernel.org> <20250213170316.GG235556@e132581.arm.com>
In-Reply-To: <20250213170316.GG235556@e132581.arm.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 13 Feb 2025 17:16:45 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLG4gu6c6=x_wG6XT0WaCC_ahH5eWHk3K9RcF0ZQrDR=A@mail.gmail.com>
X-Gm-Features: AWEUYZlrsV2jIVl8kJ5LHYnXDNpl0R31s2FyNrbBoqdloE1Gq92xxV4Cm7lY0Lg
Message-ID: <CAL_JsqLG4gu6c6=x_wG6XT0WaCC_ahH5eWHk3K9RcF0ZQrDR=A@mail.gmail.com>
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

On Thu, Feb 13, 2025 at 11:03=E2=80=AFAM Leo Yan <leo.yan@arm.com> wrote:
>
> On Sun, Feb 02, 2025 at 06:43:04PM -0600, Rob Herring (Arm) wrote:
>
> [...]
>
> > +static void __debug_save_brbe(u64 *brbcr_el1)
> > +{
> > +       *brbcr_el1 =3D 0;
> > +
> > +       /* Check if the BRBE is enabled */
> > +       if (!(read_sysreg_el1(SYS_BRBCR) & (BRBCR_ELx_E0BRE | BRBCR_ELx=
_ExBRE)))
> > +               return;
> > +
> > +       /*
> > +        * Prohibit branch record generation while we are in guest.
> > +        * Since access to BRBCR_EL1 is trapped, the guest can't
> > +        * modify the filtering set by the host.
> > +        */
> > +       *brbcr_el1 =3D read_sysreg_el1(SYS_BRBCR);
> > +       write_sysreg_el1(0, SYS_BRBCR);
> > +}
>
> Should flush branch record and use isb() before exit host kernel?

I don't think so. The isb()'s in the other cases appear to be related
to ordering WRT memory buffers. BRBE is just registers. I would assume
that there's some barrier before we switch to the guest.

> I see inconsistence between the function above and BRBE's disable
> function. Here it clears E0BRE / ExBRE bits for disabling BRBE, but the
> BRBE driver sets the PAUSED bit in BRBFCR_EL1 for disabling BRBE.

Indeed. This works, but the enabled check won't work. I'm going to add
clearing BRBCR to brbe_disable(), and this part will stay the same.

Rob
