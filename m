Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3C317554
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 04:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706676023; cv=none; b=IoSG9aoKy3+41UCJZ86oy8kKCo7ZKlyJRlhpI8bMTvLXO+fCH40MnZWUFGY2YQEQ5djrLcHx2Mg6yzTfkvieO6i1PSQ8FnWM65MqKeCInfFSfAPYTmfseSU2prFeLvRgUYZIT7Vdt/bz4xSVvBibDepEWcylG4JxVDB2a32DrV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706676023; c=relaxed/simple;
	bh=3R14n/VzZcxmNnLweehoAPfyjB2o8LMMfTdOUihMJJY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lEy4oDsu4UewvNKcxUqDAznu8afq8mMyhfbXaEjnX+fYPzpxX0X97GS915VmnMUwmx64QVo2YJ8xr1f5BdXjE0a8hD2qnfUiRwSN8ErCwi4rAtCkHCdtMGJrHRmO00bMeXiO+xFNUL0PBFFztk9iUvtENShBpG8mDiwJ7mirv3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4E6CDA7;
	Tue, 30 Jan 2024 20:41:03 -0800 (PST)
Received: from [10.163.41.195] (unknown [10.163.41.195])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 52C333F738;
	Tue, 30 Jan 2024 20:40:06 -0800 (PST)
Message-ID: <8cd39b48-7fb8-40b2-8d6c-e6fc2b48f86d@arm.com>
Date: Wed, 31 Jan 2024 10:10:05 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 06/35] mm: cma: Make CMA_ALLOC_SUCCESS/FAIL count
 the number of pages
Content-Language: en-US
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, arnd@arndb.de, akpm@linux-foundation.org,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
 vschneid@redhat.com, mhiramat@kernel.org, rppt@kernel.org, hughd@google.com,
 pcc@google.com, steven.price@arm.com, vincenzo.frascino@arm.com,
 david@redhat.com, eugenis@google.com, kcc@google.com, hyesoo.yu@samsung.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
References: <20240125164256.4147-1-alexandru.elisei@arm.com>
 <20240125164256.4147-7-alexandru.elisei@arm.com>
 <0a71c87a-ae2c-4a61-8adb-3a51d6369b99@arm.com> <ZbeRQpGNnfXnjayQ@raptor>
 <2cb8288c-5378-4968-a75b-8462b41998c6@arm.com> <ZbjkTFEvSvyHNqmu@raptor>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ZbjkTFEvSvyHNqmu@raptor>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/30/24 17:28, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Jan 30, 2024 at 10:22:11AM +0530, Anshuman Khandual wrote:
>>
>> On 1/29/24 17:21, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> On Mon, Jan 29, 2024 at 02:54:20PM +0530, Anshuman Khandual wrote:
>>>>
>>>> On 1/25/24 22:12, Alexandru Elisei wrote:
>>>>> The CMA_ALLOC_SUCCESS, respectively CMA_ALLOC_FAIL, are increased by one
>>>>> after each cma_alloc() function call. This is done even though cma_alloc()
>>>>> can allocate an arbitrary number of CMA pages. When looking at
>>>>> /proc/vmstat, the number of successful (or failed) cma_alloc() calls
>>>>> doesn't tell much with regards to how many CMA pages were allocated via
>>>>> cma_alloc() versus via the page allocator (regular allocation request or
>>>>> PCP lists refill).
>>>>>
>>>>> This can also be rather confusing to a user who isn't familiar with the
>>>>> code, since the unit of measurement for nr_free_cma is the number of pages,
>>>>> but cma_alloc_success and cma_alloc_fail count the number of cma_alloc()
>>>>> function calls.
>>>>>
>>>>> Let's make this consistent, and arguably more useful, by having
>>>>> CMA_ALLOC_SUCCESS count the number of successfully allocated CMA pages, and
>>>>> CMA_ALLOC_FAIL count the number of pages the cma_alloc() failed to
>>>>> allocate.
>>>>>
>>>>> For users that wish to track the number of cma_alloc() calls, there are
>>>>> tracepoints for that already implemented.
>>>>>
>>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>>> ---
>>>>>  mm/cma.c | 4 ++--
>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/mm/cma.c b/mm/cma.c
>>>>> index f49c95f8ee37..dbf7fe8cb1bd 100644
>>>>> --- a/mm/cma.c
>>>>> +++ b/mm/cma.c
>>>>> @@ -517,10 +517,10 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>>>>>  	pr_debug("%s(): returned %p\n", __func__, page);
>>>>>  out:
>>>>>  	if (page) {
>>>>> -		count_vm_event(CMA_ALLOC_SUCCESS);
>>>>> +		count_vm_events(CMA_ALLOC_SUCCESS, count);
>>>>>  		cma_sysfs_account_success_pages(cma, count);
>>>>>  	} else {
>>>>> -		count_vm_event(CMA_ALLOC_FAIL);
>>>>> +		count_vm_events(CMA_ALLOC_FAIL, count);
>>>>>  		if (cma)
>>>>>  			cma_sysfs_account_fail_pages(cma, count);
>>>>>  	}
>>>> Without getting into the merits of this patch - which is actually trying to do
>>>> semantics change to /proc/vmstat, wondering how is this even related to this
>>>> particular series ? If required this could be debated on it's on separately.
>>> Having the number of CMA pages allocated and the number of CMA pages freed
>>> allows someone to infer how many tagged pages are in use at a given time:
>> That should not be done in CMA which is a generic multi purpose allocator.

> Ah, ok. Let me rephrase that: Having the number of CMA pages allocated, the
> number of failed CMA page allocations and the number of freed CMA pages
> allows someone to infer how many CMA pages are in use at a given time.
> That's valuable information for software designers and system
> administrators, as it allows them to tune the number of CMA pages available
> in a system.
> 
> Or put another way: what would you consider to be more useful?  Knowing the
> number of cma_alloc()/cma_release() calls, or knowing the number of pages
> that cma_alloc()/cma_release() allocated or freed?

There is still value in knowing how many times cma_alloc() succeeded or failed
regardless of the cumulative number pages involved over the time. Actually the
count helps to understand how cma_alloc() performed overall as an allocator.

But on the cma_release() path there is no chances of failure apart from - just
when the caller itself provides an wrong input. So there are no corresponding
CMA_RELEASE_SUCCESS/CMA_RELEASE_FAIL vmstat counters in there - for a reason !

Coming back to CMA based pages being allocated and freed, there is already an
interface via sysfs (CONFIG_CMA_SYSFS) which gets updated in cma_alloc() path
via cma_sysfs_account_success_pages() and cma_sysfs_account_fail_pages().

#ls /sys/kernel/mm/cma/<name>
alloc_pages_fail alloc_pages_success

Why these counters could not meet your requirements ? Also 'struct cma' can
be updated to add an element 'nr_pages_freed' to be tracked in cma_release(),
providing free pages count as well.

There are additional debug fs based elements (CONFIG_CMA_DEBUGFS) available.

#ls /sys/kernel/debug/cma/<name>
alloc  base_pfn  bitmap  count  free  maxchunk  order_per_bit  used
