Return-Path: <SRS0=IDfC=UT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39155C48BE1
	for <kvmarm@archiver.kernel.org>; Thu, 20 Jun 2019 11:23:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0003F2070B
	for <kvmarm@archiver.kernel.org>; Thu, 20 Jun 2019 11:23:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0003F2070B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB6CF4A504;
	Thu, 20 Jun 2019 07:23:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DI5CKp+tTKpz; Thu, 20 Jun 2019 07:23:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5290E4A50B;
	Thu, 20 Jun 2019 07:23:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A59004A4EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jun 2019 07:23:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KenS+INMCr7i for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Jun 2019 07:23:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CCB64A4C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jun 2019 07:23:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3033F142F;
 Thu, 20 Jun 2019 04:23:16 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE9A83F718;
 Thu, 20 Jun 2019 04:23:14 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 3/4] KVM: arm/arm64: vgic: Fix kvm_device leak in
 vgic_its_destroy
Date: Thu, 20 Jun 2019 12:23:00 +0100
Message-Id: <20190620112301.138137-4-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190620112301.138137-1-marc.zyngier@arm.com>
References: <20190620112301.138137-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
 kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>,
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

From: Dave Martin <Dave.Martin@arm.com>

kvm_device->destroy() seems to be supposed to free its kvm_device
struct, but vgic_its_destroy() is not currently doing this,
resulting in a memory leak, resulting in kmemleak reports such as
the following:

unreferenced object 0xffff800aeddfe280 (size 128):
  comm "qemu-system-aar", pid 13799, jiffies 4299827317 (age 1569.844s)
  [...]
  backtrace:
    [<00000000a08b80e2>] kmem_cache_alloc+0x178/0x208
    [<00000000dcad2bd3>] kvm_vm_ioctl+0x350/0xbc0

Fix it.

Cc: Andre Przywara <andre.przywara@arm.com>
Fixes: 1085fdc68c60 ("KVM: arm64: vgic-its: Introduce new KVM ITS device")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 44ceaccb18cf..8c9fe831bce4 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1734,6 +1734,7 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 
 	mutex_unlock(&its->its_lock);
 	kfree(its);
+	kfree(kvm_dev);/* alloc by kvm_ioctl_create_device, free by .destroy */
 }
 
 static int vgic_its_has_attr_regs(struct kvm_device *dev,
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
