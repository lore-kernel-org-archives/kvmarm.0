From: Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH kvmtool v3 3/3] vfio-pci: Re-enable INTx mode when
 disable MSI/MSIX
Date: Fri, 5 Apr 2019 11:46:09 +0800
Message-ID: <20190405034609.GA6963@leoy-ThinkPad-X240s>
References: <20190326074131.4284-1-leo.yan@linaro.org>
 <20190326074131.4284-4-leo.yan@linaro.org>
 <fea39efb-1bc1-deff-e1a0-f695db429abb@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C344B4A426
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 23:46:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LFxBReIzwCDh for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 23:46:16 -0400 (EDT)
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com
 [209.85.214.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EBA34A332
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 23:46:16 -0400 (EDT)
Received: by mail-pl1-f193.google.com with SMTP id g12so2251775pll.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Apr 2019 20:46:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <fea39efb-1bc1-deff-e1a0-f695db429abb@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean-Philippe,

On Thu, Apr 04, 2019 at 12:06:51PM +0100, Jean-Philippe Brucker wrote:
> On 26/03/2019 07:41, Leo Yan wrote:
> > Since PCI forbids enabling INTx, MSI or MSIX at the same time, it's by
> > default to disable INTx mode when enable MSI/MSIX mode; but this logic is
> > easily broken if the guest PCI driver detects the MSI/MSIX cannot work as
> > expected and tries to rollback to use INTx mode.  In this case, the INTx
> > mode has been disabled and has no chance to re-enable it, thus both INTx
> > mode and MSI/MSIX mode cannot work in vfio.
> > 
> > Below shows the detailed flow for introducing this issue:
> > 
> >   vfio_pci_configure_dev_irqs()
> >     `-> vfio_pci_enable_intx()
> > 
> >   vfio_pci_enable_msis()
> >     `-> vfio_pci_disable_intx()
> > 
> >   vfio_pci_disable_msis()   => Guest PCI driver disables MSI
> > 
> > To fix this issue, when disable MSI/MSIX we need to check if INTx mode
> > is available for this device or not; if the device can support INTx then
> > re-enable it so that the device can fallback to use it.
> > 
> > Since vfio_pci_disable_intx() / vfio_pci_enable_intx() pair functions
> > may be called for multiple times, this patch uses 'intx_fd == -1' to
> > denote the INTx is disabled, the pair functions can directly bail out
> > when detect INTx has been disabled and enabled respectively.
> > 
> > Suggested-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> > Signed-off-by: Leo Yan <leo.yan@linaro.org>
> > ---
> >  vfio/pci.c | 41 ++++++++++++++++++++++++++++++-----------
> >  1 file changed, 30 insertions(+), 11 deletions(-)
> > 
> > diff --git a/vfio/pci.c b/vfio/pci.c
> > index 3c39844..3b2b1e7 100644
> > --- a/vfio/pci.c
> > +++ b/vfio/pci.c
> > @@ -28,6 +28,7 @@ struct vfio_irq_eventfd {
> >  	msi_update_state(state, val, VFIO_PCI_MSI_STATE_EMPTY)
> >  
> >  static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev);
> > +static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev);
> >  
> >  static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
> >  				bool msix)
> > @@ -50,17 +51,14 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
> >  	if (!msi_is_enabled(msis->virt_state))
> >  		return 0;
> >  
> > -	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX) {
> > -		/*
> > -		 * PCI (and VFIO) forbids enabling INTx, MSI or MSIX at the same
> > -		 * time. Since INTx has to be enabled from the start (we don't
> > -		 * have a reliable way to know when the user starts using it),
> > -		 * disable it now.
> > -		 */
> > +	/*
> > +	 * PCI (and VFIO) forbids enabling INTx, MSI or MSIX at the same
> > +	 * time. Since INTx has to be enabled from the start (after enabling
> > +	 * 'pdev->intx_fd' will be assigned to an eventfd and doesn't equal
> > +	 * to the init value -1), disable it now.
> > +	 */
> 
> I don't think the comment change is useful, we don't need that much
> detail. The text that you replaced was trying to explain why we enable
> INTx from the start, and would still apply (although it should have been
> s/user/guest/)
> 
> > +	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
> >  		vfio_pci_disable_intx(kvm, vdev);
> > -		/* Permanently disable INTx */
> > -		pdev->irq_modes &= ~VFIO_PCI_IRQ_MODE_INTX;
> > -	}
> >  
> >  	eventfds = (void *)msis->irq_set + sizeof(struct vfio_irq_set);
> >  
> > @@ -162,7 +160,16 @@ static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev,
> >  	msi_set_enabled(msis->phys_state, false);
> >  	msi_set_empty(msis->phys_state, true);
> >  
> > -	return 0;
> > +	/*
> > +	 * When MSI or MSIX is disabled, this might be called when
> > +	 * PCI driver detects the MSI interrupt failure and wants to
> > +	 * rollback to INTx mode.  Thus enable INTx if the device
> > +	 * supports INTx mode in this case.
> > +	 */
> > +	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
> > +		ret = vfio_pci_enable_intx(kvm, vdev);
> > +
> > +	return ret >= 0 ? 0 : ret;
> >  }
> >  
> >  static int vfio_pci_update_msi_entry(struct kvm *kvm, struct vfio_device *vdev,
> > @@ -1002,6 +1009,10 @@ static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
> >  		.index	= VFIO_PCI_INTX_IRQ_INDEX,
> >  	};
> >  
> > +	/* INTx mode has been disabled */
> 
> Here as well, the comments on intx_fd seem unnecessary. But these are
> only nits, the code is fine and I tested for regressions on my hardware, so:
> 
> Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

Thanks for reviewing.  I will spin a new patch set to drop unnecessary
comment to let changes as simple as possible.

Thanks,
Leo Yan
