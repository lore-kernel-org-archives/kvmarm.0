From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 7/9] KVM: arm/arm64: vgic: Permit uaccess writes to return
 errors
Date: Sat, 14 Jul 2018 19:05:38 +0200
Message-ID: <1531587940-2490-8-git-send-email-christoffer.dall@arm.com>
References: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E97E4A12D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o42han8EIN+g for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Jul 2018 12:53:25 -0400 (EDT)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04hn0206.outbound.protection.outlook.com [104.47.12.206])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 118374A14C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:25 -0400 (EDT)
In-Reply-To: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Currently we do not allow any vgic mmio write operations to fail, which
makes sense from mmio traps from the guest.  However, we should be able
to report failures to userspace, if userspace writes incompatible values
to read-only registers.  Rework the internal interface to allow errors
to be returned on the write side for userspace writes.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 26 +++++++++++++++++++++-----
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 31 ++++++++++++++++++++++++-------
 virt/kvm/arm/vgic/vgic-mmio.c    | 18 +++++++++++++-----
 virt/kvm/arm/vgic/vgic-mmio.h    | 19 +++++++++++--------
 4 files changed, 69 insertions(+), 25 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 34e36fc..b79de42 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -77,11 +77,26 @@ static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
        }
 }

-static void vgic_mmio_uaccess_write_v2_group(struct kvm_vcpu *vcpu,
-                                            gpa_t addr, unsigned int len,
-                                            unsigned long val)
+static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
+                                          gpa_t addr, unsigned int len,
+                                          unsigned long val)
+{
+       switch (addr & 0x0c) {
+       case GIC_DIST_IIDR:
+               if (val != vgic_mmio_read_v2_misc(vcpu, addr, len))
+                       return -EINVAL;
+       }
+
+       vgic_mmio_write_v2_misc(vcpu, addr, len, val);
+       return 0;
+}
+
+static int vgic_mmio_uaccess_write_v2_group(struct kvm_vcpu *vcpu,
+                                           gpa_t addr, unsigned int len,
+                                           unsigned long val)
 {
        /* Ignore writes from userspace */
+       return 0;
 }

 static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
@@ -376,8 +391,9 @@ static void vgic_mmio_write_apr(struct kvm_vcpu *vcpu,
 }

 static const struct vgic_register_region vgic_v2_dist_registers[] = {
-       REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
-               vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
+       REGISTER_DESC_WITH_LENGTH_UACCESS(GIC_DIST_CTRL,
+               vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc,
+               NULL, vgic_mmio_uaccess_write_v2_misc, 12,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
                vgic_mmio_read_group, vgic_mmio_write_group,
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 49df2a1..fabec2b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -120,6 +120,20 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
        }
 }

+static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
+                                          gpa_t addr, unsigned int len,
+                                          unsigned long val)
+{
+       switch (addr & 0x0c) {
+       case GICD_IIDR:
+               if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
+                       return -EINVAL;
+       }
+
+       vgic_mmio_write_v3_misc(vcpu, addr, len, val);
+       return 0;
+}
+
 static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
                                            gpa_t addr, unsigned int len)
 {
@@ -256,9 +270,9 @@ static unsigned long vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
        return value;
 }

-static void vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
-                                         gpa_t addr, unsigned int len,
-                                         unsigned long val)
+static int vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
+                                        gpa_t addr, unsigned int len,
+                                        unsigned long val)
 {
        u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
        int i;
@@ -283,6 +297,8 @@ static void vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,

                vgic_put_irq(vcpu->kvm, irq);
        }
+
+       return 0;
 }

 /* We want to avoid outer shareable. */
@@ -454,8 +470,9 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
        }

 static const struct vgic_register_region vgic_v3_dist_registers[] = {
-       REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
-               vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16,
+       REGISTER_DESC_WITH_LENGTH_UACCESS(GICD_CTLR,
+               vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc,
+               NULL, vgic_mmio_uaccess_write_v3_misc, 16,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_LENGTH(GICD_STATUSR,
                vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
@@ -475,7 +492,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
                vgic_mmio_read_pending, vgic_mmio_write_cpending,
-               vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+               vgic_mmio_read_raz, vgic_mmio_uaccess_write_wi, 1,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
                vgic_mmio_read_active, vgic_mmio_write_sactive,
@@ -548,7 +565,7 @@ static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ICPENDR0,
                vgic_mmio_read_pending, vgic_mmio_write_cpending,
-               vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+               vgic_mmio_read_raz, vgic_mmio_uaccess_write_wi, 4,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ISACTIVER0,
                vgic_mmio_read_active, vgic_mmio_write_sactive,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index ae31bd0..f56ff1c 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -40,6 +40,13 @@ void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
        /* Ignore */
 }

+int vgic_mmio_uaccess_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
+                              unsigned int len, unsigned long val)
+{
+       /* Ignore */
+       return 0;
+}
+
 unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu,
                                   gpa_t addr, unsigned int len)
 {
@@ -401,11 +408,12 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
        mutex_unlock(&vcpu->kvm->lock);
 }

-void vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
+int vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
                                     gpa_t addr, unsigned int len,
                                     unsigned long val)
 {
        __vgic_mmio_write_cactive(vcpu, addr, len, val);
+       return 0;
 }

 static void __vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
@@ -437,11 +445,12 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
        mutex_unlock(&vcpu->kvm->lock);
 }

-void vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
+int vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
                                     gpa_t addr, unsigned int len,
                                     unsigned long val)
 {
        __vgic_mmio_write_sactive(vcpu, addr, len, val);
+       return 0;
 }

 unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
@@ -773,10 +782,9 @@ static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,

        r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
        if (region->uaccess_write)
-               region->uaccess_write(r_vcpu, addr, sizeof(u32), *val);
-       else
-               region->write(r_vcpu, addr, sizeof(u32), *val);
+               return region->uaccess_write(r_vcpu, addr, sizeof(u32), *val);

+       region->write(r_vcpu, addr, sizeof(u32), *val);
        return 0;
 }

diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 1079862..a07f90a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -37,8 +37,8 @@ struct vgic_register_region {
        unsigned long (*uaccess_read)(struct kvm_vcpu *vcpu, gpa_t addr,
                                      unsigned int len);
        union {
-               void (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
-                                     unsigned int len, unsigned long val);
+               int (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
+                                    unsigned int len, unsigned long val);
                int (*uaccess_its_write)(struct kvm *kvm, struct vgic_its *its,
                                         gpa_t addr, unsigned int len,
                                         unsigned long val);
@@ -134,6 +134,9 @@ unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
 void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
                        unsigned int len, unsigned long val);

+int vgic_mmio_uaccess_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
+                              unsigned int len, unsigned long val);
+
 unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu, gpa_t addr,
                                   unsigned int len);

@@ -173,13 +176,13 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
                             gpa_t addr, unsigned int len,
                             unsigned long val);

-void vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
-                                    gpa_t addr, unsigned int len,
-                                    unsigned long val);
+int vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
+                                   gpa_t addr, unsigned int len,
+                                   unsigned long val);

-void vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
-                                    gpa_t addr, unsigned int len,
-                                    unsigned long val);
+int vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
+                                   gpa_t addr, unsigned int len,
+                                   unsigned long val);

 unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
                                      gpa_t addr, unsigned int len);
--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
