From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v9 3/5] KVM: arm/arm64: implement kvm_arch_intc_initialized
Date: Wed,  4 Mar 2015 11:14:34 +0100
Message-ID: <1425464076-20558-4-git-send-email-eric.auger@linaro.org>
References: <1425464076-20558-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26F2847948
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 05:11:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cfMNrSWau2A3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 05:11:21 -0500 (EST)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
 [209.85.212.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3938547958
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 05:11:20 -0500 (EST)
Received: by wiwh11 with SMTP id h11so29219731wiw.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 02:17:22 -0800 (PST)
In-Reply-To: <1425464076-20558-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: gleb@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On arm/arm64 the VGIC is dynamically instantiated and it is useful
to expose its state, especially for irqfd setup.

This patch defines __KVM_HAVE_ARCH_INTC_INITIALIZED and
implements kvm_arch_intc_initialized.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>

---

v7 -> v8:
- add Andre's Reviewed-by

v6 -> v7:
- usage of the new function in irqfd is introduced in previous patch
  file.
- Changed the title and the commit message accordingly

v5 -> v6:
- remove kvm_arch_intc_initialized declaration from
  architecture specific kvm_host.h since it is now in
  generic kvm_host.h
- squash v5 patch files 3 & 4
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
index 07e7eb1..5300d5a 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -452,6 +452,11 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
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
1.9.1
