From: vijay.kilari@gmail.com
Subject: [PATCH v9 08/11] arm/arm64: Documentation: Update arm-vgic-v3.txt
Date: Wed, 23 Nov 2016 18:31:55 +0530
Message-ID: <1479906118-15832-9-git-send-email-vijay.kilari@gmail.com>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5463440C25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:02:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dXwKHArBpyfW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 08:01:55 -0500 (EST)
Received: from mail-pg0-f68.google.com (mail-pg0-f68.google.com [74.125.83.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06DA740A86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:01:52 -0500 (EST)
Received: by mail-pg0-f68.google.com with SMTP id 3so1096243pgd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 05:02:33 -0800 (PST)
In-Reply-To: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

Update error code returned for Invalid CPU interface register
value.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
index 9348b3c..bff2898 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
@@ -145,7 +145,7 @@ Groups:
   Errors:
     -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: VCPU is running
-    -EINVAL: Invalid mpidr supplied
+    -EINVAL: Invalid mpidr or register value supplied
 
 
   KVM_DEV_ARM_VGIC_GRP_NR_IRQS
-- 
1.9.1
