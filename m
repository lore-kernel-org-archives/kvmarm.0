From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 08/18] arm/arm64: KVM: Export __hyp_text_start/end symbols
Date: Thu, 30 Jun 2016 18:40:41 +0100
Message-ID: <1467308451-13365-9-git-send-email-marc.zyngier@arm.com>
References: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2D6E49B94
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QCOWgxXOQVwd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 13:35:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B8549B96
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:50 -0400 (EDT)
In-Reply-To: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Declare the __hyp_text_start/end symbols in asm/virt.h so that
they can be reused without having to declare them locally.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/virt.h   | 4 ++++
 arch/arm/kvm/mmu.c            | 2 --
 arch/arm64/include/asm/virt.h | 4 ++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index d4ceaf5..a2e75b8 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -80,6 +80,10 @@ static inline bool is_kernel_in_hyp_mode(void)
 	return false;
 }
 
+/* The section containing the hypervisor idmap text */
+extern char __hyp_idmap_text_start[];
+extern char __hyp_idmap_text_end[];
+
 /* The section containing the hypervisor text */
 extern char __hyp_text_start[];
 extern char __hyp_text_end[];
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 679608f..f004e70 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -32,8 +32,6 @@
 
 #include "trace.h"
 
-extern char  __hyp_idmap_text_start[], __hyp_idmap_text_end[];
-
 static pgd_t *boot_hyp_pgd;
 static pgd_t *hyp_pgd;
 static pgd_t *merged_hyp_pgd;
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index dcbcf8d..88aa8ec 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -82,6 +82,10 @@ extern void verify_cpu_run_el(void);
 static inline void verify_cpu_run_el(void) {}
 #endif
 
+/* The section containing the hypervisor idmap text */
+extern char __hyp_idmap_text_start[];
+extern char __hyp_idmap_text_end[];
+
 /* The section containing the hypervisor text */
 extern char __hyp_text_start[];
 extern char __hyp_text_end[];
-- 
2.1.4
