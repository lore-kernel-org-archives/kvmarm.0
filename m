From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 03/37] KVM: arm/arm64: Add ITS save/restore API documentation
Date: Tue,  9 May 2017 12:44:32 +0200
Message-ID: <20170509104506.30929-4-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E60040C28
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id olgaKM5G+tPE for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:01 -0400 (EDT)
Received: from mail-qk0-f175.google.com (mail-qk0-f175.google.com
 [209.85.220.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75A0940A80
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:01 -0400 (EDT)
Received: by mail-qk0-f175.google.com with SMTP id y201so42658989qka.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:16 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

Add description for how to access ITS registers and how to save/restore
ITS tables into/from memory.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 Documentation/virtual/kvm/devices/arm-vgic-its.txt | 120 +++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
index 6081a5b..ba132e9 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
@@ -32,7 +32,127 @@ Groups:
     KVM_DEV_ARM_VGIC_CTRL_INIT
       request the initialization of the ITS, no additional parameter in
       kvm_device_attr.addr.
+
+    KVM_DEV_ARM_ITS_SAVE_TABLES
+      save the ITS table data into guest RAM, at the location provisioned
+      by the guest in corresponding registers/table entries.
+
+      The layout of the tables in guest memory defines an ABI. The entries
+      are laid out in little endian format as described in the last paragraph.
+
+    KVM_DEV_ARM_ITS_RESTORE_TABLES
+      restore the ITS tables from guest RAM to ITS internal structures.
+
+      The GICV3 must be restored before the ITS and all ITS registers but
+      the GITS_CTLR must be restored before restoring the ITS tables.
+
+      The GITS_IIDR read-only register must also be restored before
+      calling KVM_DEV_ARM_ITS_RESTORE_TABLES as the IIDR revision field
+      encodes the ABI revision.
+
+      The expected ordering when restoring the GICv3/ITS is described in section
+      "ITS Restore Sequence".
+
   Errors:
     -ENXIO:  ITS not properly configured as required prior to setting
              this attribute
     -ENOMEM: Memory shortage when allocating ITS internal data
+    -EINVAL: Inconsistent restored data
+    -EFAULT: Invalid guest ram access
+    -EBUSY:  One or more VCPUS are running
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
+      - GITS_CREADR. It must be restored otherwise commands in the queue
+        will be re-executed after restoring CWRITER. GITS_CREADR must be
+        restored before restoring the GITS_CTLR which is likely to enable the
+        ITS. Also it must be restored after GITS_CBASER since a write to
+        GITS_CBASER resets GITS_CREADR.
+      - GITS_IIDR. The Revision field encodes the table layout ABI revision.
+        In the future we might implement direct injection of virtual LPIs.
+        This will require an upgrade of the table layout and an evolution of
+        the ABI. GITS_IIDR must be restored before calling
+        KVM_DEV_ARM_ITS_RESTORE_TABLES.
+
+      For other registers, getting or setting a register has the same
+      effect as reading/writing the register on real hardware.
+  Errors:
+    -ENXIO: Offset does not correspond to any supported register
+    -EFAULT: Invalid user pointer for attr->addr
+    -EINVAL: Offset is not 64-bit aligned
+    -EBUSY: one or more VCPUS are running
+
+ ITS Restore Sequence:
+ -------------------------
+
+The following ordering must be followed when restoring the GIC and the ITS:
+a) restore all guest memory and create vcpus
+b) restore all redistributors
+c) initialize the ITS and then provide its base address
+   (KVM_DEV_ARM_VGIC_CTRL_INIT, KVM_DEV_ARM_VGIC_GRP_ADDR)
+d) restore the ITS in the following order:
+   1. Restore GITS_CBASER
+   2. Restore all other GITS_ registers, except GITS_CTLR!
+   3. Load the ITS table data (KVM_DEV_ARM_ITS_RESTORE_TABLES)
+   4. Restore GITS_CTLR
+
+Then vcpus can be started.
+
+ ITS Table ABI REV0:
+ -------------------
+
+ Revision 0 of the ABI only supports physical LPIs.
+
+ The device table and ITT are indexed by the deviceid and eventid,
+ respectively. The collection table is not indexed by collectionid:
+ CTEs are written in the table in the order of collection creation. All
+ entries are 8 bytes.
+
+ Device Table Entry (DTE):
+
+ bits:     | 63| 62 ... 49 | 48 ... 5 | 4 ... 0 |
+ values:   | V |   next    | ITT_addr |  Size   |
+
+ where;
+ - V indicates whether the entry is valid. If not, other fields
+   are not meaningful.
+ - next: equals to 0 if this entry is the last one; otherwise it
+   corresponds to the deviceid offset to the next DTE, capped by
+   2^14 -1.
+ - ITT_addr matches bits [51:8] of the ITT address (256 Byte aligned).
+ - Size specifies the supported number of bits for the eventid,
+   minus one
+
+ Collection Table Entry (CTE):
+
+ bits:     | 63| 62 ..  52  | 51 ... 16 | 15  ...   0 |
+ values:   | V |    RES0    |  RDBase   |    ICID     |
+
+ where:
+ - V indicates whether the entry is valid. If not, other fields are
+   not meaningful.
+ - RES0: reserved field with Should-Be-Zero-or-Preserved behavior.
+ - RDBase is the PE number (GICR_TYPER.Processor_Number semantic),
+ - ICID is the collection ID
+
+ Interrupt Translation Entry (ITE):
+
+ bits:     | 63 ... 48 | 47 ... 16 | 15 ... 0 |
+ values:   |    next   |   pINTID  |  ICID    |
+
+ where:
+ - next: equals to 0 if this entry is the last one; otherwise it corresponds
+   to the eventid offset to the next ITE capped by 2^16 -1.
+ - pINTID is the physical LPI ID; if zero, it means the entry is not valid
+   and other fields are not meaningful.
+ - ICID is the collection ID
+
-- 
2.9.0
