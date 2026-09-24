Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A756241D23C;
	Thu, 24 Sep 2026 23:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790291934; cv=none; b=m+utQOrnXFeMl53W+N6wI5csR/2V50Qd43A2BZfWSQXZk6RW05hvjW7YIdk8kPaEQknlUMT/f9dZ7qeNHK6nDsqm8ekJInznM1UbHgNyHFvkgxoujE1WioiKO5iPi8yU7dU/pkaILrVYPos3Ahl2syg0xdMfg+hIoKZq3JGar14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790291934; c=relaxed/simple;
	bh=EMMUNFyB1PUTqCDsa5CKWLLr4IbRaMN1Zan3hUAnon4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JJ9YtflhkhqsyyatvlgkcADkydkM1jLq2HCcYbXCZ9lH41v81RLr/5EK1beV+XI34jrYH0on8ynNnIi345CIbjZl/cuJ3dtybZMmjbvaWet2q7MIb/COcefjCvavq2qoQgeLuKwnFM8lZV6609G4OMAuMWL6KiZ//BMRwa9I6O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KkXPizQR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KkXPizQR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C2421E5E;
	Thu, 24 Sep 2026 16:18:48 -0700 (PDT)
Received: from [10.57.10.88] (unknown [10.57.10.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E8793F632;
	Thu, 24 Sep 2026 16:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790291932; bh=EMMUNFyB1PUTqCDsa5CKWLLr4IbRaMN1Zan3hUAnon4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KkXPizQRiO5wKnqRTe8Be1Dum5uOdVN1ZPpb0FEAGes41Sdj2ztg0Bc6+PCe1jNYj
	 996xLPWBYJH2H179ok9NkNxJmTfJJJzmGYwHpBP4neNoxgRNJgG/Tj55oilEG7O6Uh
	 wxk5C2cosiGR1RCa2WFJfE6XixaN7CUmVmu9KeoU=
Message-ID: <6a6eef51-a2c0-47cf-98d8-526ab8ebf963@arm.com>
Date: Fri, 25 Sep 2026 00:18:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-5-suzuki.poulose@arm.com>
 <20260924140847.AFA411F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260924140847.AFA411F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/09/2026 15:08, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] arm_rmm: SRO cancellation loop prematurely exits, leaving operations suspended
> --
> 
> commit 95084224252b24a8efc8b9db3fa71d3058e8d228
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Add support for SRO
>      
> RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
> commit adds support for executing SROs, including donating and reclaiming
> memory dynamically as requested by the RMM. It also implements cancellation
> support for these operations.
> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index c9ea964fd9081..035f21d3f26b6 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> 
> [ ... ]
> 
>> +		if (ret) {
>> +			/*
>> +			 * All memory donating SROs must be cancellable. So a
>> +			 * failure in memory allocation shouldn't be an issue.
>> +			 * However, if we encounter a random failure (e.g.,
>> +			 * buggy RMM), don't loop forever, just give up.
>> +			 */
>> +			if (WARN_ON_ONCE(!can_cancel))
>> +				return ret;
>> +			/*
>> +			 * If we have already cancelled, and came back here due
>> +			 * to an error in MEMREQ, then there is no point
>> +			 * in going in loops.
>> +			 */
>> +			if (WARN_ON_ONCE(cancelled))
>> +				break;
>> +			rmi_op_cancel(sro_handle, regs);
>> +			cancelled = true;
>> +
>> +			if (WARN_ON_ONCE(RMI_RESULT_STATUS(regs->a0) != RMI_INCOMPLETE))
>> +				return ret;
> 
> [Severity: High]
> Does this error path permanently leave the SRO suspended in the RMM?
> 
> The commit message notes that after requesting cancellation, the host must
> still "continue the operation until it has completed (otherwise the incomplete
> operation may cause future RMM operations to fail)".
> 
> However, when rmi_op_cancel() issues SMC_RMI_OP_CANCEL, it returns RMI_SUCCESS

This is wrong. RMI_OP_CANCEL returns RMI_INCOMPLETE. It doesn't return 
RMI_SUCCESS. See Section B4.3.2.5 Cancelling an SRO (DEN0137 Beta3)

Rules RVLNV and GGSTJ covers both cases (with or without memory 
reclamation). Both cases end up in RMI_INCOMPLETE, and the 
RMI_OP_CONTINUE must be invoked to drive the SRO handle to inactive.


> to acknowledge the cancel request, overwriting regs->a0. As a result,
> RMI_RESULT_STATUS(regs->a0) != RMI_INCOMPLETE evaluates to true, triggering
> this WARN_ON_ONCE and causing an immediate return. The host fails to issue the
> required SMC_RMI_OP_CONTINUE calls to drive the cancellation to completion.

> 
>> +		}
>> +	}
>> +
>> +	if (cancelled)
>> +		return -ECANCELED;
>> +
>> +	return regs->a0;
>> +}
>> +EXPORT_SYMBOL_GPL(rmi_sro_memxfer_execute);
> 
> [ ... ]
> 
>> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
>> +{
>> +	bool cancelled = false;
>> +	unsigned long sro_handle = regs->a1;
>> +
>> +	rmi_smccc_invoke(regs);
>> +
>> +	sro_handle = regs->a1;
>> +	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {
>> +		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
>> +
>> +		switch (RMI_RESULT_MEMREQ(regs->a0)) {
>> +		case RMI_OP_MEM_REQ_NONE:
>> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
>> +					regs);
>> +			break;
>> +		default:
>> +			WARN_ON_ONCE(1);
>> +			if (!can_cancel)
>> +				return regs->a0;
>> +			/*
>> +			 * We can't get here normally, but handle this anyway
>> +			 * for a buggy RMM implementation.
>> +			 */
>> +			if (cancelled)
>> +				return -ECANCELED;
>> +			rmi_op_cancel(sro_handle, regs);
>> +			cancelled = true;
>> +		}
>> +	}
> 
> [Severity: High]
> Does this loop terminate prematurely without continuing the cancelled SRO?
> 
> Similar to rmi_sro_memxfer_execute() above, after rmi_op_cancel() updates
> regs->a0 to RMI_SUCCESS, the while loop condition
> (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) evaluates to false. The
> function exits immediately without calling SMC_RMI_OP_CONTINUE to complete
> the cancellation.

As above, this is incorrect.

Cheers
Suzuki

