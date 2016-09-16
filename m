From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v3 2/2] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 16 Sep 2016 10:11:12 +0100
Message-ID: <CAFEAcA_SGmQVg0COoVArhVtC3TFEEMB3bdT-UTPYvnuwLKANYg@mail.gmail.com>
References: <1474007187-18673-1-git-send-email-agraf@suse.de> <1474007187-18673-3-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1474007187-18673-3-git-send-email-agraf@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16 September 2016 at 07:26, Alexander Graf <agraf@suse.de> wrote:
> We have 2 modes for dealing with interrupts in the ARM world. We can either
> handle them all using hardware acceleration through the vgic or we can emulate
> a gic in user space and only drive CPU IRQ pins from there.
>
> Unfortunately, when driving IRQs from user space, we never tell user space
> about timer events that may result in interrupt line state changes, so we
> lose out on timer events if we run with user space gic emulation.
>
> This patch fixes that by routing vtimer expiration events to user space.
> With this patch I can successfully run edk2 and Linux with user space gic
> emulation.

Hi Alex. I have some comments just on the userspace API docs.
These are mostly requests for clarification or expansion, and they
boil down to "if you gave me this API document change I wouldn't be
able to deduce from it the necessary changes to QEMU or kvmtool to
use this functionality".

> Signed-off-by: Alexander Graf <agraf@suse.de>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 23937e0..dec1a78 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -3202,8 +3202,10 @@ struct kvm_run {
>         /* in */
>         __u8 request_interrupt_window;
>
> -Request that KVM_RUN return when it becomes possible to inject external
> +[x86] Request that KVM_RUN return when it becomes possible to inject external
>  interrupts into the guest.  Useful in conjunction with KVM_INTERRUPT.
> +[arm*] Bits set to 1 in here mask IRQ lines that would otherwise potentially
> +trigger forever. Useful with KVM_CAP_ARM_TIMER.

It's only a _u8 and there's more than 8 IRQ lines -- which ones
can you mask this way?

>         __u8 padding1[7];
>
> @@ -3519,6 +3521,16 @@ Hyper-V SynIC state change. Notification is used to remap SynIC
>  event/message pages and to enable/disable SynIC messages/events processing
>  in userspace.
>
> +               /* KVM_EXIT_ARM_TIMER */
> +               struct {
> +                       __u8 timesource;
> +               } arm_timer;
> +
> +Indicates that a timer triggered that user space needs to handle and
> +potentially mask with vcpu->run->request_interrupt_window to allow the
> +guest to proceed. This only happens for timers that got enabled through
> +KVM_CAP_ARM_TIMER.

What values can the timesource field contain?

> +
>                 /* Fix the size of the union. */
>                 char padding[256];
>         };
> @@ -3739,6 +3751,16 @@ Once this is done the KVM_REG_MIPS_VEC_* and KVM_REG_MIPS_MSA_* registers can be
>  accessed, and the Config5.MSAEn bit is accessible via the KVM API and also from
>  the guest.
>
> +6.11 KVM_CAP_ARM_TIMER
> +
> +Architectures: arm, arm64
> +Target: vcpu
> +Parameters: args[0] contains a bitmap of timers to enable
> +
> +This capability allows to route per-core timers into user space. When it's
> +enabled, the enabled timers trigger KVM_EXIT_ARM_TIMER guest exits when they
> +are pending, unless masked by vcpu->run->request_interrupt_window.

How are the timers enumerated within the bitmap? Which timers can
be enabled like this?

Shouldn't this be talking about "timers to route to userspace"
rather than "timers to enable", since AIUI the timers are always
enabled regardless of what you set here ?

The KVM_CAP constant name seems rather generic given this is an
obscure corner of the API.


What is the mechanism for the kernel to tell userspace when the
timer *stops* being pending, so it can update the interrupt
level for it in userspace? (What you really want I think is
for the kernel to notify "timer level goes high" and "timer
level goes low" and handle the masking internally.)

> +
>  7. Capabilities that can be enabled on VMs
>  ------------------------------------------

thanks
-- PMM
