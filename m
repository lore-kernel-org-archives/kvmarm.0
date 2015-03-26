From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 11/11] KVM: arm/arm64: rework MMIO abort handling to use
 KVM MMIO bus
Date: Thu, 26 Mar 2015 14:39:38 +0000
Message-ID: <1427380778-942-12-git-send-email-andre.przywara@arm.com>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61E4649C21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 10:32:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id imeHq33qscQM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 10:32:42 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF03749C1F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 10:32:41 -0400 (EDT)
In-Reply-To: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Currently we have struct kvm_exit_mmio for encapsulating MMIO abort
data to be passed on from syndrome decoding all the way down to the
VGIC register handlers. Now as we switch the MMIO handling to be
routed through the KVM MMIO bus, it does not make sense anymore to
use that structure already from the beginning. So we put the data into
kvm_run very early and use that encapsulation till the MMIO bus call.
Then we fill kvm_exit_mmio in the VGIC only, making it a VGIC private
structure. On that way we replace the data buffer in that structure
with a pointer pointing to a single location in kvm_run, so we get
rid of some copying on the way.
With all of the virtual GIC emulation code now being registered with
the kvm_io_bus, we can remove all of the old MMIO handling code and
its dispatching functionality.

I didn't bother to rename kvm_exit_mmio (to vgic_mmio or something),
because that touches a lot of code lines without any good reason.

This is based on an original patch by Nikolay.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Cc: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
---
 arch/arm/include/asm/kvm_mmio.h   |   22 ---------
 arch/arm/kvm/mmio.c               |   60 ++++++++++++++++++-------
 arch/arm64/include/asm/kvm_mmio.h |   22 ---------
 include/kvm/arm_vgic.h            |    6 ---
 virt/kvm/arm/vgic-v2-emul.c       |   21 +--------
 virt/kvm/arm/vgic-v3-emul.c       |   35 ---------------
 virt/kvm/arm/vgic.c               |   89 ++-----------------------------------
 virt/kvm/arm/vgic.h               |   13 +++---
 8 files changed, 57 insertions(+), 211 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmio.h b/arch/arm/include/asm/kvm_mmio.h
index 3f83db2..d8e90c8 100644
--- a/arch/arm/include/asm/kvm_mmio.h
+++ b/arch/arm/include/asm/kvm_mmio.h
@@ -28,28 +28,6 @@ struct kvm_decode {
 	bool sign_extend;
 };
 
-/*
- * The in-kernel MMIO emulation code wants to use a copy of run->mmio,
- * which is an anonymous type. Use our own type instead.
- */
-struct kvm_exit_mmio {
-	phys_addr_t	phys_addr;
-	u8		data[8];
-	u32		len;
-	bool		is_write;
-	void		*private;
-};
-
-static inline void kvm_prepare_mmio(struct kvm_run *run,
-				    struct kvm_exit_mmio *mmio)
-{
-	run->mmio.phys_addr	= mmio->phys_addr;
-	run->mmio.len		= mmio->len;
-	run->mmio.is_write	= mmio->is_write;
-	memcpy(run->mmio.data, mmio->data, mmio->len);
-	run->exit_reason	= KVM_EXIT_MMIO;
-}
-
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 phys_addr_t fault_ipa);
diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 5d3bfc0..bb2ab44 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -122,7 +122,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 }
 
 static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-		      struct kvm_exit_mmio *mmio)
+		      struct kvm_run *run)
 {
 	unsigned long rt;
 	int len;
@@ -148,9 +148,9 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	sign_extend = kvm_vcpu_dabt_issext(vcpu);
 	rt = kvm_vcpu_dabt_get_rd(vcpu);
 
-	mmio->is_write = is_write;
-	mmio->phys_addr = fault_ipa;
-	mmio->len = len;
+	run->mmio.is_write = is_write;
+	run->mmio.phys_addr = fault_ipa;
+	run->mmio.len = len;
 	vcpu->arch.mmio_decode.sign_extend = sign_extend;
 	vcpu->arch.mmio_decode.rt = rt;
 
@@ -162,23 +162,49 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	return 0;
 }
 
