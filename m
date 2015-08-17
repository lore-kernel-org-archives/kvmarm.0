From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v4 3/3] Make KVM_CAP_IRQFD dependent on KVM_CAP_IRQCHIP
Date: Mon, 17 Aug 2015 12:43:40 +0300
Message-ID: <cb1a3f2cce3fc7a1240281822cef9e5ff87f2e2c.1439804074.git.p.fedin@samsung.com>
References: <cover.1439804074.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B96A55C55A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 05:30:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iq2g6KvvfGEV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2015 05:30:31 -0400 (EDT)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46C0F5C558
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 05:30:30 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NT800HAS0CZHO80@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 17 Aug 2015 10:43:47 +0100 (BST)
In-reply-to: <cover.1439804074.git.p.fedin@samsung.com>
In-reply-to: <cover.1439804074.git.p.fedin@samsung.com>
References: <cover.1439804074.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Now at least ARM is able to determine whether the machine has
virtualization support for irqchip or not at runtime. Obviously,
irqfd requires irqchip.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/kvm_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9097741..7b49618 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2478,12 +2478,13 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_HAVE_KVM_MSI
 	case KVM_CAP_SIGNAL_MSI:
 #endif
+	case KVM_CAP_CHECK_EXTENSION_VM:
+		return 1;
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	case KVM_CAP_IRQFD:
 	case KVM_CAP_IRQFD_RESAMPLE:
+		return kvm_vm_ioctl_check_extension(kvm, KVM_CAP_IRQCHIP);
 #endif
-	case KVM_CAP_CHECK_EXTENSION_VM:
-		return 1;
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
 	case KVM_CAP_IRQ_ROUTING:
 		return KVM_MAX_IRQ_ROUTES;
-- 
2.4.4
