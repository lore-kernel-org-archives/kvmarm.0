From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 02/12] KVM: arm/arm64: Document
 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Mon, 19 Mar 2018 10:20:10 +0100
Message-ID: <1521451220-27754-3-git-send-email-eric.auger@redhat.com>
References: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC49B49FBB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Mar 2018 05:13:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1c24xU0z7-11 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Mar 2018 05:12:50 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8827B49F88
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Mar 2018 05:12:50 -0400 (EDT)
In-Reply-To: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
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
---
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
index 9293b45..2c0bedf 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -27,6 +27,18 @@ Groups:
       VCPU and all of the redistributor pages are contiguous.
       Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
       This address needs to be 64K aligned.
+
+    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION (rw, 64-bit)
+      The attr field of kvm_device_attr encodes 3 values:
+      bits:     | 63   ....  52  |  51   ....   12 |11 - 0
+      values:   |     pfns       |       base      | index
+      - index encodes the unique redistibutor region index
+      - base field encodes bits [51:12] the guest physical base address
+        of the first redistributor in the region. There are two 64K pages
+        for each VCPU and all of the redistributor pages are contiguous
+        within the redistributor region.
+      - pfns encodes the size of the region in 64kB pages.
+      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
   Errors:
     -E2BIG:  Address outside of addressable IPA range
     -EINVAL: Incorrectly aligned address
-- 
2.5.5
