From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v3 3/3] Make KVM_CAP_IRQFD dependent on KVM_CAP_IRQCHIP
Date: Wed, 05 Aug 2015 13:53:59 +0300
Message-ID: <64d0b7f9daf507c537edb45b63a8a0f7d2a7d781.1438770954.git.p.fedin@samsung.com>
References: <cover.1438770954.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC1695A0D8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2015 06:41:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gh8CHJdEdZVE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2015 06:41:23 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DED65A0D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2015 06:41:23 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NSL005KSVM9N510@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 05 Aug 2015 11:54:09 +0100 (BST)
In-reply-to: <cover.1438770954.git.p.fedin@samsung.com>
In-reply-to: <cover.1438770954.git.p.fedin@samsung.com>
References: <cover.1438770954.git.p.fedin@samsung.com>
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
This has to be verified with PowerPC and S390 maintainers. I've got an
impression that KVM_CAP_IRQCHIP is forgotten on these architectures
(their KConfig selects HAVE_KVM_IRQCHIP but KVM_CAP_IRQCHIP is not
mentioned anywhere in the respective code).
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
