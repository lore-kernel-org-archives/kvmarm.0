From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v4 09/10] KVM: arm/arm64: vgic: Let userspace opt-in to
 writable v2 IGROUPR
Date: Mon, 16 Jul 2018 15:06:26 +0200
Message-ID: <1531746387-7033-10-git-send-email-christoffer.dall@arm.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B393A4A14B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 08:54:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XbdZdgrE+fXL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 08:54:05 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 712064A169
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 08:54:05 -0400 (EDT)
In-Reply-To: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
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
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 16 +++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c661d0e..c134790 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -221,6 +221,9 @@ struct vgic_dist {
 	/* Implementation revision as reported in the GICD_IIDR */
 	u32			implementation_rev;
 
+	/* Userspace can write to GICv2 IGROUPR */
+	bool			v2_groups_user_writable;
+
 	/* Do injected MSIs require an additional device ID? */
 	bool			msis_require_devid;
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index ee164f8..26654f4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -85,6 +85,18 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
 	case GIC_DIST_IIDR:
 		if (val != vgic_mmio_read_v2_misc(vcpu, addr, len))
 			return -EINVAL;
+
+		/*
+		 * If we observe a write to GICD_IIDR we know that userspace
+		 * has been updated and has had a chance to cope with older
+		 * kernels (VGICv2 IIDR.Revision == 0) incorrectly reporting
+		 * interrupts as group 1, and therefore we now allow groups to
+		 * be user writable.  Doing this by default would break
+		 * migration from old kernels to new kernels with legacy
+		 * userspace.
+		 */
+		vcpu->kvm->arch.vgic.v2_groups_user_writable = true;
+		return 0;
 	}
 
 	vgic_mmio_write_v2_misc(vcpu, addr, len, val);
@@ -95,7 +107,9 @@ static int vgic_mmio_uaccess_write_v2_group(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len,
 					    unsigned long val)
 {
-	/* Ignore writes from userspace */
+	if (vcpu->kvm->arch.vgic.v2_groups_user_writable)
+		vgic_mmio_write_group(vcpu, addr, len, val);
+
 	return 0;
 }
 
-- 
2.7.4
