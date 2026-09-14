Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68871371D05;
	Mon, 14 Sep 2026 08:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789373976; cv=none; b=dka2qd+33V6RTQzZ3SiGeakTYiNZ3WBs68TPdEn8DDPg+RSPkJ9cTKKSSt3cMyvhGQq6OpwzeFe5UAd3bjuWjvcmZPiu6q09dNRNCdxX4q7IiuzmnWnvmRNDPo7G73LDPMti5J3t1pHdywFskD14wUoV+j0RPBfVeka0KyeOiS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789373976; c=relaxed/simple;
	bh=m0ynvs3ASpXg1FC+68FV0PXhWfrNCCs02XWVdpFI/DQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=LCbHDmn5Mokbs0SvnuYbCd5tCkWPMx5Gq5SFin9P1x4I4fZqJqbqPpQ7D8OtqVXzYYSyPqazEpf1BSyvIzK/8t3939CIkE/Mpert9ltS9cJsZJqwVNBE10kZsKqZDSw17LRNdDQosoaGVzyJnVeOD7iywzl9ZnQ0XsiJ70P00xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qn7Y86S7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qn7Y86S7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2155F1570;
	Mon, 14 Sep 2026 01:19:30 -0700 (PDT)
Received: from [10.0.128.139] (unknown [10.0.128.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 347C73F7B4;
	Mon, 14 Sep 2026 01:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789373973; bh=m0ynvs3ASpXg1FC+68FV0PXhWfrNCCs02XWVdpFI/DQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=qn7Y86S79uT/YwzISi20g2289oLffqODkAmnxFgB2/f7TGFSQH0pkD3Flpjb9goCV
	 JVxc5wzSGZPvwfsvk8giDVPvJZb6nSQiZf9vHgvAswACRxWTw5hI/Q8OEqEP2oUPT0
	 WdpXR2joVP3TKazZtFh5ODPYF2WekqdLue2DS+xI=
Message-ID: <1fca136f-5802-449a-81f1-3a76c31a2f74@arm.com>
Date: Mon, 14 Sep 2026 09:19:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-5-suzuki.poulose@arm.com>
 <f00d01d1-8df0-4865-8e52-c85171cf4ca5@redhat.com>
 <4f18aa66-2296-4b63-87f5-6ab493faecbc@arm.com>
In-Reply-To: <4f18aa66-2296-4b63-87f5-6ab493faecbc@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/09/2026 07:22, Suzuki K Poulose wrote:
> Hi Gavin
> 
> Thank you for the review, I will address most of them. Responses inline.
> 
> On 14/09/2026 06:04, Gavin Shan wrote:
>> On 9/12/26 6:36 PM, Suzuki K Poulose wrote:
>>> RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
>>> means that an SMC can return with an operation still in progress. The
>>> host is expected to continue the operation until it reaches a conclusion
>>> (either success or failure). During this process the RMM can request
>>> additional memory ('donate') or hand memory back to the host
>>> ('reclaim'). The host can request an in progress operation is cancelled,
>>> but still continue the operation until it has completed (otherwise the
>>> incomplete operation may cause future RMM operations to fail).
>>>
>>> The SRO is tracked using a struct rmi_sro_state object which keeps track
>>> of any memory which has been allocated but not yet consumed by the RMM
>>> or reclaimed from the RMM. This allows the memory to be reused in a
>>> future request within the same operation. It will also permit an
>>> operation to be done in a context where memory allocation may be
>>> difficult (e.g. atomic context) with the option to abort the operation
>>> and retry the memory allocation outside of the atomic context. The
>>> memory stored in the struct rmi_sro_state object can then be reused on
>>> the subsequent attempt.
>>>
>>> Wrappers for SRO RMI commands are also provided here because they depend
>>> on the rmi_sro_execute() implementation added by this patch.
>>> Delegate/undelegate handles are also added here because they now use the
>>> SRO/stateful command infrastructure and are also used for the memory
>>> DONATE/RECLAIM flows.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> Co-Developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> 
> 
>>> ---
>>>   drivers/firmware/arm_rmm/rmi.c | 586 +++++++++++++++++++++++++++++++++
>>>   include/linux/arm-rmi-cmds.h   |  41 +++
>>>   2 files changed, 627 insertions(+)
>>>
>>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ 
>>> arm_rmm/rmi.c
>>> index 5b0e342ce3d58..4f9898ece7547 100644
>>> --- a/drivers/firmware/arm_rmm/rmi.c
>>> +++ b/drivers/firmware/arm_rmm/rmi.c
> 
>>
>> I would drop rmi_granule_range_{delegate, undelegate}() by combining 
>> their logics to
>> their only callers rmi_{delegate, undelegate}_range(). More details 
>> are provided for
>> rmi_{delegate, undelegate}_range() in the below.
> 
> Ack

I have moved them closer, but kept the logic separate, since this is not
a simple RMI call.

Cheers
Suzuki

