Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1849E37A82E;
	Tue,  8 Sep 2026 05:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788846376; cv=none; b=FPWAXZd8sMgnldwc99bMrGF6qVTC0ppxUinPy3zVH+2B17UKh8vx/NXVGevlfZ7fscA8hWKDTH8lgzPXSIpWwQDvsvFG4KWVj5Unh2LZMTmcnwfk6EJvcp59/FgRBNH4Z0Y2NuWaRdtu2hohyDoBrbEFcQeoHTCKcRsoCEJPPBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788846376; c=relaxed/simple;
	bh=018JPSiwa1Esmp2GGb5fgmI7lze3gY3IgPSCqWkIVeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0oyKu8ovM6E/vkM6CTH+SjxXG9EZ/nL6m65JpoeWPQ+B4IMGu4rsNy4OsyL6gkeEr5o9m8XAazLfQD53QjorhZ6qZyuTieVYHqxVKjFjfK6Q+U3cA1zG4Y5lxf6byT9bl+iHNcmAplArPBQxqqQQ4lWqomhwfzV5+n+z+pWfjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uswXvC9i; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uswXvC9i"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5DDF1476;
	Mon,  7 Sep 2026 22:46:09 -0700 (PDT)
Received: from [10.57.49.168] (unknown [10.57.49.168])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5AF973F86C;
	Mon,  7 Sep 2026 22:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788846373; bh=018JPSiwa1Esmp2GGb5fgmI7lze3gY3IgPSCqWkIVeY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uswXvC9iVmPahBQvMDKTommtwYrmYay+C0FosciqsZfG6re8SIW1nfbKsbOkEi0tR
	 g/wH4O4enKKNcsPeqpbj5dGb+aMFg25xbipsadAjFwRtVBgbLhjuVJ6k1D8O1i/zsr
	 P4CqKXq+SpkITHmHm8qJ1/qTpstEq0PLB4Bqht20=
Message-ID: <f65216f6-cb7b-4b76-a7cc-79b332db2bd8@arm.com>
Date: Tue, 8 Sep 2026 06:46:05 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 0/7] firmware: arm_rmm: Add RMM v2.0 base RMI support
Content-Language: en-GB
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org,
 Mathieu Poirier <mathieu.poirier@linaro.org>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <ap-C6NLnxuWWTMzi@FCCLS0092175.localdomain>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ap-C6NLnxuWWTMzi@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kohei-San

Linaro is best suited to answer this. I have Cc'ed Mathieu (and
Lorenzo), who may be able to help you here.

