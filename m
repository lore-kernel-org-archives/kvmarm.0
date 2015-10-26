From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 6/6] arm-smmu: Allow to set iommu mapping for MSI
Date: Mon, 26 Oct 2015 16:40:59 +0100
Message-ID: <20151026154059.GE20298@cbox>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1443624989-24346-6-git-send-email-Bharat.Bhushan@freescale.com>
 <1443826005.26107.191.camel@redhat.com>
 <CY1PR0301MB127637C2EA08365A249864C090480@CY1PR0301MB1276.namprd03.prod.outlook.com>
 <1444085675.26107.372.camel@redhat.com>
 <BN3PR0301MB1265E14339BD005A912624B990370@BN3PR0301MB1265.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BN3PR0301MB1265E14339BD005A912624B990370@BN3PR0301MB1265.namprd03.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
To: Bhushan Bharat <Bharat.Bhushan@freescale.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "pranavkumar@linaro.org" <pranavkumar@linaro.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 06, 2015 at 10:26:34AM +0000, Bhushan Bharat wrote:

[...]

> > 
> > I'm certainly not interested in applying an maintaining an interim solution that
> > isn't the right one.  It seems like VFIO is too involved in this process in your
> > example.  On x86 we have per vector isolation and the only thing we're
> > missing is reporting back of the region used by MSI vectors as reserved IOVA
> > space (but it's standard on x86, so an x86 VM user will never use it for IOVA).
> 
> I remember you mentioned that there is no problem when running an x86 guest on an x86 host.  But it will interesting when running a non-x86 VMs on an x86 host  or non-VM userspace use of VFIO though. 
> 
> > In your model, the MSI IOVA space is programmable,
> 
> Yes, on PowerPC and ARM-SMMU case also we have to create mapping with an IOVA. First question is which IOVA to be used, and we added the reserved iova ioctl for same.
> 
> Second problem is we needed an msi-page physical address for setting up iommu-mapping, and so we needed to reserve an msi-page. I did this for PowerPC but not in a generic extension in msi-driver and will look the code a bit more details on adding an interface to reserve an msi-page or get a shared msi-page with allow-unsafe-interrupt.

Sorry, I'm far from familiar with how x86 does interrupt handling and
I know very little of PCIe and MSIs, so please allow me to ask some
stupid questions:

What does an msi-page physical address mean?

> 
> Third problem is to report the reserved IOVA to be used for MSI vectors for the given set of devices (devices in a vfio-group). 

What do MSI vectors mean in this context?  Is this a Linux kernel
construct, something tied to PCIe, something tied to the interrupt
controller, or?

In the case of ARM, AFAIU, you have a single doorbell register per ITS
and devices can write to this register with their device id and the
eventid.  So it's a register in a page somewhere.

Now, what is the problem you don't understand with ARM here?

> 
> Mark/Christopher,
> I am not an expert in this area so I might have to understand that code. If you think you can give solution to 2nd and 3rd problem quickly then please let me know.
> 
I don't really understand what you're asking, but if you can educate me
on the concepts above I may be able to offer some advice.

Thanks,
-Christoffer
