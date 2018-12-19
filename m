From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 23/28] arm64: KVM: Add trapped system register access
 tracepoint
Date: Wed, 19 Dec 2018 18:03:44 +0000
Message-ID: <20181219180349.242681-24-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CB0F4A373
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fr+eT7nID8El for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:05:14 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED0124A378
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:13 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
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
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

We're pretty blind when it comes to system register tracing,
and rely on the ESR value displayed by kvm_handle_sys, which
isn't much.

Instead, let's add an actual name to the sysreg entries, so that
we can finally print it as we're about to perform the access
itself.

The new tracepoint is conveniently called kvm_sys_access.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c |  2 ++
 arch/arm64/kvm/sys_regs.h |  4 ++++
 arch/arm64/kvm/trace.h    | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 965c6f1706d6..a1f57fcb1bdb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1850,6 +1850,8 @@ static void perform_access(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *params,
 			   const struct sys_reg_desc *r)
 {
+	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
+
 	/*
 	 * Not having an accessor means that we have configured a trap
 	 * that we don't know how to handle. This certainly qualifies
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index cd710f8b63e0..3b1bc7f01d0b 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -35,6 +35,9 @@ struct sys_reg_params {
 };
 
 struct sys_reg_desc {
+	/* Sysreg string for debug */
+	const char *name;
+
 	/* MRS/MSR instruction which accesses it. */
 	u8	Op0;
 	u8	Op1;
@@ -130,6 +133,7 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 #define Op2(_x) 	.Op2 = _x
 
 #define SYS_DESC(reg)					\
+	.name = #reg,					\
 	Op0(sys_reg_Op0(reg)), Op1(sys_reg_Op1(reg)),	\
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
index 3b82fb1ddd09..eab91ad0effb 100644
--- a/arch/arm64/kvm/trace.h
+++ b/arch/arm64/kvm/trace.h
@@ -3,6 +3,7 @@
 #define _TRACE_ARM64_KVM_H
 
 #include <linux/tracepoint.h>
+#include "sys_regs.h"
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
@@ -152,6 +153,40 @@ TRACE_EVENT(kvm_handle_sys_reg,
 	TP_printk("HSR 0x%08lx", __entry->hsr)
 );
 
+TRACE_EVENT(kvm_sys_access,
+	TP_PROTO(unsigned long vcpu_pc, struct sys_reg_params *params, const struct sys_reg_desc *reg),
+	TP_ARGS(vcpu_pc, params, reg),
+
+	TP_STRUCT__entry(
+		__field(unsigned long,			vcpu_pc)
+		__field(bool,				is_write)
+		__field(const char *,			name)
+		__field(u8,				Op0)
+		__field(u8,				Op1)
+		__field(u8,				CRn)
+		__field(u8,				CRm)
+		__field(u8,				Op2)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_pc = vcpu_pc;
+		__entry->is_write = params->is_write;
+		__entry->name = reg->name;
+		__entry->Op0 = reg->Op0;
+		__entry->Op0 = reg->Op0;
+		__entry->Op1 = reg->Op1;
+		__entry->CRn = reg->CRn;
+		__entry->CRm = reg->CRm;
+		__entry->Op2 = reg->Op2;
+	),
+
+	TP_printk("PC: %lx %s (%d,%d,%d,%d,%d) %s",
+		  __entry->vcpu_pc, __entry->name ?: "UNKN",
+		  __entry->Op0, __entry->Op1, __entry->CRn,
+		  __entry->CRm, __entry->Op2,
+		  __entry->is_write ? "write" : "read")
+);
+
 TRACE_EVENT(kvm_set_guest_debug,
 	TP_PROTO(struct kvm_vcpu *vcpu, __u32 guest_debug),
 	TP_ARGS(vcpu, guest_debug),
-- 
2.19.2
