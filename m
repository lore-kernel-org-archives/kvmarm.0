From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5/5] arm/arm64: KVM: Make default HYP mappings non-excutable
Date: Mon, 13 Jun 2016 15:00:49 +0100
Message-ID: <1465826449-14349-6-git-send-email-marc.zyngier@arm.com>
References: <1465826449-14349-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD96412D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2016 09:57:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q0Az1Awloe57 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jun 2016 09:56:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1961649B3D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2016 09:56:54 -0400 (EDT)
In-Reply-To: <1465826449-14349-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Structures that can be generally written to don't have any requirement
to be executable (quite the opposite). This includes the kvm and vcpu
structures, as well as the stacks.

Let's change the default to incorporate the XN flag.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/pgtable.h        | 2 +-
 arch/arm64/include/asm/pgtable-prot.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 7487bf9..e0d76ba 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -97,7 +97,7 @@ extern pgprot_t		pgprot_s2_device;
 #define PAGE_READONLY_EXEC	_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_RDONLY)
 #define PAGE_KERNEL		_MOD_PROT(pgprot_kernel, L_PTE_XN)
 #define PAGE_KERNEL_EXEC	pgprot_kernel
-#define PAGE_HYP		_MOD_PROT(pgprot_kernel, L_PTE_HYP)
+#define PAGE_HYP		_MOD_PROT(pgprot_kernel, L_PTE_HYP | L_PTE_XN)
 #define PAGE_HYP_EXEC		_MOD_PROT(pgprot_kernel, L_PTE_HYP | L_PTE_RDONLY)
 #define PAGE_HYP_RO		_MOD_PROT(pgprot_kernel, L_PTE_HYP | L_PTE_RDONLY | L_PTE_XN)
 #define PAGE_HYP_DEVICE		_MOD_PROT(pgprot_hyp_device, L_PTE_HYP)
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 3802048..39f5252 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -55,7 +55,7 @@
 #define PAGE_KERNEL_EXEC	__pgprot(_PAGE_DEFAULT | PTE_UXN | PTE_DIRTY | PTE_WRITE)
 #define PAGE_KERNEL_EXEC_CONT	__pgprot(_PAGE_DEFAULT | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_CONT)
 
-#define PAGE_HYP		__pgprot(_PAGE_DEFAULT | PTE_HYP)
+#define PAGE_HYP		__pgprot(_PAGE_DEFAULT | PTE_HYP | PTE_HYP_XN)
 #define PAGE_HYP_EXEC		__pgprot(_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY)
 #define PAGE_HYP_RO		__pgprot(_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY | PTE_HYP_XN)
 #define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
-- 
2.1.4
