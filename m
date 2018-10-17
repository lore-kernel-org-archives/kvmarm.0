From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 3/7] PCI: OF: Allow endpoints to bypass the iommu
Date: Wed, 17 Oct 2018 11:14:05 -0400
Message-ID: <20181017111100-mutt-send-email-mst@kernel.org>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
	<20181012145917.6840-4-jean-philippe.brucker@arm.com>
	<20181012194158.GX5906@bhelgaas-glaptop.roam.corp.google.com>
	<20181015065024-mutt-send-email-mst@kernel.org>
	<482d0eb9-8c4c-9d64-7b32-25d5d11a8b8f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <482d0eb9-8c4c-9d64-7b32-25d5d11a8b8f@gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Jean-philippe Brucker <jphilippe.brucker@gmail.com>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, tnowicki@caviumnetworks.com, peter.maydell@linaro.org, marc.zyngier@arm.com, linux-pci@vger.kernel.org, will.deacon@arm.com, virtualization@lists.linux-foundation.org, jean-philippe.brucker@arm.com, iommu@lists.linux-foundation.org, robh+dt@kernel.org, Bjorn Helgaas <helgaas@kernel.org>, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 15, 2018 at 08:46:41PM +0100, Jean-philippe Brucker wrote:
> [Replying with my personal address because we're having SMTP issues]
> 
> On 15/10/2018 11:52, Michael S. Tsirkin wrote:
> > On Fri, Oct 12, 2018 at 02:41:59PM -0500, Bjorn Helgaas wrote:
> >> s/iommu/IOMMU/ in subject
> >>
> >> On Fri, Oct 12, 2018 at 03:59:13PM +0100, Jean-Philippe Brucker wrote:
> >>> Using the iommu-map binding, endpoints in a given PCI domain can be
> >>> managed by different IOMMUs. Some virtual machines may allow a subset of
> >>> endpoints to bypass the IOMMU. In some case the IOMMU itself is presented
> >>
> >> s/case/cases/
> >>
> >>> as a PCI endpoint (e.g. AMD IOMMU and virtio-iommu). Currently, when a
> >>> PCI root complex has an iommu-map property, the driver requires all
> >>> endpoints to be described by the property. Allow the iommu-map property to
> >>> have gaps.
> >>
> >> I'm not an IOMMU or virtio expert, so it's not obvious to me why it is
> >> safe to allow devices to bypass the IOMMU.  Does this mean a typo in
> >> iommu-map could inadvertently allow devices to bypass it?
> > 
> > 
> > Thinking about this comment, I would like to ask: can't the
> > virtio device indicate the ranges in a portable way?
> > This would minimize the dependency on dt bindings and ACPI,
> > enabling support for systems that have neither but do
> > have virtio e.g. through pci.
> 
> I thought about adding a PROBE request for this in virtio-iommu, but it
> wouldn't be usable by a Linux guest because of a bootstrapping problem.

Hmm. At some level it seems wrong to design hardware interfaces
around how Linux happens to probe things. That can change at any time
...

> Early on, Linux needs a description of device dependencies, to determine
> in which order to probe them. If the device dependency was described by
> virtio-iommu itself, the guest could for example initialize a NIC,
> allocate buffers and start DMA on the physical address space (which aborts
> if the IOMMU implementation disallows DMA by default), only to find out
> once the virtio-iommu module is loaded that it needs to cancel all DMA and
> reconfigure the NIC. With a static description such as iommu-map in DT or
> ACPI remapping tables, the guest can defer probing of the NIC until the
> IOMMU is initialized.
> 
> Thanks,
> Jean

Could you point me at the code you refer to here?

-- 
MST
