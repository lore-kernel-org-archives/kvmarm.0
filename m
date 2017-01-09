From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 13/55] KVM: arm64: Handle eret instruction traps
Date: Mon,  9 Jan 2017 01:24:09 -0500
Message-ID: <1483943091-1364-14-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F169440698
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 91R-b5-WDmiJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:09 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C84EC406B8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:08 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PXKZ017324
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:50 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 5167E84
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:50 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 2A13C84
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:50 -0500 (EST)
Received: from mail-qt0-f200.google.com (mail-qt0-f200.google.com
 [209.85.216.200])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PnEs040744
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:50 -0500
Received: by mail-qt0-f200.google.com with SMTP id x49so82674521qtc.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:50 -0800 (PST)
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

When HCR.NV bit is set, eret instruction execution in the guest
hypervisor will trap with EC code 0x1A. Let ELR_EL2 and SPSR_EL2 state
from the guest's perspective be restored to the hardware on the next
guest entry.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/asm/esr.h |  1 +
 arch/arm64/kvm/handle_exit.c | 12 ++++++++++++
 arch/arm64/kvm/trace.h       | 21 +++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d14c478..f32e3a7 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -42,6 +42,7 @@
 #define ESR_ELx_EC_HVC64	(0x16)
 #define ESR_ELx_EC_SMC64	(0x17)
 #define ESR_ELx_EC_SYS64	(0x18)
+#define ESR_ELx_EC_ERET		(0x1A)
 /* Unallocated EC: 0x19 - 0x1E */
 #define ESR_ELx_EC_IMP_DEF	(0x1f)
 #define ESR_ELx_EC_IABT_LOW	(0x20)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index a204adf..4e4a915 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -125,6 +125,17 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return ret;
 }
 
+static int kvm_handle_eret(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	trace_kvm_nested_eret(vcpu, vcpu_el2_reg(vcpu, ELR_EL2),
+			      vcpu_el2_reg(vcpu, SPSR_EL2));
+
+	*vcpu_pc(vcpu) = vcpu_el2_reg(vcpu, ELR_EL2);
+	*vcpu_cpsr(vcpu) = vcpu_el2_reg(vcpu, SPSR_EL2);
+
+	return 1;
+}
+
 static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
 	[ESR_ELx_EC_CP15_32]	= kvm_handle_cp15_32,
@@ -137,6 +148,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	[ESR_ELx_EC_HVC64]	= handle_hvc,
 	[ESR_ELx_EC_SMC64]	= handle_smc,
 	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
+	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
index 7c86cfb..5f40987 100644
--- a/arch/arm64/kvm/trace.h
+++ b/arch/arm64/kvm/trace.h
@@ -187,6 +187,27 @@
 	TP_printk("vcpu: %p, inject exception to vEL2: ESR_EL2 0x%lx, vector: 0x%016lx",
 		  __entry->vcpu, __entry->esr_el2, __entry->pc)
 );
+
+TRACE_EVENT(kvm_nested_eret,
+	TP_PROTO(struct kvm_vcpu *vcpu, unsigned long elr_el2,
+		 unsigned long spsr_el2),
+	TP_ARGS(vcpu, elr_el2, spsr_el2),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_vcpu *,	vcpu)
+		__field(unsigned long,		elr_el2)
+		__field(unsigned long,		spsr_el2)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->elr_el2 = elr_el2;
+		__entry->spsr_el2 = spsr_el2;
+	),
+
+	TP_printk("vcpu: %p, eret to elr_el2: 0x%016lx, with spsr_el2: 0x%08lx",
+		  __entry->vcpu, __entry->elr_el2, __entry->spsr_el2)
+);
 #endif /* _TRACE_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1
