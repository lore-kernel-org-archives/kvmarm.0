From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 01/22] KVM: arm/arm64: Add vITS save/restore API
 documentation
Date: Mon, 27 Mar 2017 11:30:51 +0200
Message-ID: <1490607072-21610-2-git-send-email-eric.auger@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ACBF40C2F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:29:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gpsnM1-pHRGb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 05:29:29 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F24E40C4A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:29:29 -0400 (EDT)
In-Reply-To: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Add description for how to access vITS registers and how to flush/restore
vITS tables into/from memory

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v3 -> v4:
- take into account Peter's comments:
  - typos
  - KVM_DEV_ARM_VGIC_GRP_ITS_TABLES kvm_device_attr = 0
  - add a validity bit in DTE
  - document all fields in CTE and ITE
  - document ABI revision
- take into account Andre's comments:
  - document restrictions about GITS_CREADR writing and GITS_IIDR
  - document -EBUSY error if one or more VCPUS are runnning
  - document 64b registers only can be accessed with 64b access
- itt_addr field matches bits [51:8] of the itt_addr

v1 -> v2:
- DTE and ITE now are 8 bytes
- DTE and ITE now indexed by deviceid/eventid
- use ITE name instead of ITTE
- mentions ITT_addr matches bits [51:8] of the actual address
- mentions LE layout
---
 Documentation/virtual/kvm/devices/arm-vgic-its.txt | 118 +++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
index 6081a5b..0902d20 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
@@ -36,3 +36,121 @@ Groups:
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
+      of the addressed register (32/64 bits). 64 bit registers can only
+      be accessed with full length.
+
+      Writes to read-only registers are ignored by the kernel except for:
+      - GITS_READR. It needs to be restored otherwise commands in the queue
+        will be re-executed after CWRITER setting. Writing this register is
+        allowed if the ITS is not enabled (GITS_CTLR.enable = 0). Also it
+        needs to be restored after GITS_CBASER since a write to GITS_CBASER
+        resets GITS_CREADR.
+      - GITS_IIDR. Its Revision field encodes the table layout ABI revision.
+
+      For other registers, getting or setting a register has the same
+      effect as reading/writing the register on real hardware.
+  Errors:
+    -ENXIO: Offset does not correspond to any supported register
+    -EFAULT: Invalid user pointer for attr->addr
+    -EINVAL: Offset is not 64-bit aligned
+    -EBUSY: one or more VCPUS are running
+
+  KVM_DEV_ARM_VGIC_GRP_ITS_TABLES
+  Attributes
+       The attr field of kvm_device_attr must be zero.
+
+       request the flush-save/restore of the ITS tables, namely
+       the device table, the collection table, all the ITT tables,
+       the LPI pending tables. On save, the tables are flushed
+       into guest memory at the location provisioned by the guest
+       in GITS_BASER (device and collection tables), in the MAPD
+       command (ITT_addr), GICR_PENDBASERs (pending tables).
+
+       This means the GIC should be restored before the ITS and all
+       ITS registers but the GITS_CTLR must be restored before
+       restoring the ITS tables.
+
+       The GITS_READR and GITS_IIDR read-only registers must also
+       be restored before the table restore. The IIDR revision field
+       encodes the ABI revision of the table layout. If not set by
+       user space, the restoration of the tables will fail.
+
+       Note the LPI configuration table is read-only for the
+       in-kernel ITS and its save/restore goes through the standard
+       RAM save/restore.
+
+       The layout of the tables in guest memory defines an ABI.
+       The entries are laid in little endian format as follows;
+
+  Errors:
+    -EINVAL: kvm_device_attr not equal to 0, invalid table data
+    -EFAULT: invalid guest ram access
+    -EBUSY: one or more VCPUS are running
+
+    ITS Table ABI REV1:
+    -------------------
+
+    The device table and ITE are respectively indexed by device id and
+    eventid. The collection table however is not indexed by collection id:
+    CTE are written at the beginning of the buffer.
+
+    Device Table Entry (DTE) layout: entry size = 8 bytes
+
+    bits:     | 63| 62 ... 49 | 48 ... 5 | 4 ... 0 |
+    values:   | V |   next    | ITT_addr |  Size   |
+
+    where;
+    - V indicates whether the entry is valid,
+    - ITT_addr matches bits [51:8] of the ITT address (256B aligned),
+    - next field is meaningful only if the entry is valid.
+    It equals to 0 if this entry is the last one; otherwise it corresponds
+    to the minimum between the offset to the next device id and 2^14 -1.
+
+    Collection Table Entry (CTE) layout: entry size = 8 bytes
+
+    bits:     | 63| 62 ..  52  | 51 ... 16 | 15  ...   0 |
+    values:   | V |    RES0    |  RDBase   |    ICID     |
+
+    where:
+    - V indicates whether the entry is valid,
+    - RDBase matches the PE number (GICR_TYPER.Processor_Number),
+    - ICID matches the collection ID
+
+    Interrupt Translation Entry (ITE) layout: entry size = 8 bytes
+
+    bits:     | 63 ... 48 | 47 ... 16 | 15 ... 0 |
+    values:   |    next   |   pINTID  |  ICID    |
+
+    where:
+    - pINTID is the physical LPI ID,
+    - ICID is the collection ID,
+    - next field is meaningful only if the entry is valid (pINTID != 0).
+    It equals to 0 if this entry is the last one; otherwise it corresponds
+    to the minimum between the eventid offset to the next ITE and 2^16 -1.
+
+    LPI Pending Table layout:
+
+    As specified in the ARM Generic Interrupt Controller Architecture
+    Specification GIC Architecture version 3.0 and version 4. The first
+    1kB is not modified and therefore should contain zeroes.
+
+    Future evolutions of the ITS table layout:
+
+    At the moment the table layout is defined and optimized for physical
+    LPI support.
+
+    In the future we might implement direct injection of virtual LPIS.
+    This will require an upgrade of the table layout and an evolution of
+    the ABI. The ABI revision is encoded in the GITS_IIDR revision field.
+    That register must be restored before the table restoration, otherwise
+    the operation will fail.
+
+    ABI V1: GITS_IIDR.Revision = 1
-- 
2.5.5
