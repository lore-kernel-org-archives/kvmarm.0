From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 05/11] KVM: arm/arm64: rename struct kvm_mmio_range to
 vgic_io_range
Date: Thu, 26 Mar 2015 14:39:32 +0000
Message-ID: <1427380778-942-6-git-send-email-andre.przywara@arm.com>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC17B49C22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 10:32:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PVOzymbxoqKF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 10:32:41 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D18B49BFA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 10:32:40 -0400 (EDT)
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

The name "kvm_mmio_range" is a bit bold, given that it only covers
the VGIC's MMIO ranges. To avoid confusion with kvm_io_range, rename
it to vgic_io_range.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic-v2-emul.c |    6 +++---
 virt/kvm/arm/vgic-v3-emul.c |    8 ++++----
 virt/kvm/arm/vgic.c         |   18 +++++++++---------
 virt/kvm/arm/vgic.h         |   12 ++++++------
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index c818662..ddb3135 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -319,7 +319,7 @@ static bool handle_mmio_sgi_clear(struct kvm_vcpu *vcpu,
 		return write_set_clear_sgi_pend_reg(vcpu, mmio, offset, false);
 }
 
-static const struct kvm_mmio_range vgic_dist_ranges[] = {
+static const struct vgic_io_range vgic_dist_ranges[] = {
 	{
 		.base		= GIC_DIST_CTRL,
 		.len		= 12,
@@ -647,7 +647,7 @@ static bool handle_cpu_mmio_ident(struct kvm_vcpu *vcpu,
  * CPU Interface Register accesses - these are not accessed by the VM, but by
  * user space for saving and restoring VGIC state.
  */
-static const struct kvm_mmio_range vgic_cpu_ranges[] = {
+static const struct vgic_io_range vgic_cpu_ranges[] = {
 	{
 		.base		= GIC_CPU_CTRL,
 		.len		= 12,
@@ -674,7 +674,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 				 struct kvm_device_attr *attr,
 				 u32 *reg, bool is_write)
 {
-	const struct kvm_mmio_range *r = NULL, *ranges;
+	const struct vgic_io_range *r = NULL, *ranges;
 	phys_addr_t offset;
 	int ret, cpuid, c;
 	struct kvm_vcpu *vcpu, *tmp_vcpu;
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index b3f1546..14943e3 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -340,7 +340,7 @@ static bool handle_mmio_idregs(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-static const struct kvm_mmio_range vgic_v3_dist_ranges[] = {
+static const struct vgic_io_range vgic_v3_dist_ranges[] = {
 	{
 		.base           = GICD_CTLR,
 		.len            = 0x04,
@@ -570,7 +570,7 @@ static bool handle_mmio_cfg_reg_redist(struct kvm_vcpu *vcpu,
 	return vgic_handle_cfg_reg(reg, mmio, offset);
 }
 
-static const struct kvm_mmio_range vgic_redist_sgi_ranges[] = {
+static const struct vgic_io_range vgic_redist_sgi_ranges[] = {
 	{
 		.base		= GICR_IGROUPR0,
 		.len		= 0x04,
@@ -676,7 +676,7 @@ static bool handle_mmio_typer_redist(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-static const struct kvm_mmio_range vgic_redist_ranges[] = {
+static const struct vgic_io_range vgic_redist_ranges[] = {
 	{
 		.base           = GICR_CTLR,
 		.len            = 0x04,
@@ -726,7 +726,7 @@ static bool vgic_v3_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	unsigned long rdbase = dist->vgic_redist_base;
 	int nrcpus = atomic_read(&vcpu->kvm->online_vcpus);
 	int vcpu_id;
-	const struct kvm_mmio_range *mmio_range;
+	const struct vgic_io_range *mmio_range;
 
 	if (is_in_range(mmio->phys_addr, mmio->len, dbase, GIC_V3_DIST_SIZE)) {
 		return vgic_handle_mmio_range(vcpu, run, mmio,
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index ffd937c..21a3550 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -712,11 +712,11 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 }
 
 const
-struct kvm_mmio_range *vgic_find_range(const struct kvm_mmio_range *ranges,
-				       struct kvm_exit_mmio *mmio,
-				       phys_addr_t offset)
+struct vgic_io_range *vgic_find_range(const struct vgic_io_range *ranges,
+				      struct kvm_exit_mmio *mmio,
+				      phys_addr_t offset)
 {
-	const struct kvm_mmio_range *r = ranges;
+	const struct vgic_io_range *r = ranges;
 
 	while (r->len) {
 		if (offset >= r->base &&
@@ -729,7 +729,7 @@ struct kvm_mmio_range *vgic_find_range(const struct kvm_mmio_range *ranges,
 }
 
 static bool vgic_validate_access(const struct vgic_dist *dist,
-				 const struct kvm_mmio_range *range,
+				 const struct vgic_io_range *range,
 				 unsigned long offset)
 {
 	int irq;
@@ -757,7 +757,7 @@ static bool vgic_validate_access(const struct vgic_dist *dist,
 static bool call_range_handler(struct kvm_vcpu *vcpu,
 			       struct kvm_exit_mmio *mmio,
 			       unsigned long offset,
-			       const struct kvm_mmio_range *range)
+			       const struct vgic_io_range *range)
 {
 	u32 *data32 = (void *)mmio->data;
 	struct kvm_exit_mmio mmio32;
@@ -804,10 +804,10 @@ static bool call_range_handler(struct kvm_vcpu *vcpu,
  */
 bool vgic_handle_mmio_range(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			    struct kvm_exit_mmio *mmio,
-			    const struct kvm_mmio_range *ranges,
+			    const struct vgic_io_range *ranges,
 			    unsigned long mmio_base)
 {
-	const struct kvm_mmio_range *range;
+	const struct vgic_io_range *range;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	bool updated_state;
 	unsigned long offset;
@@ -1984,7 +1984,7 @@ int vgic_get_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 	return r;
 }
 
-int vgic_has_attr_regs(const struct kvm_mmio_range *ranges, phys_addr_t offset)
+int vgic_has_attr_regs(const struct vgic_io_range *ranges, phys_addr_t offset)
 {
 	struct kvm_exit_mmio dev_attr_mmio;
 
diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
index 1e5a381..6fccb96 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -74,7 +74,7 @@ void mmio_data_write(struct kvm_exit_mmio *mmio, u32 mask, u32 value)
 	*((u32 *)mmio->data) = cpu_to_le32(value) & mask;
 }
 
-struct kvm_mmio_range {
+struct vgic_io_range {
 	phys_addr_t base;
 	unsigned long len;
 	int bits_per_irq;
@@ -89,13 +89,13 @@ static inline bool is_in_range(phys_addr_t addr, unsigned long len,
 }
 
 const
-struct kvm_mmio_range *vgic_find_range(const struct kvm_mmio_range *ranges,
-				       struct kvm_exit_mmio *mmio,
-				       phys_addr_t offset);
+struct vgic_io_range *vgic_find_range(const struct vgic_io_range *ranges,
+				      struct kvm_exit_mmio *mmio,
+				      phys_addr_t offset);
 
 bool vgic_handle_mmio_range(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			    struct kvm_exit_mmio *mmio,
-			    const struct kvm_mmio_range *ranges,
+			    const struct vgic_io_range *ranges,
 			    unsigned long mmio_base);
 
 bool vgic_handle_enable_reg(struct kvm *kvm, struct kvm_exit_mmio *mmio,
@@ -120,7 +120,7 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
 
 void vgic_kick_vcpus(struct kvm *kvm);
 
-int vgic_has_attr_regs(const struct kvm_mmio_range *ranges, phys_addr_t offset);
+int vgic_has_attr_regs(const struct vgic_io_range *ranges, phys_addr_t offset);
 int vgic_set_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_get_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr);
 
-- 
1.7.9.5
