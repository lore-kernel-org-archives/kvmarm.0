From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 06/55] KVM: arm64: Add EL2 execution context for nesting
Date: Mon,  9 Jan 2017 01:24:02 -0500
Message-ID: <1483943091-1364-7-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 412FD406D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:23:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id moq8X+R0QQDT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:23:57 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A1EE401F2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:23:57 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PX6R017321
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:39 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 3139E7E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:39 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 172F380
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:39 -0500 (EST)
Received: from mail-qt0-f200.google.com (mail-qt0-f200.google.com
 [209.85.216.200])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Pcki041735
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:39 -0500
Received: by mail-qt0-f200.google.com with SMTP id k15so94303329qtg.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:39 -0800 (PST)
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

With the nested virtualization support, the context of the guest
includes EL2 register states. The host manages a set of virtual EL2
registers.  In addition to that, the guest hypervisor supposed to run in
EL2 is now deprivilaged and runs in EL1. So, the host also manages a set
of shadow system registers to be able to run the guest hypervisor in
EL1.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h | 54 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c0c8b02..ed78d73 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -146,6 +146,42 @@ enum vcpu_sysreg {
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
+enum el2_regs {
+	ELR_EL2,
+	SPSR_EL2,
+	SP_EL2,
+	AMAIR_EL2,
+	MAIR_EL2,
+	TCR_EL2,
+	TTBR0_EL2,
+	VTCR_EL2,
+	VTTBR_EL2,
+	VMPIDR_EL2,
+	VPIDR_EL2,      /* 10 */
+	MDCR_EL2,
+	CNTHCTL_EL2,
+	CNTHP_CTL_EL2,
+	CNTHP_CVAL_EL2,
+	CNTHP_TVAL_EL2,
+	CNTVOFF_EL2,
+	ACTLR_EL2,
+	AFSR0_EL2,
+	AFSR1_EL2,
+	CPTR_EL2,       /* 20 */
+	ESR_EL2,
+	FAR_EL2,
+	HACR_EL2,
+	HCR_EL2,
+	HPFAR_EL2,
+	HSTR_EL2,
+	RMR_EL2,
+	RVBAR_EL2,
+	SCTLR_EL2,
+	TPIDR_EL2,      /* 30 */
+	VBAR_EL2,
+	NR_EL2_REGS     /* Nothing after this line! */
+};
+
 /* 32bit mapping */
 #define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
 #define c0_CSSELR	(CSSELR_EL1 * 2)/* Cache Size Selection Register */
@@ -193,6 +229,23 @@ struct kvm_cpu_context {
 		u64 sys_regs[NR_SYS_REGS];
 		u32 copro[NR_COPRO_REGS];
 	};
+
+	u64 el2_regs[NR_EL2_REGS];         /* only used for nesting */
+	u64 shadow_sys_regs[NR_SYS_REGS];  /* only used for virtual EL2 */
+
+	/*
+	 * hw_* will be used when switching to a VM. They point to either
+	 * the virtual EL2 or EL1/EL0 context depending on vcpu mode.
+	 */
+
+	/* pointing shadow_sys_regs or sys_regs */
+	u64 *hw_sys_regs;
+
+	/* copy of either gp_regs.sp_el1 or el2_regs[SP_EL2] */
+	u64 hw_sp_el1;
+
+	/* pstate written to SPSR_EL2 */
+	u64 hw_pstate;
 };
 
 typedef struct kvm_cpu_context kvm_cpu_context_t;
@@ -277,6 +330,7 @@ struct kvm_vcpu_arch {
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
 #define vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
+#define vcpu_el2_reg(v, r)	((v)->arch.ctxt.el2_regs[(r)])
 /*
  * CP14 and CP15 live in the same array, as they are backed by the
  * same system registers.
-- 
1.9.1
