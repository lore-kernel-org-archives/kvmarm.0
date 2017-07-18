From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 26/38] KVM: arm64: Add macros to support the virtual
 EL2 with VHE
Date: Tue, 18 Jul 2017 11:58:52 -0500
Message-ID: <1500397144-16232-27-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A1CF49C54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vfRMKzISzZfm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:34 -0400 (EDT)
Received: from mail-io0-f180.google.com (mail-io0-f180.google.com
 [209.85.223.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07EDE49C76
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:32 -0400 (EDT)
Received: by mail-io0-f180.google.com with SMTP id z62so17075673ioi.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:21 -0700 (PDT)
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

These macros will be used to support the virtual EL2 with VHE.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3017234..68aafbd 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -173,6 +173,30 @@ static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
 	return mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t;
 }
 
+static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
+{
+	return (vcpu_sys_reg(vcpu, HCR_EL2) & HCR_E2H);
+}
+
+static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)
+{
+	return (vcpu_sys_reg(vcpu, HCR_EL2) & HCR_TGE);
+}
+
+static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
+{
+	/*
+	 * We are in a hypervisor context if the vcpu mode is EL2 or
+	 * E2H and TGE bits are set. The latter means we are in the user space
+	 * of the VHE kernel. ARMv8.1 ARM describes this as 'InHost'
+	 */
+	if (vcpu_mode_el2(vcpu) ||
+	    (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
+		return true;
+
+	return false;
+}
+
 static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.esr_el2;
-- 
1.9.1
