From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 02/10] AArch{32,
 64}: use KVM_CREATE_DEVICE & co to instanciate the GIC
Date: Fri, 26 Jun 2015 14:16:10 +0100
Message-ID: <1435324578-21832-3-git-send-email-andre.przywara@arm.com>
References: <1435324578-21832-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC895570F8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2015 09:05:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rb3eTmHtmz9Q for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jun 2015 09:05:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93D00570EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2015 09:05:31 -0400 (EDT)
In-Reply-To: <1435324578-21832-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: penberg@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

As of 3.14, KVM/arm supports the creation/configuration of the GIC through
a more generic device API, which is now the preferred way to do so.

Plumb the new API in, and allow the old code to be used as a fallback.

[Andre: Rename some functions on the way to differentiate between
creation and initialisation more clearly and fix error path.]

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c                    | 69 +++++++++++++++++++++++++++++++++++++++-----
 arm/include/arm-common/gic.h |  2 +-
 arm/kvm.c                    |  6 ++--
 3 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 5d8cbe6..1ff3663 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -7,7 +7,50 @@
 #include <linux/byteorder.h>
 #include <linux/kvm.h>
 
-int gic__init_irqchip(struct kvm *kvm)
+static int gic_fd = -1;
+
+static int gic__create_device(struct kvm *kvm)
+{
+	int err;
+	u64 cpu_if_addr = ARM_GIC_CPUI_BASE;
+	u64 dist_addr = ARM_GIC_DIST_BASE;
+	struct kvm_create_device gic_device = {
+		.type	= KVM_DEV_TYPE_ARM_VGIC_V2,
+	};
+	struct kvm_device_attr cpu_if_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
+		.attr	= KVM_VGIC_V2_ADDR_TYPE_CPU,
+		.addr	= (u64)(unsigned long)&cpu_if_addr,
+	};
+	struct kvm_device_attr dist_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
+		.attr	= KVM_VGIC_V2_ADDR_TYPE_DIST,
+		.addr	= (u64)(unsigned long)&dist_addr,
+	};
+
+	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &gic_device);
+	if (err)
+		return err;
+
+	gic_fd = gic_device.fd;
+
+	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
+	if (err)
+		goto out_err;
+
+	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
+	if (err)
+		goto out_err;
+
+	return 0;
+
+out_err:
+	close(gic_fd);
+	gic_fd = -1;
+	return err;
+}
+
+static int gic__create_irqchip(struct kvm *kvm)
 {
 	int err;
 	struct kvm_arm_device_addr gic_addr[] = {
@@ -23,12 +66,6 @@ int gic__init_irqchip(struct kvm *kvm)
 		}
 	};
 
-	if (kvm->nrcpus > GIC_MAX_CPUS) {
-		pr_warning("%d CPUS greater than maximum of %d -- truncating\n",
-				kvm->nrcpus, GIC_MAX_CPUS);
-		kvm->nrcpus = GIC_MAX_CPUS;
-	}
-
 	err = ioctl(kvm->vm_fd, KVM_CREATE_IRQCHIP);
 	if (err)
 		return err;
@@ -41,6 +78,24 @@ int gic__init_irqchip(struct kvm *kvm)
 	return err;
 }
 
+int gic__create(struct kvm *kvm)
+{
+	int err;
+
+	if (kvm->nrcpus > GIC_MAX_CPUS) {
+		pr_warning("%d CPUS greater than maximum of %d -- truncating\n",
+				kvm->nrcpus, GIC_MAX_CPUS);
+		kvm->nrcpus = GIC_MAX_CPUS;
+	}
+
+	/* Try the new way first, and fallback on legacy method otherwise */
+	err = gic__create_device(kvm);
+	if (err)
+		err = gic__create_irqchip(kvm);
+
+	return err;
+}
+
 void gic__generate_fdt_nodes(void *fdt, u32 phandle)
 {
 	u64 reg_prop[] = {
diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
index 5a36f2c..44859f7 100644
--- a/arm/include/arm-common/gic.h
+++ b/arm/include/arm-common/gic.h
@@ -24,7 +24,7 @@
 struct kvm;
 
 int gic__alloc_irqnum(void);
-int gic__init_irqchip(struct kvm *kvm);
+int gic__create(struct kvm *kvm);
 void gic__generate_fdt_nodes(void *fdt, u32 phandle);
 
 #endif /* ARM_COMMON__GIC_H */
diff --git a/arm/kvm.c b/arm/kvm.c
index 58ad9fa..bcd2533 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -81,7 +81,7 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_MERGEABLE | MADV_HUGEPAGE);
 
-	/* Initialise the virtual GIC. */
-	if (gic__init_irqchip(kvm))
-		die("Failed to initialise virtual GIC");
+	/* Create the virtual GIC. */
+	if (gic__create(kvm))
+		die("Failed to create virtual GIC");
 }
-- 
2.3.5
