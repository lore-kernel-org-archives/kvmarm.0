From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] arm64: vgic-v2: Fix proxying of cpuif access
Date: Sun, 29 Apr 2018 14:34:32 +0200
Message-ID: <20180429123432.GA7512@C02W217FHV2R.local>
References: <20180427145102.5645-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180427145102.5645-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 27, 2018 at 03:51:02PM +0100, Marc Zyngier wrote:
> Proxying the cpuif accesses at EL2 makes use of vcpu_data_guest_to_host
> and co, which check the endianness, which call into vcpu_read_sys_reg...
> which isn't mapped at EL2 (it was inlined before, and got moved OoL
> with the VHE optimizations).

I thought we relied on static inline functions to always be inlined, but
apparently not?  Does this mean we have potential other bugs looming
depending on the mood of the compiler, or was there something special
that went wrong here?

> 
> The result is of course a nice panic. Let's add some specialized
> cruft to keep the broken platforms that require this hack alive.
> I'd rather kill BE support, but hey, just in case...
> 
> Fixes: d47533dab9f5 ("KVM: arm64: Introduce framework for accessing deferred sysregs")
> Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>

> ---
>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 33 ++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> index 86801b6055d6..b83a669b26ac 100644
> --- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> +++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> @@ -23,6 +23,30 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  
> +static bool __hyp_text __is_be(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu_mode_is_32bit(vcpu))
> +		return !!(read_sysreg_el2(spsr) & COMPAT_PSR_E_BIT);
> +
> +	return !!(read_sysreg(SCTLR_EL1) & SCTLR_ELx_EE);
> +}
> +
> +static u32 __hyp_text __host_to_guest_u32(struct kvm_vcpu *vcpu, u32 data)
> +{
> +	if (__is_be(vcpu))
> +		return cpu_to_be32(data);
> +
> +	return cpu_to_le32(data);
> +}
> +
> +static u32 __hyp_text __guest_to_host_u32(struct kvm_vcpu *vcpu, u32 data)
> +{
> +	if (__is_be(vcpu))
> +		return be32_to_cpu(data);
> +
> +	return le32_to_cpu(data);
> +}
> +
>  /*
>   * __vgic_v2_perform_cpuif_access -- perform a GICV access on behalf of the
>   *				     guest.
> @@ -64,14 +88,11 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	addr += fault_ipa - vgic->vgic_cpu_base;
>  
>  	if (kvm_vcpu_dabt_iswrite(vcpu)) {
> -		u32 data = vcpu_data_guest_to_host(vcpu,
> -						   vcpu_get_reg(vcpu, rd),
> -						   sizeof(u32));
> +		u32 data = __guest_to_host_u32(vcpu, vcpu_get_reg(vcpu, rd));
>  		writel_relaxed(data, addr);
>  	} else {
> -		u32 data = readl_relaxed(addr);
> -		vcpu_set_reg(vcpu, rd, vcpu_data_host_to_guest(vcpu, data,
> -							       sizeof(u32)));
> +		u32 data = __host_to_guest_u32(vcpu, readl_relaxed(addr));
> +		vcpu_set_reg(vcpu, rd, data);
>  	}
>  
>  	return 1;
> -- 
> 2.14.2
> 
