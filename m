Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A51C19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F1E94C4CB;
	Tue,  9 Aug 2022 05:15:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P+saC5KdV-rM; Tue,  9 Aug 2022 05:15:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 907B94C99A;
	Tue,  9 Aug 2022 05:15:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 736C44C9DF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eg2bh9bkl9oF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26FB54C460
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7684623A;
 Tue,  9 Aug 2022 02:15:43 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95B303F67D;
 Tue,  9 Aug 2022 02:15:41 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 11/19] arm/arm64: Map the UART when
 creating the translation tables
Date: Tue,  9 Aug 2022 10:15:50 +0100
Message-Id: <20220809091558.14379-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
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

The MMU is now enabled before the UART is probed, which leaves
kvm-unit-tests with a window where attempting to write to the console
results in an infinite data abort loop triggered by the exception
handlers themselves trying to use the console. Get around this by
mapping the UART early address when creating the translation tables.

Note that the address remains mapped even if the devicetree address is
different.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/io.c  | 5 +++++
 lib/arm/io.h  | 3 +++
 lib/arm/mmu.c | 8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index 343e10822263..c2c3edb563a0 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -73,6 +73,11 @@ static void uart0_init(void)
 	}
 }
 
+void __iomem *io_uart_early_base(void)
+{
+	return UART_EARLY_BASE;
+}
+
 void io_init(void)
 {
 	uart0_init();
diff --git a/lib/arm/io.h b/lib/arm/io.h
index 183479c899a9..24704d8fe0a4 100644
--- a/lib/arm/io.h
+++ b/lib/arm/io.h
@@ -7,6 +7,9 @@
 #ifndef _ARM_IO_H_
 #define _ARM_IO_H_
 
+#include <asm/io.h>
+
 extern void io_init(void);
+extern void __iomem *io_uart_early_base(void);
 
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 7765d47dc27a..19c98a8a9640 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -15,6 +15,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 
+#include "io.h"
 #include "vmalloc.h"
 
 #include <linux/compiler.h>
@@ -155,6 +156,8 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 void mmu_setup_early(phys_addr_t unused0, void *unused1)
 {
 	struct mem_region *r;
+	pgprot_t uart_prot;
+	void *uart_base;
 
 	assert(!mmu_enabled() && !page_alloc_initialized());
 
@@ -178,6 +181,11 @@ void mmu_setup_early(phys_addr_t unused0, void *unused1)
 		}
 	}
 
+	uart_base = io_uart_early_base();
+	uart_prot = __pgprot(PTE_UNCACHED | PTE_USER | PTE_UXN | PTE_PXN);
+	install_page_prot(mmu_idmap, (phys_addr_t)(unsigned long)uart_base,
+			  (uintptr_t)uart_base, uart_prot);
+
 	asm_mmu_enable((phys_addr_t)(unsigned long)mmu_idmap);
 }
 
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
