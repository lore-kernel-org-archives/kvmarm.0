Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDEDBC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:07:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 849DA4B0BE;
	Mon, 29 Nov 2021 15:07:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QY99NGSLrBPU; Mon, 29 Nov 2021 15:07:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2C044B0F7;
	Mon, 29 Nov 2021 15:07:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B17E34B0D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gulD3YP12bdE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:07:17 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB53E4B12E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:16 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 7BC84CE1682;
 Mon, 29 Nov 2021 20:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250B4C53FC7;
 Mon, 29 Nov 2021 20:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216431;
 bh=YRAEqvmApOPt3HyGrB4klDsv8OSyIsYUJiXxEthpNUM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=L3ct5Z8TQjnonyp4pxIOjkzfYbb7yl8+AekAsdpVb6G2nmBRjawQiFlyrgXFUGhTw
 RYXmCjMpqHyEU4pRahXRIXTLoar/nSEdtg809HDhfADxbXl7odo6LRFUwyUPIo3IeC
 iZNtUAk+6deWyz/r0gof3d+pEY9HTDboN6RqYJLZgnwmRtikF1Az5fDxW1Ezjt8o+q
 FuamczylYMg2g2330GuOkjLopqdhrRIevSJRjRVvJahGR4LAN/ZniE32qGxEohZ8e+
 ixLOaAZ4+SFEuxrf+vUbQGp8FdnfSMqExU0BW7y619QtdGZkTGKbY9NuLf3jGEVE8h
 4PQOhAoxJuzJw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmrE-008gvR-AI; Mon, 29 Nov 2021 20:02:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 56/69] KVM: arm64: nv: Add nested GICv3 tracepoints
Date: Mon, 29 Nov 2021 20:01:37 +0000
Message-Id: <20211129200150.351436-57-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
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
index 4ba426e2324d..94b1edb67011 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -13,6 +13,9 @@
 
 #include "vgic.h"
 
+#define CREATE_TRACE_POINTS
+#include "vgic-nested-trace.h"
+
 static inline struct vgic_v3_cpu_if *vcpu_nested_if(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.vgic_cpu.nested_vgic_v3;
@@ -119,6 +122,9 @@ static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu)
 		used_lrs = i + 1;
 	}
 
+	trace_vgic_create_shadow_lrs(vcpu, kvm_vgic_global_state.nr_lr,
+				     s_cpu_if->vgic_lr, cpu_if->vgic_lr);
+
 	s_cpu_if->used_lrs = used_lrs;
 }
 
@@ -163,8 +169,10 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 			continue; /* oh well, the guest hyp is broken */
 
 		lr = __gic_v3_get_lr(i);
-		if (!(lr & ICH_LR_STATE))
+		if (!(lr & ICH_LR_STATE)) {
+			trace_vgic_nested_hw_emulate(i, lr, l1_irq);
 			irq->active = false;
+		}
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -195,6 +203,9 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 
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
