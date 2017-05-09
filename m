From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 33/37] KVM: arm/arm64: Register iodevs when setting redist base
 and creating VCPUs
Date: Tue,  9 May 2017 12:45:02 +0200
Message-ID: <20170509104506.30929-34-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D069440C4A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ppb5Hv6p4wrd for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:34 -0400 (EDT)
Received: from mail-qk0-f175.google.com (mail-qk0-f175.google.com
 [209.85.220.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62D3C40C36
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:29 -0400 (EDT)
Received: by mail-qk0-f175.google.com with SMTP id a72so58969991qkj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:44 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Instead of waiting with registering KVM iodevs until the first VCPU is
run, we can actually create the iodevs when the redist base address is
set.  The only downside is that we must now also check if we need to do
this for VCPUs which are created after creating the VGIC, because there
is no enforced ordering between creating the VGIC (and setting its base
addresses) and creating the VCPUs.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 include/kvm/arm_vgic.h              |  1 +
 virt/kvm/arm/arm.c                  |  2 +-
 virt/kvm/arm/vgic/vgic-init.c       | 21 ++++++++++++++++++
 virt/kvm/arm/vgic/vgic-kvm-device.c |  7 +++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 43 +++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-v3.c         |  6 ------
 virt/kvm/arm/vgic/vgic.h            |  3 ++-
 7 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fabcc64..4ff65ef 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -286,6 +286,7 @@ extern struct static_key_false vgic_v2_cpuif_trap;
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
 void kvm_vgic_early_init(struct kvm *kvm);
+int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
 void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 7941699..9f6f522a4b 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -335,7 +335,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_arm_reset_debug_ptr(vcpu);
 
-	return 0;
+	return kvm_vgic_vcpu_init(vcpu);
 }
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 0ea64a1..962bb57 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -226,6 +226,27 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	return 0;
 }
 
+/**
+ * kvm_vgic_vcpu_init() - Register VCPU-specific KVM iodevs
+ * @vcpu: pointer to the VCPU being created and initialized
+ */
+int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	int ret = 0;
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return 0;
+
+	/*
+	 * If we are creating a VCPU with a GICv3 we must also register the
+	 * KVM io device for the redistributor that belongs to this VCPU.
+	 */
+	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+		ret = vgic_register_redist_iodev(vcpu);
+	return ret;
+}
+
 static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vgic_global_state.type == VGIC_V2)
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 69ccfd5..10ae6f3 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -86,8 +86,13 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		break;
 	case KVM_VGIC_V3_ADDR_TYPE_REDIST:
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
+		if (r)
+			break;
+		if (write) {
+			r = vgic_v3_set_redist_base(kvm, *addr);
+			goto out;
+		}
 		addr_ptr = &vgic->vgic_redist_base;
-		alignment = SZ_64K;
 		break;
 	default:
 		r = -ENODEV;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 168269b..99da1a2 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -565,7 +565,7 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
  *
  * Return 0 on success, -ERRNO otherwise.
  */
-static int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
+int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
@@ -574,6 +574,18 @@ static int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	gpa_t rd_base, sgi_base;
 	int ret;
 
+	/*
+	 * We may be creating VCPUs before having set the base address for the
+	 * redistributor region, in which case we will come back to this
+	 * function for all VCPUs when the base address is set.  Just return
+	 * without doing any work for now.
+	 */
+	if (IS_VGIC_ADDR_UNDEF(vgic->vgic_redist_base))
+		return 0;
+
+	if (!vgic_v3_check_base(kvm))
+		return -EINVAL;
+
 	rd_base = vgic->vgic_redist_base + kvm_vcpu_get_idx(vcpu) * SZ_64K * 2;
 	sgi_base = rd_base + SZ_64K;
 
@@ -619,7 +631,7 @@ static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &sgi_dev->dev);
 }
 
-int vgic_register_redist_iodevs(struct kvm *kvm)
+static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	int c, ret = 0;
@@ -641,6 +653,33 @@ int vgic_register_redist_iodevs(struct kvm *kvm)
 	return ret;
 }
 
+int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
+{
+	struct vgic_dist *vgic = &kvm->arch.vgic;
+	int ret;
+
+	/* vgic_check_ioaddr makes sure we don't do this twice */
+	ret = vgic_check_ioaddr(kvm, &vgic->vgic_redist_base, addr, SZ_64K);
+	if (ret)
+		return ret;
+
+	vgic->vgic_redist_base = addr;
+	if (!vgic_v3_check_base(kvm)) {
+		vgic->vgic_redist_base = VGIC_ADDR_UNDEF;
+		return -EINVAL;
+	}
+
+	/*
+	 * Register iodevs for each existing VCPU.  Adding more VCPUs
+	 * afterwards will register the iodevs when needed.
+	 */
+	ret = vgic_register_all_redist_iodevs(kvm);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 {
 	const struct vgic_register_region *region;
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 2d53d7a..bb35078 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -397,12 +397,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
 		goto out;
 	}
 
-	ret = vgic_register_redist_iodevs(kvm);
-	if (ret) {
-		kvm_err("Unable to register VGICv3 redist MMIO regions\n");
-		goto out;
-	}
-
 	if (vgic_has_its(kvm)) {
 		ret = vgic_register_its_iodevs(kvm);
 		if (ret) {
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 89eb935..5f17eac 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -174,7 +174,8 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_v3_save_pending_tables(struct kvm *kvm);
-int vgic_register_redist_iodevs(struct kvm *kvm);
+int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr);
+int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
 bool vgic_v3_check_base(struct kvm *kvm);
 
 void vgic_v3_load(struct kvm_vcpu *vcpu);
-- 
2.9.0
