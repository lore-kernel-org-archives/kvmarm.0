From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 03/13] arm: KVM: Do not use stack-protector to compile HYP code
Date: Thu, 18 May 2017 11:47:12 +0200
Message-ID: <20170518094722.9926-4-cdall@linaro.org>
References: <20170518094722.9926-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C61B240C33
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zqz5ONy-mSg1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 May 2017 05:44:09 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2D2140019
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:09 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id 70so40076999wmq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 02:47:40 -0700 (PDT)
In-Reply-To: <20170518094722.9926-1-cdall@linaro.org>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We like living dangerously. Nothing explicitely forbids stack-protector
to be used in the HYP code, while distributions routinely compile their
kernel with it. We're just lucky that no code actually triggers the
instrumentation.

Let's not try our luck for much longer, and disable stack-protector
for code living at HYP.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kvm/hyp/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 3023bb5..8679405 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -2,6 +2,8 @@
 # Makefile for Kernel-based Virtual Machine module, HYP part
 #
 
+ccflags-y += -fno-stack-protector
+
 KVM=../../../../virt/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
-- 
2.9.0
