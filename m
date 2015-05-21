From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [Qemu-devel] [RFC/RFT PATCH v2 3/3] arm/arm64: KVM: implement
 'uncached' mem coherency
Date: Wed, 20 May 2015 19:29:28 -0700
Message-ID: <555D4308.3030504@samsung.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <1431516714-25816-4-git-send-email-drjones@redhat.com>
 <20150514105549.GO32765@cbox> <20150514133213.GD12812@localhost.localdomain>
 <20150515145921.GB14144@lvm> <20150515170437.GA2951@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5739051CE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 May 2015 22:20:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7+K8SOfQ-031 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 May 2015 22:20:11 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 457CB51CE1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 May 2015 22:20:10 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NOO00LTLHLA4U50@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 20 May 2015 22:29:35 -0400 (EDT)
In-reply-to: <20150515170437.GA2951@localhost.localdomain>
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
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, qemu-devel@nongnu.org, pbonzini@redhat.com, lersek@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/15/2015 10:04 AM, Andrew Jones wrote:
> On Fri, May 15, 2015 at 08:02:59AM -0700, Christoffer Dall wrote:
>> On Thu, May 14, 2015 at 03:32:13PM +0200, Andrew Jones wrote:
>>> On Thu, May 14, 2015 at 12:55:49PM +0200, Christoffer Dall wrote:
>>>> On Wed, May 13, 2015 at 01:31:54PM +0200, Andrew Jones wrote:
>>>>> When S1 and S2 memory attributes combine wrt to caching policy,
>>>>> non-cacheable types take precedence. If a guest maps a region as
>>>>> device memory, which KVM userspace is using to emulate the device
>>>>> using normal, cacheable memory, then we lose coherency. With
>>>>> KVM_MEM_UNCACHED, KVM userspace can now hint to KVM which memory
>>>>> regions are likely to be problematic. With this patch, as pages
>>>>> of these types of regions are faulted into the guest, not only do
>>>>> we flush the page's dcache, but we also change userspace's
>>>>> mapping to NC in order to maintain coherency.
>>>>>
>>>>> What if the guest doesn't do what we expect? While we can't
>>>>> force a guest to use cacheable memory, we can take advantage of
>>>>> the non-cacheable precedence, and force it to use non-cacheable.
>>>>> So, this patch also introduces PAGE_S2_NORMAL_NC, and uses it on
>>>>> KVM_MEM_UNCACHED regions to force them to NC.
>>>>>
>>>>> We now have both guest and userspace on the same page (pun intended)
>>>>
>>>> I'd like to revisit the overall approach here.  Is doing non-cached
>>>> accesses in both the guest and host really the right thing to do here?
>>>
>>> I think so, but all ideas/approaches are still on the table. This is
>>> still an RFC.
>>>
>>>>
>>>> The semantics of the device becomes that it is cache coherent (because
>>>> QEMU is), and I think Marc argued that Linux/UEFI should simply be
>>>> adapted to handle whatever emulated devices we have as coherent.  I also
>>>> remember someone arguing that would be wrong (Peter?).
>>>
>>> I'm not really for quirking all devices in all guest types (AAVMF, Linux,
>>> other bootloaders, other OSes). Windows is unlikely to apply any quirks.
>>>
>>
>> Well my point was that if we're emulating a platform with coherent IO
>> memory for PCI devices that is something that the guest should work with
>> as such, but as Paolo explained it should always be safe for a guest to
>> assume non-coherent, so that doesn't work.
>>
>>>>
>>>> Finally, does this address all cache coherency issues with emulated
>>>> devices?  Some VOS guys had seen things still not working with this
>>>> approach, unsure why...  I'd like to avoid us merging this only to merge
>>>> a more complete solution in a few weeks which reverts this solution...
>>>
>>> I'm not sure (this is still an RFT too :-) We definitely would need to
>>> scatter some more memory_region_set_uncached() calls around QEMU first.
>>>
>>
>> It would be good if you could sync with the VOS guys and make sure your
>> patch set addresses their issues with the appropriate
>> memory_region_set_uncached() added to QEMU, and if it does not, some
>> vague idea why that falls outside of the scope of this patch set.  After
>> all, adding a USB controller to a VM is not that an esoteric use case,
>> is it?
> 
> I'll pull together a new version addressing all your comments, and also
> put some more time into making sure it'll work...
> 
> Jeremy, can you give me the qemu command line you're using for your tests?
> I'll do some experimenting with it.
> 
> Thanks,
> drew
> 

Hi Drew,

I just recently looked at these patches and little confused.

Where or how are the QEMU page tables changed to
non-cacheable?

I noticed the logical pfn is changed to non-cacheable.

- Mario
