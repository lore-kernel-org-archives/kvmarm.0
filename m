Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54D21CEABF
	for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 18:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724350407; cv=none; b=NVGVps6IdcKX7IrHQ8slXPM5ogTe6kLisYlHsiJv2kjV8RTO8VqvQjZzTHDWWOBE4GTUiKpZxfYlPMx1OYksC5Egbc8az0C9aioRStM0r4y8FoEFW/ynbqikXsUyIXjg+4JKAakVdCrELHqzywy4DPph2abJTeShSTM1P6fAMxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724350407; c=relaxed/simple;
	bh=7W6AaAuvGbYK5j4uwqemfKmyhu4/qcf4rmyVPrUi8po=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fNGcQArBRnCj67H5GsBp4fe8J+K3YxEGRSY83xAHq/+YGGvK8Ygs3w3SEOe9CU49J4VTViTGbjWAhmuKm1Uoczw+UAFaft6YQnuygS55jDsCAXt3DQGBARd1Ur4OO2ApxC1dt30tE+yypMYb9YaliiY3urW4h63tcFPsWwH6Z7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vbKho2Bc; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vbKho2Bc"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-428f5c0833bso12082425e9.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 11:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724350404; x=1724955204; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/anGTvjJVK/2MoIj/z7y54NxrhSiznN5JcZCeLu05A=;
        b=vbKho2Bcd0TponKes46/ydHVO5bBy8wDBaN4N5xrWXK7MJA5O6ikmbe9kxh/banEhQ
         BBQJhgh90mrKoNdAQEVPpgJR2jwbyF58oTxPQRS4PFadLF9Jm3BeKz2Tx7oQ3dnpxZfd
         0mt5uIlUuITli3xZRK9JKaUmvRxo3nn346KE6Uyi/+2ucoKeVirGnmx4j2yxfuHRCRCt
         XWqbA9/E1BNXsZkThxxmmp+9lje1jSJS/3qCM/KOPtQDsQDyldCvRtEtIJWzlpBhGu4K
         gv8XVvbAjENy9qM5pr5U22uosu/B7en7/8auj4BVVpaagGzfyQeWcS/9e8laNRw8Bo4o
         QRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724350404; x=1724955204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/anGTvjJVK/2MoIj/z7y54NxrhSiznN5JcZCeLu05A=;
        b=lM94aVNU751r96HCrTJM9R//XMG9FExJkrASiPMVt9WC/5l/x/4iGh8uxMp1C9l9ru
         W5J7GktC9YcQrueJLRYTyAEfc4aMWTCqUnnku+pyVHCdfOSG0fUi2VhfR4GWTUDNIPBU
         UBXRXZGneVDeKIn//cr4Z7ofl31LAzVNAFLf9qK+N+spYOmX7rKa6a8yAr5/3tlPtMz8
         9SpRp9i6354TrgRVxsX5bFuJ25Phqk/4azo4tku1G3Kx2ZOW7tNQfEPQBpARcLCcLBUd
         5KdcP1aw/B7RyFHhEeeui48a+V2fNMPbATaP68ljcsWP/dYSYQ5Kg5Ql/jc20QUp/YHY
         LNQw==
X-Forwarded-Encrypted: i=1; AJvYcCXjuiyw2hyo3PzLljvsTCA8V8wIgDb1uF4d9tbZ1mvhzfezIAlQZfuG4/Pp8dLbjtmduCzAq88=@lists.linux.dev
X-Gm-Message-State: AOJu0YxL2sFmJIWurJcDddbfGM8WGrk2j3kN5x8lVjDlzlJpc5Is5+0b
	dnKfOLtZaJaztmIC4ANhIM0BUb70mqg8+oATUYvOuA4XRfMR0zbuClkESu+q93UWXm1J8RKSzYI
	OrMlcnGKLwxDcT+O18XE8U6n9LYbkeXSlioQ=
X-Google-Smtp-Source: AGHT+IGrIgUIJwt0UKI7HXbF269KMJ2021VtmSioDifbs+8lZRKMvAZ7kztHIsKImKLVPEof7MrOkToAtKTzsxe9aI4=
X-Received: by 2002:a5d:68c9:0:b0:371:846d:558d with SMTP id
 ffacd0b85a97d-373052a6d02mr2299460f8f.34.1724350403725; Thu, 22 Aug 2024
 11:13:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240805173234.3542917-1-vdonnefort@google.com> <20240805173234.3542917-5-vdonnefort@google.com>
