From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Fri, 15 Jan 2016 15:36:56 +0000
Message-ID: <20160115153656.GM3262@leverpostej>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org>
 <1452523550-8920-4-git-send-email-okaya@codeaurora.org>
 <20160115145629.GI3262@leverpostej>
 <56990CD4.6020405@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56990CD4.6020405@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Sinan Kaya <okaya@codeaurora.org>, dmaengine@vger.kernel.org, timur@codeaurora.org, devicetree@vger.kernel.org, cov@codeaurora.org, vinod.koul@intel.com, jcm@redhat.com, agross@codeaurora.org, arnd@arndb.de, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 15, 2016 at 03:14:28PM +0000, Marc Zyngier wrote:
> On 15/01/16 14:56, Mark Rutland wrote:
> > Hi,
> > 
> > [adding KVM people, given this is meant for virtualization]
> > 
> > On Mon, Jan 11, 2016 at 09:45:43AM -0500, Sinan Kaya wrote:
> >> The Qualcomm Technologies HIDMA device has been designed to support
> >> virtualization technology. The driver has been divided into two to follow
> >> the hardware design.
> >>
> >> 1. HIDMA Management driver
> >> 2. HIDMA Channel driver
> >>
> >> Each HIDMA HW consists of multiple channels. These channels share some set
> >> of common parameters. These parameters are initialized by the management
> >> driver during power up. Same management driver is used for monitoring the
> >> execution of the channels. Management driver can change the performance
> >> behavior dynamically such as bandwidth allocation and prioritization.
> >>
> >> The management driver is executed in hypervisor context and is the main
> >> management entity for all channels provided by the device.
> > 
> > You mention repeatedly that this is designed for virtualization, but
> > looking at the series as it stands today I can't see how this operates
> > from the host side.
> 
> Nor the guest's, TBH. How do host and guest communicate, what is the
> infrastructure, how is it meant to be used? A lot of questions, and no
> answer whatsoever in this series.

I think the guest's PoV is fairly simple and understood. The DMA channel
is pased in as with any passthrough of any other platform device.

No communication with the host is necessary -- an isolated channel is
usable.

The larger concern is isolation, given the lack of IOMMU, or anything
obvious w.r.t. pinning of pages.

> > This doesn't seem to tie into KVM or VFIO, and as far as I can tell
> > there's no mechanism for associating channels with a particular virtual
> > address space (i.e. no configuration of an external or internal IOMMU),
> > nor pinning of guest pages to allow for DMA to occur safely.
> > 
> > Given that, I'm at a loss as to how this would be used in a hypervisor
> > context. What am I missing?
> > 
> > Are there additional patches, or do you have some userspace that works
> > with this in some limited configuration?
> 
> Well, this looks so far like a code dumping exercise. I'd very much
> appreciate a HIDMA101 crash course:
> 
> - How do host and guest communicate?
> - How is the integration performed in the hypervisor?
> - Does the HYP side requires any context switch (and how is that done)?

I don't believe this requires any context-switch -- it's the same as
assigning any other platform device other than additional proeprties
being controlled in the managament interface.

> - What makes it safe?

I'm concerned with how this is safe, and with the userspace interface.
e.g. if the user wants to up the QoS for a VM, how to they find the
right channel in sysfs  to alter?

> Without any of this information (and pointer to the code to back it up),
> I'm very reluctant to take any of this.

Likewise.

Thanks,
Mark.
