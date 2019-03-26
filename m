From: Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH kvmtool v2 3/3] vfio-pci: Re-enable INTx mode when
 disable MSI/MSIX
Date: Tue, 26 Mar 2019 11:17:51 +0800
Message-ID: <20190326031751.GC30141@leoy-ThinkPad-X240s>
References: <20190320062046.3895-1-leo.yan@linaro.org>
 <20190320062046.3895-4-leo.yan@linaro.org>
 <150e4c56-5baf-338c-6be9-845720f15740@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9134B4A2E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 23:18:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C5Zww3m0bFy9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Mar 2019 23:18:00 -0400 (EDT)
Received: from mail-yw1-f65.google.com (mail-yw1-f65.google.com
 [209.85.161.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77AF140A52
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 23:18:00 -0400 (EDT)
Received: by mail-yw1-f65.google.com with SMTP id d132so8742828ywa.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 20:18:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <150e4c56-5baf-338c-6be9-845720f15740@arm.com>
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

On Mon, Mar 25, 2019 at 06:28:40PM +0000, Jean-Philippe Brucker wrote:

[...]

> > @@ -162,7 +160,34 @@ static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev,
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
> > +	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX) {
> > +		/*
> > +		 * Struct pci_device_header is not only used for header,
> > +		 * it also is used for PCI configuration; and in the function
> > +		 * vfio_pci_cfg_write() it firstly writes configuration space
> > +		 * and then read back the configuration space data into the
> > +		 * header structure; thus 'irq_pin' and 'irq_line' in the
> > +		 * header will be overwritten.
> > +		 *
> > +		 * If want to enable INTx mode properly, firstly needs to
> > +		 * restore 'irq_pin' and 'irq_line' values; we can simply set 1
> > +		 * to 'irq_pin', and 'pdev->intx_gsi' keeps gsi value when
> > +		 * enable INTx mode previously so we can simply use it to
> > +		 * recover irq line number by adding offset KVM_IRQ_OFFSET.
> > +		 */
> > +		pdev->hdr.irq_pin = 1;
> > +		pdev->hdr.irq_line = pdev->intx_gsi + KVM_IRQ_OFFSET;
> 
> That doesn't look right. We shouldn't change irq_line at runtime, it's
> reserved to the guest (and irq_pin is static). Maybe move the bits that
> should only be done once (intx_gsi setup, and also the
> VFIO_DEVICE_GET_IRQ_INFO sanity check) outside of the enable() function,
> like we do for msis?

Agree this and another comment in patch 0002.  Will spin new patch
set with following these good suggestions.

Thanks a lot for reviewing!

Thanks,
Leo Yan
