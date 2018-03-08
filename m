From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: vgic: change condition for level
 interrupt resampling
Date: Thu, 8 Mar 2018 09:57:37 +0100
Message-ID: <9b3763f2-1dfa-5506-d7f2-93389647111c@redhat.com>
References: <1520492490-7943-1-git-send-email-shunyong.yang@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520492490-7943-1-git-send-email-shunyong.yang@hxt-semitech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shunyong Yang <shunyong.yang@hxt-semitech.com>, christoffer.dall@linaro.org
Cc: david.daney@cavium.com, marc.zyngier@arm.com, ard.biesheuvel@linaro.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, Joey Zheng <yu.zheng@hxt-semitech.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 08/03/18 08:01, Shunyong Yang wrote:
> When resampling irqfds is enabled, level interrupt should be
> de-asserted when resampling happens. On page 4-47 of GIC v3
> specification IHI0069D, it said,
> "When the PE acknowledges an SGI, a PPI, or an SPI at the CPU
> interface, the IRI changes the status of the interrupt to active
> and pending if:
> • It is an edge-triggered interrupt, and another edge has been
> detected since the interrupt was acknowledged.
> • It is a level-sensitive interrupt, and the level has not been
> deasserted since the interrupt was acknowledged."
> 
> GIC v2 specification IHI0048B.b has similar description on page
> 3-42 for state machine transition.
> 
> When some VFIO device, like mtty(8250 VFIO mdev emulation driver
> in samples/vfio-mdev) triggers a level interrupt, the status
> transition in LR is pending-->active-->active and pending.
> Then it will wait resampling to de-assert the interrupt.
> 
> Current design of lr_signals_eoi_mi() will return false if state
> in LR is not invalid(Inactive). It causes resampling will not happen
> in mtty case.
> 
> This will cause interrupt fired continuously to guest even 8250 IIR
> has no interrupt. When 8250's interrupt is configured in shared mode,
> it will pass interrupt to other drivers to handle. However, there
> is no other driver involved. Then, a "nobody cared" kernel complaint
> occurs.
> 
> / # cat /dev/ttyS0
> [    4.826836] random: crng init done
> [    6.373620] irq 41: nobody cared (try booting with the "irqpoll"
> option)
> [    6.376414] CPU: 0 PID: 1307 Comm: cat Not tainted 4.16.0-rc4 #4
> [    6.378927] Hardware name: linux,dummy-virt (DT)
> [    6.380876] Call trace:
> [    6.381937]  dump_backtrace+0x0/0x180
> [    6.383495]  show_stack+0x14/0x1c
> [    6.384902]  dump_stack+0x90/0xb4
> [    6.386312]  __report_bad_irq+0x38/0xe0
> [    6.387944]  note_interrupt+0x1f4/0x2b8
> [    6.389568]  handle_irq_event_percpu+0x54/0x7c
> [    6.391433]  handle_irq_event+0x44/0x74
> [    6.393056]  handle_fasteoi_irq+0x9c/0x154
> [    6.394784]  generic_handle_irq+0x24/0x38
> [    6.396483]  __handle_domain_irq+0x60/0xb4
> [    6.398207]  gic_handle_irq+0x98/0x1b0
> [    6.399796]  el1_irq+0xb0/0x128
> [    6.401138]  _raw_spin_unlock_irqrestore+0x18/0x40
> [    6.403149]  __setup_irq+0x41c/0x678
> [    6.404669]  request_threaded_irq+0xe0/0x190
> [    6.406474]  univ8250_setup_irq+0x208/0x234
> [    6.408250]  serial8250_do_startup+0x1b4/0x754
> [    6.410123]  serial8250_startup+0x20/0x28
> [    6.411826]  uart_startup.part.21+0x78/0x144
> [    6.413633]  uart_port_activate+0x50/0x68
> [    6.415328]  tty_port_open+0x84/0xd4
> [    6.416851]  uart_open+0x34/0x44
> [    6.418229]  tty_open+0xec/0x3c8
> [    6.419610]  chrdev_open+0xb0/0x198
> [    6.421093]  do_dentry_open+0x200/0x310
> [    6.422714]  vfs_open+0x54/0x84
> [    6.424054]  path_openat+0x2dc/0xf04
> [    6.425569]  do_filp_open+0x68/0xd8
> [    6.427044]  do_sys_open+0x16c/0x224
> [    6.428563]  SyS_openat+0x10/0x18
> [    6.429972]  el0_svc_naked+0x30/0x34
> [    6.431494] handlers:
> [    6.432479] [<000000000e9fb4bb>] serial8250_interrupt
> [    6.434597] Disabling IRQ #41
> 
> This patch changes the lr state condition in lr_signals_eoi_mi() from
> invalid(Inactive) to active and pending to avoid this.
> 
> I am not sure about the original design of the condition of
> invalid(active). So, This RFC is sent out for comments.
> 
> Cc: Joey Zheng <yu.zheng@hxt-semitech.com>
> Signed-off-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 4 ++--
>  virt/kvm/arm/vgic/vgic-v3.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index e9d840a75e7b..740ee9a5f551 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -46,8 +46,8 @@ void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
>  
>  static bool lr_signals_eoi_mi(u32 lr_val)
>  {
> -	return !(lr_val & GICH_LR_STATE) && (lr_val & GICH_LR_EOI) &&
> -	       !(lr_val & GICH_LR_HW);
> +	return !((lr_val & GICH_LR_STATE) ^ GICH_LR_STATE) &&
> +	       (lr_val & GICH_LR_EOI) && !(lr_val & GICH_LR_HW);
>  }
>  
>  /*
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 6b329414e57a..43111bba7af9 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -35,8 +35,8 @@ void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
>  
>  static bool lr_signals_eoi_mi(u64 lr_val)
>  {
> -	return !(lr_val & ICH_LR_STATE) && (lr_val & ICH_LR_EOI) &&
> -	       !(lr_val & ICH_LR_HW);
> +	return !((lr_val & ICH_LR_STATE) ^ ICH_LR_STATE) &&
> +	       (lr_val & ICH_LR_EOI) && !(lr_val & ICH_LR_HW);


In general don't we have this state transition

inactive -> pending -> pending + active (1) -> active -> inactive.

In that case won't we lower the virt irq level when folding the LR on
Pending + Active state, which is not was we want?

Thanks

Eric

>  }
>  
>  void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> 
