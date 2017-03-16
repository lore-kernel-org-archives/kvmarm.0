From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH 32/33] irqchip/gic-v4: Add some basic documentation
Date: Thu, 16 Mar 2017 22:02:05 +0100
Message-ID: <8d0c0d26-e28e-5328-00a6-a7cea4df9ffe@redhat.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-33-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F78D40625
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 17:00:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3tW73ArhGeM3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 17:00:33 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F06640064
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 17:00:32 -0400 (EDT)
In-Reply-To: <1484648454-21216-33-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 17/01/2017 11:20, Marc Zyngier wrote:
> Do a braindump of the way things are supposed to work.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic-v4.c | 59 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 36ccaac..8b2d9ee 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -22,6 +22,65 @@
>  
>  #include <linux/irqchip/arm-gic-v4.h>
>  
> +/*
> + * WARNING: The blurb below assumes that you understand the
> + * intricacies of GICv3, GICv4, and how a guest's view of a GICv3 gets
> + * translated into GICv4 comands. So it effectively targets at most
s/comands/commands
> + * two individuals. You know who you are.
> + *
> + * The core GICv4 code is designed to *avoid* exposing too much of the
> + * core GIC code (that would in turn leak into the hypervisor code),
> + * and instead provide a hypervisor agnostic interface to the HW (of
> + * course, the astute reader will quickly realize that hypervisor
> + * agnostic actually means KVM-specific - what were you thinking?).
> + *
> + * In order to achieve a modicum of isolation, we try to hide most of
> + * the GICv4 "stuff" behind normal irqchip operations:
> + *
> + * - Any guest-visible VLPI is backed by a Linux interrupt (and a
> + *   physical LPI which gets deconfigured
unmapped?
 when the guest maps the
> + *   VLPI). This allows the same DevID/Event pair to be either mapped
s/Event/Eventid
> + *   to the LPI (host) or the VLPI (guest).
> + *
> + * - Enabling/disabling a VLPI is done by issuing mask/unmask calls.
> + *
> + * - Guest INT/CLEAR commands are implemented through
> + *   irq_set_irqchip_state().
does it also work for vLPI? The spec mentions ICID/pINTID only.
> + *
> + * - The *bizarre* stuff (mapping/unmapping an interrupt to a VLPI, or
> + *   issuing an INV after changing a priority) gets shoved into the
> + *   irq_set_vcpu_affinity() method. While this is quite horrible
> + *   (let's face it, this is the irqchip version of an ioctl), it
> + *   confines the crap to a single location. And map/unmap really is
> + *   about setting the affinity of a VLPI to a vcpu, so only INV is
> + *   majorly out of place. So there.
I would put the above paragraph before the enable/disable and guest
INT/CLEAR bullet.

What is difficult to understand is there is also another mapping between
the vPE and the physical RDist which is handled by the below
irq_set_affinity.
> + *
> + * But handling VLPIs is only one side of the job of the GICv4
> + * code. The other (darker) side is to take care of the doorbell
> + * interrupts which are delivered when a VLPI targeting a non-running
> + * vcpu is being made pending.
> + *
> + * The choice made here is that each vcpu (VPE in old northern GICv4
> + * dialect) gets a single doorbell
s/doorbell/doorbell LPI?
, no matter how many interrupts are
> + * targeting it. This has a nice property, which is that the interrupt
> + * becomes a handle for the VPE, and that the hypervisor code can
> + * manipulate it through the normal interrupt API:
> + *
> + * - VMs (or rather the VM abstraction that matters to the GIC)
> + *   contain an irq domain where each interrupt maps to a VPE. In
> + *   turn, this domain stis on top of the normal LPI allocator, and a
s/stis/sits
> + *   specially crafted irq_chip implementation.
> + *
> + * - mask/unmask do what is expected on the doorbell interrupt.
> + *
> + * - irq_set_affinity is used to move a VPE from one redistributor to
> + *   another.
So that's the odd part for me because I would have imagined set_affinity
would have applied to this doorbell LPI and change the affinity of this
physical MSI. But as the doorbell MSI embodies the VPE, well this makes
sense to me
> + *
> + * - irq_set_vcpu_affinity once again gets hijacked for the purpose of
> + *   creating a new sub-API, namely scheduling/descheduling a VPE and
> + *   performing INVALL operations.
So this programs VPROPBASER and VPENDBASER
> + */
> +
>  static struct irq_domain *its_vpe_domain;
>  
>  static struct irq_chip its_vcpu_irq_chip = {
> 

Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric
