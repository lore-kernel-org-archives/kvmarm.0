Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8033B1EA7E
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 13:53:33 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B26822F4;
	Tue, 23 May 2023 06:54:17 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20C343F840;
	Tue, 23 May 2023 06:53:32 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Subject: [kvm-unit-tests PATCH v2] arm64: Make vector_table and vector_stub weak symbols
Date: Tue, 23 May 2023 14:53:25 +0100
Message-Id: <20230523135325.1081036-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit

This changes allows a test to define and override the declared symbols,
taking control of all or some execptions.

With the ability to override specific exception handlers, litmus7 [1] a
tool used to generate c sources for a given memory model litmus test,
can override the el1h_sync symbol to implement tests with explicit
exception handlers. For example:

AArch64 LDRv0+I2V-dsb.ishst-once
{
  [PTE(x)]=(oa:PA(x),valid:0);
  x=1;

  0:X1=x;
  0:X3=PTE(x);
  0:X2=(oa:PA(x),valid:1);
}
 P0          | P0.F           ;
L0:          | ADD X8,X8,#1   ;
 LDR W0,[X1] | STR X2,[X3]    ;
             | DSB ISHST      ;
             | ADR X9,L0      ;
             | MSR ELR_EL1,X9 ;
             | ERET           ;
exists(0:X0=0 \/ 0:X8!=1)

In this test, a thread running in core P0 executes a load to a memory
location x. The PTE of the virtual address x is initially invalid.  The
execution of the load causes a synchronous EL1 exception which is
handled by the code in P0.F. P0.F increments a counter which is
maintained in X8, updates the PTE of x and makes it valid, executes a
DSB ISHST and calls ERET which is expected to return and retry the
execution of the load in P0:L0.

The postcondition checks if there is any execution where the load wasn't
executed (X0 its destination register is not update), or that the P0.F
handler was invoked more than once (the counter X8 is not 1).

For this tests, litmus7 needs to control the el1h_sync. Calling
install_exception_handler() would be suboptimal because the
vector_stub would wrap around the code of P0.F and perturb the test.

[1]: https://diy.inria.fr/doc/litmus.html

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/cstart64.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index e4ab7d06..eda0daa5 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -275,8 +275,11 @@ exceptions_init:
 /*
  * Vector stubs
  * Adapted from arch/arm64/kernel/entry.S
+ * Declare as weak to allow external tests to redefine and override a
+ * vector_stub.
  */
 .macro vector_stub, name, vec
+.weak \name
 \name:
 	stp	 x0,  x1, [sp, #-S_FRAME_SIZE]!
 	stp	 x2,  x3, [sp,  #16]
@@ -369,7 +372,13 @@ vector_stub	el0_error_32, 15
 	b	\label
 .endm
 
+
+/*
+ * Declare as weak to allow external tests to redefine and override the
+ * default vector table.
+ */
 .align 11
+.weak vector_table
 vector_table:
 	ventry	el1t_sync			// Synchronous EL1t
 	ventry	el1t_irq			// IRQ EL1t
-- 
2.25.1

