Return-Path: <SRS0=tngP=VU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168C5C76186
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 17:58:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7CFF7218A0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Jul 2019 17:58:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CFF7218A0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4AAC4A577;
	Tue, 23 Jul 2019 13:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PbKIaF3GVpK2; Tue, 23 Jul 2019 13:58:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FF6E4A580;
	Tue, 23 Jul 2019 13:58:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AF794A55F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 13:58:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vTmxQpuFM9jY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Jul 2019 13:58:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D60884A53E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Jul 2019 13:58:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61CCE337;
 Tue, 23 Jul 2019 10:58:44 -0700 (PDT)
Received: from [10.1.196.50] (e108454-lin.cambridge.arm.com [10.1.196.50])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F7323F71A;
 Tue, 23 Jul 2019 10:58:43 -0700 (PDT)
To: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 anna-maria@linutronix.de, "bigeasy@linutronix.de" <bigeasy@linutronix.de>
From: Julien Grall <julien.grall@arm.com>
Subject: KVM Arm64 and Linux-RT issues
Message-ID: <b9867c43-7fe3-5d64-9939-b1a7ab7f1061@arm.com>
Date: Tue, 23 Jul 2019 18:58:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Language: en-US
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

Hi all,

I have been playing with the latest branch of Linux RT (5.2-rt1) and notice the 
following splat when starting a KVM guest.

