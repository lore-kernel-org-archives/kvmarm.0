From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/5] arm64: KVM: Do not use stack-protector to compile EL2 code
Date: Tue,  2 May 2017 14:30:37 +0100
Message-ID: <20170502133041.10980-2-marc.zyngier@arm.com>
References: <20170502133041.10980-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170502133041.10980-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We like living dangerously. Nothing explicitely forbids stack-protector
to be used in the EL2 code, while distributions routinely compile their
kernel with it. We're just lucky that no code actually triggers the
instrumentation.

Let's not try our luck for much longer, and disable stack-protector
for code living at EL2.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index aaf42ae8d8c3..14c4e3b14bcb 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -2,6 +2,8 @@
 # Makefile for Kernel-based Virtual Machine module, HYP part
 #
 
+ccflags-y += -fno-stack-protector
+
 KVM=../../../../virt/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
-- 
2.11.0
