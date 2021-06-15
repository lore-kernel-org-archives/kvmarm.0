Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9922C48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 03:50:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6728261059
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 03:50:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6728261059
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDCB149F8F;
	Mon, 14 Jun 2021 23:50:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JLmmdREwSaKx; Mon, 14 Jun 2021 23:50:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3732C4B086;
	Mon, 14 Jun 2021 23:50:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EE9D4B082
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 23:50:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P6KYX15whggz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 23:50:27 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0A8E49F8F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 23:50:26 -0400 (EDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G3vQV2ryHz6ylD;
 Tue, 15 Jun 2021 11:47:14 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 11:50:22 +0800
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 11:50:21 +0800
From: Yanan Wang <wangyanan55@huawei.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger
 <eric.auger@redhat.com>
Subject: [PATCH] KVM: arm64: Trival coding style fixes for all vgic-related
 files
Date: Tue, 15 Jun 2021 11:50:19 +0800
Message-ID: <20210615035019.35808-1-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

These fixes introduce no functional change but just adjustment about
coding style issues for ARM64 vgic code. They mainly include identation
fix of function parameters/arguments, identation fix of structure
initialization, identation fix of comment, also the deletion of some
superfluous space lines.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c      |  6 +++---
 arch/arm64/kvm/vgic/vgic-init.c       |  1 -
 arch/arm64/kvm/vgic/vgic-irqfd.c      |  4 ++--
 arch/arm64/kvm/vgic/vgic-its.c        | 20 +++++++++-----------
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  3 +--
 arch/arm64/kvm/vgic/vgic-mmio.c       | 10 +++++-----
 arch/arm64/kvm/vgic/vgic-mmio.h       |  2 +-
 arch/arm64/kvm/vgic/vgic.c            |  4 ++--
 arch/arm64/kvm/vgic/vgic.h            |  6 +++---
 10 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index f38c40a76251..342be3563a44 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -75,9 +75,9 @@ static void iter_init(struct kvm *kvm, struct vgic_state_iter *iter,
 static bool end_of_vgic(struct vgic_state_iter *iter)
 {
 	return iter->dist_id > 0 &&
-		iter->vcpu_id == iter->nr_cpus &&
-		iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS) &&
-		iter->lpi_idx > iter->nr_lpis;
+	       iter->vcpu_id == iter->nr_cpus &&
+	       iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS) &&
+	       iter->lpi_idx > iter->nr_lpis;
 }
 
 static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 58cbda00e56d..b0bae4fee58e 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -464,7 +464,6 @@ static int vgic_init_cpu_starting(unsigned int cpu)
 	return 0;
 }
 
