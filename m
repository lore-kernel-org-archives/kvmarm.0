Return-Path: <SRS0=bs2E=2C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E693C2D0CA
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 17:28:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 532C221655
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 17:28:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 532C221655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0774E4AC80;
	Thu, 12 Dec 2019 12:28:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vS2OGdHTzVxf; Thu, 12 Dec 2019 12:28:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 232B34AED5;
	Thu, 12 Dec 2019 12:28:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB56E4AC88
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 12:28:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 741W9lu41qc4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Dec 2019 12:28:49 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA10D4A541
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 12:28:48 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ifSGZ-00069s-LQ; Thu, 12 Dec 2019 18:28:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 6/8] KVM: arm/arm64: Remove excessive permission check in
 kvm_arch_prepare_memory_region
Date: Thu, 12 Dec 2019 17:28:22 +0000
Message-Id: <20191212172824.11523-7-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212172824.11523-1-maz@kernel.org>
References: <20191212172824.11523-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com,
 alexandru.elisei@arm.com, ard.biesheuvel@linaro.org, christoffer.dall@arm.com,
 eric.auger@redhat.com, james.morse@arm.com, justin.he@arm.com,
 mark.rutland@arm.com, linmiaohe@huawei.com, steven.price@arm.com,
 will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Jia He <justin.he@arm.com>, kvm@vger.kernel.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will@kernel.org>,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
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

From: Jia He <justin.he@arm.com>

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

Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Jia He <justin.he@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Link: https://lore.kernel.org/r/20191206020802.196108-1-justin.he@arm.com
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
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
