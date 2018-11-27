From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v5 5/7] iommu: Add virtio-iommu driver
Date: Tue, 27 Nov 2018 13:10:43 -0500
Message-ID: <20181127131031-mutt-send-email-mst@kernel.org>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
 <20181122193801.50510-6-jean-philippe.brucker@arm.com>
 <20181123164716-mutt-send-email-mst@kernel.org>
 <0fed79f3-ca2e-b539-74f5-cd2a8091f65d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <virtio-dev-return-5057-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <0fed79f3-ca2e-b539-74f5-cd2a8091f65d@arm.com>
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "joro@8bytes.org" <joro@8bytes.org>, Mark Rutland <Mark.Rutland@arm.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, Will Deacon <Will.Deacon@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 27, 2018 at 05:58:18PM +0000, Jean-Philippe Brucker wrote:
> On 23/11/2018 21:48, Michael S. Tsirkin wrote:
> >> +struct virtio_iommu_config {
> >> +	/* Supported page sizes */
> >> +	__u64					page_size_mask;
> >> +	/* Supported IOVA range */
> >> +	struct virtio_iommu_range		input_range;
> >> +	/* Max domain ID size */
> >> +	__u8					domain_bits;
> >> +	__u8					padding[3];
> > 
> > Not enough padding here it seems. Structure is 8 byte
> > aligned on 64 bit systems.
> 
> The next field (probe_size) is 4 bytes, so the alignment ends up fine.
> That field is introduced in patch 6, maybe I should move it here?
> 
> Thanks,
> Jean

Sounds like a good idea.

-- 
MST
