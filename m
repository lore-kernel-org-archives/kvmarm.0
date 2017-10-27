From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 25/26] KVM: arm/arm64: GICv4: Prevent heterogenous systems from using GICv4
Date: Fri, 27 Oct 2017 07:57:12 +0100
Message-ID: <868tfxaxiv.fsf@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
        <20171006153401.5481-26-marc.zyngier@arm.com>
        <20171026154839.ebtmqzcy7jjyejul@salmiak>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171026154839.ebtmqzcy7jjyejul@salmiak> (Mark Rutland's message
        of "Thu, 26 Oct 2017 16:48:39 +0100")
Sender: kvm-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 26 2017 at  4:48:39 pm BST, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Fri, Oct 06, 2017 at 04:34:00PM +0100, Marc Zyngier wrote:
>> The GICv4 architecture doesn't prevent CPUs implementing GICv4 to
>> cohabit with CPUs limited to GICv3 in the same system.
>> 
>> This is mad (the scheduler would have to be made aware of the v4
>> capability), and we're certainly not going to support this any
>> time soon. So let's check that all online CPUs are GICv4 capable,
>> and disable the functionnality if not.
>
> I just spotted this because of Christoffer's review; apologies for the late
> drive-by comment...
>
>> @@ -485,8 +495,21 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>>  	kvm_vgic_global_state.can_emulate_gicv2 = false;
>>  	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
>>  
>> -	/* GICv4 support? */
>> +	/*
>> +	 * GICv4 support? We need to check on all CPUs in case of some
>> +	 * extremely creative form of big-little brain damage...
>> +	 */
>>  	if (info->has_v4) {
>> +		int cpu;
>> +
>> +		for_each_online_cpu(cpu) {
>> +			bool enable;
>> +
>> +			smp_call_function_single(cpu, vgic_check_v4_cpuif,
>> +						 &enable, 1);
>> +			gicv4_enable = gicv4_enable && enable;
>> +		}
>
> With maxcpus=N on the command line, CPUs can be brought online late, so we
> might need this in a hotplug callback (and/or in the arm64 cpufeature
> framework) to handle that case.

I'm afraid that won't be enough. If the CPU is brought up once we've
already started a VM, we're screwed, as we cannot retroactively decide
to drop GICv4 on the floor and nuke the guest. Or did you have something
more radical in mind? Panic?

Maybe this approach is not the right one, in which case I'm happy to
drop this patch and implement something else.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
