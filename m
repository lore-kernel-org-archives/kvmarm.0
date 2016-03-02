From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 12/17] arm64: KVM: vgic-v2: Make GICD_SGIR quicker to
 hit
Date: Thu, 3 Mar 2016 00:08:23 +0100
Message-ID: <20160302230823.GF9634@cbox>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <1455727249-24752-13-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455727249-24752-13-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 17, 2016 at 04:40:44PM +0000, Marc Zyngier wrote:
> The GICD_SGIR register lives a long way from the beginning of
> the handler array, which is searched linearly. As this is hit
> pretty often, let's move it up. This saves us some precious
> cycles when the guest is generating IPIs.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  virt/kvm/arm/vgic-v2-emul.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
> index 1390797..1b0bee0 100644
> --- a/virt/kvm/arm/vgic-v2-emul.c
> +++ b/virt/kvm/arm/vgic-v2-emul.c
> @@ -321,6 +321,11 @@ static bool handle_mmio_sgi_clear(struct kvm_vcpu *vcpu,
>  
>  static const struct vgic_io_range vgic_dist_ranges[] = {
>  	{
> +		.base		= GIC_DIST_SOFTINT,
> +		.len		= 4,
> +		.handle_mmio	= handle_mmio_sgi_reg,
> +	},
> +	{
>  		.base		= GIC_DIST_CTRL,
>  		.len		= 12,
>  		.bits_per_irq	= 0,
> @@ -387,11 +392,6 @@ static const struct vgic_io_range vgic_dist_ranges[] = {
>  		.handle_mmio	= handle_mmio_cfg_reg,
>  	},
>  	{
> -		.base		= GIC_DIST_SOFTINT,
> -		.len		= 4,
> -		.handle_mmio	= handle_mmio_sgi_reg,
> -	},
> -	{
>  		.base		= GIC_DIST_SGI_PENDING_CLEAR,
>  		.len		= VGIC_NR_SGIS,
>  		.handle_mmio	= handle_mmio_sgi_clear,
> -- 
> 2.1.4
> 
