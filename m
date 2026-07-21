Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6A23E121A
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 23:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784675022; cv=none; b=qAuY5jHu6dUuXDQl6qIyp7KyE3pWL8kqaC3PFTj5zodbJpGvLGuC1jJhFDIQIx4PyNdGowA8Wscm4MJ7baWjRUk/OQf1fAzTPxKErqk33ODbN5fWiNmzA+nzQdQXoZ4G0MaCbP+fOrEXyh4RUHSuH9IKChYCQwpzpOIesqNX9/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784675022; c=relaxed/simple;
	bh=JNDj4ZdUOfCv9yD29+hCyBtonkpy93aEPM0ejjfCkxk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=jYsDAULE5oM8K79AIbxt3IPN48Ws1lB/0QUVk19AN9XOl1gTqPALBDX9jQDhEuHsyRM6YNCM0KY3QFOtnP/SNLBIt70wPiUqfNSxdJKZkV0iiMtywgbRssiAspc0zCVl1RuAZo4EvLyUOUf7BsTGgWRDpwgspH0VGZddLl9INIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fvg4TW3G; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fvg4TW3G"
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7eb6a8c61deso9056007a34.3
        for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 16:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784675018; x=1785279818; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NJKoZRGKO9NbNpeWxmViKbQ0iXfhg+MMY+xSLEzpUsk=;
        b=Fvg4TW3GWze6y5HcXYQjqwRrv4UFGpvhh1s8aqrT1CIH8n7QllEwwTsDfGMTAetqwj
         D0ezN51RBqTaBe8dQ9vkn0QBFnrQ/wRPGUA91+uT5fyZlF2H1KCu3Quj6LymbjaKxGrz
         afMzn1JGyfu3IhVl3oT+sk2/06T6l0qxUYN4cup0N8+l9pKJvJqsb5qU227Ok0a41VhP
         /l3Fx2gMi5mc5ut9ZkHu1qNNt9J+ei+d9I1ReX+c8uAG2NvN+3XwqAVan4jFVYaH/s1Q
         7Ehc6n1Mzh0BEDN5mKD/VN9p1ovHbuJ3Mws3Psph+X6wFFkVcrCrZzMBGDfPdbZieKpM
         ExJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784675018; x=1785279818;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NJKoZRGKO9NbNpeWxmViKbQ0iXfhg+MMY+xSLEzpUsk=;
        b=dPldHawuXfPbMcBJEVi2lpt2+BpSdm6DBeiUKDyJWHsYj4aIgJPl0hhGKllhrTwAhQ
         XQgtT9lQX2tjlFC98qB/+Ia4yyt4cLDfcbnCxOjGQmASsL6ui31WLISOcAb4qZsWdCuN
         NRvzBxErMrQcTrcfYeKyZ2VCeegaSzmLIu57fi4baLvdp4QEK+UjzbTEqqY/RjRnPkus
         S29eBzQCy1IMlhoiTE/qkCoSTBw1m9tPzW5rA13jDgeaPEAYAWGqCtTfMqpxDiLk8fL2
         McAy2uwqP6GsSuEcqJ5aPV9wWwnkEBGReL0zT246JRgLc3mRikdxM43YPeQIP0PuLuWE
         OvHw==
X-Forwarded-Encrypted: i=1; AHgh+RoKY9JKhzzyi4QRzLgnZWKaWNNYKwVjQaN3610sMRdK1EP1DB/J1BrjrY8PMBJaBPs3EgH5iN4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhsXzhyig36oVVbgT8nDl2luweUwo63DLIY518GWDLi5kKHmOT
	VdBgGqILCAT3qgfoIEU6UEl0c4EOpVGTqgWBUqeSfVHgNZmiTsgE+RhXUDw5ZL3dw5k86CTXLKO
	hJ/8FMNy2Rzwp41mxPOONQeoZ3A==
X-Received: from ilsh7.prod.google.com ([2002:a05:6e02:527:b0:506:ef74:afee])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3a0d:b0:497:e619:56a with SMTP id 5614622812f47-4a4d054cf7fmr10559726b6e.25.1784675018028;
 Tue, 21 Jul 2026 16:03:38 -0700 (PDT)
Date: Tue, 21 Jul 2026 23:03:37 +0000
In-Reply-To: <515af040-deec-471f-92df-ca3e4e91e789@linaro.org> (message from
 James Clark on Mon, 20 Jul 2026 17:46:19 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntbjc054ja.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v8 00/21] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi James, thanks for the review.

