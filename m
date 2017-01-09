From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 24/55] KVM: arm64: Forward FP exceptions to the guest hypervisor
Date: Mon,  9 Jan 2017 01:24:20 -0500
Message-ID: <1483943091-1364-25-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A254044D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2nQlbl6soOUv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:25 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B4DA407D6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:24 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PXCZ005328
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:05 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id B55F1A3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:05 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id B6788B1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:03 -0500 (EST)
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com
 [209.85.216.197])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q3Qk057119
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:03 -0500
Received: by mail-qt0-f197.google.com with SMTP id f4so58596555qte.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:03 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Forward exceptions due to floating-point register accesses to the guest
hypervisor if it has set CPTR_EL2.TFP bit.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kernel/asm-offsets.c     |  1 +
 arch/arm64/kvm/handle_exit.c        |  3 +++
 arch/arm64/kvm/handle_exit_nested.c |  6 ++++++
 arch/arm64/kvm/hyp/entry.S          | 14 ++++++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S      |  2 +-
 6 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 8d36935..54c5ce5 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -3,4 +3,5 @@
 
 int handle_hvc_nested(struct kvm_vcpu *vcpu);
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
+int kvm_handle_fp_asimd(struct kvm_vcpu *vcpu, struct kvm_run *run);
 #endif
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 4a2f0f0..b635f1a 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -131,6 +131,7 @@ int main(void)
   DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
   DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
   DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
+  DEFINE(VIRTUAL_CPTR_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.el2_regs[CPTR_EL2]));
 #endif
 #ifdef CONFIG_CPU_PM
   DEFINE(CPU_SUSPEND_SZ,	sizeof(struct cpu_suspend_ctx));
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 046fdf8..308f5c5 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -195,6 +195,9 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	[ESR_ELx_EC_BREAKPT_LOW]= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BKPT32]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+	[ESR_ELx_EC_FP_ASIMD]	= kvm_handle_fp_asimd,
+#endif
 };
 
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/handle_exit_nested.c b/arch/arm64/kvm/handle_exit_nested.c
index 871ecfc..7544c6d 100644
--- a/arch/arm64/kvm/handle_exit_nested.c
+++ b/arch/arm64/kvm/handle_exit_nested.c
@@ -43,3 +43,9 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
 
 	return -EINVAL;
 }
+
+/* This is only called when virtual CPTR_EL2.TFP bit is set. */
+int kvm_handle_fp_asimd(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+}
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 12ee62d..a76f102 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -158,6 +158,20 @@ abort_guest_exit_end:
 1:	ret
 ENDPROC(__guest_exit)
 
+ENTRY(__fpsimd_guest_trap)
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+// If virtual CPTR_EL2.TFP is set, then foward it to the nested hyp.
+	mrs	x1, tpidr_el2
+	ldr	x0, [x1, #VIRTUAL_CPTR_EL2]
+	and 	x0, x0, #CPTR_EL2_TFP
+	cbnz	x0, 1f
+#endif
+	b	__fpsimd_guest_restore
+1:
+	mov	x0, #ARM_EXCEPTION_TRAP
+	b	__guest_exit
+ENDPROC(__fpsimd_guest_trap)
+
 ENTRY(__fpsimd_guest_restore)
 	stp	x2, x3, [sp, #-16]!
 	stp	x4, lr, [sp, #-16]!
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 4e92399..d83494b 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -108,7 +108,7 @@ el1_trap:
 
 	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
 	cmp	x0, #ESR_ELx_EC_FP_ASIMD
-	b.eq	__fpsimd_guest_restore
+	b.eq	__fpsimd_guest_trap
 
 	mrs	x1, tpidr_el2
 	mov	x0, #ARM_EXCEPTION_TRAP
-- 
1.9.1
