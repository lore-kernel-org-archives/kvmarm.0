Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4701AC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:57:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F421461213
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F421461213
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8E4D4B2C4;
	Mon,  4 Oct 2021 13:57:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YerkZSoubiP6; Mon,  4 Oct 2021 13:57:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B17F4B2B3;
	Mon,  4 Oct 2021 13:57:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F5E14B2AE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:57:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xL6uQDcL3Ii1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 13:57:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 510D94B2B3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:57:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9F44E6124D;
 Mon,  4 Oct 2021 17:57:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mXS5H-00EhBv-TR; Mon, 04 Oct 2021 18:49:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/16] arm64: Implement ioremap/iounmap hooks calling into
 KVM's MMIO guard
Date: Mon,  4 Oct 2021 18:48:46 +0100
Message-Id: <20211004174849.2831548-14-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com,
 dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com,
 tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
 Steven Price <steven.price@arm.com>,
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
 arch/arm64/mm/ioremap.c | 112 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index b7c81dacabf0..5334cbdc9f64 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -9,13 +9,125 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 
+#define pr_fmt(fmt)	"ioremap: " fmt
+
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/arm-smccc.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
+#include <asm/hypervisor.h>
+
+struct ioremap_guard_ref {
+	refcount_t	count;
+};
+
+static DEFINE_STATIC_KEY_FALSE(ioremap_guard_key);
+static DEFINE_XARRAY(ioremap_guard_array);
+static DEFINE_MUTEX(ioremap_guard_lock);
+
+void ioremap_phys_range_hook(phys_addr_t phys_addr, size_t size, pgprot_t prot)
+{
+	if (!static_branch_unlikely(&ioremap_guard_key))
+		return;
+
+	if (pfn_valid(__phys_to_pfn(phys_addr)))
+		return;
+
+	mutex_lock(&ioremap_guard_lock);
+
+	while (size) {
+		u64 pfn = phys_addr >> PAGE_SHIFT;
+		struct ioremap_guard_ref *ref;
+		struct arm_smccc_res res;
+
+		ref = xa_load(&ioremap_guard_array, pfn);
+		if (ref) {
+			refcount_inc(&ref->count);
+			goto next;
+		}
+
+		/*
+		 * It is acceptable for the allocation to fail, specially
+		 * if trying to ioremap something very early on, like with
+		 * earlycon, which happens long before kmem_cache_init.
+		 * This page will be permanently accessible, similar to a
+		 * saturated refcount.
+		 */
+		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
+		if (ref) {
+			refcount_set(&ref->count, 1);
+			if (xa_err(xa_store(&ioremap_guard_array, pfn, ref,
+					    GFP_KERNEL))) {
+				kfree(ref);
+				ref = NULL;
+			}
+		}
+
+		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID,
+				  phys_addr, prot, &res);
+		if (res.a0 != SMCCC_RET_SUCCESS) {
+			pr_warn_ratelimited("Failed to register %llx\n",
+					    phys_addr);
+			xa_erase(&ioremap_guard_array, pfn);
+			kfree(ref);
+			goto out;
+		}
+
+	next:
+		size -= PAGE_SIZE;
+		phys_addr += PAGE_SIZE;
+	}
+out:
+	mutex_unlock(&ioremap_guard_lock);
+}
+
+void iounmap_phys_range_hook(phys_addr_t phys_addr, size_t size)
+{
+	if (!static_branch_unlikely(&ioremap_guard_key))
+		return;
+
+	VM_BUG_ON(phys_addr & ~PAGE_MASK || size & ~PAGE_MASK);
+
+	mutex_lock(&ioremap_guard_lock);
+
+	while (size) {
+		u64 pfn = phys_addr >> PAGE_SHIFT;
+		struct ioremap_guard_ref *ref;
+		struct arm_smccc_res res;
+
+		ref = xa_load(&ioremap_guard_array, pfn);
+		if (!ref) {
+			pr_warn_ratelimited("%llx not tracked, left mapped\n",
+					    phys_addr);
+			goto next;
+		}
+
+		if (!refcount_dec_and_test(&ref->count))
+			goto next;
+
+		xa_erase(&ioremap_guard_array, pfn);
+		kfree(ref);
+
+		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID,
+				  phys_addr, &res);
+		if (res.a0 != SMCCC_RET_SUCCESS) {
+			pr_warn_ratelimited("Failed to unregister %llx\n",
+					    phys_addr);
+			goto out;
+		}
+
+	next:
+		size -= PAGE_SIZE;
+		phys_addr += PAGE_SIZE;
+	}
+out:
+	mutex_unlock(&ioremap_guard_lock);
+}
 
 static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
 				      pgprot_t prot, void *caller)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
