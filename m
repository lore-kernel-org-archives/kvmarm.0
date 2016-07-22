From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v8 2/7] KVM: Add devid in kvm_kernel_irq_routing_entry
Date: Fri, 22 Jul 2016 13:46:35 +0000
Message-ID: <1469195200-6498-3-git-send-email-eric.auger@redhat.com>
References: <1469195200-6498-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469195200-6498-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com
Cc: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Enhance kvm_kernel_irq_routing_entry to transport the device id
field, devid. A new flags field makes possible to indicate the
devid is valid. Those additions are used for ARM GICv3 ITS MSI
injection. The original struct msi_msg msi field is replaced by
a new custom structure that embeds the new fields.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>

---
v7 -> v8:
- replace struct msi_msg by a new custom structure
- removed Christoffer's A-b

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
 include/linux/kvm_host.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c87fe6f..e33e85e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -317,7 +317,13 @@ struct kvm_kernel_irq_routing_entry {
 			unsigned irqchip;
 			unsigned pin;
 		} irqchip;
-		struct msi_msg msi;
+		struct {
+			u32 address_lo;
+			u32 address_hi;
+			u32 data;
+			u32 flags;
+			u32 devid;
+		} msi;
 		struct kvm_s390_adapter_int adapter;
 		struct kvm_hv_sint hv_sint;
 	};
--=20
1.9.1

