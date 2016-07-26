From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v11 09/10] genirq/msi: map/unmap the MSI doorbells on
 msi_domain_alloc/free_irqs
Date: Tue, 26 Jul 2016 13:01:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1607261202250.19896@nanos>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com> <1468933367-23159-10-git-send-email-eric.auger@redhat.com> <alpine.DEB.2.11.1607201016060.3564@nanos> <75f5e846-6ca4-4178-e7aa-fed90e45e546@redhat.com> <alpine.DEB.2.11.1607261022330.19896@nanos>
 <f8e83628-5fb0-70d4-c32c-237d190ec98f@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f8e83628-5fb0-70d4-c32c-237d190ec98f@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, Marc Zyngier <marc.zyngier@arm.com>, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, Jason Cooper <jason@lakedaemon.net>, LAK <linux-arm-kernel@lists.infradead.org>, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, LKML <linux-kernel@vger.kernel.org>, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org, Jean-Philippe.Brucker@arm.com, yehuday@marvell.com, Manish.Jaggi@caviumnetworks.com, robert.richter@caviumnetworks.com, Bjorn Helgaas <bhelgaas@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 26 Jul 2016, Auger Eric wrote:
> On 26/07/2016 11:00, Thomas Gleixner wrote:
> > In your case you don't want to have a partial allocation, so instead of
> > playing silly games with desc->irq you should add a flag which tells the PCI
> > code that you are not interested in a partial allocation and that it should
> > return an error code instead.
> 

> In that case can we consider we even succeeded in allocating 1 MSI? In case
> the IOMMU mapping fails, the MSI transaction will never reach the target MSI
> frame so it is not usable. So when you mean "partial" I understand we did
> not succeed in allocating maxvec IRQs, correct? Here we succeeded in
> allocating 0 IRQ and still msi_capability_init returns 1.
>
> msi_capability_init doc-comment says "a positive return value indicates the
> number of interrupts which could have been allocated."
> 
> I understand allocation success currently only depends on the fact virq was
> allocated and set to desc->irq. But with that IOMMU stuff doesn't the
> criteria changes?

Right. But then you need to express it differently in a consistent way. Not by
hacking around it by setting desc->irq to 0.

Something like a flag field in msi_desc which denotes various properties would
be a possible solution. MSI_IRQ_ALLOCATED and MSI_IRQ_REMAPPED would be
sufficient for now. And the deallocation/cleanup would rely on those flags
rather than checking desc->irq.

Thanks,

	tglx
