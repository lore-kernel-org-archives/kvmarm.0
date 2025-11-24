Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6342FE598
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 11:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763984963; cv=none; b=J7Fm8TUiD4aoZ38P+2o36nh48nv4WSkrnfJ5KBuYr5LdngVMNoEzXCpgBU1SMz7PePiHPjHlFap0u15lvDcFAkDZR5eE7TgwrgiBzt6Y1b7toaQWBjHgAD5pzm793XqPm2RfLmO0AbhE88t5d+21fMOWdcKhrzEgzfWmodZSsPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763984963; c=relaxed/simple;
	bh=aIeNzPmW+SNEBUgI3vqBtrS0W/tZgUE1BxWSi9ai/mw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lF9E+dbSWEjjg4Oca1M/kADDkmjkFMKPDUUjq68LvVfkRfHUPQc+YGFtX8JUviovgEN+VQKgB10i5xjO1AHGWW6GRsDFsCqD87NjZZ5OBbvNYk6z2WeJJ5MEKHeiff/ADmpnq3HxfPr4NZj5tdQe8+tmCBEjdkitfwGxZrNUm/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0P96Y+yz; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0P96Y+yz"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-641977dc00fso5881224a12.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 03:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763984960; x=1764589760; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YBzqTyvFz5pY73g0wyFxPosxXrPbeTrE1uucBWxOS/U=;
        b=0P96Y+yzoEQbqrIUVMqg2XDd0rRvVkwjdK93ZGqqAh3z/lR5GpkZ8TunzZtRL5BUDp
         zOSz/qkfePTYvRZGjsU+XikXSs0Q58lXC4Cfka9jVNFWw/YDJU8cNfkvC3THDwjhn2t9
         s10nKKEDffacSC4ytV2t7BIKnt+fBxw9yZt+5LDEZFeVWgOXihR+FqzsPkpsMW1qMzZL
         dqOwqyr310HvGNFfKJzVi6YTrbmapFs/ksT9tL28rUwCD+0/c8P3CgUHV4vhRgjh1ZIq
         xmciYb6YJemiKVgcExMAkdOQdmu5FYKjtsRs2MihAFLoSxrGIeCcwJAhn0vPGAcNM7AR
         gx1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763984960; x=1764589760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YBzqTyvFz5pY73g0wyFxPosxXrPbeTrE1uucBWxOS/U=;
        b=g/I70lcsRA3Yvy6UBz8NFWt1QBLb15TkDzlphdW97d6HeN+ESffkpjHolm2OjrkOaf
         ynzcv+MzBN9V6edDQusdg8TTxN0KJMs2iWQDeAQZnQJXPCXjXIrl2yDQ+OsYpihV8kEE
         /SGP4GrO9HPTIkjOM2BxDF56hbxk4v8F1N43J0e1nLdFMbbjgHlbdgYq3SZ6HLEmg+A/
         B2HmxGlWiLMyYG5KX07L/igJBOjrubsPeMOu54y2l/9mgIEApzV8iDmwMyHdvMCtTVWX
         mAR2Xwn3N1wiCms/arAmZtZWng2bGBupqEWEnUXF4P8DYNx3KFZadyFScKPjz55e859N
         BY2A==
X-Forwarded-Encrypted: i=1; AJvYcCXGovl0krWAbKTLLiJv/8sRgkTGI6odaPehISSgaKih/bNiGgv5F79felIZmW08WVwQWuOCte0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNafBdHYmo+zcdIKAXk8c7pSFYnhKWwdh/cqDxmifDaKQc29/N
	ZSE04CjavYbzxDpIEUqeB8D/iZidGS2N+xVJGAIXqL6sB5Fm+FWsMZQ2Av5YqQXbsH+dHux5AQX
	YKK4tiVOP+QzqZHXMLJazlygabzyPslRYcQyc6xGNo/jQopiD8fxCQw==
X-Gm-Gg: ASbGncsduW4kXpWt/NA5eJLLjRF6eTjWVVO26altwN41FKcYBliueAJojZiC7AKALjX
	iNI2+hC5WVhH31wbX5+5wl0KFcAUNYDImuyOq7H36lCBlv6wRLUf+2XBIv+v5iKhbjPu8L6RJkP
	PVoqV9/bxyGCqoasHvP1PIzP9pCiXs8FPJwcXH9MDAKzTxHDsL0ndoFbHxeJFcm95SeNfhbTDrc
	CAjbEFQz6lwVdbOT+EZLGrLd/WytEQh6YnMYrtPpPdp/3yZX51hKdGQbFesPsYx6nxoo3i01MTz
	xUY1jt2Es+hVMSp8q7PJAw==
