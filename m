Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECA14DC54A
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 16:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772555617; cv=none; b=lmFINYZuMjiim5MUulX22T//RHJSkVYZzz8oH7viOvP2C3dHg9L6Qr+VuouLhDDQb8+YWQdTff/ULlQyaGaUm7nmgMTCbWsDGa9UQsXAcd6owyYnhPkGAY7m6oCTnwcSQ2klXt9RDxKGdlN+UtREO7HN52Slf7amwXCAJr5r5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772555617; c=relaxed/simple;
	bh=FdbJz+2GnMDWrCreI2X/cWqA3lnADEjuc8bvbU9/Iek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tNbqHWYqU9+dhB3/a3/xYa4yYOFbdszSunpHByLxFhl4YXPK6CYy06ZU3DUECsfW4jRbI9qrN+O4GMDyjL1cZQbbpsY/Y7c1uaTNZ2P9pk+AYBimbgrVxnA5NUIIZ65o9u8iZ/MW68XIGfuSZ0bPfwhR5RjEDqgoHNo4jEgRPuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91B8A339;
	Tue,  3 Mar 2026 08:33:28 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5702B3F694;
	Tue,  3 Mar 2026 08:33:30 -0800 (PST)
Message-ID: <fd0cf579-77c4-4a76-bc8e-b19bb7988155@arm.com>
Date: Tue, 3 Mar 2026 16:33:23 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/41] KVM: arm64: Use kernel-space partid
 configuration for hypercalls
To: Marc Zyngier <maz@kernel.org>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev, zengheng4@huawei.com,
 linux-doc@vger.kernel.org, Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-13-ben.horgan@arm.com> <86jyvu85dj.wl-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <86jyvu85dj.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 3/2/26 18:15, Marc Zyngier wrote:
> On Tue, 24 Feb 2026 17:56:51 +0000,
> Ben Horgan <ben.horgan@arm.com> wrote:
>>
>> On nVHE systems whether or not MPAM is enabled, EL2 continues to use
>> partid-0 for hypercalls, even when the host may have configured its kernel
>> threads to use a different partid. 0 may have been assigned to another
>> task. Copy the EL1 MPAM register to EL2. This ensures hypercalls use the
>> same partid as the kernel thread does on the host.
>>
>> Tested-by: Gavin Shan <gshan@redhat.com>
>> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>> Tested-by: Peter Newman <peternewman@google.com>
>> Tested-by: Zeng Heng <zengheng4@huawei.com>
>> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since v2:
>> Use mask
>> Use read_sysreg_el1 to cope with hvhe
>>
>> Changes since v3:
>> Set MPAM2_EL2.MPAMEN to 1 as we rely on that before and after
>> ---
>>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>> index e7790097db93..80e71eeddc03 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>> @@ -638,6 +638,15 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
>>  	unsigned long hcall_min = 0;
>>  	hcall_t hfn;
>>  
>> +	if (system_supports_mpam()) {
>> +		u64 mask = MPAM1_EL1_PARTID_D | MPAM1_EL1_PARTID_I |
>> +			MPAM1_EL1_PMG_D | MPAM1_EL1_PMG_I;
>> +		u64 val = MPAM2_EL2_MPAMEN | (read_sysreg_el1(SYS_MPAM1) & mask);
>> +
>> +		write_sysreg_s(val, SYS_MPAM2_EL2);
>> +		isb();
>> +	}
>> +
>>  	/*
>>  	 * If pKVM has been initialised then reject any calls to the
>>  	 * early "privileged" hypercalls. Note that we cannot reject
> 
> It is extremely debatable whether this is desirable:
> 
> - pKVM really shouldn't be influenced by what the host does, which
>   means reserving PARTIDs and indirecting what the host sees. This can
>   be deferred until pKVM is actually useful upstream.
> 
> - repeatedly hammering that register plus an ISB on the hot path of a
>   hypercall is a sure way to make things worse than they should be,
>   and that should be fixed now.

Would a read modify write be preferable?

> 
> Do you really expect the EL1 settings to change on a regular basis? If

The MPAM EL1 partid/pmg configuration is kept in sync with the MPAM EL0
partid/pmg configuration (see mpam_thread_switch() in patch 4) which
means that the EL1 configuration will change whenever the user changes
the EL0 configuration.

> so, I'd rather you use a specific host hypercall, or even a trap to
> propagate the EL1 configuration. If not, just set it as part of the

I think this ends up trapping context switch which doesn't seem any more
desirable.

> KVM init and be done with it.

If we just forego this patch then the MPAM configuration for el2 as
initially configured, partid=0, pmg=0 would be used. This is also the
default for requestors that aren't MPAM aware or unconfigured, like
trusted firmware, its, gpu. VHE mode (required from 8.1?) should be
available in any platform that has MPAM (introduced in 8.4, back
portable to 8.3) and so using nvhe with MPAM seems unlikely and the
amount of data should be small enough. That leaves pKVM for which,
perhaps, doing nothing is also the correct answer.

What do you think? Drop, read modify write, or something else?

> 
> Thanks,
> 
> 	M.
> 

Thanks,

Ben

