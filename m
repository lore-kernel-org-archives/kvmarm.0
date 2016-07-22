From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/55] arm64: Add PTE_HYP_XN page table flag
Date: Fri, 22 Jul 2016 18:28:19 +0100
Message-ID: <1469208552-4155-3-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Dan Carpenter <dan.carpenter@oracle.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

EL2 page tables can be configured to deny code from being
executed, which is done by setting bit 54 in the page descriptor.

It is the same bit as PTE_UXN, but the "USER" reference felt odd
in the hypervisor code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/pgtable-hwdef.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 2813748..c3ae239 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -164,6 +164,7 @@
 #define PTE_CONT		(_AT(pteval_t, 1) << 52)	/* Contiguous range */
 #define PTE_PXN			(_AT(pteval_t, 1) << 53)	/* Privileged XN */
 #define PTE_UXN			(_AT(pteval_t, 1) << 54)	/* User XN */
+#define PTE_HYP_XN		(_AT(pteval_t, 1) << 54)	/* HYP XN */
 
 /*
  * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
-- 
2.8.1

