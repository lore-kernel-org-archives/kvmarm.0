Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8523B47D7
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932066; cv=none; b=ME5UlShYTJXmQ+XY+N51pdkunyOatDeliHmb/NJhXTYBIG7yVMeodYGW3cqUxu6y+ohcKzhVRT6+i2oH5EMGLX5rcjNv7iwvuKSIoQwXU9sIfs5lRyybfuZwrO9OyddqWnOKgxjzT0sKYyXcqOwysA15h5KnrGE+MTukTC6O4FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932066; c=relaxed/simple;
	bh=qDom30kDHQE1yKBRCtUYznzilrIa3QNyN3Dz2jBUzRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+otq1lbKcd1oZH8Tx6R4xYjrM8A5MPg/TtB1PENycgyw8RhiyPauIgg/qq2rI7IxGvU03tHnxFW5EDW/LgUQdAQHJrhXp1sZ6DDiJv8WFGoacpar1uYjo7iq/qK+eVu72ANe+IfX5oPewHbi/maUkQIBXKlHwaCBt4WPJcds+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p6Y9dCi8; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p6Y9dCi8"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493b8d92a4eso77115e9.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 01:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783932063; x=1784536863; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iyY6y6D9mzZJEerW/Rbo/gzzpD8ruopg3Z6AtyKjKbs=;
        b=p6Y9dCi8XDlxO04+dik9PYlaqhbIhHVHrARfi00He6SVbdvljZfQPbf3GUcW4dkhQs
         iCF2bKhF9e5MCMOpEvVIK4Ov2aGeH/xbRD4TOh5USksyDk+BdQ1Yuj1o3xWWhIb5oR78
         GC2on2q07x6YG+LQNKqucL/+FabpZRbJXRXMES9wWvQZosJbroJDBaaPVSeH8u1lLVRo
         +UZVlBUDTt0Fux1UC29H08Bm52zZ3+kPa/tDAEkItpmdgFBfj77ouZyGFkBLKACzefe/
         xTPoKAzPgmjwaLELx652SIC3QHYd/NSfxOrnFivuM96BtVoPuLQrXz4eZjDO7ULg7TWw
         fKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783932063; x=1784536863;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iyY6y6D9mzZJEerW/Rbo/gzzpD8ruopg3Z6AtyKjKbs=;
        b=SaBRD51XkdAheRtXG4C16sMlTr4SfhqGDs5dqJrEFeEGtAq93jmbF+s2MR3G10RQRA
         YKMQa9wZgnJkJg0rfQTYduhpZPGIqrGURZIqUOM9KkQZ/K7es/HNbpz53pkCped6wl4t
         KKK5qWeuDmnPQV8ln6R1qg6ab3EshidDnrMVpKno8Q7d2XHZHTnpEcli3Xqr3VIfIiFn
         rfUe12j5ccsHcTnj1tXUVSexYqa93VF3LhD8iyqtsD5lFOUggQ76S0DWOwids4mo0kRC
         McUtiiW9fPU/hSieAojafL1SsI112z5cOfGDs766FNlSms1QnwM5sVbZWSwQcwxFLRmY
         AEeg==
X-Forwarded-Encrypted: i=1; AHgh+Rr2ErD0JO0o4jRxAbS8Len4QmXr9mbPpQBYa3PfbsZPjqlJlMcjJO6gSRiC9kflt3ICJjpO45k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxs2dANTCuMpXODJnQwjmWGUp+XpyWNSiZUKozq1ZWmtrpbjLKD
	jR4exJcKAkhToo7MTI8vIojeDwm8tVy092iDmWgOqFPh6uq0OlAOqUMVcTDnalbsuw==
X-Gm-Gg: AfdE7ckQAzoO1OTMMBtnnPdlYjCnr4XNJKOG4EiuaKt1B03/HoP4bhf5RiYWQ0K1bTN
	1rg/2pf4WDP5taFlaiQmKTU3h/9P0sNZKh2rlZgF5Eb5zuHKlqTx/M1XuO/3Z+Yd3Q2dUvjKV0E
	MzSUHVRNVix+O/C+qLobddYNtvUojQ2l/dGvACBZ2zfbtakIBVxIWVzg+f8dyqP/z3XIIHH+A8o
	kH09cIQFwNr3KwtdRjZpktf4XE5qmMbjtZ14kHF4HizsRIgA0y0wgDeHO5OES3TLEVvXjnf6RiH
	OJMDthrNMo4xByhZWqkWrM9g6XQLNXWeiwVP1zT1BnVnXxrh+YZwAvX3dgTsyCAnOeNN9DU9a90
	2z2UlAlqTwxBzUQW5/rW4n62ZJV6OJPq0FPGuu2x6AytQS9dYY37dN2Ih85q6qydgj44D9lQC86
	i6WC0e+qy6dClhhWsuJa+HjiIZECA73kaEwomP5Heh7upy0Id+
