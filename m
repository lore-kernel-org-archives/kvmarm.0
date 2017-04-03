From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 05/34] arm64: hyp-stub: Update documentation in asm/virt.h
Date: Mon,  3 Apr 2017 19:37:38 +0100
Message-ID: <20170403183807.1620-6-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE05240A86
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OJkAV2FkSpar for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:36:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24B2C40BC4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:30 -0400 (EDT)
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

Comments in asm/virt.h are slightly out of date, so let's align
them with the new behaviour of the code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/virt.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 1466d14c664d..1569c3a0d794 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -19,9 +19,14 @@
 #define __ASM__VIRT_H
 
 /*
- * The arm64 hcall implementation uses x0 to specify the hcall type. A value
- * less than 0xfff indicates a special hcall, such as get/set vector.
- * Any other value is used as a pointer to the function to call.
+ * The arm64 hcall implementation uses x0 to specify the hcall
+ * number. A value less than HVC_STUB_HCALL_NR indicates a special
+ * hcall, such as set vector. Any other value is handled in a
+ * hypervisor specific way.
+ *
+ * The hypercall is allowed to clobber any of the caller-saved
+ * registers (x0-x18), so it is advisable to use it through the
+ * indirection of a function call (as implemented in hyp-stub.S).
  */
 
 /* HVC_GET_VECTORS - Return the value of the vbar_el2 register. */
-- 
2.11.0
