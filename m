From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 3/7] KVM: arm/arm64: vgic-its: Preserve the revious read
 from the pending table
Date: Mon, 20 Nov 2017 15:56:10 +0100
Message-ID: <20171120145610.GL28855@cbox>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
 <20171116175821.26544-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171116175821.26544-4-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Kristina Martsenko <kristina.martsenko@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 16, 2017 at 05:58:17PM +0000, Marc Zyngier wrote:
> The current pending table parsing code assumes that we keep the
> previous read of the pending bits, but keep that variable in
> the current block, making sure it is discarded on each loop.
> 
> We end-up using whatever is on the stack. Who knows, it might
> just be the right thing...

And the hits just keep on coming...

> 
> Fixes: 33d3bc9556a7d ("KVM: arm64: vgic-its: Read initial LPI pending table")
> Cc: stable@vger.kernel.org # 4.8
> Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-its.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index a3754ec719c4..370086006838 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -421,6 +421,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>  	u32 *intids;
>  	int nr_irqs, i;
>  	unsigned long flags;
> +	u8 pendmask;
>  
>  	nr_irqs = vgic_copy_lpi_list(vcpu, &intids);
>  	if (nr_irqs < 0)
> @@ -428,7 +429,6 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>  
>  	for (i = 0; i < nr_irqs; i++) {
>  		int byte_offset, bit_nr;
> -		u8 pendmask;
>  
>  		byte_offset = intids[i] / BITS_PER_BYTE;
>  		bit_nr = intids[i] % BITS_PER_BYTE;
> -- 
> 2.14.2
> 
