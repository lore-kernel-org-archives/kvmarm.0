From: Roman Storozhenko <romeusmeister@gmail.com>
Subject: [PATCH] KVM: Replaces 'unsigned' with 'unsigned int' in the codebase
Date: Tue, 27 Jun 2017 12:54:01 +0300
Message-ID: <20170627095401.GA19864@home>
Reply-To: 'Roman Storozhenko <romeusmeister@gmail.com>, '@home
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Roman Storozhenko <romeusmeister@gmail.com>
---
 virt/kvm/arm/arm.c        |  2 +-
 virt/kvm/coalesced_mmio.c |  2 +-
 virt/kvm/eventfd.c        | 10 ++++++----
 virt/kvm/irqchip.c        |  7 ++++---
 virt/kvm/kvm_main.c       | 16 ++++++++--------
 5 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a39a1e1..dbe402f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -992,7 +992,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_REG_LIST: {
 		struct kvm_reg_list __user *user_list = argp;
 		struct kvm_reg_list reg_list;
-		unsigned n;
+		unsigned int n;
 
 		if (unlikely(!kvm_vcpu_initialized(vcpu)))
 			return -ENOEXEC;
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 571c1ce..805dfbb 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -42,7 +42,7 @@ static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
 static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev)
 {
 	struct kvm_coalesced_mmio_ring *ring;
-	unsigned avail;
+	unsigned int avail;
 
 	/* Are we able to batch it ? */
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 9120edf..0359ed7 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -184,14 +184,14 @@ int __attribute__((weak)) kvm_arch_set_irq_inatomic(
  * Called with wqh->lock held and interrupts disabled
  */
 static int
-irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
+irqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode, int sync, void *key)
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(wait, struct kvm_kernel_irqfd, wait);
 	unsigned long flags = (unsigned long)key;
 	struct kvm_kernel_irq_routing_entry irq;
 	struct kvm *kvm = irqfd->kvm;
-	unsigned seq;
+	unsigned int seq;
 	int idx;
 
 	if (flags & POLLIN) {
@@ -440,7 +440,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	return ret;
 }
 
-bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
+bool kvm_irq_has_notifier(struct kvm *kvm, unsigned int irqchip,
+			  unsigned int pin)
 {
 	struct kvm_irq_ack_notifier *kian;
 	int gsi, idx;
@@ -471,7 +472,8 @@ void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
 			kian->irq_acked(kian);
 }
 
-void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
+void kvm_notify_acked_irq(struct kvm *kvm, unsigned int irqchip,
+			  unsigned int pin)
 {
 	int gsi, idx;
 
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 31e40c9..f073ecf 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -50,7 +50,8 @@ int kvm_irq_map_gsi(struct kvm *kvm,
 	return n;
 }
 
-int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
+int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned int irqchip,
+			 unsigned int pin)
 {
 	struct kvm_irq_routing_table *irq_rt;
 
@@ -179,8 +180,8 @@ bool __weak kvm_arch_can_set_irq_routing(struct kvm *kvm)
 
 int kvm_set_irq_routing(struct kvm *kvm,
 			const struct kvm_irq_routing_entry *ue,
-			unsigned nr,
-			unsigned flags)
+			unsigned int nr,
+			unsigned int flags)
 {
 	struct kvm_irq_routing_table *new, *old;
 	struct kvm_kernel_irq_routing_entry *e;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3863cf7..0906847 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -166,7 +166,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(vcpu_put);
 
 /* TODO: merge with kvm_arch_vcpu_should_kick */
-static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
+static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned int req)
 {
 	int mode = kvm_vcpu_exiting_guest_mode(vcpu);
 
@@ -252,7 +252,7 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
-int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
+int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned int id)
 {
 	struct page *page;
 	int r;
@@ -2230,7 +2230,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 		return;
 
 	me = get_cpu();
-	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
+	if (cpu != me && (unsigned int)cpu < nr_cpu_ids && cpu_online(cpu))
 		if (kvm_arch_vcpu_should_kick(vcpu))
 			smp_send_reschedule(cpu);
 	put_cpu();
@@ -3766,7 +3766,7 @@ static const struct file_operations *stat_fops_per_vm[] = {
 
 static int vm_stat_get(void *_offset, u64 *val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 	struct kvm_stat_data stat_tmp = {.offset = offset};
 	u64 tmp_val;
@@ -3784,7 +3784,7 @@ static int vm_stat_get(void *_offset, u64 *val)
 
 static int vm_stat_clear(void *_offset, u64 val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 	struct kvm_stat_data stat_tmp = {.offset = offset};
 
@@ -3805,7 +3805,7 @@ DEFINE_SIMPLE_ATTRIBUTE(vm_stat_fops, vm_stat_get, vm_stat_clear, "%llu\n");
 
 static int vcpu_stat_get(void *_offset, u64 *val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 	struct kvm_stat_data stat_tmp = {.offset = offset};
 	u64 tmp_val;
@@ -3823,7 +3823,7 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 
 static int vcpu_stat_clear(void *_offset, u64 val)
 {
-	unsigned offset = (long)_offset;
+	unsigned int offset = (long)_offset;
 	struct kvm *kvm;
 	struct kvm_stat_data stat_tmp = {.offset = offset};
 
@@ -3921,7 +3921,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	kvm_arch_vcpu_put(vcpu);
 }
 
-int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
+int kvm_init(void *opaque, unsigned int vcpu_size, unsigned int vcpu_align,
 		  struct module *module)
 {
 	int r;
-- 
2.7.4
