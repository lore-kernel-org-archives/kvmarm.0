From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [Qemu-devel] [RFC/RFT PATCH v2 1/3] arm/arm64: pageattr: add
 set_memory_nc
Date: Tue, 26 May 2015 18:08:00 -0700
Message-ID: <556518F0.5040602@samsung.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <1431516714-25816-2-git-send-email-drjones@redhat.com>
 <20150514110509.GP32765@cbox> <20150514134644.GF12812@localhost.localdomain>
 <20150518155303.GF21251@e104818-lin.cambridge.arm.com>
 <555FD30E.6050507@samsung.com> <20150525171125.GA2996@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BF5652045
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 20:59:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tpyDLgQRuQ23 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2015 20:59:02 -0400 (EDT)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BB3052169
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 20:59:01 -0400 (EDT)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NOZ00FN1HUI1250@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 26 May 2015 21:08:42 -0400 (EDT)
In-reply-to: <20150525171125.GA2996@localhost.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "lersek@redhat.com" <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/25/2015 10:11 AM, Andrew Jones wrote:
> On Fri, May 22, 2015 at 06:08:30PM -0700, Mario Smarduch wrote:
>> On 05/18/2015 08:53 AM, Catalin Marinas wrote:
>>> On Thu, May 14, 2015 at 02:46:44PM +0100, Andrew Jones wrote:
>>>> On Thu, May 14, 2015 at 01:05:09PM +0200, Christoffer Dall wrote:
>>>>> On Wed, May 13, 2015 at 01:31:52PM +0200, Andrew Jones wrote:
>>>>>> Provide a method to change normal, cacheable memory to non-cacheable.
>>>>>> KVM will make use of this to keep emulated device memory regions
>>>>>> coherent with the guest.
>>>>>>
>>>>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>>>>
>>>>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>>>
>>>>> But you obviously need Russell and Will/Catalin to ack/merge this.
>>>>
>>>> I guess this patch is going to go away in the next round. You've
>>>> pointed out that I screwed stuff up royally with my over eagerness
>>>> to reuse code. I need to reimplement change_memory_common, but a
>>>> version that takes an mm, which is more or less what I did in the
>>>> last version of this series, back when I was pinning pages.
>>>
>>> I kept wondering what this patch and the next one are doing with
>>> set_memory_nc(). Basically you were trying to set the cache attributes
>>> for the kernel linear mapping or kmap address (in the 32-bit arm case,
>>> which is removed anyway on kunmap).
>>>
>>> What you need is changing the attributes of the user mapping as accessed
>>> by Qemu but I don't think simply re-implementing change_memory_common()
>>> would work, you probably need to pin the pages in memory as well.
>>> Otherwise, the kernel may remove such pages and, when bringing them
>>> back, would set the default cacheability attributes.
>>>
>>> Another way would be to split the vma containing the non-cacheable
>>> memory so that you get a single vma with the vm_page_prot as
>>> Non-cacheable.
>>>
>>> Yet another approach could be for KVM to mmap the necessary memory for
>>> Qemu via a file_operations.mmap call (but that's only for ranges outside
>>> the guest "RAM").
>>
>> I think this option with a basic loadable driver
>> that allocates non-cachable/pinned pages for QEMU to mmap()
>> may provide a reference point to build on. If that covers
>> all the cases then perhaps move to more generic solution. This
>> should be quicker to implement and test.
> 
> I've pulled together a different approach for experimentation. I added a
> new mmap/mprotect prot flag, like what was done for the powerpc SAO bit
> (see commit b845f313d78e4e "mm: Allow architectures to define additional
> protection bits" and commit ef3d3246a0d06 " powerpc/mm: Add Strong Access
> Ordering support"). So far I've only tested with a simple test program that
> forks and messes around with mapping shared memory in different ways. With
> some cache flushing added to set_pte_at on memattr changes, then it seems
> to work pretty well.

Thanks for the pointer, it's pretty deep into generic mmap_region()
code. Does SAO apply to regular memory or MMIO regions?

> 
> Now I'll start experimenting with QEMU again to see if the "map QEMU's
> memory as noncacheable" approach makes any sense at all. If it does,
> then I'm not sure we want to do it with mprotect, but I could clean up
> the patches and post them for discussion. The main problems I see with it
> are the need to define a new PROT_ flag, and the fact that it might not
> be a good idea for userspace to have this capability in the first place,
> at least not for MAP_SHARED regions.

Seem like pretty significant incisions to generic kernel.
Appears like below patches do same thing without adding
arch specific vma protection extensions. You would need
to lock the region pages, right? Also flush the TLBs
after locking. Appears to make a general mmap() interface
unique for this case.

> 
>>
>> I wonder if kernel mm will ever have a reason
>> to create a cacheable mapping even if the pages are pinned?
>> Like reading /dev/mem although that's not a likely case here.
> 
> Actually for a version with pinned pages, then I think this one
> http://www.spinics.net/lists/kvm-arm/msg14021.html
> is a good start. There are some problems with it, but I can fix
> them in order for it to be useful for experimenting with QEMU. It
> suffers from the Device-nGnRnE issue Peter and Alex pointed out, and
> I also see that I'm using the wrong address in there as well for the
> dcache flush, because I'm using kvm_flush_dcache_pte(*ptep) in
> set_page_uncached, which ends up using page_address(page). I should
> just do __flush_dcache_area(addr, PAGE_SIZE), instead.

Sorry I missed this series it appears clean, with no excessive flushing,
and the few additional modifications you pointed out. Instead of
flush_tlb_kernel_range(), maybe use flush_tlb_all(),
I'm not sure vaae1is flushes any other alias mappings to
same pfn.

Thanks,
- Mario

> 
> Thanks,
> drew
> 
