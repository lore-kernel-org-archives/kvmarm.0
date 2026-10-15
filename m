Received: from mta1.migadu.com (out-103.mta1.migadu.com [95.215.58.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E0B52ED51
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792073589; cv=none; b=WKT0M8OPIMYBljxdzWtl9+ODwZZzC5oKzUEDDQJejy0p6MF3xQuGREPL6crJUpwxa5Cm9T4Vs9sWgE4M37SVZjb9FG5nwfZ9dalnO3uyVKwwEf1Z+c9jzfQk/W//NlvNhERuQjJkOAmpIaF2ysp6dGqu/Lh1oNKxvXZ/5lmhIG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792073589; c=relaxed/simple;
	bh=AehSZEUXyYI5DnsWcNl+PxgJ375j0fwJ+dcWs3+ntuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zntl7jnvL98fEHa7YWd6kbIgaR0964YSQPKkGvK9gbTetyBw0bKfkdAJhFqseyaTWEaC/eBKMeZhDvlLEKFTNeKb+T/ed8s1T80SAqgCWV485iLASF1Ts0bYR/FRmV0pL1pJVLFvi0ajnfC9aBNVnAMBVu9REkFFgbGpighmW2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=REYUlN4x; arc=none smtp.client-ip=95.215.58.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="REYUlN4x"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=AehSZEUXyYI5DnsWcNl+PxgJ375j0fwJ+dcWs3+ntuo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792073585; v=1; x=1792678385;
 b=REYUlN4xeIawtc9GqmqizuZsQQJ0jhq9BSCPSahT4iu75E2hsyr9PnQuuN8IJWmd+TDrR2J2
 9eMr1cFxyWE8UReUJRGl1NEA54kPTseUUemY1XNdvfYsiacFrcMn0Aa/PVorvQUKezMDoJNK0W+
 RNUA3cLg0ya1+sxfz92qxzyA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e15d62123df9eecb;
	Thu, 15 Oct 2026 14:13:05 +0000
X-Mizu-Trace-ID: e15d62123df9eecb
X-Migadu-Flow: FLOW_OUT
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b1aa36fc0eso9783a12.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 07:13:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzy2sJddPPlnqRofUmf2bWNIYbncQmWnPT9/VYCUr2HByJ9Om/WQzeRDcjKVXXIFOFOsnlZgiU=@lists.linux.dev
X-Gm-Message-State: AFq9FYLAjVzoO3ODpc3/twbScwmsFsIWV2QlB8hGHIxW63XiRcHatPlB
	dG/skr95JQ5+AsVfxA13uaL++WT7ZjVRrApI13OjJT2tpyb8D6bPNeoPpj1gemf7emT+j72PXMl
	GreBA+6Dx7A8Dqq6RDDQ8PY3LD72bFYkAdqHuLxUC
X-Received: by 2002:a05:6402:208e:10b0:6b1:d80d:396b with SMTP id
 4fb4d7f45d1cf-6b375fddc3fmr33779a12.14.1792073582345; Thu, 15 Oct 2026
 07:13:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261013130247.4135515-4-fuad.tabba@linux.dev> <20261015140909.1310928-B-seiden@linux.ibm.com>
In-Reply-To: <20261015140909.1310928-B-seiden@linux.ibm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 15 Oct 2026 15:12:25 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwqhB8_L0E5X5SgCcpK4rGceRgq1mtOwcPaMG-szycvew@mail.gmail.com>
X-Gm-Features: AclHuK8s26iwmj4UvOequv8LIG1kS_-fIOvoCkMvREIBgursWs09-hjQUBgRlhc
Message-ID: <CA+EHjTwqhB8_L0E5X5SgCcpK4rGceRgq1mtOwcPaMG-szycvew@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm64: sysreg: Mark fields the architecture dropped
 as RES0
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Oct 2026 at 15:09, Steffen Eiden <seiden@linux.ibm.com> wrote:
[...]
> Verified values with DDI0601 2026-09.
>
> While checking I noticed that Bit 58 of PMICFILTR_EL0 is also defined as
> RES0 in DDI0601 2026-09 but is defined as SYNC in tools/sysreg. Not sure
> if this demands a separate patch or can be folded into this one as you
> already are touching this reg. This field is unused as well.

Thanks Steffen. Catalin has already merged this series, so it would
have to go into a separate patch.

Like I said in the cover, I plan to fix this once and for all though later on.

Cheers,
/fuad

>
> Anyways,
>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
>
> Steffen
>
> > ---
> >  arch/arm64/tools/sysreg | 11 +++--------
> >  1 file changed, 3 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> > index 341db8e9b6c37..99af1c39478be 100644
> > --- a/arch/arm64/tools/sysreg
> > +++ b/arch/arm64/tools/sysreg
> > @@ -1420,8 +1420,7 @@ Field   17      DIRECT
> >  Field        16      EnI
> >  Res0 15:8
> >  Field        7       PAUSED
> > -Field        6       LASTFAILED
> > -Res0 5:0
> > +Res0 6:0
> >  EndSysreg
> >
> >  Sysreg       BRBTS_EL1       2       1       9       0       2
> > @@ -2663,11 +2662,7 @@ Field  57      EPAN
> >  Field        56      EnALS
> >  Field        55      EnAS0
> >  Field        54      EnASR
> > -Field        53      TME
> > -Field        52      TME0
> > -Field        51      TMT
> > -Field        50      TMT0
> > -Res0 49:47
> > +Res0 53:47
> >  Field        46      TWEDEL
> >  Field        45      TWEDEn
> >  Field        44      DSSBS
> > @@ -2985,7 +2980,7 @@ Field   27      NSH
> >  Field        26      M
> >  Res0 25
> >  Field        24      SH
> > -Field        23      T
> > +Res0 23
> >  Field        22      RLK
> >  Field        21      RLU
> >  Field        20      RLH
> > --
> > 2.39.5
> >
