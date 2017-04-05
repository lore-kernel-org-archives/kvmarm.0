From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 2/5] KVM: arm/arm64: Add ARM user space interrupt
 signaling ABI
Date: Wed, 5 Apr 2017 10:12:37 +0200
Message-ID: <20170405081237.GB1526@cbox>
References: <20170203145655.15007-1-cdall@linaro.org>
 <20170203145655.15007-3-cdall@linaro.org>
 <CAFEAcA-HMZnjbnhDC-13rWuQP-X2pk-W-6DvSR8n9_f-e4R=cA@mail.gmail.com>
 <20170221114153.GA26976@cbox>
 <5fe89e77-4fcc-f2e5-a796-a1e1f38eef9f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC60140A14
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 04:10:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N2gX0zviBu7N for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Apr 2017 04:10:24 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD81640190
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 04:10:23 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id y22so43496375wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Apr 2017 01:12:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5fe89e77-4fcc-f2e5-a796-a1e1f38eef9f@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Pekka Enberg <penberg@iki.fi>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 05, 2017 at 02:14:11AM +0200, Alexander Graf wrote:
> 
> 
> On 21.02.17 12:41, Christoffer Dall wrote:
> >Hi Alex,
> >
> >On Fri, Feb 03, 2017 at 05:51:18PM +0000, Peter Maydell wrote:
> >>On 3 February 2017 at 14:56, Christoffer Dall <cdall@linaro.org> wrote:
> >>>From: Christoffer Dall <christoffer.dall@linaro.org>
> >>>
> >>>We have 2 modes for dealing with interrupts in the ARM world. We can
> >>>either handle them all using hardware acceleration through the vgic or
> >>>we can emulate a gic in user space and only drive CPU IRQ pins from
> >>>there.
> >>>
> >>>Unfortunately, when driving IRQs from user space, we never tell user
> >>>space about events from devices emulated inside the kernel, which may
> >>>result in interrupt line state changes, so we lose out on for example
> >>>timer and PMU events if we run with user space gic emulation.
> >>>
> >>>Define an ABI to publish such device output levels to userspace.
> >>>
> >>>Signed-off-by: Alexander Graf <agraf@suse.de>
> >>>Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>
> >>
> >>Acked-by: Peter Maydell <peter.maydell@linaro.org>
> >>
> >>for the userspace ABI/docs part.
> >>
> >
> >Given Peter's ack on this ABI, any chance you could take a look at
> >fixing the userspace SMP issue and respinning the userspace patches for
> >this series?
> 
> The problem with user space SMP was simply a missing lock:
> 
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index a66845f..1b33895 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -548,10 +548,14 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs,
> struct kvm_run *run)
> 
>      /* Synchronize our internal vtimer irq line with the kvm one */
>      if (run->s.regs.device_irq_level != cpu->device_irq_level) {
> -        qemu_set_irq(ARM_CPU(cs)->gt_timer_outputs[GTIMER_VIRT],
> +        qemu_mutex_lock_iothread();
> +        qemu_set_irq(cpu->gt_timer_outputs[GTIMER_VIRT],
>                       run->s.regs.device_irq_level &
> KVM_ARM_DEV_EL1_VTIMER);
> +        qemu_set_irq(cpu->gt_timer_outputs[GTIMER_PHYS],
> +                     run->s.regs.device_irq_level &
> KVM_ARM_DEV_EL1_PTIMER);
>          /* TODO: Handle changes in PTIMER and PMU as well */
>          cpu->device_irq_level = run->s.regs.device_irq_level;
> +        qemu_mutex_unlock_iothread();
>      }
> 
>      return MEMTXATTRS_UNSPECIFIED;
> 
> ----
> 
> 
> I also wasn't able to use your series out of the box. There are
> several places in the code that check whether a timer is enabled
> (for register save/restore for example) and without vgic we never
> ended up setting that to true.
> 
> I don't know how safe it is to set it to true regardless. It feels
> to me like someone has to put more thought into how to switch from
> an initialized user space timer state to a vgic one. For reference,
> my test patch is below:
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 891a725..56a5d51 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -629,8 +629,11 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  		return 0;
> 
>  	/* Without a VGIC we do not map virtual IRQs to physical IRQs */
> -	if (!irqchip_in_kernel(vcpu->kvm))
> +	if (!irqchip_in_kernel(vcpu->kvm)) {
> +		/* Enable timer for now, may be racy? */
> +		timer->enabled = 1;
>  		return 0;
> +	}
> 
>  	if (!vgic_initialized(vcpu->kvm))
>  		return -ENODEV;
> 

Heh, sorry about this, I accidentally pushed the wrong content to my git
repo, so I'm guessing you pulled from there instead of applying these
patches directly.  If you want a branch with these patches as intended,
try this:

git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git irqs-to-user-v2-for-real

I have a v3 ready based on v4.11-rc1 plus other KVM fixes and I'll send
that out later today once I've tested with your qemu fix above.

Thanks,
-Christoffer
