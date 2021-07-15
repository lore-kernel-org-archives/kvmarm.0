Return-Path: <SRS0=OVIf=MH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C9EC07E96
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 16:54:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A36E4613F9
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 16:54:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A36E4613F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55C824B0C2;
	Thu, 15 Jul 2021 12:54:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RadzEWmsXZPc; Thu, 15 Jul 2021 12:54:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42AF54B098;
	Thu, 15 Jul 2021 12:54:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0BA4B08A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 12:54:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kFT-gpxvWJVC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jul 2021 12:54:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B5CB4B090
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 12:54:07 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4B8456128D;
 Thu, 15 Jul 2021 16:54:06 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m44Ha-00DYjr-Ou; Thu, 15 Jul 2021 17:32:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] mm/ioremap: Add arch-specific callbacks on
 ioremap/iounmap calls
Date: Thu, 15 Jul 2021 17:31:55 +0100
Message-Id: <20210715163159.1480168-13-maz@kernel.org>
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

Add a pair of hooks (ioremap_page_range_hook/iounmap_page_range_hook)
that can be implemented by an architecture.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/io.h |  3 +++
 mm/ioremap.c       | 13 ++++++++++++-
 mm/vmalloc.c       |  8 ++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/io.h b/include/linux/io.h
index 9595151d800d..0ffc265f114c 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -21,6 +21,9 @@ void __ioread32_copy(void *to, const void __iomem *from, size_t count);
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
 #ifdef CONFIG_MMU
+void ioremap_page_range_hook(unsigned long addr, unsigned long end,
+			     phys_addr_t phys_addr, pgprot_t prot);
+void iounmap_page_range_hook(phys_addr_t phys_addr, size_t size);
 int ioremap_page_range(unsigned long addr, unsigned long end,
 		       phys_addr_t phys_addr, pgprot_t prot);
 #else
diff --git a/mm/ioremap.c b/mm/ioremap.c
index 8ee0136f8cb0..bd77a86088f2 100644
--- a/mm/ioremap.c
+++ b/mm/ioremap.c
@@ -28,10 +28,21 @@ early_param("nohugeiomap", set_nohugeiomap);
 static const unsigned int iomap_max_page_shift = PAGE_SHIFT;
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
+void __weak ioremap_page_range_hook(unsigned long addr, unsigned long end,
+				    phys_addr_t phys_addr, pgprot_t prot)
+{
+}
+
 int ioremap_page_range(unsigned long addr,
 		       unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
 {
-	return vmap_range(addr, end, phys_addr, prot, iomap_max_page_shift);
+	int ret;
+
+	ret = vmap_range(addr, end, phys_addr, prot, iomap_max_page_shift);
+	if (!ret)
+		ioremap_page_range_hook(addr, end, phys_addr, prot);
+
+	return ret;
 }
 
 #ifdef CONFIG_GENERIC_IOREMAP
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d5cd52805149..af18a6141093 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -38,6 +38,7 @@
 #include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <linux/hugetlb.h>
+#include <linux/io.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
@@ -2551,6 +2552,10 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 	set_area_direct_map(area, set_direct_map_default_noflush);
 }
 
+void __weak iounmap_page_range_hook(phys_addr_t phys_addr, size_t size)
+{
+}
+
 static void __vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
@@ -2574,6 +2579,9 @@ static void __vunmap(const void *addr, int deallocate_pages)
 
 	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
 
+	if (area->flags & VM_IOREMAP)
+		iounmap_page_range_hook(area->phys_addr, get_vm_area_size(area));
+
 	vm_remove_mappings(area, deallocate_pages);
 
 	if (deallocate_pages) {
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
