From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 9/9] arm/arm64: KVM: arch timer: Reset CNTV_CTL to 0
Date: Mon, 31 Aug 2015 10:46:59 +0200
Message-ID: <CAKv+Gu-4KKUUt7J==CPK6J79mWXLeMJFsG_fj85tYB2orzfrZg@mail.gmail.com>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
	<1440942866-23802-10-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-10-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, KVM devel mailing list <kvm@vger.kernel.org>, Laszlo Ersek <lersek@redhat.com>, Drew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30 August 2015 at 15:54, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> Provide a better quality of implementation and be architecture compliant
> on ARMv7 for the architected timer by resetting the CNTV_CTL to 0 on
> reset of the timer, and call kvm_timer_update_state(vcpu) at the same
> time, ensuring the timer output is not asserted after, for example, a
> PSCI system reset.
>
> This change alone fixes the UEFI reset issue reported by Laszlo back in
> February.
>

Do you have a link to that report? I can't quite remember the details ...

> Cc: Laszlo Ersek <lersek@redhat.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Drew Jones <drjones@redhat.com>
> Cc: Wei Huang <wei@redhat.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/arch_timer.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 747302f..8a0fdfc 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -255,6 +255,15 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>         timer->irq.irq = irq->irq;
>
>         /*
> +        * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
> +        * and to 0 for ARMv7.  We provide an implementation that always
> +        * resets the timer to be disabled and unmasked and is compliant with
> +        * the ARMv7 architecture.
> +        */
> +       timer->cntv_ctl = 0;
> +       kvm_timer_update_state(vcpu);
> +
> +       /*
>          * Tell the VGIC that the virtual interrupt is tied to a
>          * physical interrupt. We do that once per VCPU.
>          */
> --
> 2.1.2.330.g565301e.dirty
>
