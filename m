From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v3 10/11] KVM: arm: add a trace event for cp14 traps
Date: Mon, 22 Jun 2015 18:41:33 +0800
Message-ID: <1434969694-7432-11-git-send-email-zhichao.huang@linaro.org>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

There are too many cp15 traps, so we don't reuse the cp15 trace event
but add a new trace event to trace the access of debug registers.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/kvm/coproc.c | 14 ++++++++++++++
 arch/arm/kvm/trace.h  | 30 ++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index fc0c2ef..42b720a 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -678,6 +678,13 @@ int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 	params.Rt2 = (kvm_vcpu_get_hsr(vcpu) >> 10) & 0xf;
 	params.CRm = 0;
 
+	if (global == cp14_regs)
+		trace_kvm_emulate_cp14_imp(params.Op1, params.Rt1, params.CRn,
+			params.CRm, params.Op2, params.is_write);
+	else
+		trace_kvm_emulate_cp15_imp(params.Op1, params.Rt1, params.CRn,
+			params.CRm, params.Op2, params.is_write);
+
 	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
 		return 1;
 	if (!emulate_cp(vcpu, &params, global, nr_global))
@@ -715,6 +722,13 @@ int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 	params.Op2 = (kvm_vcpu_get_hsr(vcpu) >> 17) & 0x7;
 	params.Rt2 = 0;
 
+	if (global == cp14_regs)
+		trace_kvm_emulate_cp14_imp(params.Op1, params.Rt1, params.CRn,
+			params.CRm, params.Op2, params.is_write);
+	else
+		trace_kvm_emulate_cp15_imp(params.Op1, params.Rt1, params.CRn,
+			params.CRm, params.Op2, params.is_write);
+
 	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
 		return 1;
 	if (!emulate_cp(vcpu, &params, global, nr_global))
diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
index 0ec3539..988da03 100644
--- a/arch/arm/kvm/trace.h
+++ b/arch/arm/kvm/trace.h
@@ -159,6 +159,36 @@ TRACE_EVENT(kvm_emulate_cp15_imp,
 			__entry->CRm, __entry->Op2)
 );
 
+/* Architecturally implementation defined CP14 register access */
+TRACE_EVENT(kvm_emulate_cp14_imp,
+	TP_PROTO(unsigned long Op1, unsigned long Rt1, unsigned long CRn,
+		 unsigned long CRm, unsigned long Op2, bool is_write),
+	TP_ARGS(Op1, Rt1, CRn, CRm, Op2, is_write),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	Op1		)
+		__field(	unsigned int,	Rt1		)
+		__field(	unsigned int,	CRn		)
+		__field(	unsigned int,	CRm		)
+		__field(	unsigned int,	Op2		)
+		__field(	bool,		is_write	)
+	),
+
+	TP_fast_assign(
+		__entry->is_write		= is_write;
+		__entry->Op1			= Op1;
+		__entry->Rt1			= Rt1;
+		__entry->CRn			= CRn;
+		__entry->CRm			= CRm;
+		__entry->Op2			= Op2;
+	),
+
+	TP_printk("Implementation defined CP14: %s\tp14, %u, r%u, c%u, c%u, %u",
+			(__entry->is_write) ? "mcr" : "mrc",
+			__entry->Op1, __entry->Rt1, __entry->CRn,
+			__entry->CRm, __entry->Op2)
+);
+
 TRACE_EVENT(kvm_wfx,
 	TP_PROTO(unsigned long vcpu_pc, bool is_wfe),
 	TP_ARGS(vcpu_pc, is_wfe),
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe kvm" in
