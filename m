Return-Path: <SRS0=fdvM=VK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E39C742D7
	for <kvmarm@archiver.kernel.org>; Sat, 13 Jul 2019 11:25:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A76720838
	for <kvmarm@archiver.kernel.org>; Sat, 13 Jul 2019 11:25:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A76720838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 692194A518;
	Sat, 13 Jul 2019 07:25:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5IueVszqPS1n; Sat, 13 Jul 2019 07:25:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0774A4C0;
	Sat, 13 Jul 2019 07:25:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6094A4C0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Jul 2019 07:25:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ecjMe9+B2l7E for <kvmarm@lists.cs.columbia.edu>;
 Sat, 13 Jul 2019 07:25:18 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDE7F4A4A4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Jul 2019 07:25:17 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id AE0B4D80B372480D093D;
 Sat, 13 Jul 2019 19:09:06 +0800 (CST)
Received: from [127.0.0.1] (10.133.216.73) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Sat, 13 Jul 2019
 19:08:58 +0800
Subject: Re: ARM/gic-v4: deadlock occurred
To: Marc Zyngier <marc.zyngier@arm.com>
References: <9efe0260-4a84-7489-ecdd-2e9561599320@huawei.com>
 <86lfzl9ofe.wl-marc.zyngier@arm.com>
 <0b413592-7d98-ebe8-35c5-da330f800326@huawei.com>
 <86a7fx9lg8.wl-marc.zyngier@arm.com>
 <4d60d130-b7ce-96cb-5f8a-11e83329601a@huawei.com>
 <868svg9igl.wl-marc.zyngier@arm.com>
From: Guoheyi <guoheyi@huawei.com>
Message-ID: <dbbf516d-3326-a948-8617-db6b6ec0ceed@huawei.com>
Date: Sat, 13 Jul 2019 19:08:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <868svg9igl.wl-marc.zyngier@arm.com>
X-Originating-IP: [10.133.216.73]
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

Really sorry for the delay of testing the rework patches. I picked up 
the work these days and applied the patches to our 4.19.36 stable 
branch. However, I got below panic during the boot process of host (not 
yet to boot guests).

I supposed the result was not related with my testing kernel version, 
for we don't have many differences in ITS driver; I can test against 
mainline if you think it is necessary.

Thanks,

Heyi


