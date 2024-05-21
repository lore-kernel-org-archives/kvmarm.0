Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B577A763F0
	for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 12:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716294515; cv=none; b=pWuA7OtU7+NPi3zVnDQOqt0GC+uNtd2PScbflfPvbiv+Kyrm+pnoMqhjrVwj6qA7E1EooJbKFZjq3YOXNVwXWW4aUU4HpAouPc9tnrCcnIdIroxk3KTE2DtyjTKgy4M9LVhhiZ2mrhdYeUZrHpcRD8YSHgrnrdWZL0NwxnP5qkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716294515; c=relaxed/simple;
	bh=YnKOB5k+cfXFmF1HFPh+ytM6NizBlvxBlwtMrZYFDYk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ttW+bNZZOIT2mRAQJy0V7lvKmIvhlBLeXlYdIaL8UGcxexuiIkK8CSLVgW9hN5wuxJFAqza1gDy1pilhRgvYLSUYA4zH60EoNlAEEW8saBngiKELLKWC3RUhZH3L7EFNNJDR0dqDdY60bNY+lhBJHl9TGpRdDexeFERyDLQW49s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=01+gbIoQ; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="01+gbIoQ"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-47f008106d0so917289137.2
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 05:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716294512; x=1716899312; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YnKOB5k+cfXFmF1HFPh+ytM6NizBlvxBlwtMrZYFDYk=;
        b=01+gbIoQjbuJax0jidW2m2OT0HP2qq4t50SYww2mhChitiSj+PziCx9hee/FBr9HgR
         QxzumTa05aH1cMN95ODn3xUpFXgZUFKc/UotgRzuQGnYxV4kmC7XmeEpsX/QpdZWquOZ
         1HwoimVgRVHUgeG737YMKURM2PKuUwLHaBBbBfcqm5P8/sI2MTMorNBsUvm3m2eBjxt4
         2/lBuAqKe7K31+HuJ9QeURrBXjAviZZ+5BOKsspCnMs0Pl6sSjA/8TMxvOLi0zWO8g5o
         E94KYadiBZ9XXkdT5V4Hu8SPIV5oTyAmTcaR1vruXTo31TRv8fECG0iXVI4r0u8Mjcbr
         wyWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716294512; x=1716899312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YnKOB5k+cfXFmF1HFPh+ytM6NizBlvxBlwtMrZYFDYk=;
        b=Hlk3aJ9M4SsDCyfs6wzgIG+Gz++l5AI+ypEwdPWn2IDOfrPTmahOHfuGMpFmFat+zy
         20NR6hDG+TOzKr44rINw/SocM/3VDvT+zNjrir66k+RHfv9ifr325PWdZPj8cOPdZa70
         xdnE/9gKYPOVz7GNyOysCvWXfKISIY9gDzRxx8zlIL7tDr1T913mszSRsnHAcn/IxwpD
         SidsInUfgmwkhe8tHkyWzLr3l9CddXRcYkOQsw88lgB5G3ZnTF6e2aa2nBf8KwJBqD/1
         PbA1VmYECQeToR0inavJ7/Xy8vOkG/0IG6UeRDNCN5UQ26yBmbBnNEsQBCUV3y3FctcF
         3FBw==
X-Forwarded-Encrypted: i=1; AJvYcCVGQ8UieTXlSHguzssJhsB7vvSRw+CTp9j1ZZ+n9I3j8bwreiXs26a51jywlqD6whmhb/AHrzWIGpwxkMlX2uTQ+zJ/EbmW
X-Gm-Message-State: AOJu0YwAU9WUWVcF3lYcEUNPlKE+x91IQrrEofMK+YpNgJcMjCugu3/u
	KXu43jsm+E4FqM/kHoKimbcl2At0XgmoaKRXQM6wUIFW238zWbjz6csEWupgxpSLLJCg+q6zFOk
	tLWPa64eNd5ARBT4wXXbgXU0ZD8MFELJNjrTl
X-Google-Smtp-Source: AGHT+IEEepHOVI/q+SM4mTlf22FyuG4U4k2qgjZfkiH3W5hjovRw5bW/NtCygWp/LGwoMstlerAiS7iakgOHAwWjvCU=
X-Received: by 2002:a05:6102:cd3:b0:47e:2e1:c437 with SMTP id
 ada2fe7eead31-48077e43290mr32103726137.28.1716294512445; Tue, 21 May 2024
 05:28:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com> <ZkeUTix0Ojn5eHKP@linux.dev>
 <b73372b3-e032-4afd-a7cd-e08a687b1d3f@sirena.org.uk> <CA+EHjTxJe8yjVkhc=2fENJoMZs+MTR=9AZLmYcxZ5HxNnUOaQw@mail.gmail.com>
 <87pltg3ntq.wl-maz@kernel.org> <ZkuKYA6-u-eZmBOO@linux.dev>
 <CA+EHjTyvRU13+LL=vyRTOykj5pbycVPce7dstXK1rpTF98jKFA@mail.gmail.com> <Zku4QF1VtKJqhnGg@linux.dev>
In-Reply-To: <Zku4QF1VtKJqhnGg@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 21 May 2024 13:27:55 +0100
Message-ID: <CA+EHjTxp-1TUSE6NG7P425KTJ_KmEuwsMqa=sXPP=f-17B-K0A@mail.gmail.com>
Subject: Re: [PATCH v1 0/7] KVM: arm64: Fix handling of host fpsimd/sve state
 in protected mode
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, will@kernel.org, qperret@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,


On Mon, May 20, 2024 at 9:53=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hey Fuad,
>
> On Mon, May 20, 2024 at 06:57:36PM +0100, Fuad Tabba wrote:
> > Hi Oliver,
> >
> > On Mon, May 20, 2024 at 6:37=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > >
> > > On Mon, May 20, 2024 at 09:11:13AM +0100, Marc Zyngier wrote:
> > > > On Mon, 20 May 2024 08:35:47 +0100, Fuad Tabba <tabba@google.com> w=
rote:
> > > > > The reason for that is that in pKVM we want to avoid leaking any
> > > > > information about protected VM activity to the host, including wh=
ether
> > > > > the VM might have performed fpsimd/sve operations. Therefore, we =
need
> > > > > to ensure that the host SVE state looks the same after a protecte=
d
> > > > > guest has run as it did before a protected guest has run.
> > >
> > > Wouldn't it be equally valid to just zero the state that will not be
> > > preserved regardless of whether or not the guest used fpsimd/sve?
> >
> > Yes it would. I think I did mention that as an option.
>
> Apologies, I probably missed it earlier on then.
>
> > However, that would need to be done at every protected guest exit, wher=
eas
> > restoring the host SVE state only needs to be done if the guest has use=
d
> > fpsimd/sve.
>
> Indeed, what I was _hoping_ is that implementations do a decent job of
> handling a zeroing idiom for SVE and avoid needing to fetch a bunch of
> state out of memory.
>
> > I think the code for the latter (i.e., zeroing out), would be simpler.
> > I'm happy to do it that way if you and the others think it's better.
>
> Right, I have no fundamental objections to fully managing the host SVE
> state in EL2. Strong preference for something simple + correct in the
> interim. Anyway, thanks for suffering through my whining and hopefully
> we can land a fix soon :)

Thanks for your review and comments, which are very helpful as always.
I'll respin this within the next couple of days.

Cheers,
/fuad

> --
> Best,
> Oliver
