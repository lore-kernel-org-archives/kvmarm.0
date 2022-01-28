Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA07C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 28 Jan 2022 12:50:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3F04B150;
	Fri, 28 Jan 2022 07:50:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hKDIkTSMg7or; Fri, 28 Jan 2022 07:49:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B76C04B0FC;
	Fri, 28 Jan 2022 07:49:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28A534B104
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 07:49:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RxSCXz45jKQB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jan 2022 07:49:56 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D7144B0EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 07:49:56 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DA4EA61C50;
 Fri, 28 Jan 2022 12:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92176C340E0;
 Fri, 28 Jan 2022 12:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643374195;
 bh=/WD9vS3aGsgxXrltjrTwy01GzuUWdSjFwfNfSSKRHk0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tg1tNYAKlD2T3CZ/94Mycy8qotn/5edmjgfN+01H6DZ/ZpUyk7AXJYQ2J3EvVnggU
 zESeJ6ZUg46FZkmevlvHaQee1dy+o+yCjZF6zunocIVfLiyxMCVL00khFM3v3i/9O/
 HWqT6ZtQphP9MDG1Om1ck56OFvABjSIu734HhoBZ0XIzmISKnO+N9vUXVfNvza1TaC
 hNTKDziLMJY8sFo6/kyZ/irk+iTstFED/hPNeEzBh6GwXg5lAwwgDedpSBXTvVArio
 lUYSBOq/sDeVLQz/TlZF1s5PLFIGTL5ONksP1syFP1AWP3u2qDXCxxzg0nxzDTXsKb
 5vYw7rqmObsMg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nDQEW-003njR-4h; Fri, 28 Jan 2022 12:20:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v6 51/64] KVM: arm64: nv: Add nested GICv3 tracepoints
Date: Fri, 28 Jan 2022 12:18:59 +0000
Message-Id: <20220128121912.509006-52-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, chase.conklin@arm.com,
 linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com,
 miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>, mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

Adding tracepoints to be able to peek into the shadow LRs used when
running a guest guest.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-nested-trace.h | 137 ++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3-nested.c    |  13 ++-
 2 files changed, 149 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-nested-trace.h

