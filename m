From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 16/31] KVM: arm64: Introduce sys_reg_desc.forward_trap
Date: Mon,  2 Oct 2017 22:10:58 -0500
Message-ID: <1507000273-3735-14-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62E6749D13
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 27If914L3Ut4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:39 -0400 (EDT)
Received: from mail-it0-f47.google.com (mail-it0-f47.google.com
 [209.85.214.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BC4949D2A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:37 -0400 (EDT)
Received: by mail-it0-f47.google.com with SMTP id y138so10005647itc.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:56 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This introduces a function prototype to determine if we need to forward
system instruction traps to the virtual EL2. The implementation of
forward_trap functions for each system instruction will be added in
later patches.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++++++
 arch/arm64/kvm/sys_regs.h | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 541bb97..88ce172 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1661,6 +1661,14 @@ static void perform_access(struct kvm_vcpu *vcpu,
 	 */
 	BUG_ON(!r->access);
 
+	/*
+	 * Forward this trap to the virtual EL2 if the guest hypervisor has
+	 * configured to trap the current instruction.
+	 */
+	if (nested_virt_in_use(vcpu) && r->forward_trap
+	    && unlikely(r->forward_trap(vcpu)))
+		return;
+
 	/* Skip instruction if instructed so */
 	if (likely(r->access(vcpu, params, r)))
 		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 827717b..6dd4008 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -61,6 +61,12 @@ struct sys_reg_desc {
 			const struct kvm_one_reg *reg, void __user *uaddr);
 	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			const struct kvm_one_reg *reg, void __user *uaddr);
+
+	/*
+	 * Forward the trap to the virtual EL2 if the guest hypervisor has
+	 * configured to trap the current instruction.
+	 */
+	bool (*forward_trap)(struct kvm_vcpu *vcpu);
 };
 
 static inline void print_sys_reg_instr(const struct sys_reg_params *p)
-- 
1.9.1
