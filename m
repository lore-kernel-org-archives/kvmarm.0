From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 19/28] KVM: arm/arm64: Fixup the kvm_exit tracepoint
Date: Wed, 19 Dec 2018 18:03:40 +0000
Message-ID: <20181219180349.242681-20-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BA004A378
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rfqZ1w0djtmb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:05:02 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9B094A398
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:02 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

The kvm_exit tracepoint strangely always reported exits as being IRQs.
This seems to be because either the __print_symbolic or the tracepoint
macros use a variable named idx.

Take this chance to update the fields in the tracepoint to reflect the
concepts in the arm64 architecture that we pass to the tracepoint and
move the exception type table to the same location and header files as
the exits code.

We also clear out the exception code to 0 for IRQ exits (which
translates to UNKNOWN in text) to make it slighyly less confusing to
parse the trace output.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |  4 ----
 arch/arm64/include/asm/kvm_asm.h |  6 ++++++
 virt/kvm/arm/trace.h             | 18 +++++++++---------
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 6f602af5263c..9921bb7ab6d8 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -320,10 +320,6 @@
 #define PAR_TO_HPFAR(par)		\
 	(((par) & GENMASK_ULL(PHYS_MASK_SHIFT - 1, 12)) >> 8)
 
-#define kvm_arm_exception_type	\
-	{0, "IRQ" }, 		\
-	{1, "TRAP" }
-
 #define ECN(x) { ESR_ELx_EC_##x, #x }
 
 #define kvm_arm_exception_class \
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index aea01a09eb94..b2e12c99db7d 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -34,6 +34,12 @@
 /* The hyp-stub will return this for any kvm_call_hyp() call */
 #define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 
+#define kvm_arm_exception_type					\
+	{ARM_EXCEPTION_IRQ,		"IRQ"		},	\
+	{ARM_EXCEPTION_EL1_SERROR, 	"SERROR"	},	\
+	{ARM_EXCEPTION_TRAP, 		"TRAP"		},	\
+	{ARM_EXCEPTION_HYP_GONE,	"HYP_GONE"	}
+
 #ifndef __ASSEMBLY__
 
 #include <linux/mm.h>
diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index 57b3edebbb40..f21f04f8036d 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -26,25 +26,25 @@ TRACE_EVENT(kvm_entry,
 );
 
 TRACE_EVENT(kvm_exit,
-	TP_PROTO(int idx, unsigned int exit_reason, unsigned long vcpu_pc),
-	TP_ARGS(idx, exit_reason, vcpu_pc),
+	TP_PROTO(int ret, unsigned int esr_ec, unsigned long vcpu_pc),
+	TP_ARGS(ret, esr_ec, vcpu_pc),
 
 	TP_STRUCT__entry(
-		__field(	int,		idx		)
-		__field(	unsigned int,	exit_reason	)
+		__field(	int,		ret		)
+		__field(	unsigned int,	esr_ec		)
 		__field(	unsigned long,	vcpu_pc		)
 	),
 
 	TP_fast_assign(
-		__entry->idx			= idx;
-		__entry->exit_reason		= exit_reason;
+		__entry->ret			= ARM_EXCEPTION_CODE(ret);
+		__entry->esr_ec = (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_TRAP) ? esr_ec : 0;
 		__entry->vcpu_pc		= vcpu_pc;
 	),
 
 	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
-		  __print_symbolic(__entry->idx, kvm_arm_exception_type),
-		  __entry->exit_reason,
-		  __print_symbolic(__entry->exit_reason, kvm_arm_exception_class),
+		  __print_symbolic(__entry->ret, kvm_arm_exception_type),
+		  __entry->esr_ec,
+		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class),
 		  __entry->vcpu_pc)
 );
 
-- 
2.19.2