X-Google-Smtp-Source: AGHT+IG7FB3BP+B8s90UvG3u8TKisBLgaeNLNo0mcm7nvH+ZLDG/xBq9eIpbyEBwPDFPgxni00+/Homwohr3IjN760E=
X-Received: by 2002:a05:6402:280e:b0:643:129f:9d74 with SMTP id
 4fb4d7f45d1cf-64554320e9emr10547471a12.7.1763984959578; Mon, 24 Nov 2025
 03:49:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251114-pkvm_init_noffa-v1-1-87a82e87c345@google.com> <86y0nyqoy9.wl-maz@kernel.org>
In-Reply-To: <86y0nyqoy9.wl-maz@kernel.org>
From: =?UTF-8?Q?Kornel_Dul=C4=99ba?= <korneld@google.com>
Date: Mon, 24 Nov 2025 12:49:08 +0100
X-Gm-Features: AWmQ_bkhS5B96awb5hA1kiuNad2P7FKIh_5r5IcWHOnEUHiGGXtG74DFdSXbmhw
Message-ID: <CACF_fqmWwtuF_7+OJ2rUPvDJzs4ubJO6XCf6N9cW2-AABSx_NQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix error checking for FFA_VERSION
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Bartlomiej Grzesik <bgrzesik@google.com>, Tomasz Nowicki <tnowicki@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 22, 2025 at 12:36=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Fri, 14 Nov 2025 11:11:53 +0000,
> "=3D?utf-8?q?Kornel_Dul=3DC4=3D99ba?=3D" <korneld@google.com> wrote:
> >
> > According to section 13.2 of the DEN0077 FF-A specification, when
> > firmware does not support the requested version, it should reply with
> > FFA_RET_NOT_SUPPORTED(-1). Table 13.6 specifies the type of the error
> > code as int32.
> > Currently, the error checking logic compares the unsigned long return
> > value it got from the SMC layer, against a "-1" literal. This fails due
> > to a type mismatch: the literal is extended to 64 bits, whereas the
> > register contains only 32 bits of ones(0x00000000ffffffff).
> > Consequently, hyp_ffa_init misinterprets the "-1" return value as an
> > invalid FF-A version. This prevents pKVM initialization on devices wher=
e
> > FF-A is not supported in firmware.
>
> Is this statement accurate? I regularly boot KVM in protected mode in
> environments that really cannot be suspected of implementing FF-A
> (there is no EL3 to start with). And yet I don't see any failure of
> the sort.
>
> Please clarify the circumstances this is triggered.

I do have EL3 enabled, but the FF-A itself is not implemented.

Without this change kvm initialization fails with the following:

[    0.946776][    T1] kvm [1]: nv: 554 coarse grained trap handlers
[    0.952880][    T1] kvm [1]: nv: 669 fine grained trap handlers
[    0.958813][    T1] kvm [1]: IPA Size Limit: 44 bits
(...)
[    1.034089][    T1] kvm [1]: Failed to init hyp memory protection
[    1.041213][    T1] kvm [1]: error initializing Hyp mode: -95

I managed to narrow this down to the FFA version check by examining
all of the places in kvm initialization logic where -EOPNOTSUPP is
returned. Since printing anything in this part of the code is somewhat
problematic I replaced =E2=80=9Creturn -EOPNOTSUPP=E2=80=9D with =E2=80=9Cr=
eturn res.s0=E2=80=9D to
examine the problematic register value:

[1.041229][    T1] kvm [1]: error initializing Hyp mode: -1

Note that the return code itself is cast to int before being printed.
Then a colleague of mine recommended looking into the arm_ffa driver.
(=E2=80=9Cdrivers/firmware/arm_ffa/driver.c=E2=80=9D) There I found that in=
 the
ffa_version_check function, the return value from the SMC call is cast
to s32 before being checked for errors.
I did the same in the kvm initialization logic, which is how this
patch was created. Furthermore I also examined the FF-A
specification(DEN0077), where the error code value type is specified
as int32.
With this change applied I can now see that kvm is up and running:

[    0.946839][    T1] kvm [1]: nv: 554 coarse grained trap handlers
[    0.952940][    T1] kvm [1]: nv: 669 fine grained trap handlers
[    0.958867][    T1] kvm [1]: IPA Size Limit: 44 bits
(...)
[    1.061717][    T1] kvm [1]: Protected hVHE mode initialized successfull=
y

The /dev/kvm file is also there.
