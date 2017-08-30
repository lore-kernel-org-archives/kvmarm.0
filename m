From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 53/59] KVM: arm/arm64: GICv4: Hook vPE scheduling into
 vgic flush/sync
Date: Wed, 30 Aug 2017 13:56:14 +0200
Message-ID: <20170830115614.GF24522@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-54-marc.zyngier@arm.com>
 <20170828181758.GA24649@cbox>
 <4dcaea2f-f8b4-c12e-c3c1-b43a4e29279b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB7B449C2A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 07:54:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YG1kC+cAMWqj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Aug 2017 07:54:04 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE1E240D16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 07:54:03 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id t201so8964867wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 04:56:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4dcaea2f-f8b4-c12e-c3c1-b43a4e29279b@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 30, 2017 at 10:59:46AM +0100, Marc Zyngier wrote:
> On 28/08/17 19:17, Christoffer Dall wrote:
> > On Mon, Jul 31, 2017 at 06:26:31PM +0100, Marc Zyngier wrote:
> >> The redistributor needs to be told which vPE is about to be run,
> >> and tells us whether there is any pending VLPI on exit.
> >>
> >> Let's add the scheduling calls to the vgic flush/sync functions,
> >> allowing the VLPIs to be delivered to the guest.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  virt/kvm/arm/vgic/vgic-v4.c | 24 ++++++++++++++++++++++++
> >>  virt/kvm/arm/vgic/vgic.c    |  4 ++++
> >>  virt/kvm/arm/vgic/vgic.h    |  1 +
> >>  3 files changed, 29 insertions(+)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> >> index 50721c4e3da5..0a8deefbcf1c 100644
> >> --- a/virt/kvm/arm/vgic/vgic-v4.c
> >> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> >> @@ -119,6 +119,30 @@ void vgic_v4_teardown(struct kvm *kvm)
> >>  	its_vm->vpes = NULL;
> >>  }
> >>  
> >> +int vgic_v4_schedule(struct kvm_vcpu *vcpu, bool on)
> >> +{
> >> +	int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
> >> +
> >> +	if (!vgic_is_v4_capable(vcpu->kvm) || !irq)
> >> +		return 0;
> > 
> > why do we need to check the its_vpe.irq here?  This check is certainly
> > not untuitive, as I don't understand what happened on a v4 capable
> > system that somehow failed.  Is it because a specific VM is configured
> > to not use VLPIs, or?
> 
> Hmm. I think that's a debug leftover from my early attempt at making
> things work with QEMU, which initializes things in the opposite order
> as kvmtool. It should be removed (or replaced by a fat WARN_ON).
> 
> >> +
> >> +	/*
> >> +	 * Before making the VPE resident, make sure the redistributor
> >> +	 * expects us here.
> >> +	 */
> >> +	if (on) {
> >> +		int err;
> >> +
> >> +		err = irq_set_affinity(irq, cpumask_of(smp_processor_id()));
> > 
> > This is pretty unintuitive, and coming here without having read your
> > documentation may make people completely puzzled.  Could we provide a
> > pointer to the documentation that explains how the vpe irq hooks this
> > all together?
> 
> Sure, will do.
> 
> > 
> >> +		if (err) {
> >> +			kvm_err("failed irq_set_affinity IRQ%d (%d)\n", irq, err);
> >> +			return err;
> >> +		}
> >> +	}
> >> +
> >> +	return its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, on);
> >> +}
> >> +
> > 
> > I'd prefer this function be split into two and follow the vgic notation
> > of having a flush and a sync function.
> 
> Yes, makes sense.
> 
> >>  static struct vgic_its *vgic_get_its(struct kvm *kvm,
> >>  				     struct kvm_kernel_irq_routing_entry *irq_entry)
> >>  {
> >> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> >> index dfac894f6f03..9ab52108989d 100644
> >> --- a/virt/kvm/arm/vgic/vgic.c
> >> +++ b/virt/kvm/arm/vgic/vgic.c
> >> @@ -721,6 +721,8 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
> >>  {
> >>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >>  
> >> +	WARN_ON(vgic_v4_schedule(vcpu, false));
> >> +
> > 
> > This is in the critical path, so would it be worth considering a static
> > key to cater for non-GICv4 systems here?
> 
> Hey, for once I wasn't trying to optimize early! ;-) This would be
> useful indeed, as I expect GICv4 systems to be the absolute minority for
> the foreseeable future.
> 

Right.  For the record, I don't mind getting this functional first, and
adding the static key later, as you prefer.

Thanks,
-Christoffer
