From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 02/13] KVM: arm: fix gcc-4.5 build
Date: Fri, 16 Dec 2016 11:56:23 +0100
Message-ID: <20161216105634.235457-3-arnd@arndb.de>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 758B7405E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 73mynTeqi8mR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 05:55:39 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 264C740457
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:39 -0500 (EST)
In-Reply-To: <20161216105634.235457-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, kernel-build-reports@lists.linaro.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Old gcc versions cannot used named initializers for anonymous
unions, leading to a build failure here. This replaces the anonymous
union with a named one, which allows us to build with at least gcc-4.3
through 4.5. Versions 4.6 and higher are fine without this.

virt/kvm/arm/vgic/vgic-mmio-v2.c:295: error: unknown field 'read' specified in initializer
virt/kvm/arm/vgic/vgic-mmio-v2.c:295: warning: missing braces around initializer
virt/kvm/arm/vgic/vgic-mmio-v2.c:295: warning: (near initialization for 'vgic_v2_dist_registers[0].<anonymous>')
virt/kvm/arm/vgic/vgic-mmio-v2.c:295: error: unknown field 'write' specified in initializer
virt/kvm/arm/vgic/vgic-mmio-v2.c:298: error: unknown field 'read' specified in initializer

Fixes: 59c5ab40989a ("KVM: arm64: vgic-its: Introduce ITS emulation file with MMIO framework")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 virt/kvm/arm/vgic/vgic-its.c     |  4 ++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  8 ++++----
 virt/kvm/arm/vgic/vgic-mmio.c    | 16 ++++++++--------
 virt/kvm/arm/vgic/vgic-mmio.h    | 12 ++++++------
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 8c2b3cdcb2c5..922d820e2646 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1292,8 +1292,8 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	.reg_offset = off,					\
 	.len = length,						\
 	.access_flags = acc,					\
-	.its_read = rd,						\
-	.its_write = wr,					\
+	.r.its_read = rd,						\
+	.w.its_write = wr,					\
 }
 
 static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 50f42f0f8c4f..aa31110e4ebd 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -362,15 +362,15 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 		.bits_per_irq = bpi,					\
 		.len = (bpi * VGIC_NR_PRIVATE_IRQS) / 8,		\
 		.access_flags = acc,					\
-		.read = vgic_mmio_read_raz,				\
-		.write = vgic_mmio_write_wi,				\
+		.r.read = vgic_mmio_read_raz,				\
+		.w.write = vgic_mmio_write_wi,				\
 	}, {								\
 		.reg_offset = off + (bpi * VGIC_NR_PRIVATE_IRQS) / 8,	\
 		.bits_per_irq = bpi,					\
 		.len = (bpi * (1024 - VGIC_NR_PRIVATE_IRQS)) / 8,	\
 		.access_flags = acc,					\
-		.read = rd,						\
-		.write = wr,						\
+		.r.read = rd,						\
+		.w.write = wr,						\
 	}
 
 static const struct vgic_register_region vgic_v3_dist_registers[] = {
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index ebe1b9fa3c4d..6690922bc6b0 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -500,16 +500,16 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 
 	switch (iodev->iodev_type) {
 	case IODEV_CPUIF:
-		data = region->read(vcpu, addr, len);
+		data = region->r.read(vcpu, addr, len);
 		break;
 	case IODEV_DIST:
-		data = region->read(vcpu, addr, len);
+		data = region->r.read(vcpu, addr, len);
 		break;
 	case IODEV_REDIST:
-		data = region->read(iodev->redist_vcpu, addr, len);
+		data = region->r.read(iodev->redist_vcpu, addr, len);
 		break;
 	case IODEV_ITS:
-		data = region->its_read(vcpu->kvm, iodev->its, addr, len);
+		data = region->r.its_read(vcpu->kvm, iodev->its, addr, len);
 		break;
 	}
 
@@ -531,16 +531,16 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 
 	switch (iodev->iodev_type) {
 	case IODEV_CPUIF:
-		region->write(vcpu, addr, len, data);
+		region->w.write(vcpu, addr, len, data);
 		break;
 	case IODEV_DIST:
-		region->write(vcpu, addr, len, data);
+		region->w.write(vcpu, addr, len, data);
 		break;
 	case IODEV_REDIST:
-		region->write(iodev->redist_vcpu, addr, len, data);
+		region->w.write(iodev->redist_vcpu, addr, len, data);
 		break;
 	case IODEV_ITS:
-		region->its_write(vcpu->kvm, iodev->its, addr, len, data);
+		region->w.its_write(vcpu->kvm, iodev->its, addr, len, data);
 		break;
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 84961b4e4422..7f7da7239612 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -26,14 +26,14 @@ struct vgic_register_region {
 				      unsigned int len);
 		unsigned long (*its_read)(struct kvm *kvm, struct vgic_its *its,
 					  gpa_t addr, unsigned int len);
-	};
+	} r;
 	union {
 		void (*write)(struct kvm_vcpu *vcpu, gpa_t addr,
 			      unsigned int len, unsigned long val);
 		void (*its_write)(struct kvm *kvm, struct vgic_its *its,
 				  gpa_t addr, unsigned int len,
 				  unsigned long val);
-	};
+	} w;
 };
 
 extern struct kvm_io_device_ops kvm_io_gic_ops;
@@ -72,8 +72,8 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
 		.bits_per_irq = bpi,					\
 		.len = bpi * 1024 / 8,					\
 		.access_flags = acc,					\
-		.read = rd,						\
-		.write = wr,						\
+		.r.read = rd,						\
+		.w.write = wr,						\
 	}
 
 #define REGISTER_DESC_WITH_LENGTH(off, rd, wr, length, acc)		\
@@ -82,8 +82,8 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
 		.bits_per_irq = 0,					\
 		.len = length,						\
 		.access_flags = acc,					\
-		.read = rd,						\
-		.write = wr,						\
+		.r.read = rd,						\
+		.w.write = wr,						\
 	}
 
 int kvm_vgic_register_mmio_region(struct kvm *kvm, struct kvm_vcpu *vcpu,
-- 
2.9.0
