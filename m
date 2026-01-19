Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299A01F03D7
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 01:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768786254; cv=none; b=j+P3Aah3D6JbUMy5vb4XA0xjtzVMWHtf2M+MBcphZjzQEFabUuesJlBoSBA+zs2RU5mHBiKprgxISps/X5CilIrODz+ls18k423d3MsJK//DDL7B5DfMMf90VKQETnDCaS5JzRlUdku/CifOfAeqeomDw6W5R7OvcoxCInZB1Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768786254; c=relaxed/simple;
	bh=esFUOG5kG/KdPoZSnGmpEQOj2HbWxqZ50jGQ1dSqriE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kEDotauWEIO1BOOmt9Sd3XNd6JGZsL3rKy3WknU2YMIxx0KcmurB9Hy/4nOeTqJc7RyMrxWTxg2NPI/Gv4lWolySXUSYYFBZNSAn9A1QDePEpe7VVNH3m0ChaCxXg7XJQWy9vmuCN27Mxl8B1Hdd4z4vNKFIuSIyoeQKpuythdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e5TZd48B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e5TZd48B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768786252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ZNUsUjLhm5UFUgzDZQqKpLzGtDmZv4iToPekSwA0mM=;
	b=e5TZd48BtzJ/8+MFnWJguTyvU5xjCxXmRGJzXvGcXtOG3WB5BN1LuQCpsGUfTBr38dKUBY
	bXCqNo05GYjrc5Exo+y3lXJS+KlGXsqpyymUH786YrAwP4CjuKrUuvYwDUUTnhUyzQpFIO
	1ZO3o1jgTAYTxLnKM5ae+gX8MHvpYyQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-Wg4j52xFORioMyAK5vbiQg-1; Sun, 18 Jan 2026 20:30:49 -0500
X-MC-Unique: Wg4j52xFORioMyAK5vbiQg-1
X-Mimecast-MFC-AGG-ID: Wg4j52xFORioMyAK5vbiQg_1768786246
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34e5a9f0d6aso3651512a91.0
        for <kvmarm@lists.linux.dev>; Sun, 18 Jan 2026 17:30:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768786246; x=1769391046;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5ZNUsUjLhm5UFUgzDZQqKpLzGtDmZv4iToPekSwA0mM=;
        b=jRQSpA+pZPztYYjf6MymUYAYe/EmpoDM9qHeOJfUvD3xp13TaGJe5EihAb51tatUOs
         JOhhMet9HgB0U+1nsUHyDAdEXaRa+WAyyJEOKhAxZU1dnTT9a/IuCoDJACgzSRms09pN
         rmZ1mO91BuacEMfnIp9L9AlAoS0WOmSeA0FqAMITSUHkYqF7t4OuXTiKeUJAgNAqX0zm
         +8qUBDDwkumk/JX6KpzUpIn+CgNrGqVTcPCZfx9MRRXLCEJzL7FtkTIfS4WM5Qo5ccXo
         4/VKdyPO6P6whcgjltHsNrLQTIVOZLSdetpRfpXShXQuLsOPAAd8Akc/xjZLav9z9Aap
         WLqw==
X-Forwarded-Encrypted: i=1; AJvYcCVfjkVwp/g1SSdMspAt3q0OZo1Hj/3sPmAnpoG30DUP5GsnWKGR2tHZ/UVCm83nOBGKi7VNoug=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgLbPo0AA65DrtyEhtz7henvEW1pvkAO5TsO9SsuEF+0R1AGML
	fCpGGGAvG1cYDGoBws64+TKJHcZNXtD8tMxQRDVZIUsBwGsbOozjawdC2u0dDmPoaVCQPH0J3uw
	WbqhJMtXwa2ifTOH+e+siN6aMTppONRR9nyeUJx949lwTfxAakTbo+FQO5w==
X-Gm-Gg: AY/fxX46qCsQOF/bOCgyzRI8wg4DyRefnvJIENL4u3cFUQ2VtMZY3cul8Ud1I0Xzkq1
	wIcqN+8K5Q+PRiaW0AxyDy34AW2L3qDrenZR/8oREHA3fig1WaG+9iBrlyw92XI3VMN0npUUoac
	CR0IoAfMjnVGnqyblYvBgpkKb9nhl1c7YJqApV9ZUcxp035ezV4YnBfnbMiM+C/2K2/jFwuoIdc
	424o1a6LgxadHaAEN/fQ7otmjL2YqGHTmmhunDVxLMvr7aLTJf1hGQnko1ZruF/X8SZAdox0diU
	qi8SldtepyOMy9EPBGwn/0Msv1qjFS7JOihpc7SK3FV9u8rTUh7ntOPj0VYCYLeP8VFnxRAmO7v
	ePuEQ3l5/9BE=
