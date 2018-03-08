From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: vgic: change condition for level
 interrupt resampling
Date: Thu, 8 Mar 2018 08:19:00 -0800
Message-ID: <20180308161900.GC1917@lvm>
References: <1520492490-7943-1-git-send-email-shunyong.yang@hxt-semitech.com>
 <9ad47673-068e-f732-d2ca-9c76a8fbdfbc@arm.com>
 <0a15633d-8944-cb9b-3e6b-b08ee5ec42b9@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0a15633d-8944-cb9b-3e6b-b08ee5ec42b9@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shunyong Yang <shunyong.yang@hxt-semitech.com>, ard.biesheuvel@linaro.org, will.deacon@arm.com, eric.auger@redhat.com, david.daney@cavium.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Joey Zheng <yu.zheng@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 08, 2018 at 11:54:27AM +0000, Marc Zyngier wrote:
> On 08/03/18 09:49, Marc Zyngier wrote:
> > [updated Christoffer's email address]
> > 
> > Hi Shunyong,
> > 
> > On 08/03/18 07:01, Shunyong Yang wrote:
> >> When resampling irqfds is enabled, level interrupt should be
> >> de-asserted when resampling happens. On page 4-47 of GIC v3
> >> specification IHI0069D, it said,
> >> "When the PE acknowledges an SGI, a PPI, or an SPI at the CPU
> >> interface, the IRI changes the status of the interrupt to active
> >> and pending if:
> >> • It is an edge-triggered interrupt, and another edge has been
> >> detected since the interrupt was acknowledged.
> >> • It is a level-sensitive interrupt, and the level has not been
> >> deasserted since the interrupt was acknowledged."
> >>
> >> GIC v2 specification IHI0048B.b has similar description on page
> >> 3-42 for state machine transition.
> >>
> >> When some VFIO device, like mtty(8250 VFIO mdev emulation driver
> >> in samples/vfio-mdev) triggers a level interrupt, the status
> >> transition in LR is pending-->active-->active and pending.
> >> Then it will wait resampling to de-assert the interrupt.
> >>
> >> Current design of lr_signals_eoi_mi() will return false if state
> >> in LR is not invalid(Inactive). It causes resampling will not happen
> >> in mtty case.
> > 
> > Let me rephrase this, and tell me if I understood it correctly:
> > 
> > - A level interrupt is injected, activated by the guest (LR state=active)
> > - guest exits, re-enters, (LR state=pending+active)
> > - guest EOIs the interrupt (LR state=pending)
> > - maintenance interrupt
> > - we don't signal the resampling because we're not in an invalid state
> > 
> > Is that correct?
> > 
> > That's an interesting case, because it seems to invalidate some of the 
> > optimization that went in over a year ago.
> > 
> > 096f31c4360f KVM: arm/arm64: vgic: Get rid of MISR and EISR fields
> > b6095b084d87 KVM: arm/arm64: vgic: Get rid of unnecessary save_maint_int_state
> > af0614991ab6 KVM: arm/arm64: vgic: Get rid of unnecessary process_maintenance operation
> > 
> > We could compare the value of the LR before the guest entry with
> > the value at exit time, but we still could miss it if we have a
> > transition such as P+A -> P -> A and assume a long enough propagation
> > delay for the maintenance interrupt (which is very likely).
> > 
> > In essence, we have lost the benefit of EISR, which was to give us a
> > way to deal with asynchronous signalling.
> > 
> >>
> >> This will cause interrupt fired continuously to guest even 8250 IIR
> >> has no interrupt. When 8250's interrupt is configured in shared mode,
> >> it will pass interrupt to other drivers to handle. However, there
> >> is no other driver involved. Then, a "nobody cared" kernel complaint
> >> occurs.
> >>
> >> / # cat /dev/ttyS0
> >> [    4.826836] random: crng init done
> >> [    6.373620] irq 41: nobody cared (try booting with the "irqpoll"
> >> option)
> >> [    6.376414] CPU: 0 PID: 1307 Comm: cat Not tainted 4.16.0-rc4 #4
> >> [    6.378927] Hardware name: linux,dummy-virt (DT)
> >> [    6.380876] Call trace:
> >> [    6.381937]  dump_backtrace+0x0/0x180
> >> [    6.383495]  show_stack+0x14/0x1c
> >> [    6.384902]  dump_stack+0x90/0xb4
> >> [    6.386312]  __report_bad_irq+0x38/0xe0
> >> [    6.387944]  note_interrupt+0x1f4/0x2b8
> >> [    6.389568]  handle_irq_event_percpu+0x54/0x7c
> >> [    6.391433]  handle_irq_event+0x44/0x74
> >> [    6.393056]  handle_fasteoi_irq+0x9c/0x154
> >> [    6.394784]  generic_handle_irq+0x24/0x38
> >> [    6.396483]  __handle_domain_irq+0x60/0xb4
> >> [    6.398207]  gic_handle_irq+0x98/0x1b0
> >> [    6.399796]  el1_irq+0xb0/0x128
> >> [    6.401138]  _raw_spin_unlock_irqrestore+0x18/0x40
> >> [    6.403149]  __setup_irq+0x41c/0x678
> >> [    6.404669]  request_threaded_irq+0xe0/0x190
> >> [    6.406474]  univ8250_setup_irq+0x208/0x234
> >> [    6.408250]  serial8250_do_startup+0x1b4/0x754
> >> [    6.410123]  serial8250_startup+0x20/0x28
> >> [    6.411826]  uart_startup.part.21+0x78/0x144
> >> [    6.413633]  uart_port_activate+0x50/0x68
> >> [    6.415328]  tty_port_open+0x84/0xd4
> >> [    6.416851]  uart_open+0x34/0x44
> >> [    6.418229]  tty_open+0xec/0x3c8
> >> [    6.419610]  chrdev_open+0xb0/0x198
> >> [    6.421093]  do_dentry_open+0x200/0x310
> >> [    6.422714]  vfs_open+0x54/0x84
> >> [    6.424054]  path_openat+0x2dc/0xf04
> >> [    6.425569]  do_filp_open+0x68/0xd8
> >> [    6.427044]  do_sys_open+0x16c/0x224
> >> [    6.428563]  SyS_openat+0x10/0x18
> >> [    6.429972]  el0_svc_naked+0x30/0x34
> >> [    6.431494] handlers:
> >> [    6.432479] [<000000000e9fb4bb>] serial8250_interrupt
> >> [    6.434597] Disabling IRQ #41
> >>
> >> This patch changes the lr state condition in lr_signals_eoi_mi() from
> >> invalid(Inactive) to active and pending to avoid this.
> >>
> >> I am not sure about the original design of the condition of
> >> invalid(active). So, This RFC is sent out for comments.
> >>
> >> Cc: Joey Zheng <yu.zheng@hxt-semitech.com>
> >> Signed-off-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
> >> ---
> >>  virt/kvm/arm/vgic/vgic-v2.c | 4 ++--
> >>  virt/kvm/arm/vgic/vgic-v3.c | 4 ++--
> >>  2 files changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> >> index e9d840a75e7b..740ee9a5f551 100644
> >> --- a/virt/kvm/arm/vgic/vgic-v2.c
> >> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> >> @@ -46,8 +46,8 @@ void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
> >>  
> >>  static bool lr_signals_eoi_mi(u32 lr_val)
> >>  {
> >> -	return !(lr_val & GICH_LR_STATE) && (lr_val & GICH_LR_EOI) &&
> >> -	       !(lr_val & GICH_LR_HW);
> >> +	return !((lr_val & GICH_LR_STATE) ^ GICH_LR_STATE) &&
> > 
> > That feels very wrong. You're now signalling the resampling in both
> > invalid and pending+active, and the latter state doesn't mean you've
> > EOIed anything. You're now over-signalling, and signalling the
> > wrong event.
> > 
> >> +	       (lr_val & GICH_LR_EOI) && !(lr_val & GICH_LR_HW);
> >>  }
> >>  
> >>  /*
> >> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> >> index 6b329414e57a..43111bba7af9 100644
> >> --- a/virt/kvm/arm/vgic/vgic-v3.c
> >> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> >> @@ -35,8 +35,8 @@ void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
> >>  
> >>  static bool lr_signals_eoi_mi(u64 lr_val)
> >>  {
> >> -	return !(lr_val & ICH_LR_STATE) && (lr_val & ICH_LR_EOI) &&
> >> -	       !(lr_val & ICH_LR_HW);
> >> +	return !((lr_val & ICH_LR_STATE) ^ ICH_LR_STATE) &&
> >> +	       (lr_val & ICH_LR_EOI) && !(lr_val & ICH_LR_HW);
> >>  }
> >>  
> >>  void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >>
> > 
> > Assuming I understand the issue correctly, I cannot really see how
> > to solve this without reintroducing EISR, which sucks majorly.
> > 
> > I'll try to cook something shortly and we can all have a good
> > fight about how crap this is.
> 
> Here's what I came up with. I don't really like it, but that's
> the least invasive this I could come up with. Please let me
> know if that helps with your test case. Note that I have only
> boot-tested this on a sample of 1 machine, so I don't expect this
> to be perfect.
> 
> Also, any guideline on how to reproduce this would be much appreciated.
> I never used this mdev/mtty thing, so please bear with me.
> 
> Thanks,
> 
> 	M.
> 
> From 66a7c4cfc1029b0169dd771e196e2876ba3f17b1 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <marc.zyngier@arm.com>
> Date: Thu, 8 Mar 2018 11:14:06 +0000
> Subject: [PATCH] KVM: arm/arm64: Do not rely on LR state to guess EOI MI
>  status
> 
> We so far rely on the LR state to decide whether the guest has
> EOI'd a level interrupt or not. While this looks like a good
> idea on the surface, it leads to a couple of annoying corner
> cases:
> 
> Example 1: (P = Pending, A = Active, MI = Maintenance Interrupt)
> P -> guest IAR -> A -> exit/entry -> P+A -> guest EOI -> P -> MI

Do we really get an EOI maintenance interrupt here?  Reading the MISR
and EISR descriptions make me thing this is not the case...

> 
> The state is now pending, we've really EOI'd the interrupt, and
> yet lr_signals_eoi_mi() returns false, since the state is not 0.
> The result is that we won't signal anything on the corresponding
> irqfd, which people complain about. Meh.

So the core of the problem is that when we've entered the guest with
PENDING+ACTIVE and when we exit (for some reason) we don't signal the
resamplefd, right?  The solution seems to me that we don't ever do
PENDING+ACTIVE if you need to resample after each deactivate.  What
would be the point of appending a pending state that you only know to be
valid after a resample anyway?

> 
> Example 2:
> P+A -> guest EOI -> P -> delayed MI -> guest IAR -> A -> MI fires

We could be more clever and do the following calculation on every exit:

If you enter with P, and exit with either A or 0, then signal.

If you enter with P+A, and you exit with either P, A, or 0, then signal.

Wouldn't that also solve it?  (Although I have a feeling you'd miss some
exits in this case).

Thanks,
-Christoffer
