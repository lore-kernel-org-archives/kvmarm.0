From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v4 09/12] KVM: arm/arm64: Check all vcpu redistributors
 are set on map_resources
Date: Sun, 29 Apr 2018 14:35:33 +0200
Message-ID: <20180429123533.GE7512@C02W217FHV2R.local>
References: <1524838505-3823-1-git-send-email-eric.auger@redhat.com>
 <1524838505-3823-10-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524838505-3823-10-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 27, 2018 at 04:15:02PM +0200, Eric Auger wrote:
> On vcpu first run, we eventually know the actual number of vcpus.
> This is a synchronization point to check all redistributors
> were assigned. On kvm_vgic_map_resources() we check both dist and
> redist were set, eventually check potential base address inconsistencies.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>

> 
> ---
> 
> v3 -> v4:
> - use kvm_debug
> ---
>  virt/kvm/arm/vgic/vgic-v3.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index c4a2a46..5563671 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -484,16 +484,25 @@ struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rd_regions)
>  
>  int vgic_v3_map_resources(struct kvm *kvm)
>  {
> -	int ret = 0;
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> -	struct vgic_redist_region *rdreg =
> -		list_first_entry(&dist->rd_regions,
> -				 struct vgic_redist_region, list);
> +	struct kvm_vcpu *vcpu;
> +	int ret = 0;
> +	int c;
>  
>  	if (vgic_ready(kvm))
>  		goto out;
>  
> -	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) || !rdreg) {
> +	kvm_for_each_vcpu(c, vcpu, kvm) {
> +		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +
> +		if (IS_VGIC_ADDR_UNDEF(vgic_cpu->rd_iodev.base_addr)) {
> +			kvm_debug("vcpu %d redistributor base not set\n", c);
> +			ret = -ENXIO;
> +			goto out;
> +		}
> +	}
> +
> +	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base)) {
>  		kvm_err("Need to set vgic distributor addresses first\n");
>  		ret = -ENXIO;
>  		goto out;
> -- 
> 2.5.5
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
