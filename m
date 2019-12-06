Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FC2C43603
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 08:00:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 025D224679
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 08:00:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 025D224679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56DEB4AF21;
	Fri,  6 Dec 2019 03:00:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IDKcWIWsifL0; Fri,  6 Dec 2019 03:00:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 082504AF25;
	Fri,  6 Dec 2019 03:00:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5620F4AC83
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 21:08:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tWBnwltoFwv4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Dec 2019 21:08:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A5864A959
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 21:08:21 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4448A31B;
 Thu,  5 Dec 2019 18:08:20 -0800 (PST)
Received: from localhost.localdomain (unknown [10.169.40.54])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 834003F718;
 Thu,  5 Dec 2019 18:08:16 -0800 (PST)
From: Jia He <justin.he@arm.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm: remove excessive permission check in
 kvm_arch_prepare_memory_region
Date: Fri,  6 Dec 2019 10:08:02 +0800
Message-Id: <20191206020802.196108-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
X-Mailman-Approved-At: Fri, 06 Dec 2019 03:00:43 -0500
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jia He <justin.he@arm.com>,
 linux-kernel@vger.kernel.org
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

In kvm_arch_prepare_memory_region, arm kvm regards the memory region as
writable if the flag has no KVM_MEM_READONLY, and the vm is readonly if
!VM_WRITE.

But there is common usage for setting kvm memory region as follows:
e.g. qemu side (see the PROT_NONE flag)
1. mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
   memory_region_init_ram_ptr()
2. re mmap the above area with read/write authority.

Such example is used in virtio-fs qemu codes which hasn't been upstreamed
[1]. But seems we can't forbid this example.

Without this patch, it will cause an EPERM during kvm_set_memory_region()
and cause qemu boot crash.

As told by Ard, "the underlying assumption is incorrect, i.e., that the
value of vm_flags at this point in time defines how the VMA is used
during its lifetime. There may be other cases where a VMA is created
with VM_READ vm_flags that are changed to VM_READ|VM_WRITE later, and
we are currently rejecting this use case as well."

[1] https://gitlab.com/virtio-fs/qemu/blob/5a356e/hw/virtio/vhost-user-fs.c#L488

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Jia He <justin.he@arm.com>
---
 virt/kvm/arm/mmu.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 38b4c910b6c3..a48994af70b8 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2301,15 +2301,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (!vma || vma->vm_start >= reg_end)
 			break;
 
-		/*
-		 * Mapping a read-only VMA is only allowed if the
-		 * memory region is configured as read-only.
-		 */
-		if (writable && !(vma->vm_flags & VM_WRITE)) {
-			ret = -EPERM;
-			break;
-		}
-
 		/*
 		 * Take the intersection of this VMA with the memory region
 		 */
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
