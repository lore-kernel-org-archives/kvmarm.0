From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 06/38] KVM: arm64: Add vcpu_mode_el2 primitive to
 support nesting
Date: Tue, 18 Jul 2017 11:58:32 -0500
Message-ID: <1500397144-16232-7-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2059649C00
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i7KoUv98NXSL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:58:56 -0400 (EDT)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com
 [209.85.223.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5320C40D44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:56 -0400 (EDT)
Received: by mail-io0-f182.google.com with SMTP id z62so17065584ioi.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:59:44 -0700 (PDT)
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

From: Christoffer Dall <christoffer.dall@linaro.org>

When running a nested hypervisor we occasionally have to figure out if
the mode we are switching into is the virtual EL2 mode or a regular
EL0/1 mode.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_emulate.h   |  6 ++++++
 arch/arm64/include/asm/kvm_emulate.h | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 9a8a45a..399cd75e 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -77,6 +77,12 @@ static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+/* We don't support nesting on arm */
+static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static inline unsigned long *vcpu_pc(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.ctxt.gp_regs.usr_regs.ARM_pc;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fe39e68..5d6f3d0 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -143,6 +143,18 @@ static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 	return mode != PSR_MODE_EL0t;
 }
 
+static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
+{
+	u32 mode;
+
+	if (vcpu_mode_is_32bit(vcpu))
+		return false;
+
+	mode = *vcpu_cpsr(vcpu) & PSR_MODE_MASK;
+
+	return mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t;
+}
+
 static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.esr_el2;
-- 
1.9.1