In-Reply-To: <20240805173234.3542917-5-vdonnefort@google.com>
From: John Stultz <jstultz@google.com>
Date: Thu, 22 Aug 2024 11:13:11 -0700
Message-ID: <CANDhNCoWvBn=h3ENEM9bbJO8LBVh5m=3vw79Bawr3e4NE4UMSQ@mail.gmail.com>
Subject: Re: [RFC PATCH 04/11] timekeeping: Export the boot clock in snapshots
To: Vincent Donnefort <vdonnefort@google.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 5, 2024 at 10:33=E2=80=AFAM 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:
>
> On arm64 systems, the arch timer can be accessible by both EL1 and EL2.
> This means when running with nVHE or protected KVM, it is easy to
> generate clock values from the hypervisor, synchronized with the kernel.
>
> For tracing purpose, the boot clock is interesting as it doesn't stop on
> suspend. Export it as part of the time snapshot. This will later allow
> the hypervisor to add boot clock timestamps to its events.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> index fc12a9ba2c88..0fc6a61d64bd 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -275,18 +275,24 @@ struct ktime_timestamps {
>   *                              counter value
>   * @cycles:    Clocksource counter value to produce the system times
>   * @real:      Realtime system time
> + * @boot:      Boot time

So, adding the boottime to this kernel-internal snapshot seems reasonable t=
o me.

>   * @raw:       Monotonic raw system time
>   * @cs_id:     Clocksource ID
>   * @clock_was_set_seq: The sequence number of clock-was-set events
>   * @cs_was_changed_seq:        The sequence number of clocksource change=
 events
> + * @mono_shift:        The monotonic clock slope shift
> + * @mono_mult: The monotonic clock slope mult


This bit, including the mult/shift pair however, isn't well explained
and is a little more worrying.


> @@ -1074,14 +1076,21 @@ void ktime_get_snapshot(struct system_time_snapsh=
ot *systime_snapshot)
>                 systime_snapshot->clock_was_set_seq =3D tk->clock_was_set=
_seq;
>                 base_real =3D ktime_add(tk->tkr_mono.base,
>                                       tk_core.timekeeper.offs_real);
> +               base_boot =3D ktime_add(tk->tkr_mono.base,
> +                                     tk_core.timekeeper.offs_boot);
>                 base_raw =3D tk->tkr_raw.base;
>                 nsec_real =3D timekeeping_cycles_to_ns(&tk->tkr_mono, now=
);
>                 nsec_raw  =3D timekeeping_cycles_to_ns(&tk->tkr_raw, now)=
;
> +               mono_mult =3D tk->tkr_mono.mult;
> +               mono_shift =3D tk->tkr_mono.shift;
>         } while (read_seqcount_retry(&tk_core.seq, seq));
>
>         systime_snapshot->cycles =3D now;
>         systime_snapshot->real =3D ktime_add_ns(base_real, nsec_real);
> +       systime_snapshot->boot =3D ktime_add_ns(base_boot, nsec_real);
>         systime_snapshot->raw =3D ktime_add_ns(base_raw, nsec_raw);
> +       systime_snapshot->mono_shift =3D mono_shift;
> +       systime_snapshot->mono_mult =3D mono_mult;
>  }
>  EXPORT_SYMBOL_GPL(ktime_get_snapshot);

So this looks like you're trying to stuff kernel timekeeping internal
values into the snapshot so you can skirt around the timekeeping
subsystem and generate your own timestamps.

This ends up duplicating logic, but in an incomplete way.  For
instance, you don't have things like ntp state, etc, so the timestamps
you generate will not exactly match the kernel, and may have
discontinuities. :(

Now for many cases "close enough" is fine. But the difficulty is the
expectation bar always raises, and eventually "close enough" isn't and
we have a broken interface that has to be fixed.

That said, I do get the need to have something like this is
legitimate. There have been a number of cases where external hardware
(PTP timestamps from NICs) or contexts (virt) are able to record
hardware clocksource timestamps on their own, and want to be able to
map that back to the kernel's (or maybe "a kernel's" if there are
multiple VMs) sense of time.  Sometimes even wanting to do this quite
a bit later after the timestamp was recorded. The ktime_get_snapshot()
logic was added in the first place for this reason.

Some more aggressive approaches try to dump a bunch of the internal
kernel timekeeping state out to userland and call it an api.
See https://lore.kernel.org/lkml/410bbef9771ef8aa51704994a70d5965e367e2ce.c=
amel@infradead.org/
for a recent (and thorough) effort there.

I'm very much not a fan of this approach, as it mimics older efforts
for userspace time calculations that were done before we settled on
VDSOs, which were very fragile and required years of keeping backwards
compatibility logic to map the current kernel state back to separate
structures and expensive conversions to different units that userland
expected.

The benefit with VDSO interface is while the data is exposed to
userland, the structure is not, and the logic is still kernel
controlled, so changes to internal state can be done without breaking
userland.

Something I have been thinking about is maybe it would be beneficial
to rework the timekeeping core so that given a clocksource timestamp,
it could calculate the time for that timestamp. While existing apis
would still do a new read of the clocksource, so the timestamps would
always increase, an old timestamp could be used to retro-calculate a
past time.  The thing that prevents this now is that the timekeeping
core doesn't keep any history, so we can't correctly back-calculate
times before the last state change. But potentially we could keep a
buffer of timekeeper states associated with clocksource intervals, and
so we could find the right state to use for a given clocksource
timestamp. Now, this would still only work to a point, as we don't
want to keep tons of historical state.  But then with this, maybe we
could switch to something more VDSO-like where the PTP drivers or host
systems could request a time given a timestamp (and probably some
clocksource id so we can sanity check everyone is using the same
clock), and we could still provide what they want without having to
expose all of our state.

Unfortunately though, this is all hand waving and pontificating on my
part, as it would be a large rework. But it seems something closer
where we share opaque kernel state along with logic with proper
syscall like APIs to do the calculations, would be a much better
approach over just exporting more kernel state as an API.

For a more short term approach, since you can't be exact outside of
the timekeeping logic, why not interpolate from the data
ktime_get_snapshot already provides to calculate your own sense of the
frequency?

thanks
-john
