From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 02/12] KVM: arm/arm64: Document
 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Fri, 27 Apr 2018 16:14:55 +0200
Message-ID: <1524838505-3823-3-git-send-email-eric.auger@redhat.com>
References: <1524838505-3823-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCC8B4A09C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Apr 2018 10:06:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0KflqTd+0AaZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Apr 2018 10:05:48 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED6C14A084
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Apr 2018 10:05:47 -0400 (EDT)
In-Reply-To: <1524838505-3823-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

We introduce a new KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attribute in
KVM_DEV_ARM_VGIC_GRP_ADDR group. It allows userspace to provide the
base address and size of a redistributor region

Compared to KVM_VGIC_V3_ADDR_TYPE_REDIST, this new attribute allows
to declare several separate redistributor regions.

So the whole redist space does not need to be contiguous anymore.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

---
v3 -> v4:
- Added Peter's R-b
---
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 25 ++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
index 9293b45..cbc4328 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -27,9 +27,32 @@ Groups:
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
+        of the first redistributor in the region.
+      - count encodes the number of redistributors in the region. Must be
+        greater than 0.
+      There are two 64K pages for each redistributor in the region and
+      redistributors are laid out contiguously within the region. Regions
+      are filled with redistributors in the index order. The sum of all
+      region count fields must be greater than or equal to the number of
+      VCPUs. Redistributor regions must be registered in the incremental
+      index order, starting from index 0.
+      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
+
+  It is invalid to mix calls with KVM_VGIC_V3_ADDR_TYPE_REDIST and
+  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attributes.
+
   Errors:
     -E2BIG:  Address outside of addressable IPA range
-    -EINVAL: Incorrectly aligned address
+    -EINVAL: Incorrectly aligned address, bad redistributor region
+             count/index, mixed redistributor region attribute usage
     -EEXIST: Address already configured
     -ENXIO:  The group or attribute is unknown/unsupported for this device
              or hardware support is missing.
-- 
2.5.5
