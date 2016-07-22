From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 30/55] KVM: kvm_io_bus: Add kvm_io_bus_get_dev() call
Date: Fri, 22 Jul 2016 18:28:47 +0100
Message-ID: <1469208552-4155-31-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6597149BD5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AJ9BCmQLi++z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:24:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D7B049BC2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:29 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

The kvm_io_bus framework is a nice place of holding information about
various MMIO regions for kernel emulated devices.
Add a call to retrieve the kvm_io_device structure which is associated
with a certain MMIO address. This avoids to duplicate kvm_io_bus'
knowledge of MMIO regions without having to fake MMIO calls if a user
needs the device a certain MMIO address belongs to.
This will be used by the ITS emulation to get the associated ITS device
when someone triggers an MSI via an ioctl from userspace.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0640ee9..614a981 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -164,6 +164,8 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev);
 int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			      struct kvm_io_device *dev);
+struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
+					 gpa_t addr);
 
 #ifdef CONFIG_KVM_ASYNC_PF
 struct kvm_async_pf {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ef54b4c..bd2eb92 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3496,6 +3496,30 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 	return r;
 }
 
+struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
+					 gpa_t addr)
+{
+	struct kvm_io_bus *bus;
+	int dev_idx, srcu_idx;
+	struct kvm_io_device *iodev = NULL;
+
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+
+	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
+
+	dev_idx = kvm_io_bus_get_first_dev(bus, addr, 1);
+	if (dev_idx < 0)
+		goto out_unlock;
+
+	iodev = bus->range[dev_idx].dev;
+
+out_unlock:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+
+	return iodev;
+}
+EXPORT_SYMBOL_GPL(kvm_io_bus_get_dev);
+
 static struct notifier_block kvm_cpu_notifier = {
 	.notifier_call = kvm_cpu_hotplug,
 };
-- 
2.8.1
