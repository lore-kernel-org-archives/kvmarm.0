Return-Path: <SRS0=vYaB=VV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041B3C7618B
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 08:53:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7CC022083B
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 08:53:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CC022083B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB6D14A5A1;
	Wed, 24 Jul 2019 04:53:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6JZ8l4Wv+6N0; Wed, 24 Jul 2019 04:53:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C1C44A55B;
	Wed, 24 Jul 2019 04:53:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A0D4A547
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 04:53:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j7tnGBsU2C7O for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jul 2019 04:53:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B596E4A524
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 04:53:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FE3F337;
 Wed, 24 Jul 2019 01:53:39 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 0A70F3F694; Wed, 24 Jul 2019 01:53:37 -0700 (PDT)
Subject: Re: KVM Arm64 and Linux-RT issues
To: Julien Grall <julien.grall@arm.com>,
 "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 anna-maria@linutronix.de, "bigeasy@linutronix.de" <bigeasy@linutronix.de>
References: <b9867c43-7fe3-5d64-9939-b1a7ab7f1061@arm.com>
From: Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
 Z46HaNmN2hZS/oJ69c1DI5Rcww==
Organization: ARM Ltd
Message-ID: <cd310858-2c0f-6af1-bf82-ee1e01a2cfb8@arm.com>
Date: Wed, 24 Jul 2019 09:53:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <b9867c43-7fe3-5d64-9939-b1a7ab7f1061@arm.com>
Content-Language: en-US
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

Julien,

On 23/07/2019 18:58, Julien Grall wrote:
> Hi all,
> 
> I have been playing with the latest branch of Linux RT (5.2-rt1) and notice the 
> following splat when starting a KVM guest.
> 
> [  122.336254] 003: BUG: sleeping function called from invalid context at 
> kernel/locking/rtmutex.c:968
> [  122.336263] 003: in_atomic(): 1, irqs_disabled(): 0, pid: 1430, name: kvm-vcpu-1
> [  122.336267] 003: 2 locks held by kvm-vcpu-1/1430:
> [  122.336271] 003:  #0: ffff8007c1518100 (&vcpu->mutex){+.+.}, at: 
> kvm_vcpu_ioctl+0x70/0xae0
> [  122.336287] 003:  #1: ffff8007fb08b478 
> (&cpu_base->softirq_expiry_lock){+.+.}, at: hrtimer_grab_expiry_lock+0x24/0x40
> [  122.336299] 003: Preemption disabled at:
> [  122.336300] 003: [<ffff0000111a44e8>] schedule+0x30/0xd8
> [  122.336308] 003: CPU: 3 PID: 1430 Comm: kvm-vcpu-1 Tainted: G        W 
> 5.2.0-rt1-00008-g5bc0332820fd #88
> [  122.336311] 003: Hardware name: AMD Seattle (Rev.B0) Development Board 
> (Overdrive) (DT)
> [  122.336314] 003: Call trace:
> [  122.336315] 003:  dump_backtrace+0x0/0x130
> [  122.336319] 003:  show_stack+0x14/0x20
> [  122.336321] 003:  dump_stack+0xbc/0x104
> [  122.336324] 003:  ___might_sleep+0x198/0x238
> [  122.336327] 003:  rt_spin_lock+0x5c/0x70
> [  122.336330] 003:  hrtimer_grab_expiry_lock+0x24/0x40
> [  122.336332] 003:  hrtimer_cancel+0x1c/0x38
> [  122.336334] 003:  kvm_timer_vcpu_load+0x78/0x3e0
> [  122.336338] 003:  kvm_arch_vcpu_load+0x130/0x298
> [  122.336340] 003:  kvm_sched_in+0x38/0x68
> [  122.336342] 003:  finish_task_switch+0x14c/0x300
> [  122.336344] 003:  __schedule+0x2b8/0x8d0
> [  122.336346] 003:  schedule+0x38/0xd8
> [  122.336347] 003:  kvm_vcpu_block+0xac/0x790
> [  122.336349] 003:  kvm_handle_wfx+0x210/0x520
> [  122.336352] 003:  handle_exit+0x134/0x1d0
> [  122.336355] 003:  kvm_arch_vcpu_ioctl_run+0x658/0xbc0
> [  122.336357] 003:  kvm_vcpu_ioctl+0x3a0/0xae0
> [  122.336359] 003:  do_vfs_ioctl+0xbc/0x910
> [  122.336363] 003:  ksys_ioctl+0x78/0xa8
> [  122.336365] 003:  __arm64_sys_ioctl+0x1c/0x28
> [  122.336367] 003:  el0_svc_common.constprop.0+0x90/0x188
> [  122.336370] 003:  el0_svc_handler+0x28/0x78
> [  122.336373] 003:  el0_svc+0x8/0xc
> [  122.564216] 000: BUG: scheduling while atomic: kvm-vcpu-1/1430/0x00000002
> [  122.564221] 000: 2 locks held by kvm-vcpu-1/1430:
> [  122.564224] 000:  #0: ffff8007c1518100 (&vcpu->mutex){+.+.}, at: 
> kvm_vcpu_ioctl+0x70/0xae0
> [  122.564236] 000:  #1: ffff8007fb08b478 
> (&cpu_base->softirq_expiry_lock){+.+.}, at: hrtimer_grab_expiry_lock+0x24/0x40
> [  122.564245] 000: Modules linked in:
> [  122.564248] 000: Preemption disabled at:
> [  122.564249] 000: [<ffff0000111a44e8>] schedule+0x30/0xd8

[...]

> The first problem "BUG: sleeping function called from invalid context at 
> kernel/locking/rtmutex.c:968" seem to be related to RT-specific commit 
> d628c3c56cab "hrtimer: Introduce expiry spin lock".
> 
>  From my understanding, the problem is the hrtimer_cancel() is called from a 
> preempt notifier and therefore preemption will be disabled. The patch mentioned 
> above will actually require hrtimer_cancel() to be called from preemptible context.
> 
> Do you have any thoughts how the problem should be addressed?

It really feels like a change in hrtimer_cancel semantics. From what I
understand, this is used to avoid racing against the softirq, but boy it
breaks things.

If this cannot be avoided, this means we can't cancel the background
timer (which is used to emulate the vcpu timer while it is blocked
waiting for an interrupt), then we must move this canceling to the point
where the vcpu is unblocked (instead of scheduled), which may have some
side effects -- I'll have a look.

But that's not the only problem: We also have hrtimers used to emulate
timers while the vcpu is running, and these timers are canceled in
kvm_timer_vcpu_put(), which is also called from a preempt notifier.
Unfortunately, I don't have a reasonable solution for that (other than
putting this hrtimer_cancel in a workqueue and start chasing the
resulting races).

Any other idea before I start tearing our timer code apart *again*?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
