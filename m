Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276B914AD02
	for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 09:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732698430; cv=none; b=C0tiIX0m9cuGnRr9IKSrRHPzXvUU43OTqw/0uB78i5hd69sUWYkrj3VMopbAOoAQfAbTP8qWMUGqiwTozp7hoWLZDB26i9e1ux5PaU4B2NTduhCj5T9yY3WYxrKB4UrW5vsJkDsZC1FduRkqcg7k7mmqjR7715FgqhEZ7WvErTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732698430; c=relaxed/simple;
	bh=EYhWuCkWd78rd53gaTGuNCDhMxotWupB+s7j8Vqu+jM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vpq2tNFm0SZe0ieP4jff/jHOu4w3oY7yCraIxix16tQZWJVGqQsPLcIJO7bYIgMMXNQlV/XFKfmkItv3LKX0LTp3B+43CaWTOqlq2YJIwdZOI5XcNtDVRMk++P9bEiRlQ8egCzT7JHbGLlDBSgefizZks5J9V9og4eznwKvbHHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mXOQRpW6; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mXOQRpW6"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4349338add3so32145e9.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 01:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732698427; x=1733303227; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mBxxllbmGCNC4M6ZGUi3hTx4gy23i+k4nkuufppIRDc=;
        b=mXOQRpW6kb062AefwsL8v3p6DSpGqjPaMX+Amo8fSjpt7xX58TxB1VvyphX/V47S1M
         wc9zj6WsSWPZePJCgGeeEVPwI3uytnIbLljGHJITrlBlZBuJIWRdsCXi/Sl36FME5Dka
         8Bd6HvED+sRYpDUQ3kxpVfxN+9bU7HqsnYSOI5zFCfK3QICY8lZPyrLIc3bpk9dB7fhV
         GUaTBkxkZAtqQuLYX65ChRwIt567am6jghk4xfEZQMfOhZidVTAmRq3aknkaScMvrUO3
         ajsYr7ejSZQqRZMlDXxf3vdFkn0TtV77wEMzCtTQ7S+0xGV54R2f4VGbbKvnBgyjLTNN
         wmjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732698427; x=1733303227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mBxxllbmGCNC4M6ZGUi3hTx4gy23i+k4nkuufppIRDc=;
        b=cG9m2TXqKZiMttm1KOIc4sOlw4XFNs2b7OVK2KTiNkSdkk3Wv0ZEHR7pHEWTutuQ/a
         q0x3h1Rh2a4H7F0c2aGabf9o/oUVWlqk+YQIvAgmAgM9X6/dQwfZOIox7xWmupkD/0uL
         wW5wecu2sG241vCfUyeCLeIntCOITh1gIUnqmUGIHrzW/WeEhsNdIKfxtKqTn3q/jjxy
         N6O0fFbUdvb/7cHkpziDCkvaeQ63vg3kKMzGSmfTuaIPmX1Ev0hpi9bPAkL08R5FOgL6
         78wXagyb6ODsLPBYqevpnYzh87Kp61FQ7Cyu0KDyxTj5WDKB7fHYVUUv/ESyrQhRsf2t
         aJYQ==
X-Gm-Message-State: AOJu0YzHcO9fuQllvUw9ptdIc2xBNeKdpFzpM4f7lFgImCYMLdcXM3S1
	lLyTblm6H168P2RICnxJYgnPIqyb4T0O11fQa6myX9mUhI2efDQ9swSrW1S+YTmXyCcCIYaB4LC
	DSES6XC38oK78W7Z4LmD9v8OEVWDI1gNAjY2N
X-Gm-Gg: ASbGncsEttJNPOzcVBC11YZpFyBuMWesfmqKKTf3jQ3dAeHxWpPKMSdfTe1o7qzh3BT
	O+Xa+zIGISOh1StEaOuTnYJ2tX78I/kWWJZPz0RWpgNMtDTgPZJzfJggQSVDb
X-Google-Smtp-Source: AGHT+IEUOv+ttrgixa863IXDx4IkyNSORqkbzpzMgsE3AtC5i38dGESn9hxm+cgmL+2iHBzWVZ/gwvQzBFwaHgYd9xU=
X-Received: by 2002:a05:600c:511f:b0:434:9dce:75da with SMTP id
 5b1f17b1804b1-434aa0a508fmr870905e9.0.1732698427321; Wed, 27 Nov 2024
 01:07:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241122110622.3010118-1-tabba@google.com> <20241122110622.3010118-8-tabba@google.com>
 <100b6b71-22d4-4513-9f8f-849a11c0a809@arm.com>
In-Reply-To: <100b6b71-22d4-4513-9f8f-849a11c0a809@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 27 Nov 2024 09:06:31 +0000
Message-ID: <CA+EHjTx4WdCNt=ZHNSMFygGDsy70LnDev4VpdTnhb+-j7QfdQg@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] KVM: arm64: Rework specifying restricted
 features for protected VMs
To: =?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kristina,

On Tue, 26 Nov 2024 at 18:28, Kristina Mart=C5=A1enko
<kristina.martsenko@arm.com> wrote:
>
> Hi Fuad,
>
> On 22/11/2024 11:06, Fuad Tabba wrote:
> > The existing code didn't properly distinguish between signed and
> > unsigned features, and was difficult to read and to maintain.
> > Rework it using the same method used in other parts of KVM when
> > handling vcpu features.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
>
>
> > +static const struct pvm_feature pvmid_aa64isar2[] =3D {
> > +     MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, GPA3, IMP, _vcpu_has_ptrauth),
> > +     MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, APA3, PAuth, _vcpu_has_ptrauth),
> > +     MAX_FEAT(ID_AA64ISAR2_EL1, ATS1A, IMP),
> > +     FEAT_END
> > +};
>
> Just wondering - did you intentionally hide the MOPS feature from protect=
ed
> guests here? (It was exposed before)
>
> I did notice that the HCRX trap setting is currently broken/missing in up=
stream
> pKVM, which means MOPS instructions UNDEF in the guest. Is it related to =
that?

You're right on both counts. It was there before, but I removed it in
this patch series since HCRX trap setting is missing.

I have patches that add support for pKVM, based on the work that
you've already done, ready to post later.

I will respin this series again soon, with the comments from Marc.

Thanks,
/fuad

> Thanks,
> Kristina
>
