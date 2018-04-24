From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 05/12] KVM: arm/arm64: Revisit Redistributor TYPER
 last bit computation
Date: Tue, 24 Apr 2018 23:06:55 +0200
Message-ID: <20180424210655.GF4533@C02W217FHV2R.local>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-6-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1523607658-9166-6-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 13, 2018 at 10:20:51AM +0200, Eric Auger wrote:
> The TYPER of an redistributor reflects whether the rdist is
> the last one of the redistributor region. Let's compare the TYPER
> GPA against the address of the last occupied slot within the
> redistributor region.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 49ca176..ce5c927 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -184,12 +184,17 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>  					      gpa_t addr, unsigned int len)
>  {
>  	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_redist_region *rdreg = vgic_cpu->rdreg;
>  	int target_vcpu_id = vcpu->vcpu_id;
> +	gpa_t last_rdist_typer = rdreg->base + GICR_TYPER +
> +			(rdreg->free_index - 1) * KVM_VGIC_V3_REDIST_SIZE;
>  	u64 value;
>  
>  	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
>  	value |= ((target_vcpu_id & 0xffff) << 8);
> -	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
> +
> +	if (addr == last_rdist_typer)
>  		value |= GICR_TYPER_LAST;
>  	if (vgic_has_its(vcpu->kvm))
>  		value |= GICR_TYPER_PLPIS;
> -- 
> 2.5.5
> 

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
