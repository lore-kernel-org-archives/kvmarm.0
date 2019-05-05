Return-Path: <SRS0=Skfd=TF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBBEC004C9
	for <kvmarm@archiver.kernel.org>; Sun,  5 May 2019 11:07:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6AEE82087F
	for <kvmarm@archiver.kernel.org>; Sun,  5 May 2019 11:07:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AEE82087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF36B4A4CA;
	Sun,  5 May 2019 07:07:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8deEjZrMnJfC; Sun,  5 May 2019 07:07:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FF1B4A4A3;
	Sun,  5 May 2019 07:07:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 555364A3A5
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 May 2019 07:07:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lZMDVHTbK0sG for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 May 2019 07:07:14 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BAA04A331
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 May 2019 07:07:14 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 526279D4F40EBE4B8746;
 Sun,  5 May 2019 19:07:10 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.55) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Sun, 5 May 2019
 19:07:02 +0800
Subject: Re: ARM/gic-v4: deadlock occurred
To: Marc Zyngier <marc.zyngier@arm.com>
References: <9efe0260-4a84-7489-ecdd-2e9561599320@huawei.com>
 <86lfzl9ofe.wl-marc.zyngier@arm.com>
From: Heyi Guo <guoheyi@huawei.com>
Message-ID: <0b413592-7d98-ebe8-35c5-da330f800326@huawei.com>
Date: Sun, 5 May 2019 19:07:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <86lfzl9ofe.wl-marc.zyngier@arm.com>
X-Originating-IP: [10.177.31.55]
X-CFilter-Loop: Reflected
Cc: linux-kernel@vger.kernel.org, kvmarm <kvmarm@lists.cs.columbia.edu>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

Appreciate your quick patch :) We'll test it and let you know the result.

Heyi


