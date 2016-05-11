From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 23/55] KVM: arm/arm64: vgic-new: Add CTLR, TYPER and
 IIDR handlers
Date: Wed, 11 May 2016 15:15:56 +0200
Message-ID: <20160511131556.GR27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-24-git-send-email-andre.przywara@arm.com>
 <20160511120533.GM27623@cbox> <57332AD8.6050306@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 428F049B40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:12:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0EaMOdE2nxpX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:12:23 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2467449B3D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:12:22 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id g17so82072087wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:15:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57332AD8.6050306@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 11, 2016 at 01:51:36PM +0100, Marc Zyngier wrote:
> On 11/05/16 13:05, Christoffer Dall wrote:
> > On Fri, May 06, 2016 at 11:45:36AM +0100, Andre Przywara wrote:
> >> From: Marc Zyngier <marc.zyngier@arm.com>
> >>
> >> Those three registers are v2 emulation specific, so their implementation
> >> lives entirely in vgic-mmio-v2.c. Also they are handled in one function,
> >> as their implementation is pretty simple.
> >> When the guest enables the distributor, we kick all VCPUs to get
> >> potentially pending interrupts serviced.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >> Changelog RFC..v1:
> >> - kick VCPUs is the distributor gets enabled
> >> - improve comment
> >>
> >> Changelog v1 .. v2:
> >> - adapt to new MMIO framework
> >> - use switch() statements to improve readability
> >>
> >> Changelog v2 .. v3:
> >> - add vgic_kick_vcpus() implementation
> >>
> >>  include/linux/irqchip/arm-gic.h  |  1 +
> >>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 48 +++++++++++++++++++++++++++++++++++++++-
> >>  virt/kvm/arm/vgic/vgic.c         | 15 +++++++++++++
> >>  virt/kvm/arm/vgic/vgic.h         |  4 ++++
> >>  4 files changed, 67 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
> >> index be0d26f..fd05185 100644
> >> --- a/include/linux/irqchip/arm-gic.h
> >> +++ b/include/linux/irqchip/arm-gic.h
> >> @@ -33,6 +33,7 @@
> >>  
> >>  #define GIC_DIST_CTRL			0x000
> >>  #define GIC_DIST_CTR			0x004
> >> +#define GIC_DIST_IIDR			0x008
> >>  #define GIC_DIST_IGROUP			0x080
> >>  #define GIC_DIST_ENABLE_SET		0x100
> >>  #define GIC_DIST_ENABLE_CLEAR		0x180
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> index 2729a22..69e96f7 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> @@ -20,9 +20,55 @@
> >>  #include "vgic.h"
> >>  #include "vgic-mmio.h"
> >>  
> >> +static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
> >> +					    gpa_t addr, unsigned int len)
> >> +{
> >> +	u32 value;
> >> +
> >> +	switch (addr & 0x0c) {
> >> +	case GIC_DIST_CTRL:
> >> +		value = vcpu->kvm->arch.vgic.enabled ? GICD_ENABLE : 0;
> >> +		break;
> >> +	case GIC_DIST_CTR:
> >> +		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> >> +		value = (value >> 5) - 1;
> >> +		value |= (atomic_read(&vcpu->kvm->online_vcpus) - 1) << 5;
> >> +		break;
> >> +	case GIC_DIST_IIDR:
> >> +		value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
> >> +		break;
> >> +	default:
> >> +		return 0;
> >> +	}
> >> +
> >> +	return extract_bytes(value, addr & 3, len);
> >> +}
> >> +
> >> +static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
> >> +				    gpa_t addr, unsigned int len,
> >> +				    unsigned long val)
> >> +{
> >> +	switch (addr & 0x0c) {
> >> +	case GIC_DIST_CTRL:
> >> +		if (!(addr & 1)) {
> > 
> > what is this !(addr & 1) check?
> 
> We check that the write includes the lowest byte of the register. But as
> we only have aligned accesses, it probably doesn't matter... I'll hack
> that away.
> 
where do we check to only have aligned accesses?

-Christoffer
