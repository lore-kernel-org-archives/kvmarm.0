From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 25/26] KVM: arm/arm64: GICv4: Prevent heterogenous systems from using GICv4
Date: Fri, 27 Oct 2017 09:31:12 +0100
Message-ID: <86mv4d9elr.fsf@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
        <20171006153401.5481-26-marc.zyngier@arm.com>
        <20171026154839.ebtmqzcy7jjyejul@salmiak> <868tfxaxiv.fsf@arm.com>
        <20171027073728.taejncafoehkfzuc@salmiak> <86r2tp9g2s.fsf@arm.com>
        <20171027080421.m3ruegg6liflcvro@salmiak>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171027080421.m3ruegg6liflcvro@salmiak> (Mark Rutland's message
        of "Fri, 27 Oct 2017 09:04:21 +0100")
Sender: kvm-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27 2017 at  9:04:21 am BST, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Oct 27, 2017 at 08:59:23AM +0100, Marc Zyngier wrote:
>> On Fri, Oct 27 2017 at  8:37:28 am BST, Mark Rutland <mark.rutland@arm.com> wrote:
>> > On Fri, Oct 27, 2017 at 07:57:12AM +0100, Marc Zyngier wrote:
>> >> On Thu, Oct 26 2017 at  4:48:39 pm BST, Mark Rutland <mark.rutland@arm.com> wrote:
>> >> > On Fri, Oct 06, 2017 at 04:34:00PM +0100, Marc Zyngier wrote:
>> >
>> >> >> @@ -485,8 +495,21 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>> >> >>  	kvm_vgic_global_state.can_emulate_gicv2 = false;
>> >> >>  	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
>> >> >>  
>> >> >> -	/* GICv4 support? */
>> >> >> +	/*
>> >> >> +	 * GICv4 support? We need to check on all CPUs in case of some
>> >> >> +	 * extremely creative form of big-little brain damage...
>> >> >> +	 */
>> >> >>  	if (info->has_v4) {
>> >> >> +		int cpu;
>> >> >> +
>> >> >> +		for_each_online_cpu(cpu) {
>> >> >> +			bool enable;
>> >> >> +
>> >> >> +			smp_call_function_single(cpu, vgic_check_v4_cpuif,
>> >> >> +						 &enable, 1);
>> >> >> +			gicv4_enable = gicv4_enable && enable;
>> >> >> +		}
>> >> >
>> >> > With maxcpus=N on the command line, CPUs can be brought online late, so we
>> >> > might need this in a hotplug callback (and/or in the arm64 cpufeature
>> >> > framework) to handle that case.
>> >> 
>> >> I'm afraid that won't be enough. If the CPU is brought up once we've
>> >> already started a VM, we're screwed, as we cannot retroactively decide
>> >> to drop GICv4 on the floor and nuke the guest. Or did you have something
>> >> more radical in mind? Panic?
>> >
>> > If you teach the arm64 cpufeature framework about this, it can abort bringing a
>> > !GICv4 CPU online late.
>> 
>> You wish.
>> 
>> There is all kind of difficulties with that. This requires checking an
>> EL2 register (ICH_VTR_EL2) when we've not initialised KVM yet (so no HYP
>> call facility). We could make it an additional hyp-stub feature, but
>> that feels pretty involved.
>
> Aargh; I'd assumed we could probe this from EL1 somewhow.
>
>> Effectively, GICv4 support having it supported on the redistributors,
>> the ITSs, and the CPUs. The cpufeature framework only addresses the
>> first one. So unless the solution encompasses all the elements in the
>> chain, any checking feels pretty pointless.
>
> Sure thing. :/

How are we taking this further?

I can drop this altogether (after all, you will get what you deserve if
you design a broken system). The alternative would be to add a hotplug
notifier here, and spit out a warning if we're going to be in
trouble. We still run into the risk of messing with a VM that's already
been started before the non-v4 CPU.

Thoughts anyone?

	M.
-- 
Jazz is not dead. It just smells funny.
