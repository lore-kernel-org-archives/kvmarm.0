Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233B837C108;
	Fri, 25 Sep 2026 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790348565; cv=none; b=cqSiyEAxp3Yg6HBs2d6oznekiUS6mNJL4QrtJVwh4yKCmM4rTvTHC5V+avBT4wXoykOPzrDlKmxTcFf5gAg4XeHN8zEl63cvaTtgRo91JbBKmFMXPVSgSlbQ1Yf9FXNZFl0/bx4ppMTD+0qHlS7K00J19sZCDbu3vFVLCNR/+GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790348565; c=relaxed/simple;
	bh=85LE8mJXVs6JArsgWcvXfC7Xtvt9iQDJisLQSCB8z5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YzjfCutAqYOULItQl5W5CUujrvYjTSZn3JLYs6t6JvR783oKGQACCkL1p29UF8KyiXfLVKY75N21qtvxB4HAq/y/190YiZAr9Q36P9t3vWrSR1kHATH4Sy8aolTGb0TTVwCRm6Q1WYX2ioGKwLze/QIJ5+wOhCnvMCpsUv/52Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H5MONHZC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H5MONHZC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C359C1688;
	Fri, 25 Sep 2026 08:02:25 -0700 (PDT)
Received: from [10.57.10.17] (unknown [10.57.10.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 223813F85F;
	Fri, 25 Sep 2026 08:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790348549; bh=85LE8mJXVs6JArsgWcvXfC7Xtvt9iQDJisLQSCB8z5M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H5MONHZCwvGc1eZswUFSIojrHQj6YlW7HZ5fNwn+jQVdGMqH/vBhYivsTR+JAtuyG
	 Z/4jawUWYLuSRUIzDSPuriwInkylUHXsMJhTc4Rj+oQV87AUNcaPhHFRAvPX5/iJGO
	 ZBeCQ+HGppvRK0/Wh/iPt2aKQErK4VUKtP3RuAS4=
Message-ID: <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com>
Date: Fri, 25 Sep 2026 16:02:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 5/7] firmware: arm_rmm: Activate the RMM
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
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-6-suzuki.poulose@arm.com> <arZmXFw5Jw2IbAmA@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <arZmXFw5Jw2IbAmA@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/09/2026 13:17, Catalin Marinas wrote:
> On Thu, Sep 24, 2026 at 02:51:59PM +0100, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> Activate the RMM after the basic configuration. This is a memory
>> transferring stateful operation.
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v17:
>>   * Inline RMM_ACTIVATE command and remove the definitions from arm-rmi-cmds.h
>>   * Use scope-based cleanup to free sro object
>> Changes since v16:
>>   * Split into a new patch
>> ---
>>   drivers/firmware/arm_rmm/rmi.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index 035f21d3f26b6..0859f256e192b 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -834,7 +834,18 @@ static int __init arm64_init_rmi(void)
>>   	if (ret)
>>   		return ret;
>>   
>> -	return 0;
>> +	/* Activate the RMM */
>> +	struct rmi_sro_state *sro __free(kfree) = kmalloc_obj(*sro);
>> +	if (!sro)
>> +		return -ENOMEM;
>> +
>> +	ret = rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
>> +	if (ret) {
>> +		pr_err("RMM activate failed (%d)\n", ret);
>> +		ret = ret < 0 ? ret : -ENXIO;
>> +	}
>> +
>> +	return ret;
> 
> It was raised earlier this year [1] but I'm not sure it concluded. How
> do we handle kexec and kdump? I think RMI_RMM_DEACTIVATE only succeeds
> if nothing is delegated, so it would need all realms torn down first. If
> that's not feasible, we could at least block (non-crash) kexec like pKVM
> does.

You are right, we can't DEACTIVATE until all granules have been
"undelegated" back. Not just the Realms, but also the GPTs/Tracking
Metadata etc would need to be reclaimed (when we get to support
dynamic GPT/Tracking metadata). For now, we should block the kexec.
> 
> Kdump gets even more interesting if it starts accessing delegated pages
> and getting GPF.
> 
> [1] https://lore.kernel.org/r/CABpDEukEO4Y_fg8fv5Nr1_Pw_qOK=2UmioXk=WyPEzoEprPcGA@mail.gmail.com

Kdump may be a bit more easier, as the kdump kernel is supposed to use
the "reserved" region and vmcore access could handle the GPF and
provide "0"s to the reader ? May be this is one case where the
host needs to be able to handle GPFs.

Cheers
Suzuki

> 

