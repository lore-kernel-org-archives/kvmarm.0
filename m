Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E1319CD19
	for <kvmarm@lists.linux.dev>; Thu,  5 Sep 2024 13:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725542271; cv=none; b=FnTIOvdL7VTIKOzxnEMLRM09+4kMBGIdkI41pf2OjCC55DrLugAiSrVZp0ZJiVv680kDJdaM9pNj9KuepQ+9wa+F042657B/WTpbKozU7zIO8RwuAAx2tIRjzW8m+oCDhmUJQRwK+EW/9uMNRXPeuzG5azZpuafzwwlMx9q1SM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725542271; c=relaxed/simple;
	bh=N+lhla7AWpVoDZUFSHdMZ1wMsrYVkHxx1DbVXn2irUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aoz/PD9wzcvd9NvDpTlKpvfBuWwQWscfKB+bS+FNx/fpPeTT6OsUuysTWBxPXLhRQAKOfaOdSQ1kO5f8/9iGin8+mC2EI9DIvHGHH3sqTtIhZbxq90b2y89SVNGE5sks4j4OiIDcxIexDC3O1EkimVsyFokavYM7fCGNwIQzUzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jfjjMwT6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jfjjMwT6"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42c7bc97423so7987515e9.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Sep 2024 06:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725542268; x=1726147068; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R/vmwgwSPC+1W4S00VKiG7KYIY1ywAU4STVuyexDuv8=;
        b=jfjjMwT6CLBSQ6Z6FfwZsHNcek3/UAMKZthBNOC4eUc7llPBogLjlxVvVe98tPHmdk
         NvkWuITLNq7ahIO+nFhsVWE/ch0cT0ond7382GflBPFMysRRUvevlXHm2K5wtPqf6sYI
         NrO6fQxvBylPQebsmMOrH4EdFjuvcAdm5ZWj8lkDUyLKX9fEhgDiqyQoZTXShcSzXakc
         FlTr88c0SrEEZQ7JZjVHsPjozL0aWiRoOE8NZ3Y8EpZ/EswyVZsu8IJ1kFFBUG3IAICS
         A+G4XGFVfmtR4298ekw3A9+es/v4OrxziQ7G13e63fcuR7mjyn/V746SthoKPchuFy4M
         hKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725542268; x=1726147068;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/vmwgwSPC+1W4S00VKiG7KYIY1ywAU4STVuyexDuv8=;
        b=APHHxwIGKsMJrPJDrTvahzdJYWM0tbHrShDxgnjRd+zvlc5HhP4eYjM4lUv3VtDbr8
         ytrCSrkHsG6VO8Hj4O/VSZ/QyUtHtIOtsaaMsndvXOmTKsVb4eXAVoHE6+Eet9NF6BQW
         LU2+FMzF8gO8M0jzw+st2yA/AO0E9uckD2rDdrnKssg8pirBXuPloer/o4gM3ToKBSYE
         HJ5aTMmLPebitii+A369Fb418OejyurNnH8t/AEna7KDki1GOg8Ct2SSAmn7IINh1M8t
         TVUb+8gTTU4jLE4V8aumY6ylmtR5+5df4JESlRKXI10eLnYBvRaffztHExxpoK67NS8n
         CWOA==
X-Forwarded-Encrypted: i=1; AJvYcCXDI+W+a2XAlSu5v5Mkp6x35afP5QtwuXDC+z4g+PJe1OSiQhqOqLjmJm8g0MdXP+Jt1TRuOcI=@lists.linux.dev
X-Gm-Message-State: AOJu0YycbtjTDUtwB4tY+MAMCTM2vGbcceaQQz8nf6MnXujobGuRWsUN
	7T+9r1RbHfexUS3nwffFUj5b4+zgLZ64gu3d5t8ztrGoKakENBGfsC/W1Ch4Bw==
X-Google-Smtp-Source: AGHT+IHTHn2aXJtsQGJ22gtRmy/fbjOqw/mNiYErEosb3aKkNonpxJLFR7vYaNQtUUpbNxqbOBtE3Q==
X-Received: by 2002:a05:600c:1f92:b0:42a:a6aa:4118 with SMTP id 5b1f17b1804b1-42c9a36cc76mr24977255e9.18.1725542267402;
        Thu, 05 Sep 2024 06:17:47 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6da24bbsm233630715e9.0.2024.09.05.06.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 06:17:46 -0700 (PDT)
Date: Thu, 5 Sep 2024 14:17:42 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: John Stultz <jstultz@google.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
	qperret@google.com, kernel-team@android.com,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 04/11] timekeeping: Export the boot clock in snapshots
Message-ID: <ZtmvdjGwAARUv2yR@google.com>
References: <20240805173234.3542917-1-vdonnefort@google.com>
 <20240805173234.3542917-5-vdonnefort@google.com>
 <CANDhNCoWvBn=h3ENEM9bbJO8LBVh5m=3vw79Bawr3e4NE4UMSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANDhNCoWvBn=h3ENEM9bbJO8LBVh5m=3vw79Bawr3e4NE4UMSQ@mail.gmail.com>

