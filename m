Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E864534A9;
	Wed, 30 Sep 2026 08:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790756345; cv=none; b=l+Zgkb6kxpqfzIR/px2C4xvTGS7jAQbmEuoVKBEvZt9Ri3m+tLkXJvlUnUEms4m2MrJl2e5cAnvfoIP9w/UPrQU11jjE6IMHH+y9xwdpzcNgUt695mbO8UUiacfJaM8ImHeD6R9PNQBcXMr/sNQAku4/7U4PS1R9N5UzlIFZLIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790756345; c=relaxed/simple;
	bh=lfZj10nJ+gasYMBDGKcSc2OvOyFn1EF5uOIn79yazxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XU9thT38LeZqmKKhlcDFCWNPdCHtEBC18PJRy4f6H8tQDcySM86EpDE4HqMhGK/NEeejXGFfFGnmJH3MzsgQ4UJpEujhivHxoJwdo0/5BDJMf4ivv2EEDMlf2HoxElttoi57OfbUZ9ZiNxUyBkds9q2aEmk6GKWEANMRTfAi0jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X4XrG4y1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X4XrG4y1"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CA441477;
	Wed, 30 Sep 2026 01:18:55 -0700 (PDT)
Received: from [192.168.1.148] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B25F33F85F;
	Wed, 30 Sep 2026 01:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790756338; bh=lfZj10nJ+gasYMBDGKcSc2OvOyFn1EF5uOIn79yazxk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X4XrG4y16Lmyoe4sTOZYwsAKt48rAIotXDiltM4j9FIReVUaQnHf9IrOQrN+z0OFJ
	 VsH2FnJlV6yDMnGMECKpp+apeLoZYmM5wO2kDlYapzyCcJ3796TH2yDBgEUIqIFNb6
	 IPiT9bczlCoThFlDr7b7BSnQ8jvXIhCNdA9yO23s=
Message-ID: <a2fa2bd1-6888-4ed5-9e2f-233eacb600a5@arm.com>
Date: Wed, 30 Sep 2026 09:18:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 2/9] firmware: arm_rmm: Check for RMI support at init
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, Marc Zyngier
 <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-3-suzuki.poulose@arm.com>
 <20260929222840.A0E821F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260929222840.A0E821F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/09/2026 23:28, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] arm_rmm: unbounded spin loop on RMI_BUSY without scheduling
> - [Medium] arm_rmm: commit message and code mismatch on feature registers count
> --
> 
> commit 5ddd90a4b6dcf005d84ebc9f9003eb3f383394f8
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Check for RMI support at init
> 
> This commit queries the RMI version to ensure compatibility and reads
> feature registers from the Realm Management Monitor (RMM). It also exposes
> these feature registers for future use.
> 
>> The first two feature registers are read and exposed for future code to
>> use.
> 
> [Severity: Medium]
> Is this description accurate? The commit message explicitly claims that the
> first two feature registers are read, whereas the actual implementation in
> rmi_read_features() iterates over ARRAY_SIZE(rmi_feat_reg_cache) (which is
> 5) to read all 5 feature registers. This looks like the commit message
> might have missed the v19 code change.

Ack. I have fixed this locally.

> 
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> new file mode 100644
>> index 0000000000000..911489b636522
>> --- /dev/null
>> +++ b/include/linux/arm-rmi-cmds.h
> [ ... ]
>> +static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
>> +{
>> +	struct arm_smccc_1_2_regs args = *regs;
>> +	long status;
>> +	int i = 0;
>> +
>> +	while (i < RMM_BLOCKED_RETRY_COUNT) {
>> +		arm_smccc_1_2_invoke(&args, regs);
>> +
>> +		status = RMI_RESULT_STATUS(regs->a0);
>> +		if (status != RMI_BUSY && status != RMI_BLOCKED)
>> +			break;
>> +		if (status == RMI_BLOCKED)
>> +			i++;
>> +		cpu_relax();
>> +	}
> 
> [Severity: High]
> Does this sequence create an unbounded spin loop if the firmware continuously
> returns RMI_BUSY?
> 
> If the status returned by arm_smccc_1_2_invoke() is RMI_BUSY, the loop
> continues without incrementing the exit counter i. It issues cpu_relax()
> but does not yield the CPU (e.g., via cond_resched()) or impose a timeout.
> If the RMM firmware remains busy, this could cause the host kernel to lock
> up indefinitely.

This is like "spinlock contention". RMM returns EBUSY when a resource is
locked temporarily. We should be able to make progress, unlike the
RMI_BLOCKED, which is blocking due to a long running operation.

Cheers
Suzuki

