From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 01/27] arm64: Add a facility to turn an ESR syndrome into a sysreg encoding
Date: Fri,  9 Jun 2017 12:49:30 +0100
Message-ID: <20170609114956.25963-2-marc.zyngier@arm.com>
References: <20170609114956.25963-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170609114956.25963-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

It is often useful to compare an ESR syndrome reporting the trapping
of a system register with a value matching that system register.

Since encoding both the sysreg and the ESR version seem to be a bit
overkill, let's add a set of macros that convert an ESR value into
the corresponding sysreg encoding.

We handle both AArch32 and AArch64, taking advantage of identical
encodings between system registers and CP15 accessors.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/esr.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 85997c0e5443..e7d8e281ff62 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -19,6 +19,7 @@
 #define __ASM_ESR_H
 
 #include <asm/memory.h>
+#include <asm/sysreg.h>
 
 #define ESR_ELx_EC_UNKNOWN	(0x00)
 #define ESR_ELx_EC_WFx		(0x01)
@@ -181,6 +182,29 @@
 #define ESR_ELx_SYS64_ISS_SYS_CNTFRQ	(ESR_ELx_SYS64_ISS_SYS_VAL(3, 3, 0, 14, 0) | \
 					 ESR_ELx_SYS64_ISS_DIR_READ)
 
+#define esr_sys64_to_sysreg(e)					\
+	sys_reg((((e) & ESR_ELx_SYS64_ISS_OP0_MASK) >>		\
+		 ESR_ELx_SYS64_ISS_OP0_SHIFT),			\
+		(((e) & ESR_ELx_SYS64_ISS_OP1_MASK) >>		\
+		 ESR_ELx_SYS64_ISS_OP1_SHIFT),			\
+		(((e) & ESR_ELx_SYS64_ISS_CRN_MASK) >>		\
+		 ESR_ELx_SYS64_ISS_CRN_SHIFT),			\
+		(((e) & ESR_ELx_SYS64_ISS_CRM_MASK) >>		\
+		 ESR_ELx_SYS64_ISS_CRM_SHIFT),			\
+		(((e) & ESR_ELx_SYS64_ISS_OP2_MASK) >>		\
+		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
+
+#define esr_cp15_to_sysreg(e)					\
+	sys_reg(3,						\
+		(((e) & ESR_ELx_SYS64_ISS_OP1_MASK) >>		\
+		 ESR_ELx_SYS64_ISS_OP1_SHIFT),			\
+		(((e) & ESR_ELx_SYS64_ISS_CRN_MASK) >>		\
+		 ESR_ELx_SYS64_ISS_CRN_SHIFT),			\
+		(((e) & ESR_ELx_SYS64_ISS_CRM_MASK) >>		\
+		 ESR_ELx_SYS64_ISS_CRM_SHIFT),			\
+		(((e) & ESR_ELx_SYS64_ISS_OP2_MASK) >>		\
+		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
+
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 
-- 
2.11.0
