From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 15/38] KVM: arm64: Move exception macros and enums to a
 common file
Date: Tue, 18 Jul 2017 11:58:41 -0500
Message-ID: <1500397144-16232-16-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADEFB49C30
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f3i2N+R1Pq5J for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:12 -0400 (EDT)
Received: from mail-it0-f49.google.com (mail-it0-f49.google.com
 [209.85.214.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5472A49C26
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:12 -0400 (EDT)
Received: by mail-it0-f49.google.com with SMTP id a62so23794520itd.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:00 -0700 (PDT)
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

These macros and enums can be reused to inject exceptions
for nested virtualization.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 12 ++++++++++++
 arch/arm64/kvm/inject_fault.c        | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 14c4ce9..94f98cc 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -31,6 +31,18 @@
 #include <asm/cputype.h>
 #include <asm/virt.h>
 
+#define CURRENT_EL_SP_EL0_VECTOR	0x0
+#define CURRENT_EL_SP_ELx_VECTOR	0x200
+#define LOWER_EL_AArch64_VECTOR		0x400
+#define LOWER_EL_AArch32_VECTOR		0x600
+
+enum exception_type {
+	except_type_sync	= 0,
+	except_type_irq		= 0x80,
+	except_type_fiq		= 0x100,
+	except_type_serror	= 0x180,
+};
+
 unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num);
 unsigned long *vcpu_spsr32(const struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index da6a8cf..94679fb 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -28,11 +28,6 @@
 #define PSTATE_FAULT_BITS_64 	(PSR_MODE_EL1h | PSR_A_BIT | PSR_F_BIT | \
 				 PSR_I_BIT | PSR_D_BIT)
 
-#define CURRENT_EL_SP_EL0_VECTOR	0x0
-#define CURRENT_EL_SP_ELx_VECTOR	0x200
-#define LOWER_EL_AArch64_VECTOR		0x400
-#define LOWER_EL_AArch32_VECTOR		0x600
-
 static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
 	unsigned long cpsr;
@@ -101,13 +96,6 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 		*fsr = 0x14;
 }
 
-enum exception_type {
-	except_type_sync	= 0,
-	except_type_irq		= 0x80,
-	except_type_fiq		= 0x100,
-	except_type_serror	= 0x180,
-};
-
 static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
 {
 	u64 exc_offset;
-- 
1.9.1
