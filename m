Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BB219AA68
	for <kvmarm@lists.linux.dev>; Thu,  5 Sep 2024 13:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725541475; cv=none; b=NmqmKeHSjf5K7B/7dA6U4GIlcgj1TKco77lcYeGhaGPxcO0PphnBxNTjdOEBuLjyTOo7ZKgLJIax4z368LRhHOlMBpWiC5gSj9dvzYX5akClCgFnZ7fuy+MOoQeEALpP2H6e9Qu1xZJwfMftlqa7uoX/kYZIqqyrSqsy6l5zMr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725541475; c=relaxed/simple;
	bh=z9YAtd99+C5SYjdXi+a7Jz1ywaePUfg3hR4CCPPcJPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bmy/zXuOvjAFjpihTWznWqZhwShFy/uIfica0LK+xNAN5NQKLQCGdgrrWJ78o4IgAf6Y42FfPLsowb8+zVlU1RzeQwkx7/mW/B9Q5VTJ1VX80StMA77YNURtMYOhHQ7WBmk6FMZ8Mpv7od90aa0I4ETMTyASMEg+nFwFgtnNLps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZUR1afhC; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZUR1afhC"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42bbd16fcf2so6241705e9.2
        for <kvmarm@lists.linux.dev>; Thu, 05 Sep 2024 06:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725541472; x=1726146272; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F5ewrjlY/YGTCs4PB8tvo6Mk73EOm5sgUJrafW81wFI=;
        b=ZUR1afhCe74JdpGf5CX1+THhCEEMCvdC/buyQubevOQEaUan+Cabfsy/5Q1Ka2/mpU
         c/S7DGCeGc51Q5vRqeMYWNck5CV6Vl6J161GVj3y5+Rf+HLlrWxbulRRHeezpy4lbsL+
         HsDrYFTVAA6OIE2nZJdBCUxafzP9lXv6yQyEwHBaKojUnXWeM9S1sqmUYZg/ePAtzxAV
         H83bjwA+UYvHcAkpofiwlSXOl3C5dYot0tnVJRueerBXm1OS0ZVfv/OXlodBGpoQHBNX
         L6qn3dZOjwwEG/aq333Pj8SQfSLPAxYRY3XaHR66jbHh/3+YhgJsN9aY3KvS0WyX75NX
         4VIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725541472; x=1726146272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F5ewrjlY/YGTCs4PB8tvo6Mk73EOm5sgUJrafW81wFI=;
        b=ivwt/exwe6L0Dp+xamrOLuKo0i3tQ+ET57l4Zst7yKf/Aj6AfVRm3aRWf8sL7sECeS
         /86qreipEbBuiLHMvi0dWJ/VAzm3nLBLSeFE+ZE1q+IFv6RuGeRYUS28Nlj3q+/7S6JB
         dFAT1StfgHuFLX3Np3OfItF17D3X1uUHprjbvQffTm4ywU40rUYGiaOSRvrJPPYT4vEC
         WfYk2zbsBio2pNXANEgk4RFfsbHbJg6xvDQbPsKrovyZEr3/oZMjF5rtNYBdA2e3OKMB
         Oitf4oRKcCu2s3JS82Wg21JEFEo6lLZr2JYx7DcnPn3st1TxH2bfWEEStRVOmPasYee/
         mxcA==
X-Forwarded-Encrypted: i=1; AJvYcCVdM6uUyR6yeBACnix4k+I8UuoKCvYO0yJEtMXxa+dbdc8sOuounZDv+2GS24Od4gVDFqO9vAA=@lists.linux.dev
X-Gm-Message-State: AOJu0YycNQm0Za+7/dtu16rmbN2ksx1GBH+rGU+gxJAbdKkuHwrtW3BY
	JiXQ53R2/2lLkz9/0mPwYOhxvyYiKJwhKPD4AqeAANyEf8gc7mKx20eW7nnIXg91AU/x/HDzKr4
	k5g==
X-Google-Smtp-Source: AGHT+IH3MH64rkQaleCh2by3sP+UrUKUdqiRYBD5N6IDWnMC5Ldv+a1Yn13fvP80Kw2DonCwpr4DXw==
X-Received: by 2002:adf:9c1a:0:b0:368:5ba0:622 with SMTP id ffacd0b85a97d-3749b57f3cbmr14609300f8f.44.1725541469791;
        Thu, 05 Sep 2024 06:04:29 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374c554f0c2sm12819351f8f.43.2024.09.05.06.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 06:04:29 -0700 (PDT)
Date: Thu, 5 Sep 2024 14:04:25 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org, oliver.upton@linux.dev,
	kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com,
	kernel-team@android.com