On 2019/5/5 18:38, Marc Zyngier wrote:
> [+ kvmarm]
>
> Hi Heyi,
>
> On Sun, 05 May 2019 03:26:18 +0100,
> Heyi Guo <guoheyi@huawei.com> wrote:
>> Hi folks,
>>
>> We observed deadlocks after enabling GICv4 and PCI passthrough on
>> ARM64 virtual machines, when not pinning VCPU to physical CPU.
>>
>> We observed below warnings after enabling lockdep debug in kernel:
>>
>> [  362.847021] =====================================================
>> [  362.855643] WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
>> [  362.864840] 4.19.34+ #7 Tainted: G        W
>> [  362.872314] -----------------------------------------------------
>> [  362.881034] CPU 0/KVM/51468 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
>> [  362.890504] 00000000659c1dc9 (fs_reclaim){+.+.}, at: fs_reclaim_acquire.part.22+0x0/0x48
>> [  362.901413]
>> [  362.901413] and this task is already holding:
>> [  362.912976] 000000007318873f (&dev->event_map.vlpi_lock){....}, at: its_irq_set_vcpu_affinity+0x134/0x638
>> [  362.928626] which would create a new lock dependency:
>> [  362.936837]  (&dev->event_map.vlpi_lock){....} -> (fs_reclaim){+.+.}
>> [  362.946449]
>> [  362.946449] but this new dependency connects a HARDIRQ-irq-safe lock:
>> [  362.960877]  (&irq_desc_lock_class){-.-.}
>> [  362.960880]
>> [  362.960880] ... which became HARDIRQ-irq-safe at:
>> [  362.981234]   lock_acquire+0xf0/0x258
>> [  362.988337]   _raw_spin_lock+0x54/0x90
>> [  362.995543]   handle_fasteoi_irq+0x2c/0x198
>> [  363.003205]   generic_handle_irq+0x34/0x50
>> [  363.010787]   __handle_domain_irq+0x68/0xc0
>> [  363.018500]   gic_handle_irq+0xf4/0x1e0
>> [  363.025913]   el1_irq+0xc8/0x180
>> [  363.032683]   _raw_spin_unlock_irq+0x40/0x60
>> [  363.040512]   finish_task_switch+0x98/0x258
>> [  363.048254]   __schedule+0x350/0xca8
>> [  363.055359]   schedule+0x40/0xa8
>> [  363.062098]   worker_thread+0xd8/0x410
>> [  363.069340]   kthread+0x134/0x138
>> [  363.076070]   ret_from_fork+0x10/0x18
>> [  363.083111]
>> [  363.083111] to a HARDIRQ-irq-unsafe lock:
>> [  363.095213]  (fs_reclaim){+.+.}
>> [  363.095216]
>> [  363.095216] ... which became HARDIRQ-irq-unsafe at:
>> [  363.114527] ...
>> [  363.114530]   lock_acquire+0xf0/0x258
>> [  363.126269]   fs_reclaim_acquire.part.22+0x3c/0x48
>> [  363.134206]   fs_reclaim_acquire+0x2c/0x38
>> [  363.141363]   kmem_cache_alloc_trace+0x44/0x368
>> [  363.148892]   acpi_os_map_iomem+0x9c/0x208
>> [  363.155934]   acpi_os_map_memory+0x28/0x38
>> [  363.162831]   acpi_tb_acquire_table+0x58/0x8c
>> [  363.170021]   acpi_tb_validate_table+0x34/0x58
>> [  363.177162]   acpi_tb_get_table+0x4c/0x90
>> [  363.183741]   acpi_get_table+0x94/0xc4
>> [  363.190020]   find_acpi_cpu_topology_tag+0x54/0x240
>> [  363.197404]   find_acpi_cpu_topology_package+0x28/0x38
>> [  363.204985]   init_cpu_topology+0xdc/0x1e4
>> [  363.211498]   smp_prepare_cpus+0x2c/0x108
>> [  363.217882]   kernel_init_freeable+0x130/0x508
>> [  363.224699]   kernel_init+0x18/0x118
>> [  363.230624]   ret_from_fork+0x10/0x18
>> [  363.236611]
>> [  363.236611] other info that might help us debug this:
>> [  363.236611]
>> [  363.251604] Chain exists of:
>> [  363.251604]   &irq_desc_lock_class --> &dev->event_map.vlpi_lock --> fs_reclaim
>> [  363.251604]
>> [  363.270508]  Possible interrupt unsafe locking scenario:
>> [  363.270508]
>> [  363.282238]        CPU0                    CPU1
>> [  363.289228]        ----                    ----
>> [  363.296189]   lock(fs_reclaim);
>> [  363.301726]                                local_irq_disable();
>> [  363.310122] lock(&irq_desc_lock_class);
>> [  363.319143] lock(&dev->event_map.vlpi_lock);
>> [  363.328617]   <Interrupt>
>> [  363.333713]     lock(&irq_desc_lock_class);
>> [  363.340414]
>> [  363.340414]  *** DEADLOCK ***
>> [  363.340414]
>> [  363.353682] 5 locks held by CPU 0/KVM/51468:
>> [  363.360412]  #0: 00000000eeb852a5 (&vdev->igate){+.+.}, at: vfio_pci_ioctl+0x2f8/0xed0
>> [  363.370915]  #1: 000000002ab491f7 (lock#9){+.+.}, at: irq_bypass_register_producer+0x6c/0x1d0
>> [  363.382139]  #2: 000000000d9fd5c6 (&its->its_lock){+.+.}, at: kvm_vgic_v4_set_forwarding+0xd0/0x188
>> [  363.396625]  #3: 00000000232bdc47 (&irq_desc_lock_class){-.-.}, at: __irq_get_desc_lock+0x60/0xa0
>> [  363.408486]  #4: 000000007318873f (&dev->event_map.vlpi_lock){....}, at: its_irq_set_vcpu_affinity+0x134/0x638
>>
>>
>> Then we found that irq_set_vcpu_affinity() in kernel/irq/manage.c
>> aquires an antomic context by irq_get_desc_lock() at the beginning,
>> but in its_irq_set_vcpu_affinity()
>> (drivers/irqchip/irq-gic-v3-its.c) we are still using mutext_lock,
>> kcalloc, kfree, etc, which we think should be forbidden in atomic
>> context.
>>
>> Though the issue is observed in 4.19.34, we don't find any related
>> fixes in the mainline yet.
> Thanks for the report. Given that you're the only users of GICv4,
> you're bound to find a number of these issues.
>
> Can you try the patch below and let me know whether it helps? This is
> the simplest thing I can think off to paper over the issue, but is
> isn't pretty, and I'm looking at possible alternatives (ideally, we'd
> be able to allocate the map outside of the irqdesc lock, but this
> requires some API change between KVM, the GICv4 layer and the ITS
> code).
>
> Note that I'm travelling for the next two weeks without access to my
> test rig, so I'm relying on you to test this stuff.
>
> Thanks,
>
> 	M.
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 7577755bdcf4..18aa04b6a9f4 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -142,7 +142,7 @@ struct event_lpi_map {
>   	u16			*col_map;
>   	irq_hw_number_t		lpi_base;
>   	int			nr_lpis;
> -	struct mutex		vlpi_lock;
> +	raw_spinlock_t		vlpi_lock;
>   	struct its_vm		*vm;
>   	struct its_vlpi_map	*vlpi_maps;
>   	int			nr_vlpis;
> @@ -1263,13 +1263,13 @@ static int its_vlpi_map(struct irq_data *d, struct its_cmd_info *info)
>   	if (!info->map)
>   		return -EINVAL;
>   
> -	mutex_lock(&its_dev->event_map.vlpi_lock);
> +	raw_spin_lock(&its_dev->event_map.vlpi_lock);
>   
>   	if (!its_dev->event_map.vm) {
>   		struct its_vlpi_map *maps;
>   
>   		maps = kcalloc(its_dev->event_map.nr_lpis, sizeof(*maps),
> -			       GFP_KERNEL);
> +			       GFP_ATOMIC);
>   		if (!maps) {
>   			ret = -ENOMEM;
>   			goto out;
> @@ -1312,7 +1312,7 @@ static int its_vlpi_map(struct irq_data *d, struct its_cmd_info *info)
>   	}
>   
>   out:
> -	mutex_unlock(&its_dev->event_map.vlpi_lock);
> +	raw_spin_unlock(&its_dev->event_map.vlpi_lock);
>   	return ret;
>   }
>   
> @@ -1322,7 +1322,7 @@ static int its_vlpi_get(struct irq_data *d, struct its_cmd_info *info)
>   	u32 event = its_get_event_id(d);
>   	int ret = 0;
>   
> -	mutex_lock(&its_dev->event_map.vlpi_lock);
> +	raw_spin_lock(&its_dev->event_map.vlpi_lock);
>   
>   	if (!its_dev->event_map.vm ||
>   	    !its_dev->event_map.vlpi_maps[event].vm) {
> @@ -1334,7 +1334,7 @@ static int its_vlpi_get(struct irq_data *d, struct its_cmd_info *info)
>   	*info->map = its_dev->event_map.vlpi_maps[event];
>   
>   out:
> -	mutex_unlock(&its_dev->event_map.vlpi_lock);
> +	raw_spin_unlock(&its_dev->event_map.vlpi_lock);
>   	return ret;
>   }
>   
> @@ -1344,7 +1344,7 @@ static int its_vlpi_unmap(struct irq_data *d)
>   	u32 event = its_get_event_id(d);
>   	int ret = 0;
>   
> -	mutex_lock(&its_dev->event_map.vlpi_lock);
> +	raw_spin_lock(&its_dev->event_map.vlpi_lock);
>   
>   	if (!its_dev->event_map.vm || !irqd_is_forwarded_to_vcpu(d)) {
>   		ret = -EINVAL;
> @@ -1374,7 +1374,7 @@ static int its_vlpi_unmap(struct irq_data *d)
>   	}
>   
>   out:
> -	mutex_unlock(&its_dev->event_map.vlpi_lock);
> +	raw_spin_unlock(&its_dev->event_map.vlpi_lock);
>   	return ret;
>   }
>   
> @@ -2436,7 +2436,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
>   	dev->event_map.col_map = col_map;
>   	dev->event_map.lpi_base = lpi_base;
>   	dev->event_map.nr_lpis = nr_lpis;
> -	mutex_init(&dev->event_map.vlpi_lock);
> +	raw_spin_lock_init(&dev->event_map.vlpi_lock);
>   	dev->device_id = dev_id;
>   	INIT_LIST_HEAD(&dev->entry);
>   
>


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
