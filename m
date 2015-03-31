From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 4/4] target-arm: kvm - add support for HW assisted debug
Date: Tue, 31 Mar 2015 16:40:46 +0100
Message-ID: <1427816446-31586-5-git-send-email-alex.bennee@linaro.org>
References: <1427816446-31586-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427816446-31586-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org, peter.maydell@linaro.org, christoffer.dall@linaro.org, zhichao.huang@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex@bennee.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

=46rom: Alex Benn=C3=A9e <alex@bennee.com>

This adds basic support for HW assisted debug. The ioctl interface to
KVM allows us to pass an implementation defined number of break and
watch point registers. When KVM_GUESTDBG_USE_HW_BP is specified these
debug registers will be installed in place on the world switch into the
guest.

The hardware is actually capable of more advanced matching but it is
unclear if this expressiveness is available via the gdbstub protocol.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

---
v2
  - correct setting of PMC/BAS/MASK
  - improved commentary
  - added helper function to check watchpoint in range
  - fix find/deletion of watchpoints

diff --git a/target-arm/kvm.c b/target-arm/kvm.c
index ae0f8b2..d1adf5f 100644
--- a/target-arm/kvm.c
+++ b/target-arm/kvm.c
@@ -17,6 +17,7 @@
=20
 #include "qemu-common.h"
 #include "qemu/timer.h"
+#include "qemu/error-report.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/kvm.h"
 #include "kvm_arm.h"
@@ -476,6 +477,8 @@ void kvm_arch_post_run(CPUState *cs, struct kvm_run=
 *run)
=20
 #define HSR_EC_SHIFT            26
 #define HSR_EC_SOFT_STEP        0x32
+#define HSR_EC_HW_BKPT          0x30
+#define HSR_EC_HW_WATCH         0x34
 #define HSR_EC_SW_BKPT          0x3c
=20
 static int kvm_handle_debug(CPUState *cs, struct kvm_run *run)
@@ -496,6 +499,16 @@ static int kvm_handle_debug(CPUState *cs, struct k=
vm_run *run)
             return true;
         }
         break;
+    case HSR_EC_HW_BKPT:
+        if (kvm_arm_find_hw_breakpoint(cs, arch_info->pc)) {
+            return true;
+        }
+        break;
+    case HSR_EC_HW_WATCH:
+        if (kvm_arm_find_hw_watchpoint(cs, arch_info->far)) {
+            return true;
+        }
+        break;
     default:
         error_report("%s: unhandled debug exit (%x, %llx)\n",
                      __func__, arch_info->hsr, arch_info->pc);
@@ -556,6 +569,10 @@ void kvm_arch_update_guest_debug(CPUState *cs, str=
uct kvm_guest_debug *dbg)
     if (kvm_sw_breakpoints_active(cs)) {
         dbg->control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP=
;
     }
+    if (kvm_hw_breakpoints_active(cs)) {
+        dbg->control |=3D KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP=
;
+        kvm_copy_hw_breakpoint_data(&dbg->arch);
+    }
 }
=20
 /* C6.6.29 BRK instruction */
@@ -582,26 +599,6 @@ int kvm_arch_remove_sw_breakpoint(CPUState *cs, st=
ruct kvm_sw_breakpoint *bp)
     return 0;
 }
=20
-int kvm_arch_insert_hw_breakpoint(target_ulong addr,
-                                  target_ulong len, int type)
-{
-    qemu_log_mask(LOG_UNIMP, "%s: not implemented\n", __func__);
-    return -EINVAL;
-}
-
-int kvm_arch_remove_hw_breakpoint(target_ulong addr,
-                                  target_ulong len, int type)
-{
-    qemu_log_mask(LOG_UNIMP, "%s: not implemented\n", __func__);
-    return -EINVAL;
-}
-
-
-void kvm_arch_remove_all_hw_breakpoints(void)
-{
-    qemu_log_mask(LOG_UNIMP, "%s: not implemented\n", __func__);
-}
-
 void kvm_arch_init_irq_routing(KVMState *s)
 {
 }
diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
index 8cf3a62..dbe81a7 100644
--- a/target-arm/kvm64.c
+++ b/target-arm/kvm64.c
@@ -2,6 +2,7 @@
  * ARM implementation of KVM hooks, 64 bit specific code
  *
  * Copyright Mian-M. Hamayun 2013, Virtual Open Systems
+ * Copyright Alex Benn=C3=A9e 2014, Linaro
  *
  * This work is licensed under the terms of the GNU GPL, version 2 or =
later.
  * See the COPYING file in the top-level directory.
@@ -12,11 +13,17 @@
 #include <sys/types.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
+#include <sys/ptrace.h>
+#include <asm/ptrace.h>
=20
+#include <linux/elf.h>
 #include <linux/kvm.h>
