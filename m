Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9CE156CF
	for <kvmarm@lists.linux.dev>; Mon, 16 Sep 2024 12:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726490360; cv=none; b=mQhklSWl0wKcYjS7aQWqIge5y9HoxvPTmUBJzcHUiV/M9fAN6eA1m72Lc47Ct6+f2ZzKlIvHBOpUOYENKgTkhLsqT7YOwO9qZcg9HVTmmns1gkM38Vy1f+ljxApVP0uTXLQjc0doeZIbgJO4OQlvD9JwoLsZJEJRXXn0uKRh6/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726490360; c=relaxed/simple;
	bh=RZkKybt20BrFAMvkBvu8gcqvGmwdfqgMDLPcU+OPREs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hMGutpNh2/tyU1iyncpXdI3GoNrZn+M86joMuNyYoKcIA0h9sUgLe75O2yBZ5HX0syUunmlgTG1YgDbTZWeFjzM+9+VqH3QZZoS7xKKJky4zyJWQeaovbeWGN5DB/sfnhRZHzTTFO26FFC0+Ghtb4mNRMbItVls+lRADilK1sys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2rEV4iHZ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2rEV4iHZ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42cb9a0c300so37628205e9.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Sep 2024 05:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726490356; x=1727095156; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dxWchoWn22rdAe/2dB1cdrVrt6OnsXWFBRvbrcWerg8=;
        b=2rEV4iHZQ+EPKmXXgzk9/VHkTyr3K1FjAT+698rccVtiLFIo6F/eZ1aoYGwGGBcMRZ
         4RocPgT4AEsTS59QGrsn6Hm7g72L+xVMinFjGxroaSAc583XQqYj4a2KsIYx7GQlOQMd
         8PdiMpSyhTlxjQyVEoRep40F1As5vIAxQVdHIt/QObNVEnFSIhlpaCup1rfA8sKwJBBG
         KfCxd93BaSCZA/FxIax0NxvAult/tW6fq0Jubyd5TpduA1/nJTVBtbAQK3PgtPnLyAc4
         +cqS2ObbBeOlOUvDY2KBmKbtql6becCeNeKAHnSNahk7qiRieKCP1z4ZD7d4rxogKhA7
         2RHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726490356; x=1727095156;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dxWchoWn22rdAe/2dB1cdrVrt6OnsXWFBRvbrcWerg8=;
        b=xJDkGwj2DioiXmMFeSeCdokA0azeJ3HdDti4OpZCVt6IyXWFfb3LfdBCDIknju2z9s
         tE7uilbGHZ46FsRxM2ZnhxOlMrEKrs3eoMVVhqpltzLpCX0R/l/J1WeLWGQG5ciWS9Vm
         EGt3s1pH6+ZMo+gkTHnjwVI71C5vdd0ahgZBPjzshg+Ks5eG6xxuVH9UEo52Y7BDuuHF
         GUSGOlSidS3bhhr7Id5pjLUiXjYeJuEmKjIrXlsHP8pO4Z24MlevESTGGeayvUHPkHxR
         W288YylpJ2EvqW/nPAiilEh0nheB3d67gKBIhf2mBRL9pAK5PSm5e73JjqxLfXA3AypS
         Se1A==
X-Forwarded-Encrypted: i=1; AJvYcCUAjluCvtrDwsE+HB+eEL5cqmzniHdgzi6h5Gj0DaGpNpcj9ysAwqJQuX+voyD1JaxTLf+N1oY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3iiqWG4xdCDcIb+ytERh1Kf7W8hTVq2lKnDfTbmxX9aECQut7
	2kL7C/MSsbs3RB4wqZVheflUp0MsFHeQ3MRp/vwqbLmlzHnO+Jcrht7GygUmEQ==
X-Google-Smtp-Source: AGHT+IFQMybW3PX0qI+sz8J2Ss9CRF+75CADSBG6Hly78QAjV2aOvJ2n6gpbAy2/S/tFK1yOGYBOvw==
X-Received: by 2002:a05:600c:1c91:b0:42c:bd5a:945b with SMTP id 5b1f17b1804b1-42cdb53f8aemr110146165e9.21.1726490355612;
        Mon, 16 Sep 2024 05:39:15 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42d9b1947e2sm113668245e9.44.2024.09.16.05.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 05:39:15 -0700 (PDT)
Date: Mon, 16 Sep 2024 13:39:11 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: John Stultz <jstultz@google.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
	qperret@google.com, kernel-team@android.com,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Stephen Boyd <sboyd@kernel.org>,
	"Christopher S. Hall" <christopher.s.hall@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
