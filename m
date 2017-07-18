From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 04/38] KVM: arm/arm64: Check if nested virtualization
 is in use
Date: Tue, 18 Jul 2017 11:58:30 -0500
Message-ID: <1500397144-16232-5-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1199D412A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UWGrUChgU4Fc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:58:54 -0400 (EDT)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com
 [209.85.223.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DE1049C0E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:52 -0400 (EDT)
Received: by mail-io0-f180.google.com with SMTP id l7so10046815iof.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:59:41 -0700 (PDT)
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

Nested virtualizaion is in use only if all three conditions are met:
- The architecture supports nested virtualization.
- The kernel parameter is set.
- The userspace uses nested virtualiztion feature.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   | 11 +++++++++++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/nested.c           | 17 +++++++++++++++++
 virt/kvm/arm/arm.c                |  4 ++++
 4 files changed, 34 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 00b0f97..7e9e6c8 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -303,4 +303,15 @@ static inline int __init kvmarm_nested_cfg(char *buf)
 {
 	return 0;
 }
+
+static inline int init_nested_virt(void)
+{
+	return 0;
+}
+
+static inline bool nested_virt_in_use(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6df0c7c..86d4b6c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -387,5 +387,7 @@ static inline void __cpu_init_stage2(void)
 }
 
 int __init kvmarm_nested_cfg(char *buf);
+int init_nested_virt(void);
+bool nested_virt_in_use(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 79f38da..9a05c76 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -24,3 +24,20 @@ int __init kvmarm_nested_cfg(char *buf)
 {
 	return strtobool(buf, &nested_param);
 }
+
+int init_nested_virt(void)
+{
+	if (nested_param && cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
+		kvm_info("Nested virtualization is supported\n");
+
+	return 0;
+}
+
+bool nested_virt_in_use(struct kvm_vcpu *vcpu)
+{
+	if (nested_param && cpus_have_const_cap(ARM64_HAS_NESTED_VIRT)
+	    && test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features))
+		return true;
+
+	return false;
+}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 1c1c772..36aae3a 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1478,6 +1478,10 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		goto out_err;
 
+	err = init_nested_virt();
+	if (err)
+		return err;
+
 	err = init_subsystems();
 	if (err)
 		goto out_hyp;
-- 
1.9.1
