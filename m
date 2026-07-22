Received: from mail-wm2-f7.google.com (mail-wm2-f7.google.com [74.125.225.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5518423A80
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 09:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784711120; cv=none; b=cK4SfGWuDqFBkUEV2fmY8V3gPm+xNgkXr3yV18VWdYcwco3UIDHlQ6WwMHLGuymKCQuYNUHIN53SVe2G3rKo9Y6R/xwMQcD8wx2sy2SUKBo0/kb/n1wlRUrW239/urxxudxQwAFacsBPAagzXO0R+TwobOwO5WUGr5iapqTvgnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784711120; c=relaxed/simple;
	bh=AE3cTa4X04AE9oSxeFCaLAWEnD2osvzZTsPzljAGlXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6Fvg2fJrcZECQq83GHJlKcZdKtaMEnMCI42Lqc9LD1im8ycl9aHqJBvCglaKt1fFjUPKoDzLhTgiIzDZpjbEm1hjJGZ6qSTokuBSmtcEhLA1f0qftoMsH28QeCL9OFgzmCMsnVEzZDXjFGNqKt1d0i/KdSxgd2L/7Rut6XkBRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=atWLC305; arc=none smtp.client-ip=74.125.225.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="atWLC305"
Received: by mail-wm2-f7.google.com with SMTP id 5b1f17b1804b1-49557073245so12522905e9.1
        for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 02:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1784711110; x=1785315910; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0gLbjhV3gcgaoSq+Ov7SOkzaksefEJaOQJ3XtteCL3A=;
        b=atWLC305IhIVh9tFry+Ck6x1UJUAmFQ8dPkOHwFHoQ33o0ugCizYeIIPkUicFXNB5s
         /TC+c7idK1uac2l7cINwvqCuSB2esowu5BHrdkCP/jNP6npftJ1Dgg/HlN2TD9UROFnY
         pXkVaRw9HucM3W0HOBJ9r6hfqwctkyzzCiHUOEoHRj39NHoqA4iyTT9P5scI5g6xMptv
         AEF0QAT7jpHihdmTZQB9qN1M7iiz79KWLjLpGe2vIAXqyqxnIqnJpLOEgJDm+XvFmei9
         J2GV8f8lR674VPGNGRFFNikAAdfJ0NIjhpsG/TbMH6q+9e53hDUcC/r6RF6DOpILGWK9
         SeVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784711110; x=1785315910;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0gLbjhV3gcgaoSq+Ov7SOkzaksefEJaOQJ3XtteCL3A=;
        b=E2dU9AqMs8I0woEIO0vfcDs44kJPaabspRCLRPuDB3sJop3cCC6/F12imbhmprMSoL
         gVQUa9jHrCO09/4k49JEfxdSKtCiQNfuLKhdugbtc7I7L300zMLumXe8v0bYIx0oBgRl
         2A1SRqndqgMTYSbA2+PP1qZS+h8Ce3+AaUtUNu3p8a3N4JuymD4HjkOaPwGiBj9xOU2y
         pfuE0czxoCz+O0LwMOtw/w2wgulio/6PbU2S7fuLqoA7QtZXXRV+RVC5YQGO/m5seJ/e
         DyD8ZmL2o269O2CAreawvHI1KxpDSHKJrozqQLgfNOK+GEof00M4pcD37Gn5FOmtMpUE
         D7+Q==
X-Forwarded-Encrypted: i=1; AHgh+RpTUXD1jQPdw0PkAISKEiPaNohYaSMnqJ2fa99p/ssvpapU6hS6cK3TrztBlfzrsQwe/XCl/wA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxl1tcLmN/0dRZ4hLjlPYkVwpHRU+u1n1vsl0/l0I+BfOTKEFl2
	QAAT6LMLd94DzQqe8o4tQbAI2GxU7MefCasFnH0y5fTTVfLlLrzKXL7Ve0gsDEbGLkk=
X-Gm-Gg: AR+sD13M4rqReqp927GpCfyRIgFXN+MmIWNYiVYvv4Oe/kmRLT1HQftuWk5+hbDSLcg
	gXtRdJGqabp8FxQ6L3Yu6afdMhJSnnCN7/tKvYOZeOqPa4iV/WbQDPbVpS9iEszLFAGsuggO2r0
	T+ol5qVVRCCSuBxroj9LbvyjEZvlc5yEGCp8SEgPDjrEU+EzSJSGu2qUy3TZh7q6wRfqCwFtB/f
	yK7qUHrdrBniQRC4AUvrWnj6gdKk6Sipv68wrD4/XDFi7Tj9wGf7JEnp8FDxDwViRsQupNk/fZn
	+KXVqSuMiNhpTNc/SkUMw9tkoMVLuCxcKBUkhI7LjYh6qc1sVQLWQ0UXSk8MeaEDCPpxh7LDZS7
	+ErwZSwJCVJJVgW6IpgujB+ehKwPMO+ZQmfnd5sUa8BECpqQnstAXPDBFaCvTAmrODX5B41Pu4M
	wYPngETvtKB0STqVyckQ==
X-Received: by 2002:a05:600c:9a2:b0:495:3aac:1098 with SMTP id 5b1f17b1804b1-4954a50c489mr170439955e9.32.1784711109434;
        Wed, 22 Jul 2026 02:05:09 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.141.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495653bfed7sm142065635e9.11.2026.07.22.02.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 02:05:08 -0700 (PDT)
Message-ID: <e7170127-018b-4b11-b606-3f29ba65ec88@linaro.org>
Date: Wed, 22 Jul 2026 10:05:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/21] ARM64 PMU Partitioning
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com,
 corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <gsntbjc054ja.fsf@coltonlewis-kvm.c.googlers.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <gsntbjc054ja.fsf@coltonlewis-kvm.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 22/07/2026 12:03 am, Colton Lewis wrote:
> Hi James, thanks for the review.
> 
> James Clark <james.clark@linaro.org> writes:
> 
>> On 12/06/2026 8:28 pm, Colton Lewis wrote:
>>> This series creates a new PMU scheme on ARM, a partitioned PMU that
>>> allows reserving a subset of counters for more direct guest access,
>>> significantly reducing overhead. More details, including performance
>>> benchmarks, can be read in the v1 cover letter linked below.
> 
>>> An overview of what this series accomplishes was presented at KVM
>>> Forum 2025. Slides [1] and video [2] are linked below.
> 
>>> The kernel command line parameter for the driver still exists, but now
>>> only defines an upper limit of counters the guest might use rather
>>> than taking those counters from the host permanently.
> 
>>> I would appreciate any discussion on whether that parameter should
>>> still exist as it's an inconvenient enabling gate on the feature that
>>> is no longer required. The question comes down to what, if any, guards
>>> we want against a guest monopolizing all counters on a system.
> 
> 
>> Hi Colton,
> 
>> The existence of the parameter makes sense, but can't the default be
>> arm_pmuv3.reserved_host_counters=0 instead of -1 (partition disabled)?
> 
> How would you interpret reserved_host_counters=0? Because that would
> express that the host should have zero counters and the guest gets them
> all. I remember in early versions of this series last year I did use 0
> as the default but reviewers asked for a way to express the scenario of
> of zero counters for the host.
> 

I think I would interpret it as it is now. Can't the host still use them 
until the guest does and then they only get squeezed if there is a 
collision? That doesn't sound too bad to me. And if a host wants 
reserved counters they can set a positive number.

Is reserved_host_counters==max_counters equivalent to -1? And there's no 
overview in the cover letter or documentation about how it interacts 
with the dynamic guest counter reservations. A bit more detail or a few 
paragraphs in one place would help users, maybe with examples so they 
don't have to piece together all the commit messages to work it out.

>> It's still a bit fiddly having to do two things to make it work, and
>> there's no documentation about what the defaults or other prerequisites
>> are. IMO it's not even trivial to work out that you need to prefix it
>> with "arm_pmuv3.", which documentation would improve.
> 
> It is fiddly, which is why the more I think about it the more I'd rather
> ditch the kernel cmdline entirely and leave it up to KVM. That's the
> most flexible approach. There isn't a good way to change the cmdline
> after boot. Trying to make it writeable via sysfs runs into the problem
> of when is it safe to apply the change.
> 
> I thought it was commonly understood module parameters need to be
> prefixed by the module name, but I can add better documentation to that
> effect.
> 
> 

People just want it written out fully somewhere so they can copy paste 
it. Kernel developers might be able to piece it together, but not 
everyone will.

>> Testing the whole set I ran into a few issues:
> 
>> This warn is hit when there is some kind of interaction with sleeping. I
>> tried to bisect it but it only appears on the last commit when the
>> option to enable partitioning is added.
> 
>>     /*
>>      * ARM pmu always has to reprogram the period, so ignore
>>      * PERF_EF_RELOAD, see the comment below.
>>      */
>>     if (flags & PERF_EF_RELOAD)
>>         WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
> 
>> Steps to reproduce:
> 
>> Host (arm_pmuv3.reserved_host_counters=0):
>>    $ sudo perf stat -C 2 -e \
>>      'branches,branches,branches,branches,branches,branches'
>>    $ sudo taskset --cpu-list 2 ./lkvm run --kernel \
>>      /boot/vmlinux-7.1.0-rc7+ -m 1024 -c 1 --pmu
> 
>> Guest:
>>    $ sleep 1
> 
>>     WARNING: drivers/perf/arm_pmu.c:302 at cpu_pm_pmu_notify+0x278/0x2c0,
>> CPU#2: swapper/2/0
>>      Call trace:
>>     cpu_pm_pmu_notify+0x278/0x2c0 (P)
>>     notifier_call_chain+0x84/0x1d0
>>     raw_notifier_call_chain+0x24/0x38
>>     cpu_pm_exit+0x34/0x68
>>     acpi_processor_ffh_lpi_enter+0x40/0x78
>>     acpi_idle_lpi_enter+0x54/0x78
>>     cpuidle_enter_state+0xb4/0x248
>>     cpuidle_enter+0x44/0x68
>>     do_idle+0x21c/0x300
>>     cpu_startup_entry+0x40/0x50
>>     secondary_start_kernel+0x120/0x150
>>     __secondary_switched+0xc0/0xc8
> 
> 
> I'll attempt to reproduce that. I've never seen it myself but I've
> mainly been using QEMU for my testing.
> 

The newest Arm FVP should have cpuidle enabled if you boot it with ACPI, 
but I hit this on a Radxa Orion O6 board.

> 
>> When running the guest on a single CPU I get different counts for the
>> same event for a single process, although this never happens on a host.
>> I think there might even be some Perf tests which expect them to be the
>> same, and this doesn't depend on whether any events are running on the
>> host or not. Not sure if you ran all the Perf selftests in a guest or 
>> not?
> 
> I'll investigate but I'm not sure perf is intended to guarantee
> that. perf stat just runs the event counters but may not write or read
> them at exactly the same time.
> 

Is that true? The perf core calls perf_pmu_disable() when a process is 
scheduled out before reading the count of each event of that process in 
an inner loop. The perf_pmu_disable() clears PMCR_EL0.E which freezes 
all of the counters so they can be read out in a consistent state.

It's important that they're all stopped at the same time because 
counters might be used in metrics as ratios of each other. So I think 
it's deliberately designed that way and appears to not be working in a 
guest now.

>> I'm not sure if the exception level filtering isn't working or there is
>> something wrong with freezing. Doesn't the host PMU driver need to
>> freeze with HPME? I see it's still doing it with PMCR_EL0.E which
>> freezes the guest's counters now doesn't it?
> 
> HPME only has any effect while HPMN is programmed to a value different
> than the number of counters on the system. That is only true in a guest
> context. As I understand it, that means HPME has no effect anywhere the
> host driver needs to freeze counters since that happens in host context.
> 

Oh yeah that makes sense, I didn't think about that. I'm not sure if my 
other idea about exception level filtering being responsible makes sense 
either.

> Maybe HPMN stays programmed during interrupt handling though. I'll
> confirm.
>  
> 
>> Host (arm_pmuv3.reserved_host_counters=0):
>>    $ sudo taskset --cpu-list 2 ./lkvm run --kernel \
>>      /boot/vmlinux-7.1.0-rc7+ -m 1024 -c 1 --pmu
> 
>> Guest:
>>    $ perf stat -e branches,branches true
> 
>>     Performance counter stats for 'true':
> 
>>               167963      branches
> 
>>               160925      branches
> 
> 
>>    $ perf stat -e branches,branches,branches,branches,branches true
> 
>>     Performance counter stats for 'true':
> 
>>               164425      branches
> 
>>               164425      branches
> 
>>               164425      branches
> 
>>               157743      branches
> 
>>               157743      branches
> 
> 
>> When running the guest on two CPUs I just get zeros. Do the kvm
>> selftests not catch this? Or is it something to do with my setup:
> 
> KVM selftests definitely don't catch it. I'll see if I can reproduce.
> 
> Since the problem happens with 2 CPUs I wonder if something is
> triggering the lazy context swap behavior so the counter values aren't
> being moved to the 2nd CPU correctly.
> 

If that was the case I would have expected it to be intermittent, or you 
would get a partial count if the second CPU started from 0, but not 
zeros every where every time. Let me know if I can run any more tests.

>> Host (arm_pmuv3.reserved_host_counters=0):
>>    $ sudo taskset --cpu-list 2-3 ./lkvm run --kernel \
>>      /boot/vmlinux-7.1.0-rc7+ -m 1024 -c 1 --pmu
> 
>> Guest:
>>    $ perf stat -e branches,branches true
> 
>>    Performance counter stats for 'true':
> 
>>                    0      branches
> 
>>                    0      branches
> 
>> I also noticed I get the "squeezed" warning printed after launching the
>> guest but not using Perf. This comment implies that not using counters
>> makes it a nop:
> 
>>        /*
>>      * If we aren't guest-owned then we know the guest isn't using
>>      * the PMU anyway, so no need to bother with the swap.
>>      */
>>     if (vcpu->arch.pmu.access != VCPU_PMU_ACCESS_GUEST_OWNED)
>>         return;
> 
>> But maybe linux is touching them in a way that makes them guest owned,
>> even on probe? Or is the guest/host ownership tracking not working, I
>> didn't look too hard.
> 
> Maybe. I'll check. The guest is also running its own PMU driver that
> might trigger guest ownership on initialization since ownership is
> determined by which registers the guest touches.
> 

It doesn't enable any counters though does it, even if it touches some 
of the registers to probe? Should that result in squeezing out host 
counters? Maybe it's more complicated to implement, but right now it 
seems like there is some complexity without much benefit as 90% of hosts 
are going to probe the counters just to see what's there but not use them.

>> Finally I think there are 3 critical Sashiko comments on this version.
>> If they're false positives, then maybe some comments in the code or
>> commit messages could reassure it.
> 
> I've looked at these and concluded they are worth fixing.
> 
>> Thanks
>> James
> 
>>> v8:
> 
>>> * Rebase on top of v7.1-rc7.
> 
>>> * Implement Oliver Upton's accessor proposal to centralize PMU
>>>     register access and simplify trap handlers. Instead of one singular
>>>     accessor, implement as two because the read and write paths are
>>>     always different anyway.
> 
>>> * Introduce the partitioning flag along with the
>>>     kvm_pmu_is_partitioned predicate
> 
>>> * Don't use ifdef for partitioning predicates as that can be handled
>>>     by has_vhe
> 
>>> * Clean up MDCR_EL2 handling by open-coding use_fgt and hpmn and
>>>     unconditionally setting RES0 bits.
> 
>>> * Use {read,write}_pmcrcntrn in context swaps
> 
>>> * Put operators on preceeding lines
> 
>>> * Rename hw_cntr_mask to hw_cntr_impl to clarify it tracks the number
>>>     of counters implemented by hardware
> 
>>> * Use GENMASK_ULL in mask functions returning u64
> 
>>> * warn_once when host events are squeezed out by guest counter
>>>     allocations.
> 
>>> * Address Sashiko AI Review findings:
> 
>>>     - Critical fixes for lazy PMU context swaps (ensuring guest state is
>>>       loaded on transition to GUEST_OWNED), PMSELR_EL0 trapping to
>>>       prevent stale selector index, and masking guest PMCR_EL0 writes to
>>>       prevent host reset.
> 
>>>     - High priority fixes for lock safety (disabling IRQs when acquiring
>>>       perf context lock), disabling guest counters on vCPU put,
>>>       preserving VHE host profiling in MDCR_EL2, waking halted vCPUs on
>>>       guest PMU interrupts, masking host configuration leaks, preemption
>>>       safety in per-CPU accesses, emulating PMCR.N reads, and preventing
>>>       data races in PMOVSSET_EL0 accesses.
> 
>>>     - Medium/Low fixes for user-access fallback safety, VM-wide state
>>>       modification restrictions, selftests type safety, and cleanup of
>>>       unused fields and typos.
> 
>>> v7:
>>> https://lore.kernel.org/kvmarm/20260504211813.1804997-1- 
>>> coltonlewis@google.com/
> 
>>> v6:
>>> https://lore.kernel.org/kvmarm/20260209221414.2169465-1- 
>>> coltonlewis@google.com/
> 
>>> v5:
>>> https://lore.kernel.org/kvmarm/20251209205121.1871534-1- 
>>> coltonlewis@google.com/
> 
>>> v4:
>>> https://lore.kernel.org/kvmarm/20250714225917.1396543-1- 
>>> coltonlewis@google.com/
> 
>>> v3:
>>> https://lore.kernel.org/kvm/20250626200459.1153955-1- 
>>> coltonlewis@google.com/
> 
>>> v2:
>>> https://lore.kernel.org/kvm/20250620221326.1261128-1- 
>>> coltonlewis@google.com/
> 
>>> v1:
>>> https://lore.kernel.org/kvm/20250602192702.2125115-1- 
>>> coltonlewis@google.com/
> 
>>> [1] https://gitlab.com/qemu-project/kvm-forum/-/raw/main/ 
>>> _attachments/2025/Optimizing__itvHkhc.pdf
>>> [2] https://www.youtube.com/watch? 
>>> v=YRzZ8jMIA6M&list=PLW3ep1uCIRfxwmllXTOA2txfDWN6vUOHp&index=9
> 
>>> Colton Lewis (20):
>>>     arm64: cpufeature: Add cpucap for HPMN0
>>>     KVM: arm64: Reorganize PMU functions
>>>     perf: arm_pmuv3: Generalize counter bitmasks
>>>     perf: arm_pmuv3: Check cntr_mask before using pmccntr
>>>     perf: arm_pmuv3: Allocate counter indices from high to low
>>>     perf: arm_pmuv3: Add method to partition the PMU
>>>     KVM: arm64: Set up FGT for Partitioned PMU
>>>     KVM: arm64: Add Partitioned PMU register trap handlers
>>>     KVM: arm64: Set up MDCR_EL2 to handle a Partitioned PMU
>>>     KVM: arm64: Context swap Partitioned PMU guest registers
>>>     KVM: arm64: Enforce PMU event filter at vcpu_load()
>>>     perf: Add perf_pmu_resched_update()
>>>     KVM: arm64: Apply dynamic guest counter reservations
>>>     KVM: arm64: Implement lazy PMU context swaps
>>>     perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters
>>>     KVM: arm64: Detect overflows for the Partitioned PMU
>>>     KVM: arm64: Add vCPU device attr to partition the PMU
>>>     KVM: selftests: Add find_bit to KVM library
>>>     KVM: arm64: selftests: Add test case for Partitioned PMU
>>>     KVM: arm64: selftests: Relax testing for exceptions when partitioned
> 
>>> Marc Zyngier (1):
>>>     KVM: arm64: Reorganize PMU includes
> 
>>>    arch/arm/include/asm/arm_pmuv3.h              |  18 +
>>>    arch/arm64/include/asm/arm_pmuv3.h            |  12 +-
>>>    arch/arm64/include/asm/kvm_host.h             |  17 +-
>>>    arch/arm64/include/asm/kvm_types.h            |   6 +-
>>>    arch/arm64/include/uapi/asm/kvm.h             |   2 +
>>>    arch/arm64/kernel/cpufeature.c                |  10 +-
>>>    arch/arm64/kvm/Makefile                       |   2 +-
>>>    arch/arm64/kvm/arm.c                          |   2 +
>>>    arch/arm64/kvm/config.c                       |  41 +-
>>>    arch/arm64/kvm/debug.c                        |  30 +-
>>>    arch/arm64/kvm/pmu-direct.c                   | 507 ++++++++++++
>>>    arch/arm64/kvm/pmu-emul.c                     | 684 +----------------
>>>    arch/arm64/kvm/pmu.c                          | 720 ++++++++++++++ 
>>> ++++
>>>    arch/arm64/kvm/sys_regs.c                     | 271 +++++--
>>>    arch/arm64/tools/cpucaps                      |   1 +
>>>    arch/arm64/tools/sysreg                       |   6 +-
>>>    drivers/perf/arm_pmuv3.c                      | 136 +++-
>>>    include/kvm/arm_pmu.h                         |  93 ++-
>>>    include/linux/perf/arm_pmu.h                  |   8 +
>>>    include/linux/perf/arm_pmuv3.h                |  14 +-
>>>    include/linux/perf_event.h                    |   3 +
>>>    kernel/events/core.c                          |  31 +-
>>>    tools/include/perf/arm_pmuv3.h                |  12 +-
>>>    tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>>>    .../selftests/kvm/arm64/vpmu_counter_access.c | 112 ++-
>>>    tools/testing/selftests/kvm/lib/find_bit.c    |   2 +
>>>    26 files changed, 1918 insertions(+), 823 deletions(-)
>>>    create mode 100644 arch/arm64/kvm/pmu-direct.c
>>>    create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c
> 
> 
>>> base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48

