Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EECE39989D;
	Tue, 11 Aug 2026 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786461084; cv=none; b=Re4/nT3oDB/Zb0a4oYfdRve1AvFl6Zhs6HS273Q1He4GdM+SmH86umao2vu15XfYmZNa4hkacCd8kfOaHJhM9F9GYHxnLChg+sNZKSGJQDqIUoLCETuZ+54R5Sh/wbZ3+zBXYhwyby9lijZzjx5qgsm72Q+Qp/AM0lMGN0/V9KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786461084; c=relaxed/simple;
	bh=kDDYlXulaDY8kALDeWuyOverwrCQSxMzEot+EHWqycI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=thkEggVgSYFJRjW/yJ9IyMyGqUXK+XuciKtTIcCO+JcJJIR3v9tqZe2UFDPRlOYoKVDxPWWtyIiGT5cxyfM18YI4+m9w+MPejidshFdf726tCfeF3pywWikiMuveJlefBLpT8oX/+KS0JisRmgP1bxDbwoQtWPyYZkBy1W6bl1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CFq+KJEj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CFq+KJEj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 372F61516;
	Tue, 11 Aug 2026 08:11:14 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A72B3F632;
	Tue, 11 Aug 2026 08:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786461078; bh=kDDYlXulaDY8kALDeWuyOverwrCQSxMzEot+EHWqycI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CFq+KJEjHh7zmyzu6EkHr4X1WVBBCk5sU1Bf9jSrz2nyrnMMUG+vk7SzCy6qApv6c
	 8uDjXsSiAeZoIVOgqvUsimXRBvOPNkgmgrpqiQrP7zrmIx0rxrNTfXNRA0gquSHLIA
	 rm648u3B5jtW0/FwZgKH/BZHCnj6Uu4027eNq6kg=
Message-ID: <d4bdecca-517a-4b4b-bf67-cef6b09bc8c1@arm.com>
Date: Tue, 11 Aug 2026 16:11:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 07/45] arm64: mm: Handle Granule Protection Faults
 (GPFs)
To: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-8-steven.price@arm.com> <ans1ZSwMEKeT9Gfz@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ans1ZSwMEKeT9Gfz@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/08/2026 15:44, Catalin Marinas wrote:
> On Mon, Aug 03, 2026 at 02:43:23PM +0100, Steven Price wrote:
>> If the host attempts to access granules that have been delegated for use
>> in a realm these accesses will be caught and will trigger a Granule
>> Protection Fault (GPF).
>>
>> A fault during a page walk signals a bug in the kernel and is handled by
>> oopsing the kernel. A non-page walk fault could be caused by user space
>> having access to a page which has been delegated to the kernel and will
>> trigger a SIGBUS to allow debugging why user space is trying to access a
>> delegated page.
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v10:
>>   * Don't call arm64_notify_die() in do_gpf() but simply return 1.
>> Changes since v2:
>>   * Include missing "Granule Protection Fault at level -1"
>> ---
>>   arch/arm64/mm/fault.c | 28 ++++++++++++++++++++++------
>>   1 file changed, 22 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 85e23388f9bb..ea3ae0ca7dba 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -909,6 +909,22 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>>   	return 0;
>>   }
>>   
>> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
>> +{
>> +	const struct fault_info *inf = esr_to_fault_info(esr);
>> +
>> +	die_kernel_fault(inf->name, far, esr, regs);
>> +	return 0;
>> +}
>> +
>> +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
>> +{
>> +	if (!is_el1_instruction_abort(esr) && fixup_exception(regs, esr))
>> +		return 0;
>> +
>> +	return 1;
>> +}
> 
> Is there a valid case for fixup_exception() here? IOW, do we ever have a
> valid user mapping of the pages delegated to a guest? If the above is
> considered a kernel bug, I'd not silently ignore this (like return less
> bytes copied or -EFAULT to user) but rather warn, potentially
> rate-limited.

Good question. This shouldn't be a valid case. We expect the VMM to use
guest_memfd and that should prevent any mmaps and thus fixups shouldn't
be required. That said, this series doesn't enforce that the VMM uses
GMEM backed memslots for Guest RAM. We should probably do that while
mapping things in.

With that, we could drop that fixup and scream a bit.

Cheers
Suzuki

> 
> If there is a real use-case for this, what's preventing GUP + memcpy()
> from triggering a similar fault with no fixup available?
> 

