From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v11 6/8] arm64: KVM: Enable VHE support for :G/:H perf
 event modifiers
Date: Mon, 11 Mar 2019 12:16:22 +0000
Message-ID: <20190311121622.GH10637@e119886-lin.cambridge.arm.com>
References: <20190308120746.56897-1-andrew.murray@arm.com>
 <20190308120746.56897-7-andrew.murray@arm.com>
 <465b5efe-a54d-29ff-cb2e-2a2460c02974@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <465b5efe-a54d-29ff-cb2e-2a2460c02974@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 11, 2019 at 09:39:19AM +0000, Julien Thierry wrote:
> Hi Andrew,
> 
> On 08/03/2019 12:07, Andrew Murray wrote:
> > With VHE different exception levels are used between the host (EL2) and
> > guest (EL1) with a shared exception level for userpace (EL0). We can take
> > advantage of this and use the PMU's exception level filtering to avoid
> > enabling/disabling counters in the world-switch code. Instead we just
> > modify the counter type to include or exclude EL0 at vcpu_{load,put} time.
> > 
> > We also ensure that trapped PMU system register writes do not re-enable
> > EL0 when reconfiguring the backing perf events.
> > 
> > This approach completely avoids blackout windows seen with !VHE.
> > 
> > Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  3 ++
> >  arch/arm64/include/asm/kvm_host.h |  5 +-
> >  arch/arm64/kernel/perf_event.c    |  6 ++-
> >  arch/arm64/kvm/pmu.c              | 87 ++++++++++++++++++++++++++++++-
> >  arch/arm64/kvm/sys_regs.c         |  3 ++
> >  virt/kvm/arm/arm.c                |  2 +
> >  6 files changed, 102 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index a358cb15bb0d..3ce429954306 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -326,6 +326,9 @@ static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
> >  
> > +static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
> > +static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
> > +
> >  static inline void kvm_arm_vhe_guest_enter(void) {}
> >  static inline void kvm_arm_vhe_guest_exit(void) {}
> >  
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 7ca4e094626d..d631528898b5 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -487,7 +487,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
> >  
> >  static inline bool kvm_pmu_counter_defered(struct perf_event_attr *attr)
> >  {
> > -	return attr->exclude_host;
> > +	return (!has_vhe() && attr->exclude_host);
> >  }
> >  
> >  #ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
> > @@ -501,6 +501,9 @@ void kvm_clr_pmu_events(u32 clr);
> >  
> >  void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt);
> >  bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt);
> > +
> > +void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
> > +void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> >  #else
> >  static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
> >  static inline void kvm_clr_pmu_events(u32 clr) {}
> > diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> > index 64f02a9fd7cd..a121a82fc54c 100644
> > --- a/arch/arm64/kernel/perf_event.c
> > +++ b/arch/arm64/kernel/perf_event.c
> > @@ -847,8 +847,12 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
> >  	 * with other architectures (x86 and Power).
> >  	 */
> >  	if (is_kernel_in_hyp_mode()) {
> > -		if (!attr->exclude_kernel)
> > +		if (!attr->exclude_kernel && !attr->exclude_host)
> >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> > +		if (attr->exclude_guest)
> > +			config_base |= ARMV8_PMU_EXCLUDE_EL1;
> > +		if (attr->exclude_host)
> > +			config_base |= ARMV8_PMU_EXCLUDE_EL0;
> >  	} else {
> >  		if (!attr->exclude_hv && !attr->exclude_host)
> >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> > diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> > index a1cee7919953..a0830c70ece5 100644
> > --- a/arch/arm64/kvm/pmu.c
> > +++ b/arch/arm64/kvm/pmu.c
> > @@ -12,11 +12,19 @@
> >  DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
> >  
> >  /*
> > - * Given the exclude_{host,guest} attributes, determine if we are going
> > - * to need to switch counters at guest entry/exit.
> > + * Given the perf event attributes and system type, determine
> > + * if we are going to need to switch counters at guest entry/exit.
> >   */
> >  static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
> >  {
> > +	/**
> > +	 * With VHE the guest kernel runs at EL1 and the host at EL2,
> > +	 * where user (EL0) is excluded then we have no reason to switch
> > +	 * counters.
> > +	 */
> > +	if (has_vhe() && attr->exclude_user)
> > +		return false;
> > +
> >  	/* Only switch if attributes are different */
> >  	return (attr->exclude_host ^ attr->exclude_guest);
> >  }
> > @@ -87,3 +95,78 @@ void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
> >  		write_sysreg(pmu->events_host, pmcntenset_el0);
> >  }
> >  
> > +/*
> > + * Modify ARMv8 PMU events to include EL0 counting
> > + */
> > +static void kvm_vcpu_pmu_enable_el0(unsigned long events)
> > +{
> > +	u64 typer;
> > +	u32 counter;
> > +
> > +	for_each_set_bit(counter, &events, 32) {
> > +		write_sysreg(counter, pmselr_el0);
> > +		isb();
> > +		typer = read_sysreg(pmxevtyper_el0) & ~ARMV8_PMU_EXCLUDE_EL0;
> > +		write_sysreg(typer, pmxevtyper_el0);
> > +		isb();
> > +	}
> > +}
> > +
> > +/*
> > + * Modify ARMv8 PMU events to exclude EL0 counting
> > + */
> > +static void kvm_vcpu_pmu_disable_el0(unsigned long events)
> > +{
> > +	u64 typer;
> > +	u32 counter;
> > +
> > +	for_each_set_bit(counter, &events, 32) {
> > +		write_sysreg(counter, pmselr_el0);
> > +		isb();
> > +		typer = read_sysreg(pmxevtyper_el0) | ARMV8_PMU_EXCLUDE_EL0;
> > +		write_sysreg(typer, pmxevtyper_el0);
> > +		isb();
> > +	}
> > +}
> > +
> > +/*
> > + * On VHE ensure that only guest events have EL0 counting enabled
> > + */
> > +void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpu_context *host_ctxt;
> > +	struct kvm_host_data *host;
> > +	u32 events_guest, events_host;
> > +
> > +	if (!has_vhe())
> > +		return;
> > +
> > +	host_ctxt = vcpu->arch.host_cpu_context;
> > +	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> > +	events_guest = host->pmu_events.events_guest;
> > +	events_host = host->pmu_events.events_host;
> > +
> > +	kvm_vcpu_pmu_enable_el0(events_guest);
> > +	kvm_vcpu_pmu_disable_el0(events_host);
> 
> So, we load a vcpu, and all events common to the guest and the host
> (events_guest & events_host) get the EXCLUDE_EL0 flag set.
> 
> I don't see anything that will remove that flag before running the
> guest. Am I missing something? Should these lines be as follows?
> 
> 	kvm_vcpu_pmu_enable_el0(events_guest & events_host);
> 	kvm_vcpu_pmu_enable_el0(events_guest ^ events_host);
> 

