From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 02/24] KVM: arm/arm64: Add GICV3 pending table save API documentation
Date: Thu,  4 May 2017 13:44:22 +0200
Message-ID: <1493898284-29504-3-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Add description for how to save GICV3 LPI pending bit into
guest RAM pending tables.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v5: creation
---
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
index c1a2461..9293b45 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -167,11 +167,17 @@ Groups:
     KVM_DEV_ARM_VGIC_CTRL_INIT
       request the initialization of the VGIC, no additional parameter in
       kvm_device_attr.addr.
+    KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
+      save all LPI pending bits into guest RAM pending tables.
+
+      The first kB of the pending table is not altered by this operation.
   Errors:
     -ENXIO: VGIC not properly configured as required prior to calling
      this attribute
     -ENODEV: no online VCPU
     -ENOMEM: memory shortage when allocating vgic internal data
+    -EFAULT: Invalid guest ram access
+    -EBUSY:  One or more VCPUS are running
 
 
   KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
-- 
2.5.5
