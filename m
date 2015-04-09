From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 2/2] arm_gicv2m: set kvm_gsi_direct_mapping and
 kvm_msi_via_irqfd_allowed
Date: Thu,  9 Apr 2015 16:20:08 +0100
Message-ID: <1428592808-4424-3-git-send-email-eric.auger@linaro.org>
References: <1428592808-4424-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F2574BE83
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 11:12:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nLzButhWJB2E for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 11:12:45 -0400 (EDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
 [209.85.212.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B428B4BF0D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 11:12:45 -0400 (EDT)
Received: by wiun10 with SMTP id n10so102355200wiu.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Apr 2015 08:20:21 -0700 (PDT)
In-Reply-To: <1428592808-4424-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, peter.maydell@linaro.org, cornelia.huck@de.ibm.com, borntraeger@de.ibm.com, agraf@suse.de, james.hogan@imgtec.com
Cc: aik@ozlabs.ru, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

After introduction of kvm_arch_msi_data_to_gsi, kvm_gsi_direct_mapping
now can be set on ARM. Also kvm_msi_via_irqfd_allowed can be set,
depending on kernel irqfd support, hence enabling VIRTIO-PCI with
vhost back-end.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/intc/arm_gicv2m.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/hw/intc/arm_gicv2m.c b/hw/intc/arm_gicv2m.c
index a80a16d..7c6bea2 100644
--- a/hw/intc/arm_gicv2m.c
+++ b/hw/intc/arm_gicv2m.c
@@ -138,6 +138,8 @@ static void gicv2m_realize(DeviceState *dev, Error **errp)
     }
 
     msi_supported = true;
+    kvm_gsi_direct_mapping = true;
+    kvm_msi_via_irqfd_allowed = kvm_irqfds_enabled();
 }
 
 static void gicv2m_init(Object *obj)
-- 
1.8.3.2
