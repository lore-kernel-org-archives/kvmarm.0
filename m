From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 6/9] kvm: arm/arm64: Add host pmu to support VM
 introspection
Date: Wed, 18 Jan 2017 13:18:33 +0000
Message-ID: <c2382140-b7ac-11d8-89f0-bf421e38f844@arm.com>
References: <20170110113856.7183-1-punit.agrawal@arm.com>
 <20170110113856.7183-7-punit.agrawal@arm.com>
 <1a6b8d71-58a5-b29b-3f01-e945deb2baf6@arm.com>
 <20170118113523.GB3231@leverpostej>
 <87o9z4msi3.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87o9z4msi3.fsf@e105922-lin.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 18/01/17 13:01, Punit Agrawal wrote:
> Mark Rutland <mark.rutland@arm.com> writes:
> 
>> On Wed, Jan 18, 2017 at 11:21:21AM +0000, Marc Zyngier wrote:
>>> On 10/01/17 11:38, Punit Agrawal wrote:
>>>> +#define VM_MASK	GENMASK_ULL(31, 0)
>>>> +#define EVENT_MASK	GENMASK_ULL(32, 39)
>>>> +#define EVENT_SHIFT	(32)
>>>> +
>>>> +#define to_pid(cfg)	((cfg) & VM_MASK)
>>>> +#define to_event(cfg)	(((cfg) & EVENT_MASK) >> EVENT_SHIFT)
>>>> +
>>>> +PMU_FORMAT_ATTR(vm, "config:0-31");
>>>> +PMU_FORMAT_ATTR(event, "config:32-39");
>>>
>>> I'm a bit confused by these. Can't you get the PID of the VM you're
>>> tracing directly from perf, without having to encode things?
> 
> With perf attached to a PID, the event gets scheduled out when the task
> is context switched. As the PID of the controlling process was used,
> none of the vCPU events were counted.
> 
>> And if you
>>> can't, surely this should be a function of the size of pid_t?
> 
> Agreed. I'll update above if we decide to carry on with this
> approach. More below...
> 
>>>
>>> Mark, can you shine some light here?
>>
>> AFAICT, this is not necessary.
>>
>> The perf_event_open() syscall takes a PID separately from the
>> perf_event_attr. i.e. we should be able to do:
>>
>> // monitor a particular vCPU
>> perf_event_open(attr, vcpupid, -1, -1, 0)
>>
>> ... or .. 
>>
>> // monitor a particular vCPU on a pCPU
>> perf_event_open(attr, vcpupid, cpu, -1, 0)
>>
>> ... or ...
>>
>> // monitor all vCPUs on a pCPU
>> perf_event_open(attr, -1, cpu, -1, 0)
>>
>> ... so this shouldn't be necessary. AFAICT, this is a SW PMU, so there
>> should be no issue with using the perf_sw_context.
> 
> I might have missed it but none of the modes of invoking perf_event_open
> allow monitoring a set of process, i.e., all vcpus belonging to a
> particular VM, which was one of the aims and a feature I was carrying
> over from the previous version. If we do not care about this...
> 
>>
>> If this is a bodge to avoid opening a perf_event per vCPU thread, then I
>> completely disagree with the approach. This would be better handled in
>> userspace by discovering the set of threads and opening events for
>> each.
> 
> ... then requiring userspace to invoke perf_event_open perf vCPU will
> simplify this patch.
> 
> Marc, any objections?

Not so far, but I'm curious to find out how you determine which thread
is a vcpu, let alone a given vcpu.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