[  122.336254] 003: BUG: sleeping function called from invalid context at 
kernel/locking/rtmutex.c:968
[  122.336263] 003: in_atomic(): 1, irqs_disabled(): 0, pid: 1430, name: kvm-vcpu-1
[  122.336267] 003: 2 locks held by kvm-vcpu-1/1430:
[  122.336271] 003:  #0: ffff8007c1518100 (&vcpu->mutex){+.+.}, at: 
kvm_vcpu_ioctl+0x70/0xae0
[  122.336287] 003:  #1: ffff8007fb08b478 
(&cpu_base->softirq_expiry_lock){+.+.}, at: hrtimer_grab_expiry_lock+0x24/0x40
[  122.336299] 003: Preemption disabled at:
[  122.336300] 003: [<ffff0000111a44e8>] schedule+0x30/0xd8
[  122.336308] 003: CPU: 3 PID: 1430 Comm: kvm-vcpu-1 Tainted: G        W 
5.2.0-rt1-00008-g5bc0332820fd #88
[  122.336311] 003: Hardware name: AMD Seattle (Rev.B0) Development Board 
(Overdrive) (DT)
[  122.336314] 003: Call trace:
[  122.336315] 003:  dump_backtrace+0x0/0x130
[  122.336319] 003:  show_stack+0x14/0x20
[  122.336321] 003:  dump_stack+0xbc/0x104
[  122.336324] 003:  ___might_sleep+0x198/0x238
[  122.336327] 003:  rt_spin_lock+0x5c/0x70
[  122.336330] 003:  hrtimer_grab_expiry_lock+0x24/0x40
[  122.336332] 003:  hrtimer_cancel+0x1c/0x38
[  122.336334] 003:  kvm_timer_vcpu_load+0x78/0x3e0
[  122.336338] 003:  kvm_arch_vcpu_load+0x130/0x298
[  122.336340] 003:  kvm_sched_in+0x38/0x68
[  122.336342] 003:  finish_task_switch+0x14c/0x300
[  122.336344] 003:  __schedule+0x2b8/0x8d0
[  122.336346] 003:  schedule+0x38/0xd8
[  122.336347] 003:  kvm_vcpu_block+0xac/0x790
[  122.336349] 003:  kvm_handle_wfx+0x210/0x520
[  122.336352] 003:  handle_exit+0x134/0x1d0
[  122.336355] 003:  kvm_arch_vcpu_ioctl_run+0x658/0xbc0
[  122.336357] 003:  kvm_vcpu_ioctl+0x3a0/0xae0
[  122.336359] 003:  do_vfs_ioctl+0xbc/0x910
[  122.336363] 003:  ksys_ioctl+0x78/0xa8
[  122.336365] 003:  __arm64_sys_ioctl+0x1c/0x28
[  122.336367] 003:  el0_svc_common.constprop.0+0x90/0x188
[  122.336370] 003:  el0_svc_handler+0x28/0x78
[  122.336373] 003:  el0_svc+0x8/0xc
[  122.564216] 000: BUG: scheduling while atomic: kvm-vcpu-1/1430/0x00000002
[  122.564221] 000: 2 locks held by kvm-vcpu-1/1430:
[  122.564224] 000:  #0: ffff8007c1518100 (&vcpu->mutex){+.+.}, at: 
kvm_vcpu_ioctl+0x70/0xae0
[  122.564236] 000:  #1: ffff8007fb08b478 
(&cpu_base->softirq_expiry_lock){+.+.}, at: hrtimer_grab_expiry_lock+0x24/0x40
[  122.564245] 000: Modules linked in:
[  122.564248] 000: Preemption disabled at:
[  122.564249] 000: [<ffff0000111a44e8>] schedule+0x30/0xd8
[  122.564255] 000: CPU: 0 PID: 1430 Comm: kvm-vcpu-1 Tainted: G        W 
5.2.0-rt1-00008-g5bc0332820fd #88
[  122.564259] 000: Hardware name: AMD Seattle (Rev.B0) Development Board 
(Overdrive) (DT)
[  122.564261] 000: Call trace:
[  122.564262] 000:  dump_backtrace+0x0/0x130
[  122.564264] 000:  show_stack+0x14/0x20
[  122.564267] 000:  dump_stack+0xbc/0x104
[  122.564269] 000:  __schedule_bug+0xbc/0xe8
[  122.564272] 000:  __schedule+0x6e4/0x8d0
[  122.564274] 000:  schedule+0x38/0xd8
[  122.564275] 000:  rt_spin_lock_slowlock_locked+0xf8/0x390
[  122.564277] 000:  rt_spin_lock_slowlock+0x68/0xa0
[  122.564279] 000:  rt_spin_lock+0x64/0x70
[  122.564281] 000:  hrtimer_grab_expiry_lock+0x24/0x40
[  122.564283] 000:  hrtimer_cancel+0x1c/0x38
[  122.564285] 000:  kvm_timer_vcpu_load+0x78/0x3e0
[  122.564287] 000:  kvm_arch_vcpu_load+0x130/0x298
[  122.564290] 000:  kvm_sched_in+0x38/0x68
[  122.564291] 000:  finish_task_switch+0x14c/0x300
[  122.564293] 000:  __schedule+0x2b8/0x8d0
[  122.564295] 000:  schedule+0x38/0xd8
[  122.564297] 000:  kvm_vcpu_block+0xac/0x790
[  122.564298] 000:  kvm_handle_wfx+0x210/0x520
[  122.564301] 000:  handle_exit+0x134/0x1d0
[  122.564303] 000:  kvm_arch_vcpu_ioctl_run+0x658/0xbc0
[  122.564305] 000:  kvm_vcpu_ioctl+0x3a0/0xae0
[  122.564307] 000:  do_vfs_ioctl+0xbc/0x910
[  122.564309] 000:  ksys_ioctl+0x78/0xa8
[  122.564311] 000:  __arm64_sys_ioctl+0x1c/0x28
[  122.564313] 000:  el0_svc_common.constprop.0+0x90/0x188
[  122.564316] 000:  el0_svc_handler+0x28/0x78
[  122.564318] 000:  el0_svc+0x8/0xc
[  122.564341] 000: WARNING: CPU: 0 PID: 1430 at kernel/sched/core.c:7366 
migrate_enable+0x21c/0x428
[  122.564346] 000: Modules linked in:
[  122.564348] 000: CPU: 0 PID: 1430 Comm: kvm-vcpu-1 Tainted: G        W 
5.2.0-rt1-00008-g5bc0332820fd #88
[  122.564351] 000: Hardware name: AMD Seattle (Rev.B0) Development Board 
(Overdrive) (DT)
[  122.564352] 000: pstate: 60000005 (nZCv daif -PAN -UAO)
[  122.564355] 000: pc : migrate_enable+0x21c/0x428
[  122.564357] 000: lr : rt_spin_unlock+0x2c/0x48
[  122.564359] 000: sp : ffff00002648b680
[  122.564362] 000: x29: ffff00002648b680 x28: ffff000011af9b00
[  122.564365] 000: x27: ffff8007fb03d918 x26: 00008007e9579000
[  122.564368] 000: x25: 0000000000000000 x24: fffefdf7d6910c00
[  122.564371] 000: x23: 0000000000000000 x22: 0000000000000008
[  122.564374] 000: x21: 0000000000000001 x20: ffff8007c284cd80
[  122.564377] 000: x19: ffff000011af0d88 x18: 000000000004ffff
[  122.564379] 000: x17: 0000000000000000 x16: 0000000000000000
[  122.564382] 000: x15: ffff000011f7ae50 x14: 0000000000020f9e
[  122.564385] 000: x13: 0000000000000028 x12: 0000000000000002
[  122.564387] 000: x11: 0000000000000028 x10: ffff000011af2000
[  122.564390] 000: x9 : 0000000000000000 x8 : 0000000000096855
[  122.564393] 000: x7 : 0000000000000001 x6 : 0000000000000000
[  122.564395] 000: x5 : 00008007e9579000 x4 : 0000000000000001
[  122.564398] 000: x3 : 0000000000000001 x2 : 0000000000000000
[  122.564400] 000: x1 : 0000000000000070 x0 : 0000000000000000
[  122.564402] 000: Call trace:
[  122.564403] 000:  migrate_enable+0x21c/0x428
[  122.564406] 000:  rt_spin_unlock+0x2c/0x48
[  122.564408] 000:  hrtimer_grab_expiry_lock+0x30/0x40
[  122.564410] 000:  hrtimer_cancel+0x1c/0x38
[  122.564411] 000:  kvm_timer_vcpu_load+0x78/0x3e0
[  122.564414] 000:  kvm_arch_vcpu_load+0x130/0x298
[  122.564416] 000:  kvm_sched_in+0x38/0x68
[  122.564418] 000:  finish_task_switch+0x14c/0x300
[  122.564420] 000:  __schedule+0x2b8/0x8d0
[  122.564421] 000:  schedule+0x38/0xd8
[  122.564423] 000:  kvm_vcpu_block+0xac/0x790
[  122.564425] 000:  kvm_handle_wfx+0x210/0x520
[  122.564427] 000:  handle_exit+0x134/0x1d0
[  122.564429] 000:  kvm_arch_vcpu_ioctl_run+0x658/0xbc0
[  122.564431] 000:  kvm_vcpu_ioctl+0x3a0/0xae0
[  122.564433] 000:  do_vfs_ioctl+0xbc/0x910
[  122.564435] 000:  ksys_ioctl+0x78/0xa8
[  122.564437] 000:  __arm64_sys_ioctl+0x1c/0x28
[  122.564439] 000:  el0_svc_common.constprop.0+0x90/0x188
[  122.564441] 000:  el0_svc_handler+0x28/0x78
[  122.564443] 000:  el0_svc+0x8/0xc
[  122.564446] 000: irq event stamp: 1855748
[  122.564447] 000: hardirqs last  enabled at (1855747): [<ffff0000111a8a44>] 
_raw_spin_unlock_irqrestore+0x94/0xa0
[  122.564450] 000: hardirqs last disabled at (1855748): [<ffff00001008193c>] 
do_debug_exception+0x94/0x208
[  122.564453] 000: softirqs last  enabled at (1567014): [<ffff000010088090>] 
fpsimd_restore_current_state+0x50/0xa0
[  122.564457] 000: softirqs last disabled at (1567011): [<ffff000010088068>] 
fpsimd_restore_current_state+0x28/0xa0
[  122.564460] 000: ---[ end trace 0000000000000003 ]---
[  122.564488] 000: WARNING: CPU: 0 PID: 1430 at kernel/cpu.c:331 
unpin_current_cpu+0x94/0x138
[  122.564494] 000: Modules linked in:
[  122.564496] 000: CPU: 0 PID: 1430 Comm: kvm-vcpu-1 Tainted: G        W 
5.2.0-rt1-00008-g5bc0332820fd #88
[  122.564498] 000: Hardware name: AMD Seattle (Rev.B0) Development Board 
(Overdrive) (DT)
[  122.564499] 000: pstate: a0000005 (NzCv daif -PAN -UAO)
[  122.564502] 000: pc : unpin_current_cpu+0x94/0x138
[  122.564504] 000: lr : unpin_current_cpu+0x64/0x138
[  122.564506] 000: sp : ffff00002648b640
[  122.564508] 000: x29: ffff00002648b640 x28: ffff000011af9b00
[  122.564511] 000: x27: ffff8007fb03d918 x26: 00008007e9579000
[  122.564513] 000: x25: 0000000000000000 x24: 00000000ffffffff
[  122.564516] 000: x23: ffff8007c284cd80 x22: ffff000011aa31f0
[  122.564519] 000: x21: 0000ffffee50f260 x20: ffff000011af0da8
[  122.564522] 000: x19: ffff8007fb01c2c8 x18: 000000000004ffff
[  122.564524] 000: x17: 0000000000000000 x16: 0000000000000000
[  122.564527] 000: x15: ffff000011f7ae50 x14: 0000000000020f9e
[  122.564529] 000: x13: 0000000000000028 x12: 0000000000000002
[  122.564532] 000: x11: 0000000000000028 x10: ffff000011af2000
[  122.564535] 000: x9 : 0000000000000000 x8 : 000000006cc11800
[  122.564537] 000: x7 : 0000000050000000 x6 : 000000007a82670e
[  122.564540] 000: x5 : 00008007e9579000 x4 : 0000000000000002
[  122.564542] 000: x3 : 00008007e9579000 x2 : 0000000000000001
[  122.564545] 000: x1 : ffff8007c284cd80 x0 : 0000000000000000
[  122.564547] 000: Call trace:
[  122.564548] 000:  unpin_current_cpu+0x94/0x138
[  122.564550] 000:  migrate_enable+0x190/0x428
[  122.564552] 000:  rt_spin_unlock+0x2c/0x48
[  122.564554] 000:  hrtimer_grab_expiry_lock+0x30/0x40
[  122.564556] 000:  hrtimer_cancel+0x1c/0x38
[  122.564558] 000:  kvm_timer_vcpu_load+0x78/0x3e0
[  122.564560] 000:  kvm_arch_vcpu_load+0x130/0x298
[  122.564562] 000:  kvm_sched_in+0x38/0x68
[  122.564564] 000:  finish_task_switch+0x14c/0x300
[  122.564566] 000:  __schedule+0x2b8/0x8d0
[  122.564567] 000:  schedule+0x38/0xd8
[  122.564569] 000:  kvm_vcpu_block+0xac/0x790
[  122.564571] 000:  kvm_handle_wfx+0x210/0x520
[  122.564573] 000:  handle_exit+0x134/0x1d0
[  122.564575] 000:  kvm_arch_vcpu_ioctl_run+0x658/0xbc0
[  122.564577] 000:  kvm_vcpu_ioctl+0x3a0/0xae0
[  122.564579] 000:  do_vfs_ioctl+0xbc/0x910
[  122.564581] 000:  ksys_ioctl+0x78/0xa8
[  122.564583] 000:  __arm64_sys_ioctl+0x1c/0x28
[  122.564585] 000:  el0_svc_common.constprop.0+0x90/0x188
[  122.564588] 000:  el0_svc_handler+0x28/0x78
[  122.564590] 000:  el0_svc+0x8/0xc
[  122.564592] 000: irq event stamp: 1855754
[  122.564593] 000: hardirqs last  enabled at (1855753): [<ffff0000111a8a44>] 
_raw_spin_unlock_irqrestore+0x94/0xa0
[  122.564596] 000: hardirqs last disabled at (1855754): [<ffff00001008193c>] 
do_debug_exception+0x94/0x208
[  122.564598] 000: softirqs last  enabled at (1567014): [<ffff000010088090>] 
fpsimd_restore_current_state+0x50/0xa0
[  122.564601] 000: softirqs last disabled at (1567011): [<ffff000010088068>] 
fpsimd_restore_current_state+0x28/0xa0
[  122.564604] 000: ---[ end trace 0000000000000004 ]---
[  122.564786] 000: 
================================================================================
[  122.564787] 000: UBSAN: Undefined behaviour in 
/home/julieng/works/linux/kernel/cpu.c:332:15
[  122.564791] 000: index -1 is out of range for type 'long unsigned int [256]'
[  122.564794] 000: CPU: 0 PID: 1430 Comm: kvm-vcpu-1 Tainted: G        W 
5.2.0-rt1-00008-g5bc0332820fd #88
[  122.564797] 000: Hardware name: AMD Seattle (Rev.B0) Development Board 
(Overdrive) (DT)
[  122.564798] 000: Call trace:
[  122.564799] 000:  dump_backtrace+0x0/0x130
[  122.564802] 000:  show_stack+0x14/0x20
[  122.564804] 000:  dump_stack+0xbc/0x104
[  122.564806] 000:  ubsan_epilogue.isra.5+0xc/0x3c
[  122.564810] 000:  __ubsan_handle_out_of_bounds+0x78/0x88
[  122.564812] 000:  unpin_current_cpu+0x130/0x138
[  122.564814] 000:  migrate_enable+0x190/0x428
[  122.564816] 000:  rt_spin_unlock+0x2c/0x48
[  122.564819] 000:  hrtimer_grab_expiry_lock+0x30/0x40
[  122.564821] 000:  hrtimer_cancel+0x1c/0x38
[  122.564823] 000:  kvm_timer_vcpu_load+0x78/0x3e0
[  122.564825] 000:  kvm_arch_vcpu_load+0x130/0x298
[  122.564827] 000:  kvm_sched_in+0x38/0x68
[  122.564829] 000:  finish_task_switch+0x14c/0x300
[  122.564831] 000:  __schedule+0x2b8/0x8d0
[  122.564833] 000:  schedule+0x38/0xd8
[  122.564834] 000:  kvm_vcpu_block+0xac/0x790
[  122.564836] 000:  kvm_handle_wfx+0x210/0x520
[  122.564838] 000:  handle_exit+0x134/0x1d0
[  122.564841] 000:  kvm_arch_vcpu_ioctl_run+0x658/0xbc0
[  122.564843] 000:  kvm_vcpu_ioctl+0x3a0/0xae0
[  122.564845] 000:  do_vfs_ioctl+0xbc/0x910
[  122.564847] 000:  ksys_ioctl+0x78/0xa8
[  122.564849] 000:  __arm64_sys_ioctl+0x1c/0x28
[  122.564851] 000:  el0_svc_common.constprop.0+0x90/0x188
[  122.564853] 000:  el0_svc_handler+0x28/0x78
[  122.564856] 000:  el0_svc+0x8/0xc
[  122.564858] 000: 
================================================================================
[  122.564868] 000: Unable to handle kernel paging request at virtual address 
ffff001f11e1e436
[  122.564871] 000: Mem abort info:
[  122.564872] 000:   ESR = 0x96000021
[  122.564874] 000:   Exception class = DABT (current EL), IL = 32 bits
[  122.564876] 000:   SET = 0, FnV = 0
[  122.564878] 000:   EA = 0, S1PTW = 0
[  122.564879] 000: Data abort info:
[  122.564880] 000:   ISV = 0, ISS = 0x00000021
[  122.564882] 000:   CM = 0, WnR = 0
[  122.564884] 000: swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000080038dc000
[  122.564887] 000: [ffff001f11e1e436] pgd=00000087fffff003, pud=0000000000000000
[  122.564944] 000: Internal error: Oops: 96000021 [#1] PREEMPT SMP
[  122.564948] 000: Modules linked in:
[  122.564949] 000: CPU: 0 PID: 1430 Comm: kvm-vcpu-1 Tainted: G        W 
5.2.0-rt1-00008-g5bc0332820fd #88
[  122.564952] 000: Hardware name: AMD Seattle (Rev.B0) Development Board 
(Overdrive) (DT)
[  122.564953] 000: pstate: 80000005 (Nzcv daif -PAN -UAO)
[  122.564955] 000: pc : __ll_sc_arch_atomic_sub_return+0x4/0x20
[  122.564959] 000: lr : __read_rt_unlock+0x1c/0x68
[  122.564963] 000: sp : ffff00002648b620
[  122.564964] 000: x29: ffff00002648b620 x28: ffff000011af9b00
[  122.564967] 000: x27: ffff8007fb03d918 x26: 00008007e9579000
[  122.564970] 000: x25: 0000000000000000 x24: 00000000ffffffff
[  122.564973] 000: x23: ffffffffffffffff x22: ffff000011aa31f0
[  122.564975] 000: x21: 0000000000000000 x20: ffff000011af0da8
[  122.564978] 000: x19: ffff001f11e1e39e x18: 000000000004ffff
[  122.564980] 000: x17: 0000000000000000 x16: 0000000000000000
[  122.564983] 000: x15: ffff000011f7ae50 x14: 0000000000020fac
[  122.564985] 000: x13: 0000000000000028 x12: ffff000012007d70
[  122.564987] 000: x11: 00000000000107d4 x10: ffff000011af2000
[  122.564990] 000: x9 : 0000000000008008 x8 : ffff000011f7a000
[  122.564992] 000: x7 : 0000000000000001 x6 : ffff000011f7a000
[  122.564995] 000: x5 : 00008007e9579000 x4 : 0000000000000002
[  122.564997] 000: x3 : 0000000000000002 x2 : 0000000000000001
[  122.564999] 000: x1 : ffff001f11e1e436 x0 : 0000000000000001
[  122.565001] 000: Call trace:
[  122.565002] 000:  __ll_sc_arch_atomic_sub_return+0x4/0x20
[  122.565004] 000:  unpin_current_cpu+0x80/0x138
[  122.565007] 000:  migrate_enable+0x190/0x428
[  122.565009] 000:  rt_spin_unlock+0x2c/0x48
[  122.565011] 000:  hrtimer_grab_expiry_lock+0x30/0x40
[  122.565012] 000:  hrtimer_cancel+0x1c/0x38
[  122.565014] 000:  kvm_timer_vcpu_load+0x78/0x3e0
[  122.565016] 000:  kvm_arch_vcpu_load+0x130/0x298
[  122.565018] 000:  kvm_sched_in+0x38/0x68
[  122.565020] 000:  finish_task_switch+0x14c/0x300
[  122.565022] 000:  __schedule+0x2b8/0x8d0
[  122.565023] 000:  schedule+0x38/0xd8
[  122.565024] 000:  kvm_vcpu_block+0xac/0x790
[  122.565026] 000:  kvm_handle_wfx+0x210/0x520
[  122.565028] 000:  handle_exit+0x134/0x1d0
[  122.565031] 000:  kvm_arch_vcpu_ioctl_run+0x658/0xbc0
[  122.565032] 000:  kvm_vcpu_ioctl+0x3a0/0xae0
[  122.565034] 000:  do_vfs_ioctl+0xbc/0x910
[  122.565036] 000:  ksys_ioctl+0x78/0xa8
[  122.565038] 000:  __arm64_sys_ioctl+0x1c/0x28
[  122.565040] 000:  el0_svc_common.constprop.0+0x90/0x188
[  122.565042] 000:  el0_svc_handler+0x28/0x78
[  122.565045] 000:  el0_svc+0x8/0xc
[  122.565048] 000: Code: 88107c31 35ffffb0 d65f03c0 f9800031 (885f7c31)
[  122.565052] 000: ---[ end trace 0000000000000005 ]---
[  122.565060] 000: note: kvm-vcpu-1[1430] exited with preempt_count 1

The first problem "BUG: sleeping function called from invalid context at 
kernel/locking/rtmutex.c:968" seem to be related to RT-specific commit 
d628c3c56cab "hrtimer: Introduce expiry spin lock".

 From my understanding, the problem is the hrtimer_cancel() is called from a 
preempt notifier and therefore preemption will be disabled. The patch mentioned 
above will actually require hrtimer_cancel() to be called from preemptible context.

Do you have any thoughts how the problem should be addressed?

The second problem seems to hint that migrate_enable() was called on a task not 
pinned (-1). This will result to derefence an invalid value. I need to 
investigate how this can happen.

Looking at the other RT tree, I think 5.0 RT now has the same problem.

Cheers,

-- 
Julien Grall
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
