From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 05/11] KVM: arm/arm64: Make vgic_v3_check_base more
 broadly usable
Date: Tue, 9 May 2017 11:45:17 +0200
Message-ID: <6914904e-0e77-5872-f9a5-c593576c3c41@redhat.com>
References: <20170509085618.28311-1-cdall@linaro.org>
 <20170509085618.28311-6-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6286405DA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 05:42:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cAC-Y2FLIp-s for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 05:42:06 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7D1940430
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 05:42:05 -0400 (EDT)
In-Reply-To: <20170509085618.28311-6-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 09/05/2017 10:56, Christoffer Dall wrote:
> As we are about to fiddle with the IO device registration mechanism,
> let's be a little more careful when setting base addresses as early as
> possible.  When setting a base address, we can check that there's
> address space enough for its scope and when the last of the two
> base addresses (dist and redist) get set, we can also check if the
> regions overlap at that time.
> 
> This allows us to provide error messages to the user at time when trying
> to set the base address, as opposed to later when trying to run the VM.
> 
> To do this,  we make vgic_v3_check_base available in the core vgic-v3
> code as well as in the other parts of the GICv3 code, namely the MMIO
> config code.
> 
> We also return true for undefined base addresses so that the function
> can be used before all base addresses are set; all callers already check
> for uninitialized addresses before calling this function.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  virt/kvm/arm/vgic/vgic-v3.c | 19 +++++++++++++++----
>  virt/kvm/arm/vgic/vgic.h    |  1 +
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 12e52a0..2d53d7a 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -329,19 +329,30 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>  	return 0;
>  }
>  
> -/* check for overlapping regions and for regions crossing the end of memory */
> -static bool vgic_v3_check_base(struct kvm *kvm)
> +/*
> + * Check for overlapping regions and for regions crossing the end of memory
> + * for base addresses which have already been set.
> + */
> +bool vgic_v3_check_base(struct kvm *kvm)
>  {
>  	struct vgic_dist *d = &kvm->arch.vgic;
>  	gpa_t redist_size = KVM_VGIC_V3_REDIST_SIZE;
>  
>  	redist_size *= atomic_read(&kvm->online_vcpus);
>  
> -	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE < d->vgic_dist_base)
> +	if (!IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) &&
> +	    d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE < d->vgic_dist_base)
>  		return false;
> -	if (d->vgic_redist_base + redist_size < d->vgic_redist_base)
> +
> +	if (!IS_VGIC_ADDR_UNDEF(d->vgic_redist_base) &&
> +	    d->vgic_redist_base + redist_size < d->vgic_redist_base)
>  		return false;
>  
> +	/* Both base addresses must be set to check if they overlap */
> +	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) ||
> +	    IS_VGIC_ADDR_UNDEF(d->vgic_redist_base))
> +		return true;
> +
>  	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= d->vgic_redist_base)
>  		return true;
>  	if (d->vgic_redist_base + redist_size <= d->vgic_dist_base)
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index a2aeaa8..89eb935 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -175,6 +175,7 @@ int vgic_v3_map_resources(struct kvm *kvm);
>  int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
>  int vgic_v3_save_pending_tables(struct kvm *kvm);
>  int vgic_register_redist_iodevs(struct kvm *kvm);
> +bool vgic_v3_check_base(struct kvm *kvm);
>  
>  void vgic_v3_load(struct kvm_vcpu *vcpu);
>  void vgic_v3_put(struct kvm_vcpu *vcpu);
> 
