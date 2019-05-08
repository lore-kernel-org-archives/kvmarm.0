Return-Path: <SRS0=Kjqu=TI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E90C04A6B
	for <kvmarm@archiver.kernel.org>; Wed,  8 May 2019 13:02:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C5A621019
	for <kvmarm@archiver.kernel.org>; Wed,  8 May 2019 13:02:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C5A621019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05C704A420;
	Wed,  8 May 2019 09:02:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CUZPJDM3mW5O; Wed,  8 May 2019 09:02:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B765D4A331;
	Wed,  8 May 2019 09:02:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E387C4A331
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 May 2019 09:02:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1m7HT1I3fIiX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 May 2019 09:01:59 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 611724A321
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 May 2019 09:01:59 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id AED76EAA47F7EB63A56A;
 Wed,  8 May 2019 21:01:55 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.55) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 May 2019
 21:01:49 +0800
Subject: Re: ARM/gic-v4: deadlock occurred
To: Marc Zyngier <marc.zyngier@arm.com>
References: <9efe0260-4a84-7489-ecdd-2e9561599320@huawei.com>
 <86lfzl9ofe.wl-marc.zyngier@arm.com>
 <0b413592-7d98-ebe8-35c5-da330f800326@huawei.com>
 <86a7fx9lg8.wl-marc.zyngier@arm.com>
From: Heyi Guo <guoheyi@huawei.com>
Message-ID: <4d60d130-b7ce-96cb-5f8a-11e83329601a@huawei.com>
Date: Wed, 8 May 2019 21:01:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <86a7fx9lg8.wl-marc.zyngier@arm.com>
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

The bad news is that though your previous patch fixed the lockdep warnings, we can still reproduce soft lockup panics and some other exceptions... So our issue may not be related with this lock defect.

Most of the call traces are as below, stuck in smp_call_function_many:

