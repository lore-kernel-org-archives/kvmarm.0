Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5B827FB34
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 12:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769170344; cv=none; b=dGWSFZFDo9Oz7mdhul15HVa8OQ9m/5jLAGMh1qU9vvw6STbcE5fJLOFV1GNpY0q1cLIFSCEdUrZ1dY0vD80HahqdaoUKKoZeVUS3juNyrJ/fZuQm2GIIprgdy7s2M0gxowHvAYC7z7fAB8l4yiGwySxLpBYGSQ2HYZ7AYY3D5KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769170344; c=relaxed/simple;
	bh=mJnGfSnNZnYvNd/hH7XFW2DTHO9jL/r2IVbPDgGEdck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0Tr9gYkvLEp99YrUUStJO050grrF3IF3lO5HDW8fE8aXYMQjAJ4+8Ru2d+wcQ8W1rN2mwlPuuR5dkR2TAmywg362UmDOTG8Q8qskt0/bofLpsgFxCbTne7fxZSc10wfu6laNTFbotekuUWoEKZ30lFkrFQzL2TUXqto5ZA33zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YKxtRN9P; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YKxtRN9P"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48049955f7fso15809495e9.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 04:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769170340; x=1769775140; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mJfSzpptsvgNQ0mCpYmk8DIXrBhJMmuZV4W80Mdql0g=;
        b=YKxtRN9PdM4pS1OidiSBirfOglDC3YfEiPgigd/Ge/YOprfnC8QlZrNSFmAtaWaruN
         3EUo/FIFUg+RBRxyv4PwjCZaiBwdKIXR0mzusC2tQAMeFKl5WqCHoSToYSZ4gFTeheZX
         13cp/QKGJpDnxccPZXR+2PqNks+H9RcPmipeqjiorkxhBjNbWlnSWebVqteODG1GE/ER
         zO/EZxdjlZ25MFmsIF/VvSoZRUDZQmwGQxJuvSAZ6xwIDsHL2WJo+wiLiAnHf9/lFk28
         61ptjqKPsayqJLnpiu0HFU5q8ARRj65MWvz1h0DdvsA+hBeNPmDPHdsJl/xY6tkXnNaq
         OhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769170340; x=1769775140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJfSzpptsvgNQ0mCpYmk8DIXrBhJMmuZV4W80Mdql0g=;
        b=jzqIp4uG8fJG0w4TYYaqfvAECYGM5w2JxpYwaS9jii6awsEa8VR5gzYZy0IZwVy8gi
         K9HHGskw8oBr9T0AsZBXyICnosEUqeZrjLfNlGIs0gg/rSnsLIf/nXQIjFeVfs39b/HS
         HInj7je1JBKi9tyKnVz47gnPahtlNyWJp9s4cyL89xcUjlteg+A/7nDeI6xIp4enrzyK
         FAyEZ4m6sJna1cxmLUtKYrUtlOJ/XqMtLCLZh0MjeFfHS8P/3ivtzrpNhhbhelOwgRhY
         DrHvL8bQ7VrJ5Lqgor1RI/YAGihta5OTeRB5rtFs5X07CsuyKp7h0RSvmD1YW72SRCEf
         B0mA==
X-Forwarded-Encrypted: i=1; AJvYcCUgEU63UIxI7HOQ8mOhqIPmvmUOWi19j7YZxlCtseYc5RYcLiRR21ZQveO+cCVzfg70y4LT3mk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7HHEAkKdT0AhvnLL3U5vetvS34nmvQuEkfI3LyMLHCRdpA+k4
	3iTJIqtIweLMCmcuyqSgJCR59LBTaz1bwM45o8frOUq1DtsMpbdkLEJaU0RVOcjrBQ==
X-Gm-Gg: AZuq6aIKbbomENf6BzlUF/atNF7WBdt/tLveL54IzQ/Od62bI/2VpE576qIPY+nv5A1
	i+5j/YJDJRcBKYTbNhyy7z3/Eez9tcaSTTkxQO/Q5oKIPA3lFhVmU0C1ULFQeWSYB0swvUwW9Zq
	o7LJG7WmrVThy+OcJGWd/CN6obm8H/ZQFeyqqUMOmwPmkysixkPuwvEDst1WHQGgjNobDqp7rQu
	J2OhK2ZUdj+GGWxorRTARgdyL6dR7JUI8B4JQqF+KudCQNISWpwDD7IBXOMgOQO699KATQOgwvm
	Z1V/5yRFiczR+/xgjZF6MzNlNEqriZ11jmzovkVMASNHFzeAqloNZiN4XbvXF3NFU6atooV5qIA
	E/HFlCLItwv20wKqTSKKgEqUBrZLUbMniVzCQD14TB2ekYywnwiYPHCes3dXR3McFkdlzG1JvcP
	qENqygFAMXlUUcvwxAvlflfb4Zj6gpszCJroVenpIQCLgV2FT1tw==
X-Received: by 2002:a05:600c:5253:b0:47a:8154:33e3 with SMTP id 5b1f17b1804b1-48051256401mr19426385e9.28.1769170339674;
        Fri, 23 Jan 2026 04:12:19 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804d8a5b67sm47732645e9.10.2026.01.23.04.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 04:12:19 -0800 (PST)
Date: Fri, 23 Jan 2026 12:12:15 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Stephen Boyd <sboyd@kernel.org>,
	"Christopher S. Hall" <christopher.s.hall@intel.com>,
	Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v9 25/30] KVM: arm64: Sync boot clock with the nVHE/pKVM
 hyp
Message-ID: <aXNln7dzZzf-iGGI@google.com>
References: <20251202093623.2337860-1-vdonnefort@google.com>
 <20251202093623.2337860-26-vdonnefort@google.com>
 <86bjj5mrhn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bjj5mrhn.wl-maz@kernel.org>

