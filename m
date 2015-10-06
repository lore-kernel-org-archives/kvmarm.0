From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 5/6] vfio-pci: Create iommu mapping for msi interrupt
Date: Tue, 06 Oct 2015 09:06:37 -0600
Message-ID: <1444143997.4059.31.camel@redhat.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1443624989-24346-5-git-send-email-Bharat.Bhushan@freescale.com>
	 <1443825993.26107.190.camel@redhat.com>
	 <CY1PR0301MB1276F1B231284369F36D486490480@CY1PR0301MB1276.namprd03.prod.outlook.com>
	 <1444085096.26107.363.camel@redhat.com>
	 <CY1PR0301MB1276D7FC6ED3D31CF341790490370@CY1PR0301MB1276.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CY1PR0301MB1276D7FC6ED3D31CF341790490370@CY1PR0301MB1276.namprd03.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
To: Bhushan Bharat <Bharat.Bhushan@freescale.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "pranavkumar@linaro.org" <pranavkumar@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 2015-10-06 at 08:32 +0000, Bhushan Bharat wrote:
> 
> 
> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Tuesday, October 06, 2015 4:15 AM
> > To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
> > Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> > christoffer.dall@linaro.org; eric.auger@linaro.org; pranavkumar@linaro.org;
> > marc.zyngier@arm.com; will.deacon@arm.com
> > Subject: Re: [RFC PATCH 5/6] vfio-pci: Create iommu mapping for msi
> > interrupt
> > 
> > On Mon, 2015-10-05 at 07:20 +0000, Bhushan Bharat wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > Sent: Saturday, October 03, 2015 4:17 AM
> > > > To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
> > > > Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> > > > christoffer.dall@linaro.org; eric.auger@linaro.org;
> > > > pranavkumar@linaro.org; marc.zyngier@arm.com; will.deacon@arm.com
> > > > Subject: Re: [RFC PATCH 5/6] vfio-pci: Create iommu mapping for msi
> > > > interrupt
> > > >
> > > > On Wed, 2015-09-30 at 20:26 +0530, Bharat Bhushan wrote:
> > > > > An MSI-address is allocated and programmed in pcie device during
> > > > > interrupt configuration. Now for a pass-through device, try to
> > > > > create the iommu mapping for this allocted/programmed msi-address.
> > > > > If the iommu mapping is created and the msi address programmed in
> > > > > the pcie device is different from msi-iova as per iommu
> > > > > programming then reconfigure the pci device to use msi-iova as msi
> > address.
> > > > >
> > > > > Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
> > > > > ---
> > > > >  drivers/vfio/pci/vfio_pci_intrs.c | 36
> > > > > ++++++++++++++++++++++++++++++++++--
> > > > >  1 file changed, 34 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vfio/pci/vfio_pci_intrs.c
> > > > > b/drivers/vfio/pci/vfio_pci_intrs.c
> > > > > index 1f577b4..c9690af 100644
> > > > > --- a/drivers/vfio/pci/vfio_pci_intrs.c
> > > > > +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> > > > > @@ -312,13 +312,23 @@ static int vfio_msi_set_vector_signal(struct
> > > > vfio_pci_device *vdev,
> > > > >  	int irq = msix ? vdev->msix[vector].vector : pdev->irq + vector;
> > > > >  	char *name = msix ? "vfio-msix" : "vfio-msi";
> > > > >  	struct eventfd_ctx *trigger;
> > > > > +	struct msi_msg msg;
> > > > > +	struct vfio_device *device;
> > > > > +	uint64_t msi_addr, msi_iova;
> > > > >  	int ret;
> > > > >
> > > > >  	if (vector >= vdev->num_ctx)
> > > > >  		return -EINVAL;
> > > > >
> > > > > +	device = vfio_device_get_from_dev(&pdev->dev);
> > > >
> > > > Have you looked at this function?  I don't think we want to be doing
> > > > that every time we want to poke the interrupt configuration.
> > >
> > > I am trying to describe what I understood, a device can have many
> > interrupts and we should setup iommu only once, when called for the first
> > time to enable/setup interrupt.
> > > Similarly when disabling the interrupt we should iommu-unmap when
> > > called for the last enabled interrupt for that device. Now with this
> > > understanding, should I move this map-unmap to separate functions and
> > > call them from vfio_msi_set_block() rather than in
> > > vfio_msi_set_vector_signal()
> > 
> > Interrupts can be setup and torn down at any time and I don't see how one
> > function or the other makes much difference.
> > vfio_device_get_from_dev() is enough overhead that the data we need
> > should be cached if we're going to call it with some regularity.  Maybe
> > vfio_iommu_driver_ops.open() should be called with a pointer to the
> > vfio_device... or the vfio_group.
> 
> vfio_iommu_driver_ops.open() ? or do you mean vfio_pci_open() should be called with vfio_device or vfio_group, and we will cache that in vfio_pci_device ?

vfio_pci_open() is an implementation of vfio_iommu_driver_ops.open().
The internal API between vfio and vfio bus drivers would need to have a
parameter added.

