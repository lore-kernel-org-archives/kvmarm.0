From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 03/10] irq: add irq__get_nr_allocated_lines
Date: Fri, 26 Jun 2015 14:16:11 +0100
Message-ID: <1435324578-21832-4-git-send-email-andre.przywara@arm.com>
References: <1435324578-21832-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1435324578-21832-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: penberg@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The ARM GIC emulation needs to be told the number of interrupts
it has to support. As commit 1c262fa1dc7bc ("kvm tools: irq: make
irq__alloc_line generic") made the interrupt counter private,
add a new accessor returning the number of interrupt lines we've
allocated so far.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/irq.h | 1 +
 irq.c             | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/kvm/irq.h b/include/kvm/irq.h
index 4cec6f0..8a78e43 100644
--- a/include/kvm/irq.h
+++ b/include/kvm/irq.h
@@ -11,6 +11,7 @@
 struct kvm;
 
 int irq__alloc_line(void);
+int irq__get_nr_allocated_lines(void);
 
 int irq__init(struct kvm *kvm);
 int irq__exit(struct kvm *kvm);
diff --git a/irq.c b/irq.c
index 33ea8d2..71eaa05 100644
--- a/irq.c
+++ b/irq.c
@@ -7,3 +7,8 @@ int irq__alloc_line(void)
 {
 	return next_line++;
 }
+
+int irq__get_nr_allocated_lines(void)
+{
+	return next_line - KVM_IRQ_OFFSET;
+}
-- 
2.3.5

