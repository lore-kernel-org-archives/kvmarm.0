Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BB93E7BBF;
	Thu,  1 Oct 2026 09:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845900; cv=none; b=K/JAeqLh0GTr2V9D4qfnIyaOuzodsjyO2Cf0Jif5glvz+cGpCFIKutZbbeyh8UpQPZRQfnN9AX00rTdE1sSZ7CLg9gJk01DtQLQBmCs7nIOYznkaQfp/rGTMKse8Zevyos8KJL0ZRyINwk8wew1mv6Ye51ufvwPB0yCNU2WOUBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845900; c=relaxed/simple;
	bh=GQrDMdfMqZNswkZK5dFyWnVceo9e29aWWhkScXVyzjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iThmIv2WREBsVVjZUZxVji/2WW4Y1v2HXK3lkv9xzoZAy03YNEW580R7Z44rExI45Znqn59TVH3/gx0eULKmn9MvvJV0seDPTfSRZvbbpXX0dlVGb1Mxn14+0ZBcrTKilUTBGxXPv3t+saEHz1dHCpLQNTWW/+MMXSNOZPaMC2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ufUYSCru; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ufUYSCru"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9757D497;
	Thu,  1 Oct 2026 02:11:34 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BDB343F86F;
	Thu,  1 Oct 2026 02:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790845898; bh=GQrDMdfMqZNswkZK5dFyWnVceo9e29aWWhkScXVyzjw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ufUYSCruKSsgdz5AQlNPK4y4LK9KHDsv7nd6GemQeqNp+/bgncE9xD3ttBnyyqxgp
	 yW4GsFqAV2/s/ErFu2GT4lpgVd14g+qe52yHiioiQYjTtr0gr/tzyth1sfw1THT4mY
	 19QyBDeyP+mJwuEAStC3anS0gKSFObEQ79Qw93a0=
Message-ID: <ea458644-d723-46e2-bd7d-7746e56d7a08@arm.com>
Date: Thu, 1 Oct 2026 10:11:35 +0100
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
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Will Deacon <will@kernel.org>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
 <20261001084555.1456543-9-suzuki.poulose@arm.com>
 <20261001090450.C1CBB1F0089A@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261001090450.C1CBB1F0089A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/10/2026 10:04, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] arm_rmm: dropped out_top on RMI_ERROR_RTT for range commands
> --
> 
> commit 68e63e1b38f1af07d69bbc2eee9306e4bedb8efa
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Add wrappers for Realm related RMI commands
> 
> This commit introduces wrappers for the RMI calls used to create and
> manage realm guests. These inline functions map the standard KVM realm
> operations to their underlying SMCCC interfaces.
> 
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> index 5d005054f3c6c..e3503aba646e2 100644
>> --- a/include/linux/arm-rmi-cmds.h
>> +++ b/include/linux/arm-rmi-cmds.h
> [ ... ]
>> +static inline long rmi_rtt_data_map(unsigned long rd,
>> +				    unsigned long base,
>> +				    unsigned long top,
>> +				    unsigned long flags,
>> +				    unsigned long oaddr,
>> +				    unsigned long *out_top)
>> +{
>> +	struct arm_smccc_1_2_regs regs = {
>> +		SMC_RMI_RTT_DATA_MAP, rd, base, top, flags, oaddr
>> +	};
>> +	long ret;
>> +
>> +	ret = rmi_sro_execute(&regs);
>> +
>> +	if (ret == RMI_SUCCESS && out_top)
>> +		*out_top = regs.a1;
> 
> [Severity: High]
> If this operation encounters an RTT state conflict midway through processing
> the range, the RMM terminates early and returns RMI_ERROR_RTT.
> 

Nope, see below.

> When that happens, the RMM writes the failing IPA to out_top (register x1)
> so the caller knows which pages were successfully processed before the error.
> 
> By restricting the out_top assignment strictly to ret == RMI_SUCCESS, doesn't
> this silently discard the partial progress indicator on RMI_ERROR_RTT, causing
> KVM to lose track of the modified pages?
> 
>> +
>> +	return ret;
>> +}
> [ ... ]
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
> [Severity: High]
> Similarly, if rmi_rtt_data_unmap() encounters an RMI_ERROR_RTT, it returns
> early here without populating out_top.

As explained earlier, out_top is invalid when result != RMI_SUCCESS for
all cases except RMI_RTT_DESTROY.

Suzuki
