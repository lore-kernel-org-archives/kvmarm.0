From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 2/3] KVM: arm/arm64: Add ARM arch timer interrupts ABI
Date: Tue, 1 Nov 2016 11:26:54 +0000
Message-ID: <CAFEAcA8x9Rt7SwXfqC8QOuXUEysrGBvYZW_=9ZA+pNgYu7HbTA@mail.gmail.com>
References: <20160927190806.22988-1-christoffer.dall@linaro.org> <20160927190806.22988-3-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160927190806.22988-3-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Alexander Graf <agraf@suse.de>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 27 September 2016 at 20:08, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> From: Alexander Graf <agraf@suse.de>
>
> We have 2 modes for dealing with interrupts in the ARM world. We can
> either handle them all using hardware acceleration through the vgic or
> we can emulate a gic in user space and only drive CPU IRQ pins from
> there.
>
> Unfortunately, when driving IRQs from user space, we never tell user
> space about timer events that may result in interrupt line state
> changes, so we lose out on timer events if we run with user space gic
> emulation.
>
> Define an ABI to publish the timer output level to userspace.
>
> Signed-off-by: Alexander Graf <agraf@suse.de>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  Documentation/virtual/kvm/api.txt | 29 +++++++++++++++++++++++++++++
>  arch/arm/include/uapi/asm/kvm.h   |  2 ++
>  arch/arm64/include/uapi/asm/kvm.h |  2 ++
>  include/uapi/linux/kvm.h          |  6 ++++++
>  4 files changed, 39 insertions(+)
>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 739db9a..2adf600 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -3928,3 +3928,32 @@ In order to use SynIC, it has to be activated by setting this
>  capability via KVM_ENABLE_CAP ioctl on the vcpu fd. Note that this
>  will disable the use of APIC hardware virtualization even if supported
>  by the CPU, as it's incompatible with SynIC auto-EOI behavior.
> +
> +8.3 KVM_CAP_ARM_TIMER
> +
> +Architectures: arm, arm64
> +This capability, if KVM_CHECK_EXTENSION indicates that it is available, means
> +that if userspace creates a VM without an in-kernel interrupt controller, it
> +will be notified of changes to the output level of ARM architected timers
> +presented to the VM.  For such VMs, on every return to userspace, the kernel
> +updates the vcpu's run->s.regs.timer_irq_level field to represent the actual
> +output level of the timers.
> +
> +Whenever kvm detects a change in the timer output level, kvm guarantees at
> +least one return to userspace before running the VM.  This exit could either
> +be a KVM_EXIT_INTR or any other exit event, like KVM_EXIT_MMIO. This way,
> +userspace can always sample the timer output level and re-compute the state of
> +the userspace interrupt controller.  Userspace should always check the state
> +of run->s.regs.timer_irq_level on every kvm exit.  The value in
> +run->s.regs.timer_irq_level should be considered a level triggered interrupt
> +signal.
> +
> +The field run->s.regs.timer_irq_level is available independent of
> +run->kvm_valid_regs or run->kvm_dirty_regs bits.
> +
> +Currently the following bits are defined for the timer_irq_level bitmap:
> +
> +    KVM_ARM_TIMER_VTIMER  -  virtual timer
> +
> +Future versions of kvm may implement additional timer events. These will get
> +indicated by additional KVM_CAP extensions.

This API looks good to me generally. My only question is whether we
want to name the struct fields so they're not specifically talking
about timer interrupts. For instance we probably want to expose the
vPMU interrupt line to userspace too. We could do that by adding another
struct field pmu_irq_level, but we could equally just assign it a bit
in the existing irq_level field.

Possible current and future outbound interrupt lines (some of these
would only show up in some unlikely or lots-of-implementation-needed
cases, I'm just trying to produce an exhaustive list):
 * virtual timer
 * physical timer
 * hyp timer (nested virtualization case)
 * secure timer (unlikely but maybe if EL3 is ever supported inside a VM)
 * gic maintenance interrupt (nested virt again)
 * PMU interrupt

The kernel doesn't know which interrupt number these would be wired
up to, so they're all just arbitrary outputs, and you could put them
in one field or split them up into multiple fields, it doesn't make
much difference.

thanks
-- PMM
