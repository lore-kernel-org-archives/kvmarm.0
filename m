Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B227A74BE0
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 22:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709244840; cv=none; b=eobxXSVnRyJWIgGgm1tkIwFjFo5R2fG19/B+n6pNVNYsclV27xWinTPRWIGDDlQltCLugtOOfbD8znNB/VaVm8Od8nR64bN04bp7lAGutqfjYF8D4pfMgfiO0/5hjmpE3lQhxVVD5nSaGBAkh8KR+p1gyB2P0FqABxpdSm5hcx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709244840; c=relaxed/simple;
	bh=t21HnzIGHk+n6QlvVMMSXJY9HBCCiiEVREtwL2Cu0k0=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 MIME-Version:Content-Type; b=mHGXyjAxxiwF4D+6696F2Ws0/Zw5CpIWwn5v3tm+HDG344O4wzCI8SezZoLadVgGF2pF5rds4+POLED2OjjxBugcS1rKAFtuz0622anXXeHXUQmsVyUKoy6EoH3097WZbRyo5nua8eJzBovheq/7SiJR9+f5PRdmFP+OjRGwsKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J02uUBnr; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J02uUBnr"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3bb9b28acb4so1055560b6e.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 14:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709244838; x=1709849638; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=F0bbqczj3Keglw64JiNfdvO4M759XtAlzANrlsOPWOc=;
        b=J02uUBnrZHmUqFXdCLWqYdy+8Wa0gyzcCPuqQzo07AP4I7JiUdXTMcbtpj28hUCZAN
         h4BOFBotOj+FOVmawMrU0SxA7j/bO96xCwl79fbSl5mHEoL4ueYkCtxSIhqXAqO4R6c0
         c81Uj+YLtxgu1NSgZ3UFCL/QuhKX9PaSYy8B/gPu20V2rGMNEuH/51ZkJ9U8kU80QX9h
         uCPfZiOKPohyZ1eTJj0X/w7Uj7F/S9GL5Br0zSrTCBaTV1O0qAdOJm0Qa9A+GB+GNkEk
         bXqn0YuGS3ZZblodO0wVAzal6EYvRmKeuF3dJPLqbpaks69QQKnh9GLERBGa7WD8unH6
         l06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709244838; x=1709849638;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0bbqczj3Keglw64JiNfdvO4M759XtAlzANrlsOPWOc=;
        b=oPkB/aQ8HSu3QZR/x39TjTrnDgKqlnjFyti7fN2B3G3tDhh79dZkvjVKVfUbUxvfqj
         zT1wTaLL/bB3HhFrvGq7lahUbmW9ajD3z88jZ9olMhJiPoBYaVrSTDdvmP66WLXofNp7
         zNl1/rZARIevF1nVKDLyC+0xsjGyw0SkbvtlxWWMz5TNN7W8ChoaIqeBPJ0tC8btabG7
         U/dEb10y/4/q5M2oiFyVlIhF/2ZmjH8X9MRSiT7cYUw4V31uVFSHzyIuC5amzDTEjGwD
         3uMjY39lhY2BNoaAIdf/zALopPAXDEPWYWEJ0kqZGzrdkLflOxwM8Fq9emri+lK8yinz
         7QPw==
X-Forwarded-Encrypted: i=1; AJvYcCVRjc/GpFSOi29tPeLwqP4uTb3FzVkxiFMPHfysOHWIz3Q6zc64BjewrAzdqqAXpqgf+9+W/hHaaumpJg/RaP311qb/WzKX
X-Gm-Message-State: AOJu0YzPbjYLwaMSQ66Pj5O/XQUcLLBWWPV3gGum1+bt7818kqABRIqE
	d0QRmZGnYMOImL2N6Ae9eG9fquPo032s+0ZQyLOGeufB0wxGkm8fpCZ6FCf5OEQ=
