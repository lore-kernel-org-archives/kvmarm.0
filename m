Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85CE3ADBA4
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783931204; cv=none; b=cM7/aOOGqyxvwBUd/vkf3drafkBXKTYdNxMeXdlam/KiWOf7cGWa9sBIGSW+750/9lz8l1BPYouo9Kt7Xj5Tdf7IjhyIgnXvBdzEZ8dz8whxg00JZW0SxRA7zj0TTKKzEhKh5mUZ1eZEsmOwkXXyFJMK92dElRBZ/ps76fV9Fow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783931204; c=relaxed/simple;
	bh=C082o+EiFKpjjyCwale+ZemOqCiOLALjOGsSt2C9bbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fShGahAoPoeGyK8t4LGN9VAxY/cysc08WFC/BrionkyNsgNr18bSo8XEvI/nnryJZIp1ZaQLXvlL5NRPn7fCAVqLcWi52YbxStZp9BF2NTTB3acJsmxa9L2jDY9vsWLkI/CWgIYwnHyWf61DSgveuaCeh7JWjWplSSIeyxdZ0d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WcRYAjDw; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WcRYAjDw"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493b8d99342so65075e9.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 01:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783931201; x=1784536001; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=amf55tWJXben6rIQyHF/blCpD5b43dwdFfwgfK1yuhQ=;
        b=WcRYAjDwfd0vPhvnuQW6fM3VRea1jPNsHh2o40KpzWznFI7HXI+6u+9KKX+VLm4Dsx
         KeYh9q1CRA7/s+ghR3LyGXGOBSnYxZx8HbJaNoYGkBZpb8b/AsjFk58w/P3nqH8Wj+cW
         HE9adSL7jidBAAUMuOFfh3v51e2fuHy8gR6QsoPB5l++dsTE1JMYXdhojwZ2h6CmrtOG
         VFLQcFiebLW1aBi8kHHBuTCTFdM0NsW919vsHYuCoyBU0fTo07jx10AdVYv4FjLq79KD
         GbYGY3wjT4mGNR+QOWxPDpLgG4NwmHN2kNf2YfTdsPnGZ86iKSkFQs0TpCYEZY635Ija
         YP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783931201; x=1784536001;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=amf55tWJXben6rIQyHF/blCpD5b43dwdFfwgfK1yuhQ=;
        b=R7lh3F/eBd2ZhGpdxZJOWyHvCud+R8hebOwSj2h3vWSh1RI+0oSHCWF1VjPwHL1ZnO
         2JH2bGTHj5fBguGI+89bVSh54b2MZILNR8kPlJyqafXEsTz5GFji1/wEO2fz/RQtNaXw
         xCimQGzVxOHqrurmVv6hQl0WU+8Ad9UdkPdi0QOXyKd2SJObzw9494dKn/iG7U43AOtS
         LVDiQGPaOL08os+QCNSpeSLQcPXH6oPyXku9VHNTWyInAmzubvhVONN292JQWywv+dYD
         J5bm7peYC8ep/xEt50OTVK8QCc1Q6jiAxiktuY5cYuNQY7ZBuENcmBdpD3Dh0TRgHmIi
         WSZA==
X-Forwarded-Encrypted: i=1; AHgh+RqYi9nIFVA2DcUsgLfUXGXyHs5B/UgAGXC/69C0yzEDh5JTfvtUB/fAguPgilbPDHRoIlRw4G4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+2sq8cTPbrKm5LWh5pfgfYvpBuQcZadIUfT2uuxZv7omlzq3j
	kKXf6lgE8ZkHcYhlAdhxIjvPqBNX5ZWAVJRy3d+7EjpWXkSvm95NHr3FiwFXzYn0sPCvNiZ3zj+
	kELjfaQ==
X-Gm-Gg: AfdE7clBTGSWZvd0lES9BbUDfk6u8zyXxVvfi6+yHrB95oQ/k3lX+uhMnibZ60ieDuc
	Q1cbN0whfH2rhtpZGIpNlCNSdl4Y3pdKEabIJtIkdQts2q1Yx1Ayyhng5NyuyedjYlQ5/gU6DI4
	Qlko5cw5UQKGIi2Te0rb5rSXfNJJ8gk3ZYSj3quzLcLDllPU67qHN91++SDM6KAViHwqr5TaO5h
	S+eCko14st3esT20Eh3AqOFpXMCbh764ipYnXz3iGqROH7Gm/SCjx8aOwjgms1p1Bt5gv8mH9wE
	2a5KcNWZ/TZfS2+mihEUJydAQI2uBedl1UrxI5Vw/ecZfJbAOxsbieOWESoFq4YkoZCww7LScL9
	d4K2l5NUb8UrkOM4ulyvAqkIQSDTa6xIgnz9s/HTS1Hlklg0dtbr6XYexk6oF6xs7t8WuZ1XFbm
	ucyIHxC9+x9LZhZxWMpejp+twg7xgWYLoj87FuEC5SdMzq0/jSTNTSFm8yi80=
