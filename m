From: amittomer25@gmail.com
Subject: [PATCH] KVM: arm/arm64: Output Guest cntvoff value
Date: Sat,  2 Jan 2016 00:28:29 +0530
Message-ID: <1451674709-31074-1-git-send-email-amittomer25@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F12C541145
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jan 2016 13:55:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KrpduzfURBHt for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jan 2016 13:55:14 -0500 (EST)
Received: from mail-pf0-f194.google.com (mail-pf0-f194.google.com
 [209.85.192.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB9F24113E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jan 2016 13:55:13 -0500 (EST)
Received: by mail-pf0-f194.google.com with SMTP id q63so14603565pfb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Jan 2016 10:58:35 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Amit Tomar <amittomer25@gmail.com>

This provides an easy access to guest's CVTVOFF value, somewhat
similar to how x86 outputs TSC offset value.

Signed-off-by: Amit Singh Tomar <amittomer25@gmail.com>
---
 virt/kvm/arm/arch_timer.c |    1 +
 virt/kvm/arm/trace.h      |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 69bca18..b0800fe 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -466,4 +466,5 @@ void kvm_timer_enable(struct kvm *kvm)
 void kvm_timer_init(struct kvm *kvm)
 {
 	kvm->arch.timer.cntvoff = kvm_phys_timer_read();
+	trace_kvm_timer_init(kvm->arch.timer.cntvoff);
 }
diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index 37d8b98..c7e1c2f 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -52,6 +52,21 @@ TRACE_EVENT(kvm_timer_update_irq,
 		  __entry->vcpu_id, __entry->irq, __entry->level)
 );
 
+TRACE_EVENT(kvm_timer_init,
+	TP_PROTO(unsigned long long cntvoff),
+	TP_ARGS(cntvoff),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long, cntvoff)
+	),
+
+	TP_fast_assign(
+		__entry->cntvoff	= cntvoff;
+	),
+
+	TP_printk("CNTVOFF: %llx", __entry->cntvoff)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.9.5
