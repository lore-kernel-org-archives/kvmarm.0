From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 2/3] KVM: Documentation: Document KVM_EXIT_IRQ
Date: Tue, 01 Dec 2015 13:19:44 +0300
Message-ID: <88f34826cecc1aed0d0617ce817fb91fd051745e.1448965024.git.p.fedin@samsung.com>
References: <cover.1448965024.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 682C949969
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 05:18:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G0AvuwpQYfhi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 05:18:30 -0500 (EST)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F11C4995C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 05:18:29 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYO008RTCP3SP50@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 01 Dec 2015 10:19:51 +0000 (GMT)
In-reply-to: <cover.1448965024.git.p.fedin@samsung.com>
In-reply-to: <cover.1448965024.git.p.fedin@samsung.com>
References: <cover.1448965024.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add documentation for the new exit code.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 Documentation/virtual/kvm/api.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 092ee9f..d8aae4c 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3331,6 +3331,20 @@ the userspace IOAPIC should process the EOI and retrigger the interrupt if
 it is still asserted.  Vector is the LAPIC interrupt vector for which the
 EOI was received.
 
+		/* KVM_EXIT_IRQ */
+		struct kvm_irq_level irq;
+
+Indicates that an interrupt happens, to be processed by irqchip implemented in
+userspace. irq.irq specifies the raw IRQ number, and irq.status is to be
+interpreted according to interrupt type:
+ For level-triggered interrupts irq.status is set to new level of the line, and
+  the exit happens upon level change.
+ For edge-triggered interrupts irq.status is set to active level of the line
+  (low or high), and the exit happens when the line is pulsed.
+
+CPU-private interrupts (like per-CPU timers) belong to the vCPU where the exit
+happened.
+
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.4.4
