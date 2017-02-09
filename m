From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/25] KVM: arm/arm64: Documentation: Update arm-vgic-v3.txt
Date: Thu,  9 Feb 2017 14:59:08 +0000
Message-ID: <1486652363-7696-11-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F41B40BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gFA6w-EUj6NJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Feb 2017 09:59:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4A0040B5B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:20 -0500 (EST)
In-Reply-To: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

Update error code returned for Invalid CPU interface register
value and access in AArch32 mode.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
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
2.1.4
