From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from
 userspace
Date: Fri, 03 Nov 2017 18:36:52 +0000
Message-ID: <59FCB744.30609@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F2016BA9E4@DGGEMA503-MBX.china.huawei.com> <0184EA26B2509940AA629AE1405DD7F2016BAC2B@DGGEMA503-MBX.china.huawei.com> <59F0CD1F.9070201@arm.com> <900d0b35-e0dc-1e9d-b62a-bc587136f918@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <900d0b35-e0dc-1e9d-b62a-bc587136f918@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Huangshaoyu <huangshaoyu@huawei.com>, Wuquanming <wuquanming@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 27/10/17 08:21, gengdongjiu wrote:
> On 2017/10/26 1:42, James Morse wrote:
>> On 20/10/17 16:33, gengdongjiu wrote:
>>> As we discuss below solution:
>>> When guest happen SEA/SEI, KVM calls memory_failure() to send an asynchronous SIGBUS
>>> signal(BUS_MCEERR_AO) to QEMU, and make this address to poisoned.
>>> after QEMU receive this BUS_MCEERR_AO, it will record this address to CPER and notify guest.
>>> When guest happen stage2 page fault, KVM send a synchronous SIGBUS
>>> BUS_MCEERR_AR to QEMU, and QEMU also record CPER and immediately inject SEA abort.
>>>
>>> But this solution, still have some problems.
>>>
>>> 1. In some situation, For RAS, when happen SEA, hardware cannot provide an error physical
>>> address
>>
>> Eh? For any RAS error you should get a physical address in ERR<n>ADDR.
>>
>> When you get an external abort due to RAS you can scan these nodes to find which
>> one generated the error and collect the component information.
>> Doing this in firmware is better because firmware knows the SoC topology, so it
>> can skip the nodes it knows won't be relevant to an error on this CPU.

> Thanks for you suggestion.
> After discussed this issue internally in our side,  I think this should be our firmware issue.
> Not a common issue.
> so let us ignore the issue that hardware does not record physical error address.

This is going to give you problems in the long run. All we can do with 'memory
corrupt at an unknown address' is reboot.


>>> to software instead it can only provide virtual address in FAR_ELx, 
>>> This is to say, firmware cannot provide physical error address, but provided the virtual
>>> address in the FAR_ELx. so BIOS cannot record this address to APEI table. In
>>
>> Nit: APEI table, you mean recorded as CPER records in a buffer pointed to by a
>> GHES's ErrorStatusAddress. APEI tables aren't parsed post boot.
>>
>>
>>> this case, when firmware Jump to hypervisor, hypervisor cannot call
>>> memory_failure(), now only the physical address is recorded and valid, APEI
>>> driver will call the memory_failure()), in this case, host will not send SIGBUS
>>> to QEMU. So guest cannot know there is SEA happen.
>>> At least there is such issue in Huawei's platform (cannot provide PA for RAS firmware-first,
>>> only can provide VA in FAR_ELx)
>>
>> This isn't a KVM problem.
>>
>> It looks like both of UEFI's 'Table 275. Memory Error Record' and 'Table 276.
>> Memory Error Record 2' require a physical address. You can't describe a memory
>> error without one.
>>
>> Is this really a memory error?, or some other component, say, a virtually
>> indexed cache.

> When happen SEA, if the {D,I}FSC is 0b0101xx which is SEA on translation table walk or hardware update of translation
> table, it means the page table itself happen issue, not the target address error.
> For this case, even firmware can report a error page table physical address, but memory_memory()
> can not recognize this address because the page table address is not belong to any task include Qemu,
> so memory_failure() will not deliver SIGBUS. Of course, this is memory address.

Both KVM's stage2 and Qemu's user-space page tables are made up of pages of
kernel memory. When memory_failure() is told one of these is corrupt, it should
panic.

