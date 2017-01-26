From: vijay.kilari@gmail.com
Subject: [PATCH v11 8/8] arm/arm64: Documentation: Update arm-vgic-v3.txt
Date: Thu, 26 Jan 2017 19:50:53 +0530
Message-ID: <1485440453-10597-9-git-send-email-vijay.kilari@gmail.com>
References: <1485440453-10597-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A63004019A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 09:21:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5k8NvizP0NFG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jan 2017 09:21:52 -0500 (EST)
Received: from mail-pg0-f65.google.com (mail-pg0-f65.google.com [74.125.83.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1DCBD40692
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 09:21:50 -0500 (EST)
Received: by mail-pg0-f65.google.com with SMTP id 3so4744204pgj.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 06:22:01 -0800 (PST)
In-Reply-To: <1485440453-10597-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, eric.auger@redhat.com, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

Update error code returned for Invalid CPU interface register
value and access in AArch32 mode.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
index 9348b3c..c1a2461 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -118,7 +118,7 @@ Groups:
     -EBUSY: One or more VCPUs are running
 
 
-  KVM_DEV_ARM_VGIC_CPU_SYSREGS
+  KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
   Attributes:
     The attr field of kvm_device_attr encodes two values:
     bits:     | 63      ....       32 | 31  ....  16 | 15  ....  0 |
@@ -139,13 +139,15 @@ Groups:
     All system regs accessed through this API are (rw, 64-bit) and
     kvm_device_attr.addr points to a __u64 value.
 
-    KVM_DEV_ARM_VGIC_CPU_SYSREGS accesses the CPU interface registers for the
+    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS accesses the CPU interface registers for the
     CPU specified by the mpidr field.
 
+    CPU interface registers access is not implemented for AArch32 mode.
+    Error -ENXIO is returned when accessed in AArch32 mode.
   Errors:
     -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: VCPU is running
-    -EINVAL: Invalid mpidr supplied
+    -EINVAL: Invalid mpidr or register value supplied
 
 
   KVM_DEV_ARM_VGIC_GRP_NR_IRQS
@@ -204,3 +206,6 @@ Groups:
     architecture defined MPIDR, and the field is encoded as follows:
       | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
       |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
+  Errors:
+    -EINVAL: vINTID is not multiple of 32 or
+     info field is not VGIC_LEVEL_INFO_LINE_LEVEL
-- 
1.9.1
