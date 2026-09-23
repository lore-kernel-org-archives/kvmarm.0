Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8163B27FB;
	Wed, 23 Sep 2026 16:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790179454; cv=none; b=ccacj5d7PAQRxa2aARilQdU74vYzvY6zZSOoAmhhy0mp5+XYeutpPj7ufzAg7w0v40v40mpyYXLS/I6VwppkTjJ3TFxUiPqYJ+9tClLndgUB7AfQD22QE0ESop3pmfChZmsnfbTzpdTnNWHuNC68flKmtjTvJPaLBYOWk2k0858=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790179454; c=relaxed/simple;
	bh=LypSKbP3j1z/OluSZ8QgXPhuhfs8wposHBwrrJn+Pdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jFjyhW6oa41qEJUPRetMAmnSTGIFV4kiVqe4LrzKfcZPfcAhQWi3HUyUPrYoEf0RxGygqKIhnjG8rjfNp7twv6ckP4eGUiGBs3W2C3turxJbgMbuaJFFA4wSndwWx2NOeA7ZzDD43XJfpEN2W9Z5JeFwhm9t7Mm+k7sgdAIaDJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KOsuIYT7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KOsuIYT7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CCED1570;
	Wed, 23 Sep 2026 09:04:07 -0700 (PDT)
Received: from [10.57.8.94] (unknown [10.57.8.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB7A43F86C;
	Wed, 23 Sep 2026 09:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790179451; bh=LypSKbP3j1z/OluSZ8QgXPhuhfs8wposHBwrrJn+Pdk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KOsuIYT7/OTV9MNcwsKRHBPb9lZmEF5HNpqf3oja3i9mkeb6DrOC+3m7Gx/3iPPwI
	 HvW+L00xnoSRguEbxi+qnFypGWzRg+ETkljCS43h5pYPbWjQYSvYFQTziRa16jhKTq
	 GvV3m4USV360TJbc+TcbqTVHe+pRo8U8KRVhPexE=
Message-ID: <49dcab27-1d03-4df2-b7cb-4df4eda6d909@arm.com>
Date: Wed, 23 Sep 2026 17:04:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Content-Language: en-GB
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 gshan@redhat.com, joey.gouly@arm.com, tabba@google.com,
 yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <arK3tsTV6EDhI-nt@willie-the-truck> <arOyp8WUrYBAjrGH@arm.com>
 <arP0IF0MjFUv36AP@willie-the-truck>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <arP0IF0MjFUv36AP@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/09/2026 16:45, Will Deacon wrote:
> On Wed, Sep 23, 2026 at 12:06:15PM +0100, Catalin Marinas wrote:
>> On Tue, Sep 22, 2026 at 06:15:34PM +0100, Will Deacon wrote:
>>> On Sun, Sep 13, 2026 at 08:04:58AM +0100, Suzuki K Poulose wrote:
>>>> From: Steven Price <steven.price@arm.com>
>>>>
>>>> If the host attempts to access granules that have been delegated for use
>>>> in a realm these accesses will be caught and will trigger a Granule
>>>> Protection Fault (GPF).
>>>>
>>>> A fault during a page walk signals a bug in the kernel and is handled by
>>>> oopsing the kernel. A non-page walk fault could be caused by user space
>>>> having access to a page which has been delegated to the kernel and will
>>>> trigger a SIGBUS to allow debugging why user space is trying to access a
>>>> delegated page.
>>>>
>>>> There is work in progress to unmap the guest_memfd backed private pages from the
>>>> linear map. Until we get that support, we could get spurious GPFs from within
>>>> the kernel, e.g., load_unaligned_zeropad(). So, try to fix them up for now.
>>>>
>>>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> ---
>>>> Changes since v17:
>>>>   * Pass untagged address to die_kernel_fault() - Sashiko
>>>>   * Explicitly check !user_mode() for fixups - Catalin
>>>>   * Switch to BUS_OBJERR for si_code from SI_KERNEL - Catalin
>>>>   * Clarify the commit description about the upcoming work on
>>>>     unmapping guest_memfd backed pages from linear map
>>>> Changes since v16:
>>>>   * Update the commit description to indicate why we try to fixup GPFs
>>>> Changes since v10:
>>>>   * Don't call arm64_notify_die() in do_gpf() but simply return 1.
>>>> Changes since v2:
>>>>   * Include missing "Granule Protection Fault at level -1"
>>>> ---
>>>>   arch/arm64/mm/fault.c | 30 ++++++++++++++++++++++++------
>>>>   1 file changed, 24 insertions(+), 6 deletions(-)
>>>
>>> I still don't think we should do this, given that the plan is to unmap
>>> the memory from the linear map. If this thing fires, it's a kernel bug
>>> and it should be fatal.
>>
>> If the linear unmapping gets merged first, I agree, no need to handle
>> these faults. I haven't followed that series, so no idea where it is at.

There doesn't seem to be much progress on that series. Brendan
volunteered to resurrect the series, taking over from Nikita [0].
But looks like Brendan is not working on this anymore. Will see
if someone is really planning to look at it.

[0] https://lore.kernel.org/all/DJJ35VLH2PE5.DFD8OYXEOH97@linux.dev


>>
>> However, I'd still keep part of this patch - the reporting and panic but
>> without the actual exception table recovery. There's some value in
>> killing user-space and WARN (or pr_ratelimited) without a full panic, it
>> helps with debugging. That's what do_bad() via arm64_notify_die() gives
>> us currently anyway.
>>
>> So maybe we can keep it to just:
>>
>> static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
>> {
>> 	if (user_mode(regs)) {
>> 		pr_alert_ratelimited("%s[%d]: granule protection fault at 0x%016lx\n",
>> 				current->comm, task_pid_nr(current),
>> 				untagged_addr(far));
>> 		mem_abort_decode(esr);
>> 	}
>>
>> 	return 1;
>> }
>>
>> and we get the SIGBUS or panic via do_mem_abort(). No recovery for
>> uaccess though, we get the same kernel panic.
> 
> But how can this ever occur in user mode? I'm fine with making that part
> unconditional.

Agree, if the user mode can hit this, a page is mapped in the EL0 and
it can as well cause the Kernel to hit a GPF.
Also if make the handling unconditional, we end up calling
die_kernel_fault() and that does the mem_abort_decode() causing
duplicate logs.

Suzuki


> 
> Will

