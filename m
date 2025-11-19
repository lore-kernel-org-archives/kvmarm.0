Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314A728507B
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 21:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763587889; cv=none; b=GSVtsFtQg6ZckDeixfSEmjq3ITamb/FdD73VWwivPZaWWee4ZSYXtaBkX2l/wFa7H9uw0gsf1hmOgnpxOfzyrId9cP3dKIxa3q28z6XOZLfvuYVoLo7WtAfvfe+Op0I1mNQZ9fxMJ2Tu1pdaKwd1/RnQp7leQy2HVD5XmyKRq0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763587889; c=relaxed/simple;
	bh=xnVWHoRf7o0NcxPQfVQjG9xcAOWFFNXm2zL7SdEXGTY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rSKNGWgkEtQ6bXCAVqLG2GzEbTJWZH4dUvIimxntd3yK1m96z3gWSfx2qBxC1K9FJdxGWrQujV2QWfEoipcjNyQGa8p4xaZCqxH8BgbpZDSTP7q4HCX+N4hUWuv9eUUGd1pGUAkzppZ1jq3mW6B1aiTfDZPF9Fsk/+lmHrbHJXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XhCrzZ65; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XhCrzZ65"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-298389232c4so4228355ad.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 13:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763587887; x=1764192687; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tRlBn8hNsoLzEGGI6zV1NxPFQ/eFHCg8PaMSNSKYawI=;
        b=XhCrzZ65y4WSZ8RUnp2TkZts3YMFCE629Dd+ew+JOhKgTlxHoJOG9nAfXCPkBnfodn
         wbcK2HsQRR2YNRSSlDZLwXi8OqMv76rjEFtZcc7H225wJop0ZOM+mVLucVmOJihjUYB3
         lk6gxjt+OaF+tckbD9ijg0ZQH7YWVT98iDFT8hd6IVuL0MHWOQvA87NdGS+H+tC0SsRb
         BNgmcDTwTm2H0+5JZ2ZQ40T/rAU84/TQkeVaR8asRWVdAdqttub5QbD09PgNUmPasw8i
         H9CAgBP4zNZIBy9FOYAlUCR3MRhy/zFhcek9+YaTJc4UoIJ+t4yOmluIVL560TUlCxQG
         8rVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763587887; x=1764192687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRlBn8hNsoLzEGGI6zV1NxPFQ/eFHCg8PaMSNSKYawI=;
        b=Is8P2eCoujpFCfbzR8FzEPnjrfXTmkP+CoJQUCfBAa5KFcB7DfEfSGRhD5X8CgAMxZ
         BKFpWiCrlO6WE2+uklkEVsH/L8Qe0R6qT4/FXipWljsUJ/Zy22q59WM3RMUrP5FPLKyS
         92tQx4iSk7l6ZJ//0Yfun0WAk+lMNxnejqOdIg3wlFF9wAUKU5a6xu0iFYzRfx5j3rYz
         aHunIExB/QvfQ0FZ3VEjs10jRNnO4QvhpHdgx4wRYoG5Ey7KPBO3cQPsfX9dMzAhTALf
         8CCeyb5scv2RoQX+iTj1DaaO8lfoyWRoQYziJVPBRovOHCKTwL/U0CGBVAFiXL6hpzcP
         a2aA==
X-Forwarded-Encrypted: i=1; AJvYcCV9mrWgnbLacUCtw/tEEa1betpLZofH9ayjSjSdsbm9x6U5Xlb7/RXqLzGZvx7J0MolWZC1BsQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1FV9FxvFWfeFxBvnnzPB6GgvGmBn69+7a43SiBTVmcpz3WZFF
	Q/D8eAjktZin/p5EhYNkLH/c1OmowRdPhOAiBuY8iRvUIrmbEH90oaZ3FwggeIhXw09wuhEuD4y
	2KKjZOg==
