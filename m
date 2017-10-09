From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 04/20] KVM: arm/arm64: Guard kvm_vgic_map_is_active
 against !vgic_initialized
Date: Mon, 9 Oct 2017 17:22:13 +0100
Message-ID: <2fb75502-ee42-9178-835f-637179d47937@arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
 <20170923004207.22356-5-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170923004207.22356-5-cdall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/09/17 01:41, Christoffer Dall wrote:
> If the vgic is not initialized, don't try to grab its spinlocks or
> traverse its data structures.
> 
> This is important because we soon have to start considering the active
> state of a virtual interrupts when doing vcpu_load, which may happen
> early on before the vgic is initialized.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index fed717e..e1f7dbc 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -777,6 +777,9 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>  	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
>  	bool map_is_active;
>  
> +	if (!vgic_initialized(vcpu->kvm))
> +		return false;
> +
>  	spin_lock(&irq->irq_lock);
>  	map_is_active = irq->hw && irq->active;
>  	spin_unlock(&irq->irq_lock);
> 

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
