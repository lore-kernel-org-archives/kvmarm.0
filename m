From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 17/26] KVM: arm/arm64: GICv4: Handle INVALL applied to
 a vPE
Date: Tue, 7 Nov 2017 22:23:25 +0100
Message-ID: <e247390a-c9d5-4c3a-5812-88b83e87ce10@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-18-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-18-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 27/10/2017 16:28, Marc Zyngier wrote:
> Since when updating the properties one LPI at a time, there is no
Since we update the properties one LPI at a time, ... ?
> need to perform an INV each time we read one. Instead, we rely
> on the final VINVALL that gets sent to the ITS to do the work.
The commit message is not crystal clear for me.

I understand in case of vgic_its_cmd_handle_invall you want to avoid
doing an invalidation for each physical irq but rather do an
its_invall_vpe at the end. So you add a new  @needs_inv arg to
update_lpi_config to tell whether the invalidation should be done or not.

Besides

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> 
> Acked-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 2e77c7c83942..eb72eb027060 100644
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
> @@ -273,7 +273,7 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
>   * VCPU. Unconditionally applies if filter_vcpu is NULL.
>   */
>  static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> -			     struct kvm_vcpu *filter_vcpu)
> +			     struct kvm_vcpu *filter_vcpu, bool needs_inv)
>  {
>  	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
>  	u8 prop;
> @@ -297,7 +297,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>  	}
>  
>  	if (irq->hw)
> -		return its_prop_update_vlpi(irq->host_irq, prop, true);
> +		return its_prop_update_vlpi(irq->host_irq, prop, needs_inv);
>  
>  	return 0;
>  }
> @@ -1096,7 +1096,7 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
>  	if (!ite)
>  		return E_ITS_INV_UNMAPPED_INTERRUPT;
>  
> -	return update_lpi_config(kvm, ite->irq, NULL);
> +	return update_lpi_config(kvm, ite->irq, NULL, true);
>  }
>  
>  /*
> @@ -1131,12 +1131,15 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
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
> 
