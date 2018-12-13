From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [virtio-dev] Re: [PATCH v5 5/7] iommu: Add virtio-iommu driver
Date: Thu, 13 Dec 2018 12:37:56 +0000
Message-ID: <1494c026-a763-6c77-2476-a3373c21ae6f@arm.com>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
 <20181122193801.50510-6-jean-philippe.brucker@arm.com>
 <20181123165206-mutt-send-email-mst@kernel.org>
 <e76a51ba-7a0f-3fca-a1ae-640131f9dfe1@arm.com>
 <20181127130527-mutt-send-email-mst@kernel.org>
 <e1dde79c-0bc4-ea99-1bb0-9e70b56955fb@arm.com>
 <20181212093709-mutt-send-email-mst@kernel.org>
 <eb267a7c-a881-afd9-9ce2-bcdc317d16d7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C84374A1DE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Dec 2018 07:38:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6UrB+ET6gMVb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Dec 2018 07:38:03 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B99174A1D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Dec 2018 07:38:03 -0500 (EST)
In-Reply-To: <eb267a7c-a881-afd9-9ce2-bcdc317d16d7@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: virtio-dev@lists.oasis-open.org, lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com, devicetree@vger.kernel.org, marc.zyngier@arm.com, linux-pci@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, virtualization@lists.linux-foundation.org, iommu@lists.linux-foundation.org, robh+dt@kernel.org, bhelgaas@google.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 2018-12-12 3:27 pm, Auger Eric wrote:
> Hi,
> 
> On 12/12/18 3:56 PM, Michael S. Tsirkin wrote:
>> On Fri, Dec 07, 2018 at 06:52:31PM +0000, Jean-Philippe Brucker wrote:
>>> Sorry for the delay, I wanted to do a little more performance analysis
>>> before continuing.
>>>
>>> On 27/11/2018 18:10, Michael S. Tsirkin wrote:
>>>> On Tue, Nov 27, 2018 at 05:55:20PM +0000, Jean-Philippe Brucker wrote:
>>>>>>> +	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1) ||
>>>>>>> +	    !virtio_has_feature(vdev, VIRTIO_IOMMU_F_MAP_UNMAP))
>>>>>>
>>>>>> Why bother with a feature bit for this then btw?
>>>>>
>>>>> We'll need a new feature bit for sharing page tables with the hardware,
>>>>> because they require different requests (attach_table/invalidate instead
>>>>> of map/unmap.) A future device supporting page table sharing won't
>>>>> necessarily need to support map/unmap.
>>>>>
>>>> I don't see virtio iommu being extended to support ARM specific
>>>> requests. This just won't scale, too many different
>>>> descriptor formats out there.
>>>
>>> They aren't really ARM specific requests. The two new requests are
>>> ATTACH_TABLE and INVALIDATE, which would be used by x86 IOMMUs as well.
>>>
>>> Sharing CPU address space with the HW IOMMU (SVM) has been in the scope
>>> of virtio-iommu since the first RFC, and I've been working with that
>>> extension in mind since the beginning. As an example you can have a look
>>> at my current draft for this [1], which is inspired from the VFIO work
>>> we've been doing with Intel.
>>>
>>> The negotiation phase inevitably requires vendor-specific fields in the
>>> descriptors - host tells which formats are supported, guest chooses a
>>> format and attaches page tables. But invalidation and fault reporting
>>> descriptors are fairly generic.
>>
>> We need to tread carefully here.  People expect it that if user does
>> lspci and sees a virtio device then it's reasonably portable.
>>
>>>> If you want to go that way down the road, you should avoid
>>>> virtio iommu, instead emulate and share code with the ARM SMMU (probably
>>>> with a different vendor id so you can implement the
>>>> report on map for devices without PRI).
>>>
>>> vSMMU has to stay in userspace though. The main reason we're proposing
>>> virtio-iommu is that emulating every possible vIOMMU model in the kernel
>>> would be unmaintainable. With virtio-iommu we can process the fast path
>>> in the host kernel, through vhost-iommu, and do the heavy lifting in
>>> userspace.
>>
>> Interesting.
>>
>>> As said above, I'm trying to keep the fast path for
>>> virtio-iommu generic.
>>>
>>> More notes on what I consider to be the fast path, and comparison with
>>> vSMMU:
>>>
>>> (1) The primary use-case we have in mind for vIOMMU is something like
>>> DPDK in the guest, assigning a hardware device to guest userspace. DPDK
>>> maps a large amount of memory statically, to be used by a pass-through
>>> device. For this case I don't think we care about vIOMMU performance.
>>> Setup and teardown need to be reasonably fast, sure, but the MAP/UNMAP
>>> requests don't have to be optimal.
>>>
>>>
>>> (2) If the assigned device is owned by the guest kernel, then mappings
>>> are dynamic and require dma_map/unmap() to be fast, but there generally
>>> is no need for a vIOMMU, since device and drivers are trusted by the
>>> guest kernel. Even when the user does enable a vIOMMU for this case
>>> (allowing to over-commit guest memory, which needs to be pinned
>>> otherwise),
>>
>> BTW that's in theory in practice it doesn't really work.
>>
>>> we generally play tricks like lazy TLBI (non-strict mode) to
>>> make it faster.
>>
>> Simple lazy TLB for guest/userspace drivers would be a big no no.
>> You need something smarter.
>>
>>> Here device and drivers are trusted, therefore the
>>> vulnerability window of lazy mode isn't a concern.
>>>
>>> If the reason to enable the vIOMMU is over-comitting guest memory
>>> however, you can't use nested translation because it requires pinning
>>> the second-level tables. For this case performance matters a bit,
>>> because your invalidate-on-map needs to be fast, even if you enable lazy
>>> mode and only receive inval-on-unmap every 10ms. It won't ever be as
>>> fast as nested translation, though. For this case I think vSMMU+Caching
>>> Mode and userspace virtio-iommu with MAP/UNMAP would perform similarly
>>> (given page-sized payloads), because the pagetable walk doesn't add a
>>> lot of overhead compared to the context switch. But given the results
>>> below, vhost-iommu would be faster than vSMMU+CM.
>>>
>>>
>>> (3) Then there is SVM. For SVM, any destructive change to the process
>>> address space requires a synchronous invalidation command to the
>>> hardware (at least when using PCI ATS). Given that SVM is based on page
>>> faults, fault reporting from host to guest also needs to be fast, as
>>> well as fault response from guest to host.
>>>
>>> I think this is where performance matters the most. To get a feel of the
>>> advantage we get with virtio-iommu, I compared the vSMMU page-table
>>> sharing implementation [2] and vhost-iommu + VFIO with page table
>>> sharing (based on Tomasz Nowicki's vhost-iommu prototype). That's on a
>>> ThunderX2 with a 10Gb NIC assigned to the guest kernel, which
>>> corresponds to case (2) above, with nesting page tables and without the
>>> lazy mode. The host's only job is forwarding invalidation to the HW SMMU.
>>>
>>> vhost-iommu performed on average 1.8x and 5.5x better than vSMMU on
>>> netperf TCP_STREAM and TCP_MAERTS respectively (~200 samples). I think
>>> this can be further optimized (that was still polling under the vq
>>> lock), and unlike vSMMU, virtio-iommu offers the possibility of
>>> multi-queue for improved scalability. In addition, the guest will need
>>> to send both TLB and ATC invalidations with vSMMU, but virtio-iommu
>>> allows to multiplex those, and to invalidate ranges. Similarly for fault
>>> injection, having the ability to report page faults to the guest from
>>> the host kernel should be significantly faster than having to go to
>>> userspace and back to the kernel.
>>
>> Fascinating. Any data about host CPU utilization?
>>
>> Eric what do you think?
>>
>> Is it true that SMMUv3 is fundmentally slow at the architecture level
>> and so a PV interface will always scale better until
>> a new hardware interface is designed?
> 
> As far as I understand the figures above correspond to vhost-iommu
> against vsmmuv3. In the 2 cases the guest owns stage1 tables so the
> difference comes from the IOTLB invalidation handling. With vhost we
> avoid a kernel <-> userspace round trip which may mostly explain the
> difference.
> 
> About SMMUv3 issues I already reported one big limitation with respect
> to hugepage invalidation. See [RFC v2 4/4] iommu/arm-smmu-v3: add
> CMD_TLBI_NH_VA_AM command for iova range invalidation
> (https://lkml.org/lkml/2017/8/11/428).
> 
> At smmuv3 guest driver level, arm_smmu_tlb_inv_range_nosync(), when
> called with a hugepage size, invalidates each 4K/64K page of the region
> and not the whole region at once. Each of them are trapped by the SMMUv3
> device which forwards them to the host. This stalls the guest. This
> issue can be observed in DPDK case - not the use case benchmarked above - .
> 
> I raised this point again in recent discussions and it is unclear
> whether this is an SMMUv3 driver limitation or an architecture
> limitation. Seems a single invalidation within the block mapping should
> invalidate the whole mapping at HW level. In the past I hacked a
> workaround by defining an implementation defined invalidation command.
> 
> Robin/Will, could you please explain the rationale behind the
> arm_smmu_tlb_inv_range_nosync() implementation.

Fundamentally, TLBI commands only take an address, so invalidations have 
to match the actual leaf PTEs being removed. If iommu_unmap() sees that 
2MB is a valid block size, it may send a single "unmap this 2MB" request 
to the driver, but nobody knows how that region is actually mapped until 
the pagetable code walks the tables. If it does find a 2MB block PTE, 
then it can simply clear it and generate a single invalidation command - 
if a TLB entry exists for that block mapping then any address within the 
block will match it. If however that 2MB region was actually covered by 
a subtable of 4KB pages, then separate TLB entries may exist for any or 
all of those pages, and a single address can at best only match one of 
them. Thus after the table PTE is cleared, a separate command has to be 
generated for each page to ensure that all possible TLB entries 
associated with that table are invalidated.

So if you're seeing page-granularity invalidation, it means that the 
thing you're unmapping wasn't actually mapped as that size of hugepage 
in the first place (or something pathological has caused it to be split 
in the meantime - I recall we once had an amusing bug which caused VFIO 
to do that on teardown). There is one suboptimal case if we're taking 
out potentially multiple levels of table at once (e.g. a 1GB region), 
where we don't bother recursing down the removed table to see whether 
anything was mapped with blocks at the intermediate level, and just 
invalidate the whole lot at page granularity to cover the worst-case 
scenario. I think we assumed that sort of unmap would be unlikely enough 
that it wasn't worth optimising for at the time, but there's certainly 
scope to improve it if unmapping 1GB worth of 2MB blocks turns out to be 
a common thing.

FWIW SMMUv3.2 has introduced actual range-invalidation commands - 
reworking all the TLBI logic in the driver to make worthwhile use of 
those is on the to-do list, but until real 3.2 hardware starts coming to 
light I've not been prioritising it.

Robin.

> 
> Thanks
> 
> Eric
> 
> 
> 
>>
>>
>>>
>>> (4) Virtio and vhost endpoints weren't really a priority for the base
>>> virtio-iommu device, we were looking mainly at device pass-through. I
>>> have optimizations in mind for this, although a lot of them are based on
>>> page tables, not MAP/UNMAP requests. But just getting the vIOMMU closer
>>> to vhost devices, avoiding the trip to userspace through vhost-tlb,
>>> should already improve things.
>>>
>>> The important difference when DMA is done by software is that you don't
>>> need to mirror all mappings into the HW IOMMU - you don't need
>>> inval-on-map. The endpoint can ask the vIOMMU for mappings when it needs
>>> them, like vhost-iotlb does for example. So the MAP/UNMAP interface of
>>> virtio-iommu performs poorly for emulated/PV endpoints compared to an
>>> emulated IOMMU, since it requires three context switches for DMA
>>> (MAP/DMA/UNMAP) between host and guest, rather than two (DMA/INVAL).
>>> There is a feature I call "posted MAP", that avoids the kick on MAP and
>>> instead lets the device fetch the MAP request on TLB miss, but I haven't
>>> spent enough time experimenting with this.
>>>
>>>> Others on the TC might feel differently.
>>>>
>>>> If someone's looking into adding virtio iommu support in hardware,
>>>> that's a different matter. Which is it?
>>>
>>> I'm not aware of anything like that, and suspect that no one would
>>> consider it until virtio-iommu is more widely adopted.
>>>
>>> Thanks,
>>> Jean
>>>
>>>
>>> [1] Diff between current spec and page table sharing draft
>>>      (Very rough, missing page fault support and I'd like to rework the
>>>       PASID model a bit, but table descriptors p.24-26 for both Arm
>>>       SMMUv2 and SMMUv3.)
>>>
>>> http://jpbrucker.net/virtio-iommu/spec-table/diffs/virtio-iommu-pdf-diff-v0.9-v0.10.dev03.pdf
>>>
>>> [2] [RFC v2 00/28] vSMMUv3/pSMMUv3 2 stage VFIO integration
>>>      https://www.mail-archive.com/qemu-devel@nongnu.org/msg562369.html