James Clark <james.clark@linaro.org> writes:

> On 12/06/2026 8:28 pm, Colton Lewis wrote:
>> This series creates a new PMU scheme on ARM, a partitioned PMU that
>> allows reserving a subset of counters for more direct guest access,
>> significantly reducing overhead. More details, including performance
>> benchmarks, can be read in the v1 cover letter linked below.

>> An overview of what this series accomplishes was presented at KVM
>> Forum 2025. Slides [1] and video [2] are linked below.

>> The kernel command line parameter for the driver still exists, but now
>> only defines an upper limit of counters the guest might use rather
>> than taking those counters from the host permanently.

>> I would appreciate any discussion on whether that parameter should
>> still exist as it's an inconvenient enabling gate on the feature that
>> is no longer required. The question comes down to what, if any, guards
>> we want against a guest monopolizing all counters on a system.


> Hi Colton,

> The existence of the parameter makes sense, but can't the default be
> arm_pmuv3.reserved_host_counters=0 instead of -1 (partition disabled)?

How would you interpret reserved_host_counters=0? Because that would
express that the host should have zero counters and the guest gets them
all. I remember in early versions of this series last year I did use 0
as the default but reviewers asked for a way to express the scenario of
of zero counters for the host.

> It's still a bit fiddly having to do two things to make it work, and
> there's no documentation about what the defaults or other prerequisites
> are. IMO it's not even trivial to work out that you need to prefix it
> with "arm_pmuv3.", which documentation would improve.

It is fiddly, which is why the more I think about it the more I'd rather
ditch the kernel cmdline entirely and leave it up to KVM. That's the
most flexible approach. There isn't a good way to change the cmdline
after boot. Trying to make it writeable via sysfs runs into the problem
of when is it safe to apply the change.

I thought it was commonly understood module parameters need to be
prefixed by the module name, but I can add better documentation to that
effect.


> Testing the whole set I ran into a few issues:

> This warn is hit when there is some kind of interaction with sleeping. I
> tried to bisect it but it only appears on the last commit when the
> option to enable partitioning is added.

> 	/*
> 	 * ARM pmu always has to reprogram the period, so ignore
> 	 * PERF_EF_RELOAD, see the comment below.
> 	 */
> 	if (flags & PERF_EF_RELOAD)
> 		WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));

> Steps to reproduce:

> Host (arm_pmuv3.reserved_host_counters=0):
>    $ sudo perf stat -C 2 -e \
>      'branches,branches,branches,branches,branches,branches'
>    $ sudo taskset --cpu-list 2 ./lkvm run --kernel \
>      /boot/vmlinux-7.1.0-rc7+ -m 1024 -c 1 --pmu

> Guest:
>    $ sleep 1

>     WARNING: drivers/perf/arm_pmu.c:302 at cpu_pm_pmu_notify+0x278/0x2c0,
> CPU#2: swapper/2/0
>      Call trace:
>     cpu_pm_pmu_notify+0x278/0x2c0 (P)
>     notifier_call_chain+0x84/0x1d0
>     raw_notifier_call_chain+0x24/0x38
>     cpu_pm_exit+0x34/0x68
>     acpi_processor_ffh_lpi_enter+0x40/0x78
>     acpi_idle_lpi_enter+0x54/0x78
>     cpuidle_enter_state+0xb4/0x248
>     cpuidle_enter+0x44/0x68
>     do_idle+0x21c/0x300
>     cpu_startup_entry+0x40/0x50
>     secondary_start_kernel+0x120/0x150
>     __secondary_switched+0xc0/0xc8


I'll attempt to reproduce that. I've never seen it myself but I've
mainly been using QEMU for my testing.


> When running the guest on a single CPU I get different counts for the
> same event for a single process, although this never happens on a host.
> I think there might even be some Perf tests which expect them to be the
> same, and this doesn't depend on whether any events are running on the
> host or not. Not sure if you ran all the Perf selftests in a guest or not?

I'll investigate but I'm not sure perf is intended to guarantee
that. perf stat just runs the event counters but may not write or read
them at exactly the same time.

> I'm not sure if the exception level filtering isn't working or there is
> something wrong with freezing. Doesn't the host PMU driver need to
> freeze with HPME? I see it's still doing it with PMCR_EL0.E which
> freezes the guest's counters now doesn't it?

HPME only has any effect while HPMN is programmed to a value different
than the number of counters on the system. That is only true in a guest
context. As I understand it, that means HPME has no effect anywhere the
host driver needs to freeze counters since that happens in host context.

