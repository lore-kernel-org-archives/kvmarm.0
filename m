Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960D7125D6
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735815004; cv=none; b=n1LgRu3U2pZD2GlwPYD+LceZAnirRxbAAMUrtNH3aYO9kb3FBttt1IqleFKy02ctBXaD5FMeDPOT5f50f/v1BsJTrMuJvjrzbKL7Tk9qN4UbOcTwXQ305sNXpSegDKtQgJzz3EDzFWlmZizX1MRgAf6rKm7/BvZpsE6+9wZ/HJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735815004; c=relaxed/simple;
	bh=hxIcWlXe+twot3P/0qLC7v4U8JgDgu/M8ubl2iJtCwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FdYwFiYnu5HhJE0kMMF0pSqpaoBOEkCckBjU1yU1DzL0NVKMVXOPxaezqX8uRALizF9tmxmoKq1j0Hpr3wrzx+FZbC1mu5dSf5MwMjmRjvy1Kw42HNSP0jQcjTYj7LdB7ArV/9VxMkLHoosAcOvAht1k3AKWKlDWBMpAi7xwiWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD3D411FB;
	Thu,  2 Jan 2025 02:50:28 -0800 (PST)
Received: from [10.1.25.140] (e121487-lin.cambridge.arm.com [10.1.25.140])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D12C3F59E;
	Thu,  2 Jan 2025 02:49:59 -0800 (PST)
Message-ID: <a895cb90-78b9-4b7b-b575-222e5a5caf21@arm.com>
Date: Thu, 2 Jan 2025 10:49:57 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
To: Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, andrew.jones@linux.dev, eric.auger@redhat.com
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor> <98b12b89-34f5-4203-a7c2-e6c4cebad6a7@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <98b12b89-34f5-4203-a7c2-e6c4cebad6a7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Nikos,

On 12/30/24 17:01, Nikos Nikoleris wrote:
> Hi Vladimir,
> 
> Thanks for this! Some comments inline.

Thanks for your time!

> 
> On 23/12/2024 12:03, Alexandru Elisei wrote:
>> Hi Vladimir,
>>
>> The patch looks good, but it just occured to me, the tests do a great job
>> checking that tagged accesses fail when they should be failing, but they don't
>> check that taggedd accesses *succeed* when they should not be failing. I think
>> that's useful to have at the start of each test, if nothing just as a sanity
>> check.
>>
>> On Thu, Dec 12, 2024 at 10:34:47AM +0000, Vladimir Murzin wrote:
>>> Test tag storage access and tag mismatch for different MTE modes.
>>>
>>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>>> ---
>>>
>>>   v1 -> v2
>>>      - Addressed comments (I hope I did not miss any) from Alexandru
>>>
>>>   arm/Makefile.arm64            |  10 +-
>>>   arm/cstart64.S                |   4 +-
>>>   arm/mte.c                     | 299 ++++++++++++++++++++++++++++++++++
>>>   arm/run                       |   3 +-
>>>   arm/unittests.cfg             |  19 +++
>>>   lib/arm64/asm/mmu.h           |   1 +
>>>   lib/arm64/asm/pgtable-hwdef.h |   2 +
>>>   lib/arm64/asm/sysreg.h        |  12 ++
>>>   8 files changed, 347 insertions(+), 3 deletions(-)
>>>   create mode 100644 arm/mte.c
>>>
>>> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
>>> index 3b9034e3..48dcdbd4 100644
>>> --- a/arm/Makefile.arm64
>>> +++ b/arm/Makefile.arm64
>>> @@ -17,10 +17,17 @@ ifneq ($(strip $(sve_flag)),)
>>>   CFLAGS += -DCC_HAS_SVE
>>>   endif
>>>   +mte_flag := $(call cc-option, -march=armv8.5-a+memtag, "")
> 
> FEAT_MTE2 is an optional feature from v8.4. Should we lower the requirement? I've also tried checking for armv8-a+memtag and that work too, since we don't really care about the exact version.
> 

IIUC, that might demand newer compiler(s) since most of them went
quite conservative originally and only recently removed that
dependency [1]. So it seems better to be conservative to cover broader
compiler base.

