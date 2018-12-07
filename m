From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: Re: [PATCH v5 5/7] iommu: Add virtio-iommu driver
Date: Fri, 7 Dec 2018 18:52:31 +0000
Message-ID: <e1dde79c-0bc4-ea99-1bb0-9e70b56955fb@arm.com>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
 <20181122193801.50510-6-jean-philippe.brucker@arm.com>
 <20181123165206-mutt-send-email-mst@kernel.org>
 <e76a51ba-7a0f-3fca-a1ae-640131f9dfe1@arm.com>
 <20181127130527-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-5145-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20181127130527-mutt-send-email-mst@kernel.org>
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: mark.rutland@arm.com, virtio-dev@lists.oasis-open.org, lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com, devicetree@vger.kernel.org, marc.zyngier@arm.com, linux-pci@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, virtualization@lists.linux-foundation.org, eric.auger@redhat.com, iommu@lists.linux-foundation.org, robh+dt@kernel.org, bhelgaas@google.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Sorry for the delay, I wanted to do a little more performance analysis
before continuing.

On 27/11/2018 18:10, Michael S. Tsirkin wrote:
> On Tue, Nov 27, 2018 at 05:55:20PM +0000, Jean-Philippe Brucker wrote:
>>>> +	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1) ||
>>>> +	    !virtio_has_feature(vdev, VIRTIO_IOMMU_F_MAP_UNMAP))
>>>
>>> Why bother with a feature bit for this then btw?
>>
>> We'll need a new feature bit for sharing page tables with the hardware,
>> because they require different requests (attach_table/invalidate instead
>> of map/unmap.) A future device supporting page table sharing won't
>> necessarily need to support map/unmap.
>>
> I don't see virtio iommu being extended to support ARM specific
> requests. This just won't scale, too many different
> descriptor formats out there.

They aren't really ARM specific requests. The two new requests are
ATTACH_TABLE and INVALIDATE, which would be used by x86 IOMMUs as well.

Sharing CPU address space with the HW IOMMU (SVM) has been in the scope
of virtio-iommu since the first RFC, and I've been working with that
extension in mind since the beginning. As an example you can have a look
at my current draft for this [1], which is inspired from the VFIO work
we've been doing with Intel.

The negotiation phase inevitably requires vendor-specific fields in the
descriptors - host tells which formats are supported, guest chooses a
format and attaches page tables. But invalidation and fault reporting
descriptors are fairly generic.

> If you want to go that way down the road, you should avoid
> virtio iommu, instead emulate and share code with the ARM SMMU (probably
> with a different vendor id so you can implement the
> report on map for devices without PRI).

vSMMU has to stay in userspace though. The main reason we're proposing
virtio-iommu is that emulating every possible vIOMMU model in the kernel
would be unmaintainable. With virtio-iommu we can process the fast path
in the host kernel, through vhost-iommu, and do the heavy lifting in
userspace. As said above, I'm trying to keep the fast path for
virtio-iommu generic.


More notes on what I consider to be the fast path, and comparison with
vSMMU:

(1) The primary use-case we have in mind for vIOMMU is something like
DPDK in the guest, assigning a hardware device to guest userspace. DPDK
maps a large amount of memory statically, to be used by a pass-through
device. For this case I don't think we care about vIOMMU performance.
Setup and teardown need to be reasonably fast, sure, but the MAP/UNMAP
requests don't have to be optimal.


(2) If the assigned device is owned by the guest kernel, then mappings
are dynamic and require dma_map/unmap() to be fast, but there generally
is no need for a vIOMMU, since device and drivers are trusted by the
guest kernel. Even when the user does enable a vIOMMU for this case
(allowing to over-commit guest memory, which needs to be pinned
otherwise), we generally play tricks like lazy TLBI (non-strict mode) to
make it faster. Here device and drivers are trusted, therefore the
vulnerability window of lazy mode isn't a concern.

If the reason to enable the vIOMMU is over-comitting guest memory
however, you can't use nested translation because it requires pinning
the second-level tables. For this case performance matters a bit,
because your invalidate-on-map needs to be fast, even if you enable lazy
mode and only receive inval-on-unmap every 10ms. It won't ever be as
fast as nested translation, though. For this case I think vSMMU+Caching
Mode and userspace virtio-iommu with MAP/UNMAP would perform similarly
(given page-sized payloads), because the pagetable walk doesn't add a
lot of overhead compared to the context switch. But given the results
below, vhost-iommu would be faster than vSMMU+CM.


(3) Then there is SVM. For SVM, any destructive change to the process
address space requires a synchronous invalidation command to the
hardware (at least when using PCI ATS). Given that SVM is based on page
faults, fault reporting from host to guest also needs to be fast, as
well as fault response from guest to host.

I think this is where performance matters the most. To get a feel of the
advantage we get with virtio-iommu, I compared the vSMMU page-table
sharing implementation [2] and vhost-iommu + VFIO with page table
sharing (based on Tomasz Nowicki's vhost-iommu prototype). That's on a
ThunderX2 with a 10Gb NIC assigned to the guest kernel, which
corresponds to case (2) above, with nesting page tables and without the
lazy mode. The host's only job is forwarding invalidation to the HW SMMU.

vhost-iommu performed on average 1.8x and 5.5x better than vSMMU on
netperf TCP_STREAM and TCP_MAERTS respectively (~200 samples). I think
this can be further optimized (that was still polling under the vq
lock), and unlike vSMMU, virtio-iommu offers the possibility of
multi-queue for improved scalability. In addition, the guest will need
to send both TLB and ATC invalidations with vSMMU, but virtio-iommu
allows to multiplex those, and to invalidate ranges. Similarly for fault
injection, having the ability to report page faults to the guest from
the host kernel should be significantly faster than having to go to
userspace and back to the kernel.


(4) Virtio and vhost endpoints weren't really a priority for the base
virtio-iommu device, we were looking mainly at device pass-through. I
have optimizations in mind for this, although a lot of them are based on
page tables, not MAP/UNMAP requests. But just getting the vIOMMU closer
to vhost devices, avoiding the trip to userspace through vhost-tlb,
should already improve things.

The important difference when DMA is done by software is that you don't
need to mirror all mappings into the HW IOMMU - you don't need
inval-on-map. The endpoint can ask the vIOMMU for mappings when it needs
them, like vhost-iotlb does for example. So the MAP/UNMAP interface of
virtio-iommu performs poorly for emulated/PV endpoints compared to an
emulated IOMMU, since it requires three context switches for DMA
(MAP/DMA/UNMAP) between host and guest, rather than two (DMA/INVAL).
There is a feature I call "posted MAP", that avoids the kick on MAP and
instead lets the device fetch the MAP request on TLB miss, but I haven't
spent enough time experimenting with this.

> Others on the TC might feel differently.
> 
> If someone's looking into adding virtio iommu support in hardware,
> that's a different matter. Which is it?

I'm not aware of anything like that, and suspect that no one would
consider it until virtio-iommu is more widely adopted.

Thanks,
Jean


[1] Diff between current spec and page table sharing draft
    (Very rough, missing page fault support and I'd like to rework the
     PASID model a bit, but table descriptors p.24-26 for both Arm
     SMMUv2 and SMMUv3.)

http://jpbrucker.net/virtio-iommu/spec-table/diffs/virtio-iommu-pdf-diff-v0.9-v0.10.dev03.pdf

[2] [RFC v2 00/28] vSMMUv3/pSMMUv3 2 stage VFIO integration
    https://www.mail-archive.com/qemu-devel@nongnu.org/msg562369.html
