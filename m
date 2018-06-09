From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: drop resource size check for GICV window
Date: Sat, 9 Jun 2018 12:06:57 +0200
Message-ID: <20180609100657.GI5097@C02W217FHV2R.local>
References: <20180601150628.10111-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180601150628.10111-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 01, 2018 at 05:06:28PM +0200, Ard Biesheuvel wrote:
> When booting a 64 KB pages kernel on a ACPI GICv3 system that
> implements support for v2 emulation, the following warning is
> produced
> 
>   GICV size 0x2000 not a multiple of page size 0x10000
> 
> and support for v2 emulation is disabled, preventing GICv2 VMs
> from being able to run on such hosts.
> 
> The reason is that vgic_v3_probe() performs a sanity check on the
> size of the window (it should be a multiple of the page size),
> while the ACPI MADT parsing code hardcodes the size of the window
> to 8 KB. This makes sense, considering that ACPI does not bother
> to describe the size in the first place, under the assumption that
> platforms implementing ACPI will follow the architecture and not
> put anything else in the same 64 KB window.

Does the architecture actually say that anywhere?

> 
> So let's just drop the sanity check altogether, and assume that
> the window is at least 64 KB in size.

This could obviously be dangerous if broken systems actually exist.
Marc may know more about that than me.  An alternative would be to
modify the ACPI code to assume max(8 KB, page size) instead, and/or a
command line parameter to override this check.

That said, I'm not directly opposed to this patch, but I'll let Marc
have a look as well.

Thanks,
-Christoffer

> 
> Fixes: 909777324588 ("KVM: arm/arm64: vgic-new: vgic_init: implement kvm_vgic_hyp_init")
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-v3.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index bdcf8e7a6161..72fc688c3e9d 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -552,11 +552,6 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  		pr_warn("GICV physical address 0x%llx not page aligned\n",
>  			(unsigned long long)info->vcpu.start);
>  		kvm_vgic_global_state.vcpu_base = 0;
> -	} else if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
> -		pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
> -			(unsigned long long)resource_size(&info->vcpu),
> -			PAGE_SIZE);
> -		kvm_vgic_global_state.vcpu_base = 0;
>  	} else {
>  		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
>  		kvm_vgic_global_state.can_emulate_gicv2 = true;
> -- 
> 2.17.0
> 
