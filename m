Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B114329C68
	for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764090500; cv=none; b=ePVITcneRhi9+eI0PgIA4EB1T7Vld+sw55KbYZ0Q2PkvZQAt7IZzsRpeVMimABb8wNWqs9xmGSaXURBOj0SitxQ6FkOm3g6RuGnKUPZpB3DAL0JmaAEbz6G3UFapdZCejf4DEyyNXQgaG97M21ZzMupE7C2uu62u8/FiwpdDgVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764090500; c=relaxed/simple;
	bh=Ws/YNKakph/oNkC8T2Z0oK5lQ8Qe0+L4yEIQYy1pOV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R3TjgTs1eihXV4LbaYFXTwwM/kylU4GpsxSiQ+g2I1KKq+IWmbNJcH4ucMBC6mk8RabWxdxHlCec61LssMFn+cr9RvfJZC3UTlJqhMO0JZ9+FVnSEz/lclex8GE1iqDze4x+KS+hI5eO+d9HW/vaKbkRUpS+EaZSSLjM+EeVNk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sXDkyVmM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sXDkyVmM"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343806688cbso13898934a91.3
        for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 09:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764090498; x=1764695298; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y4ndUQJXblyMVIEo31GQ2aPBJsTj4kLS2trQiSNmxdk=;
        b=sXDkyVmMU8r0kFFns6m95FHmKeidG/MDhOQfEKZ9CnEBka1vPyAO1G3GGSd1XEgFQ3
         U0XxiU5TMQn4B4c06HCzEbbQnyeDU/bFwOpRANVPjUv2E1npXV3mgvEfNZ+ss9zVAvmY
         nT8E8cPP3pI2am+ztS9OiMNYYc4TxQHCa1sWyW4AEiUN1SaEkw+5R6Joa4SFUllVbai+
         i5FyR9b0PLRUCKcLzsM18Zmbh9RhjXyru7wnj+HmvatXCbN04C3X7Gheba9l8aIN1bQe
         8g7jfyEmDff99mFbybsh01sYRv1M18cBYLDjnnzWQspcudSZ4rhcxyu5jmCmDZYe6tEq
         +PIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764090498; x=1764695298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4ndUQJXblyMVIEo31GQ2aPBJsTj4kLS2trQiSNmxdk=;
        b=NjzMz5LczJJM7T0E8UCJ2YvG4wpH8vUT+B1rLySx18Hw4b1TQWaUG4Kw/AsTETR+a7
         JNfEPStnPQ1dD8wK/+XY5Upo1FIuudSuNmHA1/4fXGkOQuF43/FEhdhnZjbcZPT8JoKv
         MEoJIfWiR3IrTVQT1lFM5TmILI0TN3OKur0sfJcI2UWcvGuG2nyvG8HOtFhZuYJFQg9c
         dKzvSKaZStLPZjmGZOHygf6WKfA28NpxKAWu1tT2ZqxUTLxIo8/Dz+Jvp+3LSgInK+q5
         2YciyZOkVVi1ZzCm0QnZZAKymC2yz/MZmDm3zKHcdNXtFafUxJJTcOELTfYyoF8F78U8
         HPZw==
X-Forwarded-Encrypted: i=1; AJvYcCXxt3Fdce6ZcthX4Nu204BsRW2L9kaePmSczsg97k4xCQESvrZEByX3rJgowgqZ5sPhumIodLw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyEGQDIlv+UhZuX4sLNfEjGe6uvUkD+FjvvGeAvTEDX1AfoBZ8I
	5yQLJsidvfg0BcKQt2+oKbnxjDvCqU7PGm0d+fwp2k59qM49TxBqMCvFMG2P1nFuEEZTQuOjIiv
	usUcG0Q==
