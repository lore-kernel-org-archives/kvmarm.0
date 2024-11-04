Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BA42BB04
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730737832; cv=none; b=j48MP08WxyybfasWVtXZbUfYLEgdQlFPMhRjEkjYxsLZGjkXuTwodJRIYhe8JwCw6XTxLg4umEXKdwT+WRSYf4VUpxYCkwfkAZJRr22cyG0I/se8f/DJW1Bu5W1MnOJgynkBhAA7yNcOcsLone2ok9ZaJcJNVsj7Yd0JiJ1e6pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730737832; c=relaxed/simple;
	bh=Ll4tJtBmfcOCF1wRTkd8jK9LVRHjEColx8OdGS2YV0c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P8gDw8Fsj8i00OkYzWOJwa84Z/IaLr2ogtWj1S1uer++UsSYBI4PWnKanMQY7lkxO6/W1jJ5w0vFxxahpZAEy5CbJ6vCgl8pquoafLfJVt9BI0hNLPcIJgFp+ZMwf98LpvKHJRzMqobFN5fDZviwFIW7dJr9awA8R1uNg8Ndpns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F8VTZVSI; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F8VTZVSI"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37d538fe5f2so2951141f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 08:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730737828; x=1731342628; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=81MEKb96Xf23UJSyBQxdF8diKY/hHJyzem6vpJzEVks=;
        b=F8VTZVSItdjrQJv/zi8bcQYNWnvvpi9oey7nKmOUVehaW4rg++WzxApAdFndXCkuMg
         YPN8b4Sw6Zumv9HSGm9ZBAf9ly1uzwYhMiZfIKjuy74P2QbSl/dI0HUq8LGcLnzfH3ng
         fwam6yGBZvtmkNXtC5zrtZfYZQD5G4/VkhOTV5LoLnIx2sQ9X96E1QEzuD87OyUOvtJt
         m/22EVcorC9KODBRTbIfSKZq2OjVdvRdRvz9BB97fk+C3yJmVZjFIzvyCK955DsBq7sK
         wNukmh8OZe+RzjPU9xDW19NJCamx4lSd5wIpYaKLv8FZOR3qmfiZpaM++slXAiyZNqg1
         8Eow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730737828; x=1731342628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=81MEKb96Xf23UJSyBQxdF8diKY/hHJyzem6vpJzEVks=;
        b=HkLOSWb0hpM1m8HV7AEYR/JSMXFFTE1qklweV75EnGHgz6BXFdTIEZlwBAKDE9lT5Z
         z8Ht4pIJrobdyPoUxpjFTWszsmeheeem+rel7NvPAk1+IBdCfKn8InylH4sTrRB3RtOm
         lx4nJJIljkPY+9LuOb7cyG6NGsVIjzq3cFrJ08mq+wuGSj7GiPPdEbQ3cFNHIUvEpOVf
         /6p8BsU+dGAIqw0cpQ436dOURjxwY7Jv38Z9V245o7+GK4gDLPHsoOct4u/71gElvcjb
         Nf5CSUYuIyIPMc7/gS5tf69KOJxaKtaIOpbra3jx6YY+a4BPGOvkparQiv6B1i5g8TYr
         GFLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgjcpR6wODZ0lsGes1Tx/X9E9m34BsIlOKkIeaXR+LCJxPi897+eTuceuhlDC4Kl1/MH9+3LA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKFntHAH/553ou1uboMRx1aubvGNFkEG4bLui0FxBJO9+ZglnP
	oQnBI1gyRGtuwVgMRGzUhOj2F4Wa0IQBS8Wwr6U7Yd35PyCxPfk3rrhyNBLouVkzLvqvFXiiVnz
	CUERdNfYNbeqP0C0FmlEQjmUTvAjhUtVKJefDwQ==
X-Google-Smtp-Source: AGHT+IEju2LhnIlbLomjmkieAVQZclJMFur7ko24mfBkDSRB0/zezLDP4oMRlXLwj9h5AjtXpFCyqKny28HPJkpERnQ=
X-Received: by 2002:a05:6000:1569:b0:37d:3777:2ac6 with SMTP id
 ffacd0b85a97d-381be7d9781mr13788713f8f.35.1730737828579; Mon, 04 Nov 2024
 08:30:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com> <Zx__Zi3Zpg1AspnE@pinwheel> <52690aae-55b6-47d5-a308-dd75475f8377@redhat.com>