=20
 #include "qemu-common.h"
 #include "qemu/timer.h"
+#include "qemu/host-utils.h"
+#include "qemu/error-report.h"
+#include "exec/gdbstub.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/kvm.h"
 #include "kvm_arm.h"
@@ -24,6 +31,312 @@
 #include "internals.h"
 #include "hw/arm/arm.h"
=20
+/* Max and current break/watch point counts */
+int max_hw_bp, max_hw_wp;
+int cur_hw_bp, cur_hw_wp;
+struct kvm_guest_debug_arch guest_debug_registers;
+
+/**
+ * kvm_arm_init_debug()
+ * @cs: CPUState
+ *
+ * kvm_check_extension returns 0 if we have no debug registers or the
+ * number we have.
+ *
+ */
+static void kvm_arm_init_debug(CPUState *cs)
+{
+    max_hw_wp =3D kvm_check_extension(cs->kvm_state, KVM_CAP_GUEST_DEB=
UG_HW_WPS);
+    max_hw_bp =3D kvm_check_extension(cs->kvm_state, KVM_CAP_GUEST_DEB=
UG_HW_BPS);
+    return;
+}
+
+/**
+ * insert_hw_breakpoint()
+ * @addr: address of breakpoint
+ *
+ * See ARM ARM D2.9.1 for details but here we are only going to create
+ * simple un-linked breakpoints (i.e. we don't chain breakpoints
+ * together to match address and context or vmid). The hardware is
+ * capable of fancier matching but that will require exposing that
+ * fanciness to GDB's interface
+ *
+ * D7.3.2 DBGBCR<n>_EL1, Debug Breakpoint Control Registers
+ *
+ *  31  24 23  20 19   16 15 14  13  12   9 8   5 4    3 2   1  0
+ * +------+------+-------+-----+----+------+-----+------+-----+---+
+ * | RES0 |  BT  |  LBN  | SSC | HMC| RES0 | BAS | RES0 | PMC | E |
+ * +------+------+-------+-----+----+------+-----+------+-----+---+
+ *
+ * BT: Breakpoint type (0 =3D unlinked address match)
+ * LBN: Linked BP number (0 =3D unused)
+ * SSC/HMC/PMC: Security, Higher and Priv access control (Table D-12)
+ * BAS: Byte Address Select (RES1 for AArch64)
+ * E: Enable bit
+ */
+static int insert_hw_breakpoint(target_ulong addr)
+{
+    uint32_t bcr =3D 0x1; /* E=3D1, enable */
+    if (cur_hw_bp >=3D max_hw_bp) {
+        return -ENOBUFS;
+    }
+    bcr =3D deposit32(bcr, 1, 2, 0x3);   /* PMC =3D 11 */
+    bcr =3D deposit32(bcr, 5, 4, 0xf);   /* BAS =3D RES1 */
+    guest_debug_registers.dbg_bcr[cur_hw_bp] =3D bcr;
+    guest_debug_registers.dbg_bvr[cur_hw_bp] =3D addr;
+    cur_hw_bp++;
+    return 0;
+}
+
+/**
+ * delete_hw_breakpoint()
+ * @pc: address of breakpoint
+ *
+ * Delete a breakpoint and shuffle any above down
+ */
+
+static int delete_hw_breakpoint(target_ulong pc)
+{
+    int i;
+    for (i =3D 0; i < cur_hw_bp; i++) {
+      if (guest_debug_registers.dbg_bvr[i] =3D=3D pc) {
+          while (i < cur_hw_bp) {
+              if (i =3D=3D max_hw_bp) {
+                  guest_debug_registers.dbg_bvr[i] =3D 0;
+                  guest_debug_registers.dbg_bcr[i] =3D 0;
+              } else {
+                  guest_debug_registers.dbg_bvr[i] =3D
+                      guest_debug_registers.dbg_bvr[i + 1];
+                  guest_debug_registers.dbg_bcr[i] =3D
+                      guest_debug_registers.dbg_bcr[i + 1];
+              }
+              i++;
+          }
+          cur_hw_bp--;
+          return 0;
+      }
+    }
+    return -ENOENT;
+}
+
+/**
+ * insert_hw_watchpoint()
+ * @addr: address of watch point
+ * @len: size of area
+ * @type: type of watch point
+ *
+ * See ARM ARM D2.10. As with the breakpoints we can do some advanced
+ * stuff if we want to. The watch points can be linked with the break
+ * points above to make them context aware. However for simplicity
+ * currently we only deal with simple read/write watch points.
+ *
+ * D7.3.11 DBGWCR<n>_EL1, Debug Watchpoint Control Registers
+ *
+ *  31  29 28   24 23  21  20  19 16 15 14  13   12  5 4   3 2   1  0
+ * +------+-------+------+----+-----+-----+-----+-----+-----+-----+---=
+
+ * | RES0 |  MASK | RES0 | WT | LBN | SSC | HMC | BAS | LSC | PAC | E =
|
+ * +------+-------+------+----+-----+-----+-----+-----+-----+-----+---=
+
+ *
+ * MASK: num bits addr mask (0=3Dnone,01/10=3Dres,11=3D3 bits (8 bytes=
))
+ * WT: 0 - unlinked, 1 - linked (not currently used)
+ * LBN: Linked BP number (not currently used)
+ * SSC/HMC/PAC: Security, Higher and Priv access control (Table D-12)
+ * BAS: Byte Address Select
+ * LSC: Load/Store control (01: load, 10: store, 11: both)
+ * E: Enable
+ *
+ * The bottom 2 bits of the value register are masked. Therefor to
+ * break on an sizes smaller than unaligned byte you need to set
+ * MASK=3D0, BAS=3Dbit per byte in question. For larger regions (^2) y=
ou
+ * need to ensure you mask the address as required and set BAS=3D0xff
+ */
+
+static int insert_hw_watchpoint(target_ulong addr,
+                                target_ulong len, int type)
+{
+    uint32_t dbgwcr =3D 1; /* E=3D1, enable */
+    uint64_t dbgwvr =3D addr & (~0x7ULL);
+
+    if (cur_hw_wp >=3D max_hw_wp) {
+        return -ENOBUFS;
+    }
+
+    /* PAC 00 is reserved, assume EL1 exception */
+    dbgwcr =3D deposit32(dbgwcr, 1, 2, 1);
+
+    switch (type) {
+    case GDB_WATCHPOINT_READ:
+        dbgwcr =3D deposit32(dbgwcr, 3, 2, 1);
+        break;
+    case GDB_WATCHPOINT_WRITE:
+        dbgwcr =3D deposit32(dbgwcr, 3, 2, 2);
+        break;
+    case GDB_WATCHPOINT_ACCESS:
+        dbgwcr =3D deposit32(dbgwcr, 3, 2, 3);
+        break;
+    default:
+        g_assert_not_reached();
+        break;
+    }
+    if (len <=3D 8) {
+        /* we align the address and set the bits in BAS */
+        int off =3D addr & 0x7;
+        int bas =3D (1 << len)-1;
+        dbgwcr =3D deposit32(dbgwcr, 5+off, 8-off, bas);
+    } else {
+        /* For ranges above 8 bytes we need to be a power of 2 */
+        if (ctpop64(len)=3D=3D1) {
+            int bits =3D ctz64(len);
+            dbgwvr &=3D ~((1 << bits)-1);
+            dbgwcr =3D deposit32(dbgwcr, 24, 4, bits);
+            dbgwcr =3D deposit32(dbgwcr, 5, 8, 0xff);
+        } else {
+            return -ENOBUFS;
+        }
+    }
+
+    guest_debug_registers.dbg_wcr[cur_hw_wp] =3D dbgwcr;
+    guest_debug_registers.dbg_wvr[cur_hw_wp] =3D dbgwvr;
+    cur_hw_wp++;
+    return 0;
+}
+
+
+static bool check_watchpoint_in_range(int i, target_ulong addr)
+{
+    uint32_t dbgwcr =3D guest_debug_registers.dbg_wcr[i];
+    uint64_t addr_top, addr_bottom =3D guest_debug_registers.dbg_wvr[i=
];
+    int bas =3D extract32(dbgwcr, 5, 8);
+    int mask =3D extract32(dbgwcr, 24, 4);
+
+    if (mask) {
+        addr_top =3D addr_bottom + (1 << mask);
+    } else {
+        /* BAS must be contiguous but can offset against the base
+         * address in DBGWVR */
+        addr_bottom =3D addr_bottom + ctz32(bas);
+        addr_top =3D addr_bottom + clo32(bas);
+    }
+
+    if (addr >=3D addr_bottom && addr <=3D addr_top ) {
+        return true;
+    }
+
+    return false;
+}
+
+/**
+ * delete_hw_watchpoint()
+ * @addr: address of breakpoint
+ *
+ * Delete a breakpoint and shuffle any above down
+ */
+
+static int delete_hw_watchpoint(target_ulong addr,
+                                target_ulong len, int type)
+{
+    int i;
+    for (i =3D 0; i < cur_hw_wp; i++) {
+        if (check_watchpoint_in_range(i, addr)) {
+            while (i < cur_hw_wp) {
+                if (i =3D=3D max_hw_wp) {
+                    guest_debug_registers.dbg_wvr[i] =3D 0;
+                    guest_debug_registers.dbg_wcr[i] =3D 0;
+                } else {
+                    guest_debug_registers.dbg_wvr[i] =3D
+                        guest_debug_registers.dbg_wvr[i + 1];
+                    guest_debug_registers.dbg_wcr[i] =3D
+                        guest_debug_registers.dbg_wcr[i + 1];
+                }
+                i++;
+            }
+            cur_hw_wp--;
+            return 0;
+        }
+    }
+    return -ENOENT;
+}
+
+
+int kvm_arch_insert_hw_breakpoint(target_ulong addr,
+                                  target_ulong len, int type)
+{
+    switch (type) {
+    case GDB_BREAKPOINT_HW:
+        return insert_hw_breakpoint(addr);
+        break;
+    case GDB_WATCHPOINT_READ:
+    case GDB_WATCHPOINT_WRITE:
+    case GDB_WATCHPOINT_ACCESS:
+        return insert_hw_watchpoint(addr, len, type);
+    default:
+        return -ENOSYS;
+    }
+}
+
+int kvm_arch_remove_hw_breakpoint(target_ulong addr,
+                                  target_ulong len, int type)
+{
+    switch (type) {
+    case GDB_BREAKPOINT_HW:
+        return delete_hw_breakpoint(addr);
+        break;
+    case GDB_WATCHPOINT_READ:
+    case GDB_WATCHPOINT_WRITE:
+    case GDB_WATCHPOINT_ACCESS:
+        return delete_hw_watchpoint(addr, len, type);
+    default:
+        return -ENOSYS;
+    }
+}
+
+
+void kvm_arch_remove_all_hw_breakpoints(void)
+{
+    memset((void *)&guest_debug_registers, 0, sizeof(guest_debug_regis=
ters));
+    cur_hw_bp =3D 0;
+    cur_hw_wp =3D 0;
+}
+
+void kvm_copy_hw_breakpoint_data(struct kvm_guest_debug_arch *ptr)
+{
+    /* Compile time assert? */
+    g_assert(sizeof(struct kvm_guest_debug_arch) =3D=3D sizeof(guest_d=
ebug_registers));
+    memcpy(ptr, &guest_debug_registers, sizeof(guest_debug_registers))=
;
+}
+
+bool kvm_hw_breakpoints_active(CPUState *cs)
+{
+    return ( (cur_hw_bp > 0) || (cur_hw_wp >0) ) ? TRUE:FALSE;
+}
+
+bool kvm_arm_find_hw_breakpoint(CPUState *cpu, target_ulong pc)
+{
+  if (kvm_hw_breakpoints_active(cpu)) {
+    int i;
+    for (i=3D0; i<cur_hw_bp; i++) {
+      if (guest_debug_registers.dbg_bvr[i] =3D=3D pc) {
+        return true;
+      }
+    }
+  }
+  return false;
+}
+
+bool kvm_arm_find_hw_watchpoint(CPUState *cpu, target_ulong addr)
+{
+  if (kvm_hw_breakpoints_active(cpu)) {
+    int i;
+    for (i=3D0; i<cur_hw_wp; i++) {
+        if (check_watchpoint_in_range(i, addr)) {
+                return true;
+        }
+    }
+  }
+  return false;
+}
+
+
 static inline void set_feature(uint64_t *features, int feature)
 {
     *features |=3D 1ULL << feature;
@@ -106,6 +419,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
         return ret;
     }
