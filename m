Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD9A36E489;
	Fri, 25 Sep 2026 09:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327011; cv=none; b=IQV0LTsUDYIOOH9L/pYhyRXLPXGT/1vVQoCY/EAE4VcOXtIMYTW0LOXrojFTpNKQmbgkzedGrYZq6PFhjtDLn/fMz1jKb7A1WNEvEp6qkE1SZErHz4sEZgE9kNLfVeMxSLjpd7Dbvs5xHvOdbO2Dn90Dfhh4xoAkoNGHvfQRBBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327011; c=relaxed/simple;
	bh=sOAlpYevyEEeqo1Lx6FnS3Y7E3aUZb0OVhb2WCb8c0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iBW4n2Wvn2O9cKQNxQ4/KMiN1m4wnPfzltTqs6tEOockIXY8czf90D/J/DbqaMolePlKt4AFXeSv80IzpoGvnC4JT36rNKTITLUQzx7R/p68N+/XQ0xDlAWHXuaZGnzuaWUNAY7JRPJoLDaBITF5mO1fi8T7uBZvpFJig33zvBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ule2hsFw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ule2hsFw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C4DE1758;
	Fri, 25 Sep 2026 02:03:25 -0700 (PDT)
Received: from [10.57.10.88] (unknown [10.57.10.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57A9A3F86C;
	Fri, 25 Sep 2026 02:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790327008; bh=sOAlpYevyEEeqo1Lx6FnS3Y7E3aUZb0OVhb2WCb8c0o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ule2hsFwr8aED801DCcqIgLrUcWuQutUQXVi9350MdfOoGlVbmTrOv7pRQ7HqRVnV
	 gGCzsDpOqeDYg8meXD0+euDrJXWydl1ypuJ6Jvwv4Ofhui1FX7gF81H2fkpJy0kamF
	 eQv78mxZEV1sYyrBH7fDPXjnD3kqprKDEvQuPnHk=
Message-ID: <0c41a8a4-c4b5-4ca7-b1c9-8aaa1958e4bb@arm.com>
Date: Fri, 25 Sep 2026 10:03:23 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 0/7] firmware: arm_rmm: Add RMM v2.0 base RMI support
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <fd404549-9c40-4fdf-9259-104c28b64c76@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <fd404549-9c40-4fdf-9259-104c28b64c76@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/09/2026 07:29, Gavin Shan wrote:
> On 9/24/26 11:51 PM, Suzuki K Poulose wrote:
>> This series adds the generic firmware layer for talking to the Realm
>> Management Monitor (RMM), as specified by the RMM v2.0-bet3
>> specification[1]. It is the first part of the Arm CCA host support that
>> was previously posted as part of the larger KVM series.
>>
>> The split allows this RMM support to be used as a base for other work,
>> including Aneesh's PCI IDE support with Arm CCA RMM as the TSM,
>>   without depending on the KVM Realm support that will follow as separate
>>   series. (See more on that below)
>>
>> The series adds:
>>
>>   * The RMI SMC definitions and direct-call wrappers.
>>
>>   * RMM discovery and version checks during firmware init.
>>
>>   * RMM host configuration, including the host page size.
>>
>>   * Stateful RMI Operation (SRO) infrastructure for commands which the 
>> RMM
>>     can complete across multiple SMC calls while requesting or returning
>>     memory to the host.
>>
>>   * Verification that granule tracking is available at fine granularity.
>>     Fine-grained tracking allows each granule in the system to be tracked
>>     independently, which is required before individual granules can be
>>     delegated. A future series will add support for dynamically supplying
>>     memory to the RMM for this tracking.
>>
>>   * Support for fully firmware-managed systems, where the Granule 
>> Protection
>>     Tables for memory regions are allocated and managed by firmware. 
>> RMM v2.0
>>     also allows dynamic GPT creation on demand; support for that will 
>> be added
>>     in a later series.
>>
>>   * Wrappers for the RMI commands that are used for managing the 
>> "Realm VM"
>>     lifecycle. This is added in to make it easier for the on-going KVM 
>> support
>>     to evolve in parallel pieces.
>>
>> If the platform firmware cannot manage the granule tracking or the 
>> GPTs, we
>> bail out and deactivate the RMM, reclaiming any memory that we have 
>> donated.
>>
>> The RMM v2.0 spec introduces Stateful RMI Operations (SROs), which allow
>> the RMM to complete an operation over several SMC calls while requesting
>> or returning memory to the host. This allows interrupts to be handled in
>> the middle of an operation and lets the RMM dynamically allocate memory
>> for internal tracking purposes. For example, RMI_REC_CREATE no longer
>> needs auxiliary granules to be provided up front, and can instead
>> request memory during the operation.
>>
>> This series applies on v7.3-rc2 and a branch is available at [2]. The KVM
>> CCA support that builds on this series is available at [3] as an 
>> integration
>> branch. The KVM support depends on guest-memfd-in-place conversion 
>> support v13
>> from Ackerley [4], we plan to split that into parts, which apply 
>> cleanly on
>> v7.3-rcx without any dependency and is in progress. This will be made 
>> available
>> as soon as it is ready. Until then [3] shows how this base series 
>> enables KVM
>> CCA support. You may find the tf-RMM [5] and kvmtool support [6] below.
>>
>> [1] RMM spec : https://support.arm.com/documentation/den0137/2-0bet3/
>> [2] This series: https://gitlab.arm.com/linux-arm/linux-cca.git cca/ 
>> cca-host/fw_rmm/v19
>> [3] KVM CCA v17 integration branch: https://gitlab.arm.com/linux-arm/ 
>> linux-cca.git cca/cca/cca-host/kvm-v20/integration
> 
> s/v17/v20 ?

Yikes, I have pushed this in the kvm-v20, with the changes to the 
RMI_RESULT instead of RMI_RETURN etc. So the branch is correct, but the 
description is not. I will rectify that


>> [4] Gmem inplace conversion https://github.com/googleprodkernel/linux- 
>> cc/tree/guest_memfd-inplace-conversion-v13
>> [5] TF-RMM https://git.trustedfirmware.org/TF-RMM/tf-rmm.git main 
>> (commit: 134266ae)
>> [6] kvmtool https://gitlab.arm.com/linux-arm/kvmtool-cca.git tag:cca- 
>> kvm-v20 (Also cca/kvm-v18)
>>
>> Known issues: RMMv2.0 spec.
>>   * RmiOpMemDonateReq:count (Uint14) is incompatible with 
>> RmiAddrRangeDesc4KB
>>    (Uint10) and RmiAddrRangeDesc16KB (Uint12). i.e., a larger 
>> contiguous request
>>    may not be satisfiable by the host. This is resolved in the RMM 
>> spec, by clamping
>>    the upper limit on the number to match the RmiAddrRangeDesc* and 
>> will be published
>>    in the next release.
>>   * RMM to clarify the scenarios that triggers the RMI_BLOCKED and the
>>     recommendations to limit the cases.
>>
> 
> Applied this series on top of upstream linux v7.3.rc4. The built kernel 
> can boot up on
> GH200 machine and CCA host emulated by QEMU with various combinations: 
> 4KB or 64KB base
> page size, CONFIG_ARM_RMM_RMI is {Y, N}. The RMI is only detected and 
> configured on CCA
> host when the base page size is 4KB because RMM only support 4KB granule 
> size at present.
> Details can be found from TF-RMM/runtime/rmi/ 
> granule.c::smc_rmm_config_set(). Besides,
> some of the added functions based on the RMI calls aren't covered by the 
> tests obviously.
> So I think this series doesn't introduce regressions at least.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>

Thanks Gavin ! Much appreciated

Cheers
Suzuki
