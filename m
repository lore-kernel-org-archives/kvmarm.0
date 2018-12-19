From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v6 0/7] Add virtio-iommu driver
Date: Wed, 19 Dec 2018 18:09:59 -0500
Message-ID: <20181219180417-mutt-send-email-mst@kernel.org>
References: <20181211182104.18241-1-jean-philippe.brucker@arm.com>
 <20181212103545.GV16835@8bytes.org>
 <9110873f-d344-b6b9-c722-9accfc329db2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <virtio-dev-return-5202-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <9110873f-d344-b6b9-c722-9accfc329db2@arm.com>
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "frowand.list@gmail.com" <frowand.list@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "eric.auger@redhat.com" <eric.auger@redhat.com>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Robin Murphy <Robin.Murph>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 13, 2018 at 12:50:29PM +0000, Jean-Philippe Brucker wrote:
> >> [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.9.1
> >>     git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.9
> > 
> > Unfortunatly gitweb seems to be broken on linux-arm.org. What is missing
> > in this patch-set to make this work on x86?
> 
> You should be able to access it here:
> http://www.linux-arm.org/git?p=linux-jpb.git;a=shortlog;h=refs/heads/virtio-iommu/devel
> 
> That branch contains missing bits for x86 support:
> 
> * ACPI support. We have the code but it's waiting for an IORT spec
> update, to reserve the IORT node ID. I expect it to take a while, given
> that I'm alone requesting a change for something that's not upstream or
> in hardware.

Frankly I think you should take a hard look at just getting the data
needed from the PCI device itself.  You don't need to depend on virtio,
it can be a small driver that gets you that data from the device config
space and then just goes away.

If you want help with writing such a small driver let me know.

If there's an advantage to virtio-iommu then that would be its
portability, and it all goes out of the window because
of dependencies on ACPI and DT and OF and the rest of the zoo.


> * DMA ops for x86 (see "HACK" commit). I'd like to use dma-iommu but I'm
> not sure how to implement the glue that sets dma_ops properly.
> 
> Thanks,
> Jean

OK so IIUC you are looking into Christoph's suggestions to fix that up?

There's still a bit of time left before the merge window,
maybe you can make above changes.

-- 
MST
