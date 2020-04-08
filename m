Return-Path: <SRS0=0SjI=5Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B84C2BA2B
	for <kvmarm@archiver.kernel.org>; Wed,  8 Apr 2020 11:16:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D76520753
	for <kvmarm@archiver.kernel.org>; Wed,  8 Apr 2020 11:16:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D76520753
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9B404B1DE;
	Wed,  8 Apr 2020 07:16:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yi259a+tyCuf; Wed,  8 Apr 2020 07:16:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 855404B1EB;
	Wed,  8 Apr 2020 07:16:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA234B1DE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Apr 2020 07:16:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kshfoy4eKcbr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Apr 2020 07:16:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1A694B198
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Apr 2020 07:16:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA07731B;
 Wed,  8 Apr 2020 04:16:03 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1E153F73D;
 Wed,  8 Apr 2020 04:16:02 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: arch_timer shouldn't assume the vcpu is loaded
To: Marc Zyngier <maz@kernel.org>
References: <20200406150355.4859-1-james.morse@arm.com>
 <20200408110726.4d81bc3b@why>
From: James Morse <james.morse@arm.com>
Message-ID: <cc6bed09-33dd-027a-126f-ed22389c1624@arm.com>
Date: Wed, 8 Apr 2020 12:16:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200408110726.4d81bc3b@why>
Content-Language: en-GB
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On 08/04/2020 11:07, Marc Zyngier wrote:
> On Mon,  6 Apr 2020 16:03:55 +0100
> James Morse <james.morse@arm.com> wrote:
> 
>> kvm_arch_timer_get_input_level() needs to get the arch_timer_context for
>> a particular vcpu, and uses kvm_get_running_vcpu() to find it.
>>
>> kvm_arch_timer_get_input_level() may be called to handle a user-space
>> write to the redistributor, where the vcpu is not loaded. This causes
>> kvm_get_running_vcpu() to return NULL:
>> | Unable to handle kernel paging request at virtual address 0000000000001ec0
>> | Mem abort info:
>> |   ESR = 0x96000004
>> |   EC = 0x25: DABT (current EL), IL = 32 bits
>> |   SET = 0, FnV = 0
>> |   EA = 0, S1PTW = 0
>> | Data abort info:
>> |   ISV = 0, ISS = 0x00000004
>> |   CM = 0, WnR = 0
>> | user pgtable: 4k pages, 48-bit VAs, pgdp=000000003cbf9000
>> | [0000000000001ec0] pgd=0000000000000000
>> | Internal error: Oops: 96000004 [#1] PREEMPT SMP
>> | Modules linked in: r8169 realtek efivarfs ip_tables x_tables
>> | CPU: 1 PID: 2615 Comm: qemu-system-aar Not tainted 5.6.0-rc7 #30
>> | Hardware name: Marvell mvebu_armada-37xx/mvebu_armada-37xx, BIOS 2018.03-devel-18.12.3-gc9aa92c-armbian 02/20/2019
>> | pstate: 00000085 (nzcv daIf -PAN -UAO)
>> | pc : kvm_arch_timer_get_input_level+0x1c/0x68
>> | lr : kvm_arch_timer_get_input_level+0x1c/0x68
>>
>> | Call trace:
>> |  kvm_arch_timer_get_input_level+0x1c/0x68
>> |  vgic_get_phys_line_level+0x3c/0x90
>> |  vgic_mmio_write_senable+0xe4/0x130
>> |  vgic_uaccess+0xe0/0x100
>> |  vgic_v3_redist_uaccess+0x5c/0x80
>> |  vgic_v3_attr_regs_access+0xf0/0x200
>> |  nvgic_v3_set_attr+0x234/0x250
>> |  kvm_device_ioctl_attr+0xa4/0xf8
>> |  kvm_device_ioctl+0x7c/0xc0
>> |  ksys_ioctl+0x1fc/0xc18
>> |  __arm64_sys_ioctl+0x24/0x30
>> |  do_el0_svc+0x7c/0x148
>> |  el0_sync_handler+0x138/0x258
>> |  el0_sync+0x140/0x180
>> | Code: 910003fd f9000bf3 2a0003f3 97ff650c (b95ec001)
>> | ---[ end trace 81287612d93f1e70 ]---
>> | note: qemu-system-aar[2615] exited with preempt_count 1
>>
>> Loading the vcpu doesn't make a lot of sense for handling a device ioctl(),
>> so instead pass the vcpu through to kvm_arch_timer_get_input_level(). Its
>> not clear that an intid makes much sense without the paired vcpu.
> 
> I don't fully agree with the analysis, Remember we are looking at the
> state of the physical interrupt associated with a virtual interrupt, so
> the vcpu doesn't quite make sense here if it isn't loaded.
> 
> What does it mean to look at the HW timer when we are not in the right
> context? For all we know, it is completely random (the only guarantee
> we have is that it is disabled, actually).

> My gut feeling is that this is another instance where we should provide
> specific userspace accessors that would only deal with the virtual
> state, and leave anything that deals with the physical state of the
> interrupt to be exercised only by the guest.

> Does it make sense?

Broadly, yes. Specifically ... I'm not familiar enough with this code to work out where
such a change should go!

~20 mins of grepping later~

Remove REGISTER_DESC_WITH_LENGTH() so that uaccess helpers have to be provided, and forbid
NULL for the ur/uw values in REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED()...?

Or if that is too invasive, something like, (totally, untested):
----------------%<----------------
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 97fb2a40e6ba..30ae5f29e429 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -113,10 +113,11 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
                struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);

                raw_spin_lock_irqsave(&irq->irq_lock, flags);
-               if (vgic_irq_is_mapped_level(irq)) {
+               if (kvm_running_vcpu() && vgic_irq_is_mapped_level(irq)) {
                        bool was_high = irq->line_level;

                        /*
+                        * Unless we are running due to a user-space access,
                         * We need to update the state of the interrupt because
                         * the guest might have changed the state of the device
                         * while the interrupt was disabled at the VGIC level.
----------------%<----------------


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
