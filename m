From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 36/38] KVM: arm64: Respect virtual HCR_EL2.TVM and TRVM
 settings
Date: Tue, 18 Jul 2017 11:59:02 -0500
Message-ID: <1500397144-16232-37-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A29749C29
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0qZ6mUMZrWDE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:51 -0400 (EDT)
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com
 [209.85.214.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1DC3349C7F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:51 -0400 (EDT)
Received: by mail-it0-f44.google.com with SMTP id a62so23805381itd.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:39 -0700 (PDT)
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

Forward the EL1 virtual memory register traps to the virtual EL2 if they
are not coming from the virtual EL2 and the virtual HCR_EL2.TVM or TRVM
bit is set.

This is for recursive nested virtualization.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3559cf7..3e4ec5e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -135,6 +135,27 @@ static inline bool el12_reg(struct sys_reg_params *p)
 	return (p->Op1 == 5);
 }
 
+/* This function is to support the recursive nested virtualization */
+static bool forward_vm_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
+{
+	u64 hcr_el2 = vcpu_sys_reg(vcpu, HCR_EL2);
+
+	/* If a trap comes from the virtual EL2, the host hypervisor handles. */
+	if (vcpu_mode_el2(vcpu))
+		return false;
+
+	/*
+	 * If the virtual HCR_EL2.TVM or TRVM bit is set, we need to foward
+	 * this trap to the virtual EL2.
+	 */
+	if ((hcr_el2 & HCR_TVM) && p->is_write)
+		return true;
+	else if ((hcr_el2 & HCR_TRVM) && !p->is_write)
+		return true;
+
+	return false;
+}
+
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
  * is set. If the guest enables the MMU, we stop trapping the VM
@@ -152,6 +173,9 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	if (el12_reg(p) && forward_nv_traps(vcpu))
 		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
 
+	if (!el12_reg(p) && forward_vm_traps(vcpu, p))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	/*
 	 * Redirect EL1 register accesses to the corresponding EL2 registers if
 	 * they are meant to access EL2 registers.
-- 
1.9.1
