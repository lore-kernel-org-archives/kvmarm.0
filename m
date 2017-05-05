From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 09/24] KVM: arm64: vgic-its: Introduce migration ABI
 infrastructure
Date: Fri, 5 May 2017 02:43:50 -0700
Message-ID: <20170505094350.GA2695@lvm>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-10-git-send-email-eric.auger@redhat.com>
 <20170504171301.GT5923@cbox>
 <2b69826d-9c8a-0ee3-9061-5de4d5f9dc21@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2b69826d-9c8a-0ee3-9061-5de4d5f9dc21@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 05, 2017 at 10:16:08AM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 04/05/2017 19:13, Christoffer Dall wrote:
> > On Thu, May 04, 2017 at 01:44:29PM +0200, Eric Auger wrote:
> >> We plan to support different migration ABIs, ie. characterizing
> >> the ITS table layout format in guest RAM. For example, a new ABI
> >> will be needed if vLPIs get supported for nested use case.
> >>
> >> So let's introduce an array of supported ABIs (at the moment a single
> >> ABI is supported though). The following characteristics are foreseen
> >> to vary with the ABI: size of table entries, save/restore operation,
> >> the way abi settings are applied.
> >>
> >> By default the MAX_ABI_REV is applied on its creation. In subsequent
> >> patches we will introduce a way for the userspace to change the ABI
> >> in use.
> >>
> >> The entry sizes now are set according to the ABI version and not
> >> hardcoded anymore.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >> v6 -> v7:
> >> - rename abi into its_table_abi_versions
> >> - kernel doc comments for struct vgic_its_abi
> >> - comment GIC_ENCODE_SZ
> >> - slighly rephrase the commit message
> >>
> >> v5: creation and squash KVM: arm64: ITS: Report the ITE size in
> >>     GITS_TYPER
> >> ---
> >>  include/kvm/arm_vgic.h             |  3 ++
> >>  include/linux/irqchip/arm-gic-v3.h |  5 +++
> >>  virt/kvm/arm/vgic/vgic-its.c       | 92 ++++++++++++++++++++++++++++++++++++--
> >>  3 files changed, 96 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index c0b3d99..285474a 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -162,6 +162,9 @@ struct vgic_its {
> >>  	u32			creadr;
> >>  	u32			cwriter;
> >>  
> >> +	/* migration ABI revision in use */
> >> +	u32			abi_rev;
> >> +
> >>  	/* Protects the device and collection lists */
> >>  	struct mutex		its_lock;
> >>  	struct list_head	device_list;
> >> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> >> index 97cbca1..81ebe43 100644
> >> --- a/include/linux/irqchip/arm-gic-v3.h
> >> +++ b/include/linux/irqchip/arm-gic-v3.h
> >> @@ -132,6 +132,9 @@
> >>  #define GIC_BASER_SHAREABILITY(reg, type)				\
> >>  	(GIC_BASER_##type << reg##_SHAREABILITY_SHIFT)
> >>  
> >> +/* encode a size field of width @w containing @n - 1 units */
> >> +#define GIC_ENCODE_SZ(n, w) (((unsigned long)(n) - 1) & GENMASK_ULL(((w) - 1), 0))
> >> +
> >>  #define GICR_PROPBASER_SHAREABILITY_SHIFT		(10)
> >>  #define GICR_PROPBASER_INNER_CACHEABILITY_SHIFT		(7)
> >>  #define GICR_PROPBASER_OUTER_CACHEABILITY_SHIFT		(56)
> >> @@ -232,6 +235,7 @@
> >>  #define GITS_CTLR_QUIESCENT		(1U << 31)
> >>  
> >>  #define GITS_TYPER_PLPIS		(1UL << 0)
> >> +#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
> >>  #define GITS_TYPER_IDBITS_SHIFT		8
> >>  #define GITS_TYPER_DEVBITS_SHIFT	13
> >>  #define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
> >> @@ -290,6 +294,7 @@
> >>  #define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
> >>  #define GITS_BASER_ENTRY_SIZE_SHIFT		(48)
> >>  #define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0x1f) + 1)
> >> +#define GITS_BASER_ENTRY_SIZE_MASK	GENMASK_ULL(52, 48)
> >>  #define GITS_BASER_SHAREABILITY_SHIFT	(10)
> >>  #define GITS_BASER_InnerShareable					\
> >>  	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
> >> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> >> index 18588ef..c336cce 100644
> >> --- a/virt/kvm/arm/vgic/vgic-its.c
> >> +++ b/virt/kvm/arm/vgic/vgic-its.c
> >> @@ -33,6 +33,12 @@
> >>  #include "vgic.h"
> >>  #include "vgic-mmio.h"
> >>  
> >> +/* Highest migration ABI revision supported by this code */
> >> +#define MAX_ABI_REV 0
> >> +
> >> +static int vgic_its_set_abi(struct vgic_its *its, int rev);
> >> +static const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its);
> >> +
> >>  /*
> >>   * Creates a new (reference to a) struct vgic_irq for a given LPI.
> >>   * If this LPI is already mapped on another ITS, we increase its refcount
> >> @@ -123,6 +129,25 @@ struct its_ite {
> >>  	u32 event_id;
> >>  };
> >>  
> >> +/**
> >> + * struct vgic_its_abi - ITS abi ops and settings
> >> + * @cte_esz: collection table entry size
> >> + * @dte_esz: device table entry size
> >> + * @ite_esz: interrupt translation table entry size
> >> + * @save tables: save the ITS tables into guest RAM
> >> + * @restore_tables: restore the ITS internal structs from
> >> + * tables stored in guest RAM
> > 
> > nit: indent to align with the beginning of 'restore...'
> > 
> > 
> >> + * @commit: apply the ABI settings to the ITS
> > 
> > hmm, I already forgot what the commit function does, and reading this
> > text doesn't seem to help me, unfortunately.  When is this called, what
> > does it do?
> what about:
>  * @commit: initialize the registers which expose the ABI settings,
>  *  especially the entry sizes
> 
Ah yes, much better.

Thanks,
-Christoffer
