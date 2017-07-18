From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 18/38] KVM: arm64: Trap SPSR_EL1,
 ELR_EL1 and VBAR_EL1 from virtual EL2
Date: Tue, 18 Jul 2017 11:58:44 -0500
Message-ID: <1500397144-16232-19-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88CE140FA7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uK6qx9E4YgLJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:20 -0400 (EDT)
Received: from mail-it0-f41.google.com (mail-it0-f41.google.com
 [209.85.214.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FFEE40CE4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:18 -0400 (EDT)
Received: by mail-it0-f41.google.com with SMTP id a62so23796109itd.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:06 -0700 (PDT)
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

For the same reason we trap virtual memory register accesses at virtual
EL2, we need to trap SPSR_EL1, ELR_EL1 and VBAR_EL1 accesses. ARM v8.3
introduces the HCR_EL2.NV1 bit to be able to trap on those register
accesses in EL1. Do not set this bit until the whole nesting support is
completed.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/sysreg.h |  2 ++
 arch/arm64/kvm/sys_regs.c       | 29 ++++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 98c32ef..6373d3d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -164,6 +164,8 @@
 #define SYS_TTBR1_EL1			sys_reg(3, 0, 2, 0, 1)
 #define SYS_TCR_EL1			sys_reg(3, 0, 2, 0, 2)
 
+#define	SYS_SPSR_EL1			sys_reg(3, 0, 4, 0, 0)
+#define	SYS_ELR_EL1			sys_reg(3, 0, 4, 0, 1)
 #define SYS_ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 
 #define SYS_AFSR0_EL1			sys_reg(3, 0, 5, 1, 0)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d8b1d4b..b83fef2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -936,6 +936,30 @@ static bool trap_el2_regs(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_elr(struct kvm_vcpu *vcpu,
+		struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	access_rw(p, &vcpu->arch.ctxt.gp_regs.elr_el1);
+	return true;
+}
+
+static bool access_spsr(struct kvm_vcpu *vcpu,
+		struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	access_rw(p, &vcpu->arch.ctxt.gp_regs.spsr[KVM_SPSR_EL1]);
+	return true;
+}
+
+static bool access_vbar(struct kvm_vcpu *vcpu,
+		struct sys_reg_params *p,
+		const struct sys_reg_desc *r)
+{
+	access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -994,6 +1018,9 @@ static bool trap_el2_regs(struct kvm_vcpu *vcpu,
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
 
+	{ SYS_DESC(SYS_SPSR_EL1), access_spsr},
+	{ SYS_DESC(SYS_ELR_EL1), access_elr},
+
 	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
@@ -1006,7 +1033,7 @@ static bool trap_el2_regs(struct kvm_vcpu *vcpu,
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
 
-	{ SYS_DESC(SYS_VBAR_EL1), NULL, reset_val, VBAR_EL1, 0 },
+	{ SYS_DESC(SYS_VBAR_EL1), access_vbar, reset_val, VBAR_EL1, 0 },
 
 	{ SYS_DESC(SYS_ICC_IAR0_EL1), write_to_read_only },
 	{ SYS_DESC(SYS_ICC_EOIR0_EL1), read_from_write_only },
-- 
1.9.1