On Wed, Jan 07, 2026 at 02:23:16PM +0000, Marc Zyngier wrote:
> On Tue, 02 Dec 2025 09:36:18 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > Configure the hypervisor tracing clock with the kernel boot clock. For
> > tracing purposes, the boot clock is interesting: it doesn't stop on
> > suspend. However, it is corrected on a regular basis, which implies the
> > need to re-evaluate it every once in a while.
> > 
> > Cc: John Stultz <jstultz@google.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Cc: Christopher S. Hall <christopher.s.hall@intel.com>
> > Cc: Richard Cochran <richardcochran@gmail.com>
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index f83650a7aad9..375607c67285 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -93,6 +93,7 @@ enum __kvm_host_smccc_func {
> >  	__KVM_HOST_SMCCC_FUNC___tracing_unload,
> >  	__KVM_HOST_SMCCC_FUNC___tracing_enable,
> >  	__KVM_HOST_SMCCC_FUNC___tracing_swap_reader,
> > +	__KVM_HOST_SMCCC_FUNC___tracing_update_clock,
> >  };
> >  
> >  #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > index 7da8788ce527..fd641e1b1c23 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
> > @@ -11,6 +11,7 @@ int __tracing_load(unsigned long desc_va, size_t desc_size);
> >  void __tracing_unload(void);
> >  int __tracing_enable(bool enable);
> >  int __tracing_swap_reader(unsigned int cpu);
> > +void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> >  #else
> >  static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
> >  static inline void tracing_commit_entry(void) { }
> > @@ -19,5 +20,6 @@ static inline int __tracing_load(unsigned long desc_va, size_t desc_size) { retu
> >  static inline void __tracing_unload(void) { }
> >  static inline int __tracing_enable(bool enable) { return -ENODEV; }
> >  static inline int __tracing_swap_reader(unsigned int cpu) { return -ENODEV; }
> > +static inline void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
> >  #endif
> >  #endif
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 8b78b29c2069..45b8f70828de 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -613,6 +613,18 @@ static void handle___tracing_swap_reader(struct kvm_cpu_context *host_ctxt)
> >  	cpu_reg(host_ctxt, 1) = __tracing_swap_reader(cpu);
> >  }
> >  
> > +static void handle___tracing_update_clock(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	DECLARE_REG(u32, mult, host_ctxt, 1);
> > +	DECLARE_REG(u32, shift, host_ctxt, 2);
> > +	DECLARE_REG(u64, epoch_ns, host_ctxt, 3);
> > +	DECLARE_REG(u64, epoch_cyc, host_ctxt, 4);
> > +
> > +	__tracing_update_clock(mult, shift, epoch_ns, epoch_cyc);
> > +
> > +	cpu_reg(host_ctxt, 1) = 0;
> 
> What's the purpose of setting X1 to 0? This is a call returning void,
> so I don't immediately see the need for this.

Hum, nope nothing. And actually the same applies to __tracing_write_event() and
__tracing_unload()

> 
> > +}
> > +
> >  typedef void (*hcall_t)(struct kvm_cpu_context *);
> >  
> >  #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
> > @@ -658,6 +670,7 @@ static const hcall_t host_hcall[] = {
> >  	HANDLE_FUNC(__tracing_unload),
> >  	HANDLE_FUNC(__tracing_enable),
> >  	HANDLE_FUNC(__tracing_swap_reader),
> > +	HANDLE_FUNC(__tracing_update_clock),
> >  };
> >  
> >  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
> > index df9d66fcb3c9..97e9f6c1a52c 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/trace.c
> > @@ -271,3 +271,19 @@ int __tracing_swap_reader(unsigned int cpu)
> >  
> >  	return ret;
> >  }
> > +
> > +void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
> > +{
> > +	int cpu;
> > +
> > +	/* After this loop, all CPUs are observing the new bank... */
> > +	for (cpu = 0; cpu < hyp_nr_cpus; cpu++) {
> > +		struct simple_rb_per_cpu *simple_rb = per_cpu_ptr(trace_buffer.simple_rbs, cpu);
> > +
> > +		while (READ_ONCE(simple_rb->status) == SIMPLE_RB_WRITING)
> > +			;
> > +	}
> > +
> > +	/* ...we can now override the old one and swap. */
> > +	trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
> > +}
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index 2866effe28ec..1e5fc27f0e9d 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
> > @@ -4,15 +4,133 @@
> >   * Author: Vincent Donnefort <vdonnefort@google.com>
> >   */
> >  
> > +#include <linux/cpumask.h>
> >  #include <linux/trace_remote.h>
> > +#include <linux/tracefs.h>
> >  #include <linux/simple_ring_buffer.h>
> >  
> > +#include <asm/arch_timer.h>
> >  #include <asm/kvm_host.h>
> >  #include <asm/kvm_hyptrace.h>
> >  #include <asm/kvm_mmu.h>
> >  
> >  #include "hyp_trace.h"
> >  
> > +/* Same 10min used by clocksource when width is more than 32-bits */
> > +#define CLOCK_MAX_CONVERSION_S	600
> > +/*
> > + * Time to give for the clock init. Long enough to get a good mult/shift
> > + * estimation. Short enough to not delay the tracing start too much.
> > + */
> > +#define CLOCK_INIT_MS		100
> > +/*
> > + * Time between clock checks. Must be small enough to catch clock deviation when
> > + * it is still tiny.
> > + */
> > +#define CLOCK_UPDATE_MS		500
> 
> If these definitions are common, can't we reuse the existing ones?
> Specially given that this isn't EL2 code.

Only the first is reused but it doesn't exist any definition for it.

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
