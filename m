Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D074963C1;
	Mon, 28 Sep 2026 10:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790590431; cv=none; b=mlo9zmOhYIyLOsaA+cz9GLPeGhXpgeFqtozpwyWUDU+I8MbCQzfKoFjFHEUYV7Daoq+y1K5Lj7xAr2LXBKBXe6DCzh4vmkRBU61eTon213i0KzeIGOHL4L5Whi57ZwE+j24/j51oKA+uRZSAaHk+TPE/IHfP0uXsTb7o2EHK/s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790590431; c=relaxed/simple;
	bh=L4rj5sebU0MgVvbIqYSRSR7LTOTUxoD15WXyP2ljPok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ckaujv0NF8Du1ThoddQ3PWA2z+PWpX5nGv9LcSu785L1o5lolhyhaiHYIOWUGZU5kxCFHLCzzv/47QIpw+2EVMbx21XfaQe/ay2zytBoT9otsRIMNQqQn75OSurTChKL4ivoOO3UkMrB0VoMXyoz/8MAlZrBGCkPku23bpfSlow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FtXcuGe5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FtXcuGe5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83A0D1595;
	Mon, 28 Sep 2026 03:13:40 -0700 (PDT)
Received: from [10.57.12.79] (unknown [10.57.12.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F3253F86F;
	Mon, 28 Sep 2026 03:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790590424; bh=L4rj5sebU0MgVvbIqYSRSR7LTOTUxoD15WXyP2ljPok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FtXcuGe5Bf9/0/FkzKwLKEy+JoJg8ovzaYSX2D2/AliXaV5Mu/9pP37XIhE5v6fV3
	 zwG/SPm1X9FHl8h9u4+rG242LQ2Y7sNXNJEj09s0mPMYE1rl1NvyZRqzOeDT+hBKCE
	 BAvBPp1hyT7DyFZ0607j5nyKtRA6XXRnoD1oNYF4=
Message-ID: <4fabad44-280f-40e6-95bb-49011cd2f185@arm.com>
Date: Mon, 28 Sep 2026 11:13:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
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
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Gareth Stockwell <Gareth.Stockwell@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-5-suzuki.poulose@arm.com> <arozNIQ-fQ0XQViI@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <arozNIQ-fQ0XQViI@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/09/2026 10:28, Catalin Marinas wrote:
> On Thu, Sep 24, 2026 at 02:51:58PM +0100, Suzuki K Poulose wrote:
>> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
>> +{
>> +	struct arm_smccc_1_2_regs *regs = &sro->regs;
>> +	bool cancelled = false;
>> +	unsigned long sro_handle;
>> +
>> +	rmi_smccc_invoke(regs);
>> +
>> +	sro_handle = regs->a1;
>> +	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {
>> +		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
>> +		int ret = 0;
>> +
>> +		switch (RMI_RESULT_MEMREQ(regs->a0)) {
>> +		case RMI_OP_MEM_REQ_NONE:
>> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
>> +					regs);
>> +			break;
>> +		case RMI_OP_MEM_REQ_DONATE:
>> +			ret = rmi_sro_donate(sro, sro_handle, regs->a2, regs,
>> +					     gfp);
>> +			break;
>> +		case RMI_OP_MEM_REQ_RECLAIM:
>> +			ret = rmi_sro_reclaim(sro, sro_handle, regs);
>> +			break;
>> +		default:
>> +			WARN_ON_ONCE(1);
>> +			ret = -ENXIO;
>> +			break;
>> +		}
> 
> Another thing I came across while looking whether we can defer the
> activation. It seems that the spec (I_JVYCH) lists some SROs as
> PE-bound. Nothing here or in rmi_sro_execute() disables migration and
> the memory allocation paths can even sleep with GFP_KERNEL.

No, this is not required. I agree this is confusing. I will get it
clarified.

So, there are two different sources for the SRO contexts. One is a 
global pool and the other an Object.

e.g., For an RMI operation on an Object, SRO context can be the object
itself (e.g., REC_CREATE, REALM_ACTIVATE etc.)

However, when there is no reliable object for the command (e.g., 
RMI_GRANULE_RANGE_DELEGATE), the RMM must allocate a context from
the global pool. Now, the "PE" in there comes from a recommendation
to the RMM implementations, that the global pool size must depend on
the number of PEs on the system. This doesn't mean that the SRO
handles are only bound to those PEs. I will get this clarified
in the RMM spec.

Cheers
Suzuki



> 
> Do we need to disable preemption (only for rmi_sro_execute()) or at
> least migration (the memxfer path)? We did something similar for the RSI
> attestation token loop, commit 24f55f511b9e ("virt: arm-cca-guest: use
> migrate_disable() for attestation token requests").
> 
> With only migration disabled, another thread on the same CPU
> issuing a PE-bound SRO would get RMI_BLOCKED (R_NDXSG). In theory, we
> can get a priority inversion case (maybe this doesn't happen with the
> current implementation, just looking at the API design). The RMI_BLOCKED
> fix not to loop forever probably saves us but the caller would have to
> actively sleep or give up before retrying (i.e. don't move the busy loop
> higher app the call stack).
> 
> Another option is to have a per-CPU mutex here and serialise the SROs
> which are PE-bound (there are some precedents for per-CPU mutexes in the
> kernel).
> 

