From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 0/5] Add virtio-iommu driver
Date: Wed, 27 Jun 2018 22:59:39 +0300
Message-ID: <20180627224801-mutt-send-email-mst@kernel.org>
References: <20180621190655.56391-1-jean-philippe.brucker@arm.com>
 <20180626210132-mutt-send-email-mst@kernel.org>
 <2bcda195-d2c6-fbf0-322e-d91756fc3547@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <virtio-dev-return-4586-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <2bcda195-d2c6-fbf0-322e-d91756fc3547@arm.com>
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, "jasowang@redhat.com" <jasowang@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, Will Deacon <Will.Deacon@arm.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>, bharat.bhushan@
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 27, 2018 at 07:04:46PM +0100, Jean-Philippe Brucker wrote:
> On 26/06/18 19:07, Michael S. Tsirkin wrote:
> > So as I pointed out new virtio 0 device isn't really welcome ;)
> 
> Agreed, virtio-iommu is expected to be implemented on virtio 1 and
> later. I'll remove the two legacy-related paragraph from the spec and
> add a check in the driver as you suggested, to avoid giving the wrong idea.
> 
> > No one bothered implementing virtio 1 in MMIO for all the work
> > that was put in defining it.
> 
> That is curious, given that the virtio_mmio driver supports virtio 1 and
> from my own experience, porting the MMIO transport to virtio 1 only
> requires updating a few registers, when ANY_LAYOUT, modern virtqueue and
> status are already implemented.
> 
> > The fact that the MMIO part of the
> > spec doesn't seem to allow for transitional devices might
> > or might not have something to do with this.
> 
> Sorry, which part do you have in mind? The spec does provide both a
> legacy and modern register layout, with version numbers to differentiate
> them.

Yes but there's no way to implement a transitional virtio mmio
device. The version is either "legacy" or "modern".

So if you implement a modern device old guests won't work with it.

> > So why make it an MMIO device at all? A system with an IOMMU
> > will have a PCI bus, won't it? And it's pretty common to
> > have the IOMMU be a PCI device on the root bus.
> Having the IOMMU outside PCI seems more common though. On Arm and Intel
> the IOMMU doesn't have a PCI config space, BARs or capabilities, just a
> plain MMIO region and a static number of interrupts. However the AMD
> IOMMU appears as a PCI device with additional MMIO registers. I would be
> interested in implementing virtio-iommu as a PCI dev at some point, at
> least so that we can use MSI-X.
> 
> The problem is that it requires invasive changes in the firmware
> interfaces and drivers. They need to describe relationship between IOMMU
> and endpoint, and DT or ACPI IORT don't expect the programming interface
> to be inside the PCI bus that the IOMMU manages.

They don't particularly care IMHO.

> Describing it as a
> peripheral is more natural. For AMD it is implemented in their driver
> using IVHD tables that can't be reused. Right now I don't expect any
> success in proposing changes to firmware interfaces or drivers, because
> the device is new and paravirtualized, and works out of the box with
> MMIO. Hopefully that will change in the future, perhaps when someone
> supports DT for AMD IOMMU (they do describe bindings at the end of the
> spec, but I don't think it can work in Linux with the existing
> infrastructure)

That's a bit abstract, I don't really understand the issues involved.
ACPI is formatted by QEMU, so firmware does not need to care.
And is there even a DT for intel?

> Another reason to keep the MMIO transport option is that one
> virtio-iommu can manage DMA from endpoints on multiple PCI domains at
> the same time, as well as platform devices. Some VMMs might want that,
> in which case the IOMMU would be a separate platform device.

Which buses are managed by the IOMMU is separate from the bus
on which it's programming interface resides.

> > Will remove need to bother with dt bindings etc.
> That's handled by the firmware drivers and IOMMU layer, there shouldn't
> be any special treatment at the virtio layer. In general removal of an
> IOMMU needs to be done after removal of all endpoints connected to it,
> which should be described using device_link from the driver core. DT or
> ACPI is only used to tell drivers where to find resources, and to
> describe the DMA topology.
> 
> Thanks,
> Jean

My point was virtio mmio isn't widely used outside of ARM.
Rather than try to make everyone use it, IMHO it's better
to start with PCI.

-- 
MST
