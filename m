From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/27] KVM: arm/arm64: implement kvm_arch_intc_initialized
Date: Thu,  2 Apr 2015 11:05:10 +0100
Message-ID: <1427969131-8445-7-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D2E4AD80
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 05:58:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DHzbRtGvCa40 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2015 05:57:58 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9F724AD33
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 05:57:54 -0400 (EDT)
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

On arm/arm64 the VGIC is dynamically instantiated and it is useful
to expose its state, especially for irqfd setup.

This patch defines __KVM_HAVE_ARCH_INTC_INITIALIZED and
implements kvm_arch_intc_initialized.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   | 2 ++
 arch/arm/kvm/arm.c                | 5 +++++
 arch/arm64/include/asm/kvm_host.h | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 41008cd..902a7d1 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -27,6 +27,8 @@
 #include <asm/fpstate.h>
 #include <kvm/arm_arch_timer.h>
 
+#define __KVM_HAVE_ARCH_INTC_INITIALIZED
+
 #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
 #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
 #else
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 37b46c5..5e893eb 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -448,6 +448,11 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+bool kvm_arch_intc_initialized(struct kvm *kvm)
+{
+	return vgic_initialized(kvm);
+}
+
 static void vcpu_pause(struct kvm_vcpu *vcpu)
 {
 	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8ac3c70..967fb1c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -28,6 +28,8 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
 
+#define __KVM_HAVE_ARCH_INTC_INITIALIZED
+
 #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
 #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
 #else
-- 
2.1.4
