From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: [kvm-unit-tests PATCH V2 1/2] arm/arm64: add GICD_IIDR definition
Date: Tue, 19 Dec 2017 20:34:44 -0500
Message-ID: <1513733685-32573-2-git-send-email-shihwei@cs.columbia.edu>
References: <1513733685-32573-1-git-send-email-shihwei@cs.columbia.edu>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1513733685-32573-1-git-send-email-shihwei@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, drjones@redhat.com, pbonzini@redhat.com, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Added the definition of GICD_IIDR for later use in micro test.

Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
---
 lib/arm/asm/gic.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 2eb4af8..3b9982b 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -10,6 +10,7 @@
 /* Distributor registers */
 #define GICD_CTLR			0x0000
 #define GICD_TYPER			0x0004
+#define GICD_IIDR			0x0008
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
 #define GICD_ISPENDR			0x0200
-- 
1.9.1