X-Google-Smtp-Source: AGHT+IFzDAUOZTDNFOssfEjC4490DRPTOVZZ7CJwR5gD19Yg3yMCKcUxEwLwt1d5WA+HAajf5nh9jS9CJiQ=
X-Received: from pjbpw1.prod.google.com ([2002:a17:90b:2781:b0:33b:c211:1fa9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384f:b0:341:8c8e:38b5
 with SMTP id 98e67ed59e1d1-34733f3e483mr14061440a91.25.1764090498218; Tue, 25
 Nov 2025 09:08:18 -0800 (PST)
Date: Tue, 25 Nov 2025 09:08:16 -0800
In-Reply-To: <83067602-325a-4655-a1b7-e6bd6a31eed4@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-29-seanjc@google.com>
 <aSUK8FuWT4lpMP3F@google.com> <83067602-325a-4655-a1b7-e6bd6a31eed4@linux.intel.com>
Message-ID: <aSXigAQznhuxZmy7@google.com>
Subject: Re: [PATCH v5 28/44] KVM: x86/pmu: Load/save GLOBAL_CTRL via
 entry/exit fields for mediated PMU
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 25, 2025, Dapeng Mi wrote:
> On 11/25/2025 9:48 AM, Sean Christopherson wrote:
> >> +	if (host_pmu->version < 4 || !(host_perf_cap & PERF_CAP_FW_WRITES))
> >> +		return false;
> >> +
> >> +	/*
> >> +	 * All CPUs that support a mediated PMU are expected to support loading
> >> +	 * and saving PERF_GLOBAL_CTRL via dedicated VMCS fields.
> >> +	 */
> >> +	if (WARN_ON_ONCE(!cpu_has_load_perf_global_ctrl() ||
> >> +			 !cpu_has_save_perf_global_ctrl()))
> >> +		return false;
> > And so this WARN fires due to cpu_has_save_perf_global_ctrl() being false.  The
> > bad changelog is mine, but the code isn't entirely my fault.  I did suggest the
> > WARN in v3[1], probably because I forgot when PMU v4 was introduced and no one
> > corrected me.
> >
> > v4 of the series[2] then made cpu_has_save_perf_global_ctrl() a hard requirement,
> > based on my miguided feedback.
> >
> >    * Only support GLOBAL_CTRL save/restore with VMCS exec_ctrl, drop the MSR
> >      save/retore list support for GLOBAL_CTRL, thus the support of mediated
> >      vPMU is constrained to SapphireRapids and later CPUs on Intel side.
> >
> > Doubly frustrating is that this was discussed in the original RFC, where Jim
> > pointed out[3] that requiring VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL would prevent
> > enabling the mediated PMU on Skylake+, and I completely forgot that conversation
> > by the time v3 of the series rolled around :-(
> 
> VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL is introduced from SPR and later. I
> remember the original requirements includes to support Skylake and Icelake,
> but I ever thought there were some offline sync and the requirement changed...

Two things:

 1) Upstream's "requirements" are not the same as Google's requirements (or those
    of any company/individual).  Upstream most definitely is influenced by the
    needs and desires of end users, but ultimately the decision to do something
    (or not) is one that needs to be made by the upstream community.

 2) Decisions made off-list need to be summarized and communicated on-list,
    especially in cases like this where it's a relatively minor detail in a
    large series/feature, and thus easy to overlook.

I'll follow-up internally to make sure these points are well-understood by Google
folks as well (at least, those working on KVM).

> My bad,

Eh, this was a group "effort".  I'm as much to blame as anyone else.

> I should double confirm this at then.

No need, as above, Google's requirements (assuming the requirements you're referring
to are coming from Google people) are effectively just one data point.  At this
point, I want to drive the decision to support Sylake+ (or not) purely through
discussion of upstream patches.

> > As mentioned in the discussion with Jim, _if_ PMU v4 was introduced with ICX (or
> > later), then I'd be in favor of making VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL a hard
> > requirement.  But losing supporting Skylake+ is a bit much.
> >
> > There are a few warts with nVMX's use of the auto-store list that need to be
> > cleaned up, but on the plus side it's also a good excuse to clean up
> > {add,clear}_atomic_switch_msr(), which have accumulated some cruft and quite a
> > bit of duplicate code.  And while I still dislike using the auto-store list, the
> > code isn't as ugly as it was back in v3 because we _can_ make the "load" VMCS
> > controls mandatory without losing support for any CPUs (they predate PMU v4).
> 
> Yes, xxx_atomic_switch_msr() helpers need to be cleaned up and optimized. I
> suppose we can have an independent patch-set to clean up and support
> global_ctrl with auto-store list for Skylake and Icelake.

I have the code written (I wanted to see how much complexity it would add before
re-opening this discussion).  My plan is to put the Skylake+ support at the end
of the series, not a separate series, so that it can be reviewed in one shot.
E.g. if we can make a change in the "main" series that would simplify Skylake+
support, then I'd prefer to find and implement any such change right away.
