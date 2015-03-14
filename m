From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 08/12] KVM: arm/arm64: implement kvm_io_bus MMIO handling
 for the VGIC
Date: Sat, 14 Mar 2015 15:27:20 +0100
Message-ID: <20150314142720.GD10935@cbox>
References: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
 <1426263012-22935-9-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 577EB48D74
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:20:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wc065MnUZqZJ for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Mar 2015 10:20:31 -0400 (EDT)
Received: from mail-lb0-f182.google.com (mail-lb0-f182.google.com
 [209.85.217.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06910488A2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 10:20:30 -0400 (EDT)
Received: by lbbzq9 with SMTP id zq9so6640061lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Mar 2015 07:26:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1426263012-22935-9-git-send-email-andre.przywara@arm.com>
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

On Fri, Mar 13, 2015 at 04:10:08PM +0000, Andre Przywara wrote:
> Currently we use a lot of VGIC specific code to do the MMIO
> dispatching.
> Use the previous reworks to add kvm_io_bus style MMIO handlers.
> 
> Those are not yet called by the MMIO abort handler, also the actual
> VGIC emulator function do not make use of it yet, but will be enabled
> with the following patches.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h |    9 ++++
>  virt/kvm/arm/vgic.c    |  111 ++++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic.h    |    7 +++
>  3 files changed, 127 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index b81630b..4bfc6a3 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -24,6 +24,7 @@
>  #include <linux/irqreturn.h>
>  #include <linux/spinlock.h>
>  #include <linux/types.h>
> +#include <kvm/iodev.h>
>  
>  #define VGIC_NR_IRQS_LEGACY	256
>  #define VGIC_NR_SGIS		16
> @@ -147,6 +148,14 @@ struct vgic_vm_ops {
>  	int	(*map_resources)(struct kvm *, const struct vgic_params *);
>  };
>  
> +struct vgic_io_device {
> +	gpa_t addr;
> +	int len;
> +	const struct vgic_io_range *reg_ranges;
> +	struct kvm_vcpu *redist_vcpu;
> +	struct kvm_io_device dev;
> +};
> +
>  struct vgic_dist {
>  	spinlock_t		lock;
>  	bool			in_kernel;
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 7aae19b..71389b8 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -32,6 +32,8 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_mmu.h>
>  #include <trace/events/kvm.h>
> +#include <asm/kvm.h>
> +#include <kvm/iodev.h>
>  
>  /*
>   * How the whole thing works (courtesy of Christoffer Dall):
> @@ -774,6 +776,66 @@ bool vgic_handle_mmio_range(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  }
>  
>  /**
> + * vgic_handle_mmio_access - handle an in-kernel MMIO access
> + * This is called by the read/write KVM IO device wrappers below.
> + * @vcpu:	pointer to the vcpu performing the access
> + * @this:	pointer to the KVM IO device in charge
> + * @addr:	guest physical address of the access
> + * @len:	size of the access
> + * @val:	pointer to the data region
> + * @is_write:	read or write access
> + *
> + * returns true if the MMIO access could be performed
> + */
> +static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
> +				   struct kvm_io_device *this, gpa_t addr,
> +				   int len, void *val, bool is_write)
> +{
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	struct kvm_run *run = vcpu->run;
> +	const struct vgic_io_range *range;
> +	struct kvm_exit_mmio mmio;
> +	bool updated_state;
> +	gpa_t offset;
> +
> +	offset = addr - iodev->addr;
> +	range = vgic_find_range(iodev->reg_ranges, len, offset);
> +	if (unlikely(!range || !range->handle_mmio)) {
> +		pr_warn("Unhandled access %d %08llx %d\n", is_write, addr, len);
> +		return -ENXIO;
> +	}
> +
> +	mmio.phys_addr = addr;
> +	mmio.len = len;
> +	mmio.is_write = is_write;
> +	if (is_write)
> +		memcpy(mmio.data, val, len);
> +	mmio.private = iodev->redist_vcpu;
> +
> +	spin_lock(&dist->lock);
> +	offset -= range->base;
> +	if (vgic_validate_access(dist, range, offset)) {
> +		updated_state = call_range_handler(vcpu, &mmio, offset, range);
> +		if (!is_write)
> +			memcpy(val, mmio.data, len);
> +	} else {
> +		if (!is_write)
> +			memset(val, 0, len);
> +		updated_state = false;
> +	}
> +	spin_unlock(&dist->lock);
> +	kvm_prepare_mmio(run, &mmio);

we're not the only user of kvm_exit_mmio I believe, so we could rename
this to vgic_io as well and you could change the mmio.data array to be a
void *val pointer, which just gets set to the pointer passed into this
function (which I think points to the kvm_run structs data array) and
you can avoid all these memcopies, right?

> +	kvm_handle_mmio_return(vcpu, run);
> +
> +	if (updated_state)
> +		vgic_kick_vcpus(vcpu->kvm);
> +
> +	return 0;
> +}
> +
> +/**
>   * vgic_handle_mmio - handle an in-kernel MMIO access for the GIC emulation
>   * @vcpu:      pointer to the vcpu performing the access
>   * @run:       pointer to the kvm_run structure
> @@ -797,6 +859,55 @@ bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	return vcpu->kvm->arch.vgic.vm_ops.handle_mmio(vcpu, run, mmio);
>  }
>  
> +static int vgic_handle_mmio_read(struct kvm_vcpu *vcpu,
> +				 struct kvm_io_device *this,
> +				 gpa_t addr, int len, void *val)
> +{
> +	return vgic_handle_mmio_access(vcpu, this, addr, len, val, false);
> +}
> +
> +static int vgic_handle_mmio_write(struct kvm_vcpu *vcpu,
> +				  struct kvm_io_device *this,
> +				  gpa_t addr, int len, const void *val)
> +{
> +	return vgic_handle_mmio_access(vcpu, this, addr, len, (void *)val,
> +				       true);
> +}
> +
> +struct kvm_io_device_ops vgic_io_ops = {
> +	.read	= vgic_handle_mmio_read,
> +	.write	= vgic_handle_mmio_write,
> +};
> +

can you add kdocs to this exported function?

> +int vgic_register_kvm_io_dev(struct kvm *kvm, gpa_t base, int len,
> +			     const struct vgic_io_range *ranges,
> +			     int redist_id,

nit: consider renaming to redist_vcpu_id

> +			     struct vgic_io_device *iodev)
> +{
> +	struct kvm_vcpu *vcpu = NULL;
> +	int ret;
> +
> +	if (redist_id >= 0)
> +		vcpu = kvm_get_vcpu(kvm, redist_id);
> +
> +	iodev->addr		= base;
> +	iodev->len		= len;
> +	iodev->reg_ranges	= ranges;
> +	iodev->redist_vcpu	= vcpu;
> +
> +	kvm_iodevice_init(&iodev->dev, &vgic_io_ops);
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, base, len,
> +				      &iodev->dev);
> +	mutex_unlock(&kvm->slots_lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;

kvm_io_bus_register_dev returns either 0 or -ERRNO, so you can just
return ret here.

> +}
> +
>  static int vgic_nr_shared_irqs(struct vgic_dist *dist)
>  {
>  	return dist->nr_irqs - VGIC_NR_PRIVATE_IRQS;
> diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
> index ffafb15..f2063a7 100644
> --- a/virt/kvm/arm/vgic.h
> +++ b/virt/kvm/arm/vgic.h
> @@ -20,6 +20,8 @@
>  #ifndef __KVM_VGIC_H__
>  #define __KVM_VGIC_H__
>  
> +#include <kvm/iodev.h>
> +
>  #define VGIC_ADDR_UNDEF		(-1)
>  #define IS_VGIC_ADDR_UNDEF(_x)  ((_x) == VGIC_ADDR_UNDEF)
>  
> @@ -82,6 +84,11 @@ struct vgic_io_range {
>  			    phys_addr_t offset);
>  };
>  
> +int vgic_register_kvm_io_dev(struct kvm *kvm, gpa_t base, int len,
> +			     const struct vgic_io_range *ranges,
> +			     int redist_id,
> +			     struct vgic_io_device *iodev);
> +
>  static inline bool is_in_range(phys_addr_t addr, unsigned long len,
>  			       phys_addr_t baseaddr, unsigned long size)
>  {
> -- 
> 1.7.9.5
> 
