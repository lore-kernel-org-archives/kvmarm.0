Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EAD5C282CE
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 12:59:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2839920679
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 12:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2839920679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35F884A4FF;
	Tue,  4 Jun 2019 08:59:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h3kBBE1+Vpds; Tue,  4 Jun 2019 08:58:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D47924A483;
	Tue,  4 Jun 2019 08:58:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 699A84A4F3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 08:58:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bhg-OZBa8FM3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 08:58:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E09DA4A418
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 08:58:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AB3AA78;
 Tue,  4 Jun 2019 05:58:55 -0700 (PDT)
Received: from [10.37.8.2] (unknown [10.37.8.2])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79AAB3F690;
 Tue,  4 Jun 2019 05:58:53 -0700 (PDT)
To: linux-rt-users <linux-rt-users@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 kvmarm@lists.cs.columbia.edu
From: Julien Grall <julien.grall@arm.com>
Subject: KVM Arm Device passthrough and linux-rt
Message-ID: <26832850-37ee-ae07-08ca-cc3e90978867@arm.com>
Date: Tue, 4 Jun 2019 13:58:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Language: en-US
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Steven Rostedt <rostedt@goodmis.org>, julia@ni.com
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

Hi,

While trying device passthrough on Linux-rt with KVM Arm, I had
the following splat.

[  363.410141] 000: BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:974
[  363.410150] 000: in_atomic(): 0, irqs_disabled(): 128, pid: 2916, name: qemu-system-aar
[  363.410153] 000: 4 locks held by qemu-system-aar/2916:
[  363.410157] 000:  #0: ffff8007bd248100 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x70/0xae0
[  363.410171] 000:  #1: ffff8007bd1e2b20 (&kvm->irq_srcu){....}, at: kvm_notify_acked_irq+0x7c/0x300
[  363.410179] 000:  #2: ffff8007bd1e2b20 (&kvm->irq_srcu){....}, at: irqfd_resampler_ack+0x0/0xd8
[  363.410187] 000:  #3: ffff8007c2b27d28 (&ctx->wqh#2){+.+.}, at: eventfd_signal+0x24/0x78
[  363.410196] 000: irq event stamp: 4033894
[  363.410197] 000: hardirqs last  enabled at (4033893): [<ffff000011119400>] _raw_spin_unlock_irqrestore+0x88/0x90
[  363.410203] 000: hardirqs last disabled at (4033894): [<ffff0000100bed18>] kvm_arch_vcpu_ioctl_run+0x2a8/0xc08
[  363.410207] 000: softirqs last  enabled at (0): [<ffff0000100edde0>] copy_process.isra.1.part.2+0x8d8/0x1958
[  363.410212] 000: softirqs last disabled at (0): [<0000000000000000>]  (null)
[  363.410216] 000: CPU: 0 PID: 2916 Comm: qemu-system-aar Tainted: G        W       5.0.14-rt9-00013-g4b2a13c8a804 #84
[  363.410219] 000: Hardware name: AMD Seattle (Rev.B0) Development Board (Overdrive) (DT)
[  363.410221] 000: Call trace:
[  363.410222] 000:  dump_backtrace+0x0/0x158
[  363.410225] 000:  show_stack+0x14/0x20
[  363.410227] 000:  dump_stack+0xa0/0xd4
[  363.410230] 000:  ___might_sleep+0x16c/0x1f8
[  363.410234] 000:  rt_spin_lock+0x5c/0x70
[  363.410237] 000:  eventfd_signal+0x24/0x78
[  363.410238] 000:  irqfd_resampler_ack+0x94/0xd8
[  363.410241] 000:  kvm_notify_acked_irq+0xf8/0x300
[  363.410243] 000:  vgic_v2_fold_lr_state+0x174/0x1e0
[  363.410246] 000:  kvm_vgic_sync_hwstate+0x5c/0x2b8
[  363.410249] 000:  kvm_arch_vcpu_ioctl_run+0x624/0xc08
[  363.410250] 000:  kvm_vcpu_ioctl+0x3a0/0xae0
[  363.410252] 000:  do_vfs_ioctl+0xbc/0x910
[  363.410255] 000:  ksys_ioctl+0x78/0xa8
[  363.410257] 000:  __arm64_sys_ioctl+0x1c/0x28
[  363.410260] 000:  el0_svc_common+0x90/0x118
[  363.410263] 000:  el0_svc_handler+0x2c/0x80
[  363.410265] 000:  el0_svc+0x8/0xc

This is happening because vgic_v2_fold_lr_state() is expected
to be called with interrupt disabled. However, some of the path
(e.g eventfd) will take a spinlock.

The spinlock is from the waitqueue, so using a raw_spin_lock cannot
even be considered.

Do you have any input on how this could be solved?

Cheers,

-- 
Julien Grall
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