X-Google-Smtp-Source: AGHT+IEd+gfd++T3e2i6Z4dBj2glGk6LJnNjNrz24WgF1sqa+HmClxx9J2N7UBfKQW53wCFECS0cLQGpQb0=
X-Received: from plot18.prod.google.com ([2002:a17:902:8c92:b0:298:9ac:cfe9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccc7:b0:298:49db:a9c5
 with SMTP id d9443c01a7336-29b5b136462mr7336255ad.43.1763587887332; Wed, 19
 Nov 2025 13:31:27 -0800 (PST)
Date: Wed, 19 Nov 2025 13:31:26 -0800
In-Reply-To: <aKNF7jc4qr9ab-Es@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-10-seanjc@google.com>
 <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
 <aJ9VQH87ytkWf1dH@google.com> <aJ9YbZTJAg66IiVh@google.com>
 <20250818143204.GH3289052@noisy.programming.kicks-ass.net> <aKNF7jc4qr9ab-Es@google.com>
Message-ID: <aR43LoV1ti5-2WRD@google.com>
Subject: Re: [PATCH v5 09/44] perf/x86: Switch LVTPC to/from mediated PMI
 vector on guest load/put context
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 18, 2025, Sean Christopherson wrote:
> On Mon, Aug 18, 2025, Peter Zijlstra wrote:
> > On Fri, Aug 15, 2025 at 08:55:25AM -0700, Sean Christopherson wrote:
> > > On Fri, Aug 15, 2025, Sean Christopherson wrote:
> > > > On Fri, Aug 15, 2025, Peter Zijlstra wrote:
> > > So if we're confident that switching the host LVTPC outside of
> > > perf_{load,put}_guest_context() is functionally safe, I'm a-ok with it.
> > 
> > Let me see. So the hardware sets Masked when it raises the interrupt.
> > 
> > The interrupt handler clears it from software -- depending on uarch in 3
> > different places:
> >  1) right at the start of the PMI
> >  2) in the middle, right before enabling the PMU (writing global control)
> >  3) at the end of the PMI
> > 
> > the various changelogs adding that code mention spurious PMIs and
> > malformed PEBS records.
> > 
> > So the fun all happens when the guest is doing PMI and gets a VM-exit
> > while still Masked.
> > 
> > At that point, we can come in and completely rewrite the PMU state,
> > reroute the PMI and enable things again. Then later, we 'restore' the
> > PMU state, re-set LVTPC masked to the guest interrupt and 'resume'.
> > 
> > What could possibly go wrong :/ Kan, I'm assuming, but not knowing, that
> > writing all the PMU MSRs is somehow serializing state sufficient to not
> > cause the above mentioned fails? Specifically, clearing PEBS_ENABLE
> > should inhibit those malformed PEBS records or something? What if the
> > host also has PEBS and we don't actually clear the bit?
> > 
> > The current order ensures we rewrite LVTPC when global control is unset;
> > I think we want to keep that.
> 
> Yes, for sure.
> 
> > While staring at this, I note that perf_load_guest_context() will clear
> > global ctrl, clear all the counter programming, and re-enable an empty
> > pmu. Now, an empty PMU should result in global control being zero --
> > there is nothing run after all.
> > 
> > But then kvm_mediated_pmu_load() writes an explicit 0 again. Perhaps
> > replace this with asserting it is 0 instead?
> 
> Yeah, I like that idea, a lot.  This?
> 
> 	perf_load_guest_context();
> 
> 	/*
> 	 * Sanity check that "loading" guest context disabled all counters, as
> 	 * modifying the LVTPC while host perf is active will cause explosions,
> 	 * as will loading event selectors and PMCs with guest values.
> 	 *
> 	 * VMX will enable/disable counters at VM-Enter/VM-Exit by atomically
> 	 * loading PERF_GLOBAL_CONTROL.  SVM effectively performs the switch by
> 	 * configuring all events to be GUEST_ONLY.
> 	 */
> 	WARN_ON_ONCE(rdmsrq(kvm_pmu_ops.PERF_GLOBAL_CTRL));

This doesn't actually work, because perf_load_guest_context() doesn't guarantee
PERF_GLOBAL_CTRL is '0', it only guarantees all events are disabled.  E.g. if
there are no perf events, perf_load_guest_context() is one big nop (I think).

And while it might seem reasonable to expect PERF_GLOBAL_CTRL to be '0' if
there are no perf events, that doesn't hold true today.  E.g. amd_pmu_reload_virt()
unconditionally sets all supported MSR_AMD64_PERF_CNTR_GLOBAL_CTL bits.

I'm sure we could massage perf to really truly ensure PERF_GLOBAL_CTRL is '0',
but I don't see any value in explicitly doing that in perf_load_guest_context()
(versus simply doing it in KVM), and I would rather not play whack-a-mole in perf
as part of this series.

So unless someone really, really wants to lean on perf to clear PERF_GLOBAL_CTRL,
I'll go with this:

	/*
	 * Explicitly clear PERF_GLOBAL_CTRL, as "loading" the guest's context
	 * disables all individual counters (if any were enabled), but doesn't
	 * globally disable the entire PMU.  Loading event selectors and PMCs
	 * with guest values while PERF_GLOBAL_CTRL is non-zero will generate
	 * unexpected events and PMIs.
	 *
	 * VMX will enable/disable counters at VM-Enter/VM-Exit by atomically
	 * loading PERF_GLOBAL_CONTROL.  SVM effectively performs the switch by
	 * configuring all events to be GUEST_ONLY.  Clear PERF_GLOBAL_CONTROL
	 * even for SVM to minimize the damage if a perf event is left enabled,
	 * and to ensure a consistent starting state.
	 */
	wrmsrq(kvm_pmu_ops.PERF_GLOBAL_CTRL, 0);
