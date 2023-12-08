Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8DC1094B
	for <kvmarm@lists.linux.dev>; Fri,  8 Dec 2023 08:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CUCaYwMh"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-46484f37549so556443137.1
        for <kvmarm@lists.linux.dev>; Fri, 08 Dec 2023 00:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702023475; x=1702628275; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylcSh/0Cky0DgjR/72eg84rKMDIg4t1bPkNBeufIEVE=;
        b=CUCaYwMh1TlpX3ZlsDjLiwP9/6enzIPkI6XtT8kdMGK5UZYwmct9UwR6ap3YQK5a83
         u1lKblC9bhx8KCrULxeQonmBDFSX4ilazXLINp0C76JPIE2KyBDA1jx9uVXMc8199mks
         wdlwbmysFNQcelcawfoQZMUw+7/y/n/Duh1IFE1w2X32Z9LLtgXFpfbdaB0EA8tN/ePi
         pw+m4oW8g64GeoI3KoQJy5eM5BRInRlrDAEGnSREipqQyBgfqE/E2Z5jXIzWVMl9OLX1
         aTy9ezfrs+k0M3jC7B0i884b4O3XIZM7zx83DH4M6BU9nFAsGM7nBDwpq/0XfUMRZruu
         RhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702023475; x=1702628275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ylcSh/0Cky0DgjR/72eg84rKMDIg4t1bPkNBeufIEVE=;
        b=BV+dR7uQBIaqTrPGbQ32+1M2MMetcVRUE1vbRcbuU6NerKbi4i2Nnz04BIjM9p0vM6
         i1mNThjVAF8kom4YMQCq+vhlHWrFOy/VtV1UWBzkSW3DFebzZIWDaJwK2sIbhGEDrcm8
         1+Jv18TBNzr5gwvB2Ommy8bJ1m9AEnLFhB2L2bw9gVxgWeEeLjOtXeVvJTYoCY6SsHqv
         5+PNAklsjCEuyFeUGdQba6V7VFVLdA0wd9qHYNUxJaKJyzBunOv/40JSo3vxA14ZU1v2
         Kt/5vAzCWv2zxn7pIFiv5EXH12Zc9uoMJrmR46aPJkkKb689xeZlvfXzRAHLrc7zgoLl
         ZHyA==
X-Gm-Message-State: AOJu0Ywo1HNdNZ+Tk8m32mT+ma7z373W2VVPhdaV/7X0JdB1xKPo2YY1
	TRYSrVbB0Rr2tGybPYdtvx7CHy3ywcEIn/hErBiYzA==
X-Google-Smtp-Source: AGHT+IEeH5AvhiTp4Lfc/McM/lGVNkcRbRSId/+c7oDM8TWsTsxH1/Cu2+oeU3YEKTN9abKVgjNuAsdSPf2HkrZOHSk=
X-Received: by 2002:a67:efd3:0:b0:464:a099:58ab with SMTP id
 s19-20020a67efd3000000b00464a09958abmr3401707vsp.30.1702023475236; Fri, 08
 Dec 2023 00:17:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com> <20231206100503.564090-4-tabba@google.com>
 <bbe3b916-9db3-403c-acdf-8472c750bfcd@sirena.org.uk>
In-Reply-To: <bbe3b916-9db3-403c-acdf-8472c750bfcd@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 8 Dec 2023 08:17:19 +0000
Message-ID: <CA+EHjTzwNnfwANuKmWtoipwb4nGhTt7RNtP=6ngfRqSErzAsuQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/12] KVM: arm64: Add latest HFGITR_EL2 FGT entries to
 nested virt
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, Dec 7, 2023 at 5:14=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Wed, Dec 06, 2023 at 10:04:53AM +0000, Fuad Tabba wrote:
>
> > Add the missing nested virt FGT table entries HFGITR_EL2. Based
> > on the 2023-09 Arm Architecture System Registers xml
> > specification [*]. Add the missing field definitions as well,
> > both to generate the correct RES0 mask and to be able to toggle
> > their FGT bits.
> >
> > Also adds definitions of some of the missing system registers and
> > instructions, which can be trapped by the FGT bits.
> >
> > [*] https://developer.arm.com/downloads/-/exploration-tools
>
> That should be a reference to DDI0602 (for the instruction XML) and
> DD0601 (for the system register XML) - it's the same content, just a
> more stable name.

Got it. Will fix it on the respin.

Cheers,
/fuad

>
> >  Sysreg HFGITR_EL2    3       4       1       1       6
> > -Res0 63:61
> > +Res0 63
> > +Field        62      ATS1E1A
> > +Res0 61
> >  Field        60      COSPRCTX
> >  Field        59      nGCSEPP
> >  Field        58      nGCSSTR_EL1
>
> The sysreg looks good:
>
> Reviewed-by: Mark Brown <broonie@kernel.org>
