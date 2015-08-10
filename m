From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v4 08/15] KVM: arm: add a trace event for cp14 traps
Date: Mon, 10 Aug 2015 21:26:00 +0800
Message-ID: <1439213167-8988-9-git-send-email-zhichao.huang@linaro.org>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE1F85A766
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:14:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YLA+CJ7pCbuT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:14:44 -0400 (EDT)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
 [209.85.220.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00E415A777
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:14:43 -0400 (EDT)
Received: by pabyb7 with SMTP id yb7so106839422pab.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:27:44 -0700 (PDT)
In-Reply-To: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

There are too many cp15 traps, so we don't reuse the cp15 trace event
but add a new trace event to trace the access of debug registers.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/coproc.c | 14 ++++++++++++++
 arch/arm/kvm/trace.h  | 30 ++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 2164f4e..d15b250 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -643,6 +643,13 @@ int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
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
@@ -680,6 +687,13 @@ int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
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