X-Google-Smtp-Source: AGHT+IHdJxypAmK3qvNYc2vGOAmkw9y2ZwPcLUGqtAKe2grsU0Su0E62P6Tt4LBvrgbMxt6+5DcYzg==
X-Received: by 2002:a05:6808:438f:b0:3c1:c2e6:b046 with SMTP id dz15-20020a056808438f00b003c1c2e6b046mr3051822oib.23.1709244837897;
        Thu, 29 Feb 2024 14:13:57 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:a90b:ac37:af4a:feb9])
        by smtp.gmail.com with ESMTPSA id ei4-20020a056a0080c400b006e57e220ceasm1771460pfb.6.2024.02.29.14.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 14:13:57 -0800 (PST)
References: <20240203-arm64-gcs-v8-0-c9fec77673ef@kernel.org>
 <20240203-arm64-gcs-v8-33-c9fec77673ef@kernel.org>
 <87sf1n7uea.fsf@linaro.org>
 <9b899b4e-7410-4c3b-967b-7794dac742e4@sirena.org.uk>
 <87ttlzsyro.fsf@linaro.org>
 <c710a6b1-cf58-4e32-ada0-c0b256a62b2c@sirena.org.uk>
User-agent: mu4e 1.10.8; emacs 29.1
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
 <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, Oleg
 Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees
 Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, "Rick P.
 Edgecombe" <rick.p.edgecombe@intel.com>, Deepak Gupta
 <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, Szabolcs Nagy
 <Szabolcs.Nagy@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Florian Weimer <fweimer@redhat.com>, Christian
 Brauner <brauner@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v8 33/38] kselftest/arm64: Add a GCS test program built
 with the system libc
In-reply-to: <c710a6b1-cf58-4e32-ada0-c0b256a62b2c@sirena.org.uk>
Date: Thu, 29 Feb 2024 19:13:55 -0300
Message-ID: <878r329avw.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Mark Brown <broonie@kernel.org> writes:

> [[PGP Signed Part:Undecided]]
> On Thu, Feb 22, 2024 at 11:24:59PM -0300, Thiago Jung Bauermann wrote:
>> Mark Brown <broonie@kernel.org> writes:
>
>> > I believe based on prior discussions that you're running this using
>> > shrinkwrap - can you confirm exactly how please, including things like
>> > which firmware configuration you're using?  I'm using current git with
>> >
>> >   shrinkwrap run \
>> >         --rtvar KERNEL=arch/arm64/boot/Image \
>> >         --rtvar ROOTFS=${ROOTFS} \
>> >         --rtvar CMDLINE="${CMDLINE}" \
>> >         --overlay=arch/v9.4.yaml ns-edk2.yaml
>> >
>> > and a locally built yocto and everything seems perfectly happy.
>> 
>> Yes, this is how I'm running it:
>> 
>>   CMDLINE="Image dtb=fdt.dtb console=ttyAMA0 earlycon=pl011,0x1c090000 root=/dev/vda2 ip=dhcp maxcpus=1"
>> 
>>   shrinkwrap run \
>>       --rtvar=KERNEL=Image-gcs-v8-v6.7-rc4-14743-ga551a7d7af93 \
>
> I guess that's bitrotted?

Ah, sorry. When I renamed the Image I messed up the kernel version in the
filename, but I did confirm via "uname -r" that I was running the
correct version: 6.8.0-rc2-ga551a7d7af93.

>> My rootfs is Ubuntu 22.04.3. In case it's useful, my kernel config is
>> here:
>
> ...
>
>> https://people.linaro.org/~thiago.bauermann/gcs/config-v6.8.0-rc2
>
> Thanks, it seems to be something in your config that's making a
> difference - I can see issues with that.  Hopefully that'll help me get
> to the bottom of this quickly.  I spent a bunch of time fighting with
> Ubuntu images to get them running but once I did they didn't seem to
> make much difference.

In that case, it's interesting that I still run into the problem with
the defconfig. One thing I failed to mention and perhaps is relevant
considering your result, is that I didn't copy the modules into the disk
image, so the FVP was running just with was built into the kernel.

That was actually the main reason for me to use a custom config:
I didn't want to have to deal with kernel modules, so I created a config
that didn't have any.

-- 
Thiago
