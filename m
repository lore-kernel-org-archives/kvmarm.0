From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 12/12] KVM: arm/arm64: remove now obsolete VGIC specific
 MMIO handling code
Date: Mon, 23 Mar 2015 15:58:29 +0000
Message-ID: <1427126309-11223-13-git-send-email-andre.przywara@arm.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1A7449786
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 11:51:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hj3Yd+j3G+Et for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2015 11:51:47 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 687EB49722
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 11:51:46 -0400 (EDT)
In-Reply-To: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

With all of the virtual GIC emulation code now being registered with
the kvm_io_bus, we can remove all of the old MMIO handling code and
its dispatching functionality.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h      |    2 --
 virt/kvm/arm/vgic-v2-emul.c |   19 ------------
 virt/kvm/arm/vgic-v3-emul.c |   39 ------------------------
 virt/kvm/arm/vgic.c         |   71 -------------------------------------------
 virt/kvm/arm/vgic.h         |    5 ---
 5 files changed, 136 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 14853d8..9503664 100644
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
diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 69f27c8..12cb1361 100644
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
@@ -575,7 +557,6 @@ void vgic_v2_init_emulation(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	dist->vm_ops.handle_mmio = vgic_v2_handle_mmio;
 	dist->vm_ops.queue_sgi = vgic_v2_queue_sgi;
 	dist->vm_ops.add_sgi_source = vgic_v2_add_sgi_source;
 	dist->vm_ops.init_model = vgic_v2_init_model;
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 35679d1..4d443a07 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -710,45 +710,7 @@ static const struct vgic_io_range vgic_redist_ranges[] = {
 	{},
 };
 
-/*
- * This function splits accesses between the distributor and the two
- * redistributor parts (private/SPI). As each redistributor is accessible
- * from any CPU, we have to determine the affected VCPU by taking the faulting
- * address into account. We then pass this VCPU to the handler function via
- * the private parameter.
- */
 #define SGI_BASE_OFFSET SZ_64K
-static bool vgic_v3_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
-				struct kvm_exit_mmio *mmio)
-{
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	unsigned long dbase = dist->vgic_dist_base;
-	unsigned long rdbase = dist->vgic_redist_base;
-	int nrcpus = atomic_read(&vcpu->kvm->online_vcpus);
-	int vcpu_id;
-	const struct vgic_io_range *mmio_range;
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
-	if (mmio->phys_addr >= rdbase + SGI_BASE_OFFSET) {
-		rdbase += SGI_BASE_OFFSET;
-		mmio_range = vgic_redist_sgi_ranges;
-	} else {
-		mmio_range = vgic_redist_ranges;
-	}
-	return vgic_handle_mmio_range(vcpu, run, mmio, mmio_range, rdbase);
-}
 
 static bool vgic_v3_queue_sgi(struct kvm_vcpu *vcpu, int irq)
 {
@@ -864,7 +826,6 @@ void vgic_v3_init_emulation(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	dist->vm_ops.handle_mmio = vgic_v3_handle_mmio;
 	dist->vm_ops.queue_sgi = vgic_v3_queue_sgi;
 	dist->vm_ops.add_sgi_source = vgic_v3_add_sgi_source;
 	dist->vm_ops.init_model = vgic_v3_init_model;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 2598fe8..df25cf8 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -785,53 +785,6 @@ static bool call_range_handler(struct kvm_vcpu *vcpu,
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
@@ -888,30 +841,6 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
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
index fc73103..0df74cb 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -107,11 +107,6 @@ const
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