[   16.990413] iommu: Adding device 0000:00:00.0 to group 6
[   17.000691] pcieport 0000:00:00.0: Signaling PME with IRQ 133
[   17.006456] pcieport 0000:00:00.0: AER enabled with IRQ 134
[   17.012151] iommu: Adding device 0000:00:08.0 to group 7
[   17.018575] Unable to handle kernel paging request at virtual address 
00686361635f746f
[   17.026467] Mem abort info:
[   17.029251]   ESR = 0x96000004
[   17.032313]   Exception class = DABT (current EL), IL = 32 bits
[   17.038207]   SET = 0, FnV = 0
[   17.041258]   EA = 0, S1PTW = 0
[   17.044391] Data abort info:
[   17.047260]   ISV = 0, ISS = 0x00000004
[   17.051081]   CM = 0, WnR = 0
[   17.054035] [00686361635f746f] address between user and kernel 
address ranges
[   17.061140] Internal error: Oops: 96000004 [#1] SMP
[   17.065997] Process kworker/0:4 (pid: 889, stack limit = 
0x(____ptrval____))
[   17.073013] CPU: 0 PID: 889 Comm: kworker/0:4 Not tainted 4.19.36+ #8
[   17.079422] Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 0.52 
06/20/2019
[   17.086788] Workqueue: events work_for_cpu_fn
[   17.091126] pstate: 20c00009 (nzCv daif +PAN +UAO)
[   17.095895] pc : __kmalloc_track_caller+0xb0/0x2a0
[   17.100662] lr : __kmalloc_track_caller+0x64/0x2a0
[   17.105429] sp : ffff00002920ba00
[   17.108728] x29: ffff00002920ba00 x28: ffff802cb6792780
[   17.114015] x27: 00000000006080c0 x26: 00000000006000c0
[   17.119302] x25: ffff0000084c8a00 x24: ffff802cbfc0fc00
[   17.124588] x23: ffff802cbfc0fc00 x22: ffff0000084c8a00
[   17.129875] x21: 0000000000000004 x20: 00000000006000c0
[   17.135161] x19: 65686361635f746f x18: ffffffffffffffff
[   17.140448] x17: 000000000000000e x16: 0000000000000007
[   17.145734] x15: ffff000009119708 x14: 0000000000000000
[   17.151021] x13: 0000000000000003 x12: 0000000000000000
[   17.156307] x11: 0000000005f5e0ff x10: ffff00002920bb80
[   17.161594] x9 : 00000000ffffffd0 x8 : 0000000000000098
[   17.166880] x7 : ffff00002920bb80 x6 : ffff000008a8cb98
[   17.172167] x5 : 000000000000a705 x4 : ffff803f802d22e0
[   17.177453] x3 : ffff00002920b990 x2 : ffff7e00b2dafd00
[   17.182740] x1 : 0000803f77476000 x0 : 0000000000000000
[   17.188027] Call trace:
[   17.190461]  __kmalloc_track_caller+0xb0/0x2a0
[   17.194886]  kvasprintf+0x7c/0x108
[   17.198271]  kasprintf+0x60/0x80
[   17.201488]  populate_msi_sysfs+0xe4/0x250
[   17.205564]  __pci_enable_msi_range+0x278/0x450
[   17.210073]  pci_alloc_irq_vectors_affinity+0xd4/0x110
[   17.215188]  pcie_port_device_register+0x134/0x558
[   17.219955]  pcie_portdrv_probe+0x3c/0xf0
[   17.223947]  local_pci_probe+0x44/0xa8
[   17.227679]  work_for_cpu_fn+0x20/0x30
[   17.231411]  process_one_work+0x1b4/0x3f8
[   17.235401]  worker_thread+0x210/0x470
[   17.239134]  kthread+0x134/0x138
[   17.242348]  ret_from_fork+0x10/0x18
[   17.245907] Code: f100005f fa401a64 54000bc0 b9402300 (f8606a66)
[   17.251970] kernel fault(0x1) notification starting on CPU 0
[   17.257602] kernel fault(0x1) notification finished on CPU 0
[   17.263234] Modules linked in:
[   17.266277] ---[ end trace 023e6b19cb68b94f ]---



On 2019/5/9 15:48, Marc Zyngier wrote:
> Hi Heyi,
>
> On Wed, 08 May 2019 14:01:48 +0100,
> Heyi Guo <guoheyi@huawei.com> wrote:
>> Hi Marc,
>>
>> The bad news is that though your previous patch fixed the lockdep
>> warnings, we can still reproduce soft lockup panics and some other
>> exceptions... So our issue may not be related with this lock defect.
>>
>> Most of the call traces are as below, stuck in smp_call_function_many:
>>
>> [ 6862.660611] watchdog: BUG: soft lockup - CPU#27 stuck for 23s! [CPU 18/KVM:95311]
>> [ 6862.668283] Modules linked in: ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter vport_vxlan vxlan ip6_udp_tunnel udp_tunnel openvswitch nsh nf_nat_ipv6 nf_nat_ipv4 nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib ib_umad rpcrdma sunrpc rdma_ucm ib_uverbs ib_iser rdma_cm iw_cm ib_cm hns_roce_hw_v2 hns_roce aes_ce_blk crypto_simd ib_core cryptd aes_ce_cipher crc32_ce ghash_ce sha2_ce sha256_arm64 sha1_ce marvell ses enclosure hibmc_drm ttm drm_kms_helper drm sg ixgbe mdio fb_sys_fops syscopyarea hns3 hclge sysfillrect hnae3 sysimgblt sbsa_gwdt vhost_net tun vhost tap ip_tables dm_mod megaraid_sas hisi_sas_v3_hw hisi_sas_main ipmi_si ipmi_devintf ipmi_msghandler br_netfilter xt_sctp
>> [ 6862.668519] irq event stamp: 1670812
>> [ 6862.668526] hardirqs last  enabled at (1670811): [<ffff000008083498>] el1_irq+0xd8/0x180
>> [ 6862.668530] hardirqs last disabled at (1670812): [<ffff000008083448>] el1_irq+0x88/0x180
>> [ 6862.668534] softirqs last  enabled at (1661542): [<ffff000008081d2c>] __do_softirq+0x41c/0x51c
>> [ 6862.668539] softirqs last disabled at (1661535): [<ffff0000080fafc4>] irq_exit+0x18c/0x198
>> [ 6862.668544] CPU: 27 PID: 95311 Comm: CPU 18/KVM Kdump: loaded Tainted: G        W         4.19.36-1.2.141.aarch64 #1
>> [ 6862.668548] Hardware name: Huawei TaiShan 2280 V2/BC82AMDA, BIOS TA BIOS TaiShan 2280 V2 - B900 01/29/2019
>> [ 6862.668551] pstate: 80400009 (Nzcv daif +PAN -UAO)
>> [ 6862.668557] pc : smp_call_function_many+0x360/0x3b8
>> [ 6862.668560] lr : smp_call_function_many+0x320/0x3b8
>> [ 6862.668563] sp : ffff000028f338e0
>> [ 6862.668566] x29: ffff000028f338e0 x28: ffff000009893fb4
>> [ 6862.668575] x27: 0000000000000400 x26: 0000000000000000
>> [ 6862.668583] x25: ffff0000080b1e08 x24: 0000000000000001
>> [ 6862.668591] x23: ffff000009891bc8 x22: ffff000009891bc8
>> [ 6862.668599] x21: ffff805f7d6da408 x20: ffff000009893fb4
>> [ 6862.668608] x19: ffff805f7d6da400 x18: 0000000000000000
>> [ 6862.668616] x17: 0000000000000000 x16: 0000000000000000
>> [ 6862.668624] x15: 0000000000000000 x14: 0000000000000000
>> [ 6862.668632] x13: 0000000000000040 x12: 0000000000000228
>> [ 6862.668640] x11: 0000000000000020 x10: 0000000000000040
>> [ 6862.668648] x9 : 0000000000000000 x8 : 0000000000000010
>> [ 6862.668656] x7 : 0000000000000000 x6 : ffff805f7d329660
>> [ 6862.668664] x5 : ffff000028f33850 x4 : 0000000002000402
>> [ 6862.668673] x3 : 0000000000000000 x2 : ffff803f7f3dc678
>> [ 6862.668681] x1 : 0000000000000003 x0 : 000000000000000a
>> [ 6862.668689] Call trace:
>> [ 6862.668693]  smp_call_function_many+0x360/0x3b8
> This would tend to indicate that one of the CPUs isn't responding to
> the IPI because it has its interrupts disabled, or has crashed badly
> already. Can you check where in smp_call_function_many this is
> hanging? My bet is on the wait loop at the end of the function.
>
> You'll need to find out what this unresponsive CPU is doing...
>
>> Any idea is appreciated.
>>
>> We will find some time and board to test your new patch set, but
>> right now our top priority is to debug the above issue, so it may
>> take some time to get back with the test result. Sorry for that.
> No worries, that can wait.
>
> 	M.
>


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
