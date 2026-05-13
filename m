Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60E33043D5
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778688637; cv=none; b=tIDqJksppG64I2xscmFcusB/PeiXqttDZhNqVp4HMfHvIxd+1mR+iqWjUTUfjq77m2VdDWUD0t5wZn75InpHrAED3nz3S07FdYYEfkIlRBxpEOD3GraLzzknnfiCkLDYr2/BiHLwDT6S6FKjaxuBa5mpv2bRXw9cYBNc3wvGoJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778688637; c=relaxed/simple;
	bh=xUFNckisZTKglNhJBqKKNuO742ekTOASKm0SwN4Guw0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=KDrUgU2b/rTFfP0yujCUBAGn8A8iTwlo5ETv4SUsD+E1iryulrSVd10cMbKigDTrebt1r8XwNiF5gr3/TDwRgfPOun/N6ecQpfy2yIqqLRxBifXyDltf9JqoSAfB5cn5AmHkT8t8XH/4vG2slbZSo7ptB9xzYvYAGugzrKw6ync=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qB21v+zf; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qB21v+zf"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-69b4f753046so6871530eaf.2
        for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 09:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778688635; x=1779293435; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=syDSn8FwCn4myKFJCIXbZFQJnGch0dw2zPcy4g4QTeo=;
        b=qB21v+zfpDDBeH0G/BlXpmEOH3u1CCilz76JAVTBb1vITwAuTobnMjBPFboJ+xgxrP
         7JsNggXN+0YOyybiTh1CDF5rZOj3q0WA3YnzDgTA2lvHoqAMDIhdldxmQRrkFxcqNfvg
         cXQ98kvyevjc8YYcXLFxhmtp7t3b73wh6oLgHbzz/MlWueFGmHd6M3N/d32x/txlxeNi
         wb5PaQFt6fJmvC6Z7I2wwWU8KObPfxaOm2k4O6eFgQd5aMzLySLNrGPxoxtg/U5nayvf
         8UkR15Jdy4CkiQeIJXjctEtvZxiy+kMMe7vjgn5GUrJ6IDXrtPoRFOWsbcNUEqVxWG6z
         MbdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778688635; x=1779293435;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=syDSn8FwCn4myKFJCIXbZFQJnGch0dw2zPcy4g4QTeo=;
        b=H06a/gJzlbpWoQ4xr3myhMihgaKg5EMKxq7NDdSo9SqnFxZrQUCO1PMK3nTH9PQKQS
         t/9K2e86oAx6zh5PuJrZekZ1JiJmYZyojpMKclJSHv0OLtJns5+fydI7MCPE0r8Dgefv
         g5OQ2ucS/ItlX/C4UL54h0z4Ym0BuiistCtFYRKHgQ56DRQLBcsp4fsxC8dy+aO3fYpx
         bpbT3oifcAjp1qq+fBwaW5PplZMxitSy57NYHXT7NHZrldOAMJPXKvg5XdNhwjGjXnxJ
         y7K+kGd60ZYxyj3cqN+NIsekd6OdkY9f9BwEbLF7Kl2MibC0ra/YvQQTVcOZq5RQ/pI/
         akjQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mc7twKiVOaq/3qPAiUmb1VKMIezFoKOKNtdghzpupueFdo98RSKGZaPnGyAGZyU2Od905Yvk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWKR0Plq/uFe5ezgs3QTY7BWc/EuCGI8ky+/ISazN7+VZkHa7K
	nDmL7hLtBl31uAcAtZ1lPsmPUs0C7BAqKZE/01W7mMWXW9X36lkzZteyRSFlqC3VnEmhL8aXP1B
	PlcA5xHRsB0UrDPCtfi/nWZKEiA==
