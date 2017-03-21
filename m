From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 1/5] KVM: arm/arm64: Clarify GICC_PMR export format
Date: Tue, 21 Mar 2017 12:05:26 +0100
Message-ID: <20170321110530.15857-2-cdall@linaro.org>
References: <20170321110530.15857-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AA0140C26
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:03:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7VN2s-VqEFWx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 07:03:49 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5185240BE3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:03:49 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id n11so9555232wma.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 04:05:35 -0700 (PDT)
In-Reply-To: <20170321110530.15857-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Vijaya.Kumar@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

We are exporting the format of the priority field as it's stored in the
GICH_VMCR.VMPriMask field using the lower five bits when accessing
register state using the GICC_PMR offset.  This is unfortunate, but it's
ABI already, so we simply have to make it clear.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 76e61c8..975a904 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -83,6 +83,12 @@ Groups:
 
     Bits for undefined preemption levels are RAZ/WI.
 
+    For historical reasons we export the GICC_PMR register in the format of the
+    GICH_VMCR.VMPriMask field in the lower 5 bits of a word, meaning that
+    userspace must always use the lower 5 bits to communicate with the KVM
+    device and must shift the value left by 3 places to obtain the actual
+    priority mask level.
+
   Limitations:
     - Priorities are not implemented, and registers are RAZ/WI
     - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
-- 
2.9.0
