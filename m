From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v7 01/27] KVM: Documentation: Document arm64 core registers in
 detail
Date: Fri, 29 Mar 2019 13:00:26 +0000
Message-ID: <1553864452-15080-2-git-send-email-Dave.Martin@arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F22464A380
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:01:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ag1z08SiozUZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Mar 2019 09:01:42 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D20C64A2E9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:01:42 -0400 (EDT)
In-Reply-To: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Since the the sizes of individual members of the core arm64
registers vary, the list of register encodings that make sense is
not a simple linear sequence.

To clarify which encodings to use, this patch adds a brief list
to the documentation.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Grall <julien.grall@arm.com>
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
---
 Documentation/virtual/kvm/api.txt | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 7de9eee..2d4f7ce 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2107,6 +2107,30 @@ contains elements ranging from 32 to 128 bits. The index is a 32bit
 value in the kvm_regs structure seen as a 32bit array.
   0x60x0 0000 0010 <index into the kvm_regs struct:16>
 
+Specifically:
+    Encoding            Register  Bits  kvm_regs member
+----------------------------------------------------------------
+  0x6030 0000 0010 0000 X0          64  regs.regs[0]
+  0x6030 0000 0010 0002 X1          64  regs.regs[1]
+    ...
+  0x6030 0000 0010 003c X30         64  regs.regs[30]
+  0x6030 0000 0010 003e SP          64  regs.sp
+  0x6030 0000 0010 0040 PC          64  regs.pc
+  0x6030 0000 0010 0042 PSTATE      64  regs.pstate
+  0x6030 0000 0010 0044 SP_EL1      64  sp_el1
+  0x6030 0000 0010 0046 ELR_EL1     64  elr_el1
+  0x6030 0000 0010 0048 SPSR_EL1    64  spsr[KVM_SPSR_EL1] (alias SPSR_SVC)
+  0x6030 0000 0010 004a SPSR_ABT    64  spsr[KVM_SPSR_ABT]
+  0x6030 0000 0010 004c SPSR_UND    64  spsr[KVM_SPSR_UND]
+  0x6030 0000 0010 004e SPSR_IRQ    64  spsr[KVM_SPSR_IRQ]
+  0x6060 0000 0010 0050 SPSR_FIQ    64  spsr[KVM_SPSR_FIQ]
+  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]
+  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]
+    ...
+  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]
+  0x6020 0000 0010 00d4 FPSR        32  fp_regs.fpsr
+  0x6020 0000 0010 00d5 FPCR        32  fp_regs.fpcr
+
 arm64 CCSIDR registers are demultiplexed by CSSELR value:
   0x6020 0000 0011 00 <csselr:8>
 
-- 
2.1.4
