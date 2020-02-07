Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4904C352A2
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 09:00:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 782B12082E
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 09:00:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 782B12082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF16C4A535;
	Fri,  7 Feb 2020 04:00:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vt8j0hQSETS4; Fri,  7 Feb 2020 04:00:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A328B4A541;
	Fri,  7 Feb 2020 04:00:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC60C4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 04:00:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M8HHhMrjiSaj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 04:00:37 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C7324A3B4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 04:00:37 -0500 (EST)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 88D6132A064F138B9523;
 Fri,  7 Feb 2020 17:00:33 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Fri, 7 Feb 2020
 17:00:26 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
Subject: BUG: using __this_cpu_read() in preemptible [00000000] code
To: <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Message-ID: <318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com>
Date: Fri, 7 Feb 2020 17:00:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: pbonzini@redhat.com, Marc Zyngier <maz@kernel.org>
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

Hi,

Running a latest preemptible kernel and some guests on it,
I got the following message,

---8<---

[  630.031870] BUG: using __this_cpu_read() in preemptible [00000000] 
code: qemu-system-aar/37270
[  630.031872] caller is kvm_get_running_vcpu+0x1c/0x38
[  630.031874] CPU: 32 PID: 37270 Comm: qemu-system-aar Kdump: loaded 
Not tainted 5.5.0+
[  630.031876] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58 
10/29/2018
[  630.031876] Call trace:
[  630.031878]  dump_backtrace+0x0/0x200
[  630.031880]  show_stack+0x24/0x30
[  630.031882]  dump_stack+0xb0/0xf4
[  630.031884]  __this_cpu_preempt_check+0xc8/0xd0
[  630.031886]  kvm_get_running_vcpu+0x1c/0x38
[  630.031888]  vgic_mmio_change_active.isra.4+0x2c/0xe0
[  630.031890]  __vgic_mmio_write_cactive+0x80/0xc8
[  630.031892]  vgic_mmio_uaccess_write_cactive+0x3c/0x50
[  630.031894]  vgic_uaccess+0xcc/0x138
[  630.031896]  vgic_v3_redist_uaccess+0x7c/0xa8
[  630.031898]  vgic_v3_attr_regs_access+0x1a8/0x230
[  630.031901]  vgic_v3_set_attr+0x1b4/0x290
[  630.031903]  kvm_device_ioctl_attr+0xbc/0x110
[  630.031905]  kvm_device_ioctl+0xc4/0x108
[  630.031907]  ksys_ioctl+0xb4/0xd0
[  630.031909]  __arm64_sys_ioctl+0x28/0x38
[  630.031911]  el0_svc_common.constprop.1+0x7c/0x1a0
[  630.031913]  do_el0_svc+0x34/0xa0
[  630.031915]  el0_sync_handler+0x124/0x274
[  630.031916]  el0_sync+0x140/0x180

---8<---

I'm now at commit 90568ecf561540fa330511e21fcd823b0c3829c6.

And it looks like vgic_get_mmio_requester_vcpu() was broken by
7495e22bb165 ("KVM: Move running VCPU from ARM to common code").

Could anyone please have a look?


Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
