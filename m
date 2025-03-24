Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48671DDE9
	for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 15:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742831530; cv=none; b=kZiMu951c40jHKXqzS3mOg9BK6nwJcgnUpFnDdGomqpnRs2bRI9ZwGHsjLbfo7Ts7GFpGR5lWXfn2omWJw7EsbwCYrFaJAcElvENet1KYfhtJY0KCfvPF1YuBooi+bw6DRHHPwmZwtLFIR2/NWopjwVTkw6mKS2XLFLtbehrmy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742831530; c=relaxed/simple;
	bh=jrF5OhvPJSXyXb6LX2+y3oBS6QjtjU88e7ADlwpSXaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D2IEBLI4sD1KjC6AjawFUh7glcuTydj9Cfl02+mYTPMsePNbn4zRwq9yCRk2VCmHHm3U7EFg6IOJD/jeRb3H93kqVR5zBEa2nXnGzQToGK88vmhwidpcigytMBkb9f8N98Q40u4D8WR3o1yMZpXWYayHXiBYAgh2+CIejLc3U3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qyhGSqnM; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qyhGSqnM"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cfebc343dso34546865e9.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 08:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742831527; x=1743436327; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfspRdXGlgq6NyzVTJZAgVrhAb+j3MeBFls5zV5sjbk=;
        b=qyhGSqnMboFqPpVDa1n/1njBgUFdEdqwb+FGF9dspnjMaKsHAn8oZlnyrDJKJHXK5P
         9REndK8pejEFAq6x5tgbMTvR5dY+pinsQNuUdgk2VIH51eeIl/ZL8qqzAsZUxDowR72f
         q20OmauJpkuVsho7wrepjwnAfKFUZG5rQ1h4mGPafURgVPEKJE8fUrG8vpKEYT7o6Ft+
         TXn71/nkVaijyewqu4Et+3/f84nYxIpBeEPeCnLZne3ioN2R0o+cr41xeFkS9mgVCC2g
         8w9CLT1/en98p+OrdQu7lu2NbpsroB1jpGXSx5qjyVKdt/5dF9K7QNrlo4wsE3QXC+oY
         lcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742831527; x=1743436327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfspRdXGlgq6NyzVTJZAgVrhAb+j3MeBFls5zV5sjbk=;
        b=FQ5QfTkfSDYWC0sl1uZdm+FzziMwoia8yXdcOIiDdFNhVL/GW9+OTsl6cXhUa/JCjI
         Jo6MWM1OtPSEqL9qka75FIsD9D5eJDJLp2Jy47CGpNkDS95I8aLyOO2Lmi0azeFiTPUS
         Sj5JTYboHQpI77WlyMALbXss2GcBGz7sfusEgWQPfrNfJ+Y8ji/7AmsiKeetyiY2bvSo
         5fbQUzk/JOArmbCuObGh080lXpmTpMxqcsU7XNGpdsCu+6UIEubhf0ifggWaXwNX9gPo
         9JOIY1zMWIBUiLjPjHUaYKbk4T1x41QZOHxjF/UlYkEUe0H+9AY0gs1Vz+GtIHN5yQsO
         5mUg==
X-Forwarded-Encrypted: i=1; AJvYcCUlVnPuC4i3gctcMXwt2MQXp1MyyLifktXQo3tS5MV5PcX7vLBb98rdBv2INYrfuB6cvVkaa8U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxgAO+7XwP8cYKW0ES7NdMQk6mD2Y0AH7mEwUiY1kIZSpdcfehL
	VZ0FDWVnOuOwjTsUbfD17PRFWrwPAXofgubXu4wSPVLEQGYbcW0gCTNSUOCAkx0=
X-Gm-Gg: ASbGncupD3iAulwwRu3o/52quiHXyy2nmMHXf5Zbi6vIj7jrglZAqlBQXSeDzS+/0G6
	FidKX2oByLtxeKQ3ZutqwJzWeJwSgKIlHLQuZAI8XCFZErBEiLlLnw1nXHJem1+b1KUsMY2HN/q
	KxOWIjH8jszhFKKBB1VcuEoszMpUEyTenPAMWJEkJU7zkbaceZ5/ypAD3M7WNPa7246+sMJHSjf
	+QJfzkC71rR2ffIA7HqEjc303l6mh65xHzHJ5exnZAVJVIiNBBSV1huH2hziofhm5faOz7y8pll
	iswbudpanTt7EyDfgnFeAbR4dE5odXBxGigrUN3vtkU=
