Return-Path: <SRS0=diMM=3E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7053C33C9E
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 02:49:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E513222C3
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 02:49:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E513222C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFF8D4B042;
	Tue, 14 Jan 2020 21:49:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FKihJCyCjcf7; Tue, 14 Jan 2020 21:49:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 758994B098;
	Tue, 14 Jan 2020 21:49:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BC7B4B042
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jan 2020 21:49:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ENzs7qmFNk6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jan 2020 21:49:43 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C6164A32E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jan 2020 21:49:43 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 03EB36A164696BC473C5;
 Wed, 15 Jan 2020 10:49:40 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 15 Jan 2020
 10:49:32 +0800
Subject: Re: [PATCH v3 29/32] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20191224111055.11836-1-maz@kernel.org>
 <20191224111055.11836-30-maz@kernel.org>
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <cc5fe20c-7a0c-c266-e78a-2a85963ab20f@hisilicon.com>
Date: Wed, 15 Jan 2020 10:49:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20191224111055.11836-30-maz@kernel.org>
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc, [This is from Nianyao]

On 2019/12/24 19:10, Marc Zyngier wrote:
> In order to let a guest buy in the new, active-less SGIs, we
> need to be able to switch between the two modes.
> 
> Handle this by stopping all guest activity, transfer the state
> from one mode to the other, and resume the guest.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/kvm/arm_vgic.h      |  3 ++
>  virt/kvm/arm/vgic/vgic-v3.c |  2 +
>  virt/kvm/arm/vgic/vgic-v4.c | 96 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h    |  1 +
>  4 files changed, 102 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 63457908c9c4..69f4164d6477 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -231,6 +231,9 @@ struct vgic_dist {
>  	/* distributor enabled */
>  	bool			enabled;
>  
> +	/* Wants SGIs without active state */
> +	bool			nassgireq;
> +
>  	struct vgic_irq		*spis;
>  
>  	struct vgic_io_device	dist_iodev;
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index c2fdea201747..c79a251c4974 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -540,6 +540,8 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  		goto out;
>  	}
>  
> +	if (kvm_vgic_global_state.has_gicv4_1)
> +		vgic_v4_configure_vsgis(kvm);
>  	dist->ready = true;
>  
>  out:
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index c2fcde104ea2..063785fd2dc7 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -97,6 +97,102 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
>  	return IRQ_HANDLED;
>  }
>  
> +static void vgic_v4_sync_sgi_config(struct its_vpe *vpe, struct vgic_irq *irq)
> +{
> +	vpe->sgi_config[irq->intid].enabled	= irq->enabled;
> +	vpe->sgi_config[irq->intid].group 	= irq->group;
> +	vpe->sgi_config[irq->intid].priority	= irq->priority;
> +}
> +
> +static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
> +{
> +	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
> +	int i;
> +
> +	/*
> +	 * With GICv4.1, every virtual SGI can be directly injected. So
> +	 * let's pretend that they are HW interrupts, tied to a host
> +	 * IRQ. The SGI code will do its magic.
> +	 */
> +	for (i = 0; i < VGIC_NR_SGIS; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
> +		struct irq_desc *desc;
> +		int ret;
> +
> +		if (irq->hw) {
> +			vgic_put_irq(vcpu->kvm, irq);
> +			continue;
> +		}
> +
> +		irq->hw = true;
> +		irq->host_irq = irq_find_mapping(vpe->sgi_domain, i);

I think we need to check whether irq_find_mapping returns 0.

> +		vgic_v4_sync_sgi_config(vpe, irq);
> +		/*
> +		 * SGIs are initialised as disabled. Enable them if
> +		 * required by the rest of the VGIC init code.
> +		 */
> +		desc = irq_to_desc(irq->host_irq);
> +		ret = irq_domain_activate_irq(irq_desc_get_irq_data(desc),
> +					      false);

If irq->host_irq is not valid , in irq_domain_activate_irq, it will trigger NULL pointer
dereference in host kernel.
I meet a problem here. When hw support GIC4.1, and host kernel is started with
kvm-arm.vgic_v4_enable=0, starting a virtual machine will trigger NULL pointer
dereference in host. The following is error info:

[    7.913815] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000038
[    7.913818] Mem abort info:
[    7.913819]   ESR = 0x96000007
[    7.913821]   EC = 0x25: DABT (current EL), IL = 32 bits
[    7.913823]   SET = 0, FnV = 0
[    7.913825]   EA = 0, S1PTW = 0
[    7.913827] Data abort info:
[    7.913828]   ISV = 0, ISS = 0x00000007
[    7.913830]   CM = 0, WnR = 0
[    7.913832] user pgtable: 64k pages, 48-bit VAs, pgdp=00000824405a0800
[    7.913835] [0000000000000038] pgd=0000082444120003, pud=0000082444120003, pmd=0000082444130003, pte=0000000000000000
[    7.913840] Internal error: Oops: 96000007 [#1] SMP
[    7.913842] Modules linked in:
[    7.913845] CPU: 1 PID: 1918 Comm: qemu-system-aar Tainted: G        W         5.5.0-rc2-14819-g4e11d8f-dirty #20
[    7.913849] pstate: 80400009 (Nzcv daif +PAN -UAO)
[    7.913852] pc : irq_domain_activate_irq+0x0/0x58
[    7.913854] lr : vgic_v4_configure_vsgis+0x108/0x208
[    7.913857] sp : ffff8000160af7b0
[    7.913858] x29: ffff8000160af7b0 x28: ffff082445030000
[    7.913861] x27: 0000000000000004 x26: ffff0824456032c8
[    7.913864] x25: 0000000000000000 x24: ffff8000118d1130
[    7.913868] x23: 0000000000000001 x22: ffff8000118d0000
[    7.913871] x21: 0000000000000000 x20: ffff082445602360
[    7.913874] x19: ffff082445603348 x18: 0000000000000010
[    7.913877] x17: 0000000000000050 x16: 0000000000000001
[    7.913880] x15: ffff8000110eb258 x14: ffffffffffffffff
[    7.913883] x13: ffff8000910cfb17 x12: ffff8000110cfb24
[    7.913886] x11: ffff8000110f8000 x10: 0000000000000040
[    7.913889] x9 : ffff8000110f8fe0 x8 : ffff8000110f8fd8
[    7.913892] x7 : ffff082420000270 x6 : 0000000000000000
[    7.913895] x5 : ffff082420000248 x4 : 0000000000000000
[    7.913898] x3 : 0000000000000000 x2 : 0000000000000000
[    7.913901] x1 : 0000000000000000 x0 : 0000000000000028
[    7.913904] Call trace:
[    7.913907]  irq_domain_activate_irq+0x0/0x58
[    7.913909]  vgic_mmio_write_v3_misc+0xf0/0x100
[    7.913912]  dispatch_mmio_write+0x78/0x100
[    7.913915]  __kvm_io_bus_write+0xbc/0xf8
[    7.913918]  kvm_io_bus_write+0x48/0x80
[    7.913921]  io_mem_abort+0x128/0x288
[    7.913924]  kvm_handle_guest_abort+0x2c0/0xe88
[    7.913927]  handle_exit+0x6c/0x1d8
[    7.913930]  kvm_arch_vcpu_ioctl_run+0x454/0x6e8
[    7.913932]  kvm_vcpu_ioctl+0x310/0x9e0
[    7.913935]  do_vfs_ioctl+0x604/0xbd0
[    7.913938]  ksys_ioctl+0x78/0xa8
[    7.913940]  __arm64_sys_ioctl+0x1c/0x28
[    7.913943]  el0_svc_handler+0x7c/0x188
[    7.913946]  el0_sync_handler+0x138/0x258
[    7.913948]  el0_sync+0x140/0x180
[    7.913952] Code: a8c87bfd d65f03c0 97fe9008 d503201f (f9400803)
[    7.913954] ---[ end trace e0d0e4b407d388f3 ]---

Thanks,

> +		if (!WARN_ON(ret)) {
> +			/* Transfer pending state */
> +			ret = irq_set_irqchip_state(irq->host_irq,
> +						    IRQCHIP_STATE_PENDING,
> +						    irq->pending_latch);
> +			WARN_ON(ret);
> +			irq->pending_latch = false;
> +		}
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +}
> +
> +static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +
> +	for (i = 0; i < VGIC_NR_SGIS; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
> +		struct irq_desc *desc;
> +		int ret;
> +
> +		if (!irq->hw) {
> +			vgic_put_irq(vcpu->kvm, irq);
> +			continue;
> +		}
> +
> +		irq->hw = false;
> +		ret = irq_get_irqchip_state(irq->host_irq,
> +					    IRQCHIP_STATE_PENDING,
> +					    &irq->pending_latch);
> +		WARN_ON(ret);
> +
> +		desc = irq_to_desc(irq->host_irq);
> +		irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +}
> +
> +/* Must be called with the kvm lock held */
> +void vgic_v4_configure_vsgis(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	kvm_arm_halt_guest(kvm);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (dist->nassgireq)
> +			vgic_v4_enable_vsgis(vcpu);
> +		else
> +			vgic_v4_disable_vsgis(vcpu);
> +	}
> +
> +	kvm_arm_resume_guest(kvm);
> +}
> +
>  /**
>   * vgic_v4_init - Initialize the GICv4 data structures
>   * @kvm:	Pointer to the VM being initialized
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index c7fefd6b1c80..769e4802645e 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -316,5 +316,6 @@ void vgic_its_invalidate_cache(struct kvm *kvm);
>  bool vgic_supports_direct_msis(struct kvm *kvm);
>  int vgic_v4_init(struct kvm *kvm);
>  void vgic_v4_teardown(struct kvm *kvm);
> +void vgic_v4_configure_vsgis(struct kvm *kvm);
>  
>  #endif
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