X-Received: from iovs8.prod.google.com ([2002:a05:6602:2bc8:b0:96e:18c2:898c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1a0c:b0:696:64ab:cd9d with SMTP id 006d021491bc7-69b7a9d330cmr1858550eaf.12.1778688634368;
 Wed, 13 May 2026 09:10:34 -0700 (PDT)
Date: Wed, 13 May 2026 16:10:33 +0000
In-Reply-To: <18d747ea-660a-4ae6-b8b8-365d745352ce@linaro.org> (message from
 James Clark on Mon, 11 May 2026 15:57:13 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt8q9ncmti.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v7 00/20] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: alexandru.elisei@arm.com, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes


Hi James. Thanks for reviewing.

James Clark <james.clark@linaro.org> writes:

> On 04/05/2026 10:17 pm, Colton Lewis wrote:
>> This series creates a new PMU scheme on ARM, a partitioned PMU that
>> allows reserving a subset of counters for more direct guest access,
>> significantly reducing overhead. More details, including performance
>> benchmarks, can be read in the v1 cover letter linked below.

>> An overview of what this series accomplishes was presented at KVM
>> Forum 2025. Slides [1] and video [2] are linked below.

>> After a few false starts, meeting with Will Deacon and Mark Rutland to
>> discuss implementation ideas, and a few more false starts, I finally
>> have an implementation of dynamic counter reservation that works
>> without disrupting host perf too much. Now the host only loses access
>> to the guest counters when a vCPU resides on the CPU.

>> The key was creating perf_pmu_resched_update, which behaves exactly
>> like perf_pmu_resched except it takes a callback to call in between
>> when the perf events are scheduled out and when they are scheduled
>> back in. That allows us to update the PMU's available counters when we
>> know they are not currently in use without needing to expose private
>> perf core functions and triple check they are not being called in a
>> way that violates existing assumptions.

>> Because this introduces a possibility of perf reschedule during vCPU
>> load, I've optimized to only do that operation if there are host
>> events occupying the intended guest counters at the time of the load.

>> The kernel command line parameter for the driver still exists, but now
>> only defines an upper limit of counters the guest might use rather
>> than taking those counters from the host permanently.

>> v7:

>> * Implement dynamic counter reservation as described above. One side
>>     effect is the PMUv3 driver now needs much fewer changes to enforce
>>     the boundary.

>> * Move register accesses out of fast path for non-FGT hardware. The
>>     performance impact was negligible and this moves bloat out of the
>>     fast path and allows a more reliable design with more code sharing.

>> * Make PMCCNTR a special case in the context swap again because trying
>>     to access it with PMXEVCNTR is undefined.

>> * Fix a bug where kvm_pmu_guest_counter_mask was using & instead of |.

>> * Re-expose the dedicated instruction counter to the host since it was
>>     decided the guest will not own it.

>> * Change the global armv8pmu_reserved_host_counters to
>>     armv8pmu_is_partitoned because it was only used in boolean checks.

>> * Fix typo in vcpu attribute commit so the spelling of the flag in the
>>     commit message matches the code.

>> * Rebase to v7.0-rc7

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

>> Colton Lewis (19):
>>     arm64: cpufeature: Add cpucap for HPMN0
>>     KVM: arm64: Reorganize PMU functions
>>     perf: arm_pmuv3: Generalize counter bitmasks
>>     perf: arm_pmuv3: Check cntr_mask before using pmccntr
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
>>    arch/arm64/kernel/cpufeature.c                |   8 +
>>    arch/arm64/kvm/Makefile                       |   2 +-
>>    arch/arm64/kvm/arm.c                          |   2 +
>>    arch/arm64/kvm/config.c                       |  41 +-
>>    arch/arm64/kvm/debug.c                        |  31 +-
>>    arch/arm64/kvm/pmu-direct.c                   | 494 ++++++++++++
>>    arch/arm64/kvm/pmu-emul.c                     | 674 +----------------
>>    arch/arm64/kvm/pmu.c                          | 701 ++++++++++++++++++
>>    arch/arm64/kvm/sys_regs.c                     | 250 ++++++-
>>    arch/arm64/tools/cpucaps                      |   1 +
>>    arch/arm64/tools/sysreg                       |   6 +-
>>    drivers/perf/arm_pmuv3.c                      | 111 ++-
>>    include/kvm/arm_pmu.h                         | 110 +++
>>    include/linux/perf/arm_pmu.h                  |   3 +
>>    include/linux/perf/arm_pmuv3.h                |  14 +-
>>    include/linux/perf_event.h                    |   3 +
>>    kernel/events/core.c                          |  28 +-
>>    tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>>    .../selftests/kvm/arm64/vpmu_counter_access.c | 112 ++-
>>    tools/testing/selftests/kvm/lib/find_bit.c    |   1 +
>>    25 files changed, 1861 insertions(+), 787 deletions(-)
>>    create mode 100644 arch/arm64/kvm/pmu-direct.c
>>    create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c


>> base-commit: 591cd656a1bf5ea94a222af5ef2ee76df029c1d2
>> --
>> 2.54.0.545.g6539524ca2-goog

> I tested it a bit and ran the kselftests and it all seems to be working

Great to hear you didn't find any obvious problems with your testing!

> ok. Some of the critical sashiko comments look like they are worth
> looking into though:
> https://sashiko.dev/#/patchset/20260504211813.1804997-1-coltonlewis%40google.com
> For example writing to PMCR_EL0.P from EL2 resets the host's counters,
> even if it's KVM doing it after trapping a write from the guest.

I will comb through this and the other sashiko comments and fix.
