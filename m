From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 02/13] arm64: KVM: Do not use stack-protector to compile EL2 code
Date: Thu, 18 May 2017 11:47:11 +0200
Message-ID: <20170518094722.9926-3-cdall@linaro.org>
References: <20170518094722.9926-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170518094722.9926-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We like living dangerously. Nothing explicitely forbids stack-protector
to be used in the EL2 code, while distributions routinely compile their
kernel with it. We're just lucky that no code actually triggers the
instrumentation.

Let's not try our luck for much longer, and disable stack-protector
for code living at EL2.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/hyp/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index aaf42ae..14c4e3b 100644
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
2.9.0
