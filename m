Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52618C4320A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:18:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0238661425
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:18:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0238661425
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A99BA4B286;
	Wed, 25 Aug 2021 12:18:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CbNV0tVxk45q; Wed, 25 Aug 2021 12:18:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F354B2A9;
	Wed, 25 Aug 2021 12:17:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA15E4B22C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 27ywL1JNTnP2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:17:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 193B64B20D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D42CB113E;
 Wed, 25 Aug 2021 09:17:29 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 838793F66F;
 Wed, 25 Aug 2021 09:17:28 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 11/39] KVM: arm64: Allow userspace to lock and unlock
 memslots
Date: Wed, 25 Aug 2021 17:17:47 +0100
Message-Id: <20210825161815.266051-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

The ioctls have been implemented, allow the userspace to lock and unlock
memslots.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/arm.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c47e96ae4f7c..4bd4b8b082a4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -80,11 +80,6 @@ int kvm_arch_check_processor_compat(void *opaque)
 	return 0;
 }
 
-static int kvm_arm_lock_memslot_supported(void)
-{
-	return 0;
-}
-
 static int kvm_lock_user_memory_region_ioctl(struct kvm *kvm,
 					     struct kvm_enable_cap *cap)
 {
@@ -127,8 +122,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.mte_enabled = true;
 		break;
 	case KVM_CAP_ARM_LOCK_USER_MEMORY_REGION:
-		if (!kvm_arm_lock_memslot_supported())
-			return -EINVAL;
 		r = kvm_lock_user_memory_region_ioctl(kvm, cap);
 		break;
 	default:
@@ -306,7 +299,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = system_has_full_ptr_auth();
 		break;
 	case KVM_CAP_ARM_LOCK_USER_MEMORY_REGION:
-		r = kvm_arm_lock_memslot_supported();
+		r = 1;
 		break;
 	default:
 		r = 0;
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
