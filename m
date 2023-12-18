Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C38A5BFA5
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MnETlgqZ"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-67ad277a06bso27103836d6.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 09:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702919772; x=1703524572; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yUJ+cQY02LxRwbCRVY3PHCduRA0nRH+e4kZ3WZjs100=;
        b=MnETlgqZw/b+GMeC1OJZ4+n2J1HeUMTDOIkDbtUG3dz13J9s4TpOCtdic3gG1hy2Hc
         kHzjHxk3RQi47rkL5sKrw8CAW53tiXCtLkaZsP/hA/IyyF6ylUD9bybtv0wpHovofyGZ
         6FkU27tlW8QD/cUQto/2A1Wv0WvLA90SFctTZ7yb3k28v4byf7tuLKIieNaEZFvBqYEv
         VydKdxjqAMDnsErmbEqESZh917gwjHBG/P+p+SjiZ9opCy/L3QBhkNM4Otm+dsE7rEqW
         g4UtADmwBC2jrEjjLuA+RUCbRWndM6+T8eDncTPIdh37q6DCKHNIBjwldpl6/FTGd+Yo
         3xwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702919772; x=1703524572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yUJ+cQY02LxRwbCRVY3PHCduRA0nRH+e4kZ3WZjs100=;
        b=nyiqjSEcCh4RqcxdJHJCCAGHqJJyuyk33lDreO5lcq7YadVjqD/CfBN7ivZSroCBqT
         N2y0EI2QRlgvje6dNnCA96nG9L1z26XirgLt0own+CI8+fKDuzx92qYkegjJzkYYv1tJ
         x3rlXTJvRxOwW5mNkg0ig20WeD1ofFN+aahu9Nsicm/HgTnALUKuUW5+w+jBnnpSBkrX
         3OYYHWlgqgk2ydSz/ahwaGBLo09UuTw+uiSaU/qvC3rYPd4Rh6Qrcg3jweVdqFqvZRFC
         AZLdhnC+8sSqa/obCRPZu4nRXkbKBTx72NpvGsKi0zSQvxTZN9HmCOQqL1IYNu0mp8yz
         vVCg==
X-Gm-Message-State: AOJu0Yy0UM74X9sBMOu1gLKGnqSePu2SM4G8YiFbI1slldYvcCY2HLUL
	Jik5d8RSnxIabNFb7VMNsVkxVwpY1gNCI2/PMRaz0Q==
X-Google-Smtp-Source: AGHT+IH/lPxn2uS9uvZawijr/HPwmYftUWe1F/f8oLMr0iORWO3t5EcX1JAHAbfiPFcfVajZH2bj1GKLeDgrpJQCODk=
X-Received: by 2002:a05:6214:21e8:b0:67f:4824:72fc with SMTP id
 p8-20020a05621421e800b0067f482472fcmr1620964qvj.59.1702919772554; Mon, 18 Dec
 2023 09:16:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com> <170291942595.3349022.748097050325200963.b4-ty@kernel.org>
In-Reply-To: <170291942595.3349022.748097050325200963.b4-ty@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Dec 2023 17:15:35 +0000
Message-ID: <CA+EHjTyd_GM0VSSW+3v8jNpC+w1pwhX0PHwKNtdcDFyJGTzAOw@mail.gmail.com>
Subject: Re: (subset) [PATCH v3 00/17] KVM: arm64: Fixes to fine grain traps
 and pKVM traps
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, jingzhangos@google.com, broonie@kernel.org, 
	oliver.upton@linux.dev, catalin.marinas@arm.com, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	eric.auger@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 5:11=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 14 Dec 2023 10:01:40 +0000, Fuad Tabba wrote:
> > Changes from v2:
> > - Rebased on arm64/for-next/sysregs, which includes new system
> >   register definitions (Mark, Joey)
> > - Explicitly trap unsupported HFGxTR_EL2 features rather than
> >   relying on its nMASK (Joey)
> > - Add new system registers to the auto-generated sysreg rather
> >   than hardcoding them (Mark)
> > - Drop patch that was meant as RFC
> > - Added missing system registers, fields, and  system
> >   instructions
> > - Split patches that make system register changes
> > - Fixes to patches defining allowed features for protected VMs
> > - Other minor fixes and tidying up
> >
> > [...]
>
> Applied to next with the changes agreed on the list.

Thank you!
/fuad

>
> [05/17] KVM: arm64: Explicitly trap unsupported HFGxTR_EL2 features
>         commit: 1565c881c3df053447309ff69ec7fd5dee2085e4
> [06/17] KVM: arm64: Add missing HFGxTR_EL2 FGT entries to nested virt
>         commit: 9d400eb722bd1be712b007149ff1d8fb2d6470db
> [07/17] KVM: arm64: Add missing HFGITR_EL2 FGT entries to nested virt
>         commit: 863ac38984a822ff9f4337d70853d771dcf7aae5
> [08/17] KVM: arm64: Add bit masks for HAFGRTR_EL2
>         commit: f9d6ed0213021ea00af30efbfa33e9a06c0610f2
> [09/17] KVM: arm64: Handle HAFGRTR_EL2 trapping in nested virt
>         commit: 676f482354886caa9b0cfa9236f5d20ac78f8c6a
> [10/17] KVM: arm64: Update and fix FGT register masks
>         commit: fc04838f9c00fcbc90a8926bbd46928d6fb36477
> [11/17] KVM: arm64: Add build validation for FGT trap mask values
>         commit: 6c4abbea6d9c09df448b43624074a208c38e68e0
> [12/17] KVM: arm64: Use generated FGT RES0 bits instead of specifying the=
m
>         commit: 9ff67dd26a9eed9d73dc23aa63e87b16b3382184
> [13/17] KVM: arm64: Define FGT nMASK bits relative to other fields
>         commit: 5f6bd3f3daaaab8559ad7d2266ba38345231b7ae
> [14/17] KVM: arm64: Macros for setting/clearing FGT bits
>         commit: 0ccd901da1886cf9dc53ab36ad8f1160b65e41f1
> [15/17] KVM: arm64: Fix which features are marked as allowed for protecte=
d VMs
>         commit: 73e3ce3f4a0e561e24ca71b20de00f03b427981e
> [16/17] KVM: arm64: Mark PAuth as a restricted feature for protected VMs
>         commit: 21de26dbc5170dde8e4dfbfa1ecb77804ed6a377
> [17/17] KVM: arm64: Trap external trace for protected VMs
>         commit: 9d52612690985fc0ee1ae1fbad61530a4f6bbb53
>
> Cheers,
>
>         M.
> --
> Without deviation from the norm, progress is not possible.
>
>
