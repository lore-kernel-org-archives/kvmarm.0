From: Bhushan Bharat <Bharat.Bhushan@freescale.com>
Subject: RE: [RFC PATCH 5/6] vfio-pci: Create iommu mapping for msi interrupt
Date: Tue, 6 Oct 2015 08:32:36 +0000
Message-ID: <CY1PR0301MB1276D7FC6ED3D31CF341790490370@CY1PR0301MB1276.namprd03.prod.outlook.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1443624989-24346-5-git-send-email-Bharat.Bhushan@freescale.com>
 <1443825993.26107.190.camel@redhat.com>
 <CY1PR0301MB1276F1B231284369F36D486490480@CY1PR0301MB1276.namprd03.prod.outlook.com>
 <1444085096.26107.363.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED26041973
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 04:30:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3PjQOp-OsIQa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Oct 2015 04:30:45 -0400 (EDT)
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0142.outbound.protection.outlook.com [65.55.169.142])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DEB4412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 04:30:45 -0400 (EDT)
In-Reply-To: <1444085096.26107.363.camel@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Tuesday, October 06, 2015 4:15 AM
> To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
> Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> christoffer.dall@linaro.org; eric.auger@linaro.org; pranavkumar@linaro.org;
> marc.zyngier@arm.com; will.deacon@arm.com
> Subject: Re: [RFC PATCH 5/6] vfio-pci: Create iommu mapping for msi
> interrupt
> 
> On Mon, 2015-10-05 at 07:20 +0000, Bhushan Bharat wrote:
> >
> >
> > > -----Original Message-----
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Saturday, October 03, 2015 4:17 AM
> > > To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
> > > Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> > > christoffer.dall@linaro.org; eric.auger@linaro.org;
> > > pranavkumar@linaro.org; marc.zyngier@arm.com; will.deacon@arm.com
> > > Subject: Re: [RFC PATCH 5/6] vfio-pci: Create iommu mapping for msi
> > > interrupt
> > >
> > > On Wed, 2015-09-30 at 20:26 +0530, Bharat Bhushan wrote:
> > > > An MSI-address is allocated and programmed in pcie device during
> > > > interrupt configuration. Now for a pass-through device, try to
> > > > create the iommu mapping for this allocted/programmed msi-address.
> > > > If the iommu mapping is created and the msi address programmed in
> > > > the pcie device is different from msi-iova as per iommu
> > > > programming then reconfigure the pci device to use msi-iova as msi
> address.
> > > >
> > > > Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
> > > > ---
> > > >  drivers/vfio/pci/vfio_pci_intrs.c | 36
> > > > ++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 34 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/vfio/pci/vfio_pci_intrs.c
> > > > b/drivers/vfio/pci/vfio_pci_intrs.c
> > > > index 1f577b4..c9690af 100644
> > > > --- a/drivers/vfio/pci/vfio_pci_intrs.c
> > > > +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> > > > @@ -312,13 +312,23 @@ static int vfio_msi_set_vector_signal(struct
> > > vfio_pci_device *vdev,
> > > >  	int irq = msix ? vdev->msix[vector].vector : pdev->irq + vector;
> > > >  	char *name = msix ? "vfio-msix" : "vfio-msi";
> > > >  	struct eventfd_ctx *trigger;
> > > > +	struct msi_msg msg;
> > > > +	struct vfio_device *device;
> > > > +	uint64_t msi_addr, msi_iova;
> > > >  	int ret;
> > > >
> > > >  	if (vector >= vdev->num_ctx)
> > > >  		return -EINVAL;
> > > >
> > > > +	device = vfio_device_get_from_dev(&pdev->dev);
> > >
> > > Have you looked at this function?  I don't think we want to be doing
> > > that every time we want to poke the interrupt configuration.
> >
> > I am trying to describe what I understood, a device can have many
> interrupts and we should setup iommu only once, when called for the first
> time to enable/setup interrupt.
> > Similarly when disabling the interrupt we should iommu-unmap when
> > called for the last enabled interrupt for that device. Now with this
> > understanding, should I move this map-unmap to separate functions and
> > call them from vfio_msi_set_block() rather than in
> > vfio_msi_set_vector_signal()
> 
> Interrupts can be setup and torn down at any time and I don't see how one
> function or the other makes much difference.
> vfio_device_get_from_dev() is enough overhead that the data we need
> should be cached if we're going to call it with some regularity.  Maybe
> vfio_iommu_driver_ops.open() should be called with a pointer to the
> vfio_device... or the vfio_group.

vfio_iommu_driver_ops.open() ? or do you mean vfio_pci_open() should be called with vfio_device or vfio_group, and we will cache that in vfio_pci_device ?

> 
> > >  Also note that
> > > IOMMU mappings don't operate on devices, but groups, so maybe we
> > > want to pass the group.
> >
> > Yes, it operates on group. I hesitated to add an API to get group. Do you
> suggest to that it is ok to add API to get group from device.
> 
> No, the above suggestion is probably better.
> 
> > >
> > > > +	if (device == NULL)
> > > > +		return -EINVAL;
> > >
> > > This would be a legitimate BUG_ON(!device)
> > >
> > > > +
> > > >  	if (vdev->ctx[vector].trigger) {
> > > >  		free_irq(irq, vdev->ctx[vector].trigger);
> > > > +		get_cached_msi_msg(irq, &msg);
> > > > +		msi_iova = ((u64)msg.address_hi << 32) | msg.address_lo;
> > > > +		vfio_device_unmap_msi(device, msi_iova, PAGE_SIZE);
> > > >  		kfree(vdev->ctx[vector].name);
> > > >  		eventfd_ctx_put(vdev->ctx[vector].trigger);
> > > >  		vdev->ctx[vector].trigger = NULL; @@ -346,12 +356,11 @@
> static
> > > > int vfio_msi_set_vector_signal(struct
> > > vfio_pci_device *vdev,
> > > >  	 * cached value of the message prior to enabling.
> > > >  	 */
> > > >  	if (msix) {
> > > > -		struct msi_msg msg;
> > > > -
> > > >  		get_cached_msi_msg(irq, &msg);
> > > >  		pci_write_msi_msg(irq, &msg);
> > > >  	}
> > > >
> > > > +
> > >
> > > gratuitous newline
> > >
> > > >  	ret = request_irq(irq, vfio_msihandler, 0,
> > > >  			  vdev->ctx[vector].name, trigger);
> > > >  	if (ret) {
> > > > @@ -360,6 +369,29 @@ static int vfio_msi_set_vector_signal(struct
> > > vfio_pci_device *vdev,
> > > >  		return ret;
> > > >  	}
> > > >
> > > > +	/* Re-program the new-iova in pci-device in case there is
> > > > +	 * different iommu-mapping created for programmed msi-address.
> > > > +	 */
> > > > +	get_cached_msi_msg(irq, &msg);
> > > > +	msi_iova = 0;
> > > > +	msi_addr = (u64)(msg.address_hi) << 32 | (u64)(msg.address_lo);
> > > > +	ret = vfio_device_map_msi(device, msi_addr, PAGE_SIZE,
> > > &msi_iova);
> > > > +	if (ret) {
> > > > +		free_irq(irq, vdev->ctx[vector].trigger);
> > > > +		kfree(vdev->ctx[vector].name);
> > > > +		eventfd_ctx_put(trigger);
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	/* Reprogram only if iommu-mapped iova is different from msi-
> > > address */
> > > > +	if (msi_iova && (msi_iova != msi_addr)) {
> > > > +		msg.address_hi = (u32)(msi_iova >> 32);
> > > > +		/* Keep Lower bits from original msi message address */
> > > > +		msg.address_lo &= PAGE_MASK;
> > > > +		msg.address_lo |= (u32)(msi_iova & 0x00000000ffffffff);
> > >
> > > Seems like you're making some assumptions here that are dependent on
> > > the architecture and maybe the platform.
> >
> > What I tried is to map the msi page with different iova, which is page size
> aligned. But the offset within the page will remain same.
> > For example, original msi address was 0x0603_0040 and we have a reserved
> region at 0xf000_0000. So iommu mapping is created for 0xf000_0000
> =>0x0600_3000 of size 0x1000.
> >
> > So the new address to be programmed in device is 0xf000_0040, offset
> 0x40 added to base address in iommu mapping.
> 
> Don't you need ~PAGE_MASK for it to work like that?  The & with
> 0x00000000ffffffff shouldn't be needed either, certainly not with all the
> leading zeros.

Yes, I think ~PAGE_MSK can be used.

Thanks
-Bharat

> 
> > > > +		pci_write_msi_msg(irq, &msg);
> > > > +	}
> > > > +
> > > >  	vdev->ctx[vector].trigger = trigger;
> > > >
> > > >  	return 0;
> > >
> > >
> >
> 
> 
