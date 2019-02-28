From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 01/13] KVM: arm64: add {read,
 write}_sysreg_elx_s versions for new registers
Date: Thu, 28 Feb 2019 16:07:23 +0000
Message-ID: <20190228160737.3323-2-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 402824A36D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eyNG7q40emWO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1518F4A379
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:03 -0500 (EST)
In-Reply-To: <20190228160737.3323-1-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

KVM provides {read,write}_sysreg_el1() to write to ${REG}_EL1 when we
really want to read/write to the EL1 register without any VHE register
redirection.

SPE registers are not supported by many versions of GAS. For this reason
we mostly use mrs_s macro which takes sys_reg() representation.

However these SPE registers using sys_reg representation doesn't work
well with existing {read,write}_sysreg_el1 macros. We need to add
{read,write}_sysreg_el1_s versions so cope up with them.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Hi,

There were alternatives proposed to this in the past[1]. I am happy
to that version and use it instead of this patch.

Regards,
Sudeep

[1] https://patchwork.kernel.org/patch/10435599/

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index a80a7ef57325..68c49f258729 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -34,6 +34,15 @@
 			     : "=r" (reg));				\
 		reg;							\
 	})
+#define read_sysreg_elx_s(r,nvh,vh)					\
+	({								\
+		u64 reg;						\
+		asm volatile(ALTERNATIVE("mrs_s %0, " __stringify(r##nvh),\
+					 "mrs_s %0, " __stringify(r##vh),\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+			     : "=r" (reg));				\
+		reg;							\
+	})
 
 #define write_sysreg_elx(v,r,nvh,vh)					\
 	do {								\
@@ -43,6 +52,14 @@
 					 ARM64_HAS_VIRT_HOST_EXTN)	\
 					 : : "rZ" (__val));		\
 	} while (0)
+#define write_sysreg_elx_s(v,r,nvh,vh)					\
+	do {								\
+		u64 __val = (u64)(v);					\
+		asm volatile(ALTERNATIVE("msr_s " __stringify(r##nvh) ", %x0",\
+					 "msr_s " __stringify(r##vh) ", %x0",\
+					 ARM64_HAS_VIRT_HOST_EXTN)	\
+					 : : "rZ" (__val));		\
+	} while (0)
 
 /*
  * Unified accessors for registers that have a different encoding
@@ -71,7 +88,9 @@
 #define read_sysreg_el0(r)	read_sysreg_elx(r, _EL0, _EL02)
 #define write_sysreg_el0(v,r)	write_sysreg_elx(v, r, _EL0, _EL02)
 #define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
+#define read_sysreg_el1_s(r)	read_sysreg_elx_s(r, _EL1, _EL12)
 #define write_sysreg_el1(v,r)	write_sysreg_elx(v, r, _EL1, _EL12)
+#define write_sysreg_el1_s(v,r)	write_sysreg_elx_s(v, r, _EL1, _EL12)
 
 /* The VHE specific system registers and their encoding */
 #define sctlr_EL12              sys_reg(3, 5, 1, 0, 0)
-- 
2.17.1
