Return-Path: <SRS0=1Ej7=XV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CEBC4360C
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 15:00:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86D2E21D6C
	for <kvmarm@archiver.kernel.org>; Thu, 26 Sep 2019 15:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86D2E21D6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFF624A6EB;
	Thu, 26 Sep 2019 10:59:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id miEQTipnJI1k; Thu, 26 Sep 2019 10:59:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E004A6F8;
	Thu, 26 Sep 2019 10:59:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D7814A6EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 10:59:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IyIAS+2JQaDt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Sep 2019 10:59:55 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 879674A6EA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Sep 2019 10:59:53 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 3F525EDEDF2B5DFC0E8C;
 Thu, 26 Sep 2019 22:59:45 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Thu, 26 Sep 2019
 22:59:34 +0800
Subject: Re: [PATCH 03/35] irqchip/gic-v3-its: Allow LPI invalidation via the
 DirectLPI interface
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-4-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <92ff82ca-ebcb-8f5f-5063-313f65bbc5e3@huawei.com>
Date: Thu, 26 Sep 2019 22:57:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190923182606.32100-4-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>
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

I get one kernel panic with this patch on D05.

(I don't have the GICv4.1 board at the moment. I have to wait for the
  appropriate HW to do more tests.)

On 2019/9/24 2:25, Marc Zyngier wrote:
> We currently don't make much use of the DirectLPI feature, and it would
> be beneficial to do this more, if only because it becomes a mandatory
> feature for GICv4.1.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 51 +++++++++++++++++++++++---------
>   1 file changed, 37 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 58cb233cf138..c94eb287393b 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -175,6 +175,12 @@ static DEFINE_IDA(its_vpeid_ida);
>   #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>   #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
>   
> +static inline u32 its_get_event_id(struct irq_data *d)
> +{
> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +	return d->hwirq - its_dev->event_map.lpi_base;
> +}
> +
>   static struct its_collection *dev_event_to_col(struct its_device *its_dev,
>   					       u32 event)
>   {
> @@ -183,6 +189,13 @@ static struct its_collection *dev_event_to_col(struct its_device *its_dev,
>   	return its->collections + its_dev->event_map.col_map[event];
>   }
>   
> +static struct its_collection *irq_to_col(struct irq_data *d)
> +{
> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +
> +	return dev_event_to_col(its_dev, its_get_event_id(d));
> +}
> +

irq_to_col uses device's event_map and col_map to get the target
collection, yes it works well with device's LPI.
But direct_lpi_inv also pass doorbells to it...

We don't allocate doorbells for any devices, instead for each vPE.

And see below,

>   static struct its_collection *valid_col(struct its_collection *col)
>   {
>   	if (WARN_ON_ONCE(col->target_address & GENMASK_ULL(15, 0)))
> @@ -1031,12 +1044,6 @@ static void its_send_vinvall(struct its_node *its, struct its_vpe *vpe)
>    * irqchip functions - assumes MSI, mostly.
>    */
>   
> -static inline u32 its_get_event_id(struct irq_data *d)
> -{
> -	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> -	return d->hwirq - its_dev->event_map.lpi_base;
> -}
> -
>   static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
>   {
>   	irq_hw_number_t hwirq;
> @@ -1081,12 +1088,28 @@ static void wait_for_syncr(void __iomem *rdbase)
>   		cpu_relax();
>   }
>   
> +static void direct_lpi_inv(struct irq_data *d)
> +{
> +	struct its_collection *col;
> +	void __iomem *rdbase;
> +
> +	/* Target the redistributor this LPI is currently routed to */
> +	col = irq_to_col(d);
> +	rdbase = per_cpu_ptr(gic_rdists->rdist, col->col_id)->rd_base;
> +	gic_write_lpir(d->hwirq, rdbase + GICR_INVLPIR);
> +
> +	wait_for_syncr(rdbase);
> +}
> +
>   static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
>   {
>   	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>   
>   	lpi_write_config(d, clr, set);
> -	its_send_inv(its_dev, its_get_event_id(d));
> +	if (gic_rdists->has_direct_lpi && !irqd_is_forwarded_to_vcpu(d))
> +		direct_lpi_inv(d);
> +	else
> +		its_send_inv(its_dev, its_get_event_id(d));
>   }
>   
>   static void its_vlpi_set_doorbell(struct irq_data *d, bool enable)
> @@ -2912,15 +2935,15 @@ static void its_vpe_send_cmd(struct its_vpe *vpe,
>   
>   static void its_vpe_send_inv(struct irq_data *d)
>   {
> -	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> -
>   	if (gic_rdists->has_direct_lpi) {
> -		void __iomem *rdbase;
> -
> -		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
> -		gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_INVLPIR);
> -		wait_for_syncr(rdbase);
> +		/*
> +		 * Don't mess about. Generating the invalidation is easily
> +		 * done by using the parent irq_data, just like below.
> +		 */
> +		direct_lpi_inv(d->parent_data);

"GICv4-vpe"'s parent is "GICv3", not "ITS".  What do we expect with
irq_data_get_irq_chip_data(parent's irq_data)?

I noticed it when running this series on D05 (with GICv4.0 and DirectLPI
support), panic call trace attached below.
I think we really need a fix here.


Thanks,
zenghui

>   	} else {
> +		struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +
>   		its_vpe_send_cmd(vpe, its_send_inv);
>   	}
>   }
> 

---8<

[ 2046.193227] Unable to handle kernel paging request at virtual address 
0000002045fa4d92
[ 2046.201350] Mem abort info:
[ 2046.204132]   ESR = 0x96000005
[ 2046.207174]   Exception class = DABT (current EL), IL = 32 bits
[ 2046.213081]   SET = 0, FnV = 0
[ 2046.216123]   EA = 0, S1PTW = 0
[ 2046.219251] Data abort info:
[ 2046.222119]   ISV = 0, ISS = 0x00000005
[ 2046.225942]   CM = 0, WnR = 0
[ 2046.228898] user pgtable: 4k pages, 48-bit VAs, pgdp=0000001fa85d7000
[ 2046.235326] [0000002045fa4d92] pgd=0000001fb185d003, pud=0000000000000000
[ 2046.242103] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[ 2046.247664] Modules linked in: openvswitch nsh nf_conncount nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter sunrpc vfat fat aes_ce_blk 
crypto_simd cryptd aesel vhost_net tun vhost tap ip_tables ext4 mbcache 
jbd2 sd_mod marvell hisi_sas_v2_hw hisi_sas_main ipmi_si libsas 
scsi_transport_sas hns_mdio hnae br_netfilter bridge dm_mod stp llc nvme 
nvme_core xt_sctp sctp libcrc32c nbd
[ 2046.307974] CPU: 3 PID: 15094 Comm: CPU 0/KVM Kdump: loaded Not 
tainted 5.3.0gic-v4.1-devel+ #2
[ 2046.316658] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58 
10/29/2018
[ 2046.323867] pstate: 60000085 (nZCv daIf -PAN -UAO)
[ 2046.328646] pc : direct_lpi_inv+0x7c/0xe0
[ 2046.332643] lr : its_vpe_send_inv.isra.24+0x50/0x60
[ 2046.337508] sp : ffff000034cab780
[ 2046.340810] x29: ffff000034cab780 x28: ffff000010e7c000
[ 2046.346110] x27: 0000000000000002 x26: ffff0000113718c0
[ 2046.351410] x25: ffff00001136f000 x24: ffff80af8a3f7420
[ 2046.356710] x23: 0000000000000001 x22: 0000000000000001
[ 2046.362010] x21: ffff80af95d96518 x20: ffff802fb78bf380
[ 2046.367309] x19: ffff80af95d96548 x18: 0000000000000000
[ 2046.372609] x17: 0000000000000000 x16: 0000000000000000
[ 2046.377908] x15: 0000000000000000 x14: 0000000000000000
[ 2046.383207] x13: 0000000000000000 x12: 0000000000000088
[ 2046.388506] x11: 0000000000000002 x10: ffff00001156a000
[ 2046.393805] x9 : 0000000000000000 x8 : ffff00001136f848
[ 2046.399105] x7 : ffff00001018c6a8 x6 : 0000001fba060000
[ 2046.404405] x5 : ffff000012c40000 x4 : 0000000045fa26c9
[ 2046.409704] x3 : ffff801fbb429800 x2 : 00000000000026c9
[ 2046.415004] x1 : ffff00001136f8a8 x0 : ffff000012163000
[ 2046.420303] Call trace:
[ 2046.422739]  direct_lpi_inv+0x7c/0xe0
[ 2046.426388]  its_vpe_send_inv.isra.24+0x50/0x60
[ 2046.430906]  its_vpe_unmask_irq+0x34/0x40
[ 2046.434904]  unmask_irq.part.5+0x30/0x50
[ 2046.438814]  irq_enable+0x78/0x98
[ 2046.442116]  __irq_startup+0x88/0x90
[ 2046.445680]  irq_startup+0x7c/0x140
[ 2046.449156]  __enable_irq+0x80/0x90
[ 2046.452632]  enable_irq+0x58/0xb0
[ 2046.455934]  its_make_vpe_non_resident+0xf0/0x108
[ 2046.460626]  vgic_v4_put+0x64/0x70
[ 2046.464015]  kvm_arch_vcpu_blocking+0x34/0x68
[ 2046.468360]  kvm_vcpu_block+0x50/0x598
[ 2046.472097]  kvm_handle_wfx+0x118/0x3d8
[ 2046.475920]  handle_exit+0x14c/0x1c8
[ 2046.479484]  kvm_arch_vcpu_ioctl_run+0x338/0xab8
[ 2046.484088]  kvm_vcpu_ioctl+0x3c8/0xa60
[ 2046.487912]  do_vfs_ioctl+0xc4/0x7f0
[ 2046.491475]  ksys_ioctl+0x8c/0xa0
[ 2046.494778]  __arm64_sys_ioctl+0x28/0x38
[ 2046.498689]  el0_svc_common.constprop.0+0x80/0x1b8
[ 2046.503467]  el0_svc_handler+0x34/0x90
[ 2046.507204]  el0_svc+0x8/0xc
[ 2046.510076] Code: d0006f41 f940d865 9122a021 d000dee0 (786478c3)
[ 2046.516158] ---[ end trace f6392171e61487dc ]---
[ 2046.520763] Kernel panic - not syncing: Fatal exception
[ 2046.525976] SMP: stopping secondary CPUs
[ 2046.529913] Kernel Offset: disabled
[ 2046.533391] CPU features: 0x0002,20006008
[ 2046.537387] Memory Limit: none


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
