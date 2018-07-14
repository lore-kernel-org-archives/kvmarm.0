From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 9/9] KVM: arm/arm64: vgic: Update documentation of the
 GICv2 device
Date: Sat, 14 Jul 2018 19:05:40 +0200
Message-ID: <1531587940-2490-10-git-send-email-christoffer.dall@arm.com>
References: <1531587940-2490-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B61394A147
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VQar1xVn6Mey for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Jul 2018 12:53:32 -0400 (EDT)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04hn0220.outbound.protection.outlook.com [104.47.14.220])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 118824A0EF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Jul 2018 12:53:32 -0400 (EDT)
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

Update the documentation to reflect the ordering requirements of
restoring GICv2 distributor registers and remove outdated limitations in
the documentation while we're at it.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index b3ce126..c9a6393 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -49,9 +49,12 @@ Groups:
     index is specified with the vcpu_index field.  Note that most distributor
     fields are not banked, but return the same value regardless of the
     vcpu_index used to access the register.
-  Limitations:
-    - Priorities are not implemented, and registers are RAZ/WI
-    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
+
+    GICD_IIDR.Revision is updated when the KVM implementation of an emulated
+    GICv2 is changed.  Userspace should read GICD_IIDR from KVM and write back
+    the read value to confirm its expected behavior is aligned with the KVM
+    implementation.  To properly restore the interrupt group configuration,
+    GICD_IIDR should be written before any other registers.
   Errors:
     -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
@@ -94,9 +97,6 @@ Groups:
     use the lower 5 bits to communicate with the KVM device and must shift the
     value left by 3 places to obtain the actual priority mask level.

-  Limitations:
-    - Priorities are not implemented, and registers are RAZ/WI
-    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
   Errors:
     -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
