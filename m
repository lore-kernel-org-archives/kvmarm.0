From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 27/58] arm64: Add a facility to turn an ESR syndrome into a
 sysreg encoding
Date: Fri, 30 Jun 2017 09:44:43 +0100
Message-ID: <20170630084514.6779-28-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C076C40D16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7LGLh60B6znd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:46:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4630240DF9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:42 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Signed-off-by: Christoffer Dall <cdall@linaro.org>
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
