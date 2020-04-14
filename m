Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A5AC2BB86
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 03:04:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8DA42072D
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 03:04:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8DA42072D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62E534B256;
	Mon, 13 Apr 2020 23:04:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D+WbdpeeiWE7; Mon, 13 Apr 2020 23:04:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D54B4B229;
	Mon, 13 Apr 2020 23:04:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AD964B1F9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 23:04:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KbZG+tBgK358 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2020 23:04:23 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 230364B1F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 23:04:20 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 3D6C6B928563B7540FB8;
 Tue, 14 Apr 2020 11:04:16 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Tue, 14 Apr 2020 11:04:09 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>
Subject: [PATCH 1/2] KVM: arm64: vgic-v3: Retire all pending LPIs on vcpu
 destroy
Date: Tue, 14 Apr 2020 11:03:47 +0800
Message-ID: <20200414030349.625-2-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20200414030349.625-1-yuzenghui@huawei.com>
References: <20200414030349.625-1-yuzenghui@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org, linux-kernel@vger.kernel.org,
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

It's likely that the vcpu fails to handle all virtual interrupts if
userspace decides to destroy it, leaving the pending ones stay in the
ap_list. If the un-handled one is a LPI, its vgic_irq structure will
be eventually leaked because of an extra refcount increment in
vgic_queue_irq_unlock().

This was detected by kmemleak on almost every guest destroy, the
backtrace is as follows:

unreferenced object 0xffff80725aed5500 (size 128):
comm "CPU 5/KVM", pid 40711, jiffies 4298024754 (age 166366.512s)
hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 08 01 a9 73 6d 80 ff ff ...........sm...
c8 61 ee a9 00 20 ff ff 28 1e 55 81 6c 80 ff ff .a... ..(.U.l...
backtrace:
[<000000004bcaa122>] kmem_cache_alloc_trace+0x2dc/0x418
[<0000000069c7dabb>] vgic_add_lpi+0x88/0x418
[<00000000bfefd5c5>] vgic_its_cmd_handle_mapi+0x4dc/0x588
[<00000000cf993975>] vgic_its_process_commands.part.5+0x484/0x1198
[<000000004bd3f8e3>] vgic_its_process_commands+0x50/0x80
[<00000000b9a65b2b>] vgic_mmio_write_its_cwriter+0xac/0x108
[<0000000009641ebb>] dispatch_mmio_write+0xd0/0x188
[<000000008f79d288>] __kvm_io_bus_write+0x134/0x240
[<00000000882f39ac>] kvm_io_bus_write+0xe0/0x150
[<0000000078197602>] io_mem_abort+0x484/0x7b8
[<0000000060954e3c>] kvm_handle_guest_abort+0x4cc/0xa58
[<00000000e0d0cd65>] handle_exit+0x24c/0x770
[<00000000b44a7fad>] kvm_arch_vcpu_ioctl_run+0x460/0x1988
[<0000000025fb897c>] kvm_vcpu_ioctl+0x4f8/0xee0
[<000000003271e317>] do_vfs_ioctl+0x160/0xcd8
[<00000000e7f39607>] ksys_ioctl+0x98/0xd8

Fix it by retiring all pending LPIs in the ap_list on the destroy path.

p.s. I can also reproduce it on a normal guest shutdown. It is because
userspace still send LPIs to vcpu (through KVM_SIGNAL_MSI ioctl) while
the guest is being shutdown and unable to handle it. A little strange
though and haven't dig further...

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 virt/kvm/arm/vgic/vgic-init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index a963b9d766b7..53ec9b9d9bc4 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -348,6 +348,12 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
+	/*
+	 * Retire all pending LPIs on this vcpu anyway as we're
+	 * going to destroy it.
+	 */
+	vgic_flush_pending_lpis(vcpu);
+
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
 }
 
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
