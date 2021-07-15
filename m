Return-Path: <SRS0=OVIf=MH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A804AC47E48
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 16:54:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 411CB613FB
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 16:54:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 411CB613FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7BAE4B097;
	Thu, 15 Jul 2021 12:54:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wm9+QkXDOcjU; Thu, 15 Jul 2021 12:54:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D05164B09A;
	Thu, 15 Jul 2021 12:54:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D44FF4B08D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 12:54:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c1zBnWXr-p0m for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jul 2021 12:53:59 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37B104B08A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 12:53:59 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 84887613E9;
 Thu, 15 Jul 2021 16:53:58 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m44Hb-00DYjr-4J; Thu, 15 Jul 2021 17:32:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] arm64: Implement ioremap/iounmap hooks calling into
 KVM's MMIO guard
Date: Thu, 15 Jul 2021 17:31:56 +0100
Message-Id: <20210715163159.1480168-14-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715163159.1480168-1-maz@kernel.org>
References: <20210715163159.1480168-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com,
 dbrazdil@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org
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

Implement the previously defined ioremap/iounmap hooks for arm64,
calling into KVM's MMIO guard if available.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/mm/ioremap.c | 56 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index b7c81dacabf0..0801fd92f0e3 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -9,13 +9,69 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 
+#define pr_fmt(fmt)	"ioremap: " fmt
+
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/io.h>
+#include <linux/arm-smccc.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
+#include <asm/hypervisor.h>
+
+static DEFINE_STATIC_KEY_FALSE(ioremap_guard_key);
+
+void ioremap_page_range_hook(unsigned long addr, unsigned long end,
+			     phys_addr_t phys_addr, pgprot_t prot)
+{
+	size_t size = end - addr;
+
+	if (!static_branch_unlikely(&ioremap_guard_key))
+		return;
+
+	if (pfn_valid(__phys_to_pfn(phys_addr)))
+		return;
+
+	while (size) {
+		struct arm_smccc_res res;
+
+		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID,
+				  phys_addr, prot, &res);
+		if (res.a0 != SMCCC_RET_SUCCESS) {
+			pr_warn_ratelimited("Failed to register %llx\n",
+					    phys_addr);
+			return;
+		}
+
+		size -= PAGE_SIZE;
+		phys_addr += PAGE_SIZE;
+	}
+}
+
+void iounmap_page_range_hook(phys_addr_t phys_addr, size_t size)
+{
+	if (!static_branch_unlikely(&ioremap_guard_key))
+		return;
+
+	VM_BUG_ON(phys_addr & ~PAGE_MASK || size & ~PAGE_MASK);
+
+	while (size) {
+		struct arm_smccc_res res;
+
+		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID,
+				  phys_addr, &res);
+		if (res.a0 != SMCCC_RET_SUCCESS) {
+			pr_warn_ratelimited("Failed to unregister %llx\n",
+					    phys_addr);
+			return;
+		}
+
+		size -= PAGE_SIZE;
+		phys_addr += PAGE_SIZE;
+	}
+}
 
 static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
 				      pgprot_t prot, void *caller)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
