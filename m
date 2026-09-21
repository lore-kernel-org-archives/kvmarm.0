Received: from mta1.migadu.com (out-235.mta1.migadu.com [95.215.58.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC214AC156
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 15:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790004372; cv=none; b=RMxGqpkmFNsjkW0Mdp7WPSO6KUAAXu/modXxuOGJqZA7BDIlGKjNYlw3vBq0/JQ1TnC813iclglkH9eI4Wc7miL/BuZ42le3nusu5mLTshpnGRWY0oLcmwNM4A3cJSnWFanba/G1B2T7Za8QGljLdn3ClGkoLWqK/Xv+fZ9TJN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790004372; c=relaxed/simple;
	bh=/8RGZVQWUyzs19cUu3Y//9Vj+1op9fq9/ZosbH4mY4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U0q5IBTD1dszAZdcZFZTMPJLPW/1rUWj3HiT/J3/NRc5vxo9lVSZryEiv25d4oqz27Byunl9zIzPudzLycjZYs069BSIzZUuqaZHbVCi6G/Qqwq5PruhZsAYJVnfstT3J4DVpbIf4soYxJz4b86dL+Zxp26AmHvE99QHyRVBB9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mB5AIyBo; arc=none smtp.client-ip=95.215.58.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mB5AIyBo"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=/8RGZVQWUyzs19cUu3Y//9Vj+1op9fq9/ZosbH4mY4I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790004368; v=1; x=1790609168;
 b=mB5AIyBoHdl8O95uCsQ/9MJwakI8UzRx9H+x+TrMIpR55qu8U9BbdhD/v2GxKdkeI8yc/gYi
 rxvzkSTl13R/g8MeRoI/smP+HCn0YRv9lm4zITAuLqTI18KtLbr0wqn7NcoEHUHjgjmQjRour/l
 g5e/Y4O6+7+iwiuagJJVoZco=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d54de683c4b6e667;
	Mon, 21 Sep 2026 15:26:08 +0000
X-Mizu-Trace-ID: d54de683c4b6e667
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b83c1421ecso10457e87.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 08:26:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwQA2Y/oKT3po65U2oxHMDJ63ntVIX745zwEag7BxmVB/BVnDD+jhBYt+BYqLMOLfbQsQVaZwo=@lists.linux.dev
X-Gm-Message-State: AFuF++nKgm2nW7zOVSsaOv3kp27HkKyjq4dwfDsAdNm7BEAydKKb9G5L
	HaaYakPY3hkMGtARHYHshrSr+1pkM+BTB0EiNIUSi/Lhw+ktjU1nTo5yHPqUvpiQDBiUj1NKMq/
	o/VndTm5KdhzfzRyR/gZ0b0eFbFpPHc0l1bhGT7t7
X-Received: by 2002:a05:6512:3c86:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5b8c7eaa535mr194108e87.9.1790004367252; Mon, 21 Sep 2026
 08:26:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260921140427.2211373-1-fuad.tabba@linux.dev>
 <20260921140427.2211373-4-fuad.tabba@linux.dev> <20260921141701.33CFD1F000FF@smtp.kernel.org>
In-Reply-To: <20260921141701.33CFD1F000FF@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 21 Sep 2026 16:25:31 +0100
X-Gmail-Original-Message-ID: <CA+EHjTweK4XJZNaeKKzizReQrP+25jDT08hDkc9+zQoxWu+iYg@mail.gmail.com>
X-Gm-Features: AcwNN1UdQ0NUVS431o0imISYD8tq6CTjYnZ7u83ldsAQHh0Mec-JjbiaaUqj-84
Message-ID: <CA+EHjTweK4XJZNaeKKzizReQrP+25jDT08hDkc9+zQoxWu+iYg@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: selftests: Test a timer set past the
 counter's wrap
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 21 Sept 2026 at 15:17, <sashiko-bot@kernel.org> wrote:
[...]
>
> > +/*
> > + * With the counter at wait_ms, a tval of -(wait_ms + long_wait_ms) puts cval
> > + * within long_wait_ms of the counter's wrap: a deadline further away than the
> > + * counter can reach. Unmasked, so an early ISTATUS shows up as an IRQ.
> > + */
> > +static void test_timers_past_counter_wrap(enum arch_timer timer)
> > +{
> > +     s32 tval = -(s32)msec_to_cycles(test_args.wait_ms + test_args.long_wait_ms);
> > +     int i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
> > +             sleep_method_t sm = sleep_method[i];
> > +
> > +             local_irq_disable();
> > +             set_counter(timer, msec_to_cycles(test_args.wait_ms));
> > +             set_tval_irq(timer, tval, CTL_ENABLE);
>
> [Severity: Medium]
> Could this sequence lead to a flaky test on a loaded host system?

Yes, a stall of more than long_wait_ms between the counter write and
the TVAL write leaves cval below the counter. This should sort it out:

-        s32 tval = -(s32)msec_to_cycles(test_args.wait_ms +
test_args.long_wait_ms);
+        u64 cval = -msec_to_cycles(test_args.long_wait_ms);
[...]
-                set_tval_irq(timer, tval, CTL_ENABLE);
+                set_cval_irq(timer, cval, CTL_ENABLE);

Cheers,
/fuad
