From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v6 0/7] Add virtio-iommu driver
Date: Wed, 12 Dec 2018 09:35:19 -0500
Message-ID: <20181212093413-mutt-send-email-mst@kernel.org>
References: <20181211182104.18241-1-jean-philippe.brucker@arm.com>
 <20181212103545.GV16835@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <virtio-dev-return-5188-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <20181212103545.GV16835@8bytes.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org, devicetree@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, jasowang@redhat.com, robh+dt@kernel.org, mark.rutland@arm.com, bhelgaas@google.com, frowand.list@gmail.com, kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com, tnowicki@caviumnetworks.com, kevin.tian@intel.com, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com, bharat.bhushan@nxp.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 12, 2018 at 11:35:45AM +0100, Joerg Roedel wrote:
> Hi,
> 
> to make progress on this, we should first agree on the protocol used
> between guest and host. I have a few points to discuss on the protocol
> first.
> 
> On Tue, Dec 11, 2018 at 06:20:57PM +0000, Jean-Philippe Brucker wrote:
> > [1] Virtio-iommu specification v0.9, sources and pdf
> >     git://linux-arm.org/virtio-iommu.git virtio-iommu/v0.9
> >     http://jpbrucker.net/virtio-iommu/spec/v0.9/virtio-iommu-v0.9.pdf
> 
> Looking at this I wonder why it doesn't make the IOTLB visible to the
> guest. the UNMAP requests seem to require that the TLB is already
> flushed to make the unmap visible.
> 
> I think that will cost significant performance for both, vfio and
> dma-iommu use-cases which both do (vfio at least to some degree),
> deferred flushing.
> 
> I also wonder whether the protocol should implement a
> protocol version handshake

virtio has a builtin version handshake so devices don't need to.

> and iommu-feature set queries.
> 
> > [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.9.1
> >     git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.9
> 
> Unfortunatly gitweb seems to be broken on linux-arm.org. What is missing
> in this patch-set to make this work on x86?

And I wonder about pcc too.

> Regards,
> 
> 	Joerg