+/**
+ * handle_kernel_mmio - handle an in-kernel MMIO access
+ * @vcpu:	pointer to the vcpu performing the access
+ * @run:	pointer to the kvm_run structure
+ *
+ * returns true if the MMIO access has been performed in kernel space,
+ * and false if it needs to be emulated in user space.
+ */
+static bool handle_kernel_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	int ret;
+
+	if (run->mmio.is_write) {
+		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, run->mmio.phys_addr,
+				       run->mmio.len, run->mmio.data);
+
+	} else {
+		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, run->mmio.phys_addr,
+				      run->mmio.len, run->mmio.data);
+	}
+	if (!ret) {
+		kvm_handle_mmio_return(vcpu, run);
+		return true;
+	}
+
+	return false;
+}
+
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 phys_addr_t fault_ipa)
 {
-	struct kvm_exit_mmio mmio;
 	unsigned long data;
 	unsigned long rt;
 	int ret;
 
 	/*
-	 * Prepare MMIO operation. First stash it in a private
-	 * structure that we can use for in-kernel emulation. If the
-	 * kernel can't handle it, copy it into run->mmio and let user
-	 * space do its magic.
+	 * Prepare MMIO operation. First put the MMIO data into run->mmio.
+	 * Then try if some in-kernel emulation feels responsible, otherwise
+	 * let user space do its magic.
 	 */
 
 	if (kvm_vcpu_dabt_isvalid(vcpu)) {
-		ret = decode_hsr(vcpu, fault_ipa, &mmio);
+		ret = decode_hsr(vcpu, fault_ipa, run);
 		if (ret)
 			return ret;
 	} else {
@@ -188,21 +214,21 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
 	rt = vcpu->arch.mmio_decode.rt;
 
-	if (mmio.is_write) {
+	if (run->mmio.is_write) {
 		data = vcpu_data_guest_to_host(vcpu, *vcpu_reg(vcpu, rt),
-					       mmio.len);
+					       run->mmio.len);
 
-		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, mmio.len,
+		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, run->mmio.len,
 			       fault_ipa, data);
-		mmio_write_buf(mmio.data, mmio.len, data);
+		mmio_write_buf(run->mmio.data, run->mmio.len, data);
 	} else {
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, mmio.len,
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, run->mmio.len,
 			       fault_ipa, 0);
 	}
 
-	if (vgic_handle_mmio(vcpu, run, &mmio))
+	if (handle_kernel_mmio(vcpu, run))
 		return 1;
 
-	kvm_prepare_mmio(run, &mmio);
+	run->exit_reason = KVM_EXIT_MMIO;
 	return 0;
 }
diff --git a/arch/arm64/include/asm/kvm_mmio.h b/arch/arm64/include/asm/kvm_mmio.h
index 9f52beb..889c908 100644
--- a/arch/arm64/include/asm/kvm_mmio.h
+++ b/arch/arm64/include/asm/kvm_mmio.h
@@ -31,28 +31,6 @@ struct kvm_decode {
 	bool sign_extend;
 };
 
