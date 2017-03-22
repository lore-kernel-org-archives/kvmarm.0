From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 19/19] KVM: arm64: ITS: Pending table save/restore
Date: Wed, 22 Mar 2017 14:39:44 +0000
Message-ID: <19960cae-8dbd-6244-a2d6-96a8cea46d80@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-20-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3FA340992
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 10:36:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fbk0lQqR6pPN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Mar 2017 10:36:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C9540962
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 10:36:00 -0400 (EDT)
In-Reply-To: <1488800074-21991-20-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 06/03/17 11:34, Eric Auger wrote:
> Save and restore the pending tables.
> 
> Pending table restore obviously requires the pendbaser to be
> already set.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - do not care about the 1st KB which should be zeroed according to
>   the spec.
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 71 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 69 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 27ebabd..24824be 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1736,7 +1736,48 @@ static int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
>   */
>  static int vgic_its_flush_pending_tables(struct vgic_its *its)

So as suspected before, I think passing the "its" pointer here is wrong.
In fact you don't use that ITS except for getting the kvm pointer.
Architecturally the pending tables are per redistributor, so you should
pass a struct vcpu pointer.
So the cleanest way would be to have a FLUSH/RESTORE_PENDING_TABLE ioctl
on the *redistributor* kvm_device, which iterates through the list here
and just dumps the pending bits for LPIs targeting that VCPU (skipping
over others).
Alternatively it would be enough to pass just a struct kvm pointer here
and keep dumping all LPIs, but call this function only once per VM (not
for each ITS). That sounds a bit dodgy from the architectural point of
view, though.

>  {
> -	return -ENXIO;
> +	struct kvm *kvm = its->dev->kvm;
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_irq *irq;
> +	int ret;
> +
> +	/**
> +	 * we do not take the dist->lpi_list_lock since we have a garantee
> +	 * the LPI list is not touched while the its lock is held
> +	 */

As mentioned before I think this has to be reworked to take the lock,
copy the table, drop the lock again and then iterate over the (private)
copy to handle each LPI.
Or something completely different.
But IIRC the lpi_list_lock is taken completely independent of any ITS
emulation code in vgic.c.

> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
> +		struct kvm_vcpu *vcpu;
> +		gpa_t pendbase, ptr;
> +		bool stored;
> +		u8 val;
> +
> +		vcpu = irq->target_vcpu;
> +		if (!vcpu)
> +			return -EINVAL;

Isn't target_vcpu == NULL a valid use case? So continue; instead of return?

> +
> +		pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
> +
> +		ptr = pendbase + (irq->intid / BITS_PER_BYTE);
> +
> +		ret = kvm_read_guest(kvm, (gpa_t)ptr, &val, 1);
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
> +	}
> +
> +	return 0;
>  }
>  
>  /**
> @@ -1745,7 +1786,33 @@ static int vgic_its_flush_pending_tables(struct vgic_its *its)
>   */
>  static int vgic_its_restore_pending_tables(struct vgic_its *its)

Could deserve the comment that it doesn't actually scan the table for
set bits, but only checks the mapped LPIs (and thus should come last in
the restore process).
Also the same comment as above about using the "its" pointer applies here.

>  {
> -	return -ENXIO;
> +	struct vgic_irq *irq;
> +	struct kvm *kvm = its->dev->kvm;
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	int ret;
> +
> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
> +		struct kvm_vcpu *vcpu;
> +		gpa_t pendbase, ptr;
> +		u8 val;
> +
> +		vcpu = irq->target_vcpu;
> +		if (!vcpu)
> +			return -EINVAL;
> +
> +		if (!(vcpu->arch.vgic_cpu.pendbaser & GICR_PENDBASER_PTZ))
> +			return 0;

I believe this bit is only set once by software to communicate that
*initially* (upon enabling LPIs in the redistributor) the pending table
is clear. It is never cleared by the redistributor, so you can't rely on
it here.

Cheers,
Andre.

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
>  }
>  
>  static int vgic_its_flush_ite(struct vgic_its *its, struct its_device *dev,
> 
