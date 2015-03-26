From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 02/11] KVM: move iodev.h from virt/kvm/ to include/kvm
Date: Thu, 26 Mar 2015 14:39:29 +0000
Message-ID: <1427380778-942-3-git-send-email-andre.przywara@arm.com>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E82349BFA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 10:32:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cX9tF63Ietc4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 10:32:41 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3211C49C19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 10:32:40 -0400 (EDT)
In-Reply-To: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

iodev.h contains definitions for the kvm_io_bus framework. This is
needed both by the generic KVM code in virt/kvm as well as by
architecture specific code under arch/. Putting the header file in
virt/kvm and using local includes in the architecture part seems at
least dodgy to me, so let's move the file into include/kvm, so that a
more natural "#include <kvm/iodev.h>" can be used by all of the code.
This also solves a problem later when using struct kvm_io_device
in arm_vgic.h.
Fixing up the FSF address in the GPL header and a wrong include path
on the way.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/powerpc/kvm/mpic.c   |    2 +-
 arch/x86/kvm/i8254.h      |    2 +-
 arch/x86/kvm/ioapic.h     |    2 +-
 arch/x86/kvm/irq.h        |    2 +-
 arch/x86/kvm/lapic.h      |    2 +-
 include/kvm/iodev.h       |   76 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/coalesced_mmio.c |    2 +-
 virt/kvm/eventfd.c        |    2 +-
 virt/kvm/iodev.h          |   77 ---------------------------------------------
 virt/kvm/kvm_main.c       |    2 +-
 10 files changed, 84 insertions(+), 85 deletions(-)
 create mode 100644 include/kvm/iodev.h
 delete mode 100644 virt/kvm/iodev.h

diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
index 8542f07..4703fad 100644
--- a/arch/powerpc/kvm/mpic.c
+++ b/arch/powerpc/kvm/mpic.c
@@ -34,7 +34,7 @@
 #include <asm/kvm_para.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_ppc.h>
-#include "iodev.h"
+#include <kvm/iodev.h>
 
 #define MAX_CPU     32
 #define MAX_SRC     256
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index dd1b16b..c84990b 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -3,7 +3,7 @@
 
 #include <linux/kthread.h>
 
