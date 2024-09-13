Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4FE18734B
	for <kvmarm@lists.linux.dev>; Fri, 13 Sep 2024 23:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726269683; cv=none; b=Lz6SPcD/AFcYwow9KieqDYE1eeLfBMJX8Z7I0gHu+dFeJLtQLmnqcVISt13myHoeGXJp5tdwcWo0fnG/UGL/uMIybhP/LOJj7VYBnohoSYwwHqSWeXChx9opHGnfx+AL+VztIDvP/PFlt6kiUbWX6nFIOvJGckey6GicMV0O1Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726269683; c=relaxed/simple;
	bh=fXShCPOpZz52eO91jyJt6+04d4urWyr5XmecZWpUQZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XXx9bpcgDMNJ0lSSJE5qbLbxh2liE/F1skP4j9m6QqYKcWNijYJssZTVRsnm6vXOKu5jrr+tBx6pMaFjo0er6XVjpUeXtoOmJESyr9Ipk0o/xgAfVfK4PHyZBrJ36HfwS8nyVeq9CtrIdfRAshY2kg2wMa6Ko9i6/7RAAfZByHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZM6zpV/Z; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZM6zpV/Z"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8d6ac24a3bso475651866b.1
        for <kvmarm@lists.linux.dev>; Fri, 13 Sep 2024 16:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726269680; x=1726874480; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gHrUsCpR6q/vcDy94msssmKj/tbR9miRFAu8ZGicdg=;
        b=ZM6zpV/ZM8LMtprz/rTPfS3TRVLZil3LTv/8Qj2Nh529Yrt5bWY7ljDL8M5DrmNgkr
         CQUnbGgzapS15OLpIps1gcvwHny4ZrY0CNFdLEidPOk9/4po+lNtx1Tbh69b4fH6xsZO
         is8hGVOBwUD4qqTWsCmRhdOrBGmQXK3iubVJ65eOVJh6Wjv5yub8xREwpkgSgbVMag/J
         sOtR9qBVCkIOBE4DDJ1G5flCa7sR85L0ijiG6MS5G0WH4aG51huYm7hdCPMoe7tMy1Qg
         BvMrNbvhWI0bnu1SGo3REWSSTeOPHl8GMBxGHNCA5RbVcGkhnBoY47eW2A55+0E3QQ2y
         uW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726269680; x=1726874480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5gHrUsCpR6q/vcDy94msssmKj/tbR9miRFAu8ZGicdg=;
        b=jSi5iYytU1u4syoGeuKJV5HKIo0tM1olznkfFixzNA2t4geu0qtpIghe9CwWJVYgVI
         UB+e8EENeY65j9o2jvBRSnmEnSNzrCJKZdtftkzvkARf9inofuLV8ZyRbw1OV3nrfcnc
         nmZmjvbC/bbEDeZrbtIDKYxxCFPSWg5U8D8WiznPsN4h8Onhad+dEQ7F3ZvUowvbyGhS
         OBVAqjurMwkkEE/oSirBMeXe1IxX52/oBvHjq21jE5gGk8RWFgVkX/pvNn7xSv/pMsEA
         WNRLczWnDvykppvZMrGjsuXniBRDNVM65zSrty5NwW1cwqQUVi+kGq6UIwr9YAZE9h+3
         0vyg==
X-Forwarded-Encrypted: i=1; AJvYcCVdM6IAa55LqI+Feuo4RvQBHdZtSQol5MMnrUq/92YAcIGNgPdhey4cP50ANZROsW3WA1tob7k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyR4m1Cbit4tG0vHTAEB4YM66lJaKUXyJP5EXvWeEONqF00Uu2/
	1P/5tn/mAsxRiKNi29EkEcTgEenJpT9RNOMjaypsbeGKNDIuq9hrOM26sfLHCiukFoHQhiEqghf
	qo8nJZLDE5nirjv/fQgOKK51Y4Aw9p651kOx6Er3KWmxBLAXvVcLs1LUb
X-Google-Smtp-Source: AGHT+IGvxiSn6JWS9N9/EAoj59xcTC5zKLV9vZxugR8jrHol8xrwnt7BBpr6nBUOCxwG9AGyWxa1x9nBJUY4B0O9e8k=
X-Received: by 2002:a17:907:1c22:b0:a80:9c1b:554f with SMTP id
 a640c23a62f3a-a902a8c3963mr879630266b.27.1726269678841; Fri, 13 Sep 2024
 16:21:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com> <20240911093029.3279154-10-vdonnefort@google.com>
