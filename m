From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 27/28] arm/arm64: KVM: Add ARM_EXCEPTION_IS_TRAP macro
Date: Wed, 19 Dec 2018 18:03:48 +0000
Message-ID: <20181219180349.242681-28-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 365B14A33F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vcDm4biaVt27 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:05:25 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 042864A388
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:25 -0500 (EST)
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

32 and 64bit use different symbols to identify the traps.
32bit has a fine grained approach (prefetch abort, data abort and HVC),
while 64bit is pretty happy with just "trap".

This has been fine so far, except that we now need to decode some
of that in tracepoints that are common to both architectures.

Introduce ARM_EXCEPTION_IS_TRAP which abstracts the trap symbols
and make the tracepoint use it.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_asm.h   | 4 ++++
 arch/arm64/include/asm/kvm_asm.h | 1 +
 virt/kvm/arm/trace.h             | 2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 231e87ad45d5..35491af87985 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -23,6 +23,10 @@
 
 #define ARM_EXIT_WITH_ABORT_BIT  31
 #define ARM_EXCEPTION_CODE(x)	  ((x) & ~(1U << ARM_EXIT_WITH_ABORT_BIT))
+#define ARM_EXCEPTION_IS_TRAP(x)					\
+	(ARM_EXCEPTION_CODE((x)) == ARM_EXCEPTION_PREF_ABORT	||	\
+	 ARM_EXCEPTION_CODE((x)) == ARM_EXCEPTION_DATA_ABORT	||	\
+	 ARM_EXCEPTION_CODE((x)) == ARM_EXCEPTION_HVC)
 #define ARM_ABORT_PENDING(x)	  !!((x) & (1U << ARM_EXIT_WITH_ABORT_BIT))
 
 #define ARM_EXCEPTION_RESET	  0
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index b2e12c99db7d..f5b79e995f40 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -25,6 +25,7 @@
 
 #define ARM_EXIT_WITH_SERROR_BIT  31
 #define ARM_EXCEPTION_CODE(x)	  ((x) & ~(1U << ARM_EXIT_WITH_SERROR_BIT))
+#define ARM_EXCEPTION_IS_TRAP(x)  (ARM_EXCEPTION_CODE((x)) == ARM_EXCEPTION_TRAP)
 #define ARM_SERROR_PENDING(x)	  !!((x) & (1U << ARM_EXIT_WITH_SERROR_BIT))
 
 #define ARM_EXCEPTION_IRQ	  0
diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index f21f04f8036d..3828beab93f2 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -37,7 +37,7 @@ TRACE_EVENT(kvm_exit,
 
 	TP_fast_assign(
 		__entry->ret			= ARM_EXCEPTION_CODE(ret);
-		__entry->esr_ec = (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_TRAP) ? esr_ec : 0;
+		__entry->esr_ec = ARM_EXCEPTION_IS_TRAP(ret) ? esr_ec : 0;
 		__entry->vcpu_pc		= vcpu_pc;
 	),
 
-- 
2.19.2
