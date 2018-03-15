From: "Yang, Shunyong" <shunyong.yang@hxt-semitech.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Disallow Active+Pending for level
 interrupts
Date: Thu, 15 Mar 2018 01:13:48 +0000
Message-ID: <1521076428.2589.34.camel@hxt-semitech.com>
References: <20180314183744.30889-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180314183744.30889-1-marc.zyngier@arm.com>
Content-Language: en-US
Content-ID: <B6218D386404F84B8ADB351E499C6C25@hxt-semitech.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: "eric.auger@redhat.com" <eric.auger@redhat.com>, "cdall@kernel.org" <cdall@kernel.org>, "Andre.Przywara@arm.com" <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi, Marc,

On Wed, 2018-03-14 at 18:37 +0000, Marc Zyngier wrote:
> It was recently reported that VFIO mediated devices, and anything
> that VFIO exposes as level interrupts, do no strictly follow the
> expected logic of such interrupts as it only lowers the input
> line when the guest has EOId the interrupt at the GIC level, rather
> than when it Acked the interrupt at the device level.
> =

> THe GIC's Active+Pending state is fundamentally incompatible with
> this behaviour, as it prevents KVM from observing the EOI, and in
> turn results in VFIO never dropping the line. This results in an
> interrupt storm in the guest, which it really never expected.
> =

> As we cannot really change VFIO to follow the strict rules of level
> signalling, let's forbid the A+P state altogether, as it is in the
> end only an optimization. It ensures that we will transition via
> an invalid state, which we can use to notify VFIO of the EOI.
> =


As the initial discussion topic name is different with this patch name,
I am not sure whether we should add the discussion links in this
patch's commit message for others to know some background, such as VFIO
level interrupt, irqfd level interrut, arm kvm interrupt handing, etc.

https://patchwork.kernel.org/patch/10267013/
https://patchwork.kernel.org/patch/10269579/
https://patchwork.kernel.org/patch/10274697/

Thanks.
Shunyong.

> Reported-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
> Tested-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> =A0virt/kvm/arm/vgic/vgic-v2.c | 47 +++++++++++++++++++++++++++------
> ------------
> =A0virt/kvm/arm/vgic/vgic-v3.c | 47 +++++++++++++++++++++++++++------
> ------------
> =A02 files changed, 56 insertions(+), 38 deletions(-)
> =

> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-
> v2.c
> index 29556f71b691..9356d749da1d 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -153,8 +153,35 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu
> *vcpu)
> =A0void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq
> *irq, int lr)
> =A0{
> =A0	u32 val =3D irq->intid;
> +	bool allow_pending =3D true;
> =A0
> -	if (irq_is_pending(irq)) {
> +	if (irq->active)
> +		val |=3D GICH_LR_ACTIVE_BIT;
> +
> +	if (irq->hw) {
> +		val |=3D GICH_LR_HW;
> +		val |=3D irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
> +		/*
> +		=A0* Never set pending+active on a HW interrupt, as
> the
> +		=A0* pending state is kept at the physical distributor
> +		=A0* level.
> +		=A0*/
> +		if (irq->active)
> +			allow_pending =3D false;
> +	} else {
> +		if (irq->config =3D=3D VGIC_CONFIG_LEVEL) {
> +			val |=3D GICH_LR_EOI;
> +
> +			/*
> +			=A0* Software resampling doesn't work very
> well
> +			=A0* if we allow P+A, so let's not do that.
> +			=A0*/
> +			if (irq->active)
> +				allow_pending =3D false;
> +		}
> +	}
> +
> +	if (allow_pending && irq_is_pending(irq)) {
> =A0		val |=3D GICH_LR_PENDING_BIT;
> =A0
> =A0		if (irq->config =3D=3D VGIC_CONFIG_EDGE)
> @@ -171,24 +198,6 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu,
> struct vgic_irq *irq, int lr)
> =A0		}
> =A0	}
> =A0
> -	if (irq->active)
> -		val |=3D GICH_LR_ACTIVE_BIT;
> -
> -	if (irq->hw) {
> -		val |=3D GICH_LR_HW;
> -		val |=3D irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
> -		/*
> -		=A0* Never set pending+active on a HW interrupt, as
> the
> -		=A0* pending state is kept at the physical distributor
> -		=A0* level.
> -		=A0*/
> -		if (irq->active && irq_is_pending(irq))
> -			val &=3D ~GICH_LR_PENDING_BIT;
> -	} else {
> -		if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
> -			val |=3D GICH_LR_EOI;
> -	}
> -
> =A0	/*
> =A0	=A0* Level-triggered mapped IRQs are special because we only
> observe
> =A0	=A0* rising edges as input to the VGIC.=A0=A0We therefore lower
> the line
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-
> v3.c
> index 0ff2006f3781..6b484575cafb 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -135,8 +135,35 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
> struct vgic_irq *irq, int lr)
> =A0{
> =A0	u32 model =3D vcpu->kvm->arch.vgic.vgic_model;
> =A0	u64 val =3D irq->intid;
> +	bool allow_pending =3D true;
> =A0
> -	if (irq_is_pending(irq)) {
> +	if (irq->active)
> +		val |=3D ICH_LR_ACTIVE_BIT;
> +
> +	if (irq->hw) {
> +		val |=3D ICH_LR_HW;
> +		val |=3D ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
> +		/*
> +		=A0* Never set pending+active on a HW interrupt, as
> the
> +		=A0* pending state is kept at the physical distributor
> +		=A0* level.
> +		=A0*/
> +		if (irq->active)
> +			allow_pending =3D false;
> +	} else {
> +		if (irq->config =3D=3D VGIC_CONFIG_LEVEL) {
> +			val |=3D ICH_LR_EOI;
> +
> +			/*
> +			=A0* Software resampling doesn't work very
> well
> +			=A0* if we allow P+A, so let's not do that.
> +			=A0*/
> +			if (irq->active)
> +				allow_pending =3D false;
> +		}
> +	}
> +
> +	if (allow_pending && irq_is_pending(irq)) {
> =A0		val |=3D ICH_LR_PENDING_BIT;
> =A0
> =A0		if (irq->config =3D=3D VGIC_CONFIG_EDGE)
> @@ -154,24 +181,6 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
> struct vgic_irq *irq, int lr)
> =A0		}
> =A0	}
> =A0
> -	if (irq->active)
> -		val |=3D ICH_LR_ACTIVE_BIT;
> -
> -	if (irq->hw) {
> -		val |=3D ICH_LR_HW;
> -		val |=3D ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
> -		/*
> -		=A0* Never set pending+active on a HW interrupt, as
> the
> -		=A0* pending state is kept at the physical distributor
> -		=A0* level.
> -		=A0*/
> -		if (irq->active && irq_is_pending(irq))
> -			val &=3D ~ICH_LR_PENDING_BIT;
> -	} else {
> -		if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
> -			val |=3D ICH_LR_EOI;
> -	}
> -
> =A0	/*
> =A0	=A0* Level-triggered mapped IRQs are special because we only
> observe
> =A0	=A0* rising edges as input to the VGIC.=A0=A0We therefore lower
> the line
