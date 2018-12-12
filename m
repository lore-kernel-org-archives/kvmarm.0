From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v6 0/7] Add virtio-iommu driver
Date: Tue, 11 Dec 2018 19:39:28 -0500
Message-ID: <20181211193249-mutt-send-email-mst@kernel.org>
References: <20181211182104.18241-1-jean-philippe.brucker@arm.com>
 <20181211183101.GA31936@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <virtio-dev-return-5186-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <20181211183101.GA31936@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org, devicetree@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, joro@8bytes.org, mark.rutland@arm.com, kevin.tian@intel.com, tnowicki@caviumnetworks.com, marc.zyngier@arm.com, robin.murphy@arm.com, jasowang@redhat.com, will.deacon@arm.com, robh+dt@kernel.org, bhelgaas@google.com, frowand.list@gmail.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 11, 2018 at 10:31:01AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 11, 2018 at 06:20:57PM +0000, Jean-Philippe Brucker wrote:
> > Implement the virtio-iommu driver, following specification v0.9 [1].
> > 
> > Only minor changes since v5 [2]. I fixed issues reported by Michael and
> > added tags from Eric and Bharat. Thanks!
> > 
> > You can find Linux driver and kvmtool device on v0.9 branches [3],
> > module and x86 support on virtio-iommu/devel. Also tested with Eric's
> > QEMU device [4].
> 
> Just curious, what is the use case for it?

If what I saw is any indication, it allows a very simple implementation
of page table shadowing on the host, at the cost of not being able to
accelerate with a hardware nested page tables support when available.

-- 
MST
