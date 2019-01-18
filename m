From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 05/12] arm64: Correct ARM64_CORE_REG() size encodings for
 all core registers
Date: Fri, 18 Jan 2019 16:14:14 +0000
Message-ID: <1547828061-20462-6-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 989134A3C5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zlGaIstshbVd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 11:15:27 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3393A4A3D2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:26 -0500 (EST)
In-Reply-To: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

ARM64_CORE_REG() is currently only used to generate the KVM
register IDs for registers that happen to be 64 bits in size, so
KVM_REG_SIZE_U64 is hard-coded in the definition.

To enable this macro to generate correct encodings for the FPSIMD
registers too (which are a mix of 128-bit and 32-bit registers),
this patch extends the macro to encode the correct size for each
class of register in KVM_REG_ARM_CORE.

The approach is crude, but because the KVM_REG_ARM_CORE ID
arrangement is ABI, it's not expected to evolve.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arm/aarch64/kvm-cpu.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 1b29374..0aaefaf 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -12,8 +12,21 @@
 #define SCTLR_EL1_E0E_MASK	(1 << 24)
 #define SCTLR_EL1_EE_MASK	(1 << 25)
 
-#define ARM64_CORE_REG(x)	(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
-				 KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
+static __u64 __core_reg_id(__u64 offset)
+{
+	__u64 id = KVM_REG_ARM64 | KVM_REG_ARM_CORE | offset;
+
+	if (offset < KVM_REG_ARM_CORE_REG(fp_regs))
+		id |= KVM_REG_SIZE_U64;
+	else if (offset < KVM_REG_ARM_CORE_REG(fp_regs.fpsr))
+		id |= KVM_REG_SIZE_U128;
+	else
+		id |= KVM_REG_SIZE_U32;
+
+	return id;
+}
+
+#define ARM64_CORE_REG(x) __core_reg_id(KVM_REG_ARM_CORE_REG(x))
 
 unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu)
 {
-- 
2.1.4
