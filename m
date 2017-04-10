From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 22/22] KVM: arm64: ITS: Pending table save/restore
Date: Mon, 10 Apr 2017 13:50:37 +0100
Message-ID: <0cd4382f-30e1-c9b5-c171-6137436d8751@arm.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-23-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1490607072-21610-23-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 27/03/17 10:31, Eric Auger wrote:
> Save and restore the pending tables.
> 
> Pending table restore obviously requires the pendbaser to be
> already set.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v3 -> v4:
> - remove the wrong comment about locking
> - pass kvm struct instead of its handle
> - add comment about restore method
> - remove GITR_PENDABASER.PTZ check
> - continue if target_vcpu == NULL
> - new locking strategy
> 
> v1 -> v2:
> - do not care about the 1st KB which should be zeroed according to
>   the spec.
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 66 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 64 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index a516bbb..e10aa81 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1804,16 +1804,78 @@ static int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
>   */
>  static int vgic_its_flush_pending_tables(struct kvm *kvm)
>  {
> -	return -ENXIO;
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_irq *irq;
> +	int ret;
> +
> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
> +		struct kvm_vcpu *vcpu;
> +		gpa_t pendbase, ptr;
> +		bool stored;
> +		u8 val;
> +
> +		vcpu = irq->target_vcpu;
> +		if (!vcpu)
> +			continue;
> +
> +		pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
> +
> +		ptr = pendbase + (irq->intid / BITS_PER_BYTE);
> +
> +		ret = kvm_read_guest(kvm, (gpa_t)ptr, &val, 1);

ptr is already a gpa_t...

> +		if (ret)
> +			return ret;
> +
> +		stored = val & (irq->intid % BITS_PER_BYTE);
> +		if (stored == irq->pending_latch)
> +			continue;
> +
> +		if (irq->pending_latch)
> +			val |= 1 << (irq->intid % BITS_PER_BYTE);
> +		else
> +			val &= ~(1 << (irq->intid % BITS_PER_BYTE));
> +
> +		ret = kvm_write_guest(kvm, (gpa_t)ptr, &val, 1);
> +		if (ret)
> +			return ret;

Consider the optimization used in its_sync_lpi_pending_table(), where
consecutive LPIs stored in the same byte are set in a single access.

> +	}
> +
> +	return 0;
>  }
>  
>  /**
>   * vgic_its_restore_pending_tables - Restore the pending tables from guest
>   * RAM to internal data structs
> + *
> + * Does not scan the whole pending tables but just loop on all registered
> + * LPIS and scan their associated pending bit. This obviously requires
> + * the ITEs to be restored before.
>   */
>  static int vgic_its_restore_pending_tables(struct kvm *kvm)
>  {
> -	return -ENXIO;
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_irq *irq;
> +	int ret;
> +
> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
> +		struct kvm_vcpu *vcpu;
> +		gpa_t pendbase, ptr;
> +		u8 val;
> +
> +		vcpu = irq->target_vcpu;
> +		if (!vcpu)
> +			continue;
> +
> +		pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
> +
> +		ptr = pendbase + (irq->intid / BITS_PER_BYTE);
> +
> +		ret = kvm_read_guest(kvm, (gpa_t)ptr, &val, 1);
> +		if (ret)
> +			return ret;
> +		irq->pending_latch = val & (1 << (irq->intid % BITS_PER_BYTE));
> +	}
> +	return 0;

Again, this feels very similar to what its_sync_lpi_pending_table is
doing. We should be able to have some common code here.

>  }
>  
>  static int vgic_its_flush_ite(struct vgic_its *its, struct its_device *dev,
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