=20
+    kvm_arm_init_debug(cs);
+
     return kvm_arm_init_cpreg_list(cpu);
 }
=20
diff --git a/target-arm/kvm_arm.h b/target-arm/kvm_arm.h
index 455dea3..a4b480b 100644
--- a/target-arm/kvm_arm.h
+++ b/target-arm/kvm_arm.h
@@ -162,6 +162,27 @@ typedef struct ARMHostCPUClass {
  */
 bool kvm_arm_get_host_cpu_features(ARMHostCPUClass *ahcc);
=20
+bool kvm_hw_breakpoints_active(CPUState *cs);
+void kvm_copy_hw_breakpoint_data(struct kvm_guest_debug_arch *ptr);
+
+/**
+ * kvm_arm_find_hw_breakpoint:
+ * @cpu: CPUState
+ * @pc: pc of breakpoint
+ *
+ * Return TRUE if the pc matches one of our breakpoints.
+ */
+bool kvm_arm_find_hw_breakpoint(CPUState *cpu, target_ulong pc);
+
+/**
+ * kvm_arm_find_hw_watchpoint:
+ * @cpu: CPUState
+ * @addr: address of watchpoint
+ *
+ * Return TRUE if the addr matches one of our watchpoints.
+ */
+bool kvm_arm_find_hw_watchpoint(CPUState *cpu, target_ulong addr);
+
 #endif
=20
 #endif
--=20
2.3.4

