From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 01/13] KVM: arm/arm64: Add vITS save/restore API documentation
Date: Thu, 12 Jan 2017 16:56:41 +0100
Message-ID: <1484236613-24633-2-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22DF540430
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WAXZxe6mdiBw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 10:55:19 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00C3B403FB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:19 -0500 (EST)
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, Prasun.Kapoor@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

Add description for how to access vITS registers and how to flush/restore
vITS tables into/from memory

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 Documentation/virtual/kvm/devices/arm-vgic-its.txt | 70 ++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
index 6081a5b..bd74613 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
@@ -36,3 +36,73 @@ Groups:
     -ENXIO:  ITS not properly configured as required prior to setting
              this attribute
     -ENOMEM: Memory shortage when allocating ITS internal data
+
+  KVM_DEV_ARM_VGIC_GRP_ITS_REGS
+  Attributes:
+      The attr field of kvm_device_attr encodes the offset of the
+      ITS register, relative to the ITS control frame base address
+      (ITS_base).
+
+      kvm_device_attr.addr points to a __u64 value whatever the width
+      of the addressed register (32/64 bits).
+
+      Writes to read-only registers are ignored by the kernel except
+      for a single register, GITS_READR. Normally this register is RO
+      but it needs to be restored otherwise commands in the queue will
+      be re-executed after CWRITER setting.
+
+      For other registers, Getting or setting a register has the same
+      effect as reading/writing the register on real hardware.
+  Errors:
+    -ENXIO: Offset does not correspond to any supported register
+    -EFAULT: Invalid user pointer for attr->addr
+    -EINVAL: Offset is not 64-bit aligned
+
+  KVM_DEV_ARM_VGIC_GRP_ITS_TABLES
+  Attributes
+       The attr field of kvm_device_attr is not used.
+
+       request the flush-save/restore of the ITS tables, namely
+       the device table, the collection table, all the ITT tables,
+       the LPI pending tables. On save, the tables are flushed
+       into guest memory at the location provisionned by the guest
+       in GITS_BASER (device and collection tables), on MAPD command
+       (ITT_addr), GICR_PENDBASERs (pending tables).
+
+       This means the GIC should be restored before the ITS and all
+       ITS registers but the GITS_CTRL must be restored before
+       restoring the ITS tables.
+
+       Note the LPI configuration table is read-only for the
+       in-kernel ITS and its save/restore goes through the standard
+       RAM save/restore.
+
+       The layout of the tables in guest memory defines an ABI.
+       The entries are laid out in memory as follows;
+
+    Device Table Entry (DTE) layout: entry size = 16 bytes
+
+    bits:     | 63   ...  32  | 31 ... 6 | 5 | 4   ...   0 |
+    values:   |   DeviceID    |   Resv   | V |    Size     |
+
+    bits:     | 63 ... 44 | 43  ...  0  |
+    values:   |    Resv   |  ITT_addr   |
+
+    Collection Table Entry (CTE) layout: entry size = 8 bytes
+
+    bits:     | 63| 62 ..  52  | 51 ... 16 | 15  ...   0 |
+    values:   | V |    RES0    |  RDBase   |    ICID     |
+
+    Interrupt Translation Table Entry (ITTE) layout: entry size = 16 bytes
+
+    bits:     | 63   ...  32  | 31 ... 17 | 16 | 15  ...  0 |
+    values:   |   DeviceID    |    RES0   | V  |    ICID    |
+
+    bits:     | 63 ...  32    | 31      ...        0 |
+    values:   |   pINTID      |        EventID       |
+
+    LPI Pending Table layout:
+
+    As specified in the ARM Generic Interrupt Controller Architecture
+    Specification GIC Architecture version 3.0 and version 4. The first
+    1kB contains only zeros.
-- 
2.5.5
