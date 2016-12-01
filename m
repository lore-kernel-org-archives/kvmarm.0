From: vijay.kilari@gmail.com
Subject: [PATCH v10 8/8] arm/arm64: Documentation: Update arm-vgic-v3.txt
Date: Thu,  1 Dec 2016 12:39:47 +0530
Message-ID: <1480576187-5012-9-git-send-email-vijay.kilari@gmail.com>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9571340286
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 02:09:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bNGQEYSWPQyf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2016 02:09:43 -0500 (EST)
Received: from mail-pg0-f66.google.com (mail-pg0-f66.google.com [74.125.83.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1892E40674
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2016 02:09:43 -0500 (EST)
Received: by mail-pg0-f66.google.com with SMTP id x23so3748595pgx.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2016 23:10:34 -0800 (PST)
In-Reply-To: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

Update error code returned for Invalid CPU interface register
value and access in AArch32 mode.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
index 9348b3c..0f29850 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -142,10 +142,12 @@ Groups:
     KVM_DEV_ARM_VGIC_CPU_SYSREGS accesses the CPU interface registers for the
     CPU specified by the mpidr field.
 
+    CPU interface registers access is not implemented for AArch32 mode.
+    Error -ENXIO is returned when accessed in AArch32 mode.
   Errors:
     -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: VCPU is running
-    -EINVAL: Invalid mpidr supplied
+    -EINVAL: Invalid mpidr or register value supplied
 
 
   KVM_DEV_ARM_VGIC_GRP_NR_IRQS
@@ -193,6 +195,11 @@ Groups:
 
 	Bit[n] indicates the status for interrupt vINTID + n.
 
+	Getting or setting the level info for an edge-triggered interrupt is
+	not guaranteed to work.  To restore the complete state of the VGIC, the
+	configuration (edge/level) of interrupts must be restored before
+	restoring the level.
+
     SGIs and any interrupt with a higher ID than the number of interrupts
     supported, will be RAZ/WI.  LPIs are always edge-triggered and are
     therefore not supported by this interface.
-- 
1.9.1