For VHE and !exclude_user, where an event is common to both guest and
host (i.e.  exclude_kernel = exclude_host = 0) then:

 - The event is never deferred (so we always start counting)
 - When we set the event filter at start of day (armv8pmu_set_event_filter)
   we don't exclude EL0.
 - Also we don't add this event to pmu_events due to kvm_pmu_switch_needed
   in kvm_set_pmu_events - so we don't actually do anything here.

I think the logic you were expecting is moved to start of day when the
counter is first created, thus reducing the effort here.

Thanks,

Andrew Murray 


> > +}
> > +
> > +/*
> > + * On VHE ensure that only guest host have EL0 counting enabled
> > + */
> > +void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpu_context *host_ctxt;
> > +	struct kvm_host_data *host;
> > +	u32 events_guest, events_host;
> > +
> > +	if (!has_vhe())
> > +		return;
> > +
> > +	host_ctxt = vcpu->arch.host_cpu_context;
> > +	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> > +	events_guest = host->pmu_events.events_guest;
> > +	events_host = host->pmu_events.events_host;
> > +
> > +	kvm_vcpu_pmu_enable_el0(events_host);
> > +	kvm_vcpu_pmu_disable_el0(events_guest);
> 
> Same question as above, after vcpu_put, it seems we've disabled at EL0
> host events that are common to the guest and the host.
> 
> Thanks,
> 
> -- 
> Julien Thierry
