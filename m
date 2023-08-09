Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FD5613F
	for <kvmarm@lists.linux.dev>; Wed,  9 Aug 2023 09:22:42 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49989D75;
	Wed,  9 Aug 2023 02:23:22 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.3.120])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 455C53F59C;
	Wed,  9 Aug 2023 02:22:36 -0700 (PDT)
Date: Wed, 9 Aug 2023 10:22:25 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Huang Shijie <shijie@os.amperecomputing.com>, maz@kernel.org,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
	peterz@infradead.org, ingo@redhat.com, acme@kernel.org,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	namhyung@kernel.org, irogers@google.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org, patches@amperecomputing.com,
	zwang@amperecomputing.com
Subject: Re: [PATCH] perf/core: fix the bug in the event multiplexing
Message-ID: <ZNNa0abhS53cMNcK@FVFF77S0Q05N>
References: <20230809013953.7692-1-shijie@os.amperecomputing.com>
 <ZNNNY3MlokEIj4y8@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNNNY3MlokEIj4y8@linux.dev>

On Wed, Aug 09, 2023 at 08:25:07AM +0000, Oliver Upton wrote:
> Hi Huang,
> 
> On Wed, Aug 09, 2023 at 09:39:53AM +0800, Huang Shijie wrote:
> > 2.) Root cause.
> > 	There is only 7 counters in my arm64 platform:
> > 	  (one cycle counter) + (6 normal counters)
> > 
> > 	In 1.3 above, we will use 10 event counters.
> > 	Since we only have 7 counters, the perf core will trigger
> >        	event multiplexing in hrtimer:
> > 	     merge_sched_in() -->perf_mux_hrtimer_restart() -->
> > 	     perf_rotate_context().
> > 
> >        In the perf_rotate_context(), it does not restore some PMU registers
> >        as context_switch() does.  In context_switch():
> >              kvm_sched_in()  --> kvm_vcpu_pmu_restore_guest()
> >              kvm_sched_out() --> kvm_vcpu_pmu_restore_host()
> > 
> >        So we got wrong result.
> 
> This is a rather vague description of the problem. AFAICT, the
> issue here is on VHE systems we wind up getting the EL0 count
> enable/disable bits backwards when entering the guest, which is
> corroborated by the data you have below.

Yep; IIUC the issue here is that when we take an IRQ from a guest and reprogram
the PMU in the IRQ handler, the IRQ handler will program the PMU with
appropriate host/guest/user/etc filters for a *host* context, and then we'll
return back into the guest without reconfigurign the event filtering for a
*guest* context.

That can happen for perf_rotate_context(), or when we install an event into a
running context, as that'll happen via an IPI.

> > +void arch_perf_rotate_pmu_set(void)
> > +{
> > +	if (is_guest())
> > +		kvm_vcpu_pmu_restore_guest(NULL);
> > +	else
> > +		kvm_vcpu_pmu_restore_host(NULL);
> > +}
> > +
> 
> This sort of hook is rather nasty, and I'd strongly prefer a solution
> that's confined to KVM. I don't think the !is_guest() branch is
> necessary at all. Regardless of how the pmu context is changed, we need
> to go through vcpu_put() before getting back out to userspace.
> 
> We can check for a running vCPU (ick) from kvm_set_pmu_events() and either
> do the EL0 bit flip there or make a request on the vCPU to call
> kvm_vcpu_pmu_restore_guest() immediately before reentering the guest.
> I'm slightly leaning towards the latter, unless anyone has a better idea
> here.

The latter sounds reasonable to me.

I suspect we need to take special care here to make sure we leave *all* events
in a good state when re-entering the guest or if we get to kvm_sched_out()
after *removing* an event via an IPI -- it'd be easy to mess either case up and
leave some events in a bad state.

Thanks,
Mark.