[ 6862.660611] watchdog: BUG: soft lockup - CPU#27 stuck for 23s! [CPU 18/KVM:95311]
[ 6862.668283] Modules linked in: ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter vport_vxlan vxlan ip6_udp_tunnel udp_tunnel openvswitch nsh nf_nat_ipv6 nf_nat_ipv4 nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib ib_umad rpcrdma sunrpc rdma_ucm ib_uverbs ib_iser rdma_cm iw_cm ib_cm hns_roce_hw_v2 hns_roce aes_ce_blk crypto_simd ib_core cryptd aes_ce_cipher crc32_ce ghash_ce sha2_ce sha256_arm64 sha1_ce marvell ses enclosure hibmc_drm ttm drm_kms_helper drm sg ixgbe mdio fb_sys_fops syscopyarea hns3 hclge sysfillrect hnae3 sysimgblt sbsa_gwdt vhost_net tun vhost tap ip_tables dm_mod megaraid_sas hisi_sas_v3_hw hisi_sas_main ipmi_si ipmi_devintf ipmi_msghandler br_netfilter xt_sctp
[ 6862.668519] irq event stamp: 1670812
[ 6862.668526] hardirqs last  enabled at (1670811): [<ffff000008083498>] el1_irq+0xd8/0x180
[ 6862.668530] hardirqs last disabled at (1670812): [<ffff000008083448>] el1_irq+0x88/0x180
[ 6862.668534] softirqs last  enabled at (1661542): [<ffff000008081d2c>] __do_softirq+0x41c/0x51c
[ 6862.668539] softirqs last disabled at (1661535): [<ffff0000080fafc4>] irq_exit+0x18c/0x198
[ 6862.668544] CPU: 27 PID: 95311 Comm: CPU 18/KVM Kdump: loaded Tainted: G        W         4.19.36-1.2.141.aarch64 #1
[ 6862.668548] Hardware name: Huawei TaiShan 2280 V2/BC82AMDA, BIOS TA BIOS TaiShan 2280 V2 - B900 01/29/2019
[ 6862.668551] pstate: 80400009 (Nzcv daif +PAN -UAO)
[ 6862.668557] pc : smp_call_function_many+0x360/0x3b8
[ 6862.668560] lr : smp_call_function_many+0x320/0x3b8
[ 6862.668563] sp : ffff000028f338e0
[ 6862.668566] x29: ffff000028f338e0 x28: ffff000009893fb4
[ 6862.668575] x27: 0000000000000400 x26: 0000000000000000
[ 6862.668583] x25: ffff0000080b1e08 x24: 0000000000000001
[ 6862.668591] x23: ffff000009891bc8 x22: ffff000009891bc8
[ 6862.668599] x21: ffff805f7d6da408 x20: ffff000009893fb4
[ 6862.668608] x19: ffff805f7d6da400 x18: 0000000000000000
[ 6862.668616] x17: 0000000000000000 x16: 0000000000000000
[ 6862.668624] x15: 0000000000000000 x14: 0000000000000000
[ 6862.668632] x13: 0000000000000040 x12: 0000000000000228
[ 6862.668640] x11: 0000000000000020 x10: 0000000000000040
[ 6862.668648] x9 : 0000000000000000 x8 : 0000000000000010
[ 6862.668656] x7 : 0000000000000000 x6 : ffff805f7d329660
[ 6862.668664] x5 : ffff000028f33850 x4 : 0000000002000402
[ 6862.668673] x3 : 0000000000000000 x2 : ffff803f7f3dc678
[ 6862.668681] x1 : 0000000000000003 x0 : 000000000000000a
[ 6862.668689] Call trace:
[ 6862.668693]  smp_call_function_many+0x360/0x3b8
[ 6862.668697]  kvm_make_vcpus_request_mask+0x1dc/0x240
[ 6862.668701]  kvm_make_all_cpus_request+0x70/0x98
[ 6862.668705]  kvm_arm_halt_guest+0x70/0x80
[ 6862.668708]  kvm_arch_irq_bypass_stop+0x24/0x30
[ 6862.668714]  __disconnect+0x3c/0x90
[ 6862.668718]  irq_bypass_unregister_producer+0xe0/0x138
[ 6862.668724]  vfio_msi_set_vector_signal+0x9c/0x2a8
[ 6862.668727]  vfio_msi_set_block+0x78/0x108
[ 6862.668730]  vfio_pci_set_msi_trigger+0x238/0x2e0
[ 6862.668734]  vfio_pci_set_irqs_ioctl+0xf8/0x140
[ 6862.668737]  vfio_pci_ioctl+0x30c/0xed0
[ 6862.668743]  vfio_device_fops_unl_ioctl+0x44/0x70
[ 6862.668748]  do_vfs_ioctl+0xc4/0x7f0
[ 6862.668752]  ksys_ioctl+0x8c/0xa0
[ 6862.668755]  __arm64_sys_ioctl+0x28/0x38
[ 6862.668760]  el0_svc_common+0xa0/0x190
[ 6862.668763]  el0_svc_handler+0x38/0x78
[ 6862.668767]  el0_svc+0x8/0xc
[ 6862.668771] Kernel panic - not syncing: softlockup: hung tasks
[ 6862.674729] CPU: 27 PID: 95311 Comm: CPU 18/KVM Kdump: loaded Tainted: G        W    L    4.19.36-1.2.141.aarch64 #1
[ 6862.685479] Hardware name: Huawei TaiShan 2280 V2/BC82AMDA, BIOS TA BIOS TaiShan 2280 V2 - B900 01/29/2019
[ 6862.695346] Call trace:
[ 6862.697831]  dump_backtrace+0x0/0x198
[ 6862.701562]  show_stack+0x24/0x30
[ 6862.704940]  dump_stack+0xd0/0x11c
[ 6862.708409]  panic+0x138/0x324
[ 6862.711521]  watchdog_timer_fn+0x344/0x348
[ 6862.715700]  __run_hrtimer+0xfc/0x4d0
[ 6862.719431]  __hrtimer_run_queues+0xd4/0x140
[ 6862.723785]  hrtimer_interrupt+0xd8/0x250
[ 6862.727876]  arch_timer_handler_phys+0x38/0x58
[ 6862.732410]  handle_percpu_devid_irq+0xd0/0x3f8
[ 6862.737033]  generic_handle_irq+0x34/0x50
[ 6862.741119]  __handle_domain_irq+0x68/0xc0
[ 6862.745295]  gic_handle_irq+0xf4/0x1e0
[ 6862.749117]  el1_irq+0xc8/0x180
[ 6862.752316]  smp_call_function_many+0x360/0x3b8
[ 6862.756937]  kvm_make_vcpus_request_mask+0x1dc/0x240
[ 6862.762003]  kvm_make_all_cpus_request+0x70/0x98
[ 6862.766714]  kvm_arm_halt_guest+0x70/0x80
[ 6862.770805]  kvm_arch_irq_bypass_stop+0x24/0x30
[ 6862.775428]  __disconnect+0x3c/0x90
[ 6862.778982]  irq_bypass_unregister_producer+0xe0/0x138
[ 6862.784228]  vfio_msi_set_vector_signal+0x9c/0x2a8
[ 6862.789116]  vfio_msi_set_block+0x78/0x108
[ 6862.793294]  vfio_pci_set_msi_trigger+0x238/0x2e0
[ 6862.798093]  vfio_pci_set_irqs_ioctl+0xf8/0x140
[ 6862.802714]  vfio_pci_ioctl+0x30c/0xed0
[ 6862.809692]  vfio_device_fops_unl_ioctl+0x44/0x70
[ 6862.817609]  do_vfs_ioctl+0xc4/0x7f0
[ 6862.824336]  ksys_ioctl+0x8c/0xa0
[ 6862.830680]  __arm64_sys_ioctl+0x28/0x38
[ 6862.837507]  el0_svc_common+0xa0/0x190
[ 6862.844116]  el0_svc_handler+0x38/0x78
[ 6862.850624]  el0_svc+0x8/0xc


Any idea is appreciated.

We will find some time and board to test your new patch set, but right now our top priority is to debug the above issue, so it may take some time to get back with the test result. Sorry for that.

Thanks,
Heyi


On 2019/5/8 20:31, Marc Zyngier wrote:
> On Sun, 05 May 2019 12:07:02 +0100,
> Heyi Guo <guoheyi@huawei.com> wrote:
>> Hi Marc,
>>
>> Appreciate your quick patch :) We'll test it and let you know the
>> result.
> For what it is worth, I've just pushed out a branch (irq/vlpi-map-rework)
> with a more complete fix. It is of course untested (it does compile though).
>
> Please let me know how this fares.
>
> Thanks,
>
> 	M.
>


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
