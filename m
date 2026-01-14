Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AED2BE056
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768401607; cv=none; b=KuDLsFKXHiF+v4Q8ci8U0M20uAbGK4Q5zAn8vhzDMReaKT85L41hcu27R0aB+0XehFQqBL+TU+LEKz2BdeE4mZPet10hpTtSI5c6WXDMXAG5HO/cm27KsuE8/T8fJwydD7CRQJhpwn2+aQrTXekRTnPphNGtMEN4fZsm6I/somo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768401607; c=relaxed/simple;
	bh=6pTioNudaehgaYePcdWKBdNS5VrsxZK06qKSC5dkqG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nQvcDTgWDtd9OLc032SOPiTNAC2qMNm/l4Ki+KmZt0WBvvbASZt9uiKxSidG5t5Wbt/FmzQMJY21iusNhhyBrgwpjbtsuL0jWTrr2q0acG/yUEMVVsDxIUrFPCbuxf7nGzfmsjzanep5hKP5SMW0P9qzKcU5N9pUqeLyME31saE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DA541515;
	Wed, 14 Jan 2026 06:39:58 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 179563F632;
	Wed, 14 Jan 2026 06:39:59 -0800 (PST)
Message-ID: <b9e10419-b4de-4cb6-93b6-07e878d2072a@arm.com>
Date: Wed, 14 Jan 2026 14:39:58 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/47] KVM: arm64: Use kernel-space partid
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
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-14-ben.horgan@arm.com> <86o6mwl7kl.wl-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <86o6mwl7kl.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 1/14/26 12:09, Marc Zyngier wrote:
> On Mon, 12 Jan 2026 16:58:40 +0000,
> Ben Horgan <ben.horgan@arm.com> wrote:
>>
>> On nVHE systems whether or not MPAM is enabled, EL2 continues to use
>> partid-0 for hypercalls, even when the host may have configured its kernel
>> threads to use a different partid. 0 may have been assigned to another
>> task. Copy the EL1 MPAM register to EL2. This ensures hypercalls use the
>> same partid as the kernel thread does on the host.
>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since v2:
>> Use mask
>> Use read_sysreg_el1 to cope with hvhe
>> ---
>>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>> index a7c689152f68..ad99d8a73a9e 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>> @@ -635,6 +635,14 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
>>  	unsigned long hcall_min = 0;
>>  	hcall_t hfn;
>>  
>> +	if (system_supports_mpam()) {
>> +		u64 mask = MPAM1_EL1_PARTID_D | MPAM1_EL1_PARTID_I |
>> +			MPAM1_EL1_PMG_D | MPAM1_EL1_PMG_I;
>> +
>> +		write_sysreg_s(read_sysreg_el1(SYS_MPAM1) & mask, SYS_MPAM2_EL2);
>> +		isb();
>> +	}
> 
> Is it really OK to not preserve the rest of MPAM2_EL2? This explicitly
> clears MPAM2_EL2.MPAMEN, which feels counter-productive.
> 
> 	M.
> 

There are 3 things to consider:
1. traps - these are only relevant when we leave EL2 and are dealt with
in __activate_traps_mpam(). (This also covers EnMPAMSM which is a
not-trap bit.)
2. MPAM2_EL2.MPAMEN - this is read only as long as we have an EL3 and if
we don't have EL3 will be 0 anyway from el2_setup.h and MPAM won't be
considered supported in the kernel.
3. The alternate partid space fields which are kept as zero and relate
to FEAT_RME.

So, safe. Ok with you or would you rather I make it more obviously safe?

Thanks,

Ben

