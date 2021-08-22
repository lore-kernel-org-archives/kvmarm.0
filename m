Return-Path: <SRS0=jhc2=NN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAF0C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 15:25:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E44BF6112F
	for <kvmarm@archiver.kernel.org>; Sun, 22 Aug 2021 15:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E44BF6112F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4F04B203;
	Sun, 22 Aug 2021 11:25:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y4PGDUHxhmGf; Sun, 22 Aug 2021 11:25:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3F404B1FF;
	Sun, 22 Aug 2021 11:25:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C80E4B1B6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 11:25:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r9qQfGlnTmBx for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Aug 2021 11:25:36 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D7034B174
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Aug 2021 11:25:36 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 73FB261266;
 Sun, 22 Aug 2021 15:25:35 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mHpLp-006VTo-TD; Sun, 22 Aug 2021 16:25:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/3] kvmtool: arm64: Use the maximum supported IPA size
 when creating the VM
Date: Sun, 22 Aug 2021 16:25:25 +0100
Message-Id: <20210822152526.1291918-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210822152526.1291918-1-maz@kernel.org>
References: <20210822152526.1291918-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
 alexandru.elisei@arm.com, will@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 Will Deacon <will@kernel.org>
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

Instead of just asking the the default VM size, request the maximum
IPA size to the kernel, and use this at VM creation time.

The IPA space is parametrized accordingly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arm/aarch64/include/kvm/kvm-arch.h | 19 ++++++++++++++++---
 arm/aarch64/kvm.c                  | 15 +++++++++++++++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 55ef8ed1..159567b9 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -3,10 +3,23 @@
 
 struct kvm;
 unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
+int kvm__arch_get_ipa_limit(struct kvm *kvm);
 
-#define ARM_MAX_MEMORY(kvm)	((kvm)->cfg.arch.aarch32_guest	?	\
-				ARM_LOMAP_MAX_MEMORY		:	\
-				ARM_HIMAP_MAX_MEMORY)
+#define ARM_MAX_MEMORY(kvm)	({					\
+	u64 max_ram;							\
+									\
+	if ((kvm)->cfg.arch.aarch32_guest) {				\
+		max_ram = ARM_LOMAP_MAX_MEMORY;				\
+	} else {							\
+		int ipabits = kvm__arch_get_ipa_limit(kvm);		\
+		if (ipabits <= 0)					\
+			max_ram = ARM_HIMAP_MAX_MEMORY;			\
+		else							\
+			max_ram = (1ULL << ipabits) - ARM_MEMORY_AREA;	\
+	}								\
+									\
+	max_ram;							\
+})
 
 #include "arm-common/kvm-arch.h"
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 49e1dd31..d03a27f2 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -46,3 +46,18 @@ fail:
 	return 0x80000;
 }
 
+int kvm__arch_get_ipa_limit(struct kvm *kvm)
+{
+	int ret;
+
+	ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE);
+	if (ret <= 0)
+		ret = 0;
+
+	return ret;
+}
+
+int kvm__get_vm_type(struct kvm *kvm)
+{
+	return KVM_VM_TYPE_ARM_IPA_SIZE(kvm__arch_get_ipa_limit(kvm));
+}
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
