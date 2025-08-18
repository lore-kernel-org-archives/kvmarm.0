Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8D1256C89
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755530739; cv=none; b=gF5nln7KBvLfRBakorozVUbXaky3tWkJOqX+I+MBv21v+NxVqIJKhherpTgRC1UsxkrHnKs8nXxu+M6pdvjK1vSCNyOIPfJwB/ZnceSb7gVHyl4SqG1364vUL9fyxu7NvhSGWlyCFHc7QnEn4hPEsnqqnY35aqy7C+8bxJrouf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755530739; c=relaxed/simple;
	bh=cQQ74RqI0oi17iisfFPsBnqCiIujEhsD/7CJ215Qn5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tdk5ZBZiKoNkshCLHPo8wn6+XZjmhrbBNsmO1L1lf+41UnWg0ecI8QANN+bq6APqggW8TBd/seyYDyoiWJjZfgmIH2zcQsu/Zk05+wofK5j+KvHTm6q/NV6q5TC140ydO2AWFaVvcNsMws5x8kWvsggaU6rIdaatRz65swJ8KHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a+NpuiLE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a+NpuiLE"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e6b1deso3883044a91.3
        for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 08:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755530736; x=1756135536; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CsoYx/ZJm+dL7FRV6jyG7YgqbQ7bK3pBhdAAvFLAFxA=;
        b=a+NpuiLEk6Btbskx4rNZBgLp131SSEjNdXxqbYBO/3Ocwn6UcBVhCcogwd+CqLu35t
         DdP2ZuEEa+kAgmiPo3D50eWdobE/t/vqVQrZp9x4WDyODyd82cqg57jy0p31JbaXHAhY
         qsIBL/VIjDknwXjjYwhxOjpWK6SJfq2sN9iwjzg+e9t5he+5HhZd8DyagLHHefVzhNnk
         iUxoHoVjE+Ztf34I15I/WriUotEISMDV4/3PfleUrIZN+MfiIBjxdd44qStoITOMuyPe
         FXPvyMFBYkwsZn3Xe0mRVT5Ka8YPAQ25aVHby9qdqAy+AaZmu/yM6IuIFErX7V7yBeD9
         JF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755530736; x=1756135536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CsoYx/ZJm+dL7FRV6jyG7YgqbQ7bK3pBhdAAvFLAFxA=;
        b=Y44pUVKi+s9KAkZghiARFm9F0xd/Wtm7OLa7PvDZQeWSOdrj1JFTC0iI9ktQYOqY04
         gN1mULAfAzodC5aYx1xTrwq6lh0ZRRKue6YI6Sx74mBxYJa2egXasDUs7Ihduq72Y1fr
         KzL6AzhczNLZZ7Uep9hPJTcv3Wh/yOGVjkoHmQO/CH2caE7bTNyYkDLbBVxSz2IWGLE0
         s3xM155/s3k531Eg6RtgJ8bUQAtPfOxliz4FOoHbRX9vJnZjEDp2mf5PbUrxnStOK3Vi
         CrFe3nHjKntbho09/8Bk+UByAFRiVz82g/43W0yIC1oZqRmwNPN7NEv3btz1xaofnYgR
         5cWQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8fByyVO5hlW6/qgPlk7GEr5H0307cpA5ioVudetgFPHKb7jqu9QKSCKf0ZukiI5FMP4hEX2E=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqIq45TZ9Uh2ts05bDNPKscp7m5CTvBgz9xHVm8a5yuEQq8kLs
	YSQL+3CCx5D4A7/Fm1Fdak/oIsM5KzELd4t/5OzeZN6cr+aXKVkyEZWFKzp12TFFPZqX1+d23vs
	rUNrAKg==
