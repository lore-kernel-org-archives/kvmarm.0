From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 04/37] KVM: arm/arm64: Add GICV3 pending table save API
 documentation
Date: Tue,  9 May 2017 12:44:33 +0200
Message-ID: <20170509104506.30929-5-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B53240C42
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aO1Hpieb-QXj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:02 -0400 (EDT)
Received: from mail-qk0-f178.google.com (mail-qk0-f178.google.com
 [209.85.220.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F84540AF9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:02 -0400 (EDT)
Received: by mail-qk0-f178.google.com with SMTP id u75so75008943qka.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:17 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

Add description for how to save GICV3 LPI pending bit into
guest RAM pending tables.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
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
2.9.0
