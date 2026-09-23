Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E84646D086;
	Wed, 23 Sep 2026 22:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202732; cv=none; b=ZVhKfMqoL0im1a1qlF6Kz6JygN8gIJiVq1D8YlDHXp7CzxiCq1qxOAvQxaH+hDOC9wp/popB2Ho0pL9JsATkM6LmV7M//z2OEoldz2w4fWELOBpqDrVQPOl0DJvhO4b8bub5b9APRgPmrAW9d4Pamb+XRPMpIs7PPUyZ2TZs3KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202732; c=relaxed/simple;
	bh=1XPyZl7KcJ8iUJW3sUKhc204l0JzqrgROESCE9y4KLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GxIbSviDW+eV2w8iD20EmZeyqzMO779EGUkhBCjgR0hyGPtYL06fCHTQbMiNkFKErzvuRi92+jQiveWIhF8czQtnKywmsUtiZYeF+5TMe7ginfF4RvSj1V0TJXRcEvUv7gz+kbDAXiILT6OgzgsW6aGNfMi8xs9290XJiHJExqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T4zvA616; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T4zvA616"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FBAE152B;
	Wed, 23 Sep 2026 15:32:03 -0700 (PDT)
Received: from [10.57.8.94] (unknown [10.57.8.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 222A43F632;
	Wed, 23 Sep 2026 15:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790202727; bh=1XPyZl7KcJ8iUJW3sUKhc204l0JzqrgROESCE9y4KLE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T4zvA616YRMKkA/8qFynJksx3CL52m7SBaF34fky4Pck+og5+fqKvcASybEilKkot
	 ijT6stRUsS4dTQlogQOwuIs9kbZG0d1MrlloV46j/ZTIBReieWJvP7OicSZGg4OjML
	 X6BvciaDfsJxBOwHqKV7/Vvo++g94RrgMOcXkVhc=
Message-ID: <12024d6c-b8df-434c-8b63-29f5780a13a0@arm.com>
Date: Wed, 23 Sep 2026 23:31:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 2/7] firmware: arm_rmm: Check for RMI support at init
Content-Language: en-GB
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-3-suzuki.poulose@arm.com>
 <20260914-nano-narwhal-of-blizzard-dbc6a0@sudeepholla>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260914-nano-narwhal-of-blizzard-dbc6a0@sudeepholla>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sudeep,

Apologies, this one took longer to address. Thanks for raising this,
response inline.

On 14/09/2026 11:27, Sudeep Holla wrote:
> On Sat, Sep 12, 2026 at 09:36:05AM +0100, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> Query the RMI version number and check if it is a compatible version.
>> The first two feature registers are read and exposed for future code to
>> use.
>>
>> We only support this for Little Endian kernels, the Big Endian kernel
>> support is anyway marked BROKEN and is being removed.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> [...]
> 
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> new file mode 100644
>> index 0000000000000..9792bf0e00cb9
>> --- /dev/null
>> +++ b/include/linux/arm-rmi-cmds.h
>> @@ -0,0 +1,36 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2026 ARM Ltd.
>> + */
>> +
>> +#ifndef __LINUX_ARM_RMI_CMDS_H_
>> +#define __LINUX_ARM_RMI_CMDS_H_
>> +
>> +#include <linux/arm-smccc-rmi.h>
>> +#include <linux/bug.h>
>> +#include <linux/processor.h>
>> +#include <linux/types.h>
>> +
>> +
>> +/*
>> + * rmi_smccc_invoke: Invoke the RMI call and return the results in @regs_out
>> + * @regs_in: Registers with the arguments filled in.
>> + * @regs_out: Ouptput results from the call.
>> + */
>> +static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
>> +{
>> +	struct arm_smccc_1_2_regs args = *regs;
>> +	unsigned long status;
>> +
>> +	while (1) {
>> +		arm_smccc_1_2_invoke(&args, regs);
>> +		status = RMI_RETURN_STATUS(regs->a0);
>> +		if (status != RMI_BUSY && status != RMI_BLOCKED)
>> +			break;
>> +		cpu_relax();
>> +	}
>> +}
> 
> I haven't done a detailed review, this is just a drive through comment.
> The while(1) gained my attention.
> 
> Should RMI_BLOCKED be returned to the caller instead of retried here?

Short answer yes, to be safe.

> 
> RMM spec defines RMI_BLOCKED as persisting until the Host takes action.
> It also says it is returned when another SRO on the same context is
> incomplete. You may be running it on different CPUs and hence different

I agree this is poorly documented and we are working on improving the
documentation on this front.

RMI_BLOCKED is a side effect of an incomplete operation (in other
words long running) that has turned some "resource" into an
intermediate state. e.g.

The following operations could put objects into an intermediate
state until the RMM completes it, to ensure correctness.

  * Unmap a large IPA range triggering SMMU TLB invalidations.
    For KVM, we serialize the unmap S2 with kvm->mmu_lock with
    write lock. So two operations could not race (even a map
    at the same location).

  * Delegate/Undelegate, which again could end up in SMMU GPC
    invalidations.
    The only case where we race and do parallel "delegate" is
    while handling concurrent VCPU faults on two different physical
    CPUs. Even there a failing thread handles this by returning
    to the guest and taking the fault again (if it wasn't
    resolved by the other thread). We could additionally tighten
    this by using write lock for the fault (just like pKVM).

  * Change the tracking region granularity. e.g, convert from FINE
    granulartiy to COARSE or INTERMEDIATE, causing all granules in
    the target region to be locked. This is not something we do
    in Linux. We mandate the firmware maintains FINE granularity,
    at least for now. Even with dynamic tracking, we don't expect
    to fold the tracking granularity for regions with "mixed"
    entries (which would fail anyway due to the mismatch).

  * An object bound SRO handle is active, while another SRO initiating
    operation is issued. This possible with a buggy host.
    e.g., RMI_REALM_ACTIVATE is called while RMI_RTT_INIT_RIPAS is
    in progress. In KVM we serialize this with kvm->arch.config_lock.

For all practical purposes the above operations should complete in
a single try and another command observing the RMI_BLOCKED should
be able to make progress. That said, for Linux it is better to
return the RMI_BLOCKED back to the caller after an arbitrary
tiny number of times. So I have updated the code to try for
3 times for RMI_BLOCKED and return back to the caller.

We could even drop that and just return back immediately to
the caller. Like I described above, the only case where
we expect to hit the RMI_BLOCKED in Linux is for parallel
faults, which could be handled and/or prevented in Linux.



> context I assume. But this loop takes no such action and hides the status
> from the caller, so a command issued against that context if that can
> happen can spin indefinitely while the operation which would unblock it
> cannot run. Ignore me if it taken care not to happen elsewhere. I am
> just looking at this in isolation.
> 
> Could this retry only RMI_BUSY and propagate RMI_BLOCKED so that the caller
> can arrange for the incomplete operation to make progress if the above
> scenario is possible ?

Ack. I have made the changes in the next version.

Cheers
Suzuki


> 

