From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 49/59] KVM: arm/arm64: GICv4: Propagate VLPI
 properties at map time
Date: Mon, 28 Aug 2017 20:18:41 +0200
Message-ID: <20170828181841.GJ24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-50-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-50-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 31, 2017 at 06:26:27PM +0100, Marc Zyngier wrote:
> When the VLPI gets mapped, it must inherit the configuration of
> LPI configured at the vITS level. FOr that purpose, let's make

*the LPI
*For that

> update_lpi_config globally available and call it just after
> having performed the VLPI map operation.
> 

I assume this means that the GIC compares the priorities of virtual
interrupts in the LRs with the priorities of the pending VLPIs and
figures out what to signal first?  I couldn't find anywhere in the spec
where this is explicitly stated.

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 6 ++----
>  virt/kvm/arm/vgic/vgic-v4.c  | 2 ++
>  virt/kvm/arm/vgic/vgic.h     | 2 ++
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index b395df1bf47c..d790d0c74b8b 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -37,8 +37,6 @@
>  static int vgic_its_save_tables_v0(struct vgic_its *its);
>  static int vgic_its_restore_tables_v0(struct vgic_its *its);
>  static int vgic_its_commit_v0(struct vgic_its *its);
> -static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> -			     struct kvm_vcpu *filter_vcpu, bool needs_inv);
>  
>  /*
>   * Creates a new (reference to a) struct vgic_irq for a given LPI.
> @@ -273,8 +271,8 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
>   * If filter_vcpu is not NULL, applies only if the IRQ is targeting this
>   * VCPU. Unconditionally applies if filter_vcpu is NULL.
>   */
> -static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> -			     struct kvm_vcpu *filter_vcpu, bool needs_inv)
> +int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> +		      struct kvm_vcpu *filter_vcpu, bool needs_inv)
>  {
>  	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
>  	u8 prop;
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index 338c86c5159f..534d3051a078 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -137,6 +137,8 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>  	irq->hw		= true;
>  	irq->host_irq	= virq;
>  
> +	/* Force the property update and invalidate */
> +	update_lpi_config(kvm, irq, NULL, true);
>  out:
>  	mutex_unlock(&its->its_lock);
>  	return 0;
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 1356f485d7cf..1210bf4681dc 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -228,6 +228,8 @@ void unlock_all_vcpus(struct kvm *kvm);
>  int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  			 u32 devid, u32 eventid, struct vgic_irq **irq);
>  struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
> +int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> +		      struct kvm_vcpu *filter_vcpu, bool needs_inv);
>  
>  bool vgic_is_v4_capable(struct kvm *kvm);
>  int vgic_v4_init(struct kvm *kvm);
> -- 
> 2.11.0
> 

Acked-by: Christoffer Dall <cdall@linaro.org>
