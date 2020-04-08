Return-Path: <SRS0=0SjI=5Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3E7C2D0EA
	for <kvmarm@archiver.kernel.org>; Wed,  8 Apr 2020 10:07:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B56EE20747
	for <kvmarm@archiver.kernel.org>; Wed,  8 Apr 2020 10:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZdUr9CJT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B56EE20747
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A8F4B209;
	Wed,  8 Apr 2020 06:07:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QCS9TCGGxUi7; Wed,  8 Apr 2020 06:07:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 286544B20A;
	Wed,  8 Apr 2020 06:07:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 360424B208
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Apr 2020 06:07:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yTU5XpcBHDTE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Apr 2020 06:07:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06F6D4B207
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Apr 2020 06:07:30 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DA7DF20747;
 Wed,  8 Apr 2020 10:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586340450;
 bh=o95FC0wItSEUj4ltL7xhaHqV/b3LwS/7FFNIVb55PqU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ZdUr9CJT22PsyZGxq1jI9+Bcn2cP5QjpegA/anb6qQOmn2TywTlMhD7rlx9hOxpOd
 VAcGj+pSYzH+7/tBdde2/cn3a03DTEg5fSfF7b0BcRyzb57AQDVCF+9Uzt8ZRbdPMH
 ooi75Lfb2JjxDwN1yTum52AZyZYcoAqdrKBs0cMg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jM7cF-001cDz-UQ; Wed, 08 Apr 2020 11:07:28 +0100
Date: Wed, 8 Apr 2020 11:07:26 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: arch_timer shouldn't assume the vcpu is loaded
Message-ID: <20200408110726.4d81bc3b@why>
In-Reply-To: <20200406150355.4859-1-james.morse@arm.com>
References: <20200406150355.4859-1-james.morse@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, andre.przywara@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

Hi James,

Thanks for looking into this.

On Mon,  6 Apr 2020 16:03:55 +0100
James Morse <james.morse@arm.com> wrote:

> kvm_arch_timer_get_input_level() needs to get the arch_timer_context for
> a particular vcpu, and uses kvm_get_running_vcpu() to find it.
> 
> kvm_arch_timer_get_input_level() may be called to handle a user-space
> write to the redistributor, where the vcpu is not loaded. This causes
> kvm_get_running_vcpu() to return NULL:
> | Unable to handle kernel paging request at virtual address 0000000000001ec0
> | Mem abort info:
> |   ESR = 0x96000004
> |   EC = 0x25: DABT (current EL), IL = 32 bits
> |   SET = 0, FnV = 0
> |   EA = 0, S1PTW = 0
> | Data abort info:
> |   ISV = 0, ISS = 0x00000004
> |   CM = 0, WnR = 0
> | user pgtable: 4k pages, 48-bit VAs, pgdp=000000003cbf9000
> | [0000000000001ec0] pgd=0000000000000000
> | Internal error: Oops: 96000004 [#1] PREEMPT SMP
> | Modules linked in: r8169 realtek efivarfs ip_tables x_tables
> | CPU: 1 PID: 2615 Comm: qemu-system-aar Not tainted 5.6.0-rc7 #30
> | Hardware name: Marvell mvebu_armada-37xx/mvebu_armada-37xx, BIOS 2018.03-devel-18.12.3-gc9aa92c-armbian 02/20/2019
> | pstate: 00000085 (nzcv daIf -PAN -UAO)
> | pc : kvm_arch_timer_get_input_level+0x1c/0x68
> | lr : kvm_arch_timer_get_input_level+0x1c/0x68
> 
> | Call trace:
> |  kvm_arch_timer_get_input_level+0x1c/0x68
> |  vgic_get_phys_line_level+0x3c/0x90
> |  vgic_mmio_write_senable+0xe4/0x130
> |  vgic_uaccess+0xe0/0x100
> |  vgic_v3_redist_uaccess+0x5c/0x80
> |  vgic_v3_attr_regs_access+0xf0/0x200
> |  nvgic_v3_set_attr+0x234/0x250
> |  kvm_device_ioctl_attr+0xa4/0xf8
> |  kvm_device_ioctl+0x7c/0xc0
> |  ksys_ioctl+0x1fc/0xc18
> |  __arm64_sys_ioctl+0x24/0x30
> |  do_el0_svc+0x7c/0x148
> |  el0_sync_handler+0x138/0x258
> |  el0_sync+0x140/0x180
> | Code: 910003fd f9000bf3 2a0003f3 97ff650c (b95ec001)
> | ---[ end trace 81287612d93f1e70 ]---
> | note: qemu-system-aar[2615] exited with preempt_count 1
> 
> Loading the vcpu doesn't make a lot of sense for handling a device ioctl(),
> so instead pass the vcpu through to kvm_arch_timer_get_input_level(). Its
> not clear that an intid makes much sense without the paired vcpu.

I don't fully agree with the analysis, Remember we are looking at the
state of the physical interrupt associated with a virtual interrupt, so
the vcpu doesn't quite make sense here if it isn't loaded.

What does it mean to look at the HW timer when we are not in the right
context? For all we know, it is completely random (the only guarantee
we have is that it is disabled, actually).

My gut feeling is that this is another instance where we should provide
specific userspace accessors that would only deal with the virtual
state, and leave anything that deals with the physical state of the
interrupt to be exercised only by the guest.

Does it make sense?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
