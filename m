From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 19/50] arm64: KVM: Add Virtual Abort injection helper
Date: Tue, 27 Sep 2016 20:05:27 +0200
Message-ID: <20160927180558.14699-20-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C245949B7D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AWhHvMaMWZZR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:45 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C77DE49B21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:41 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id l132so26941852wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:05 -0700 (PDT)
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

Now that we're able to context switch the HCR_EL2.VA bit, let's
introduce a helper that injects an Abort into a vcpu.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/inject_fault.c        | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b336434d..fd9d5fd 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -38,6 +38,7 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr);
 
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
+void kvm_inject_vabt(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 898c0e6..da6a8cf 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -231,3 +231,15 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 	else
 		inject_undef64(vcpu);
 }
+
+/**
+ * kvm_inject_vabt - inject an async abort / SError into the guest
+ * @vcpu: The VCPU to receive the exception
+ *
+ * It is assumed that this code is called from the VCPU thread and that the
+ * VCPU therefore is not currently executing guest code.
+ */
+void kvm_inject_vabt(struct kvm_vcpu *vcpu)
+{
+	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
+}
-- 
2.9.0
