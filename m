Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B854D1119F
	for <kvmarm@lists.linux.dev>; Fri,  8 Dec 2023 08:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K/Y4xi7f"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-67a9be1407aso10427866d6.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Dec 2023 00:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702023335; x=1702628135; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3ub3Jzzz5y5fyO+FkwY3Gx2XWFJ/K/7duZHsm6x2R4=;
        b=K/Y4xi7fGc5dxeI+JZGfBvoCul2rOkVP91R/hrsvjs6eo0/qZ5uZZhttNv+zSL0Qjl
         vH8Xtj9PSt3Es1fi1gJ8L+1cTR/OIT9KWC4CS4q/q3Csejm1Iypcv/L4RSu9PtKTjkBJ
         CMJLa3AUE2aqWtRy+t6wpYL2or1a39du0UpFH8K9fIu67N7MHlSf5p8P8q7ONdL7iMYO
         DPwBwx6v/kjxL9sq8LvtziSPUdTEw6RZ9pHCk17pvNVEkYoxAdV97s2ruRhf/n7LN5In
         HMH7nUFZkU3+Q/VyOBPzaGb1HjMRwe2izkCGMjspnrsQuaXnXyiVdKjk/UvskZRVyk8l
         ShxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702023335; x=1702628135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c3ub3Jzzz5y5fyO+FkwY3Gx2XWFJ/K/7duZHsm6x2R4=;
        b=OASF+yw1HGteOy6EneYwsdlNcraJXcGymgw5aN7ii+zdXqA1i+9Eb4XCdpMthhT1K2
         xBihLeg+9VFMPfCQ4gOI7KOl0ahtTXnPxNBHDeQ3MNS4aiwHvROLdTYYuJBRuUxFa/Dh
         YuzKyVRl7CHwuSICYOFMYiBEkx4piD8U26xWhozEOdp+LhSKPYpY8uoi/F9O0yy2DQq2
         RTFUNh8EFwkIptz2TcQggPk6EdDmroZIEiRM/WeNOf0u5Q9EL/pUCQG+kiQmYVbJ2Nxa
         +3QKqWh7Zu+BltRVZhxZy1mcoTwXdJXK31pQ5TgQdp2oBub1/lzKyCcnXZ95HAvx8BBD
         kTJw==
X-Gm-Message-State: AOJu0Yy6wQTtyzRre8Kt4Vn9LI/Ubi1Xhch3xVpXFbfOi+ozhb1YFo9Q
	v9YCBeu1k/+ldWCyGi21qA1nSQ5WJ0xBkJBqlVADWQ==
X-Google-Smtp-Source: AGHT+IGH7LX2tBtIbUV2kFIJOyChlYf6VQSyp4qHEqjHEBgDqAP/MJMwJ9LfDLyhqw4/smawHhP0vWa1EUF/nO6emIA=
X-Received: by 2002:a05:6214:d88:b0:67a:9ac1:99ac with SMTP id
 e8-20020a0562140d8800b0067a9ac199acmr4653597qve.51.1702023335350; Fri, 08 Dec
 2023 00:15:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com> <20231206100503.564090-2-tabba@google.com>
 <7c85421b-5dfd-4931-bb14-aa2416e54b58@sirena.org.uk>
In-Reply-To: <7c85421b-5dfd-4931-bb14-aa2416e54b58@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 8 Dec 2023 08:14:58 +0000
Message-ID: <CA+EHjTx7LJJzOHbO=ubWtuwhbVXd3FyX99Y6LxkT6u9vSx8qxA@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] KVM: Add missing HCRX_EL2 field definitions
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

Thanks for your reviews!

On Thu, Dec 7, 2023 at 4:57=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Wed, Dec 06, 2023 at 10:04:51AM +0000, Fuad Tabba wrote:
> > Add the latest field definitions to HCRX_EL2 from the 2023-09 Arm
> > Architecture System Registers xml specification [*].
> >
> > These fields aren't used yet. This is done mainly to get the
> > correct generated value for the register's RES0 mask.
>
> > ---
> >  arch/arm64/tools/sysreg | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
>
> This isn't a KVM specific patch, this is an arch patch - I'd have
> expected a subject line "arm64/sysreg:" or something...

Sorry. That was the intention, instead of removing the KVM for my
"KVM:arm64"s I removed the arm. Will fix it on the respin.

>
> >  Sysreg       HCRX_EL2        3       4       1       2       2
> > -Res0 63:23
> > +Res0 63:25
> > +Field        24      PACMEn
> > +Field        23      EnFPM
> >  Field        22      GCSEn
> >  Field        21      EnIDCP128
> >  Field        20      EnSDERR
>
> This is the same as my equivalent patch in the 2023 dpISA series:
>
>    https://lore.kernel.org/linux-arm-kernel/20231205-arm64-2023-dpisa-v3-=
7-dbcbcd867a7f@kernel.org/
>
> Reviewed-by: Mark Brown <broonie@kernel.org>
>
> (that series does make use of EnFPM).  Given the likelyhood of overlaps
> like this I really think we should be merging these sysreg updates even
> if the serieses that depend on them are still in flight, it doesn't make
> sense for multiple people to end up doing the typing.

Makes sense. We'll ask one of the maintainers to pick up your updates.

Cheers,
/fuad