diff --git a/arch/arm64/kvm/vgic/vgic-nested-trace.h b/arch/arm64/kvm/vgic/vgic-nested-trace.h
new file mode 100644
index 000000000000..f1a074c791a6
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-nested-trace.h
@@ -0,0 +1,137 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(_TRACE_VGIC_NESTED_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VGIC_NESTED_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvm
+
+#define SLR_ENTRY_VALS(x)							\
+	" ",									\
+	!!(__entry->lrs[x] & ICH_LR_HW),		   			\
+	!!(__entry->lrs[x] & ICH_LR_PENDING_BIT),	   			\
+	!!(__entry->lrs[x] & ICH_LR_ACTIVE_BIT),	   			\
+	__entry->lrs[x] & ICH_LR_VIRTUAL_ID_MASK,				\
+	(__entry->lrs[x] & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT,	\
+	(__entry->orig_lrs[x] & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT
+
+TRACE_EVENT(vgic_create_shadow_lrs,
+	TP_PROTO(struct kvm_vcpu *vcpu, int nr_lr, u64 *lrs, u64 *orig_lrs),
+	TP_ARGS(vcpu, nr_lr, lrs, orig_lrs),
+
+	TP_STRUCT__entry(
+		__field(	int,	nr_lr			)
+		__array(	u64,	lrs,		16	)
+		__array(	u64,	orig_lrs,	16	)
+	),
+
+	TP_fast_assign(
+		__entry->nr_lr		= nr_lr;
+		memcpy(__entry->lrs, lrs, 16 * sizeof(u64));
+		memcpy(__entry->orig_lrs, orig_lrs, 16 * sizeof(u64));
+	),
+
+	TP_printk("nr_lr: %d\n"
+		  "%50sLR[ 0]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 1]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 2]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 3]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 4]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 5]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 6]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 7]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 8]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 9]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[10]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[11]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[12]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[13]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[14]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[15]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)",
+		  __entry->nr_lr,
+		  SLR_ENTRY_VALS(0), SLR_ENTRY_VALS(1), SLR_ENTRY_VALS(2),
+		  SLR_ENTRY_VALS(3), SLR_ENTRY_VALS(4), SLR_ENTRY_VALS(5),
+		  SLR_ENTRY_VALS(6), SLR_ENTRY_VALS(7), SLR_ENTRY_VALS(8),
+		  SLR_ENTRY_VALS(9), SLR_ENTRY_VALS(10), SLR_ENTRY_VALS(11),
+		  SLR_ENTRY_VALS(12), SLR_ENTRY_VALS(13), SLR_ENTRY_VALS(14),
+		  SLR_ENTRY_VALS(15))
+);
+
+#define LR_ENTRY_VALS(x)							\
+	" ",									\
+	!!(__entry->lrs[x] & ICH_LR_HW),		   			\
+	!!(__entry->lrs[x] & ICH_LR_PENDING_BIT),	   			\
+	!!(__entry->lrs[x] & ICH_LR_ACTIVE_BIT),	   			\
+	__entry->lrs[x] & ICH_LR_VIRTUAL_ID_MASK,				\
+	(__entry->lrs[x] & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT
+
+TRACE_EVENT(vgic_put_nested,
+	TP_PROTO(struct kvm_vcpu *vcpu, int nr_lr, u64 *lrs),
+	TP_ARGS(vcpu, nr_lr, lrs),
+
+	TP_STRUCT__entry(
+		__field(	int,	nr_lr			)
+		__array(	u64,	lrs,		16	)
+	),
+
+	TP_fast_assign(
+		__entry->nr_lr		= nr_lr;
+		memcpy(__entry->lrs, lrs, 16 * sizeof(u64));
+	),
+
+	TP_printk("nr_lr: %d\n"
+		  "%50sLR[ 0]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 1]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 2]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 3]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 4]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 5]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 6]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 7]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 8]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 9]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[10]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[11]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[12]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[13]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[14]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[15]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu",
+		  __entry->nr_lr,
+		  LR_ENTRY_VALS(0), LR_ENTRY_VALS(1), LR_ENTRY_VALS(2),
+		  LR_ENTRY_VALS(3), LR_ENTRY_VALS(4), LR_ENTRY_VALS(5),
+		  LR_ENTRY_VALS(6), LR_ENTRY_VALS(7), LR_ENTRY_VALS(8),
+		  LR_ENTRY_VALS(9), LR_ENTRY_VALS(10), LR_ENTRY_VALS(11),
+		  LR_ENTRY_VALS(12), LR_ENTRY_VALS(13), LR_ENTRY_VALS(14),
+		  LR_ENTRY_VALS(15))
+);
+
+TRACE_EVENT(vgic_nested_hw_emulate,
+	TP_PROTO(int lr, u64 lr_val, u32 l1_intid),
+	TP_ARGS(lr, lr_val, l1_intid),
+
+	TP_STRUCT__entry(
+		__field(	int,	lr		)
+		__field(	u64,	lr_val		)
+		__field(	u32,	l1_intid	)
+	),
+
+	TP_fast_assign(
+		__entry->lr		= lr;
+		__entry->lr_val		= lr_val;
+		__entry->l1_intid	= l1_intid;
+	),
+
+	TP_printk("lr: %d LR %llx L1 INTID: %u\n",
+		  __entry->lr, __entry->lr_val, __entry->l1_intid)
+);
+
+#endif /* _TRACE_VGIC_NESTED_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH vgic/
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE vgic-nested-trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 4a35c2be7984..02b0b335f72a 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -15,6 +15,9 @@
 
 #include "vgic.h"
 
+#define CREATE_TRACE_POINTS
+#include "vgic-nested-trace.h"
+
 static inline struct vgic_v3_cpu_if *vcpu_nested_if(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.vgic_cpu.nested_vgic_v3;
@@ -121,6 +124,9 @@ static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu)
 		used_lrs = i + 1;
 	}
 
+	trace_vgic_create_shadow_lrs(vcpu, kvm_vgic_global_state.nr_lr,
+				     s_cpu_if->vgic_lr, cpu_if->vgic_lr);
+
 	s_cpu_if->used_lrs = used_lrs;
 }
 
@@ -165,8 +171,10 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 			continue; /* oh well, the guest hyp is broken */
 
 		lr = __gic_v3_get_lr(i);
-		if (!(lr & ICH_LR_STATE))
+		if (!(lr & ICH_LR_STATE)) {
+			trace_vgic_nested_hw_emulate(i, lr, l1_irq);
 			irq->active = false;
+		}
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -197,6 +205,9 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 
 	__vgic_v3_save_state(vcpu_shadow_if(vcpu));
 
+	trace_vgic_put_nested(vcpu, kvm_vgic_global_state.nr_lr,
+			      vcpu_shadow_if(vcpu)->vgic_lr);
+
 	/*
 	 * Translate the shadow state HW fields back to the virtual ones
 	 * before copying the shadow struct back to the nested one.
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
