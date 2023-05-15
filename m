Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0F51FBE
	for <kvmarm@lists.linux.dev>; Mon, 15 May 2023 22:15:34 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D8112F4;
	Mon, 15 May 2023 15:16:18 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 204BB3F840;
	Mon, 15 May 2023 15:15:33 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: luc.maranget@inria.fr
Subject: [kvm-unit-tests PATCH] arm64: Make vector_table and vector_stub weak symbols
Date: Mon, 15 May 2023 23:15:17 +0100
Message-Id: <20230515221517.646549-1-nikos.nikoleris@arm.com>
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
taking control of the whole vector_table or a vector_stub.

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