Maybe HPMN stays programmed during interrupt handling though. I'll
confirm.


> Host (arm_pmuv3.reserved_host_counters=0):
>    $ sudo taskset --cpu-list 2 ./lkvm run --kernel \
>      /boot/vmlinux-7.1.0-rc7+ -m 1024 -c 1 --pmu

> Guest:
>    $ perf stat -e branches,branches true

>     Performance counter stats for 'true':

>               167963      branches

>               160925      branches


>    $ perf stat -e branches,branches,branches,branches,branches true

>     Performance counter stats for 'true':

>               164425      branches

>               164425      branches

>               164425      branches

>               157743      branches

>               157743      branches


> When running the guest on two CPUs I just get zeros. Do the kvm
> selftests not catch this? Or is it something to do with my setup:

KVM selftests definitely don't catch it. I'll see if I can reproduce.

Since the problem happens with 2 CPUs I wonder if something is
triggering the lazy context swap behavior so the counter values aren't
being moved to the 2nd CPU correctly.

> Host (arm_pmuv3.reserved_host_counters=0):
>    $ sudo taskset --cpu-list 2-3 ./lkvm run --kernel \
>      /boot/vmlinux-7.1.0-rc7+ -m 1024 -c 1 --pmu

> Guest:
>    $ perf stat -e branches,branches true

>    Performance counter stats for 'true':

>                    0      branches

>                    0      branches

> I also noticed I get the "squeezed" warning printed after launching the
> guest but not using Perf. This comment implies that not using counters
> makes it a nop:

>    	/*
> 	 * If we aren't guest-owned then we know the guest isn't using
> 	 * the PMU anyway, so no need to bother with the swap.
> 	 */
> 	if (vcpu->arch.pmu.access != VCPU_PMU_ACCESS_GUEST_OWNED)
> 		return;

> But maybe linux is touching them in a way that makes them guest owned,
> even on probe? Or is the guest/host ownership tracking not working, I
> didn't look too hard.

Maybe. I'll check. The guest is also running its own PMU driver that
might trigger guest ownership on initialization since ownership is
determined by which registers the guest touches.

> Finally I think there are 3 critical Sashiko comments on this version.
> If they're false positives, then maybe some comments in the code or
> commit messages could reassure it.

I've looked at these and concluded they are worth fixing.

> Thanks
> James

>> v8:

>> * Rebase on top of v7.1-rc7.

>> * Implement Oliver Upton's accessor proposal to centralize PMU
>>     register access and simplify trap handlers. Instead of one singular
>>     accessor, implement as two because the read and write paths are
>>     always different anyway.

>> * Introduce the partitioning flag along with the
>>     kvm_pmu_is_partitioned predicate

>> * Don't use ifdef for partitioning predicates as that can be handled
>>     by has_vhe

>> * Clean up MDCR_EL2 handling by open-coding use_fgt and hpmn and
>>     unconditionally setting RES0 bits.

>> * Use {read,write}_pmcrcntrn in context swaps

>> * Put operators on preceeding lines

>> * Rename hw_cntr_mask to hw_cntr_impl to clarify it tracks the number
>>     of counters implemented by hardware

>> * Use GENMASK_ULL in mask functions returning u64

>> * warn_once when host events are squeezed out by guest counter
>>     allocations.

>> * Address Sashiko AI Review findings:

>>     - Critical fixes for lazy PMU context swaps (ensuring guest state is
>>       loaded on transition to GUEST_OWNED), PMSELR_EL0 trapping to
>>       prevent stale selector index, and masking guest PMCR_EL0 writes to
>>       prevent host reset.

>>     - High priority fixes for lock safety (disabling IRQs when acquiring
>>       perf context lock), disabling guest counters on vCPU put,
>>       preserving VHE host profiling in MDCR_EL2, waking halted vCPUs on
>>       guest PMU interrupts, masking host configuration leaks, preemption
>>       safety in per-CPU accesses, emulating PMCR.N reads, and preventing
>>       data races in PMOVSSET_EL0 accesses.

>>     - Medium/Low fixes for user-access fallback safety, VM-wide state
>>       modification restrictions, selftests type safety, and cleanup of
>>       unused fields and typos.

>> v7:
>> https://lore.kernel.org/kvmarm/20260504211813.1804997-1-coltonlewis@google.com/

>> v6:
>> https://lore.kernel.org/kvmarm/20260209221414.2169465-1-coltonlewis@google.com/