In-Reply-To: <52690aae-55b6-47d5-a308-dd75475f8377@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 4 Nov 2024 16:30:17 +0000
Message-ID: <CAFEAcA9y5ooPNZ7JbGmRyTKbZn5XPK+5zZgVAvnER=++kWuBrg@mail.gmail.com>
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
To: eric.auger@redhat.com
Cc: Kashyap Chamarthy <kchamart@redhat.com>, eric.auger.pro@gmail.com, cohuck@redhat.com, 
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev, 
	richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org, 
	oliver.upton@linux.dev, sebott@redhat.com, 
	shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, berrange@redhat.com, 
	abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com, 
	mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 4 Nov 2024 at 15:34, Eric Auger <eric.auger@redhat.com> wrote:
>
> Hi Kashyap,
>
> On 10/28/24 22:17, Kashyap Chamarthy wrote:
> > On Fri, Oct 25, 2024 at 12:17:40PM +0200, Eric Auger wrote:
> >> From: Cornelia Huck <cohuck@redhat.com>
> >>
> >> Add some documentation for the custom model.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> >> ---
> >>  docs/system/arm/cpu-features.rst | 55 +++++++++++++++++++++++++++-----
> >>  1 file changed, 47 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> >> index a5fb929243..962a2c6c26 100644
> >> --- a/docs/system/arm/cpu-features.rst
> >> +++ b/docs/system/arm/cpu-features.rst
> >> @@ -2,7 +2,10 @@ Arm CPU Features
> > [...]
> >
> >> +Using the ``host`` type means the guest is provided all the same CPU
> >> +features as the host CPU type has.  And, for this reason, the ``host``
> >> +CPU type should enable all CPU features that the host has by default.
> >> +
> >> +In case some features need to be hidden to the guest, ``custom`` model
> >> +shall be used instead. This is especially useful for migration purpose.
> >> +
> >> +The ``custom`` CPU model generally is the better choice if you want more
> >> +flexibility or stability across different machines or with different kernel
> >> +versions.
> > Does "more flexibility or stability across different machines" also
> > imply "live migration compatiblity across host CPUs"?
> yes that's the goal
> >
> >> However, even the ``custom`` CPU model will not allow configuring
> >> +an arbitrary set of features; the ID registers must describe a subset of the
> >> +host's features, and all differences to the host's configuration must actually
> >> +be supported by the kernel to be deconfigured.
> > [...]
> >
> >> +The ``custom`` CPU model needs to be configured via individual ID register
> >> +field properties, for example::
> >> +
> >> +  $ qemu-system-aarch64 -M virt -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> > If possible, it would be really helpful (and user-friendly) to be able
> > to specify the CPU feature names as you see under /proc/cpuinfo, and be
> > able to turn the flags on or off:
> >
> >         -M virt -cpu franken,rndr=on,ts=on,fhm=off
> >
> > (... instead of specifying long system register IDs that groups together
> > a bunch of CPU features.  If I understand it correctly, the register
> > "ID_AA64ISAR0_EL1" maps to a set of visible features listed here:
> > https://docs.kernel.org/arch/arm64/cpu-feature-registers.html)
> Not all the writable ID regs are visible through the above technique.
> But indeed I think we converged on the idea to use higher level feature
> names than ID reg field values.
> However we need to study the feasibility and mappings between those high
> level features and ID reg field values.
> The cons is that we need to describe this mapping manually. Besides
> being cumbersome this is also error prone.

You might be interested in "Arm Architecture Features" on
https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
which includes a 1.8MB Features.json which is a machine
readable version of the "what are the features and their
dependencies and ID registers and so on" information.

But note that (a) it is alpha quality and (b) I am not personally
going to try to interpret what might be reasonable to do with it
based on the legal notice attached to it: that's a matter for
you and your lawyer ;-)

-- PMM
