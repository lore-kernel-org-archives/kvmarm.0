Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E7419D8BC;
	Sat, 12 Sep 2026 10:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208904; cv=none; b=rfBX6SZ0frSxF3qDELibRdibRN3FHDywBZL0mPYC9tF91j1hjLcDc0RN+j71KekENTR4cQg4b8QFWd1QbZJkEMfyjGs37LWMMOFd8yEeJBszqAIwLWAkacLKsGZ/hxInzQ99GFYLE9z0ULSA/CUvp1A/KPwPhB0eWw2DiCwv2fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208904; c=relaxed/simple;
	bh=HE6a7xCB9fyBWhSMjmYXu2+SaG5pCmShpeB7NuW8BOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QEQiOR390K6W2GFj7Nl3LKrXJ8Wrj2LT7vTGI77lxY3BjIxOxaZSYjtXS96XMANPzrZoZFNr7jMljN3wJ7BO8PNux6JGjI3w9fItMbWjiaGgNcwr7tEuNYal4kO0GJBbhUyoxbwFTTephqwhXgmxR7kntRJxDsRQPAaPvaOCk+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TUeIR6nA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TUeIR6nA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E5631713;
	Sat, 12 Sep 2026 03:28:17 -0700 (PDT)
Received: from [10.57.10.2] (unknown [10.57.10.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 784C13F7B4;
	Sat, 12 Sep 2026 03:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789208901; bh=HE6a7xCB9fyBWhSMjmYXu2+SaG5pCmShpeB7NuW8BOQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TUeIR6nAdfBig/YdU4Y3FJ9oxgy59GA+iVrT/URmeKkFV4yy5DmsSP6Wqzph4VSNx
	 FxtBScE6O6Z7BWRUsfmOUFV3pO55hTIc5TJnggx+WsI6Kuu8oZjaY1H6NW3PaE2tAg
	 c2Ihk/6NJZZ5FuOtv9qSqp9MkDhDw8CX/IIX38tU=
Message-ID: <74919bee-87c1-41b4-a244-143b6cfc2b01@arm.com>
Date: Sat, 12 Sep 2026 11:28:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-5-suzuki.poulose@arm.com>
 <20260912084847.285771F00898@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260912084847.285771F00898@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/09/2026 09:48, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] `delegated_phys` is used uninitialized on the buggy RMM error path of `rmi_delegate_range()`, causing unpredictable undelegation sizes and leaking/corrupting memory.
> --
> 
> commit 860fe4975d9c1564e207c537f0159673fd509495
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> firmware: arm_rmm: Add support for SRO
> 
> RMM v2.0 introduces Stateful RMI Operations (SRO) where an SMC can return with
> an operation still in progress. The SRO is tracked using a struct rmi_sro_state
> object to manage memory donation and reclamation. This commit provides the core
> infrastructure for SRO and adds delegate/undelegate range wrappers that use it.
> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index 5b0e342ce3d58..4f9898ece7547 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> [ ... ]
>> +int rmi_delegate_range(phys_addr_t phys,
>> +		       unsigned long size,
>> +		       phys_addr_t *out_phys)
>> +{
>> +	long ret = 0;
>> +	unsigned long top = phys + size;
>> +	unsigned long out_top;
>> +
>> +	while (phys < top) {
>> +		ret = rmi_granule_range_delegate(phys, top, &out_top);
>> +
>> +		if (ret == RMI_SUCCESS) {
>> +			/* Buggy RMM ? */
>> +			if (WARN_ON(out_top <= phys)) {
>> +				rmi_undelegate_range(top - size, size);
>> +				return -ENXIO;
>> +			}
> 
> [Severity: High]
> If we take this buggy RMM error path, this function returns -ENXIO immediately
> without setting *out_phys. Does this leave the caller's delegated_phys variable
> uninitialized?
> 
> Also, doesn't rmi_undelegate_range(top - size, size) here undo the entire
> delegation, making the caller's own cleanup logic redundant and potentially
> conflicting?

I have changed this hunk to :

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 4f9898ece7547..bf7ae9a60e22b 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -154,8 +154,8 @@ int rmi_delegate_range(phys_addr_t phys,
                 if (ret == RMI_SUCCESS) {
                         /* Buggy RMM ? */
                         if (WARN_ON(out_top <= phys)) {
-                               rmi_undelegate_range(top - size, size);
-                               return -ENXIO;
+                               ret = -ENXIO;
+                               break;
                         }

Which forces to return the "completed range so far". In any case, 
UNDELEGATE on a mixed region, forces the RMM to skip the "undelegated"
granules and complete the range. So, this is safe from the caller's 
perspective. Also, we don't know how far the RMM progressed in
case of a buggy result.

> 
>> +			phys = out_top;
>> +		} else {
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (out_phys)
>> +		*out_phys = phys;
>> +
>> +	return ret;
>> +}
> [ ... ]
>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>> +				 unsigned long sro_handle,
>> +				 unsigned long donatereq,
>> +				 struct arm_smccc_1_2_regs *out_regs,
>> +				 gfp_t gfp)
>> +{
> [ ... ]
>> +	if (state == RMI_OP_MEM_DELEGATED) {
>> +		phys_addr_t delegated_phys;
>> +
>> +		if (rmi_delegate_range(phys, size, &delegated_phys)) {
>> +			if (!rmi_undelegate_range(phys, delegated_phys - phys))
>> +				free_pages_exact(virt, size);
>> +			return -ENXIO;
>> +		}
> 
> [Severity: High]
> If rmi_delegate_range() returns an error from the buggy RMM path,
> delegated_phys is completely uninitialized.
> 
> Can this result in passing a garbage size (delegated_phys - phys) to
> rmi_undelegate_range(), attempting to undelegate an unpredictable physical
> memory region and preventing free_pages_exact() from executing?

Fixed as above.

> 
>> +	}
> [ ... ]
>> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
>> +				    unsigned long sro_handle,
>> +				    unsigned long donatereq,
>> +				    struct arm_smccc_1_2_regs *out_regs,
>> +				    gfp_t gfp)
>> +{
> [ ... ]
>> +		if (state == RMI_OP_MEM_DELEGATED) {
>> +			phys_addr_t delegated_phys;
>> +
>> +			if (rmi_delegate_range(phys, block_size,
>> +					       &delegated_phys)) {
>> +				if (!rmi_undelegate_range(phys, delegated_phys - phys))
>> +					free_pages_exact(virt, block_size);
>> +				return -ENXIO;
>> +			}
> 
> [Severity: High]
> Similar to rmi_sro_donate_contig(), this code uses delegated_phys uninitialized
> if rmi_delegate_range() takes the buggy RMM error path. Could this lead to
> a similar memory leak and corruption risk?

Fixed as above.

Suzuki

>> +		}
> 

