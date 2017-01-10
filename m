From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v3 3/9] KVM: Add event to trace tlb invalidations
Date: Tue, 10 Jan 2017 11:38:50 +0000
Message-ID: <20170110113856.7183-4-punit.agrawal@arm.com>
References: <20170110113856.7183-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5951405B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 06:38:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AhtTGuyTxTEU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jan 2017 06:38:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 030AD40430
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 06:38:17 -0500 (EST)
In-Reply-To: <20170110113856.7183-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

As TLB operations can have an impact on system performance, add a trace
event to enable monitoring of guest TLB maintenance operations.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 include/trace/events/kvm.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 8ade3eb6c640..fbe33089264c 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -393,6 +393,24 @@ TRACE_EVENT(kvm_halt_poll_ns,
 #define trace_kvm_halt_poll_ns_shrink(vcpu_id, new, old) \
 	trace_kvm_halt_poll_ns(false, vcpu_id, new, old)
 
+TRACE_EVENT(kvm_tlb_invalidate,
+	TP_PROTO(unsigned long vcpu_pc, u32 opcode),
+	TP_ARGS(vcpu_pc, opcode),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, vcpu_pc)
+		__field(u32, opcode)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_pc = vcpu_pc;
+		__entry->opcode = opcode;
+	),
+
+	TP_printk("vcpu_pc=0x%16lx opcode=%08x", __entry->vcpu_pc,
+		  __entry->opcode)
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
-- 
2.11.0