-#include "iodev.h"
+#include <kvm/iodev.h>
 
 struct kvm_kpit_channel_state {
 	u32 count; /* can be 65536 */
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index c2e36d9..d9e02ca 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -3,7 +3,7 @@
 
 #include <linux/kvm_host.h>
 
-#include "iodev.h"
+#include <kvm/iodev.h>
 
 struct kvm;
 struct kvm_vcpu;
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 2d03568..ad68c73 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -27,7 +27,7 @@
 #include <linux/kvm_host.h>
 #include <linux/spinlock.h>
 
-#include "iodev.h"
+#include <kvm/iodev.h>
 #include "ioapic.h"
 #include "lapic.h"
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0bc6c65..e284c28 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -1,7 +1,7 @@
 #ifndef __KVM_X86_LAPIC_H
 #define __KVM_X86_LAPIC_H
 
-#include "iodev.h"
+#include <kvm/iodev.h>
 
 #include <linux/kvm_host.h>
 
diff --git a/include/kvm/iodev.h b/include/kvm/iodev.h
new file mode 100644
index 0000000..a6d208b
--- /dev/null
+++ b/include/kvm/iodev.h
@@ -0,0 +1,76 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __KVM_IODEV_H__
+#define __KVM_IODEV_H__
+
+#include <linux/kvm_types.h>
+#include <linux/errno.h>
+
+struct kvm_io_device;
+struct kvm_vcpu;
+
+/**
+ * kvm_io_device_ops are called under kvm slots_lock.
+ * read and write handlers return 0 if the transaction has been handled,
+ * or non-zero to have it passed to the next device.
+ **/
+struct kvm_io_device_ops {
+	int (*read)(struct kvm_vcpu *vcpu,
+		    struct kvm_io_device *this,
+		    gpa_t addr,
+		    int len,
+		    void *val);
+	int (*write)(struct kvm_vcpu *vcpu,
+		     struct kvm_io_device *this,
+		     gpa_t addr,
+		     int len,
+		     const void *val);
+	void (*destructor)(struct kvm_io_device *this);
+};
+
+
+struct kvm_io_device {
+	const struct kvm_io_device_ops *ops;
+};
+
+static inline void kvm_iodevice_init(struct kvm_io_device *dev,
+				     const struct kvm_io_device_ops *ops)
+{
+	dev->ops = ops;
+}
+
+static inline int kvm_iodevice_read(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *dev, gpa_t addr,
+				    int l, void *v)
+{
+	return dev->ops->read ? dev->ops->read(vcpu, dev, addr, l, v)
+				: -EOPNOTSUPP;
+}
+
+static inline int kvm_iodevice_write(struct kvm_vcpu *vcpu,
+				     struct kvm_io_device *dev, gpa_t addr,
+				     int l, const void *v)
+{
+	return dev->ops->write ? dev->ops->write(vcpu, dev, addr, l, v)
+				 : -EOPNOTSUPP;
+}
+
+static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
+{
+	if (dev->ops->destructor)
+		dev->ops->destructor(dev);
+}
+
+#endif /* __KVM_IODEV_H__ */
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index c831a40..571c1ce 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -8,7 +8,7 @@
  *
  */
 
-#include "iodev.h"
+#include <kvm/iodev.h>
 
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 26c72f3..9ff4193 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -36,7 +36,7 @@
 #include <linux/seqlock.h>
 #include <trace/events/kvm.h>
 
-#include "iodev.h"
+#include <kvm/iodev.h>
 
 #ifdef CONFIG_HAVE_KVM_IRQFD
 /*
diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
deleted file mode 100644
index 9ef709c..0000000
--- a/virt/kvm/iodev.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- */
-
-#ifndef __KVM_IODEV_H__
-#define __KVM_IODEV_H__
-
-#include <linux/kvm_types.h>
-#include <asm/errno.h>
-
-struct kvm_io_device;
-struct kvm_vcpu;
-
-/**
- * kvm_io_device_ops are called under kvm slots_lock.
- * read and write handlers return 0 if the transaction has been handled,
- * or non-zero to have it passed to the next device.
- **/
-struct kvm_io_device_ops {
-	int (*read)(struct kvm_vcpu *vcpu,
-		    struct kvm_io_device *this,
-		    gpa_t addr,
-		    int len,
-		    void *val);
-	int (*write)(struct kvm_vcpu *vcpu,
-		     struct kvm_io_device *this,
-		     gpa_t addr,
-		     int len,
-		     const void *val);
-	void (*destructor)(struct kvm_io_device *this);
-};
-
-
-struct kvm_io_device {
-	const struct kvm_io_device_ops *ops;
-};
-
-static inline void kvm_iodevice_init(struct kvm_io_device *dev,
-				     const struct kvm_io_device_ops *ops)
-{
-	dev->ops = ops;
-}
-
-static inline int kvm_iodevice_read(struct kvm_vcpu *vcpu,
-				    struct kvm_io_device *dev, gpa_t addr,
-				    int l, void *v)
-{
-	return dev->ops->read ? dev->ops->read(vcpu, dev, addr, l, v)
-				: -EOPNOTSUPP;
-}
-
-static inline int kvm_iodevice_write(struct kvm_vcpu *vcpu,
-				     struct kvm_io_device *dev, gpa_t addr,
-				     int l, const void *v)
-{
-	return dev->ops->write ? dev->ops->write(vcpu, dev, addr, l, v)
-				 : -EOPNOTSUPP;
-}
-
-static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
-{
-	if (dev->ops->destructor)
-		dev->ops->destructor(dev);
-}
-
-#endif /* __KVM_IODEV_H__ */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 664d67a..c5460b6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -16,7 +16,7 @@
  *
  */
 
-#include "iodev.h"
+#include <kvm/iodev.h>
 
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
-- 
1.7.9.5
