From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 04/16] KVM: kvm-vfio: User API for IRQ forwarding
Date: Mon, 13 Apr 2015 14:29:19 +0200
Message-ID: <1428928171-18884-5-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D57634C3DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XWUvdtZJakj2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:24:52 -0400 (EDT)
Received: from mail-wg0-f54.google.com (mail-wg0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F2A04C3EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:52 -0400 (EDT)
Received: by wgyo15 with SMTP id o15so79098943wgy.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:32:38 -0700 (PDT)
In-Reply-To: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com
Cc: feng.wu@intel.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds and documents a new KVM_DEV_VFIO_DEVICE group
and 2 device attributes: KVM_DEV_VFIO_DEVICE_FORWARD_IRQ,
KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ. The purpose is to be able
to set a VFIO device IRQ as forwarded or not forwarded.
the command takes as argument a handle to a new struct named
kvm_vfio_dev_irq.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v3 -> v4:
- rename kvm_arch_forwarded_irq into kvm_vfio_dev_irq
- some rewording in commit message
- document forwarding restrictions and remove unforwarding ones

v2 -> v3:
- rework vfio kvm device documentation
- reword commit message and title
- add subindex in kvm_arch_forwarded_irq to be closer to VFIO API
- forwarding state can only be changed with VFIO IRQ signaling is off

v1 -> v2:
- struct kvm_arch_forwarded_irq moved from arch/arm/include/uapi/asm/kvm.h
  to include/uapi/linux/kvm.h
  also irq_index renamed into index and guest_irq renamed into gsi
- ASSIGN/DEASSIGN renamed into FORWARD/UNFORWARD
---
 Documentation/virtual/kvm/devices/vfio.txt | 34 ++++++++++++++++++++++++------
 include/uapi/linux/kvm.h                   | 12 +++++++++++
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
index ef51740..6186e6d 100644
--- a/Documentation/virtual/kvm/devices/vfio.txt
+++ b/Documentation/virtual/kvm/devices/vfio.txt
@@ -4,15 +4,20 @@ VFIO virtual device
 Device types supported:
   KVM_DEV_TYPE_VFIO
 
-Only one VFIO instance may be created per VM.  The created device
-tracks VFIO groups in use by the VM and features of those groups
-important to the correctness and acceleration of the VM.  As groups
-are enabled and disabled for use by the VM, KVM should be updated
-about their presence.  When registered with KVM, a reference to the
-VFIO-group is held by KVM.
+Only one VFIO instance may be created per VM.
+
+The created device tracks VFIO groups in use by the VM and features
+of those groups important to the correctness and acceleration of
+the VM.  As groups are enabled and disabled for use by the VM, KVM
+should be updated about their presence.  When registered with KVM,
+a reference to the VFIO-group is held by KVM.
+
+The device also enables to control some IRQ settings of VFIO devices:
+forwarding/posting.
 
 Groups:
   KVM_DEV_VFIO_GROUP
+  KVM_DEV_VFIO_DEVICE
 
 KVM_DEV_VFIO_GROUP attributes:
   KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
@@ -20,3 +25,20 @@ KVM_DEV_VFIO_GROUP attributes:
 
 For each, kvm_device_attr.addr points to an int32_t file descriptor
 for the VFIO group.
+
+KVM_DEV_VFIO_DEVICE attributes:
+  KVM_DEV_VFIO_DEVICE_FORWARD_IRQ: set a VFIO device IRQ as forwarded
+  KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ: set a VFIO device IRQ as not forwarded
+
+For each, kvm_device_attr.addr points to a kvm_vfio_dev_irq struct.
+
+When forwarded, a physical IRQ is completed by the guest and not by the
+host. This requires HW support in the interrupt controller.
+
+Forwarding can only be set when the corresponding VFIO IRQ is not masked
+(would it be through VFIO_DEVICE_SET_IRQS command or as a consequence of this
+IRQ being currently handled) or active at interrupt controller level.
+In such a situation, -EAGAIN is returned. It is advised to to set the
+forwarding before the VFIO signaling is set up, this avoids trial and errors.
+
+Unforwarding can happen at any time.
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8055706..1b78dd3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -945,6 +945,9 @@ struct kvm_device_attr {
 #define  KVM_DEV_VFIO_GROUP			1
 #define   KVM_DEV_VFIO_GROUP_ADD			1
 #define   KVM_DEV_VFIO_GROUP_DEL			2
+#define  KVM_DEV_VFIO_DEVICE			2
+#define   KVM_DEV_VFIO_DEVICE_FORWARD_IRQ			1
+#define   KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ			2
 
 enum kvm_device_type {
 	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
@@ -964,6 +967,15 @@ enum kvm_device_type {
 	KVM_DEV_TYPE_MAX,
 };
 
+struct kvm_vfio_dev_irq {
+	__u32	argsz;		/* structure length */
+	__u32	fd;		/* file descriptor of the VFIO device */
+	__u32	index;		/* VFIO device IRQ index */
+	__u32	start;		/* start of subindex range */
+	__u32	count;		/* size of subindex range */
+	__u32	gsi[];		/* gsi, ie. virtual IRQ number */
+};
+
 /*
  * ioctls for VM fds
  */
-- 
1.9.1
