From: Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH kvmtool v1 2/2] vfio-pci: Fallback to INTx mode when
 disable MSI/MSIX
Date: Wed, 20 Mar 2019 09:04:40 +0800
Message-ID: <20190320010440.GB18687@leoy-ThinkPad-X240s>
References: <20190315083315.19221-1-leo.yan@linaro.org>
 <20190315083315.19221-2-leo.yan@linaro.org>
 <0f3ab1a0-b993-ca9d-3a02-3f56ff7967f8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8138F4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 21:04:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F-wmKTwXJz+f for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 21:04:46 -0400 (EDT)
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A171D4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 21:04:46 -0400 (EDT)
Received: by mail-oi1-f196.google.com with SMTP id i21so458193oib.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 18:04:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <0f3ab1a0-b993-ca9d-3a02-3f56ff7967f8@arm.com>
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
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean-Philippe,

On Fri, Mar 15, 2019 at 02:20:07PM +0000, Jean-Philippe Brucker wrote:
> On 15/03/2019 08:33, Leo Yan wrote:
> > Since PCI forbids enabling INTx, MSI or MSIX at the same time, it's by
> > default to disable INTx mode when enable MSI/MSIX mode; but this logic is
> > easily broken if the guest PCI driver detects the MSI/MSIX cannot work as
> > expected and tries to rollback to use INTx mode.  The INTx mode has been
> > disabled and it has no chance to be enabled again, thus both INTx mode
> > and MSI/MSIX mode will not be enabled in vfio for this case.
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
> > we need to re-enable it so the device can fallback to use it.
> > 
> > Signed-off-by: Leo Yan <leo.yan@linaro.org>
> > ---
> >  vfio/pci.c | 17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> > 
> > diff --git a/vfio/pci.c b/vfio/pci.c
> > index c0683f6..44727bb 100644
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
> > @@ -50,7 +51,7 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
> >  	if (!msi_is_enabled(msis->virt_state))
> >  		return 0;
> >  
> > -	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX) {
> > +	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
> >  		/*
> >  		 * PCI (and VFIO) forbids enabling INTx, MSI or MSIX at the same
> >  		 * time. Since INTx has to be enabled from the start (we don't
> > @@ -58,9 +59,6 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
> >  		 * disable it now.
> >  		 */
> >  		vfio_pci_disable_intx(kvm, vdev);
> > -		/* Permanently disable INTx */
> > -		pdev->irq_modes &= ~VFIO_PCI_IRQ_MODE_INTX;
> 
> As a result vfio_pci_disable_intx() may be called multiple times (each
> time the guest enables one MSI vector). Could you make
> vfio_pci_disable_intx() safe against that (maybe use intx_fd == -1 to
> denote the INTx state)?

Will do this.

> > -	}
> >  
> >  	eventfds = (void *)msis->irq_set + sizeof(struct vfio_irq_set);
> >  
> > @@ -162,7 +160,16 @@ static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev,
> >  	msi_set_enabled(msis->phys_state, false);
> >  	msi_set_empty(msis->phys_state, true);
> >  
> > -	return 0;
> > +	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
> > +		/*
> > +		 * When MSI or MSIX is disabled, this might be called when
> > +		 * PCI driver detects the MSI interrupt failure and wants to
> > +		 * rollback to INTx mode.  Thus enable INTx if the device
> > +		 * supports INTx mode in this case.
> > +		 */
> > +		ret = vfio_pci_enable_intx(kvm, vdev);
> 
> Let's remove vfio_pci_reserve_irq_fds(2) from vfio_pci_enable_intx(), it
> should only called once per run, and isn't particularly useful here
> since INTx only uses 2 fds. It's used to bump the fd rlimit when a
> device needs ~2048 file descriptors for MSI-X.

Understand; will do it.

Thanks a lot for very detailed suggestions.

> > +
> > +	return ret >= 0 ? 0 : ret;
> >  }
> >  
> >  static int vfio_pci_update_msi_entry(struct kvm *kvm, struct vfio_device *vdev,
> > 
> 
