Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E451442B1D;
	Mon,  7 Sep 2026 12:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783653; cv=none; b=BeJkQdzByLEGonrjo4b6MTSqD5K9oslx+Fbp69+WV2y0sVacurFJC7NuhBQibaGoCaI+4B0nm/iLTXa24nROkmzZKp91Yt6Qf31FVI3PxEpBYv8v9vw5LmA6dNQpmNEjfAbTisSEhUbZ78OqZbuxZjvMXwdYPY2Der/eVu30Kt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783653; c=relaxed/simple;
	bh=YRMJtNQQqjkRAyFPmB5mHo2sxevdzxb5TBdmjNJe4XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PHudK0jsH5VH5HnRBAJKHgLMfLuyiag2ko60KtdnUNWTeOtUaJEwcSWLpffi7rdwIeA4g6JIpnfzDIhs9qnquFwg7iKNd7l5Fw7gfKSYjtSIxNdL2wzGyiWVXAugWxp+bfibvNjOMFud0BWl6yvN6qUe/YfPbh5ogsVl6531zbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IRd/Fwnc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IRd/Fwnc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43FFD1476;
	Mon,  7 Sep 2026 05:20:46 -0700 (PDT)
Received: from [10.57.49.168] (unknown [10.57.49.168])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C9BB3F7D8;
	Mon,  7 Sep 2026 05:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788783650; bh=YRMJtNQQqjkRAyFPmB5mHo2sxevdzxb5TBdmjNJe4XU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IRd/FwncUQaDNv6AQd9Gp4p+ICxvyy6e5lnDjWt/Br0iwGSEZ/VGid22p+7dljYHc
	 ATs14CUj0HTXEPiPopbopOd1Z5FA4UrHp2oMj+ZhcJSipBBU0Joy1sO//A8Da6B4vu
	 eQj2pYQOftjWVsr6zKfnyIbk3OWvv1dK0+VheVVs=
Message-ID: <8ac9a39f-d54a-4a97-b44d-aeaad944f374@arm.com>
Date: Mon, 7 Sep 2026 13:20:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 7/7] firmware: arm_rmm: Add wrappers for Realm related
 RMI commands
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-8-suzuki.poulose@arm.com>
 <20260907101022.DDDFD1F00A3A@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260907101022.DDDFD1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/09/2026 11:10, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] RMI wrapper functions silently discard output registers on SMC call errors, preventing error recovery and leaking memory.
> --
> 
> commit a6c85c25d264d328a0bb8014d88418e614ccef39
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Add wrappers for Realm related RMI commands
> 
> Introduce wrappers for the RMI functions needed for creating and managing
> realm guests. This will be used by the KVM to manage the Realms.
> 
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> --- a/include/linux/arm-rmi-cmds.h
>> +++ b/include/linux/arm-rmi-cmds.h
> 
> [ ... ]
> 
>> +static inline long rmi_rtt_data_map(unsigned long rd,
> [ ... ]
>> +{
> [ ... ]
>> +	ret = rmi_sro_execute(&regs);
>> +
>> +	if (ret == RMI_SUCCESS && out_top)
>> +		*out_top = regs.a1;
> 
> [Severity: High]
> If the RMM returns an error like RMI_ERROR_RTT partway through, does this
> discard the intermediate progress in regs.a1 by gating it on RMI_SUCCESS?
> 
> If out_top is lost, it seems KVM wouldn't know where the operation stopped,
> making proper error recovery or partial mapping cleanup impossible.
> 
> [ ... ]
> 
>> +static inline long rmi_rtt_data_unmap(unsigned long rd,
> [ ... ]
>> +{
> [ ... ]
>> +	ret = rmi_sro_execute(&regs);
>> +
>> +	if (ret == RMI_SUCCESS) {
>> +		if (out_top)
>> +			*out_top = regs.a1;
>> +		if (out_range)
>> +			*out_range = regs.a2;
>> +		if (out_count)
>> +			*out_count = regs.a3;
>> +	}
> 
> [Severity: High]
> Can this lead to a leak of physical pages?
> 
> When an error occurs (e.g., RMI_ERROR_RTT due to state conflicts), the RMM
> populates the output registers with the number of successfully unmapped
> pages. Because this is gated behind RMI_SUCCESS, losing out_count means KVM
> loses track of how many physical pages were written to the output address
> list.
> 

The output parameters are only valid when the result is RMI_SUCCESS as
described by the success conditions.


> [ ... ]
> 
>> +static inline long rmi_rtt_destroy(unsigned long rd,
> [ ... ]
>> +{
> [ ... ]
>> +	long ret = rmi_sro_execute(&regs);
>> +
>> +	if (ret == RMI_SUCCESS) {
>> +		if (out_rtt)
>> +			*out_rtt = regs.a1;
>> +		if (out_top)
>> +			*out_top = regs.a2;
>> +	}
> 
> [Severity: High]
> Does discarding these outputs on error prevent diagnosing the destruction
> failure?
> 
> If an RMI_ERROR_RTT occurs, the live IPA location is returned in the output
> registers, but it looks like it gets dropped here since the return code is
> not RMI_SUCCESS.

No, the RMM only returns the out_top when the error is RMI_SUCCESS.

> 
> [ ... ]
> 
>> +static inline long rmi_rtt_unprot_unmap(unsigned long rd,
> [ ... ]
>> +{
> [ ... ]
>> +	long ret = rmi_sro_execute(&regs);
>> +
>> +	if (ret == RMI_SUCCESS) {
>> +		if (out_top)
>> +			*out_top = regs.a1;
>> +		if (out_range)
>> +			*out_range = regs.a2;
>> +		if (out_count)
>> +			*out_count = regs.a3;
>> +	}
> 
> [Severity: High]
> Similar to the data unmap wrapper above, does dropping out_count on a
> non-success return code leak physical pages for unprotected memory?
> 


Same here.

Suzuki
