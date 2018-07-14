From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 8/9] KVM: arm/arm64: vgic: Let userspace opt-in to writable
 v2 IGROUPR
Date: Sat, 14 Jul 2018 19:05:39 +0200
Message-ID: <1531587940-2490-9-git-send-email-christoffer.dall@arm.com>
References: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 873104A0EF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LvzBAyGRMIW6 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Jul 2018 12:53:28 -0400 (EDT)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01hn0204.outbound.protection.outlook.com [104.47.2.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6F814A0FC
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:27 -0400 (EDT)
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

Simply letting IGROUPR be writable from userspace would break
migration from old kernels to newer kernels, because old kernels
incorrectly report interrupt groups as group 1.  This would not be a big
problem if userspace wrote GICD_IIDR as read from the kernel, because we
could detect the incompatibility and return an error to userspace.
Unfortunately, this is not the case with current userspace
implementations and simply letting IGROUPR be writable from userspace for
an emulated GICv2 silently breaks migration and causes the destination
VM to no longer run after migration.

We now encourage userspace to write the read and expected value of
GICD_IIDR as the first part of a GIC register restore, and if we observe
a write to GICD_IIDR we know that userspace has been updated and has had
a chance to cope with older kernels (VGICv2 IIDR.Revision == 0)
incorrectly reporting interrupts as group 1, and therefore we now allow
groups to be user writable.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 include/kvm/arm_vgic.h           |  3 +++
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 15 ++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c661d0e..c134790 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -221,6 +221,9 @@ struct vgic_dist {
        /* Implementation revision as reported in the GICD_IIDR */
        u32                     implementation_rev;

+       /* Userspace can write to GICv2 IGROUPR */
+       bool                    v2_groups_user_writable;
+
        /* Do injected MSIs require an additional device ID? */
        bool                    msis_require_devid;

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index b79de42..9b6b758 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -85,6 +85,17 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
        case GIC_DIST_IIDR:
                if (val != vgic_mmio_read_v2_misc(vcpu, addr, len))
                        return -EINVAL;
+
+               /*
+                * If we observe a write to GICD_IIDR we know that userspace
+                * has been updated and has had a chance to cope with older
+                * kernels (VGICv2 IIDR.Revision == 0) incorrectly reporting
+                * interrupts as group 1, and therefore we now allow gruops to
+                * be user writable.  Doing this by default would break
+                * migration from old kernels to new kernels with legacy
+                * userspace.
+                */
+               vcpu->kvm->arch.vgic.v2_groups_user_writable = true;
        }

        vgic_mmio_write_v2_misc(vcpu, addr, len, val);
@@ -95,7 +106,9 @@ static int vgic_mmio_uaccess_write_v2_group(struct kvm_vcpu *vcpu,
                                            gpa_t addr, unsigned int len,
                                            unsigned long val)
 {
-       /* Ignore writes from userspace */
+       if (vcpu->kvm->arch.vgic.v2_groups_user_writable)
+               vgic_mmio_write_group(vcpu, addr, len, val);
+
        return 0;
 }

--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
