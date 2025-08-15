Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB84307488
	for <kvmarm@lists.linux.dev>; Fri, 15 Aug 2025 15:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272515; cv=none; b=cuYT+3B2m2aP/VNwpTF24r0rB1i8CX6IN/4V7TU2lCle71tDABaI5flePlv6uUfH6NKOpDGGQnnDmk6g9VYLW5erz7rLiPgMITS+wNlMKaiufwJQ1EXOnz4zwHGni4NsrQxXqsK6B4+cLbSyXwEx7XAJvbWDNnR9xj8+qJPaoLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272515; c=relaxed/simple;
	bh=V0iQe0wXHiwXgNwjclXLeqc33EIkx7ymZ0WlHmqsCas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kjt1cTUISsFeP5Veq60QBgqmxotnCggOwBQqB6d2EVYkDZLdZ4eXq4j9FZTFZVZsrClKvy04B6SsywJMKEDu6QuXiP/sysI8x4ZCxfFnhy4rkwXqNQDH5c+nd/yj4ZUuSjx9bUuxwVmM8DyzvWAkXpfyk7XHnNmSwMLKLOipvxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sCkcsgms; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sCkcsgms"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e09c5fso2119291a91.2
        for <kvmarm@lists.linux.dev>; Fri, 15 Aug 2025 08:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755272514; x=1755877314; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mZHHNj6EVbfkylJhuGEQxcUJR48ZbvWbqL/aI2BJPfo=;
        b=sCkcsgmsvjVV1KkLeFBm+gVXTVsjTk6/2VCqkwpkdGemY2bw5EbqFm5nmTJ76O/nDf
         GSfRBW87Y3CiEYxKvt2Urw8bZMPx3ro1hSx1j9sBdxMgpxgVnKcKiSYlLH6vhk3IBHab
         l+B9nBgv42Xrmedd+NjH7ArrOFgRHWqRY2TYlaDli33mm1Bgb/o37uh/5wIrS+WexL/w
         QDU5zNfPhrLBM4DhmQI9pf082PNDgvTYeYpufoaKpes0DgLFnsWbz9kz4w72+5ghyTKS
         7bEtID+eX6HhvbE8lYHYtAcPCis08Oy8XNYMH1EsNgQvgSgYuJOQa3pm6UH6DO7nC3ns
         xYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755272514; x=1755877314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZHHNj6EVbfkylJhuGEQxcUJR48ZbvWbqL/aI2BJPfo=;
        b=F7YixJnxrQWrU+MKlS3h1LZMEkaZtxR7AacKgQIlRGCOYX7S+2nwiYwkdhrJ1V1tro
         Tco7/ZPpOkgv5bJ2MuNC7kKikgxfPdwgqjtm2c7/ofAHdej7LmxClXpgwTO5w2wt8hmt
         3fAhRRouqSuyMy1fiCKFEyk9W87HzagEi6ZJNCp6eSvc7jMv9oWkLs6zIdaVYiINhj21
         FPmqqTqSNEt390a88iBs84vvnv5OKlk9JA26Mc9RZBkkA911n4BF0zWCMt/+heeOA51l
         DYoMLbIyuxqadnpzu848EUqF3FOrLIx0lJ7YDwgF0P5rvIy1Eo7EjXD6S483QQ9lOUvV
         CXAA==
X-Forwarded-Encrypted: i=1; AJvYcCU7McMyi71m9pk05wzImSFUBkHWlxmO5ibTrhC8gEWlMXe0Fl5jc5Wu7mzdjDms44OJed7Kn0k=@lists.linux.dev
X-Gm-Message-State: AOJu0YynXpSRu3aXY42G49Dq+/obStEKzxVuHsaXj8iAtDkYJZy6L8wj
	3yBORMBeW/p7WkwHEpLG23JdmHiTf0r1LdsEs4E16HWa5cAfmSe+9IeRJ5skjVofqCq8ypuZopO
	eow2nHw==
X-Google-Smtp-Source: AGHT+IF1xhNBmkTpZib3NykIL4xlxFbGkhXK+/yjF5LGvtuWFmTYgkxBDJw0+uZkCmQyO/RrRqfOrKLRso0=
X-Received: from pjbsd7.prod.google.com ([2002:a17:90b:5147:b0:31e:a094:a39])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5104:b0:31e:4492:af48
 with SMTP id 98e67ed59e1d1-32342238d44mr3660367a91.28.1755272513579; Fri, 15
 Aug 2025 08:41:53 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:41:52 -0700
In-Reply-To: <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-10-seanjc@google.com>
 <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
Message-ID: <aJ9VQH87ytkWf1dH@google.com>
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

On Fri, Aug 15, 2025, Peter Zijlstra wrote:
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index e1df3c3bfc0d..ad22b182762e 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -6408,6 +6408,8 @@ void perf_load_guest_context(unsigned long data)
> >  		task_ctx_sched_out(cpuctx->task_ctx, NULL, EVENT_GUEST);
> >  	}
> >  
> > +	arch_perf_load_guest_context(data);
> 
> So I still don't understand why this ever needs to reach the generic
> code. x86 pmu driver and x86 kvm can surely sort this out inside of x86,
> no?

It's definitely possible to handle this entirely within x86, I just don't love
switching the LVTPC without the protection of perf_ctx_lock and perf_ctx_disable().
It's not a sticking point for me if you strongly prefer something like this: 

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0e5048ae86fa..86b81c217b97 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1319,7 +1319,9 @@ void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu)
 
        lockdep_assert_irqs_disabled();
 
-       perf_load_guest_context(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
+       perf_load_guest_context();
+
+       perf_load_guest_lvtpc(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
 
        /*
         * Disable all counters before loading event selectors and PMCs so that
@@ -1380,5 +1382,7 @@ void kvm_mediated_pmu_put(struct kvm_vcpu *vcpu)
 
        kvm_pmu_put_guest_pmcs(vcpu);
 
+       perf_put_guest_lvtpc();
+
        perf_put_guest_context();
 }