In-Reply-To: <20240911093029.3279154-10-vdonnefort@google.com>
From: John Stultz <jstultz@google.com>
Date: Fri, 13 Sep 2024 16:21:05 -0700
Message-ID: <CANDhNCqvwn7W8JgdzY=2PrEk0unm3E0Kso7h2CCZBPO+hzLaOw@mail.gmail.com>
Subject: Re: [PATCH 09/13] KVM: arm64: Add clock for hyp tracefs
To: Vincent Donnefort <vdonnefort@google.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@kernel.org>, 
	"Christopher S. Hall" <christopher.s.hall@intel.com>, Richard Cochran <richardcochran@gmail.com>, 
	Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 2:31=E2=80=AFAM Vincent Donnefort <vdonnefort@googl=
e.com> wrote:
>
> Configure the hypervisor tracing clock before starting tracing. For
> tracing purpose, the boot clock is interesting as it doesn't stop on
> suspend. However, it is corrected on a regular basis, which implies we
> need to re-evaluate it every once in a while.
>
> Cc: John Stultz <jstultz@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Christopher S. Hall <christopher.s.hall@intel.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
...
> +static void __hyp_clock_work(struct work_struct *work)
> +{
> +       struct delayed_work *dwork =3D to_delayed_work(work);
> +       struct hyp_trace_buffer *hyp_buffer;
> +       struct hyp_trace_clock *hyp_clock;
> +       struct system_time_snapshot snap;
> +       u64 rate, delta_cycles;
> +       u64 boot, delta_boot;
> +       u64 err =3D 0;
> +
> +       hyp_clock =3D container_of(dwork, struct hyp_trace_clock, work);
> +       hyp_buffer =3D container_of(hyp_clock, struct hyp_trace_buffer, c=
lock);
> +
> +       ktime_get_snapshot(&snap);
> +       boot =3D ktime_to_ns(snap.boot);
> +
> +       delta_boot =3D boot - hyp_clock->boot;
> +       delta_cycles =3D snap.cycles - hyp_clock->cycles;
> +
> +       /* Compare hyp clock with the kernel boot clock */
> +       if (hyp_clock->mult) {
> +               u64 cur =3D delta_cycles;
> +
> +               cur *=3D hyp_clock->mult;

Mult overflow protection (I see you already have a max_delta value) is
probably needed here.

> +               cur >>=3D hyp_clock->shift;
> +               cur +=3D hyp_clock->boot;
> +
> +               err =3D abs_diff(cur, boot);
> +
> +               /* No deviation, only update epoch if necessary */
> +               if (!err) {
> +                       if (delta_cycles >=3D hyp_clock->max_delta)
> +                               goto update_hyp;
> +
> +                       goto resched;
> +               }
> +
> +               /* Warn if the error is above tracing precision (1us) */
> +               if (hyp_buffer->tracing_on && err > NSEC_PER_USEC)
> +                       pr_warn_ratelimited("hyp trace clock off by %lluu=
s\n",
> +                                           err / NSEC_PER_USEC);

I'm curious in practice, does this come up often? If so, does it
converge down nicely? Have you done much disruption testing using
adjtimex?

> +       }
> +
> +       if (delta_boot > U32_MAX) {
> +               do_div(delta_boot, NSEC_PER_SEC);
> +               rate =3D delta_cycles;
> +       } else {
> +               rate =3D delta_cycles * NSEC_PER_SEC;
> +       }
> +
> +       do_div(rate, delta_boot);
> +
> +       clocks_calc_mult_shift(&hyp_clock->mult, &hyp_clock->shift,
> +                              rate, NSEC_PER_SEC, CLOCK_MAX_CONVERSION_S=
);
> +
> +update_hyp:
> +       hyp_clock->max_delta =3D (U64_MAX / hyp_clock->mult) >> 1;
> +       hyp_clock->cycles =3D snap.cycles;
> +       hyp_clock->boot =3D boot;
> +       kvm_call_hyp_nvhe(__pkvm_update_clock_tracing, hyp_clock->mult,
> +                         hyp_clock->shift, hyp_clock->boot, hyp_clock->c=
ycles);
> +       complete(&hyp_clock->ready);

I'm very forgetful, so maybe it's unnecessary, but for future-you or
just other's like me, it might be worth adding some extra comments to
clarify the assumptions in these calculations.


thanks
-john
