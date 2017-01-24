From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Add debugfs vgic-state file
Date: Tue, 24 Jan 2017 10:23:57 +0000
Message-ID: <524751ae-8e17-f9a0-88c6-95d4614478af@arm.com>
References: <20170120103330.13858-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 669CD4098B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 05:22:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ipGZKPwILijM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Jan 2017 05:22:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8641640194
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 05:22:32 -0500 (EST)
In-Reply-To: <20170120103330.13858-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

so I gave this patch (adapted to live without the soft_pending state)
some testing on my machines (Midway, Juno, GICv3 ITS h/w) and it seemed
to work well - at least if one is nice and starts only one process
accessing vgic-state (see below). I caught some IRQs red-handed and the
output looked plausible.
The only comment I have is that "MPIDR" is a misleading header name for
that column. It's actually a union with the GICv2 targets field, which
is a bitmask of the targetting VCPUs. So the output looks more like a
bitmask and not an MPIDR on many machines. But that's just cosmetic.

Just discovered one thing: As soon as a second task is reading the file
(with "while [ 1 ]; do cat vgic-state > /dev/null; done &" in the
background, for instance), I get this splat on the host:

[60796.007461] Unable to handle kernel NULL pointer dereference at
virtual address 00000008
[60796.015538] pgd = ffff800974e30000
[60796.018952] [00000008] *pgd=00000009f4d0a003[60796.023067] Internal
error: Oops: 96000006 [#1] PREEMPT SMP
[60796.028588] Modules linked in:
[60796.031626] CPU: 3 PID: 5690 Comm: cat Tainted: G        W
4.9.0-00026-ge24503e-dirty #444
[60796.040326] Hardware name: ARM Juno development board (r0) (DT)
[60796.046190] task: ffff80097231ab00 task.stack: ffff800973894000
[60796.052059] PC is at iter_next+0x18/0x80
[60796.055946] LR is at debug_next+0x38/0x90
[60796.059917] pc : [<ffff0000080c4b38>] lr : [<ffff0000080c4bd8>]
pstate: 20000145
[60796.067240] sp : ffff800973897cc0
[60796.070522] x29: ffff800973897cc0 x28: ffff800973897d60
[60796.075805] x27: 0000000033c61000 x26: ffff800974e4dd40
[60796.081086] x25: 0000000000010000 x24: ffff800974da6380
[60796.086360] x23: ffff800973897eb8 x22: 0000000000000000
[60796.091634] x21: 0000000000000459 x20: ffff800973897d68
[60796.096908] x19: 0000000000000000 x18: 0000000000000001
[60796.102181] x17: 000000000041a1c8 x16: ffff000008275258
[60796.107456] x15: ffff800975546457 x14: 0000ffffa3912a94
[60796.112730] x13: 0000000000000000 x12: 0000000005f5e0ff
[60796.118004] x11: 0000000000000000 x10: 000000000000000c
[60796.123282] x9 : 000000000000000f x8 : ffff800973897b08
[60796.128555] x7 : 0000000000000004 x6 : ffff800975546459
[60796.133829] x5 : 0000000000000001 x4 : 0000000000000001
[60796.139103] x3 : ffff0000080c4ba0 x2 : ffff800973897d68
[60796.144377] x1 : ffff800972074000 x0 : ffff0000080c4bd8
[60796.149650]
[60796.151128] Process cat (pid: 5690, stack limit = 0xffff800973894020)
[60796.157508] Stack: (0xffff800973897cc0 to 0xffff800973898000)
[60796.163203] 7cc0: ffff800973897ce0 ffff0000080c4bd8 0000000000000000
ffff800974fc9a00
[60796.170962] 7ce0: ffff800973897d00 ffff0000082a14d0 ffff800974e4dd00
ffff800974fc9a00
[60796.178721] 7d00: ffff800973897d70 ffff000008415410 0000000000000000
ffff800974da6380
[60796.186479] 7d20: 0000000033c61000 0000000000010000 ffff800973897eb8
ffff0000090bc1a8
[60796.194237] 7d40: 0000000000000123 000000000000003f ffff000008b12000
ffff800973894000
[60796.201995] 7d60: 000000000000000d 000000000000000e ffff800973897dc0
ffff000008272d88
[60796.209753] 7d80: ffff800974da6380 ffff800973897eb8 0000000000010000
0000000033c61000
[60796.217514] 7da0: 0000000060000000 0000000000000015 0000000000000000
0000000100000000
[60796.225277] 7dc0: ffff800973897e50 ffff000008273d00 0000000000010000
ffff800974da6380
[60796.233035] 7de0: 0000000033c61000 ffff800973897eb8 ffff800973897e20
ffff000008273be8
[60796.240794] 7e00: ffff800974da6380 0000000000010000 0000000000000000
ffff800973897eb8
[60796.248552] 7e20: ffff800973897e50 ffff000008273cdc 0000000000010000
ffff800974da6380
[60796.256310] 7e40: 0000000033c61000 ffff800973897eb8 ffff800973897e80
ffff0000082752ac
[60796.264069] 7e60: ffff800974da6380 ffff800974da6380 0000000033c61000
0000000000010000
[60796.271830] 7e80: 0000000000000000 ffff0000080836f0 0000000000000000
000000000041a310
[60796.279588] 7ea0: ffffffffffffffff 0000ffffa39cd45c 0000000000000123
0000000000000000
[60796.287346] 7ec0: 0000000000000003 0000000033c61000 0000000000010000
0000000000000000
[60796.295103] 7ee0: 0000000000011011 0000000000000001 0000000000000011
0000000000000002
[60796.302861] 7f00: 000000000000003f 1f3c201f7372686b 00000000ffffffff
0000000000000030
[60796.310618] 7f20: 0000000000000038 0000000000000000 0000ffffa3912a94
0000ffffa3a47588
[60796.318376] 7f40: 0000000000000000 000000000041a1c8 0000ffffe30bd910
0000000000010000
[60796.326133] 7f60: 000000000041a310 0000000033c61000 0000000000000003
000000007fffe000
[60796.333891] 7f80: 00000000004088d0 0000000000000000 0000000000000000
0000000000000000
[60796.341649] 7fa0: 0000000000010000 0000ffffe30bdbb0 0000000000404dcc
0000ffffe30bdbb0
[60796.349407] 7fc0: 0000ffffa39cd45c 0000000060000000 0000000000000003
000000000000003f
[60796.357164] 7fe0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[60796.364917] Call trace:
[60796.367342] Exception stack(0xffff800973897af0 to 0xffff800973897c20)
[60796.373729] 7ae0:                                   0000000000000000
0001000000000000
[60796.381492] 7b00: ffff800973897cc0 ffff0000080c4b38 ffff800973897b20
ffff000008de460f
[60796.389251] 7b20: ffff800973897ba0 ffff0000082a1a38 ffff800974e4dd00
ffff800973897c10
[60796.397009] 7b40: ffff000008de45d0 ffff800972234dc0 ffff800973897eb8
ffff800974da6380
[60796.404767] 7b60: 0000000000010000 ffff800974e4dd40 0000000033c61000
ffff800973897d60
[60796.412529] 7b80: 0000000000000002 ffff000008b633c8 ffff0000080c4bd8
ffff800972074000
[60796.420287] 7ba0: ffff800973897d68 ffff0000080c4ba0 0000000000000001
0000000000000001
[60796.428045] 7bc0: ffff800975546459 0000000000000004 ffff800973897b08
000000000000000f
[60796.435802] 7be0: 000000000000000c 0000000000000000 0000000005f5e0ff
0000000000000000
[60796.443560] 7c00: 0000ffffa3912a94 ffff800975546457 ffff000008275258
000000000041a1c8
[60796.451320] [<ffff0000080c4b38>] iter_next+0x18/0x80
[60796.456239] [<ffff0000080c4bd8>] debug_next+0x38/0x90
[60796.461247] [<ffff0000082a14d0>] seq_read+0x310/0x420
[60796.466256] [<ffff000008415410>] full_proxy_read+0x60/0x88
[60796.471693] [<ffff000008272d88>] __vfs_read+0x48/0x130
[60796.476784] [<ffff000008273d00>] vfs_read+0x88/0x140
[60796.481703] [<ffff0000082752ac>] SyS_read+0x54/0xb0
[60796.486538] [<ffff0000080836f0>] el0_svc_naked+0x24/0x28
[60796.491804] Code: f9000bf3 aa0003f3 aa1e03e0 d503201f (b9400a60)
[60796.498076] ---[ end trace 31bfd09d844bbfc9 ]---

As I didn't understand the seq_* semantics in the first place, I didn't
have a look yet what could cause this.

Cheers,
Andre.

On 20/01/17 10:33, Christoffer Dall wrote:
> Add a file to debugfs to read the in-kernel state of the vgic.  We don't
> do any locking of the entire VGIC state while traversing all the IRQs,
> so if the VM is running the user/developer may not see a quiesced state,
> but should take care to pause the VM using facilities in user space for
> that purpose.
> 
> We also don't support LPIs yet, but they can be added easily if needed.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/kvm/Makefile          |   1 +
>  arch/arm64/kvm/Makefile        |   1 +
>  include/kvm/arm_vgic.h         |   5 +
>  virt/kvm/arm/vgic/vgic-debug.c | 278 +++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-init.c  |   4 +
>  virt/kvm/arm/vgic/vgic.h       |   3 +
>  6 files changed, 292 insertions(+)
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
> index 002f092..1087aee 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -165,6 +165,8 @@ struct vgic_its {
>  	struct list_head	collection_list;
>  };
>  
> +struct vgic_state_iter;
> +
>  struct vgic_dist {
>  	bool			in_kernel;
>  	bool			ready;
> @@ -212,6 +214,9 @@ struct vgic_dist {
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
> index 0000000..76e8b11
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-debug.c
> @@ -0,0 +1,278 @@
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
> +static bool the_end(struct vgic_state_iter *iter)
> +{
> +	return iter->dist_id > 0 &&
> +		iter->vcpu_id == iter->nr_cpus &&
> +		(iter->intid - VGIC_NR_PRIVATE_IRQS) == iter->nr_spis;
> +}
> +
> +static void *debug_start(struct seq_file *s, loff_t *pos)
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
> +	if (the_end(iter))
> +		iter = NULL;
> +out:
> +	mutex_unlock(&kvm->lock);
> +	return iter;
> +}
> +
> +static void *debug_next(struct seq_file *s, void *v, loff_t *pos)
> +{
> +	struct kvm *kvm = (struct kvm *)s->private;
> +	struct vgic_state_iter *iter = kvm->arch.vgic.iter;
> +
> +	++*pos;
> +	iter_next(iter);
> +	if (the_end(iter))
> +		iter = NULL;
> +	return iter;
> +}
> +
> +static void debug_stop(struct seq_file *s, void *v)
> +{
> +	struct kvm *kvm = (struct kvm *)s->private;
> +	struct vgic_state_iter *iter;
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
> +	seq_printf(s, "%s%2d TYP   ID TGT_ID PLSAEHL     HWID    MPIDR SRC PRI VCPU_ID\n", hdr, id);
> +	seq_printf(s, "----------------------------------------------------------------\n");
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
> +		      "%d%d%d%d%d%d%d "
> +		      "%8x "
> +		      "%8x "
> +		      " %2x "
> +		      " %2x "
> +		      "     %2d "
> +		      "\n",
> +			type, irq->intid,
> +			(irq->target_vcpu) ? irq->target_vcpu->vcpu_id : -1,
> +			irq->pending,
> +			irq->line_level,
> +			irq->soft_pending,
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
> +static int debug_show(struct seq_file *s, void *v)
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
> +static struct seq_operations debug_seq_ops = {
> +	.start = debug_start,
> +	.next  = debug_next,
> +	.stop  = debug_stop,
> +	.show  = debug_show
> +};
> +
> +static int debug_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +	ret = seq_open(file, &debug_seq_ops);
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
> index 5114391..cf8e812 100644
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
> @@ -291,6 +293,8 @@ void kvm_vgic_destroy(struct kvm *kvm)
>  	struct kvm_vcpu *vcpu;
>  	int i;
>  
> +	vgic_debug_destroy(kvm);
> +
>  	kvm_vgic_dist_destroy(kvm);
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm)
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 859f65c..bbcbdbb 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -94,4 +94,7 @@ int kvm_register_vgic_device(unsigned long type);
>  int vgic_lazy_init(struct kvm *kvm);
>  int vgic_init(struct kvm *kvm);
>  
> +int vgic_debug_init(struct kvm *kvm);
> +int vgic_debug_destroy(struct kvm *kvm);
> +
>  #endif
> 