X-Received: by 2002:a05:600c:3589:b0:492:203f:a378 with SMTP id 5b1f17b1804b1-49465abb636mr24695e9.8.1783931200485;
        Mon, 13 Jul 2026 01:26:40 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1d91bsm88670924f8f.4.2026.07.13.01.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:26:39 -0700 (PDT)
Date: Mon, 13 Jul 2026 08:26:35 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
Message-ID: <alShO27MLsNqgBws@google.com>
References: <20260712153835.2264905-1-smostafa@google.com>
 <CA+EHjTxN1fcBVRi+yK18UgReGsX8Evu1GsijSQC61dY3XrjCtw@mail.gmail.com>
 <alPox2BDk4Il0s9t@google.com>
 <CA+EHjTzvzcV8Cxw+VHK9Fxv7Y-7m84XbzUFU+4sXZXNrM8y7dw@mail.gmail.com>
 <alSdr9wNyyPiHmbt@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alSdr9wNyyPiHmbt@google.com>

On Mon, Jul 13, 2026 at 09:11:27AM +0100, Vincent Donnefort wrote:
> [...]
> 
> > >
> > > > > I did not add Fixes tag as this is currently dormant and not breaking
> > > > > anything.
> > > > > ---
> > > > >  arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
> > > > >  arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
> > > > >  arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
> > > > >  3 files changed, 8 insertions(+), 8 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > index 9f429f5c0664..c2ccd0e8bf22 100644
> > > > > --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > @@ -6,11 +6,11 @@
> > > > >  #include <asm/kvm_hyp.h>
> > > > >
> > > > >  #ifdef CONFIG_NVHE_EL2_TRACING
> > > > > -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > > > > -u64 trace_clock(void);
> > > > > +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > > > > +u64 hyp_trace_clock(void);
> > > >
> > > > hyp_trace_clock overlaps the host side: arch/arm64/kvm/hyp_trace.c
> > > > already has a struct hyp_trace_clock and static helpers
> > > > hyp_trace_clock_enable() / hyp_trace_clock_show() for the debugfs view
> > > > of the same clock. No actual collision, so this is only a readability
> > > > point, but a reader grepping hyp_trace_clock now gets two unrelated
> > > > things. Maybe you'd want to consider a different name, but naming is
> > > > hard :)
> 
> If we were to rename: the clock is a "hyp_clock" so probably trace_hyp_clock()
> is the right thing here.
> 
> while the "hyp_trace_" is the prefix for hyp_trace.c file content.
> 
> Although I would like to see why we pull trace_clock() from the kernel into EL2.
> That bit sounds wrong and if we have a way around perhaps that's better?

Most include path look like this:
In file included from ./include/linux/ftrace.h:11,
                 from ./include/linux/kprobes.h:28,
                 from ./include/linux/kgdb.h:17,
                 from ./arch/arm64/include/asm/cacheflush.h:11,
                 from ./include/linux/cacheflush.h:5,
                 from ./include/linux/highmem.h:8,
                 from ./include/linux/bvec.h:10,
                 from ./include/linux/blk_types.h:10,
                 from ./include/linux/writeback.h:13,
                 from ./include/linux/memcontrol.h:23,
                 from ./include/linux/resume_user_mode.h:8,
                 from ./include/linux/entry-virt.h:6,
                 from ./include/linux/kvm_host.h:5,

Although, some files have ./arch/arm64/include/asm/cacheflush.h
directly.

Thanks,
Mostafa

> 
> > >
> > > Yes, that shouldn't be a problem,  I just added hyp_ prefix, but I
> > > am ok with any suggestions!
> > 
> > Didn't I say naming is hard? :) How about, el2_? Not really happy with
> > that either tbh... but can't think of a better one...
> > 
> > /fuad
> > 
> > >
> > > Thanks,
> > > Mostafa
> > >
> > > >
> > > > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > > > Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
> > > >
> > > > Test: builds fine with the different config enables.
> > > >
> > > > Cheers,
> > > > /fuad
