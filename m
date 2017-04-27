From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 11/22] KVM: arm64: vgic-its: Interpret MAPD Size field
 and check related errors
Date: Thu, 27 Apr 2017 10:28:02 -0700
Message-ID: <20170427172802.GB56467@lvm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-12-git-send-email-eric.auger@redhat.com>
 <20170427162528.GN50776@lvm>
 <bc81470d-b5b3-0b81-e845-7f3527ef0f6f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bc81470d-b5b3-0b81-e845-7f3527ef0f6f@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 27, 2017 at 07:15:27PM +0200, Auger Eric wrote:
> Hi,
> On 27/04/2017 18:25, Christoffer Dall wrote:
> > On Fri, Apr 14, 2017 at 12:15:23PM +0200, Eric Auger wrote:
> >> Up to now the MAPD's ITT size field has been ignored. It encodes
> >> the number of eventid bit minus 1. It should be used to check
> >> the eventid when a MAPTI command is issued on a device. Let's
> >> store the number of eventid bits in the its_device and do the
> >> check on MAPTI. Also make sure the ITT size field does
> >> not exceed the GITS_TYPER IDBITS field.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >> v4 -> v5:
> >> - its_cmd_get_size macro now returns the actual number of eventid bits
> >> - use GIC_ENCODE_SZ macro to encode ID_bits
> >>
> >> v3 -> v4:
> >> - VITS_TYPER_IDBITS set to 16 to be homogeneous with VITS_ESZ definition
> >>   and correct users
> >> - nb_eventid_bits correspond to the actual number of eventid bits
> >> ---
> >>  include/linux/irqchip/arm-gic-v3.h |  2 ++
> >>  virt/kvm/arm/vgic/vgic-its.c       | 15 ++++++++++++++-
> >>  2 files changed, 16 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> >> index 54c20bd..0c6798c 100644
> >> --- a/include/linux/irqchip/arm-gic-v3.h
> >> +++ b/include/linux/irqchip/arm-gic-v3.h
> >> @@ -345,9 +345,11 @@
> >>  #define E_ITS_INT_UNMAPPED_INTERRUPT		0x010307
> >>  #define E_ITS_CLEAR_UNMAPPED_INTERRUPT		0x010507
> >>  #define E_ITS_MAPD_DEVICE_OOR			0x010801
> >> +#define E_ITS_MAPD_ITTSIZE_OOR			0x010802
> >>  #define E_ITS_MAPC_PROCNUM_OOR			0x010902
> >>  #define E_ITS_MAPC_COLLECTION_OOR		0x010903
> >>  #define E_ITS_MAPTI_UNMAPPED_DEVICE		0x010a04
> >> +#define E_ITS_MAPTI_ID_OOR			0x010a05
> >>  #define E_ITS_MAPTI_PHYSICALID_OOR		0x010a06
> >>  #define E_ITS_INV_UNMAPPED_INTERRUPT		0x010c07
> >>  #define E_ITS_INVALL_UNMAPPED_COLLECTION	0x010d09
> >> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> >> index 1b5797e..0f3c8f3 100644
> >> --- a/virt/kvm/arm/vgic/vgic-its.c
> >> +++ b/virt/kvm/arm/vgic/vgic-its.c
> >> @@ -105,6 +105,7 @@ struct its_device {
> >>  
> >>  	/* the head for the list of ITTEs */
> >>  	struct list_head itt_head;
> >> +	u32 nb_eventid_bits;
> > 
> > what does nb_ mean?
> number ;-)
> 

Ah, I think the plural form of bits here implied that, but if you
insist, then can you call it num_eventid_bits?

I was like, "notifier block", "nota bene", I'm lost...

Thanks,
-Christoffer