-/*
- * The in-kernel MMIO emulation code wants to use a copy of run->mmio,
- * which is an anonymous type. Use our own type instead.
- */
-struct kvm_exit_mmio {
-	phys_addr_t	phys_addr;
-	u8		data[8];
-	u32		len;
-	bool		is_write;
-	void		*private;
-};
-
-static inline void kvm_prepare_mmio(struct kvm_run *run,
-				    struct kvm_exit_mmio *mmio)
-{
-	run->mmio.phys_addr	= mmio->phys_addr;
-	run->mmio.len		= mmio->len;
-	run->mmio.is_write	= mmio->is_write;
-	memcpy(run->mmio.data, mmio->data, mmio->len);
-	run->exit_reason	= KVM_EXIT_MMIO;
-}
-
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 phys_addr_t fault_ipa);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d6705f4..16ec2c8 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -140,8 +140,6 @@ struct vgic_params {
 };
 
 struct vgic_vm_ops {
-	bool	(*handle_mmio)(struct kvm_vcpu *, struct kvm_run *,
-			       struct kvm_exit_mmio *);
 	bool	(*queue_sgi)(struct kvm_vcpu *, int irq);
 	void	(*add_sgi_source)(struct kvm_vcpu *, int irq, int source);
 	int	(*init_model)(struct kvm *);
@@ -313,8 +311,6 @@ struct vgic_cpu {
 
 struct kvm;
 struct kvm_vcpu;
-struct kvm_run;
-struct kvm_exit_mmio;
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
 int kvm_vgic_hyp_init(void);
@@ -330,8 +326,6 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
-bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
-		      struct kvm_exit_mmio *mmio);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 7460b37..1390797 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -404,24 +404,6 @@ static const struct vgic_io_range vgic_dist_ranges[] = {
 	{}
 };
 
-static bool vgic_v2_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				struct kvm_exit_mmio *mmio)
-{
-	unsigned long base = vcpu->kvm->arch.vgic.vgic_dist_base;
-
-	if (!is_in_range(mmio->phys_addr, mmio->len, base,
-			 KVM_VGIC_V2_DIST_SIZE))
-		return false;
-
-	/* GICv2 does not support accesses wider than 32 bits */
-	if (mmio->len > 4) {
-		kvm_inject_dabt(vcpu, mmio->phys_addr);
-		return true;
-	}
-
-	return vgic_handle_mmio_range(vcpu, run, mmio, vgic_dist_ranges, base);
-}
-
 static void vgic_dispatch_sgi(struct kvm_vcpu *vcpu, u32 reg)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -580,7 +562,6 @@ void vgic_v2_init_emulation(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	dist->vm_ops.handle_mmio = vgic_v2_handle_mmio;
 	dist->vm_ops.queue_sgi = vgic_v2_queue_sgi;
 	dist->vm_ops.add_sgi_source = vgic_v2_add_sgi_source;
 	dist->vm_ops.init_model = vgic_v2_init_model;
@@ -690,6 +671,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 	struct kvm_vcpu *vcpu, *tmp_vcpu;
 	struct vgic_dist *vgic;
 	struct kvm_exit_mmio mmio;
+	u32 data;
 
 	offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
 	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
@@ -711,6 +693,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 
 	mmio.len = 4;
 	mmio.is_write = is_write;
+	mmio.data = &data;
 	if (is_write)
 		mmio_data_write(&mmio, ~0, *reg);
 	switch (attr->group) {
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index eb1a797..e9c3a7a 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -708,40 +708,6 @@ static const struct vgic_io_range vgic_redist_ranges[] = {
 	{},
 };
 
-/*
- * This function splits accesses between the distributor and the two
- * redistributor parts (private/SPI). As each redistributor is accessible
- * from any CPU, we have to determine the affected VCPU by taking the faulting
- * address into account. We then pass this VCPU to the handler function via
- * the private parameter.
- */
-#define SGI_BASE_OFFSET SZ_64K
-static bool vgic_v3_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				struct kvm_exit_mmio *mmio)
-{
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	unsigned long dbase = dist->vgic_dist_base;
-	unsigned long rdbase = dist->vgic_redist_base;
-	int nrcpus = atomic_read(&vcpu->kvm->online_vcpus);
-	int vcpu_id;
-
-	if (is_in_range(mmio->phys_addr, mmio->len, dbase, GIC_V3_DIST_SIZE)) {
-		return vgic_handle_mmio_range(vcpu, run, mmio,
-					      vgic_v3_dist_ranges, dbase);
-	}
-
-	if (!is_in_range(mmio->phys_addr, mmio->len, rdbase,
-	    GIC_V3_REDIST_SIZE * nrcpus))
-		return false;
-
-	vcpu_id = (mmio->phys_addr - rdbase) / GIC_V3_REDIST_SIZE;
-	rdbase += (vcpu_id * GIC_V3_REDIST_SIZE);
-	mmio->private = kvm_get_vcpu(vcpu->kvm, vcpu_id);
-
-	return vgic_handle_mmio_range(vcpu, run, mmio, vgic_redist_ranges,
-				      rdbase);
-}
-
 static bool vgic_v3_queue_sgi(struct kvm_vcpu *vcpu, int irq)
 {
 	if (vgic_queue_irq(vcpu, 0, irq)) {
@@ -861,7 +827,6 @@ void vgic_v3_init_emulation(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	dist->vm_ops.handle_mmio = vgic_v3_handle_mmio;
 	dist->vm_ops.queue_sgi = vgic_v3_queue_sgi;
 	dist->vm_ops.add_sgi_source = vgic_v3_add_sgi_source;
 	dist->vm_ops.init_model = vgic_v3_init_model;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index e968179..901c130 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -758,7 +758,6 @@ static bool call_range_handler(struct kvm_vcpu *vcpu,
 			       unsigned long offset,
 			       const struct vgic_io_range *range)
 {
-	u32 *data32 = (void *)mmio->data;
 	struct kvm_exit_mmio mmio32;
 	bool ret;
 
@@ -775,70 +774,17 @@ static bool call_range_handler(struct kvm_vcpu *vcpu,
 	mmio32.private = mmio->private;
 
 	mmio32.phys_addr = mmio->phys_addr + 4;
-	if (mmio->is_write)
-		*(u32 *)mmio32.data = data32[1];
+	mmio32.data = &((u32 *)mmio->data)[1];
 	ret = range->handle_mmio(vcpu, &mmio32, offset + 4);
-	if (!mmio->is_write)
-		data32[1] = *(u32 *)mmio32.data;
 
 	mmio32.phys_addr = mmio->phys_addr;
-	if (mmio->is_write)
-		*(u32 *)mmio32.data = data32[0];
+	mmio32.data = &((u32 *)mmio->data)[0];
 	ret |= range->handle_mmio(vcpu, &mmio32, offset);
-	if (!mmio->is_write)
-		data32[0] = *(u32 *)mmio32.data;
 
 	return ret;
 }
 
 /**
- * vgic_handle_mmio_range - handle an in-kernel MMIO access
- * @vcpu:	pointer to the vcpu performing the access
- * @run:	pointer to the kvm_run structure
- * @mmio:	pointer to the data describing the access
- * @ranges:	array of MMIO ranges in a given region
- * @mmio_base:	base address of that region
- *
- * returns true if the MMIO access could be performed
- */
-bool vgic_handle_mmio_range(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			    struct kvm_exit_mmio *mmio,
-			    const struct vgic_io_range *ranges,
-			    unsigned long mmio_base)
-{
-	const struct vgic_io_range *range;
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	bool updated_state;
-	unsigned long offset;
-
-	offset = mmio->phys_addr - mmio_base;
-	range = vgic_find_range(ranges, mmio->len, offset);
-	if (unlikely(!range || !range->handle_mmio)) {
-		pr_warn("Unhandled access %d %08llx %d\n",
-			mmio->is_write, mmio->phys_addr, mmio->len);
-		return false;
-	}
-
-	spin_lock(&vcpu->kvm->arch.vgic.lock);
-	offset -= range->base;
-	if (vgic_validate_access(dist, range, offset)) {
-		updated_state = call_range_handler(vcpu, mmio, offset, range);
-	} else {
-		if (!mmio->is_write)
-			memset(mmio->data, 0, mmio->len);
-		updated_state = false;
-	}
-	spin_unlock(&vcpu->kvm->arch.vgic.lock);
-	kvm_prepare_mmio(run, mmio);
-	kvm_handle_mmio_return(vcpu, run);
-
-	if (updated_state)
-		vgic_kick_vcpus(vcpu->kvm);
-
-	return true;
-}
-
-/**
  * vgic_handle_mmio_access - handle an in-kernel MMIO access
  * This is called by the read/write KVM IO device wrappers below.
  * @vcpu:	pointer to the vcpu performing the access
@@ -873,23 +819,20 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
 	mmio.phys_addr = addr;
 	mmio.len = len;
 	mmio.is_write = is_write;
-	if (is_write)
-		memcpy(mmio.data, val, len);
+	mmio.data = val;
 	mmio.private = iodev->redist_vcpu;
 
 	spin_lock(&dist->lock);
 	offset -= range->base;
 	if (vgic_validate_access(dist, range, offset)) {
 		updated_state = call_range_handler(vcpu, &mmio, offset, range);
-		if (!is_write)
-			memcpy(val, mmio.data, len);
 	} else {
 		if (!is_write)
 			memset(val, 0, len);
 		updated_state = false;
 	}
 	spin_unlock(&dist->lock);
-	kvm_prepare_mmio(run, &mmio);
+	run->exit_reason = KVM_EXIT_MMIO;
 	kvm_handle_mmio_return(vcpu, run);
 
 	if (updated_state)
@@ -898,30 +841,6 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-/**
- * vgic_handle_mmio - handle an in-kernel MMIO access for the GIC emulation
- * @vcpu:      pointer to the vcpu performing the access
- * @run:       pointer to the kvm_run structure
- * @mmio:      pointer to the data describing the access
- *
- * returns true if the MMIO access has been performed in kernel space,
- * and false if it needs to be emulated in user space.
- * Calls the actual handling routine for the selected VGIC model.
- */
-bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
-		      struct kvm_exit_mmio *mmio)
-{
-	if (!irqchip_in_kernel(vcpu->kvm))
-		return false;
-
-	/*
-	 * This will currently call either vgic_v2_handle_mmio() or
-	 * vgic_v3_handle_mmio(), which in turn will call
-	 * vgic_handle_mmio_range() defined above.
-	 */
-	return vcpu->kvm->arch.vgic.vm_ops.handle_mmio(vcpu, run, mmio);
-}
-
 static int vgic_handle_mmio_read(struct kvm_vcpu *vcpu,
 				 struct kvm_io_device *this,
 				 gpa_t addr, int len, void *val)
diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
index 28fa3aa..0df74cb 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -59,6 +59,14 @@ void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq);
 void vgic_unqueue_irqs(struct kvm_vcpu *vcpu);
 
+struct kvm_exit_mmio {
+	phys_addr_t	phys_addr;
+	void		*data;
+	u32		len;
+	bool		is_write;
+	void		*private;
+};
+
 void vgic_reg_access(struct kvm_exit_mmio *mmio, u32 *reg,
 		     phys_addr_t offset, int mode);
 bool handle_mmio_raz_wi(struct kvm_vcpu *vcpu, struct kvm_exit_mmio *mmio,
@@ -99,11 +107,6 @@ const
 struct vgic_io_range *vgic_find_range(const struct vgic_io_range *ranges,
 				      int len, gpa_t offset);
 
-bool vgic_handle_mmio_range(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			    struct kvm_exit_mmio *mmio,
-			    const struct vgic_io_range *ranges,
-			    unsigned long mmio_base);
-
 bool vgic_handle_enable_reg(struct kvm *kvm, struct kvm_exit_mmio *mmio,
 			    phys_addr_t offset, int vcpu_id, int access);
 
-- 
1.7.9.5
