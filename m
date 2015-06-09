From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 01/10] arm/arm64: KVM: Fix ordering of timer/GIC on guest entry
Date: Tue, 09 Jun 2015 12:29:35 +0100
Message-ID: <87wpzd6rxc.fsf@linaro.org>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com> <1433783045-8002-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1433783045-8002-2-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


Marc Zyngier <marc.zyngier@arm.com> writes:

> As we now inject the timer interrupt when we're about to enter
> the guest, it makes a lot more sense to make sure this happens
> before the vgic code queues the pending interrupts.
>
> Otherwise, we get the interrupt on the following exit, which is
> not great for latency (and leads to all kind of bizarre issues
> when using with active interrupts at the HW level).
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/arm.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index d9631ec..46db690 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -529,9 +529,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcp=
u, struct kvm_run *run)
>  		if (vcpu->arch.pause)
>  			vcpu_pause(vcpu);
> =20
> -		kvm_vgic_flush_hwstate(vcpu);
>  		kvm_timer_flush_hwstate(vcpu);
> =20
> +		kvm_vgic_flush_hwstate(vcpu);
> +
>  		local_irq_disable();
> =20
>  		/*
> @@ -544,8 +545,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu=
, struct kvm_run *run)
> =20
>  		if (ret <=3D 0 || need_new_vmid_gen(vcpu->kvm)) {
>  			local_irq_enable();
> -			kvm_timer_sync_hwstate(vcpu);
>  			kvm_vgic_sync_hwstate(vcpu);
> +			kvm_timer_sync_hwstate(vcpu);
>  			continue;
>  		}
> =20
> @@ -577,9 +578,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcp=
u, struct kvm_run *run)
>  		 * Back from guest
>  		 *************************************************************/
> =20
> -		kvm_timer_sync_hwstate(vcpu);
>  		kvm_vgic_sync_hwstate(vcpu);
> =20
> +		kvm_timer_sync_hwstate(vcpu);
> +
>  		ret =3D handle_exit(vcpu, run, ret);
>  	}

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