>> v5:
>> https://lore.kernel.org/kvmarm/20251209205121.1871534-1-coltonlewis@google.com/

>> v4:
>> https://lore.kernel.org/kvmarm/20250714225917.1396543-1-coltonlewis@google.com/

>> v3:
>> https://lore.kernel.org/kvm/20250626200459.1153955-1-coltonlewis@google.com/

>> v2:
>> https://lore.kernel.org/kvm/20250620221326.1261128-1-coltonlewis@google.com/

>> v1:
>> https://lore.kernel.org/kvm/20250602192702.2125115-1-coltonlewis@google.com/

>> [1]  
>> https://gitlab.com/qemu-project/kvm-forum/-/raw/main/_attachments/2025/Optimizing__itvHkhc.pdf
>> [2]  
>> https://www.youtube.com/watch?v=YRzZ8jMIA6M&list=PLW3ep1uCIRfxwmllXTOA2txfDWN6vUOHp&index=9

>> Colton Lewis (20):
>>     arm64: cpufeature: Add cpucap for HPMN0
>>     KVM: arm64: Reorganize PMU functions
>>     perf: arm_pmuv3: Generalize counter bitmasks
>>     perf: arm_pmuv3: Check cntr_mask before using pmccntr
>>     perf: arm_pmuv3: Allocate counter indices from high to low
>>     perf: arm_pmuv3: Add method to partition the PMU
>>     KVM: arm64: Set up FGT for Partitioned PMU
>>     KVM: arm64: Add Partitioned PMU register trap handlers
>>     KVM: arm64: Set up MDCR_EL2 to handle a Partitioned PMU
>>     KVM: arm64: Context swap Partitioned PMU guest registers
>>     KVM: arm64: Enforce PMU event filter at vcpu_load()
>>     perf: Add perf_pmu_resched_update()
>>     KVM: arm64: Apply dynamic guest counter reservations
>>     KVM: arm64: Implement lazy PMU context swaps
>>     perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters
>>     KVM: arm64: Detect overflows for the Partitioned PMU
>>     KVM: arm64: Add vCPU device attr to partition the PMU
>>     KVM: selftests: Add find_bit to KVM library
>>     KVM: arm64: selftests: Add test case for Partitioned PMU
>>     KVM: arm64: selftests: Relax testing for exceptions when partitioned

>> Marc Zyngier (1):
>>     KVM: arm64: Reorganize PMU includes

>>    arch/arm/include/asm/arm_pmuv3.h              |  18 +
>>    arch/arm64/include/asm/arm_pmuv3.h            |  12 +-
>>    arch/arm64/include/asm/kvm_host.h             |  17 +-
>>    arch/arm64/include/asm/kvm_types.h            |   6 +-
>>    arch/arm64/include/uapi/asm/kvm.h             |   2 +
>>    arch/arm64/kernel/cpufeature.c                |  10 +-
>>    arch/arm64/kvm/Makefile                       |   2 +-
>>    arch/arm64/kvm/arm.c                          |   2 +
>>    arch/arm64/kvm/config.c                       |  41 +-
>>    arch/arm64/kvm/debug.c                        |  30 +-
>>    arch/arm64/kvm/pmu-direct.c                   | 507 ++++++++++++
>>    arch/arm64/kvm/pmu-emul.c                     | 684 +----------------
>>    arch/arm64/kvm/pmu.c                          | 720 ++++++++++++++++++
>>    arch/arm64/kvm/sys_regs.c                     | 271 +++++--
>>    arch/arm64/tools/cpucaps                      |   1 +
>>    arch/arm64/tools/sysreg                       |   6 +-
>>    drivers/perf/arm_pmuv3.c                      | 136 +++-
>>    include/kvm/arm_pmu.h                         |  93 ++-
>>    include/linux/perf/arm_pmu.h                  |   8 +
>>    include/linux/perf/arm_pmuv3.h                |  14 +-
>>    include/linux/perf_event.h                    |   3 +
>>    kernel/events/core.c                          |  31 +-
>>    tools/include/perf/arm_pmuv3.h                |  12 +-
>>    tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>>    .../selftests/kvm/arm64/vpmu_counter_access.c | 112 ++-
>>    tools/testing/selftests/kvm/lib/find_bit.c    |   2 +
>>    26 files changed, 1918 insertions(+), 823 deletions(-)
>>    create mode 100644 arch/arm64/kvm/pmu-direct.c
>>    create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c


>> base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