X-Google-Smtp-Source: AGHT+IFl7nFmYn4ImJin0UE8VO9TEBa7A4QjUDf+jR+LnIW0MqNGIXU4E97G8J6fG8YpTpqXzsYFRg==
X-Received: by 2002:a05:600c:574b:b0:43c:fe90:1282 with SMTP id 5b1f17b1804b1-43d5703e686mr82814625e9.7.1742831527103;
        Mon, 24 Mar 2025 08:52:07 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f556basm173837045e9.17.2025.03.24.08.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:52:06 -0700 (PDT)
Date: Mon, 24 Mar 2025 15:52:05 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, eric.auger@redhat.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Message-ID: <20250324155205.GC1844993@myrica>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
 <20250322-91a8125ad8651b24246e5799@orel>
 <Z9_tg6WhKvIJtBai@raptor>
 <20250324-5d22d8ad79a9db37b1cf6961@orel>
 <Z-E2v1sKiPG_pt9x@raptor>
 <20250324-37628351a72ca339819b528d@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324-37628351a72ca339819b528d@orel>

On Mon, Mar 24, 2025 at 02:13:13PM +0100, Andrew Jones wrote:
> On Mon, Mar 24, 2025 at 10:41:03AM +0000, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Mon, Mar 24, 2025 at 09:19:27AM +0100, Andrew Jones wrote:
> > > On Sun, Mar 23, 2025 at 11:16:19AM +0000, Alexandru Elisei wrote:
> > > ...
> > > > > > +if [ -z "$qemu_cpu" ]; then
> > > > > > +	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
> > > > > > +	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
> > > > > > +		qemu_cpu="host"
> > > > > >  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> > > > > > -			processor+=",aarch64=off"
> > > > > > +			qemu_cpu+=",aarch64=off"
> > > > > >  		fi
> > > > > > +	elif [ "$ARCH" = "arm64" ]; then
> > > > > > +		qemu_cpu="cortex-a57"
> > > > > > +	else
> > > > > > +		qemu_cpu="cortex-a15"
> > > > > 
> > > > > configure could set this in config.mak as DEFAULT_PROCESSOR, avoiding the
> > > > > need to duplicate it here.
> > > > 
> > > > That was my first instinct too, having the default value in config.mak seemed
> > > > like the correct solution.
> > > > 
> > > > But the problem with this is that the default -cpu type depends on -accel (set
> > > > via unittests.cfg or as an environment variable), host and test architecture
> > > > combination. All of these variables are known only at runtime.
> > > > 
> > > > Let's say we have DEFAULT_QEMU_CPU=cortex-a57 in config.mak. If we keep the
> > > > above heuristic, arm/run will override it with host,aarch64=off. IMO, having it
> > > > in config.mak, but arm/run using it only under certain conditions is worse than
> > > > not having it at all. arm/run choosing the default value **all the time** is at
> > > > least consistent.
> > > 
> > > I think having 'DEFAULT' in the name implies that it will only be used if
> > > there's nothing better, and we don't require everything in config.mak to
> > > be used (there's even some s390x-specific stuff in there for all
> > > architectures...)
> > 
> > I'm still leaning towards having the default value and the heuristics for
> > when to pick it in one place ($ARCH/run) as being more convenient, but I
> > can certainly see your point of view.
> 
> I wouldn't mind it only being in $ARCH/run, but this series adds the same
> logic to $ARCH/run and to ./configure. I think an additional, potentially
> unused, variable in config.mak is better than code duplication.

I agree with this. However the next version ends up replacing both
cortex-* types here with "max", so we won't need to pass these values in
the end. The "processor" selection in configure will only be used by the
Makefile for the compiler flag.

Thanks,
Jean
