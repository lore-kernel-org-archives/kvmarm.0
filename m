Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3559DC55191
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 17:39:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F009620857
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 17:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F009620857
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9EED4B1AA;
	Thu, 23 Apr 2020 13:39:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2gCqNcyL1OV1; Thu, 23 Apr 2020 13:39:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C3704B19F;
	Thu, 23 Apr 2020 13:39:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 818844B18C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 13:39:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AaBNyuEuDjLe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 13:39:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 543464B187
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 13:39:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7F89C14;
 Thu, 23 Apr 2020 10:39:03 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A1FE3F68F;
 Thu, 23 Apr 2020 10:39:02 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v4 1/5] virtio-mmio: Assign IRQ line directly before
 registering device
Date: Thu, 23 Apr 2020 18:38:40 +0100
Message-Id: <20200423173844.24220-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423173844.24220-1-andre.przywara@arm.com>
References: <20200423173844.24220-1-andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Raphael Gault <raphael.gault@arm.com>, Sami Mujawar <sami.mujawar@arm.com>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

At the moment the IRQ line for a virtio-mmio device is assigned in the
generic device__register() routine in devices.c, by calling back into
virtio-mmio.c. This does not only sound slightly convoluted, but also
breaks when we try to register an MMIO device that is not a virtio-mmio
device. In this case container_of will return a bogus pointer (as it
assumes a struct virtio_mmio), and the IRQ allocation routine will
corrupt some data in the device_header (for instance the first byte
of the "data" pointer).

Simply assign the IRQ directly in virtio_mmio_init(), before calling
device__register(). This avoids the problem and looks actually much more
straightforward.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 devices.c                 |  4 ----
 include/kvm/virtio-mmio.h |  1 -
 virtio/mmio.c             | 10 ++--------
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/devices.c b/devices.c
index a7c666a7..2c8b2665 100644
--- a/devices.c
+++ b/devices.c
@@ -1,7 +1,6 @@
 #include "kvm/devices.h"
 #include "kvm/kvm.h"
 #include "kvm/pci.h"
-#include "kvm/virtio-mmio.h"
 
 #include <linux/err.h>
 #include <linux/rbtree.h>
@@ -33,9 +32,6 @@ int device__register(struct device_header *dev)
 	case DEVICE_BUS_PCI:
 		pci__assign_irq(dev);
 		break;
-	case DEVICE_BUS_MMIO:
-		virtio_mmio_assign_irq(dev);
-		break;
 	default:
 		break;
 	}
diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
index 0528947a..6bc50bd1 100644
--- a/include/kvm/virtio-mmio.h
+++ b/include/kvm/virtio-mmio.h
@@ -57,5 +57,4 @@ int virtio_mmio_exit(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		      int device_id, int subsys_id, int class);
-void virtio_mmio_assign_irq(struct device_header *dev_hdr);
 #endif
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 5537c393..875a288c 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -280,14 +280,6 @@ static void generate_virtio_mmio_fdt_node(void *fdt,
 }
 #endif
 
-void virtio_mmio_assign_irq(struct device_header *dev_hdr)
-{
-	struct virtio_mmio *vmmio = container_of(dev_hdr,
-						 struct virtio_mmio,
-						 dev_hdr);
-	vmmio->irq = irq__alloc_line();
-}
-
 int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class)
 {
@@ -316,6 +308,8 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		.data		= generate_virtio_mmio_fdt_node,
 	};
 
+	vmmio->irq = irq__alloc_line();
+
 	r = device__register(&vmmio->dev_hdr);
 	if (r < 0) {
 		kvm__deregister_mmio(kvm, vmmio->addr);
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
