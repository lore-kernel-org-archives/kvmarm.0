Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D5883B0AF8;
	Wed, 30 Sep 2026 08:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758015; cv=none; b=IQos7fZdSE9Hm9bwtry3OVyz62LWSShrfG+ry1KbTDLtaGvSUzkCdYtXbMpmpqnBWAILC0s7zktxaxCjKODDyKdFmbUawtGHV8403sV9Dm2ga2jmAAIjv5ikUh7TED3TseDB3uBiRV56OrpcfrJIgn5CjPUISLLDIA+SY+lNSB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758015; c=relaxed/simple;
	bh=TbOx0th03nmS0W8loOgkbUdAvklfLT2M4ddkXiq7sFc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=h/TYauZhd3TXXu2ZtMAUI+Nk8/RCpLkkCwcawOSe7mkwT7R469TVyNqpEkjpSe5J3mm/kiriX2UwQ0QzJ3Q9qDk16UP8demQPlxJN+lOG2bkxsB4D7kEW/1BGwQI8ucMR5tkuExfKI1ZPyDF3qjyDCUBQ4Ms4P8vW2+vwWq9DbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=N+wh5P6E; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="N+wh5P6E"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C270143D;
	Wed, 30 Sep 2026 01:46:42 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C6533F85F;
	Wed, 30 Sep 2026 01:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790758006; bh=TbOx0th03nmS0W8loOgkbUdAvklfLT2M4ddkXiq7sFc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=N+wh5P6EBD64Hpdly5G8CCoRPlBWEpnI4pYrjVoIg30lXApnFaGyysqGtnxl4SqBz
	 307AU1GXS6RzJplrZrtzF1pAL8NeIOGfp4T9R24Zeu+5RS9ZmBS19G8eHAk5zu53OO
	 VwFaplFKHzEv/NUn7G6hRKkk8Fr9BblPL+o8enUw=
Message-ID: <a7f26cee-4378-4d79-853c-759c549544a1@arm.com>
Date: Wed, 30 Sep 2026 09:46:43 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 4/9] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Gavin Shan <gshan@redhat.com>,
 Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
 Steven Price <steven.price@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-5-suzuki.poulose@arm.com>
 <20260929223042.681D61F000FF@smtp.kernel.org>
 <e12fb220-505a-44cc-bc43-4bd4ec0e9f7a@arm.com>
In-Reply-To: <e12fb220-505a-44cc-bc43-4bd4ec0e9f7a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/09/2026 09:45, Suzuki K Poulose wrote:
> Hi,
> 
> Responses inline.
> 
> On 29/09/2026 23:30, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 3 potential 
>> issue(s) to consider:
>> - [Medium] arm_rmm: SRO cancellation discards partial progress limit 
>> leading to memory corruption
>> - [Medium] arm_rmm: integer overflow in granule clamp bypasses RMM 
>> protection
>> - [Medium] arm_rmm: missing validation of block_size_fld leads to 
>> division by zero
>> -- 
>>
>> commit 44837285c82689401d14180cb932077aa7982b67
>> Author: Steven Price <steven.price@arm.com>
>>
>> firmware: arm_rmm: Add support for SRO
>>
>> This commit introduces support for Stateful RMI Operations (SRO), 
>> allowing RMI
>> commands to return incomplete and be resumed. It adds SRO state tracking,
>> memory donation and reclaim handling, and wrappers for SRO commands.
>>
>>> --- a/drivers/firmware/arm_rmm/rmi.c
>>> +++ b/drivers/firmware/arm_rmm/rmi.c
>>> @@ -14,6 +15,687 @@
>>> +static long rmi_granule_range_delegate(unsigned long base,
>>> +                       unsigned long top,
>>> +                       unsigned long *out_top)
>>> +{
>>> +    struct arm_smccc_1_2_regs regs = {
>>> +        SMC_RMI_GRANULE_RANGE_DELEGATE, base, top
>>> +    };
>>> +    long ret = rmi_sro_execute(&regs);
>>> +
>>> +    if (ret == RMI_SUCCESS && out_top)
>>> +        *out_top = regs.a1;
>>> +
>>> +    return ret;
>>> +}
>> [ ... ]
>>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>>> +                 unsigned long sro_handle,
>>> +                 unsigned long donatereq,
>>> +                 struct arm_smccc_1_2_regs *out_regs,
>>> +                 gfp_t gfp)
>>> +{
>> [ ... ]
>>> +mem_donate:
>>> +    rmi_op_mem_donate(sro_handle,
>>> +              virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
>>> +              0, out_regs);
>>> +    donated_size = out_regs->a1 << PAGE_SHIFT;
>>> +
>>> +    if (WARN_ON(donated_size > size))
>>> +        donated_size = size;
>>
>> [Severity: Medium]
>> Is there a risk of an integer overflow here before the bounds check?
>>
>> If a buggy or compromised RMM returns a maliciously large value for
>> out_regs->a1, the left shift by PAGE_SHIFT could overflow the 64-bit
>> donated_size variable. This would result in a small value that bypasses
>> the WARN_ON() check.
> 
> Fair point, this was due to the removal of donated_granules. I will
> rectify this.

I have folded in the following hunk:

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 8d839e9e61424..12075679863c4 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -354,7 +354,7 @@ static int rmi_sro_donate_contig(struct 
rmi_sro_state *sro,
                           0, out_regs);
         donated_size = out_regs->a1 << PAGE_SHIFT;

-       if (WARN_ON(donated_size > size))
+       if (WARN_ON(out_regs->a1 > (size >> PAGE_SHIFT)))
                 donated_size = size;

         /* All granules consumed by the RMM */


Suzuki