X-Received: by 2002:a05:600c:6092:b0:490:b3cd:fc4d with SMTP id 5b1f17b1804b1-4946216ff53mr65255e9.9.1783932062990;
        Mon, 13 Jul 2026 01:41:02 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6f16cfsm349445955e9.12.2026.07.13.01.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:41:01 -0700 (PDT)
Date: Mon, 13 Jul 2026 08:40:58 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
Message-ID: <alSkmhpjNCYFnUmO@google.com>
References: <20260712153835.2264905-1-smostafa@google.com>
 <CA+EHjTxN1fcBVRi+yK18UgReGsX8Evu1GsijSQC61dY3XrjCtw@mail.gmail.com>
 <alPox2BDk4Il0s9t@google.com>
 <CA+EHjTzvzcV8Cxw+VHK9Fxv7Y-7m84XbzUFU+4sXZXNrM8y7dw@mail.gmail.com>
 <alSdr9wNyyPiHmbt@google.com>
 <alShO27MLsNqgBws@google.com>
 <alSjGAqmB7HX1jYB@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alSjGAqmB7HX1jYB@google.com>

On Mon, Jul 13, 2026 at 09:34:32AM +0100, Vincent Donnefort wrote:
> On Mon, Jul 13, 2026 at 08:26:35AM +0000, Mostafa Saleh wrote:
> > On Mon, Jul 13, 2026 at 09:11:27AM +0100, Vincent Donnefort wrote:
> > > [...]
> > > 
> > > > >
> > > > > > > I did not add Fixes tag as this is currently dormant and not breaking
> > > > > > > anything.
> > > > > > > ---
> > > > > > >  arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
> > > > > > >  arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
> > > > > > >  arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
> > > > > > >  3 files changed, 8 insertions(+), 8 deletions(-)
> > > > > > >
> > > > > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > > > index 9f429f5c0664..c2ccd0e8bf22 100644
> > > > > > > --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > > > +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > > > @@ -6,11 +6,11 @@
> > > > > > >  #include <asm/kvm_hyp.h>
> > > > > > >
> > > > > > >  #ifdef CONFIG_NVHE_EL2_TRACING
> > > > > > > -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > > > > > > -u64 trace_clock(void);
> > > > > > > +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > > > > > > +u64 hyp_trace_clock(void);
> > > > > >
> > > > > > hyp_trace_clock overlaps the host side: arch/arm64/kvm/hyp_trace.c
> > > > > > already has a struct hyp_trace_clock and static helpers
> > > > > > hyp_trace_clock_enable() / hyp_trace_clock_show() for the debugfs view
> > > > > > of the same clock. No actual collision, so this is only a readability
> > > > > > point, but a reader grepping hyp_trace_clock now gets two unrelated
> > > > > > things. Maybe you'd want to consider a different name, but naming is
> > > > > > hard :)
> > > 
> > > If we were to rename: the clock is a "hyp_clock" so probably trace_hyp_clock()
> > > is the right thing here.
> > > 
> > > while the "hyp_trace_" is the prefix for hyp_trace.c file content.
> > > 
> > > Although I would like to see why we pull trace_clock() from the kernel into EL2.
> > > That bit sounds wrong and if we have a way around perhaps that's better?
> > 
> > Most include path look like this:
> > In file included from ./include/linux/ftrace.h:11,
> >                  from ./include/linux/kprobes.h:28,
> >                  from ./include/linux/kgdb.h:17,
> >                  from ./arch/arm64/include/asm/cacheflush.h:11,
> >                  from ./include/linux/cacheflush.h:5,
> >                  from ./include/linux/highmem.h:8,
> >                  from ./include/linux/bvec.h:10,
> >                  from ./include/linux/blk_types.h:10,
> >                  from ./include/linux/writeback.h:13,
> >                  from ./include/linux/memcontrol.h:23,
> >                  from ./include/linux/resume_user_mode.h:8,
> >                  from ./include/linux/entry-virt.h:6,
> >                  from ./include/linux/kvm_host.h:5,
> > 
> > Although, some files have ./arch/arm64/include/asm/cacheflush.h
> > directly.
> 
> Ha sad, no way around that... 
> 
> So about trace_hyp_clock() / trace_hyp_clock_update() ?
> 

Makes sense, I will respin with that.

Thanks,
Mostafa

