Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FD810A22
	for <kvmarm@lists.linux.dev>; Fri,  8 Dec 2023 08:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a7OVbmXu"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-67abd020f40so23088096d6.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Dec 2023 00:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702023501; x=1702628301; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G34T/Gw6tDgRRxUpSxJ+EoHMEAfP6qfhrdkltLDdE0E=;
        b=a7OVbmXuhUITfNJWytXZWEtKSvRy4LUfxkPTPdQBAsxlz0HPkF5qqKppGdJ9Qn0c0s
         7unkPG6UPOQH8angWykVJwPCKToU3YZK2jklcGtmQeWMDWv+RqFSO3RPt5YrxpJiKvPG
         NHRprBnMpaC4Sp0w6H7qH9rIhMaEYeFsuV1IMSYtjRCijtFSfQs8G0bBeXdOYc4t4HzY
         RYaZdeUCe4hoKOAX3xPQCRDjt6aZ5AqGQfN5JFvfFl/MvJS/T4oye8uWYoC7pgQsB6vR
         KlyOcNUebkxoJpK/CkMIVM9zRz14s1vPLFs5B8TcK+f2zrEs7+vyyE6eQkxDhWufMndx
         DTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702023501; x=1702628301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G34T/Gw6tDgRRxUpSxJ+EoHMEAfP6qfhrdkltLDdE0E=;
        b=c426oshRkxSGiRtYtwYjvqSMo5AVr0Hr4A9+syzDz4EiiVG0qQnu6NGD+7ypy5OaJV
         JNMJUQnBltDb9uDtP+dY6eVI9hP1fq2NCAj9yLqji7/Volm9+raqFn4E7ySdfLgn64OU
         0Vp554RkizL6EFnQY3NLaSIfla1ZMZITlaSS72dmqhkPGSHHMfFW1EH8mGnKUD4ZpVWc
         Kqh3q5W+fH3LyjUN8QO3dG1fNLKIIU/orC0AA8OxfHfYuOzLB4+CE2K9iL4OVjkW307k
         Vin7uSGuPKJorWay0X5YUFAsb65VLENFnTWunjZbUPT201H7mdMSAtYE7brD4bElEdWO
         +qZw==
X-Gm-Message-State: AOJu0Yw9EkjOSDMbUu0XP/y+xtoihSwHH9qH4KJ+rc0Haq8qzsHVUgAL
	SpLVl1yfzzGxj7XN2REUg5RiMj3K0dW558X/hZ0B3g==
X-Google-Smtp-Source: AGHT+IHoNv9J2q+enrFqBN1ho5Sa4DdPErX11SvuSSYguqJhOSIKIqYmCQIQKBJrsbBzX6Yt8o+Xh8gXgYYLP4Wkph0=
X-Received: by 2002:a05:6214:5ec1:b0:67a:a721:7210 with SMTP id
 mn1-20020a0562145ec100b0067aa7217210mr689517qvb.45.1702023501286; Fri, 08 Dec
 2023 00:18:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com> <20231206100503.564090-5-tabba@google.com>
 <268ebe97-1f79-416e-805e-9a67144f6a99@sirena.org.uk>
In-Reply-To: <268ebe97-1f79-416e-805e-9a67144f6a99@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 8 Dec 2023 08:17:44 +0000
Message-ID: <CA+EHjTy53FTm6QtwhDhRNQrz-7CNnQro4VS67eWq+_z5KBofmA@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] KVM: arm64: Add bit masks for HAFGRTR_EL2
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 7, 2023 at 5:19=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Wed, Dec 06, 2023 at 10:04:54AM +0000, Fuad Tabba wrote:
> > To support HAFGRTR_EL2 supported in nested virt in the following
> > patch, first add its bitmask definitions based on the 2023-09
> > Arm Architecture System Registers xml specification [*].
> >
> > [*] https://developer.arm.com/downloads/-/exploration-tools
>
> DDI0601 is a more stable name, and I'd have expected an "arm64/sysreg"
> subject.

Got it.

Cheers,
/fuad

>
> > +#define __HAFGRTR_EL2_RES0   (GENMASK(63, 50) | GENMASK(16, 5))
> > +#define __HAFGRTR_EL2_MASK   (GENMASK(49, 17) | GENMASK(4, 0))
> > +#define __HAFGRTR_EL2_nMASK  0UL
> > +
>
> This one is an example of something where some manual encoding does make
> sense given all the AMCNTEN<x> and so on fields so:
>
> Reviewed-by: Mark Brown <broonie@kernel.org>
