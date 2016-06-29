From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v7 01/17] KVM: arm/arm64: move redistributor kvm_io_devices
Date: Wed, 29 Jun 2016 17:58:39 +0200
Message-ID: <a0ff7bc8-deda-87d3-199f-9ff1dcfa49e4@redhat.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
 <20160628123230.26255-2-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38E3249B5D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 11:53:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ngnqyBy55aSZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2016 11:53:30 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B133949B5C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 11:53:30 -0400 (EDT)
In-Reply-To: <20160628123230.26255-2-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 28/06/2016 14:32, Andre Przywara wrote:
> Logically a GICv3 redistributor is assigned to a (v)CPU, so we should
> aim to keep redistributor related variables out of our struct vgic_dist.
> 
> Let's start by replacing the redistributor related kvm_io_device array
> with two members in our existing struct vgic_cpu, which are naturally
> per-VCPU and thus don't require any allocation / freeing.
> So apart from the better fit with the redistributor design this saves
> some code as well.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h          |  8 +++++++-
>  virt/kvm/arm/vgic/vgic-init.c    |  1 -
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 22 ++++++++--------------
>  3 files changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 3fbd175..2f26f37 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -145,7 +145,6 @@ struct vgic_dist {
>  	struct vgic_irq		*spis;
>  
>  	struct vgic_io_device	dist_iodev;
> -	struct vgic_io_device	*redist_iodevs;
>  };
>  
>  struct vgic_v2_cpu_if {
> @@ -193,6 +192,13 @@ struct vgic_cpu {
>  	struct list_head ap_list_head;
>  
>  	u64 live_lrs;
> +
> +	/*
> +	 * Members below are used with GICv3 emulation only and represent
> +	 * parts of the redistributor.
> +	 */
> +	struct vgic_io_device	rd_iodev;
> +	struct vgic_io_device	sgi_iodev;
>  };
>  
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index a1442f7..90cae48 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -271,7 +271,6 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>  	dist->initialized = false;
>  
>  	kfree(dist->spis);
> -	kfree(dist->redist_iodevs);
>  	dist->nr_spis = 0;
>  
>  	mutex_unlock(&kvm->lock);
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index a0c515a..fc7b6c9 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -285,21 +285,14 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
>  
>  int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
>  {
> -	int nr_vcpus = atomic_read(&kvm->online_vcpus);
>  	struct kvm_vcpu *vcpu;
> -	struct vgic_io_device *devices;
>  	int c, ret = 0;
>  
> -	devices = kmalloc(sizeof(struct vgic_io_device) * nr_vcpus * 2,
> -			  GFP_KERNEL);
> -	if (!devices)
> -		return -ENOMEM;
> -
>  	kvm_for_each_vcpu(c, vcpu, kvm) {
>  		gpa_t rd_base = redist_base_address + c * SZ_64K * 2;
>  		gpa_t sgi_base = rd_base + SZ_64K;
> -		struct vgic_io_device *rd_dev = &devices[c * 2];
> -		struct vgic_io_device *sgi_dev = &devices[c * 2 + 1];
> +		struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
> +		struct vgic_io_device *sgi_dev = &vcpu->arch.vgic_cpu.sgi_iodev;
>  
>  		kvm_iodevice_init(&rd_dev->dev, &kvm_io_gic_ops);
>  		rd_dev->base_addr = rd_base;
> @@ -335,14 +328,15 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
>  	if (ret) {
>  		/* The current c failed, so we start with the previous one. */
>  		for (c--; c >= 0; c--) {
> +			struct vgic_cpu *vgic_cpu;
> +
> +			vcpu = kvm_get_vcpu(kvm, c);
> +			vgic_cpu = &vcpu->arch.vgic_cpu;
>  			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> -						  &devices[c * 2].dev);
> +						  &vgic_cpu->rd_iodev.dev);
>  			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> -						  &devices[c * 2 + 1].dev);
> +						  &vgic_cpu->sgi_iodev.dev);
>  		}
> -		kfree(devices);
> -	} else {
> -		kvm->arch.vgic.redist_iodevs = devices;
>  	}
>  
>  	return ret;
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>