X-Received: by 2002:a17:90b:4984:b0:34e:6e7d:7e73 with SMTP id 98e67ed59e1d1-352678b93d7mr12264043a91.11.1768786246310;
        Sun, 18 Jan 2026 17:30:46 -0800 (PST)
X-Received: by 2002:a17:90b:4984:b0:34e:6e7d:7e73 with SMTP id 98e67ed59e1d1-352678b93d7mr12264032a91.11.1768786245873;
        Sun, 18 Jan 2026 17:30:45 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3527310210fsm804506a91.9.2026.01.18.17.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 17:30:44 -0800 (PST)
Message-ID: <97a5f9d3-6afa-49cf-883d-4e6932e8ff60@redhat.com>
Date: Mon, 19 Jan 2026 09:30:32 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/47] arm_mpam: Add KVM/arm64 and resctrl glue code
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-1-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xEy2AqEpfdAEdF_8LcoILB9rqNCh_hlbB6y062QZhKI_1768786246
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:58 AM, Ben Horgan wrote:
> This new version of the mpam missing pieces has no major rework from the
> previous version. It's mainly small corrections and code tidying based on
> review and things I spotted along the way. To be able to merge this we need
> review from more people and people to start testing on their platforms and
> giving some Tested-by tags.
> 
> Change list in patches.
> 
> As mentioned in the cover letter for v2, one major departure from the
> previous snapshot branches referenced in the base driver series is that the
> same MPAM setting are used for kernel-space and user-space. There are pros
> and cons of choosing this policy but I think it is the best thing to start
> with as there are AMD plans for adding a resctrl feature to allow a
> different closid/rmid configuration for user-space from kernel space. The
> AMD feature is called PLZA and is mentioned in this lpc slide deck[1]. This
> gives us a path forward to add support for having the EL1 and EL0 MPAM
> partid/pmg configuration differ from each other.
> 
>  From James' cover letter:
> 
> This is the missing piece to make MPAM usable resctrl in user-space. This has
> shed its debugfs code and the read/write 'event configuration' for the monitors
> to make the series smaller.
> 
> This adds the arch code and KVM support first. I anticipate the whole thing
> going via arm64, but if goes via tip instead, the an immutable branch with those
> patches should be easy to do.
> 
> Generally the resctrl glue code works by picking what MPAM features it can expose
> from the MPAM drive, then configuring the structs that back the resctrl helpers.
> If your platform is sufficiently Xeon shaped, you should be able to get L2/L3 CPOR
> bitmaps exposed via resctrl. CSU counters work if they are on/after the L3. MBWU
> counters are considerably more hairy, and depend on hueristics around the topology,
> and a bunch of stuff trying to emulate ABMC.
> If it didn't pick what you wanted it to, please share the debug messages produced
> when enabling dynamic debug and booting with:
> | dyndbg="file mpam_resctrl.c +pl"
> 
> I've not found a platform that can test all the behaviours around the monitors,
> so this is where I'd expect the most bugs.
> 
> The MPAM spec that describes all the system and MMIO registers can be found here:
> https://developer.arm.com/documentation/ddi0598/db/?lang=en
> (Ignored the 'RETIRED' warning - that is just arm moving the documentation around.
>   This document has the best overview)
> 
> 
> Based on v6.19-rc5
> This series can be retrieved from:
> https://gitlab.arm.com/linux-arm/linux-bh.git mpam_resctrl_glue_v3
> 
> v2 can be found at:
> https://lore.kernel.org/linux-arm-kernel/20251219181147.3404071-1-ben.horgan@arm.com/
> 
> rfc can be found at:
> https://lore.kernel.org/linux-arm-kernel/20251205215901.17772-1-james.morse@arm.com/
> 
> [1] https://lpc.events/event/19/contributions/2093/attachments/1958/4172/resctrl%20Microconference%20LPC%202025%20Tokyo.pdf
> 
> Ben Horgan (10):
>    arm_mpam: Use non-atomic bitops when modifying feature bitmap
>    arm64/sysreg: Add MPAMSM_EL1 register
>    KVM: arm64: Preserve host MPAM configuration when changing traps
>    KVM: arm64: Make MPAMSM_EL1 accesses UNDEF
>    arm64: mpam: Initialise and context switch the MPAMSM_EL1 register
>    KVM: arm64: Use kernel-space partid configuration for hypercalls
>    arm_mpam: resctrl: Add rmid index helpers
>    arm_mpam: resctrl: Add kunit test for rmid idx conversions
>    arm_mpam: resctrl: Wait for cacheinfo to be ready
>    arm_mpam: resctrl: Add kunit test for mbw min control generation
> 
> Dave Martin (2):
>    arm_mpam: resctrl: Convert to/from MPAMs fixed-point formats
>    arm_mpam: resctrl: Add kunit test for control format conversions
> 
> James Morse (30):
>    arm64: mpam: Context switch the MPAM registers
>    arm64: mpam: Re-initialise MPAM regs when CPU comes online
>    arm64: mpam: Advertise the CPUs MPAM limits to the driver
>    arm64: mpam: Add cpu_pm notifier to restore MPAM sysregs
>    arm64: mpam: Add helpers to change a task or cpu's MPAM PARTID/PMG
>      values
>    KVM: arm64: Force guest EL1 to use user-space's partid configuration
>    arm_mpam: resctrl: Add boilerplate cpuhp and domain allocation
>    arm_mpam: resctrl: Sort the order of the domain lists
>    arm_mpam: resctrl: Pick the caches we will use as resctrl resources
>    arm_mpam: resctrl: Implement resctrl_arch_reset_all_ctrls()
>    arm_mpam: resctrl: Add resctrl_arch_get_config()
>    arm_mpam: resctrl: Implement helpers to update configuration
>    arm_mpam: resctrl: Add plumbing against arm64 task and cpu hooks
>    arm_mpam: resctrl: Add CDP emulation
>    arm_mpam: resctrl: Add support for 'MB' resource
>    arm_mpam: resctrl: Add support for csu counters
>    arm_mpam: resctrl: Pick classes for use as mbm counters
>    arm_mpam: resctrl: Pre-allocate free running monitors
>    arm_mpam: resctrl: Pre-allocate assignable monitors
>    arm_mpam: resctrl: Add kunit test for ABMC/CDP interactions
>    arm_mpam: resctrl: Add resctrl_arch_config_cntr() for ABMC use
>    arm_mpam: resctrl: Allow resctrl to allocate monitors
>    arm_mpam: resctrl: Add resctrl_arch_rmid_read() and
>      resctrl_arch_reset_rmid()
>    arm_mpam: resctrl: Add resctrl_arch_cntr_read() &
>      resctrl_arch_reset_cntr()
>    arm_mpam: resctrl: Update the rmid reallocation limit
>    arm_mpam: resctrl: Add empty definitions for assorted resctrl
>      functions
>    arm64: mpam: Select ARCH_HAS_CPU_RESCTRL
>    arm_mpam: resctrl: Call resctrl_init() on platforms that can support
>      resctrl
>    arm_mpam: Generate a configuration for min controls
>    arm_mpam: Quirk CMN-650's CSU NRDY behaviour
> 
> Jiapeng Chong (1):
>    arm_mpam: Remove duplicate linux/srcu.h header
> 
> Shanker Donthineni (4):
>    arm_mpam: Add quirk framework
>    arm_mpam: Add workaround for T241-MPAM-1
>    arm_mpam: Add workaround for T241-MPAM-4
>    arm_mpam: Add workaround for T241-MPAM-6
> 
>   Documentation/arch/arm64/silicon-errata.rst |    9 +
>   arch/arm64/Kconfig                          |    6 +-
>   arch/arm64/include/asm/el2_setup.h          |    3 +-
>   arch/arm64/include/asm/mpam.h               |   98 +
>   arch/arm64/include/asm/resctrl.h            |    2 +
>   arch/arm64/include/asm/thread_info.h        |    3 +
>   arch/arm64/kernel/Makefile                  |    1 +
>   arch/arm64/kernel/cpufeature.c              |   21 +-
>   arch/arm64/kernel/mpam.c                    |   58 +
>   arch/arm64/kernel/process.c                 |    7 +
>   arch/arm64/kvm/hyp/include/hyp/switch.h     |   12 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c          |    8 +
>   arch/arm64/kvm/hyp/vhe/sysreg-sr.c          |   13 +
>   arch/arm64/kvm/sys_regs.c                   |    2 +
>   arch/arm64/tools/sysreg                     |    8 +
>   drivers/resctrl/Kconfig                     |    9 +-
>   drivers/resctrl/Makefile                    |    1 +
>   drivers/resctrl/mpam_devices.c              |  306 ++-
>   drivers/resctrl/mpam_internal.h             |  131 +-
>   drivers/resctrl/mpam_resctrl.c              | 1930 +++++++++++++++++++
>   drivers/resctrl/test_mpam_devices.c         |   66 +
>   drivers/resctrl/test_mpam_resctrl.c         |  426 ++++
>   include/linux/arm_mpam.h                    |   32 +
>   23 files changed, 3119 insertions(+), 33 deletions(-)
>   create mode 100644 arch/arm64/include/asm/mpam.h
>   create mode 100644 arch/arm64/include/asm/resctrl.h
>   create mode 100644 arch/arm64/kernel/mpam.c
>   create mode 100644 drivers/resctrl/mpam_resctrl.c
>   create mode 100644 drivers/resctrl/test_mpam_resctrl.c
> 

The L3 cache partitioning and MBW (soft) limiting works fine on NVidia's grace-hopper machine.

Tested-by: Gavin Shan <gshan@redhat.com>

Thanks,
Gavin

