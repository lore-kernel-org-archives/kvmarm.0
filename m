Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF5D4D5B5
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 12:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zrhj7E2a"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3ba46a19689so2415441b6e.3
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 04:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702902652; x=1703507452; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMSTXJP4JY+S0oq5XvdiKGDhzT3I+SAYSZ7+s41mZ/8=;
        b=zrhj7E2ae7X0wVsJ2h50FO1TXbifphAfBB0kx8PPgNdblP70pXeQIFGqtWKxZElo8A
         p8zsLiclDEAWihwJ7ooW9t7bbPUn2xb4X3HLdwiQejKdQ8jP/z+ck3s1cMakvY9kcYAf
         bQL0cwiKNEh43Wri18TjKkNe3tHOPVq43KZ8qn1HCTBhSqJYTMWkKIynBjMtBMUBageG
         u1acU8pW3HEo/2apswjyoPt1sC4xxASFHPw1CF9RJq5doRBle1fKovSX8/lQ/ffYOQNV
         G0aqhyhYmXLB4j28Kk5qW6otysSiXRTUCCdLltSRJLTWDgHv169hx4Ew1EoYV2eZC+vj
         NkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702902652; x=1703507452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WMSTXJP4JY+S0oq5XvdiKGDhzT3I+SAYSZ7+s41mZ/8=;
        b=N4A9bcoFU22N8udcxN5iz8OxFnFPOzKC1gbqIokkxOWPZsbFf1KcFxFk9qQInCpP0t
         jrVn/StkpGLcvqlp9n9SMwTFW8HtkoMKxWnt1TsE4Cg+wrz+GMLtFnMSg70bfsDQ2RmJ
         qu6MQtN9Tsbd9mSXHBtSEHrXYkUrCy4V3jkAspC7lPWzGs1M70QRViATiSg4U8YjWIxK
         VPYXEqETpEqjnccCsdziOuv/XTUJB9owSeOk/MSLPweIAT+U6u8QJPnmRZ6+KYhkY8Sw
         govudqs515jKSkoMtROu1hGDBOHhaz8jdcsyy0t6jUUjlatHyd3RNq2w2Q+bCGq5dcOd
         TPvA==
X-Gm-Message-State: AOJu0YxSE1H9X5xqeVahS+nSG8RS31qPDpqHYWI0PBu563mVbOFMbhbu
	94w5X1AqOm6im0/6kcFmKM5WGdPiA4JrhUXz1v30rg==
X-Google-Smtp-Source: AGHT+IHLvYvmccqnSprJVzV2g/+4qIeWvZSRnr1Y3b2ISzNS4wrRZeWPf5c+jgFOSld9YJmkIB44ZpBOLHYc9swznAo=
X-Received: by 2002:a05:6808:128e:b0:3b8:b063:adf0 with SMTP id
 a14-20020a056808128e00b003b8b063adf0mr22253895oiw.77.1702902651988; Mon, 18
 Dec 2023 04:30:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com> <20231214100158.2305400-15-tabba@google.com>
 <86wmtbalx9.wl-maz@kernel.org> <CA+EHjTxZmc2bAaDbFLjWxx-LzCX7Jwy+EH60JgFBvWYh68U=xg@mail.gmail.com>
 <86v88vahn8.wl-maz@kernel.org> <CA+EHjTyPS-3PX+JGV32oTTMYJPk3Dijbcj3oAENg3v7sAdw7wA@mail.gmail.com>
 <86ttofae9e.wl-maz@kernel.org>
In-Reply-To: <86ttofae9e.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Dec 2023 12:30:14 +0000
Message-ID: <CA+EHjTx5JYc2Ez1uorOJwE1YRX1AkNeqxEK5SHSCf5Bdj3Vp7A@mail.gmail.com>
Subject: Re: [PATCH v3 14/17] KVM: arm64: Macros for setting/clearing FGT bits
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Dec 18, 2023 at 12:25=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Mon, 18 Dec 2023 11:17:55 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Mon, Dec 18, 2023 at 11:12=E2=80=AFAM Marc Zyngier <maz@kernel.org> =
wrote:
> > ...
> > >         if (cpu_has_amu())
> > >                 update_fgt_traps(vcpu, HAFGRTR_EL2);
> > >
> > > If that seems sensible to you, I'll fold it in, as I'd like to do
> > > without a respin if we can avoid it.
> >
> > Looks good to me. Thanks Marc!
>
> Please have a look at [1] to see what I have done (AMU fixes and my
> suggestion for the FGT macros), and let me know if that's OK with you.
>
> I've given it a go on my M2 with NV (only a couple of minor conflicts)
> and nothing caught fire.

Both the AMU fixes and the FGT macros look good to me. Thanks for this!

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git=
/log/?h=3Dkvm-arm64/fgt-rework
>
> --
> Without deviation from the norm, progress is not possible.