E.g, arm64 allocates pmd pages like so:
> static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
> {
>	return (pmd_t *)__get_free_page(PGALLOC_GFP);
> }

To do any better the kernel would need to know this memory is page-table and
that it wasn't the kernel's page-table. It also needs to know which mm_struct it
belonged to, and where in the page-table tree the corrupted page lives. There
would need to be a per-arch helper to ensure no CPU (or other component) had
cached the corrupted page table entries. (it's contained right?)

This isn't an arm64 specific issue, and its going to be very difficult to do.


> I ever make a  experiment, if a APP's page table itself generated SEA, memory_failure() will consider it
> as unknown issue. please see below log, I think this should be a common issue. 

This shouldn't be a common issue, page-tables are small compared to the memory
they map.


> so in KVM code, I plan to separately handle the page table error of SEA if
> the {D,I}FSC is 0b0101xx, and not call memory_failure(), what do you
> think about that?

I think we shouldn't special case KVM. All user-space task's page-tables are
kernel memory too, they shouldn't be treated differently. Once linux can handle
user-space page-table corruption, we can wire-in KVMs stage2.

KVM shouldn't call memory_failure() directly, for RAS it should rely on a
firmware-first or kernel-first handler to diagnose the error and do this dirty work.

I agree 'unknown error' sounds fishy:

> only the memory access SEA call memory_failure().
> 
> [   25.482904] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 7
> [   25.484862] {1}[Hardware Error]: event severity: recoverable
> [   25.486192] {1}[Hardware Error]:  Error 0, type: recoverable
> [   25.487519] {1}[Hardware Error]:   section_type: memory error
> [   25.490169] {1}[Hardware Error]:   physical_address: 0x000000007ce81000
> [   25.491718] {1}[Hardware Error]:   error_type: 3, multi-bit ECC
> [   25.501178] Memory failure: 0x7ce81: Unknown page state
> [   25.501181] Memory failure: 0x7ce81: unknown page still referenced by 1 users
> [   25.501183] Memory failure: 0x7ce81: recovery action for unknown page: Failed

We should spot this as corrupted kernel memory and bring the machine down.

/me goes digging

It looks like memory_failure()s 'error_states[]' only matches PG_reserved or
PG_slab as being kernel memory and then ...
> /*
>  * Error hit kernel page.
>  * Do nothing, try to be lucky and not touch this instead. For a few cases we
>  * could be more sophisticated.
>  */
> static int me_kernel(struct page *p, unsigned long pfn)
> {
> 	return MF_IGNORED;
> }

Eeew. This is relying on hardware containment to stop us silently propagating
the corrupt memory, and hoping we'll 'be lucky' that the in-kernel owner will
never actually need this page again. If it does? Presumably we spin through the
firmware and APEI handler, until firmware decides to stop the merry-go-round.

We can only end up in here via APEI (for now), so we can expect firmware to have
some way of doing containment. The RAS extensions require it.


>>> 3. For SEI, the address is invalid, 
>>
>> You mean FAR_ELx?

> I mean the physical address. Because SEI is asynchronous, so usually firmware will not record this address,

(is this this issue I'm to ignore?)


> If not record this address, the memory_failure() will be not called, then SIGBUS will not be sent, then guest will
> not know there is SEI happen, so for this case may be we should also inject a virtual SError to avoid the issue that
> physical address is not record.

We don't know the SError only affected the guest unless you can give us
information about what triggered it. Even if it is guest memory that is
affected, we don't know that page wasn't merged by KSM into another guest, or
another user-space process.


>>> so in some platform, firmware will not record this AP.
>>
>> For any RAS error you should get a physical address in ERR<n>ADDR.

> how about the address is not accurate?
> For SEI, even we can get a physical address from ERR<n>ADDR, but this address is not accurate.
> so firmware will make it as invalid or not record it.

This is an unknown RAS error, firmware doesn't know what happened, the host
doesn't know if it can safely continue running. The kernel should panic.



James
