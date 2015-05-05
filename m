From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Fangu=C3=A8de?=
	<j.fanguede@virtualopensystems.com>
Subject: [RFC 2/4] target-arm/kvm: Flush data cache support
Date: Tue,  5 May 2015 11:13:45 +0200
Message-ID: <1430817227-6278-3-git-send-email-j.fanguede@virtualopensystems.com>
References: <1430817227-6278-1-git-send-email-j.fanguede@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1430817227-6278-1-git-send-email-j.fanguede@virtualopensystems.com>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org
Cc: kvmarm@lists.cs.columbia.edu, tech@virtualopensystems.com, =?UTF-8?q?J=C3=A9r=C3=A9my=20Fangu=C3=A8de?= <j.fanguede@virtualopensystems.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, "open list:Overall" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Implement data cache maintenance coherency functions, by using
=46LUSH_DCACHE_GPA ioctl. Introduce kvm_arm_maintain_cache_coherency()
for flushing the data cache if necessary, a very simple logic is
implemented to reduce number of flushes due to reads. Two wrapping
functions are exposed, for easier usage.

Signed-off-by: J=C3=A9r=C3=A9my Fangu=C3=A8de <j.fanguede@virtualopensy=
stems.com>
---
 include/sysemu/kvm.h |  3 +++
 stubs/kvm.c          |  9 +++++++++
 target-arm/kvm.c     | 51 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++
 3 files changed, 63 insertions(+)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 197e6c0..986f365 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -451,4 +451,7 @@ int kvm_set_one_reg(CPUState *cs, uint64_t id, void=
 *source);
  * Returns: 0 on success, or a negative errno on failure.
  */
 int kvm_get_one_reg(CPUState *cs, uint64_t id, void *target);
+
+void kvm_arch_cache_flush_needed(hwaddr addr, int len, bool is_write);
+void kvm_arch_cache_coherency_pre_run(void);
 #endif
diff --git a/stubs/kvm.c b/stubs/kvm.c
index e7c60b6..8ed5380 100644
--- a/stubs/kvm.c
+++ b/stubs/kvm.c
@@ -5,3 +5,12 @@ int kvm_arch_irqchip_create(KVMState *s)
 {
     return 0;
 }
+
+
+void kvm_arch_cache_flush_needed(hwaddr addr, int len, bool is_write)
+{
+}
+
+void kvm_arch_cache_coherency_pre_run(void)
+{
+}
diff --git a/target-arm/kvm.c b/target-arm/kvm.c
index fdd9ba3..548dae2 100644
--- a/target-arm/kvm.c
+++ b/target-arm/kvm.c
@@ -598,3 +598,54 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routin=
g_entry *route,
 {
     return 0;
 }
+
+static void kvm_arm_flush_cache_addr(hwaddr addr, int len)
+{
+    int ret;
+    struct kvm_mem_addr mem_addr;
+    mem_addr.addr =3D addr;
+    mem_addr.len =3D len;
+    ret =3D kvm_vm_ioctl(kvm_state, KVM_FLUSH_DCACHE_GPA, &mem_addr);
+    if (ret) {
+        fprintf(stderr, "error: Failed to flush CPU caches %d\n", ret)=
;
+    }
+}
+
+static void kvm_arm_maintain_cache_coherency(hwaddr addr, int len,
+                                             bool enter_guest, bool is=
_write)
+{
+    static hwaddr prev_addr;
+    static int prev_len;
+    hwaddr end_line, prev_end_line;
+
+    if (enter_guest) {
+        /* We will return to the guest after that, restore the default
+           configuration */
+        prev_addr =3D 0x0;
+        return;
+    }
+
+    /* Assume the minimal CPU cache line is 32 B */
+    end_line =3D (addr + len) & ~0x1f;
+    prev_end_line =3D (prev_addr + prev_len) & ~0x1f;
+
+    /* Don't flush two times in a row the same line"
+       Always flush on a write */
+    if ((prev_addr & ~0x1f) !=3D (addr & ~0x1f)
+        || (prev_end_line < end_line)
+        || is_write) {
+        kvm_arm_flush_cache_addr(addr, len);
+        prev_addr =3D addr;
+        prev_len =3D len;
+    }
+}
+
+void kvm_arch_cache_flush_needed(hwaddr addr, int len, bool is_write)
+{
+    kvm_arm_maintain_cache_coherency(addr, len, false, is_write);
+}
+
+void kvm_arch_cache_coherency_pre_run(void)
+{
+    kvm_arm_maintain_cache_coherency(0, 0, true, false);
+}
--=20
1.9.1

