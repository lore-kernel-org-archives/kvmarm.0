From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 48/59] KVM: arm/arm64: GICv4: Handle INVALL applied to
 a vPE
Date: Mon, 28 Aug 2017 20:18:37 +0200
Message-ID: <20170828181837.GI24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-49-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-49-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 31, 2017 at 06:26:26PM +0100, Marc Zyngier wrote:
> Since when updating the properties one LPI at a time, there is no
> need to perform an INV each time we read one. Instead, we rely
> on the final VINVALL that gets sent to the ITS to do the work.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  virt/kvm/arm/vgic/vgic-its.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 9e46081e5f15..b395df1bf47c 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -38,7 +38,7 @@ static int vgic_its_save_tables_v0(struct vgic_its *its);
>  static int vgic_its_restore_tables_v0(struct vgic_its *its);
>  static int vgic_its_commit_v0(struct vgic_its *its);
>  static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> -			     struct kvm_vcpu *filter_vcpu);
> +			     struct kvm_vcpu *filter_vcpu, bool needs_inv);
>  
>  /*
>   * Creates a new (reference to a) struct vgic_irq for a given LPI.
> @@ -106,7 +106,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>  	 * However we only have those structs for mapped IRQs, so we read in
>  	 * the respective config data from memory here upon mapping the LPI.
>  	 */
> -	ret = update_lpi_config(kvm, irq, NULL);
> +	ret = update_lpi_config(kvm, irq, NULL, false);
>  	if (ret)
>  		return ERR_PTR(ret);
>  
> @@ -274,7 +274,7 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
>   * VCPU. Unconditionally applies if filter_vcpu is NULL.
>   */
>  static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> -			     struct kvm_vcpu *filter_vcpu)
> +			     struct kvm_vcpu *filter_vcpu, bool needs_inv)
>  {
>  	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
>  	u8 prop;
> @@ -298,7 +298,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>  	}
>  
>  	if (irq->hw)
> -		return its_prop_update_vlpi(irq->host_irq, prop, true);
> +		return its_prop_update_vlpi(irq->host_irq, prop, needs_inv);
>  
>  	return 0;
>  }
> @@ -1095,7 +1095,7 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
>  	if (!ite)
>  		return E_ITS_INV_UNMAPPED_INTERRUPT;
>  
> -	return update_lpi_config(kvm, ite->irq, NULL);
> +	return update_lpi_config(kvm, ite->irq, NULL, true);
>  }
>  
>  /*
> @@ -1130,12 +1130,15 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
>  		irq = vgic_get_irq(kvm, NULL, intids[i]);
>  		if (!irq)
>  			continue;
> -		update_lpi_config(kvm, irq, vcpu);
> +		update_lpi_config(kvm, irq, vcpu, false);
>  		vgic_put_irq(kvm, irq);
>  	}
>  
>  	kfree(intids);
>  
> +	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.its_vm)
> +		its_invall_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe);
> +
>  	return 0;
>  }
>  
> -- 
> 2.11.0
> 
