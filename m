From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 80/85] KVM: arm: Reserve bit in KVM_REG_ARM encoding for
 secure/nonsecure
Date: Wed, 28 Mar 2018 13:52:49 +0100
Message-ID: <20180328125254.31380-81-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0D14A0EA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 09:02:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kAJHo3Qcg9sD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 09:02:07 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AE0C401CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:26 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Peter Maydell <peter.maydell@linaro.org>

We have a KVM_REG_ARM encoding that we use to expose KVM guest registers
to userspace. Define that bit 28 in this encoding indicates secure vs
nonsecure, so we can distinguish the secure and nonsecure banked versions
of a banked AArch32 register.

For KVM currently, all guest registers are nonsecure, but defining
the bit is useful for userspace. In particular, QEMU uses this
encoding as part of its on-the-wire migration format, and needs to be
able to describe secure-bank registers when it is migrating (fully
emulated) EL3-enabled CPUs.

Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/uapi/asm/kvm.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 6edd177bb1c7..2ba95d6fe852 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -135,6 +135,15 @@ struct kvm_arch_memory_slot {
 #define KVM_REG_ARM_CRM_SHIFT		7
 #define KVM_REG_ARM_32_CRN_MASK		0x0000000000007800
 #define KVM_REG_ARM_32_CRN_SHIFT	11
+/*
+ * For KVM currently all guest registers are nonsecure, but we reserve a bit
+ * in the encoding to distinguish secure from nonsecure for AArch32 system
+ * registers that are banked by security. This is 1 for the secure banked
+ * register, and 0 for the nonsecure banked register or if the register is
+ * not banked by security.
+ */
+#define KVM_REG_ARM_SECURE_MASK	0x0000000010000000
+#define KVM_REG_ARM_SECURE_SHIFT	28
 
 #define ARM_CP15_REG_SHIFT_MASK(x,n) \
 	(((x) << KVM_REG_ARM_ ## n ## _SHIFT) & KVM_REG_ARM_ ## n ## _MASK)
-- 
2.14.2
