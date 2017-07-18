From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 24/38] KVM: arm64: Respect virtual HCR_EL2.TWX setting
Date: Tue, 18 Jul 2017 11:58:50 -0500
Message-ID: <1500397144-16232-25-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9998049BFD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PYQofd7QT914 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:30 -0400 (EDT)
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com
 [209.85.223.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9784C4104E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:29 -0400 (EDT)
Received: by mail-io0-f172.google.com with SMTP id 5so16506961iow.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:18 -0700 (PDT)
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

Forward exceptions due to WFI or WFE instructions to the virtual EL2 if
they are not coming from the virtual EL2 and virtual HCR_EL2.TWX is set.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/handle_exit.c      | 13 ++++++++++++-
 arch/arm64/kvm/nested.c           | 20 ++++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 46880c3..53b0b33 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -442,5 +442,6 @@ static inline void __cpu_init_stage2(void)
 int __init kvmarm_nested_cfg(char *buf);
 int init_nested_virt(void);
 bool nested_virt_in_use(struct kvm_vcpu *vcpu);
+int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 8b398b2..25ec824 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -107,7 +107,18 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu, struct kvm_run *run)
  */
 static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
+	bool is_wfe = !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE);
+
+	if (nested_virt_in_use(vcpu)) {
+		int ret = handle_wfx_nested(vcpu, is_wfe);
+
+		if (ret < 0 && ret != -EINVAL)
+			return ret;
+		else if (ret >= 0)
+			return ret;
+	}
+
+	if (is_wfe) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
 		kvm_vcpu_on_spin(vcpu);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9a05c76..042d304 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -18,6 +18,8 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_emulate.h>
+
 static bool nested_param;
 
 int __init kvmarm_nested_cfg(char *buf)
@@ -41,3 +43,21 @@ bool nested_virt_in_use(struct kvm_vcpu *vcpu)
 
 	return false;
 }
+
+/*
+ * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
+ * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
+ * handle this.
+ */
+int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
+{
+	u64 hcr_el2 = vcpu_sys_reg(vcpu, HCR_EL2);
+
+	if (vcpu_mode_el2(vcpu))
+		return -EINVAL;
+
+	if ((is_wfe && (hcr_el2 & HCR_TWE)) || (!is_wfe && (hcr_el2 & HCR_TWI)))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
+	return -EINVAL;
+}
-- 
1.9.1
