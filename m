From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 11/50] arm64: KVM: Move the AArch32 conditional execution to
 common code
Date: Tue, 27 Sep 2016 20:05:19 +0200
Message-ID: <20160927180558.14699-12-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5AEA49B81
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w6TzUP8j6Gmk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:39 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37E1D49B1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:34 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id w84so190346100wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:05:57 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

It would make some sense to share the conditional execution code
between 32 and 64bit. In order to achieve this, let's move that
code to virt/kvm/arm/aarch32.c. While we're at it, drop a
superfluous BUG_ON() that wasn't that useful.

Following patches will migrate the 32bit port to that code base.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/emulate.c                             | 4 +---
 arch/arm64/kvm/Makefile                            | 3 ++-
 arch/arm64/kvm/emulate.c => virt/kvm/arm/aarch32.c | 4 +---
 3 files changed, 4 insertions(+), 7 deletions(-)
 rename arch/arm64/kvm/emulate.c => virt/kvm/arm/aarch32.c (97%)

diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index af93e3f..eda9ddd 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -221,9 +221,7 @@ static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_arm = !(cpsr & PSR_T_BIT);
 
-	BUG_ON(is_arm && (cpsr & PSR_IT_MASK));
-
-	if (!(cpsr & PSR_IT_MASK))
+	if (is_arm || !(cpsr & PSR_IT_MASK))
 		return;
 
 	cond = (cpsr & 0xe000) >> 13;
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 695eb3c..d50a82a 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,9 +16,10 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/e
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
+kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-init.o
diff --git a/arch/arm64/kvm/emulate.c b/virt/kvm/arm/aarch32.c
similarity index 97%
rename from arch/arm64/kvm/emulate.c
rename to virt/kvm/arm/aarch32.c
index 40098ad..cb02e56 100644
--- a/arch/arm64/kvm/emulate.c
+++ b/virt/kvm/arm/aarch32.c
@@ -109,9 +109,7 @@ static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_arm = !(cpsr & COMPAT_PSR_T_BIT);
 
-	BUG_ON(is_arm && (cpsr & COMPAT_PSR_IT_MASK));
-
-	if (!(cpsr & COMPAT_PSR_IT_MASK))
+	if (is_arm || !(cpsr & COMPAT_PSR_IT_MASK))
 		return;
 
 	cond = (cpsr & 0xe000) >> 13;
-- 
2.9.0
