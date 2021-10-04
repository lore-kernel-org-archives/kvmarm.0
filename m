Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951A6C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:56:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F7CD61247
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 17:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0F7CD61247
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A50634B26D;
	Mon,  4 Oct 2021 13:56:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YKC+-xNgv9rL; Mon,  4 Oct 2021 13:56:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A10064B299;
	Mon,  4 Oct 2021 13:56:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85C1A4B268
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:56:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KT3bg101RIsY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 13:56:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C2194B250
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 13:56:51 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5AC1A61207;
 Mon,  4 Oct 2021 17:56:50 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mXS5H-00EhBv-I3; Mon, 04 Oct 2021 18:49:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/16] mm/vmalloc: Add arch-specific callbacks to track
 io{remap, unmap} physical pages
Date: Mon,  4 Oct 2021 18:48:45 +0100
Message-Id: <20211004174849.2831548-13-maz@kernel.org>
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

Add a pair of hooks (ioremap_phys_range_hook/iounmap_phys_range_hook)
that can be implemented by an architecture. Contrary to the existing
arch_sync_kernel_mappings(), this one tracks things at the physical
address level.

This is specially useful in these virtualised environments where
the guest has to tell the host whether (and how) it intends to use
a MMIO device.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/io.h |  2 ++
 mm/Kconfig         |  5 +++++
 mm/vmalloc.c       | 12 +++++++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/io.h b/include/linux/io.h
index 9595151d800d..84eac81e8834 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -21,6 +21,8 @@ void __ioread32_copy(void *to, const void __iomem *from, size_t count);
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
 #ifdef CONFIG_MMU
+void ioremap_phys_range_hook(phys_addr_t phys_addr, size_t size, pgprot_t prot);
+void iounmap_phys_range_hook(phys_addr_t phys_addr, size_t size);
 int ioremap_page_range(unsigned long addr, unsigned long end,
 		       phys_addr_t phys_addr, pgprot_t prot);
 #else
diff --git a/mm/Kconfig b/mm/Kconfig
index d16ba9249bc5..a154803836b7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -894,6 +894,11 @@ config IO_MAPPING
 config SECRETMEM
 	def_bool ARCH_HAS_SET_DIRECT_MAP && !EMBEDDED
 
+# Some architectures want callbacks for all IO mappings in order to
+# track the physical addresses that get used as devices.
+config ARCH_HAS_IOREMAP_PHYS_HOOKS
+	bool
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d77830ff604c..babcf3a75502 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -38,6 +38,7 @@
 #include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <linux/hugetlb.h>
+#include <linux/io.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
@@ -316,9 +317,14 @@ int ioremap_page_range(unsigned long addr, unsigned long end,
 {
 	int err;
 
-	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
+	prot = pgprot_nx(prot);
+	err = vmap_range_noflush(addr, end, phys_addr, prot,
 				 ioremap_max_page_shift);
 	flush_cache_vmap(addr, end);
+
+	if (IS_ENABLED(CONFIG_ARCH_HAS_IOREMAP_PHYS_HOOKS) && !err)
+		ioremap_phys_range_hook(phys_addr, end - addr, prot);
+
 	return err;
 }
 
@@ -2608,6 +2614,10 @@ static void __vunmap(const void *addr, int deallocate_pages)
 
 	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
 
+	if (IS_ENABLED(CONFIG_ARCH_HAS_IOREMAP_PHYS_HOOKS) &&
+	    area->flags & VM_IOREMAP)
+		iounmap_phys_range_hook(area->phys_addr, get_vm_area_size(area));
+
 	vm_remove_mappings(area, deallocate_pages);
 
 	if (deallocate_pages) {
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
