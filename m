Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1210712BF24
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 13:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713274764; cv=none; b=T0xJuq48lo7VvOrvT9XXr+TaDu6JtORQ4Y3MRK1pDQG/qPuKsNOEbIF3Mr0z261Al6UBOUwOteuNTntR3tEk47HJlENDvDFY2kU8uC8swYoSq/tgB414AlPM0Hv2Mwn9kzvelXYoRVZE+DbhvS28EB9Q+/6jKeHTu991yaMujs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713274764; c=relaxed/simple;
	bh=ghfiteqccZ9u4YXY4+h2p9YU/mFojNhG6KhxrhUdvOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H+QgtMvcaMO44MzVvN8YaPoYTQCFBbmUAJIZrzDvMU81kOHSQ35RIBnaD2tvLfhBmBNh2jkY8gP13UwXzZgRcdDek4b4cgvt7/G22WxlCb+JaF9Mz1YO8mRxrVKL8BDaPgXqfSkh49v0L4WkD+p9BfHW8knS9NbVijMj+8WU5sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tRioz7iM; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tRioz7iM"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5aa22ebd048so3186241eaf.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 06:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713274762; x=1713879562; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZhCIxFcZZPkhpySqbXmcUoDNwR1A800L74u2p7tN5pg=;
        b=tRioz7iMYceFtoY6dFZFd+5zuASfzH2sfzegQqFLroFB6pjHUfknhaxk169divCt0V
         BwBjMIv/Vm6JX1+MGd/rBoK+oYNrxztUOIR3x11QJwSEjyGrAayGOtjYhxcGD9GU96Xw
         owDHIHLJhwPGTyVVdBNMX1Sd+d1+DahCxupLBot+1SLjM9OspjYldsrX34sK0TfsipiD
         9vzwXSyWSkRy9hYFO8O8/l8tr+d84mHugcMT/1XodJLAuKqNsoQgLk+MaqZE2COyAhKp
         ovMMRJnHlJaamMvFV4glAUbzJkoJFfFDh5jmxK8igOdvYjbMxc9Vhbrzt++x8ck3NF/m
         R1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713274762; x=1713879562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZhCIxFcZZPkhpySqbXmcUoDNwR1A800L74u2p7tN5pg=;
        b=udclh3g3iNiwmUmCxtgfWITjRH2atq1LVXsGfcoguthzMXfgdPROw22R3ksZSJTTWg
         OSh1tR/IImVFVa1VHG45jl46H5PiSAnYlbdGchXOVWUc79UfBNEihRaAHb8PFdkB5gSC
         Y1tAU8OUuf56dz37Veammq3hAzDJKly0IV3dPiuUjVaGV2qQXCXDJYr0Uv0oHUbLFu2y
         padTsK4Y+WLUCBmdcjuOofdE2I25QfQ7qwaVfieqtURaHPy79eYnx3aFIRzuct0EkGUv
         o+WLTKChmCjl38rdsx8k1Lm8/HyeQhDjru1BUE4cDbfTDRLxFaI3y6TR9KWZLkUFLULr
         4w5A==
X-Gm-Message-State: AOJu0YyZD8WMW+SXUS/Jkxz3r/lt8wjuWKfdmmnhivcWwyQjJkYW6Bp+
	vRLj73DgIXAE9rW5zqPxwqXnASQAqeVLZLWkq0Q1lrM08kz9f0K+ahS+QLld8yvWty5h7k1aFq2
	2oFj/RUcoydslN6S0rnjMjOL7iCM2ez+bwLos
X-Google-Smtp-Source: AGHT+IEeCmSlnHA/V/RF4RN6QnLHl5AOKJC297WNg2gjEPfNY7eoS6FM24WpBQqeKdVDN+WgG9ZDtHrpkww6/aED/ao=
X-Received: by 2002:a05:6359:4dc2:b0:17b:f637:7bb with SMTP id
 pj2-20020a0563594dc200b0017bf63707bbmr13322642rwb.30.1713274761943; Tue, 16
 Apr 2024 06:39:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com> <20240416095638.3620345-17-tabba@google.com>
 <Zh5XTuCF/53ImnxM@finisterre.sirena.org.uk>
In-Reply-To: <Zh5XTuCF/53ImnxM@finisterre.sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 16 Apr 2024 14:38:44 +0100
Message-ID: <CA+EHjTysTe7UyB1CSs=oVm4Gznr60WXwwQbME8Z7a9UfvyX7vA@mail.gmail.com>
Subject: Re: [PATCH v2 16/47] KVM: arm64: Clarify rationale for ZCR_EL1 value
 restored on guest exit
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, mark.rutland@arm.com, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks again for the reviews Mark.

On Tue, Apr 16, 2024 at 11:47=E2=80=AFAM Mark Brown <broonie@kernel.org> wr=
ote:
>
> On Tue, Apr 16, 2024 at 10:56:07AM +0100, Fuad Tabba wrote:
> > Expand comment clarifying why the host value representing SVE
> > vector length being restored for ZCR_EL1 on guest exit isn't the
> > same as it was on guest entry.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Reviewed-by: Mark Brown <broonie@kernel.org>
>
> however if this gets respun:
>
> > +                      * Restoring the VL isn't needed in VHE mode sinc=
e
> > +                      * ZCR_EL1 fulfils the role of ZCR_EL2 when doing=
 the
> > +                      * save from EL2.
>
> It might be slighty more clear to say s/of ZCR_EL2/ZCR_EL2 would/ - it's
> a very marginal difference though.

Applied it locally and will include this on a respin.

Cheers,
/fuad
