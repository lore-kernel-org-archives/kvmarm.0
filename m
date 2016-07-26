From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v11 10/10] genirq/msi: use the MSI doorbell's IOVA when
 requested
Date: Tue, 26 Jul 2016 11:04:18 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1607261101340.19896@nanos>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com> <1468933367-23159-11-git-send-email-eric.auger@redhat.com> <alpine.DEB.2.11.1607201105310.3564@nanos> <08a930f2-8cc9-7d99-78c0-77d08ee40db3@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <08a930f2-8cc9-7d99-78c0-77d08ee40db3@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org, Jean-Philippe.Brucker@arm.com, yehuday@marvell.com, Manish.Jaggi@caviumnetworks.com, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

Eric,

On Mon, 25 Jul 2016, Auger Eric wrote:
> On 20/07/2016 11:09, Thomas Gleixner wrote:
> > On Tue, 19 Jul 2016, Eric Auger wrote:
> >> @@ -63,10 +63,18 @@ static int msi_compose(struct irq_data *irq_data,
> >>  {
> >>  	int ret = 0;
> >>  
> >> -	if (erase)
> >> +	if (erase) {
> >>  		memset(msg, 0, sizeof(*msg));
> >> -	else
> >> +	} else {
> >> +		struct device *dev;
> >> +
> >>  		ret = irq_chip_compose_msi_msg(irq_data, msg);
> >> +		if (ret)
> >> +			return ret;
> >> +
> >> +		dev = msi_desc_to_dev(irq_data_get_msi_desc(irq_data));
> >> +		WARN_ON(iommu_msi_msg_pa_to_va(dev, msg));
> > 
> > What the heck is this call doing? And why is there only a WARN_ON and not a
> > proper error return code handling?
> 
> iommu_msi_msg_pa_to_va is part of the new iommu-msi API introduced in PART I
> of this series. This helper function detects the physical address found in
> the MSI message has a corresponding allocated IOVA. This happens if the MSI
> doorbell is accessed through an IOMMU and this IOMMU do not bypass the MSI
> addresses (ARM case). Allocation of this IOVA was performed in the previous
> patch.
>
> So, if this is the case, the physical address is swapped with the IOVA
> address. That way the PCIe device will send the MSI with this IOVA and
> the address will be translated by the IOMMU into the target MSI doorbell PA.
> 
> Hope this clarifies

No, it does not. You are explaining in great length what that function is
doing, but you are not explaining WHY your don't do a proper return code
handling and just do a WARN_ON() and happily proceed. If that function fails
then the interrupt will not be functional, so WHY on earth are you continuing?

Thanks,

	tglx
