From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v2 5/8] KVM: Add event to trace tlb invalidations
Date: Wed, 26 Oct 2016 18:41:45 +0100
Message-ID: <20161026174148.17172-6-punit.agrawal@arm.com>
References: <20161026174148.17172-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DC5040460
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Oct 2016 13:42:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GGLwQMkkFb+r for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Oct 2016 13:42:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6964F4041B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Oct 2016 13:42:39 -0400 (EDT)
In-Reply-To: <20161026174148.17172-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

As TLB operations can have an impact on system performance, add a trace
event to enable monitoring of guest TLB maintenance operations.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 include/trace/events/kvm.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 8ade3eb..4b3d07e 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -393,6 +393,23 @@ TRACE_EVENT(kvm_halt_poll_ns,
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
+	TP_printk("vcpu_pc=0x%16lx opcode=%08x", __entry->vcpu_pc, __entry->opcode)
+);
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
-- 
2.9.3