On Thu, Aug 22, 2024 at 11:13:11AM -0700, John Stultz wrote:
> On Mon, Aug 5, 2024 at 10:33 AM 'Vincent Donnefort' via kernel-team
> <kernel-team@android.com> wrote:
> >
> > On arm64 systems, the arch timer can be accessible by both EL1 and EL2.
> > This means when running with nVHE or protected KVM, it is easy to
> > generate clock values from the hypervisor, synchronized with the kernel.
> >
> > For tracing purpose, the boot clock is interesting as it doesn't stop on
> > suspend. Export it as part of the time snapshot. This will later allow
> > the hypervisor to add boot clock timestamps to its events.
> >
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> > diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> > index fc12a9ba2c88..0fc6a61d64bd 100644
> > --- a/include/linux/timekeeping.h
> > +++ b/include/linux/timekeeping.h
> > @@ -275,18 +275,24 @@ struct ktime_timestamps {
> >   *                              counter value
> >   * @cycles:    Clocksource counter value to produce the system times
> >   * @real:      Realtime system time
> > + * @boot:      Boot time
> 
> So, adding the boottime to this kernel-internal snapshot seems reasonable to me.
> 
> >   * @raw:       Monotonic raw system time
> >   * @cs_id:     Clocksource ID
> >   * @clock_was_set_seq: The sequence number of clock-was-set events
> >   * @cs_was_changed_seq:        The sequence number of clocksource change events
> > + * @mono_shift:        The monotonic clock slope shift
> > + * @mono_mult: The monotonic clock slope mult
> 
> 
> This bit, including the mult/shift pair however, isn't well explained
> and is a little more worrying.
> 
> 
> > @@ -1074,14 +1076,21 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
> >                 systime_snapshot->clock_was_set_seq = tk->clock_was_set_seq;
> >                 base_real = ktime_add(tk->tkr_mono.base,
> >                                       tk_core.timekeeper.offs_real);
> > +               base_boot = ktime_add(tk->tkr_mono.base,
> > +                                     tk_core.timekeeper.offs_boot);
> >                 base_raw = tk->tkr_raw.base;
> >                 nsec_real = timekeeping_cycles_to_ns(&tk->tkr_mono, now);
> >                 nsec_raw  = timekeeping_cycles_to_ns(&tk->tkr_raw, now);
> > +               mono_mult = tk->tkr_mono.mult;
> > +               mono_shift = tk->tkr_mono.shift;
> >         } while (read_seqcount_retry(&tk_core.seq, seq));
> >
> >         systime_snapshot->cycles = now;
> >         systime_snapshot->real = ktime_add_ns(base_real, nsec_real);
> > +       systime_snapshot->boot = ktime_add_ns(base_boot, nsec_real);
> >         systime_snapshot->raw = ktime_add_ns(base_raw, nsec_raw);
> > +       systime_snapshot->mono_shift = mono_shift;
> > +       systime_snapshot->mono_mult = mono_mult;
> >  }
> >  EXPORT_SYMBOL_GPL(ktime_get_snapshot);
> 
> So this looks like you're trying to stuff kernel timekeeping internal
> values into the snapshot so you can skirt around the timekeeping
> subsystem and generate your own timestamps.
> 
> This ends up duplicating logic, but in an incomplete way.  For
> instance, you don't have things like ntp state, etc, so the timestamps
> you generate will not exactly match the kernel, and may have
> discontinuities. :(
> 
> Now for many cases "close enough" is fine. But the difficulty is the
> expectation bar always raises, and eventually "close enough" isn't and
> we have a broken interface that has to be fixed.
> 
> That said, I do get the need to have something like this is
> legitimate. There have been a number of cases where external hardware
> (PTP timestamps from NICs) or contexts (virt) are able to record
> hardware clocksource timestamps on their own, and want to be able to
> map that back to the kernel's (or maybe "a kernel's" if there are
> multiple VMs) sense of time.  Sometimes even wanting to do this quite
> a bit later after the timestamp was recorded. The ktime_get_snapshot()
> logic was added in the first place for this reason.
> 
> Some more aggressive approaches try to dump a bunch of the internal
> kernel timekeeping state out to userland and call it an api.
> See https://lore.kernel.org/lkml/410bbef9771ef8aa51704994a70d5965e367e2ce.camel@infradead.org/
> for a recent (and thorough) effort there.
> 
> I'm very much not a fan of this approach, as it mimics older efforts
> for userspace time calculations that were done before we settled on
> VDSOs, which were very fragile and required years of keeping backwards
> compatibility logic to map the current kernel state back to separate
> structures and expensive conversions to different units that userland
> expected.
> 
> The benefit with VDSO interface is while the data is exposed to
> userland, the structure is not, and the logic is still kernel
> controlled, so changes to internal state can be done without breaking
> userland.
> 
> Something I have been thinking about is maybe it would be beneficial
> to rework the timekeeping core so that given a clocksource timestamp,
> it could calculate the time for that timestamp. While existing apis
> would still do a new read of the clocksource, so the timestamps would
> always increase, an old timestamp could be used to retro-calculate a
> past time.  The thing that prevents this now is that the timekeeping
> core doesn't keep any history, so we can't correctly back-calculate
> times before the last state change. But potentially we could keep a
> buffer of timekeeper states associated with clocksource intervals, and
> so we could find the right state to use for a given clocksource
> timestamp. Now, this would still only work to a point, as we don't
> want to keep tons of historical state.  But then with this, maybe we
> could switch to something more VDSO-like where the PTP drivers or host
> systems could request a time given a timestamp (and probably some
> clocksource id so we can sanity check everyone is using the same
> clock), and we could still provide what they want without having to
> expose all of our state.
> 
> Unfortunately though, this is all hand waving and pontificating on my
> part, as it would be a large rework. But it seems something closer
> where we share opaque kernel state along with logic with proper
> syscall like APIs to do the calculations, would be a much better
> approach over just exporting more kernel state as an API.
> 
> For a more short term approach, since you can't be exact outside of
> the timekeeping logic, why not interpolate from the data
> ktime_get_snapshot already provides to calculate your own sense of the
> frequency?

Understood, I shouldn't sneak out mult and shift. So for the following version,
I'll just use the boot clock value and process my "own" mult and "shift".

Thanks for having a look at the change!

> 
> thanks
> -john
