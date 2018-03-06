From: Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v2] KVM: arm: reserve bit in KVM_REG_ARM encoding for
 secure/nonsecure
Date: Tue,  6 Mar 2018 19:47:41 +0000
Message-ID: <20180306194741.30395-1-peter.maydell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

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
---
v1->v2: expanded comment
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
2.16.2
