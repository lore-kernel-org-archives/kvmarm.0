Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798E113CF98
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 12:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717502626; cv=none; b=n7QDnbFfZMEoFBf0XM3HYnerQ3oXSjSTLDrXLvSwcxS7j/fjNbt8D3IsSuWKZP8gX0T2xgAqHzT6pJJsOlDcSbaXN4mJyasxML/1SywT6TQ1WR0i1+m8MdU+Pd1CdZZYVyHjraDHXyfRIVSRTrkdOSgKgDUO5IUDL6whYVBtoGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717502626; c=relaxed/simple;
	bh=RTE0lE8ZCwkLpffGnbD9Y5vGiIwsGUm/S/J4xwQfKHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iOi9j+2Uw/a189j8GO0rvSk+C2cBE9Pr1LO6pYk5/OQrGFd16WdVNH4NZnJI4oHhtUwwYLkTE6DfR/XNJYPHyjk2SgtdU1jE4VvgShX4eFiOoUdP43p2jvNcLoV9jIxdI8HS+HSfLAzTgd9QZg/6tG8V4k4ItmfGwCBwQ2unxck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qgsZps0W; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qgsZps0W"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3d1fd55081fso399617b6e.2
        for <kvmarm@lists.linux.dev>; Tue, 04 Jun 2024 05:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717502624; x=1718107424; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XE4VHykk1T34gJY6Lzj5KQ2a2vwgTXrOy+meCtywNXo=;
        b=qgsZps0Wnz+CCpC+gqiei+iDkjtlBuwSISbWb8KWIj3BtrC6JExWMMj7zm6SWC1lBM
         tj29eNmFxJZk+LiEOta9x2UP8DAj/AKAWz82ibbrytW1XoCknkKstVi6w11gGBqKOtxm
         ZevZqDj4pWAi3+GhSrXD1U3WeoDCINWdbenZGZ2FX9QKvThFjjGSdrIr6QeW7u4wcv29
         gizTAJDpYQIYJcssZL8gu5C3otfUDd/O+oVq0vQRFV7Q+qsHmYpbRWdNzgAarK7RoFeS
         QHhLiaBmJMYjqTclp4oNn61CIlmJbVvkxdI3PMEwIzQWqRTsg7cDWoewSh137uDuiM7i
         YOEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717502624; x=1718107424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XE4VHykk1T34gJY6Lzj5KQ2a2vwgTXrOy+meCtywNXo=;
        b=ZLUx/ipq0PqweQXYE1cVvAQsNkptkUBi9GyeGEh/mnS3nuzgRThdHCoaMRwU6g/v+/
         AJTSUq/W8gl5Z6IC7L40biLitFsUimha+Q3d1Be/qiwhYMfQuSJSmE/RA7LopHno3mgR
         niAGhLtyz1i3Q9zmWNunj2SSuQxfkhILDsjP1CYR3XxHdXAKS5NKvZaHEznsnyYUt/oX
         xALEIst/UeggJl1UtIsqJCTMxJmAoeVx6Vi3/iQarrtEg9Gh9G0bsWQpCoj1aIqbMBQC
         RC+SAZnqZiEGTuMlOwhfUWmqV0gXPVCE+x75p+cnxcI+61f3M6DvlzdeBtHAtfWkFjLy
         7XqA==
X-Gm-Message-State: AOJu0Yy4EeBDSVn6BLQ4xmghcEtl/T1+T+ZQInzbw+Tks2FGK2nEdAJ6
	In9hq23J2m6hKnSuXLOKaZhpLqD+acnkMFmidjxQn5ItlJXnExJbLqtpgcYDCY03Jo+G0h78B+r
	LXv1tyg0nCTVxdN6PoN77rqPxiG+c0WmfLyZG
X-Google-Smtp-Source: AGHT+IHqrYlR642hs6n2UKb4rdJgc6Q3l3+HnAW7YZ/gG7wQRv9W+MncOD+9T3VearkuHuFmoOBmNGTnCgBwwwcdWxk=
X-Received: by 2002:a05:6808:2915:b0:3d2:e9:b8f5 with SMTP id
 5614622812f47-3d200e9b94cmr652935b6e.41.1717502624244; Tue, 04 Jun 2024
 05:03:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com> <20240603122852.3923848-7-tabba@google.com>
 <728c100c-ea38-4802-832d-04521821d169@sirena.org.uk>
In-Reply-To: <728c100c-ea38-4802-832d-04521821d169@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Jun 2024 13:03:07 +0100
Message-ID: <CA+EHjTw6ybZ8+YuRjmRcpm7rC_aHPn7H1V4cejrN1Zo9njhbGA@mail.gmail.com>
Subject: Re: [PATCH v4 6/9] KVM: arm64: Eagerly restore host fpsimd/sve state
 in pKVM
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Mon, Jun 3, 2024 at 4:52=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Mon, Jun 03, 2024 at 01:28:48PM +0100, Fuad Tabba wrote:
>
> > +static void fpsimd_sve_flush(void)
> > +{
> > +     *host_data_ptr(fp_owner) =3D FP_STATE_HOST_OWNED;
> > +}
>
> My previous comments about this being confusing still stand.

Sorry, I missed this in my reply to v3.

This follows the convention for save/flush in hyp-main.c. Since the
act of flushing the fpsimd/sve state is lazy, i.e., only takes place
if the guest were to use fpsimd/sve, then the only thing that we need
to do to flush is to mark the state as owned by the host.

You suggested inlining this, but since this is static, I think the
compiler would do that. Even though it's only one line, it maintains
symmetry with fpsimd_sve_sync().

Cheers,
/fuad
