From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: vgic: Add debugfs vgic-state file
Date: Wed, 25 Jan 2017 10:09:25 +0000
Message-ID: <0ec06062-e6fd-eb38-5c26-76670bd96d0b@arm.com>
References: <20170124132555.19094-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170124132555.19094-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Alex Bennee <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 24/01/17 13:25, Christoffer Dall wrote:
> Add a file to debugfs to read the in-kernel state of the vgic.  We don't
> do any locking of the entire VGIC state while traversing all the IRQs,
> so if the VM is running the user/developer may not see a quiesced state,
> but should take care to pause the VM using facilities in user space for
> that purpose.
> 
> We also don't support LPIs yet, but they can be added easily if needed.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks for renaming the MPIDR header field! Also I can confirm that the
multiple readers issue has been fixed.

Tested-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
> Changes since v1:
>  - Check error code in vgic_debug_stop so that users which did not
>    succeed in opening the seq file also doesn't do the cleanup, which
>    could lead to a kernel crash with multiple readers of this file
>    before.
>  - Renamed some functions to be a bit less cute
>  - Rebased on the patch that gets rid of the pendin field in struct
>    vgic_irq.
> 
>  arch/arm/kvm/Makefile          |   1 +
>  arch/arm64/kvm/Makefile        |   1 +
>  include/kvm/arm_vgic.h         |   5 +
>  virt/kvm/arm/vgic/vgic-debug.c | 284 +++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-init.c  |   4 +
>  virt/kvm/arm/vgic/vgic.h       |   3 +
>  6 files changed, 298 insertions(+)
>  create mode 100644 virt/kvm/arm/vgic/vgic-debug.c
> 
> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> index d571243..12b6281 100644
> --- a/arch/arm/kvm/Makefile
> +++ b/arch/arm/kvm/Makefile
> @@ -33,5 +33,6 @@ obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
>  obj-y += $(KVM)/arm/vgic/vgic-mmio-v3.o
>  obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
>  obj-y += $(KVM)/arm/vgic/vgic-its.o
> +obj-y += $(KVM)/arm/vgic/vgic-debug.o
>  obj-y += $(KVM)/irqchip.o
>  obj-y += $(KVM)/arm/arch_timer.o
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index d50a82a..e025bec 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -31,6 +31,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-debug.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index da2ce08..0af1477 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -166,6 +166,8 @@ struct vgic_its {
>  	struct list_head	collection_list;
>  };
>  
> +struct vgic_state_iter;
> +
>  struct vgic_dist {
>  	bool			in_kernel;
>  	bool			ready;
> @@ -213,6 +215,9 @@ struct vgic_dist {
>  	spinlock_t		lpi_list_lock;
>  	struct list_head	lpi_list_head;
>  	int			lpi_list_count;
> +
> +	/* used by vgic-debug */
> +	struct vgic_state_iter *iter;
>  };
>  
>  struct vgic_v2_cpu_if {
> diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
> new file mode 100644
> index 0000000..ec466a6
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-debug.c
> @@ -0,0 +1,284 @@
> +/*
> + * Copyright (C) 2016 Linaro
> + * Author: Christoffer Dall <christoffer.dall@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/cpu.h>
> +#include <linux/debugfs.h>
> +#include <linux/interrupt.h>
> +#include <linux/kvm_host.h>
> +#include <linux/seq_file.h>
> +#include <linux/uaccess.h>
> +#include <kvm/arm_vgic.h>
> +#include <asm/kvm_mmu.h>
> +#include "vgic.h"
> +
> +/*
> + * Structure to control looping through the entire vgic state.  We start at
> + * zero for each field and move upwards.  So, if dist_id is 0 we print the
> + * distributor info.  When dist_id is 1, we have already printed it and move
> + * on.
> + *
> + * When vcpu_id < nr_cpus we print the vcpu info until vcpu_id == nr_cpus and
> + * so on.
> + */
> +struct vgic_state_iter {
> +	int nr_cpus;
> +	int nr_spis;
> +	int dist_id;
> +	int vcpu_id;
> +	int intid;
> +};
> +
> +static void iter_next(struct vgic_state_iter *iter)
> +{
> +	if (iter->dist_id == 0) {
> +		iter->dist_id++;
> +		return;
> +	}
> +
> +	iter->intid++;
> +	if (iter->intid == VGIC_NR_PRIVATE_IRQS &&
> +	    ++iter->vcpu_id < iter->nr_cpus)
> +		iter->intid = 0;
> +}
> +
> +static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
> +		      loff_t pos)
> +{
> +	int nr_cpus = atomic_read(&kvm->online_vcpus);
> +
> +	memset(iter, 0, sizeof(*iter));
> +
> +	iter->nr_cpus = nr_cpus;
> +	iter->nr_spis = kvm->arch.vgic.nr_spis;
> +
> +	/* Fast forward to the right position if needed */
> +	while (pos--)
> +		iter_next(iter);
> +}
> +
> +static bool end_of_vgic(struct vgic_state_iter *iter)
> +{
> +	return iter->dist_id > 0 &&
> +		iter->vcpu_id == iter->nr_cpus &&
> +		(iter->intid - VGIC_NR_PRIVATE_IRQS) == iter->nr_spis;
> +}
> +
> +static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
> +{
> +	struct kvm *kvm = (struct kvm *)s->private;
> +	struct vgic_state_iter *iter;
> +
> +	mutex_lock(&kvm->lock);
> +	iter = kvm->arch.vgic.iter;
> +	if (iter) {
> +		iter = ERR_PTR(-EBUSY);
> +		goto out;
> +	}
> +
> +	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
> +	if (!iter) {
> +		iter = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +
> +	iter_init(kvm, iter, *pos);
> +	kvm->arch.vgic.iter = iter;
> +
> +	if (end_of_vgic(iter))
> +		iter = NULL;
> +out:
> +	mutex_unlock(&kvm->lock);
> +	return iter;
> +}
> +
> +static void *vgic_debug_next(struct seq_file *s, void *v, loff_t *pos)
> +{
> +	struct kvm *kvm = (struct kvm *)s->private;
> +	struct vgic_state_iter *iter = kvm->arch.vgic.iter;
> +
> +	++*pos;
> +	iter_next(iter);
> +	if (end_of_vgic(iter))
> +		iter = NULL;
> +	return iter;
> +}
> +
> +static void vgic_debug_stop(struct seq_file *s, void *v)
> +{
> +	struct kvm *kvm = (struct kvm *)s->private;
> +	struct vgic_state_iter *iter;
> +
> +	/*
> +	 * If the seq file wasn't properly opened, there's nothing to clearn
> +	 * up.
> +	 */
> +	if (IS_ERR(v))
> +		return;
> +
> +	mutex_lock(&kvm->lock);
> +	iter = kvm->arch.vgic.iter;
> +	kfree(iter);
> +	kvm->arch.vgic.iter = NULL;
> +	mutex_unlock(&kvm->lock);
> +}
> +
> +static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
> +{
> +	seq_printf(s, "Distributor\n");
> +	seq_printf(s, "===========\n");
> +	seq_printf(s, "vgic_model:\t%s\n",
> +		   (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) ?
> +		   "GICv3" : "GICv2");
> +	seq_printf(s, "nr_spis:\t%d\n", dist->nr_spis);
> +	seq_printf(s, "enabled:\t%d\n", dist->enabled);
> +	seq_printf(s, "\n");
> +
> +	seq_printf(s, "P=pending, L=line_level, S=soft_pending, A=active\n");
> +	seq_printf(s, "E=enabled, H=hw, L=config_level\n");
> +}
> +
> +static void print_header(struct seq_file *s, struct vgic_irq *irq,
> +			 struct kvm_vcpu *vcpu)
> +{
> +	int id = 0;
> +	char *hdr = "SPI ";
> +
> +	if (vcpu) {
> +		hdr = "VCPU";
> +		id = vcpu->vcpu_id;
> +	}
> +
> +	seq_printf(s, "\n");
> +	seq_printf(s, "%s%2d TYP   ID TGT_ID PLAEHL     HWID   TARGET SRC PRI VCPU_ID\n", hdr, id);
> +	seq_printf(s, "---------------------------------------------------------------\n");
> +}
> +
> +static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
> +			    struct kvm_vcpu *vcpu)
> +{
> +	char *type;
> +	if (irq->intid < VGIC_NR_SGIS)
> +		type = "SGI";
> +	else if (irq->intid < VGIC_NR_PRIVATE_IRQS)
> +		type = "PPI";
> +	else
> +		type = "SPI";
> +
> +	if (irq->intid ==0 || irq->intid == VGIC_NR_PRIVATE_IRQS)
> +		print_header(s, irq, vcpu);
> +
> +	seq_printf(s, "       %s %4d "
> +		      "    %2d "
> +		      "%d%d%d%d%d%d "
> +		      "%8x "
> +		      "%8x "
> +		      " %2x "
> +		      " %2x "
> +		      "     %2d "
> +		      "\n",
> +			type, irq->intid,
> +			(irq->target_vcpu) ? irq->target_vcpu->vcpu_id : -1,
> +			irq->pending_latch,
> +			irq->line_level,
> +			irq->active,
> +			irq->enabled,
> +			irq->hw,
> +			irq->config == VGIC_CONFIG_LEVEL,
> +			irq->hwintid,
> +			irq->mpidr,
> +			irq->source,
> +			irq->priority,
> +			(irq->vcpu) ? irq->vcpu->vcpu_id : -1);
> +
> +}
> +
> +static int vgic_debug_show(struct seq_file *s, void *v)
> +{
> +	struct kvm *kvm = (struct kvm *)s->private;
> +	struct vgic_state_iter *iter = (struct vgic_state_iter *)v;
> +	struct vgic_irq *irq;
> +	struct kvm_vcpu *vcpu = NULL;
> +
> +	if (iter->dist_id == 0) {
> +		print_dist_state(s, &kvm->arch.vgic);
> +		return 0;
> +	}
> +
> +	if (!kvm->arch.vgic.initialized)
> +		return 0;
> +
> +	if (iter->vcpu_id < iter->nr_cpus) {
> +		vcpu = kvm_get_vcpu(kvm, iter->vcpu_id);
> +		irq = &vcpu->arch.vgic_cpu.private_irqs[iter->intid];
> +	} else {
> +		irq = &kvm->arch.vgic.spis[iter->intid - VGIC_NR_PRIVATE_IRQS];
> +	}
> +
> +	spin_lock(&irq->irq_lock);
> +	print_irq_state(s, irq, vcpu);
> +	spin_unlock(&irq->irq_lock);
> +
> +	return 0;
> +}
> +
> +static struct seq_operations vgic_debug_seq_ops = {
> +	.start = vgic_debug_start,
> +	.next  = vgic_debug_next,
> +	.stop  = vgic_debug_stop,
> +	.show  = vgic_debug_show
> +};
> +
> +static int debug_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +	ret = seq_open(file, &vgic_debug_seq_ops);
> +	if (!ret) {
> +		struct seq_file *seq;
> +		/* seq_open will have modified file->private_data */
> +		seq = file->private_data;
> +		seq->private = inode->i_private;
> +	}
> +
> +	return ret;
> +};
> +
> +static struct file_operations vgic_debug_fops = {
> +	.owner   = THIS_MODULE,
> +	.open    = debug_open,
> +	.read    = seq_read,
> +	.llseek  = seq_lseek,
> +	.release = seq_release
> +};
> +
> +int vgic_debug_init(struct kvm *kvm)
> +{
> +	if (!kvm->debugfs_dentry)
> +		return -ENOENT;
> +
> +	if (!debugfs_create_file("vgic-state", 0444,
> +				 kvm->debugfs_dentry,
> +				 kvm,
> +				 &vgic_debug_fops))
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +int vgic_debug_destroy(struct kvm *kvm)
> +{
> +	return 0;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index c737ea0..276139a 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -259,6 +259,8 @@ int vgic_init(struct kvm *kvm)
>  	if (ret)
>  		goto out;
>  
> +	vgic_debug_init(kvm);
> +
>  	dist->initialized = true;
>  out:
>  	return ret;
> @@ -288,6 +290,8 @@ static void __kvm_vgic_destroy(struct kvm *kvm)
>  	struct kvm_vcpu *vcpu;
>  	int i;
>  
> +	vgic_debug_destroy(kvm);
> +
>  	kvm_vgic_dist_destroy(kvm);
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm)
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index b2cf34b..48da1f6 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -102,4 +102,7 @@ int kvm_register_vgic_device(unsigned long type);
>  int vgic_lazy_init(struct kvm *kvm);
>  int vgic_init(struct kvm *kvm);
>  
> +int vgic_debug_init(struct kvm *kvm);
> +int vgic_debug_destroy(struct kvm *kvm);
> +
>  #endif
> 