<snip>

>>> +
>>> +static inline void mte_set_tag(void *addr, size_t size, unsigned int tag)
>>> +{
>>> +#ifdef CC_HAS_MTE
>>> +    unsigned long in = (unsigned long)untagged(addr);
>>> +    unsigned long start = ALIGN_DOWN(in, 16);
>>> +    unsigned long end = ALIGN(in + size , 16);
>>> +
>>> +    for (unsigned long ptr = start; ptr < end; ptr += 16)
>>> +        asm volatile(".arch   armv8.5-a+memtag\n"
> 
> Is the .arch directive necessary? IIUC, this is typically used to instruct the compiler to use a reduced feature set.
> 

Yes, it is necessary here since we want compiler (more precisely,
assembler) to recognize stg/ldg instructions. That directive is limited
to inline asm block only. Alternative would be to ask user to provide
`-march=armv8.5-a+memtag` option build time, that was discussed in [2]


>>> +                 "stg %0, [%0]"
>>> +                 :
>>> +                 : "r"(tagged(ptr, tag))
>>> +                 : "memory");
>>> +#endif
>>> +}
>>> +
>>> +static inline unsigned long get_clear_tfsr(void)
>>> +{
>>> +    unsigned long r;
>>> +
>>> +    dsb(nsh);
>>> +    isb();
>>> +
>>> +    r = read_sysreg_s(TFSR_EL1);
>>> +    write_sysreg_s(0, TFSR_EL1);
>>> +
>>> +    return r;
>>> +}
>>> +
>>> +static void mte_sync_test(void)
>>> +{
>>> +    unsigned int *mem = alloc_page();
>>> +    unsigned int val = 0;
>>> +
>>> +    memset(mem, 0xff, PAGE_SIZE);
>>> +    mte_init();
> 
> The mte_init() could also be called by main as it is common across all three tests?
> 

Good point! I'll move it into main()

>>> +    mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
>>> +    mte_set_tag(mem, PAGE_SIZE, 0);
>>> +    mte_set_tcf(MTE_TCF_SYNC);
>>> +    mte_exception = false;
>>> +
>>> +    install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
> 
> Would it make sense to call this from mte_init() and maybe check whether we got an exception for sync fault and that we didn't for async faults?
> 

There are cases (async and asymm writes) where we do not expect any exception so we
can rely on default exception handler to stop the world and produce output with all
handy information for debug.

>>> +
>>> +    mem_read(mem, 1, &val);
>>
>> When I came back to the patch, I read this and I thought that the value 1
>> represents what the value of 'val' should be. Do you think the code would be
>> easier to read if mem_read() took a tagged address directly, i.e:
>>
>>     mem_read(tagged(mem, 1), &val);
>>
>> Up to you what you prefer.
> 
> I agree with Alex. But up to you Vladimir.
> 

Ack.

>>
>>> +
>>> +    report((val == 0) && mte_exception, "read");
>>> +
>>> +    mte_exception = false;
>>> +
>>> +    mem_write(mem, 2, 0xbbbbbbbb);
>>> +
>>> +    report((*mem == 0xffffffff) && mte_exception, "write");
> 
> Minor but you might want to call free_pages(mem) as well.
> 

Ack.

<snip>

>>> +static unsigned int mte_version(void)
>>> +{
>>> +#ifdef CC_HAS_MTE
>>> +    uint64_t r;
>>> +
>>> +    asm volatile("mrs %x0, id_aa64pfr1_el1" : "=r"(r));
>>> +
>>> +    return (r >> 8) & 0b1111;
> 
> Sorry, if this very tedious but it might be better if we defined some constants here instead?
> 

Ack.


[1] https://gcc.gnu.org/pipermail/gcc-patches/2023-June/622848.html
[2] https://lore.kernel.org/all/c2d9b61b-7dce-422b-8a3c-898f1003c9e4@arm.com/T/#m0a8ae8a0fa6a2f021feb95367d2e71eccc8258d3

Happy (western) New Year!

Vladimir

