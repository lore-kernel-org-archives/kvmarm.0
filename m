From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH V12 3/7] dma: add Qualcomm Technologies HIDMA management
 driver
Date: Fri, 15 Jan 2016 15:22:58 +0000
Message-ID: <20160115152257.GK3262@leverpostej>
References: <1452523550-8920-1-git-send-email-okaya@codeaurora.org>
 <1452523550-8920-4-git-send-email-okaya@codeaurora.org>
 <20160115145629.GI3262@leverpostej>
 <56990C40.4050407@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F01449A13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:19:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z4H+HhN0xaNR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 10:19:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42CEB49A11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:19:08 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <56990C40.4050407@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, arnd@arndb.de, vinod.koul@intel.com, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, marc.zyngier@arm.com, agross@codeaurora.org, dmaengine@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-msm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 15, 2016 at 10:12:00AM -0500, Sinan Kaya wrote:
> Hi Mark,
> 
> On 1/15/2016 9:56 AM, Mark Rutland wrote:
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
> > 
> > This doesn't seem to tie into KVM or VFIO, and as far as I can tell
> > there's no mechanism for associating channels with a particular virtual
> > address space (i.e. no configuration of an external or internal IOMMU),
> > nor pinning of guest pages to allow for DMA to occur safely.
> 
> I'm using VFIO platform driver for this purpose. VFIO platform driver is 
> capable of assigning any platform device to a guest machine with this driver. 

Typically VFIO-platform also comes with a corresponding reset driver.
You don't need one?

> You just unbind the HIDMA channel driver from the hypervisor and bind to vfio
> driver using the very same approach you'd use with PCIe. 
> 
> Of course, this all assumes the presence of an IOMMU driver on the system. VFIO
> driver uses the IOMMU driver to create the mappings. 

No IOMMU was described in the DT binding. It sounds like you'd need an
optional (not present in the guest) iommus property per-channel

> The mechanism used here is not different from VFIO PCI from user perspective.
> 
> > 
> > Given that, I'm at a loss as to how this would be used in a hypervisor
> > context. What am I missing?
> > 
> > Are there additional patches, or do you have some userspace that works
> > with this in some limited configuration?
> 
> No, these are the only patches. We have one patch for the QEMU but from kernel
> perspective this is it. 

Do you have a link to that? Seeing it would help to ease my concerns.

Thanks,
Mark.
