Return-Path: <SRS0=kd74=UF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF7AC28EB7
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jun 2019 10:58:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A262E206E0
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jun 2019 10:58:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A262E206E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A16F4A500;
	Thu,  6 Jun 2019 06:58:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vsiujxvtGWzD; Thu,  6 Jun 2019 06:58:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A674A4F2;
	Thu,  6 Jun 2019 06:58:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 258824A331
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jun 2019 06:58:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UdT9NnkfvN2A for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jun 2019 06:58:18 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA0524A4AA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jun 2019 06:58:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E3D415AB;
 Thu,  6 Jun 2019 03:58:18 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 317003F690;
 Thu,  6 Jun 2019 03:58:17 -0700 (PDT)
From: Dave Martin <Dave.Martin@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/2] KVM: arm/arm64: vgic: Fix irq refcount leak in
 kvm_vgic_set_owner()
Date: Thu,  6 Jun 2019 11:58:08 +0100
Message-Id: <1559818688-20638-3-git-send-email-Dave.Martin@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1559818688-20638-1-git-send-email-Dave.Martin@arm.com>
References: <1559818688-20638-1-git-send-email-Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

kvm_vgic_set_owner() leaks a reference on the vgic_irq descriptor,
which does not seem to match up with any vgic_put_irq() that I can
find.

Since the irq pointer is not passed out and the caller must anyway
subsequently use vgic_get_irq() when is wants a pointer, it is not
clear why we should have a dangling refcount here.

The refcount is still needed inside kvm_vgic_set_owner() to prevent
the vgic_irq struct from disappearing while while it is
manipulated.

So, keep it vgic_get_irq() here, but add the matching
vgic_put_irq() before returning.

unreferenced object 0xffff800b6365ab80 (size 128):
  comm "qemu-system-aar", pid 14414, jiffies 4300822606 (age 84.436s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 b0 e1 e0 38 00 00 ff ff  ...........8....
    b0 e1 e0 38 00 00 ff ff 78 e6 ad dd 0a 80 ff ff  ...8....x.......
  backtrace:
    [<00000000a08b80e2>] kmem_cache_alloc+0x178/0x208
    [<00000000114591cb>] vgic_add_lpi.part.5+0x34/0x190
    [<00000000ec1425ae>] vgic_its_cmd_handle_mapi+0x320/0x348
    [<00000000935c5c32>] vgic_its_process_commands.part.14+0x350/0x8b8
    [<00000000dc256d2c>] vgic_mmio_write_its_cwriter+0x78/0x98
    [<000000008659acd2>] dispatch_mmio_write+0xd4/0x120

[...]

Cc: Christoffer Dall <christoffer.dall@arm.com>
Fixes: c6ccd30e0de3 ("KVM: arm/arm64: Introduce an allocator for in-kernel irq lines")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Based on the limited testing I've done so far, the patch _appears_ to
fix the bug.

However, I still don't understand which the bug is intermittent, or why
the arch_timer or pmu (the only apparent users of kvm_vgic_set_owner())
are claiming an LPI in the first place.

So there may be other bugs in the mix, or I may have misunderstood
something...

The bug (and fix) were observed with native qemu on ThunderX2, on a
merge of v5.1 with kvmarm/next commit 9eecfc22e0bf ("KVM: arm64: Fix
ptrauth ID register masking logic").

My qemu invocation was:

$ qemu-system-aarch64 -machine virt,accel=kvm,gic_version=3 -cpu host \
    -smp 4 -nographic \
    -drive id=vblock,file=block.qcow2,format=qcow2,if=none \
    -device virtio-blk-device,drive=vblock \
    -kernel Image -append 'root=/dev/vda1 ro'
---
 virt/kvm/arm/vgic/vgic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 191decc..930319c 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -599,6 +599,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
 	else
 		irq->owner = owner;
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	vgic_put_irq(vcpu->kvm, irq);
 
 	return ret;
 }
-- 
2.1.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
