From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 10/12] KVM: arm/arm64: prepare GICv3 emulation to use
 kvm_io_bus MMIO handling
Date: Sat, 14 Mar 2015 15:39:57 +0100
Message-ID: <20150314143957.GF10935@cbox>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-11-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B4F448D82
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:33:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lBtBPe6f2nPI for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Mar 2015 10:33:07 -0400 (EDT)
Received: from mail-la0-f41.google.com (mail-la0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2CB648D80
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:33:06 -0400 (EDT)
Received: by labjg1 with SMTP id jg1so9812440lab.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 07:39:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1426263012-22935-11-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 13, 2015 at 04:10:10PM +0000, Andre Przywara wrote:
> Using the framework provided by the recent vgic.c changes, we
> register a kvm_io_bus device on mapping the virtual GICv3 resources.
> The distributor mapping is pretty straight forward, but the
> redistributors need some more love, since they need to be tagged with
> the respective redistributor (read: VCPU) they are connected with.
> We use the kvm_io_bus framework to register two devices per VCPU, as
> each block is handled independently by the VGIC code.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h      |    1 +
>  virt/kvm/arm/vgic-v3-emul.c |   32 +++++++++++++++++++++++++++++++-
>  virt/kvm/arm/vgic.c         |   14 ++++++++++++++
>  3 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 74a4ac4..09fd324 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -246,6 +246,7 @@ struct vgic_dist {
>  
>  	struct vgic_vm_ops	vm_ops;
>  	struct vgic_io_device	dist_iodev;
> +	struct vgic_io_device	*redist_iodevs;
>  };
>  
>  struct vgic_v2_cpu_if {
> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
> index 14943e3..8a81c67 100644
> --- a/virt/kvm/arm/vgic-v3-emul.c
> +++ b/virt/kvm/arm/vgic-v3-emul.c
> @@ -766,6 +766,9 @@ static int vgic_v3_map_resources(struct kvm *kvm,
>  {
>  	int ret = 0;
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> +	gpa_t rdbase = dist->vgic_redist_base;
> +	struct vgic_io_device *iodevs = NULL;
> +	int i;
>  
>  	if (!irqchip_in_kernel(kvm))
>  		return 0;
> @@ -791,7 +794,34 @@ static int vgic_v3_map_resources(struct kvm *kvm,
>  		goto out;
>  	}
>  
> -	kvm->arch.vgic.ready = true;
> +	ret = vgic_register_kvm_io_dev(kvm, dist->vgic_dist_base,
> +				       GIC_V3_DIST_SIZE, vgic_v3_dist_ranges,
> +				       -1, &dist->dist_iodev);
> +	if (ret)
> +		goto out;
> +
> +	iodevs = kcalloc(dist->nr_cpus * 2, sizeof(iodevs[0]), GFP_KERNEL);
> +	if (!iodevs) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	for (i = 0; i < dist->nr_cpus; i++) {
> +		ret = vgic_register_kvm_io_dev(kvm, rdbase,
> +					       SZ_64K, vgic_redist_ranges,
> +					       i, &iodevs[i * 2]);
> +		if (ret)
> +			goto out;
> +		ret = vgic_register_kvm_io_dev(kvm, rdbase + SGI_BASE_OFFSET,
> +					       SZ_64K, vgic_redist_sgi_ranges,
> +					       i, &iodevs[i * 2 + 1]);
> +		if (ret)
> +			goto out;
> +		rdbase += GIC_V3_REDIST_SIZE;
> +	}
> +
> +	dist->redist_iodevs = iodevs;
> +	dist->ready = true;
> +

May be worth placing a comment in the error path that kvm_vgic_destroy
will clean up all registered kvm iodevs and free the allocated array.

>  out:
>  	if (ret)
>  		kvm_vgic_destroy(kvm);
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index b1dd717..f762738 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -911,6 +911,8 @@ int vgic_register_kvm_io_dev(struct kvm *kvm, gpa_t base, int len,
>  static void vgic_unregister_kvm_io_dev(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_io_device *iodevs;
> +	int i;
>  
>  	if (!dist || !kvm->buses[KVM_MMIO_BUS])
>  		return;
> @@ -919,6 +921,18 @@ static void vgic_unregister_kvm_io_dev(struct kvm *kvm)
>  	if (dist->dist_iodev.dev.ops)
>  		kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
>  					  &dist->dist_iodev.dev);
> +
> +	iodevs = dist->redist_iodevs;
> +	if (iodevs) {
> +		for (i = 0; i < dist->nr_cpus * 2; i++) {
> +			if (!iodevs[i].dev.ops)
> +				continue;

this looks a bit strange because vgic_register_kvm_io_dev does not clear
the ops pointer if kvm_io_bus_register_dev fails... ?

> +			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> +						  &iodevs[i].dev);
> +		}
> +		kfree(iodevs);
> +		dist->redist_iodevs = NULL;
> +	}
>  	mutex_unlock(&kvm->slots_lock);
>  }
>  
> -- 
> 1.7.9.5
> 
