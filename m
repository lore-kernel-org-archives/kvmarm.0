From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 1/3] KVM: arm: Fix NULL pointer dereference if KVM
 is used without in-kernel irqchip
Date: Fri, 17 Jul 2015 17:47:51 +0100
Message-ID: <55A931B7.4000905@arm.com>
References: <cover.1436874248.git.p.fedin@samsung.com> <644bce2849b89bc8520c7efcb7752c92e31f9ccd.1436874248.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <644bce2849b89bc8520c7efcb7752c92e31f9ccd.1436874248.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/07/15 13:06, Pavel Fedin wrote:
> Makes qemu working again with kernel-irqchip=off option

I'd appreciate a better commit log. Which patch broke it, why is that
necessary.

> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm/kvm/arm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index d9631ec..5668c4e 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -450,7 +450,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  	 * Map the VGIC hardware resources before running a vcpu the first
>  	 * time on this VM.
>  	 */
> -	if (unlikely(!vgic_ready(kvm))) {
> +	if (irqchip_in_kernel(kvm) && unlikely(!vgic_ready(kvm))) {

I think you should factor the irqchip_in_kernel() inside the unlikely
clause. Something like

bool vgic_needs_init = irqchip_in_kernel(kvm) && !vgic_ready(kvm);

if (unlikely(vfic_needs_init)) {
...
}

>  		ret = kvm_vgic_map_resources(kvm);
>  		if (ret)
>  			return ret;
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
