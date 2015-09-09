From: Tushar Jagad <tushar.jagad@linaro.org>
Subject: [PATCH RFC 1/3] linux-headers: sync'd kernel headers for arm/arm64
Date: Wed,  9 Sep 2015 08:42:10 +0000
Message-ID: <1441788132-6286-2-git-send-email-tushar.jagad@linaro.org>
References: <1441788132-6286-1-git-send-email-tushar.jagad@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73DBB412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 04:41:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TszWUxOcA+eN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2015 04:41:50 -0400 (EDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
 [209.85.220.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D08C413DC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 04:41:50 -0400 (EDT)
Received: by pacex6 with SMTP id ex6so4005856pac.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2015 01:42:29 -0700 (PDT)
In-Reply-To: <1441788132-6286-1-git-send-email-tushar.jagad@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: marc.zyngier@arm.com, patches@apm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Sync arm/arm64 headers for bringing in support for cross cpu.

Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 linux-headers/asm-arm64/kvm.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index c8abf25..94d1fc9 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -88,6 +88,13 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
+#define KVM_ARM_VCPU_NUM_BPTS		3 /* Number of breakpoints supported */
+#define KVM_ARM_VCPU_NUM_WPTS		7 /* Number of watchpoints supported */
+
+#define KVM_ARM_VCPU_BPTS_FEATURES_IDX	0
+#define KVM_ARM_VCPU_WPTS_FEATURES_IDX	0
+#define KVM_ARM_VCPU_BPTS_MASK		0x00000078
+#define KVM_ARM_VCPU_WPTS_MASK		0x00000780
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -193,7 +200,9 @@ struct kvm_arch_memory_slot {
  * and only here to provide source code level compatibility with older
  * userland. The highest SPI number can be set via KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
  */
+#ifndef __KERNEL__
 #define KVM_ARM_IRQ_GIC_MAX		127
+#endif
 
 /* One single KVM irqchip, ie. the VGIC */
 #define KVM_NR_IRQCHIPS          1
-- 
2.4.3
