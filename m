Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42904A3F3B;
	Thu,  1 Oct 2026 13:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861489; cv=none; b=i4PG0VEYpB9r9IZd/A1iARiPtAXdsmRPqnTU8rjyD1SVHPKvhnrpiSp6KVJoIGyMWdOZEO+49bdthfgPdhn5Ni4AqBD/HUanrUN6O84ujl7Rvn3T5Ld+RCESINlFAIbkrKmt/vjsBfsuMy0Dz7h1BYnaZ0gzM8dNKyHHZcPdUtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861489; c=relaxed/simple;
	bh=9JUs2LAw7B8Ji/NW+YFWdHTHNXeYLFb0WQgfRlzCUoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LEjxIvQJoYnzJJIKQ62SjrYS75Yk191LM75A+zG/jUXxM576ViKzWyHHHIfMV+yEbTrRYl7ue07KSEtoBlnJV+dxN2EVrby0x7dgo6m+mZpmEs3WDOWgMqZ2NAiBYr9NLbHLapdsCTDRT57ZgMDQwWwMl7XYNbzZgdDrdWPrJhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q82XEx/S; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q82XEx/S"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E05E3497;
	Thu,  1 Oct 2026 06:31:19 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1339C3F86F;
	Thu,  1 Oct 2026 06:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790861483; bh=9JUs2LAw7B8Ji/NW+YFWdHTHNXeYLFb0WQgfRlzCUoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q82XEx/SD1LWxYLGdZs4ctb0uFndIPn8h5YMgtGCxWt6Qv6ZOkaKRgvMYwrJzYXgV
	 OdEpEG0APgHLpsH4K5HmpWVb5Yvh9PwGO5ou0kicw9b6qL+9u9N6u9F0q5y6QU7r82
	 HAa/kgOIwvn0p4W6VQBErzSiux9Nk8M6jq0kGoYg=
Message-ID: <289cb9bc-f591-4f53-a710-c86159356213@arm.com>
Date: Thu, 1 Oct 2026 14:31:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 8/9] firmware: arm_rmm: Add wrappers for Realm related
 RMI commands
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
 <20261001084555.1456543-9-suzuki.poulose@arm.com> <ar5Y_pHBUQHbXr85@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ar5Y_pHBUQHbXr85@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/10/2026 13:58, Catalin Marinas wrote:
> On Thu, Oct 01, 2026 at 09:45:54AM +0100, Suzuki K Poulose wrote:
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> index 5d005054f3c6c..e3503aba646e2 100644
>> --- a/include/linux/arm-rmi-cmds.h
>> +++ b/include/linux/arm-rmi-cmds.h
>> @@ -53,6 +53,17 @@ static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
>>   	}
>>   }
>>   
>> +/*
>> + * rmi_smccc_invoke_once: Invoke the RMI call and return the results. Do not
>> + * retry the command. Let the caller deal with RMI_BUSY or RMI_BLOCKED.
>> + */
>> +static inline void rmi_smccc_invoke_once(struct arm_smccc_1_2_regs *regs)
>> +{
>> +	struct arm_smccc_1_2_regs args = *regs;
>> +
>> +	arm_smccc_1_2_invoke(&args, regs);
>> +}
> 
> Nit: I don't think we need to copy to args since there's no retry here.
> 
> That said, the SMCCC call clobbers regs->a0. We should write a comment

Ack. I will add the comment, similar to what we have for rmi_smccc_invoke().

> in case the caller thinks it can just retry with the same regs.
> Alternatively, we could pass args and res structures separately.

I thought about it, but settled in for copying the arguments.

> 
>> +/**
>> + * rmi_rec_destroy() - Destroy a REC
>> + * @rec: PA of the target REC
>> + * @sro: Allocated SRO context to be used
>> + *
>> + * Destroys a REC. The REC must not be running.
>> + *
>> + * Return: 0 on success, positive RMI result code or negative Linux error code
>> + */
>> +static inline long rmi_rec_destroy(unsigned long rec,
>> +				   struct rmi_sro_state *sro)
>> +{
>> +	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_REC_DESTROY, rec);
>> +}
>> +
>> +/**
>> + * rmi_rec_enter() - Enter a REC
>> + * @rec: PA of the target REC
>> + * @run_ptr: PA of RecRun structure
>> + *
>> + * Starts (or continues) execution within a REC.
>> + *
>> + * Return: RMI return code
>> + */
>> +static inline long rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
> 
> Nit: should probably be __always_inline. rmi_rec_destroy() and
> rmi_smccc_invoke_once() as well.

Ack.

> 
> Not for this series but something claude spotted in the integration
> branch - kvm_rec_enter() is noinstr. On this path, we end up in
> arm_smccc_1_1_get_conduit() which is not noinstr (again, that's for the
> other series; here just __always_inline should suffice).

Good point. I will address this in the other series. May be we can
always do SMC. We don't support CCA over pKVM yet. Even there, may
be SMC counduit is available ?

i.e., arm_smccc_1_2_smc() instead of arm_smccc_1_2_invoke()

> 
>> +{
>> +	struct arm_smccc_1_2_regs regs = {
>> +		SMC_RMI_REC_ENTER, rec, run_ptr,
>> +	};
>> +
>> +	rmi_smccc_invoke_once(&regs);
>> +	return regs.a0;
> 
> Should this use RMI_RESULT_STATUS(regs.a0)?

No. We should always return the full result.

> 
> The rest looks fine to me.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks Catalin

Suzuki

