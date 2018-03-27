From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 02/12] KVM: arm/arm64: Document KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Tue, 27 Mar 2018 16:04:06 +0200
Message-ID: <1522159456-10419-3-git-send-email-eric.auger@redhat.com>
References: <1522159456-10419-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522159456-10419-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

We introduce a new KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attribute in
KVM_DEV_ARM_VGIC_GRP_ADDR group. It allows userspace to provide the
base address and size of a redistributor region

Compared to KVM_VGIC_V3_ADDR_TYPE_REDIST, this new attribute allows
to declare several separate redistributor regions.

So the whole redist space does not need to be contiguous anymore.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
index 9293b45..0ded904 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -27,6 +27,24 @@ Groups:
       VCPU and all of the redistributor pages are contiguous.
       Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
       This address needs to be 64K aligned.
+
+    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION (rw, 64-bit)
+      The attr field of kvm_device_attr encodes 3 values:
+      bits:     | 63   ....  52  |  51   ....   16 | 15 - 12  |11 - 0
+      values:   |     count      |       base      |  flags   | index
+      - index encodes the unique redistributor region index
+      - flags: reserved for future use, currently 0
+      - base field encodes bits [51:16] of the guest physical base address
+        of the first redistributor in the region. There are two 64K pages
+        for each VCPU and all of the redistributor pages are contiguous
+        within the redistributor region.
+      - count encodes the number of redistributors in the region.
+      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
+
+  It is invalid to mix calls with KVM_VGIC_V3_ADDR_TYPE_REDIST and
+  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attributes. When attempted an
+  -EINVAL error is returned.
+
   Errors:
     -E2BIG:  Address outside of addressable IPA range
     -EINVAL: Incorrectly aligned address
-- 
2.5.5
