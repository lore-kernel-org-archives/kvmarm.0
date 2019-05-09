Return-Path: <SRS0=QEDf=TJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC38C04AB1
	for <kvmarm@archiver.kernel.org>; Thu,  9 May 2019 11:37:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 22BF0216C4
	for <kvmarm@archiver.kernel.org>; Thu,  9 May 2019 11:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22BF0216C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76C884A4C5;
	Thu,  9 May 2019 07:37:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fsZ5xDIq0wH9; Thu,  9 May 2019 07:37:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A13F4A3BB;
	Thu,  9 May 2019 07:37:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BD064A3BB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 May 2019 07:37:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kvg-BsJbzPvV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 May 2019 07:37:40 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83D8D4A321
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 May 2019 07:37:40 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 26233D172ACBE7C5A49C;
 Thu,  9 May 2019 19:37:37 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.55) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Thu, 9 May 2019
 19:37:27 +0800
Subject: Re: ARM/gic-v4: deadlock occurred
To: Marc Zyngier <marc.zyngier@arm.com>
References: <9efe0260-4a84-7489-ecdd-2e9561599320@huawei.com>
 <86lfzl9ofe.wl-marc.zyngier@arm.com>
 <0b413592-7d98-ebe8-35c5-da330f800326@huawei.com>
 <86a7fx9lg8.wl-marc.zyngier@arm.com>
 <4d60d130-b7ce-96cb-5f8a-11e83329601a@huawei.com>
 <868svg9igl.wl-marc.zyngier@arm.com>
From: Heyi Guo <guoheyi@huawei.com>
Message-ID: <8be3a9f0-f3c5-8874-e7f4-9fc507925153@huawei.com>
Date: Thu, 9 May 2019 19:37:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <868svg9igl.wl-marc.zyngier@arm.com>
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

Yes.

>
> You'll need to find out what this unresponsive CPU is doing...

True; we need to dig more deeply...

Appreciate it.

Heyi

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
