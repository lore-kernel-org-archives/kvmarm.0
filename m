Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694592BEC45
	for <kvmarm@lists.linux.dev>; Fri, 15 Aug 2025 15:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755273328; cv=none; b=cojky2XuxfcfnSX+39rJUnzoAeOPA8wvaq13BkqEqekqR1IwFKrnZ29BXp2Vmhy7mTQyxbUVUgyaE2BLTQ/m+rjVyT9NZLbycF9g6amzOMqf4Vx+ebQEBUqNjc3Dv4mZ6vF6XsTkfs66IoNScz9AVbTMePsukGvbIra+3W3Iozg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755273328; c=relaxed/simple;
	bh=wGA20jXRveGy5A3RdSltG8Mhq+1vci/NEVKX+vkU7E8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kl7dQ6JVqn7DhK9ZjfXYQlNc6QDABG04Sckix8cIYLBF6rzth+sU5/7437vY0c0HdL+db5e7tUsvT2Kohy480Rh/cUnTmWQflD7/82920VwjBSIHdF9/Oo2ZtGU8n3oaNkei0tSXSCBDYYZIXcXe21fzS7BU1XHoSulBZigWLhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LfmbF7lQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LfmbF7lQ"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326bed374so1973841a91.2
        for <kvmarm@lists.linux.dev>; Fri, 15 Aug 2025 08:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755273327; x=1755878127; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z7Sa/kyYZ4LkgwyCX9rJEJ7u8HAAn0SslzIHQ/FhmRM=;
        b=LfmbF7lQV2w7cbg3TVWW3DnlOf5WsjUPjoXfpS2PXvg+erG8hAk8v1aVw3kpx8ViUL
         8zuAOK2FG9iTE+mGomAv9V4gZ5qugLIKHTGkQYn5QDvR3DMXAa3+4cF3I683yJoKuQ0q
         WdS+KkQfiSQ9IG6cG9G5vx44IJFTmJkuYUWP+2WcQLXRPMMYS/ihWOMzLkUMcQ/GKKvE
         d8wSZKJYyUXvkXSJbtcg9v5Ky4TeGwgvXRG4ZfcjPed3CYOqyGVr+21lAdRfDWIu8gfi
         Lp1eTvj94Eef//FSoD/uUaDmcCOJFksna+xV8M8xlZe4xtEDeRC+dair6Ameyc0v7viD
         mBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755273327; x=1755878127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z7Sa/kyYZ4LkgwyCX9rJEJ7u8HAAn0SslzIHQ/FhmRM=;
        b=jiJWqbrp6wW0lF+9nGrD1t7HG0XGCHTVgpuIN+BJr2GYyeVFdLjOCYM5nCvCSxp8DZ
         6F+2fu2OrT8Msvc7ylP7hMVXrMx2aB4crkWyl+F0g0MAq8DQ60i5G8p7s5bdJ0HEk119
         in77dCjdj6bPMwqSnv29rZBcsXZbvkZTOvW0E3prFWTI3KcXqH8eR7oXQsWuZjER0se2
         r/KaPnL2+x64UhUWrI0H1i7iVUuwibGgOAbfH/GaDmMwq7iLaSwQZvvVzZLwCGT1lBIz
         Np4mCHdQwni481O/8esUPktqZlF/frIbo820W3+CVYqlmz7bwdvmVir5O50cqlsUBhVm
         7I6w==
X-Forwarded-Encrypted: i=1; AJvYcCXMcDFGgOiBJcUyO7crdqll7JJoEJHOiJoBR5aIr/nQGTu82D+m44ADjB4ndmzNAno7ptmzZMk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPGjZsizLH44ZD5iiIeJ2zbaDqNhM4uWkWz+9eox7NuX9sTiu8
	NjHs8WIbUJDS3v+fzYYCKHPVBbQ5AKBAS8wRyIZcc3wXcc4UqupGNWM5007QCzkpqsL7M2ttDrR
	2btXbzw==
X-Google-Smtp-Source: AGHT+IEdU+o+jxQRQjpxYUV2M2swV17WB5j94o9nqbjzzuHzapwMPWAh/lqVZpiY/Ko0sm3v0aaj/KNyHyA=
X-Received: from pjbpl10.prod.google.com ([2002:a17:90b:268a:b0:321:370d:cae5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec86:b0:313:dcf4:37bc
 with SMTP id 98e67ed59e1d1-323421229eamr3334693a91.34.1755273326710; Fri, 15
 Aug 2025 08:55:26 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:55:25 -0700
In-Reply-To: <aJ9VQH87ytkWf1dH@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-10-seanjc@google.com>
 <20250815113951.GC4067720@noisy.programming.kicks-ass.net> <aJ9VQH87ytkWf1dH@google.com>
Message-ID: <aJ9YbZTJAg66IiVh@google.com>
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

On Fri, Aug 15, 2025, Sean Christopherson wrote:
> On Fri, Aug 15, 2025, Peter Zijlstra wrote:
> > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > index e1df3c3bfc0d..ad22b182762e 100644
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -6408,6 +6408,8 @@ void perf_load_guest_context(unsigned long data)
> > >  		task_ctx_sched_out(cpuctx->task_ctx, NULL, EVENT_GUEST);
> > >  	}
> > >  
> > > +	arch_perf_load_guest_context(data);
> > 
> > So I still don't understand why this ever needs to reach the generic
> > code. x86 pmu driver and x86 kvm can surely sort this out inside of x86,
> > no?
> 
> It's definitely possible to handle this entirely within x86, I just don't love
> switching the LVTPC without the protection of perf_ctx_lock and perf_ctx_disable().
> It's not a sticking point for me if you strongly prefer something like this: 
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 0e5048ae86fa..86b81c217b97 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -1319,7 +1319,9 @@ void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu)
>  
>         lockdep_assert_irqs_disabled();
>  
> -       perf_load_guest_context(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
> +       perf_load_guest_context();
> +
> +       perf_load_guest_lvtpc(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));

Hmm, an argument for providing a dedicated perf_load_guest_lvtpc() APIs is that
it would allow KVM to handle LVTPC writes in KVM's VM-Exit fastpath, i.e. without
having to do a full put+reload of the guest context.

So if we're confident that switching the host LVTPC outside of
perf_{load,put}_guest_context() is functionally safe, I'm a-ok with it.

>         /*
>          * Disable all counters before loading event selectors and PMCs so that
> @@ -1380,5 +1382,7 @@ void kvm_mediated_pmu_put(struct kvm_vcpu *vcpu)
>  
>         kvm_pmu_put_guest_pmcs(vcpu);
>  
> +       perf_put_guest_lvtpc();
> +
>         perf_put_guest_context();
>  }
> 
