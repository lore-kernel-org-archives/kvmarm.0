From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v7 2/7] KVM: kvm_host: add devid in kvm_kernel_irq_routing_entry
Date: Mon, 18 Jul 2016 13:25:52 +0000
Message-ID: <1468848357-2331-3-git-send-email-eric.auger@redhat.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com
Cc: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Extend kvm_kernel_irq_routing_entry to transport the device id
field, devid. A new flags field makes possible to indicate the
devid is valid. Those additions are used for ARM GICv3 ITS MSI
injection.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

---
v6 -> v7:
- added msi_ prefix to flags and dev_id fields

v4 -> v5:
- add Christoffer's R-b

v2 -> v3:
- add flags

v1 -> v2:
- replace msi_msg field by a struct composed of msi_msg and devid

RFC -> PATCH:
- reword the commit message after change in first patch (uapi)
---
 include/linux/kvm_host.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c87fe6f..3d2cbb4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -317,7 +317,11 @@ struct kvm_kernel_irq_routing_entry {
 			unsigned irqchip;
 			unsigned pin;
 		} irqchip;
-		struct msi_msg msi;
+		struct {
+			struct msi_msg msi;
+			u32 msi_flags;
+			u32 msi_devid;
+		};
 		struct kvm_s390_adapter_int adapter;
 		struct kvm_hv_sint hv_sint;
 	};
-- 
1.9.1