Subject: Re: [RFC PATCH 04/11] timekeeping: Export the boot clock in snapshots
Message-ID: <ZtmsWedSRbTCEbQ-@google.com>
References: <20240805173234.3542917-1-vdonnefort@google.com>
 <20240805173234.3542917-5-vdonnefort@google.com>
 <865xrsyl6p.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865xrsyl6p.wl-maz@kernel.org>

On Thu, Aug 22, 2024 at 10:13:34AM +0100, Marc Zyngier wrote:
> On Mon, 05 Aug 2024 18:32:27 +0100,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > On arm64 systems, the arch timer can be accessible by both EL1 and EL2.
> > This means when running with nVHE or protected KVM, it is easy to
> > generate clock values from the hypervisor, synchronized with the kernel.
> 
> When you say "arch_timer" here, are you talking about the data
> structure describing the timer? Or about the actual *counter*, a
> system register provided by the HW?
> 
> I'm not sure the architecture-specific details are massively relevant,
> given that this is an arch-agnostic change.

I meant the counter but happy to drop this entire paragraph and just keep the
following one!

> 
> >
> > For tracing purpose, the boot clock is interesting as it doesn't stop on
> > suspend. Export it as part of the time snapshot. This will later allow
> > the hypervisor to add boot clock timestamps to its events.
> 
> Isn't that the actual description of the change? By getting the boot
> time as well as the parameters to compute an increment, you allow any
> subsystem able to perform a snapshot to compute a delta from boot time
> as long as they have access to the counter source.
> 
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> > index fc12a9ba2c88..0fc6a61d64bd 100644
> > --- a/include/linux/timekeeping.h
> > +++ b/include/linux/timekeeping.h
> > @@ -275,18 +275,24 @@ struct ktime_timestamps {
> >   *				 counter value
> >   * @cycles:	Clocksource counter value to produce the system times
> >   * @real:	Realtime system time
> > + * @boot:	Boot time
> >   * @raw:	Monotonic raw system time
> >   * @cs_id:	Clocksource ID
> >   * @clock_was_set_seq:	The sequence number of clock-was-set events
> >   * @cs_was_changed_seq:	The sequence number of clocksource change events
> > + * @mono_shift:	The monotonic clock slope shift
> > + * @mono_mult:	The monotonic clock slope mult
> >   */
> >  struct system_time_snapshot {
> >  	u64			cycles;
> >  	ktime_t			real;
> > +	ktime_t			boot;
> >  	ktime_t			raw;
> >  	enum clocksource_ids	cs_id;
> >  	unsigned int		clock_was_set_seq;
> >  	u8			cs_was_changed_seq;
> > +	u32			mono_shift;
> > +	u32			mono_mult;
> >  };
> >  
> >  /**
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index 2fa87dcfeda9..6d0488a555a7 100644
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -1057,9 +1057,11 @@ noinstr time64_t __ktime_get_real_seconds(void)
> >  void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
> >  {
> >  	struct timekeeper *tk = &tk_core.timekeeper;
> > +	u32 mono_mult, mono_shift;
> >  	unsigned int seq;
> >  	ktime_t base_raw;
> >  	ktime_t base_real;
> > +	ktime_t base_boot;
> >  	u64 nsec_raw;
> >  	u64 nsec_real;
> >  	u64 now;
> > @@ -1074,14 +1076,21 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
> >  		systime_snapshot->clock_was_set_seq = tk->clock_was_set_seq;
> >  		base_real = ktime_add(tk->tkr_mono.base,
> >  				      tk_core.timekeeper.offs_real);
> > +		base_boot = ktime_add(tk->tkr_mono.base,
> > +				      tk_core.timekeeper.offs_boot);
> >  		base_raw = tk->tkr_raw.base;
> >  		nsec_real = timekeeping_cycles_to_ns(&tk->tkr_mono, now);
> >  		nsec_raw  = timekeeping_cycles_to_ns(&tk->tkr_raw, now);
> > +		mono_mult = tk->tkr_mono.mult;
> > +		mono_shift = tk->tkr_mono.shift;
> >  	} while (read_seqcount_retry(&tk_core.seq, seq));
> >  
> >  	systime_snapshot->cycles = now;
> >  	systime_snapshot->real = ktime_add_ns(base_real, nsec_real);
> > +	systime_snapshot->boot = ktime_add_ns(base_boot, nsec_real);
> >  	systime_snapshot->raw = ktime_add_ns(base_raw, nsec_raw);
> > +	systime_snapshot->mono_shift = mono_shift;
> > +	systime_snapshot->mono_mult = mono_mult;
> >  }
> >  EXPORT_SYMBOL_GPL(ktime_get_snapshot);
> >  
> 
> This looks good to me, but you should probably Cc the timekeeping
> maintainers (tglx, John Stultz, and Stephen Boyd).

Yep, my bad!

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