-
 static int vgic_init_cpu_dying(unsigned int cpu)
 {
 	disable_percpu_irq(kvm_vgic_global_state.maint_irq);
diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 79f8899b234c..722a6f398b0e 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -16,8 +16,8 @@
  * This is the entry point for irqfd IRQ injection
  */
 static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
-			struct kvm *kvm, int irq_source_id,
-			int level, bool line_status)
+			      struct kvm *kvm, int irq_source_id,
+			      int level, bool line_status)
 {
 	unsigned int spi_id = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 61728c543eb9..84c1dcd69ea5 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -178,12 +178,12 @@ struct vgic_its_abi {
 
 static const struct vgic_its_abi its_table_abi_versions[] = {
 	[0] = {
-	 .cte_esz = ABI_0_ESZ,
-	 .dte_esz = ABI_0_ESZ,
-	 .ite_esz = ABI_0_ESZ,
-	 .save_tables = vgic_its_save_tables_v0,
-	 .restore_tables = vgic_its_restore_tables_v0,
-	 .commit = vgic_its_commit_v0,
+		.cte_esz = ABI_0_ESZ,
+		.dte_esz = ABI_0_ESZ,
+		.ite_esz = ABI_0_ESZ,
+		.save_tables = vgic_its_save_tables_v0,
+		.restore_tables = vgic_its_restore_tables_v0,
+		.commit = vgic_its_commit_v0,
 	},
 };
 
@@ -224,7 +224,7 @@ static struct its_device *find_its_device(struct vgic_its *its, u32 device_id)
  * Must be called with the its_lock mutex held.
  */
 static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
-				  u32 event_id)
+				u32 event_id)
 {
 	struct its_device *device;
 	struct its_ite *ite;
@@ -1258,7 +1258,6 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
 	u32 event_id = its_cmd_get_id(its_cmd);
 	struct its_ite *ite;
 
-
 	ite = find_ite(its, device_id, event_id);
 	if (!ite)
 		return E_ITS_CLEAR_UNMAPPED_INTERRUPT;
@@ -1283,7 +1282,6 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
 	u32 event_id = its_cmd_get_id(its_cmd);
 	struct its_ite *ite;
 
-
 	ite = find_ite(its, device_id, event_id);
 	if (!ite)
 		return E_ITS_INV_UNMAPPED_INTERRUPT;
@@ -2120,7 +2118,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
  * vgic_its_save_ite - Save an interrupt translation entry at @gpa
  */
 static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
-			      struct its_ite *ite, gpa_t gpa, int ite_esz)
+			     struct its_ite *ite, gpa_t gpa, int ite_esz)
 {
 	struct kvm *kvm = its->dev->kvm;
 	u32 next_offset;
@@ -2276,7 +2274,7 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 	val = (1ULL << KVM_ITS_DTE_VALID_SHIFT |
 	       ((u64)next_offset << KVM_ITS_DTE_NEXT_SHIFT) |
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
-		(dev->num_eventid_bits - 1));
+	       (dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
 	return kvm_write_guest_lock(kvm, ptr, &val, dte_esz);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 7740995de982..730135ac5fb0 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -43,7 +43,7 @@ static int vgic_check_type(struct kvm *kvm, int type_needed)
  * @type:  the VGIC addr type, one of KVM_VGIC_V[23]_ADDR_TYPE_XXX
  * @addr:  pointer to address value
  * @write: if true set the address in the VM address space, if false read the
- *          address
+ *         address
  *
  * Set or get the vgic base addresses for the distributor and the virtual CPU
  * interface in the VM physical address space.  These addresses are properties
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a09cdc0b953c..61f8d519eff1 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -229,7 +229,6 @@ static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
 	return vgic_cpu->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
 }
 
-
 static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 				     gpa_t addr, unsigned int len,
 				     unsigned long val)
@@ -568,7 +567,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICENABLER,
 		vgic_mmio_read_enable, vgic_mmio_write_cenable,
-	       NULL, vgic_uaccess_write_cenable, 1,
+		NULL, vgic_uaccess_write_cenable, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
 		vgic_mmio_read_pending, vgic_mmio_write_spending,
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 48c6067fc5ec..3ae2ff447d67 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -505,7 +505,7 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 }
 
 unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
-				    gpa_t addr, unsigned int len)
+				       gpa_t addr, unsigned int len)
 {
 	return __vgic_mmio_read_active(vcpu, addr, len);
 }
@@ -598,8 +598,8 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 }
 
 int vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
-				     gpa_t addr, unsigned int len,
-				     unsigned long val)
+				    gpa_t addr, unsigned int len,
+				    unsigned long val)
 {
 	__vgic_mmio_write_cactive(vcpu, addr, len, val);
 	return 0;
@@ -635,8 +635,8 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 }
 
 int vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
-				     gpa_t addr, unsigned int len,
-				     unsigned long val)
+				    gpa_t addr, unsigned int len,
+				    unsigned long val)
 {
 	__vgic_mmio_write_sactive(vcpu, addr, len, val);
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index fefcca2b14dc..009744b12445 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -169,7 +169,7 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 				    gpa_t addr, unsigned int len);
 
 unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
-				    gpa_t addr, unsigned int len);
+				       gpa_t addr, unsigned int len);
 
 void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 15b666200f0b..a7a43524233c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -194,7 +194,6 @@ bool vgic_get_phys_line_level(struct vgic_irq *irq)
 /* Set/Clear the physical active state */
 void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
 {
-
 	BUG_ON(!irq->hw);
 	WARN_ON(irq_set_irqchip_state(irq->host_irq,
 				      IRQCHIP_STATE_ACTIVE,
@@ -234,7 +233,8 @@ static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 		return irq->target_vcpu;
 	}
 
-	/* If neither active nor pending and enabled, then this IRQ should not
+	/*
+	 * If neither active nor pending and enabled, then this IRQ should not
 	 * be queued to any VCPU.
 	 */
 	return NULL;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index dc1f3d1657ee..a3d385129da5 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -236,11 +236,11 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
 int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-			 int offset, u32 *val);
+			   int offset, u32 *val);
 int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-			 u64 id, u64 *val);
+				u64 id, u64 *val);
 int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
-				u64 *reg);
+				 u64 *reg);
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 				    u32 intid, u64 *val);
 int kvm_register_vgic_device(unsigned long type);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