X-Google-Smtp-Source: AGHT+IFCmpj8FbJmK1+JWLBztlT6f28DkrWlTFsNjoSajBRjHfMiKFT/6+vAkpnb7u9ULN6Oz/FIAv/3KBU=
X-Received: from pjee5.prod.google.com ([2002:a17:90b:5785:b0:311:ef56:7694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52c6:b0:31e:f3b7:49c6
 with SMTP id 98e67ed59e1d1-323421b64b7mr17300718a91.15.1755530736134; Mon, 18
 Aug 2025 08:25:36 -0700 (PDT)
Date: Mon, 18 Aug 2025 08:25:34 -0700
In-Reply-To: <20250818143204.GH3289052@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-10-seanjc@google.com>
 <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
 <aJ9VQH87ytkWf1dH@google.com> <aJ9YbZTJAg66IiVh@google.com> <20250818143204.GH3289052@noisy.programming.kicks-ass.net>
Message-ID: <aKNF7jc4qr9ab-Es@google.com>
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

On Mon, Aug 18, 2025, Peter Zijlstra wrote:
> On Fri, Aug 15, 2025 at 08:55:25AM -0700, Sean Christopherson wrote:
> > On Fri, Aug 15, 2025, Sean Christopherson wrote:
> > > On Fri, Aug 15, 2025, Peter Zijlstra wrote:
> > > > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > > > index e1df3c3bfc0d..ad22b182762e 100644
> > > > > --- a/kernel/events/core.c
> > > > > +++ b/kernel/events/core.c
> > > > > @@ -6408,6 +6408,8 @@ void perf_load_guest_context(unsigned long data)
> > > > >  		task_ctx_sched_out(cpuctx->task_ctx, NULL, EVENT_GUEST);
> > > > >  	}
> > > > >  
> > > > > +	arch_perf_load_guest_context(data);
> > > > 
> > > > So I still don't understand why this ever needs to reach the generic
> > > > code. x86 pmu driver and x86 kvm can surely sort this out inside of x86,
> > > > no?
> > > 
> > > It's definitely possible to handle this entirely within x86, I just don't love
> > > switching the LVTPC without the protection of perf_ctx_lock and perf_ctx_disable().
> > > It's not a sticking point for me if you strongly prefer something like this: 
> > > 
> > > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > > index 0e5048ae86fa..86b81c217b97 100644
> > > --- a/arch/x86/kvm/pmu.c
> > > +++ b/arch/x86/kvm/pmu.c
> > > @@ -1319,7 +1319,9 @@ void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu)
> > >  
> > >         lockdep_assert_irqs_disabled();
> > >  
> > > -       perf_load_guest_context(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
> > > +       perf_load_guest_context();
> > > +
> > > +       perf_load_guest_lvtpc(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
> > 
> > Hmm, an argument for providing a dedicated perf_load_guest_lvtpc() APIs is that
> > it would allow KVM to handle LVTPC writes in KVM's VM-Exit fastpath, i.e. without
> > having to do a full put+reload of the guest context.
> > 
> > So if we're confident that switching the host LVTPC outside of
> > perf_{load,put}_guest_context() is functionally safe, I'm a-ok with it.
> 
> Let me see. So the hardware sets Masked when it raises the interrupt.
> 
> The interrupt handler clears it from software -- depending on uarch in 3
> different places:
>  1) right at the start of the PMI
>  2) in the middle, right before enabling the PMU (writing global control)
>  3) at the end of the PMI
> 
> the various changelogs adding that code mention spurious PMIs and
> malformed PEBS records.
> 
> So the fun all happens when the guest is doing PMI and gets a VM-exit
> while still Masked.
> 
> At that point, we can come in and completely rewrite the PMU state,
> reroute the PMI and enable things again. Then later, we 'restore' the
> PMU state, re-set LVTPC masked to the guest interrupt and 'resume'.
> 
> What could possibly go wrong :/ Kan, I'm assuming, but not knowing, that
> writing all the PMU MSRs is somehow serializing state sufficient to not
> cause the above mentioned fails? Specifically, clearing PEBS_ENABLE
> should inhibit those malformed PEBS records or something? What if the
> host also has PEBS and we don't actually clear the bit?
> 
> The current order ensures we rewrite LVTPC when global control is unset;
> I think we want to keep that.

Yes, for sure.

> While staring at this, I note that perf_load_guest_context() will clear
> global ctrl, clear all the counter programming, and re-enable an empty
> pmu. Now, an empty PMU should result in global control being zero --
> there is nothing run after all.
> 
> But then kvm_mediated_pmu_load() writes an explicit 0 again. Perhaps
> replace this with asserting it is 0 instead?

Yeah, I like that idea, a lot.  This?

	perf_load_guest_context();

	/*
	 * Sanity check that "loading" guest context disabled all counters, as
	 * modifying the LVTPC while host perf is active will cause explosions,
	 * as will loading event selectors and PMCs with guest values.
	 *
	 * VMX will enable/disable counters at VM-Enter/VM-Exit by atomically
	 * loading PERF_GLOBAL_CONTROL.  SVM effectively performs the switch by
	 * configuring all events to be GUEST_ONLY.
	 */
	WARN_ON_ONCE(rdmsrq(kvm_pmu_ops.PERF_GLOBAL_CTRL));

	perf_load_guest_lvtpc(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));

> Anyway, this means that moving the LVTPC writing into
> kvm_mediated_pmu_load() as you suggest is identical.
> perf_load_guest_context() results in global control being 0, we then
> assert it is 0, and write LVTPC while it is still 0.
> kvm_pmu_load_guest_pmcs() will then frob the MSRs.
> 
> OK, so *IF* doing the VM-exit during PMI is sound, this is something
> that needs a comment somewhere. 

I'm a bit lost here.  Are you essentially asking if it's ok to take a VM-Exit
while the guest is handling a PMI?  If so, that _has_ to work, because there are
myriad things that can/will trigger a VM-Exit at any point while the guest is
active.

> Then going back again, is the easy part, since on the host side, we can never
> transition into KVM during a PMI.
