Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6F049BD7C;
	Mon, 28 Sep 2026 10:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790591888; cv=none; b=LjAgkvEimrRi+glrrkprCmqMyGeykVkwC2jvSOYf6XDITg2IlBFv6S4sYR++FOPK3ECdezeie5gOcX+jWgDk1CPYnTn4yxJyTVntiGtwLtsdravhEY7IG/XN9capBM/wCISMzaQR6nstIQaU4UxtbjZCcz4cbjZQ8Elzfj1P+NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790591888; c=relaxed/simple;
	bh=WyhGkEh/Tg98781MkrRtXVLM7OrY9RABxic2LWuUJO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YUpCUiVYRm95ZYJXitu+4Y+0+VBqe8eiP4oBLsNelqhKKY8BLvHO50grrn37PpDpNut4yxI4VCOWSlD395HIoYdx5RJ6nlOuwIsJj0icnlt1dEhVuNemYIPftZYnN/m9uCRvWyp1if757fGQkauBmy2dCcZnkA5S64nsluya3FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b6e/9zz0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b6e/9zz0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F45B1595;
	Mon, 28 Sep 2026 03:38:02 -0700 (PDT)
Received: from [10.57.12.79] (unknown [10.57.12.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B3BF63F86F;
	Mon, 28 Sep 2026 03:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790591885; bh=WyhGkEh/Tg98781MkrRtXVLM7OrY9RABxic2LWuUJO0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b6e/9zz0pkhgc+qaHVauwUb4u5rmxdp7i1PHyPSXEKggwpo+VB31jvoLg5zQzb/0h
	 iYZ2vFcYs8WFv8M1rrY3QbDiNBuzgTBgfDKeybi4RgMK7SqwG6zIb3YB44LK0PhEqB
	 4caPUYWw3Z88gErdYPNWuklLnK9KYYIs0cpyhB4c=
Message-ID: <3934b4c9-6b1f-44fa-847e-4fb1e67a58e7@arm.com>
Date: Mon, 28 Sep 2026 11:38:01 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, maz@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <arK3tsTV6EDhI-nt@willie-the-truck> <arOyp8WUrYBAjrGH@arm.com>
 <arP0IF0MjFUv36AP@willie-the-truck>
 <49dcab27-1d03-4df2-b7cb-4df4eda6d909@arm.com> <araqPCdcSnqZqPWz@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <araqPCdcSnqZqPWz@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/09/2026 18:07, Catalin Marinas wrote:
> On Wed, Sep 23, 2026 at 05:04:06PM +0100, Suzuki K Poulose wrote:
>> On 23/09/2026 16:45, Will Deacon wrote:
>>> On Wed, Sep 23, 2026 at 12:06:15PM +0100, Catalin Marinas wrote:
>>>> On Tue, Sep 22, 2026 at 06:15:34PM +0100, Will Deacon wrote:
>>>>> On Sun, Sep 13, 2026 at 08:04:58AM +0100, Suzuki K Poulose wrote:
>>>>>> From: Steven Price <steven.price@arm.com>
>>>>>>
>>>>>> If the host attempts to access granules that have been delegated for use
>>>>>> in a realm these accesses will be caught and will trigger a Granule
>>>>>> Protection Fault (GPF).
>>>>>>
>>>>>> A fault during a page walk signals a bug in the kernel and is handled by
>>>>>> oopsing the kernel. A non-page walk fault could be caused by user space
>>>>>> having access to a page which has been delegated to the kernel and will
>>>>>> trigger a SIGBUS to allow debugging why user space is trying to access a
>>>>>> delegated page.
>>>>>>
>>>>>> There is work in progress to unmap the guest_memfd backed private pages from the
>>>>>> linear map. Until we get that support, we could get spurious GPFs from within
>>>>>> the kernel, e.g., load_unaligned_zeropad(). So, try to fix them up for now.
>>>>>>
>>>>>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>>>>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>>>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>>> ---
>>>>>> Changes since v17:
>>>>>>    * Pass untagged address to die_kernel_fault() - Sashiko
>>>>>>    * Explicitly check !user_mode() for fixups - Catalin
>>>>>>    * Switch to BUS_OBJERR for si_code from SI_KERNEL - Catalin
>>>>>>    * Clarify the commit description about the upcoming work on
>>>>>>      unmapping guest_memfd backed pages from linear map
>>>>>> Changes since v16:
>>>>>>    * Update the commit description to indicate why we try to fixup GPFs
>>>>>> Changes since v10:
>>>>>>    * Don't call arm64_notify_die() in do_gpf() but simply return 1.
>>>>>> Changes since v2:
>>>>>>    * Include missing "Granule Protection Fault at level -1"
>>>>>> ---
>>>>>>    arch/arm64/mm/fault.c | 30 ++++++++++++++++++++++++------
>>>>>>    1 file changed, 24 insertions(+), 6 deletions(-)
>>>>>
>>>>> I still don't think we should do this, given that the plan is to unmap
>>>>> the memory from the linear map. If this thing fires, it's a kernel bug
>>>>> and it should be fatal.
>>>>
>>>> If the linear unmapping gets merged first, I agree, no need to handle
>>>> these faults. I haven't followed that series, so no idea where it is at.
>>
>> There doesn't seem to be much progress on that series. Brendan
>> volunteered to resurrect the series, taking over from Nikita [0].
>> But looks like Brendan is not working on this anymore. Will see
>> if someone is really planning to look at it.
>>
>> [0] https://lore.kernel.org/all/DJJ35VLH2PE5.DFD8OYXEOH97@linux.dev
> 
> I just realised that this only solves part of the problem. Normal kernel
> allocations are delegated RMM metadata and they'll also trigger GPF

Other than Kdump, kernel shouldn't try to touch these metadata pages
unless there is a kernel bug ?

And the userspace wouldn't have a mapping for them anyways ?

> faults. Kdump is another point raised here:

True.

> 
> https://lore.kernel.org/all/a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com/
> 
> I think rmi_delegate_range() covers the non-kdump cases, both for
> metadata and realm memory, we could unmap the linear map there (map it
> back in rmi_undelegate_range()).

We could explore that option for the kernel allocations too.

> 
> For kdump, we have /proc/vmcore that may be mmap'ed or read() syscalls.
> I think Alper proposed an idea to use copy_from_kernel_nofault() (with
> exception recovery in do_gpf()) but we'd still need to block
> mmap_vmcore() or somehow handle SIGBUS in makedumpfile unless it does
> this already.

There is a --no-mmap option for makedumpfile in the worst case.

> 
> So, I think we should revisit the GPF handling. If we manage to unmap
> all delegated pages, we could limit the exception handling to
> is_kdump_kernel(). Otherwise we keep the exception handling as proposed
> earlier, maybe with some warnings like EL0 access.

Agree. We definitely need this for kdump handling.

Suzuki