Subject: Re: [PATCH 09/13] KVM: arm64: Add clock for hyp tracefs
Message-ID: <Zugm77Z47-kal5rf@google.com>
References: <20240911093029.3279154-1-vdonnefort@google.com>
 <20240911093029.3279154-10-vdonnefort@google.com>
 <CANDhNCqvwn7W8JgdzY=2PrEk0unm3E0Kso7h2CCZBPO+hzLaOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANDhNCqvwn7W8JgdzY=2PrEk0unm3E0Kso7h2CCZBPO+hzLaOw@mail.gmail.com>

On Fri, Sep 13, 2024 at 04:21:05PM -0700, 'John Stultz' via kernel-team wrote:
> On Wed, Sep 11, 2024 at 2:31 AM Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > Configure the hypervisor tracing clock before starting tracing. For
> > tracing purpose, the boot clock is interesting as it doesn't stop on
> > suspend. However, it is corrected on a regular basis, which implies we
> > need to re-evaluate it every once in a while.
> >
> > Cc: John Stultz <jstultz@google.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Cc: Christopher S. Hall <christopher.s.hall@intel.com>
> > Cc: Richard Cochran <richardcochran@gmail.com>
> > Cc: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> ...
> > +static void __hyp_clock_work(struct work_struct *work)
> > +{
> > +       struct delayed_work *dwork = to_delayed_work(work);
> > +       struct hyp_trace_buffer *hyp_buffer;
> > +       struct hyp_trace_clock *hyp_clock;
> > +       struct system_time_snapshot snap;
> > +       u64 rate, delta_cycles;
> > +       u64 boot, delta_boot;
> > +       u64 err = 0;
> > +
> > +       hyp_clock = container_of(dwork, struct hyp_trace_clock, work);
> > +       hyp_buffer = container_of(hyp_clock, struct hyp_trace_buffer, clock);
> > +
> > +       ktime_get_snapshot(&snap);
> > +       boot = ktime_to_ns(snap.boot);
> > +
> > +       delta_boot = boot - hyp_clock->boot;
> > +       delta_cycles = snap.cycles - hyp_clock->cycles;
> > +
> > +       /* Compare hyp clock with the kernel boot clock */
> > +       if (hyp_clock->mult) {
> > +               u64 cur = delta_cycles;
> > +
> > +               cur *= hyp_clock->mult;
> 
> Mult overflow protection (I see you already have a max_delta value) is
> probably needed here.

That should never happen really with the max_delta. But I could add a WARN_ON
and fallback to a 128-bits compute instead here too? 
> 
> > +               cur >>= hyp_clock->shift;
> > +               cur += hyp_clock->boot;
> > +
> > +               err = abs_diff(cur, boot);
> > +
> > +               /* No deviation, only update epoch if necessary */
> > +               if (!err) {
> > +                       if (delta_cycles >= hyp_clock->max_delta)
> > +                               goto update_hyp;
> > +
> > +                       goto resched;
> > +               }
> > +
> > +               /* Warn if the error is above tracing precision (1us) */
> > +               if (hyp_buffer->tracing_on && err > NSEC_PER_USEC)
> > +                       pr_warn_ratelimited("hyp trace clock off by %lluus\n",
> > +                                           err / NSEC_PER_USEC);
> 
> I'm curious in practice, does this come up often? If so, does it
> converge down nicely? Have you done much disruption testing using
> adjtimex?

So far, I haven't seen any error above ~100 ns on the machine I have tested
with, but that's a good point, I'll check how it looks when the boot clock is
less stable.

> 
> > +       }
> > +
> > +       if (delta_boot > U32_MAX) {
> > +               do_div(delta_boot, NSEC_PER_SEC);
> > +               rate = delta_cycles;
> > +       } else {
> > +               rate = delta_cycles * NSEC_PER_SEC;
> > +       }
> > +
> > +       do_div(rate, delta_boot);
> > +
> > +       clocks_calc_mult_shift(&hyp_clock->mult, &hyp_clock->shift,
> > +                              rate, NSEC_PER_SEC, CLOCK_MAX_CONVERSION_S);
> > +
> > +update_hyp:
> > +       hyp_clock->max_delta = (U64_MAX / hyp_clock->mult) >> 1;
> > +       hyp_clock->cycles = snap.cycles;
> > +       hyp_clock->boot = boot;
> > +       kvm_call_hyp_nvhe(__pkvm_update_clock_tracing, hyp_clock->mult,
> > +                         hyp_clock->shift, hyp_clock->boot, hyp_clock->cycles);
> > +       complete(&hyp_clock->ready);
> 
> I'm very forgetful, so maybe it's unnecessary, but for future-you or
> just other's like me, it might be worth adding some extra comments to
> clarify the assumptions in these calculations.

Ack.

> 
> 
> thanks
> -john

Thanks for your time!

-- 
Vincent
