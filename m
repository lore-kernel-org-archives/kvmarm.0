Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DE146F48C;
	Thu,  1 Oct 2026 06:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790834618; cv=none; b=LeHV1UtaHBLvd5s5fkMyW6s19hOIo+JLmwKLGhItE9SsSHDNsH6ubM/Qvo/fxyM9sJoZZGZZ9roFRl99VieQjqZDeQcVqkPxfGJLpGBW3/qZRJEUzOD/e4wekko82NZ5Yf+T8amEMLQJbSp/n5EToaoD4xHj9ZFHWpv5NNTv5XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790834618; c=relaxed/simple;
	bh=UmDFYi4VZi44gsY2l5hLW+B+SLS8MCgV2XEE1kTsg04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PzJeDwqgQJmZ5xMrEx48265ZSa0nshrUn1zAyGtSFalPI8ZF5H9DiDbWo4oRtRTYY64Jrl5pqudxTh9t8de2pCrXn9C/jdwg7xixIe2ZNqcInLsgGVQZOLFXgFbqkN58/6P+KMRK9wgfHnrVjLPZcUglmjB/m/DuCxy00+cl/QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f2N+hp8k; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f2N+hp8k"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8854A497;
	Wed, 30 Sep 2026 23:03:23 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18D783F85F;
	Wed, 30 Sep 2026 23:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790834606; bh=UmDFYi4VZi44gsY2l5hLW+B+SLS8MCgV2XEE1kTsg04=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f2N+hp8kFMkySuRyXVB5soAwjfn6ZommH5+uwNUl+QJAcpICMNmynkGWcZDvkJRfC
	 StFYKHE44CP58pHq26kBe+5LwI+4bVK54mrd5E9A9j3Tl743spppGpoR1kb7BqEGH6
	 jp2/y9Ij4YtYG7r2/Al/V0DHN65B9omwas9q1Jlg=
Message-ID: <b4af8478-f02c-4c94-afea-7bd0adbe7b79@arm.com>
Date: Thu, 1 Oct 2026 07:03:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 2/9] firmware: arm_rmm: Check for RMI support at init
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-3-suzuki.poulose@arm.com>
 <20260929222840.A0E821F000FF@smtp.kernel.org>
 <a2fa2bd1-6888-4ed5-9e2f-233eacb600a5@arm.com> <arzsUdIEVvafG-S5@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <arzsUdIEVvafG-S5@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30/09/2026 12:02, Catalin Marinas wrote:
> On Wed, Sep 30, 2026 at 09:18:48AM +0100, Suzuki K Poulose wrote:
>> On 29/09/2026 23:28, sashiko-bot@kernel.org wrote:
>>>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>>>> new file mode 100644
>>>> index 0000000000000..911489b636522
>>>> --- /dev/null
>>>> +++ b/include/linux/arm-rmi-cmds.h
>>> [ ... ]
>>>> +static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
>>>> +{
>>>> +	struct arm_smccc_1_2_regs args = *regs;
>>>> +	long status;
>>>> +	int i = 0;
>>>> +
>>>> +	while (i < RMM_BLOCKED_RETRY_COUNT) {
>>>> +		arm_smccc_1_2_invoke(&args, regs);
>>>> +
>>>> +		status = RMI_RESULT_STATUS(regs->a0);
>>>> +		if (status != RMI_BUSY && status != RMI_BLOCKED)
>>>> +			break;
>>>> +		if (status == RMI_BLOCKED)
>>>> +			i++;
>>>> +		cpu_relax();
>>>> +	}
>>>
>>> [Severity: High]
>>> Does this sequence create an unbounded spin loop if the firmware continuously
>>> returns RMI_BUSY?
>>>
>>> If the status returned by arm_smccc_1_2_invoke() is RMI_BUSY, the loop
>>> continues without incrementing the exit counter i. It issues cpu_relax()
>>> but does not yield the CPU (e.g., via cond_resched()) or impose a timeout.
>>> If the RMM firmware remains busy, this could cause the host kernel to lock
>>> up indefinitely.
>>
>> This is like "spinlock contention". RMM returns EBUSY when a resource is
>> locked temporarily. We should be able to make progress, unlike the
>> RMI_BLOCKED, which is blocking due to a long running operation.
> 
> I dug a bit into the RMI_BUSY description in the spec and it's not
> always safe to spin forever. For RMI_{PDEV,VDEV}_COMMUNICATE, for
> example, we need to return to the caller and retry later (for VDEV, the
> spec suggests informing the realm). That's the TSM series, which doesn't
> use the new API yet, but something to be aware of when it's updated.

Agree. There RMI_BUSY indicates the Pdev is busy with an ongoing
communication which could take longer.

> 
> We may need the spec to bound this spin anyway, or at least give an
> indication that it's not forever, otherwise it affects latency,
> especially in an RT kernel.
> 
> There's a generic RMI command return code table in B4.2 that lists
> RMI_BUSY for an imp def reason for the command failing to make progress.
> Does this apply to something like REC_ENTER? In the KVM series we call
> that with IRQs masked.

REC_ENTER only tries to lock the REC object. The only other code that
tries to lock is the PSCI completion processing to update the "rec"
state to runnable. Hence we don't expect a the REC_ENTER to be waiting
for the REC object lock and encounter an RMI_BUSY. Also, REC_ENTER
locks the object to get a refcount on the granule and the lock is
released. So even if the host issued REC_ENTER in parallel, the second
one will encounter RMI_ERROR_REC due to the bumped refcount.

That said, I am happy to return to the caller on RMI_REC_ENTER in the 
worst case and pretend there was an IRQ and that would allow the KVM
to re-enter the guest after servicing the interrupts. I have added the 
following changes to the patch where we introduce the REC_ENTER:

+/*
+ * rmi_smccc_invoke_once: Invoke the RMI call and return the results. 
Do not
+ * retry the command. Let the caller deal with RMI_BUSY or RMI_BLOCKED.
+ */
+static inline void rmi_smccc_invoke_once(struct arm_smccc_1_2_regs *regs)
+{
+       struct arm_smccc_1_2_regs args = *regs;
+
+       arm_smccc_1_2_invoke(&args, regs);
+}
+

...


+/**
+ * rmi_rec_enter() - Enter a REC
+ * @rec: PA of the target REC
+ * @run_ptr: PA of RecRun structure
+ *
+ * Starts (or continues) execution within a REC.
+ *
+ * Return: RMI return code
+ */
+static inline long rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
+{
+       struct arm_smccc_1_2_regs regs = {
+               SMC_RMI_REC_ENTER, rec, run_ptr,
+       };
+
+       rmi_smccc_invoke_once(&regs);
+       return regs.a0;
+}




> We might need different APIs here: one for sleepable callers that does
> cond_resched() (or backs off) while retrying, and one that returns
> -EBUSY, e.g. for TSM, or for commands like REC_ENTER that we don't
> expect to see RMI_BUSY and don't want to spin on.


Ack, done.

Suzuki

