From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 03/38] KVM: arm64: Add KVM nesting feature
Date: Tue, 18 Jul 2017 11:58:29 -0500
Message-ID: <1500397144-16232-4-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E14743C6E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kEbfyxgdb9zG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:58:51 -0400 (EDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
 [209.85.223.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F3E849C0B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:51 -0400 (EDT)
Received: by mail-io0-f181.google.com with SMTP id 5so16496753iow.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:59:39 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Set the initial exception level of the guest to EL2 if nested
virtualization feature is enabled.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/include/uapi/asm/kvm.h | 1 +
 arch/arm64/kvm/reset.c            | 8 ++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dcc4df8..6df0c7c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 4
+#define KVM_VCPU_MAX_FEATURES 5
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9f3ca24..4a71a72 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -99,6 +99,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
+#define KVM_ARM_VCPU_NESTED_VIRT	4 /* Support nested virtualization */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3256b92..1353516 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -41,6 +41,11 @@
 			PSR_F_BIT | PSR_D_BIT),
 };
 
+static const struct kvm_regs default_regs_reset_el2 = {
+	.regs.pstate = (PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT |
+			PSR_F_BIT | PSR_D_BIT),
+};
+
 static const struct kvm_regs default_regs_reset32 = {
 	.regs.pstate = (COMPAT_PSR_MODE_SVC | COMPAT_PSR_A_BIT |
 			COMPAT_PSR_I_BIT | COMPAT_PSR_F_BIT),
@@ -106,6 +111,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 			if (!cpu_has_32bit_el1())
 				return -EINVAL;
 			cpu_reset = &default_regs_reset32;
+		} else if (test_bit(KVM_ARM_VCPU_NESTED_VIRT,
+				    vcpu->arch.features)) {
+			cpu_reset = &default_regs_reset_el2;
 		} else {
 			cpu_reset = &default_regs_reset;
 		}
-- 
1.9.1