On 08/09/2026 05:09, Kohei Enju wrote:
> Hi Suzuki,
> 
> On 09/07 10:59, Suzuki K Poulose wrote:
>> This series adds the generic firmware layer for talking to the Realm
>> Management Monitor (RMM), as specified by the RMM v2.0-bet3
>> specification[1]. It is the first part of the Arm CCA host support that
>> was previously posted as part of the larger KVM series.
>>
>> The split allows this RMM support to be used as a base for other work,
>> including Aneesh's PCI IDE support with Arm CCA RMM as the TSM,
>>   without depending on the KVM Realm support that will follow as separate
>>   series. (See more on that below)
>>
>> The series adds:
>>
>>   * The RMI SMC definitions and direct-call wrappers.
>>
>>   * RMM discovery and version checks during firmware init.
>>
>>   * RMM host configuration, including the host page size.
>>
>>   * Stateful RMI Operation (SRO) infrastructure for commands which the RMM
>>     can complete across multiple SMC calls while requesting or returning
>>     memory to the host.
>>
>>   * Verification that granule tracking is available at fine granularity.
>>     Fine-grained tracking allows each granule in the system to be tracked
>>     independently, which is required before individual granules can be
>>     delegated. A future series will add support for dynamically supplying
>>     memory to the RMM for this tracking.
>>
>>   * Support for fully firmware-managed systems, where the Granule Protection
>>     Tables for memory regions are allocated and managed by firmware. RMM v2.0
>>     also allows dynamic GPT creation on demand; support for that will be added
>>     in a later series.
>>
>>   * Wrappers for the RMI commands that are used for managing the "Realm VM"
>>     lifecycle. This is added in to make it easier for the on-going KVM support
>>     to evolve in parallel pieces.
>>
>> If the platform firmware cannot manage the granule tracking or the GPTs, we
>> bail out and deactivate the RMM, reclaiming any memory that we have donated.
>>
>> The RMM v2.0 spec introduces Stateful RMI Operations (SROs), which allow
>> the RMM to complete an operation over several SMC calls while requesting
>> or returning memory to the host. This allows interrupts to be handled in
>> the middle of an operation and lets the RMM dynamically allocate memory
>> for internal tracking purposes. For example, RMI_REC_CREATE no longer
>> needs auxiliary granules to be provided up front, and can instead
>> request memory during the operation.
>>
>> This series applies on v7.3-rc1 and a branch is available at [2]. The KVM
>> CCA support that builds on this series is available at [3] as an integration
>> branch. The KVM support depends on guest-memfd-in-place conversion support v12
>> from Ackerley [4], we plan to split that into parts, which apply cleanly on
>> v7.3-rcx without any dependency and is in progress. This will be made available
>> as soon as it is ready. Until then [3] shows how this base series enables KVM
>> CCA support. You may find the tf-RMM [5] and kvmtool support [6] below.
>>
>> [1] RMM spec : https://support.arm.com/documentation/den0137/2-0bet3/
>> [2] This series: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/fw_rmm/v17
>> [3] KVM CCA v17 integration branch: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/kvm-integration/v17
>> [4] Gmem inplace conversion https://github.com/googleprodkernel/linux-cc/tree/guest_memfd-inplace-conversion-v12
>> [5] TF-RMM https://git.trustedfirmware.org/TF-RMM/tf-rmm.git main (commit: 134266ae)
> 
> I understand that QEMU-virt is not intended to model a realistic
> production platform and that QEMU-SBSA is generally preferred. However,
> I sometimes use QEMU-virt to test functionality quickly because it runs
> slightly faster than QEMU-SBSA.
> 
> I tested this series with QEMU-virt and found that RMM initialization
> failed during boot:
> 
>    [...]
>    INFO:    BL31: Initializing RMM
>    INFO:    RMM init start.
>    ERROR:   RMM init failed: -8
>    WARNING: BL31: RMM initialization failed
> 
> The following TF-A revision was used:
>    https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git master (38269bb)
> 
> After investigating, I found that the failure was caused by the lack of
> a plat_rmmd_reserve_memory() implementation for the QEMU-virt platform
> in TF-A. Adding an implementation equivalent to the QEMU-SBSA one
> resolved the issue:
>      https://git.trustedfirmware.org/plugins/gitiles/TF-A/trusted-firmware-a.git/+/9d594743aa4d4e8160cdf025ea7538041648972c
> 
> Is QEMU virt still intended to be supported as an RME emulation
> platform? In particular, is this functionality simply not implemented
> yet, or is there a reason why RME support is not planned for QEMU virt?
> 
> If this is not the appropriate place to discuss this, please let me

Mathieu, Lorenzo,

Over to you folks :-)

Cheers
Suzuki


> know :)
> 
> Thanks,
> Kohei
> 
>> [6] kvmtool https://gitlab.arm.com/linux-arm/kvmtool-cca.git cca/kvm-v17
>>
>> Known issues: RMMv2.0
>>   * RmiOpMemDonateReq:count (Uint14) is incompatible with RmiAddrRangeDesc4KB
>>    (Uint10) and RmiAddrRangeDesc16KB (Uint12). i.e., a larger contiguous request
>>    may not be satisfiable by the host. Arm is aware of this defect and a spec fix
>>    is in progress.
>>
>>
>> Steven Price (7):
>>    firmware: arm_rmm: Add SMC definitions for calling the RMM
>>    firmware: arm_rmm: Check for RMI support at init
>>    firmware: arm_rmm: Configure the RMM with the host's page size
>>    firmware: arm_rmm: Add support for SRO
>>    firmware: arm_rmm: Activate the RMM
>>    firmware: arm_rmm: Ensure the RMM has GPT entries for memory
>>    firmware: arm_rmm: Add wrappers for Realm related RMI commands
>>
>>   arch/arm64/Kconfig                |   1 +
>>   arch/arm64/kernel/cpufeature.c    |   1 +
>>   drivers/firmware/Kconfig          |   1 +
>>   drivers/firmware/Makefile         |   1 +
>>   drivers/firmware/arm_rmm/Kconfig  |  26 +
>>   drivers/firmware/arm_rmm/Makefile |   2 +
>>   drivers/firmware/arm_rmm/rmi.c    | 819 ++++++++++++++++++++++++++++++
>>   include/linux/arm-rmi-cmds.h      | 678 +++++++++++++++++++++++++
>>   include/linux/arm-smccc-rmi.h     | 494 ++++++++++++++++++
>>   9 files changed, 2023 insertions(+)
>>   create mode 100644 drivers/firmware/arm_rmm/Kconfig
>>   create mode 100644 drivers/firmware/arm_rmm/Makefile
>>   create mode 100644 drivers/firmware/arm_rmm/rmi.c
>>   create mode 100644 include/linux/arm-rmi-cmds.h
>>   create mode 100644 include/linux/arm-smccc-rmi.h
>>
>> -- 
>> 2.43.0
>>

