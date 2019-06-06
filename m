Return-Path: <SRS0=kd74=UF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78F8C04AB5
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jun 2019 12:34:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7789420684
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jun 2019 12:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7789420684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01EE64A4C2;
	Thu,  6 Jun 2019 08:34:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7B9F9tvwjxxy; Thu,  6 Jun 2019 08:34:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E85984A4CA;
	Thu,  6 Jun 2019 08:34:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A945C4A4C2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jun 2019 08:34:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bWQkcq-jHLBx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jun 2019 08:34:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 265CF4A331
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jun 2019 08:34:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91A70374;
 Thu,  6 Jun 2019 05:34:10 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A52043F5AF;
 Thu,  6 Jun 2019 05:34:09 -0700 (PDT)
Date: Thu, 6 Jun 2019 13:34:07 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: vgic: Fix irq refcount leak in
 kvm_vgic_set_owner()
Message-ID: <20190606123406.GC28398@e103592.cambridge.arm.com>
References: <1559818688-20638-1-git-send-email-Dave.Martin@arm.com>
 <1559818688-20638-3-git-send-email-Dave.Martin@arm.com>
 <d6992e32-22ee-8467-171c-1699d52ba54b@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d6992e32-22ee-8467-171c-1699d52ba54b@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
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

On Thu, Jun 06, 2019 at 01:06:33PM +0100, Marc Zyngier wrote:
> On 06/06/2019 11:58, Dave Martin wrote:
> > kvm_vgic_set_owner() leaks a reference on the vgic_irq descriptor,
> > which does not seem to match up with any vgic_put_irq() that I can
> > find.
> > 
> > Since the irq pointer is not passed out and the caller must anyway
> > subsequently use vgic_get_irq() when is wants a pointer, it is not
> > clear why we should have a dangling refcount here.
> > 
> > The refcount is still needed inside kvm_vgic_set_owner() to prevent
> > the vgic_irq struct from disappearing while while it is
> > manipulated.
> > 
> > So, keep it vgic_get_irq() here, but add the matching
> > vgic_put_irq() before returning.
> > 
> > unreferenced object 0xffff800b6365ab80 (size 128):
> >   comm "qemu-system-aar", pid 14414, jiffies 4300822606 (age 84.436s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 b0 e1 e0 38 00 00 ff ff  ...........8....
> >     b0 e1 e0 38 00 00 ff ff 78 e6 ad dd 0a 80 ff ff  ...8....x.......
> >   backtrace:
> >     [<00000000a08b80e2>] kmem_cache_alloc+0x178/0x208
> >     [<00000000114591cb>] vgic_add_lpi.part.5+0x34/0x190
> >     [<00000000ec1425ae>] vgic_its_cmd_handle_mapi+0x320/0x348
> >     [<00000000935c5c32>] vgic_its_process_commands.part.14+0x350/0x8b8
> >     [<00000000dc256d2c>] vgic_mmio_write_its_cwriter+0x78/0x98
> >     [<000000008659acd2>] dispatch_mmio_write+0xd4/0x120
> > 
> > [...]
> > 
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Fixes: c6ccd30e0de3 ("KVM: arm/arm64: Introduce an allocator for in-kernel irq lines")
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > 
> > ---
> > 
> > Based on the limited testing I've done so far, the patch _appears_ to
> > fix the bug.
> > 
> > However, I still don't understand which the bug is intermittent, or why
> > the arch_timer or pmu (the only apparent users of kvm_vgic_set_owner())
> > are claiming an LPI in the first place.
> > 
> > So there may be other bugs in the mix, or I may have misunderstood
> > something...
> 
> Yeah, this doesn't make much sense. Both timer and PMU are using PPIs,
> which are not refcounted, so this vgic_put_irq() is effectively a NOP.
> It doesn't invalidate the patch itself, it is just that I seriously
> doubt it fixes anything.
> 
> LPIs do not use the owner field so far, so we must have another get/put
> mismatch somewhere.

No argument from me.

As I say, this change _appeared_ to make this leak go away, but I
couldn't understand why, and didn't kick it very thoroughly.  So it
may well be a red herring.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
