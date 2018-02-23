From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 2/2] ARM: kvm: fix building with gcc-8
Date: Fri, 23 Feb 2018 19:00:24 +0100
Message-ID: <20180223180024.8846-3-christoffer.dall@linaro.org>
References: <20180223180024.8846-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00C7D40387
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Feb 2018 12:54:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bv8MeJTa-FQi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Feb 2018 12:53:50 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EF324043C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Feb 2018 12:53:50 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id z81so6184034wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Feb 2018 10:00:33 -0800 (PST)
In-Reply-To: <20180223180024.8846-1-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Arnd Bergmann <arnd@arndb.de>

In banked-sr.c, we use a top-level '__asm__(".arch_extension virt")'
statement to allow compilation of a multi-CPU kernel for ARMv6
and older ARMv7-A that don't normally support access to the banked
registers.

This is considered to be a programming error by the gcc developers
and will no longer work in gcc-8, where we now get a build error:

/tmp/cc4Qy7GR.s:34: Error: Banked registers are not available with this architecture. -- `mrs r3,SP_usr'
/tmp/cc4Qy7GR.s:41: Error: Banked registers are not available with this architecture. -- `mrs r3,ELR_hyp'
/tmp/cc4Qy7GR.s:55: Error: Banked registers are not available with this architecture. -- `mrs r3,SP_svc'
/tmp/cc4Qy7GR.s:62: Error: Banked registers are not available with this architecture. -- `mrs r3,LR_svc'
/tmp/cc4Qy7GR.s:69: Error: Banked registers are not available with this architecture. -- `mrs r3,SPSR_svc'
/tmp/cc4Qy7GR.s:76: Error: Banked registers are not available with this architecture. -- `mrs r3,SP_abt'

Passign the '-march-armv7ve' flag to gcc works, and is ok here, because
we know the functions won't ever be called on pre-ARMv7VE machines.
Unfortunately, older compiler versions (4.8 and earlier) do not understand
that flag, so we still need to keep the asm around.

Backporting to stable kernels (4.6+) is needed to allow those to be built
with future compilers as well.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=84129
Fixes: 33280b4cd1dc ("ARM: KVM: Add banked registers save/restore")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/hyp/Makefile    | 5 +++++
 arch/arm/kvm/hyp/banked-sr.c | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 5638ce0c9524..63d6b404d88e 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -7,6 +7,8 @@ ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING
 
 KVM=../../../../virt/kvm
 
+CFLAGS_ARMV7VE		   :=$(call cc-option, -march=armv7ve)
+
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
@@ -15,7 +17,10 @@ obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += cp15-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vfp.o
 obj-$(CONFIG_KVM_ARM_HOST) += banked-sr.o
+CFLAGS_banked-sr.o	   += $(CFLAGS_ARMV7VE)
+
 obj-$(CONFIG_KVM_ARM_HOST) += entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += switch.o
+CFLAGS_switch.o		   += $(CFLAGS_ARMV7VE)
 obj-$(CONFIG_KVM_ARM_HOST) += s2-setup.o
diff --git a/arch/arm/kvm/hyp/banked-sr.c b/arch/arm/kvm/hyp/banked-sr.c
index 111bda8cdebd..be4b8b0a40ad 100644
--- a/arch/arm/kvm/hyp/banked-sr.c
+++ b/arch/arm/kvm/hyp/banked-sr.c
@@ -20,6 +20,10 @@
 
 #include <asm/kvm_hyp.h>
 
+/*
+ * gcc before 4.9 doesn't understand -march=armv7ve, so we have to
+ * trick the assembler.
+ */
 __asm__(".arch_extension     virt");
 
 void __hyp_text __banked_save_state(struct kvm_cpu_context *ctxt)
-- 
2.14.2
