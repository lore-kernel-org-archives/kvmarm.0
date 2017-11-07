From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 18/26] KVM: arm/arm64: GICv4: Use pending_last as a
 scheduling hint
Date: Tue, 7 Nov 2017 22:38:03 +0100
Message-ID: <f95fdd7d-28ce-407b-209c-0930e3bf05e8@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-19-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-19-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 27/10/2017 16:28, Marc Zyngier wrote:
> When a vPE exits, the pending_last flag is set when there are
> pending VLPIs stored in the pending table. Similarily, we set
> this flag when a doorbell interrupt fires, as it indicates the
> same condition.
This is actually done in the next patch.

Besides:
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Thanks

Eric


> 
> Let's update kvm_vgic_vcpu_pending_irq() to account for that
> flag as well, making a vcpu runnable when set.
> 
> Acked-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 9d557efd1f7d..0691a2250949 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -769,6 +769,9 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
>  	if (!vcpu->kvm->arch.vgic.enabled)
>  		return false;
>  
> +	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
> +		return true;
> +
>  	spin_lock(&vgic_cpu->ap_list_lock);
>  
>  	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> 
