Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91EC8468C06;
	Wed, 30 Sep 2026 11:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790766773; cv=none; b=r9vo9ErjeB2Y2IwILFyBERkGTop01UVhFc+kYtLDDU7VQZT5RcV4LUGLY/lKZY4WvfOQdmRg9y0d3Wea0jqUo+IGer/fmYh5C6q4dNs/9AgaTjxl/V0avmb2perSRzVuEAupnv6fazd4Gs6NO+8TsVOpMNwjWRwz3+pX1cr9uPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790766773; c=relaxed/simple;
	bh=mGVGsgI+LoKKOBBSuTeiqQ/U4Wa7b7v4sQLVV1j3RUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PnGKStUuOxqlKAAFcfVxYnNAgJuVM0gsJ1ChbBcr2NZ+7DgKAU4DEpIH5zUpKaauG3PVm7BY/Dm4g+BWP4s/lZxwlI+zD6ORU/DnfvZO5GwRfYTLEWSFGYib/tkGsLAcU3GOddh6W3xUCVd25gqZ2jW/5glWZQwQPGP+fLB9fdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JKNynVOw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JKNynVOw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A506E497;
	Wed, 30 Sep 2026 04:12:47 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94F263F86F;
	Wed, 30 Sep 2026 04:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790766771; bh=mGVGsgI+LoKKOBBSuTeiqQ/U4Wa7b7v4sQLVV1j3RUg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JKNynVOwYWLWdlva3F5wvNG6YjN8ks30JQEHIlFc4eTde+VcWvns2RKVRyMpiZ6mN
	 OB+6TqoTqR6q07OZyAwYdKbTaAcvNZnXC2PM4TsMV/6D9h5mLSmWvxqsODPaPxfJfk
	 DV0ZRcH0K7if5MLGJczbgRRPIVYrWQTee0kNPo7I=
Message-ID: <d012e283-b7d8-439b-9b09-a88b07dc5d2b@arm.com>
Date: Wed, 30 Sep 2026 12:12:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 8/9] firmware: arm_rmm: Add wrappers for Realm related
 RMI commands
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Gavin Shan
 <gshan@redhat.com>, Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-9-suzuki.poulose@arm.com>
 <20260929222936.8344F1F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260929222936.8344F1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/09/2026 23:29, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] arm_rmm: Range-based RMI wrappers drop progress indicator on error, risking GPF
> - [High] arm_rmm: SRO cancellation flow aborts prematurely, leaving SRO dangling
> --
> 
> commit 206f9f5530d9fa5eb129cd6fc6e598e72857683a
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Add wrappers for Realm related RMI commands
> 
> This commit introduces static inline wrappers for executing Realm
> Management Interface (RMI) commands. These wrappers call into lower-level
> SMC execution functions to manage Realm guests.
> 
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> index 5d005054f3c6c..4f0d6a8006a4a 100644
>> --- a/include/linux/arm-rmi-cmds.h
>> +++ b/include/linux/arm-rmi-cmds.h
>> @@ -104,4 +104,464 @@ static inline bool is_rmi_available(void)
>>   }
>>   #endif	/* CONFIG_ARM_RMM_RMI */
>>   
>> +
>> +/**
>> + * rmi_rtt_data_map_init() - Create a mapping at protected IPA, copying contents
>> + *			     from a given non-secure source granule.
>> + * @rd: PA of the RD
>> + * @data: PA of the target granule mapped in the guest
>> + * @ipa: IPA at which the granule @data will be mapped in the guest
>> + * @src: PA of the source granule with contents
>> + * @flags: RMI_MEASURE_CONTENT if the contents should be measured
>> + *
>> + * Create a mapping from Protected IPA space to conventional memory, copying
>> + * contents from a Non-secure Granule provided by the caller.
>> + *
>> + * Return: 0 on success, positive RMI result code or negative Linux error code
>> + */
>> +static inline long rmi_rtt_data_map_init(unsigned long rd, unsigned long data,
>> +					 unsigned long ipa, unsigned long src,
>> +					 unsigned long flags)
>> +{
>> +	struct arm_smccc_1_2_regs regs = {
>> +		SMC_RMI_RTT_DATA_MAP_INIT, rd, data, ipa, src, flags
>> +	};
>> +
>> +	return rmi_sro_execute(&regs);
> 
> [Severity: High]
> Does the SRO cancellation flow in the underlying rmi_sro_execute() and
> rmi_sro_memxfer_execute() abort prematurely when returning to these wrappers?
> 
> In rmi_sro_execute(), the cancellation path does this:
> 
> 	rmi_op_cancel(sro_handle, regs);
> 	cancelled = true;
> 
> According to the RMM specification, SMC_RMI_OP_CANCEL returns RMI_SUCCESS when
> accepted. Since RMI_SUCCESS is 0, the loop condition in rmi_sro_execute():

RMI_OP_CANCEL never returns RMI_SUCCESS. It returns RMI_INCOMPLETE to 
trigger any memory reclaim paths. See R-RVLNV and R-GGSTJ

> 
> 	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE)
> 
> evaluates to false. This breaks out of the loop and skips the mandatory
> RMI_OP_CONTINUE calls needed to fully unwind the SRO.

As above.

> 
> Similarly, in rmi_sro_memxfer_execute(), there is an explicit assertion:
> 
> 	if (WARN_ON_ONCE(RMI_RESULT_STATUS(regs->a0) != RMI_INCOMPLETE))
> 		return ret;
> 
> which immediately aborts when rmi_op_cancel() correctly returns RMI_SUCCESS.
> 
> Can this leave SRO operations permanently in the CANCELLING state within the
> RMM, leading to resource leaks and preventing realms from being properly
> destroyed?
> 
> [ ... ]
> 
>> +static inline long rmi_rtt_data_unmap(unsigned long rd,
>> +				      unsigned long base,
>> +				      unsigned long top,
>> +				      unsigned long flags,
>> +				      unsigned long oaddr,
>> +				      unsigned long *out_top,
>> +				      unsigned long *out_range,
>> +				      unsigned long *out_count)
>> +{
>> +	struct arm_smccc_1_2_regs regs = {
>> +		SMC_RMI_RTT_DATA_UNMAP, rd, base, top, flags, oaddr
>> +	};
>> +	long ret;
>> +
>> +	ret = rmi_sro_execute(&regs);
>> +
>> +	if (ret != RMI_SUCCESS)
>> +		return ret;
>> +
>> +	if (out_top)
>> +		*out_top = regs.a1;
> 
> [Severity: Critical]
> If a range-based RMI SRO executes partially and returns an error (such as
> RMI_ERROR_INPUT), the architecture specifies that the address of the first
> unprocessed granule is returned in regs.a1.
> 
> Does this wrapper drop the Top progress marker on failure?

This is wrong. If the RMM encounters a failure after partial progress,
RMI_SUCCESS with partial response is returned. The next call would
encounter the RMI_ERROR_INPUT. Also see the following known issue in the
cover-letter:

* Clarify RMI_RTT_DATA_UNMAP, output_count, output_range are only valid 
when result is RMI_SUCCESS (FENIMORE-1746)

Suzuki


