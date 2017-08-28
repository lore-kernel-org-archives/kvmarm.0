From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 55/59] KVM: arm/arm64: GICv4: Enable VLPI support
Date: Mon, 28 Aug 2017 20:25:47 +0200
Message-ID: <20170828182547.GP24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-56-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-56-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 31, 2017 at 06:26:33PM +0100, Marc Zyngier wrote:
> All it takes is the has_v4 flag to be set in gic_kvm_info
> as well as "kvm-arm.vgic_v4_enable=1" being passed on the
> command line for GICv4 to be enabled in KVM.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

So I'm wondering if we should have a per-VM option to turn this on or
off, which may be useful for debugging and profiling.

On the other hand, I can't see x86 having this feature, so maybe it's
not worth it.

For this patch:

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  Documentation/admin-guide/kernel-parameters.txt |  4 ++++
>  virt/kvm/arm/vgic/vgic-v3.c                     | 14 ++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index d9c171ce4190..d2927d01d8b2 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1874,6 +1874,10 @@
>  			[KVM,ARM] Trap guest accesses to GICv3 common
>  			system registers
>  
> +	kvm-arm.vgic_v4_enable=
> +			[KVM,ARM] Allow use of GICv4 for direct injection of
> +			LPIs.
> +
>  	kvm-intel.ept=	[KVM,Intel] Disable extended page tables
>  			(virtualized MMU) support on capable Intel chips.
>  			Default is 1 (enabled)
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 96ea597db0e7..405733678c2f 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -24,6 +24,7 @@
>  static bool group0_trap;
>  static bool group1_trap;
>  static bool common_trap;
> +static bool gicv4_enable;
>  
>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
>  {
> @@ -459,6 +460,12 @@ static int __init early_common_trap_cfg(char *buf)
>  }
>  early_param("kvm-arm.vgic_v3_common_trap", early_common_trap_cfg);
>  
> +static int __init early_gicv4_enable(char *buf)
> +{
> +	return strtobool(buf, &gicv4_enable);
> +}
> +early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
> +
>  /**
>   * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
>   * @node:	pointer to the DT node
> @@ -478,6 +485,13 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	kvm_vgic_global_state.can_emulate_gicv2 = false;
>  	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
>  
> +	/* GICv4 support? */
> +	if (info->has_v4) {
> +		kvm_vgic_global_state.has_gicv4 = gicv4_enable;
> +		kvm_info("GICv4 support %sabled\n",
> +			 gicv4_enable ? "en" : "dis");
> +	}
> +
>  	if (!info->vcpu.start) {
>  		kvm_info("GICv3: no GICV resource entry\n");
>  		kvm_vgic_global_state.vcpu_base = 0;
> -- 
> 2.11.0
> 
