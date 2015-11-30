From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v5 2/2] KVM: Make KVM_CAP_IRQFD dependent on KVM_CAP_IRQCHIP
Date: Mon, 30 Nov 2015 12:40:45 +0300
Message-ID: <57888eef1c5c21337ddad384250bc5f55829ac67.1448874023.git.p.fedin@samsung.com>
References: <cover.1448874023.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 809A64852E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 04:39:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rTZGfA4jO2bh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2015 04:39:35 -0500 (EST)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82E0A48529
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 04:39:35 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYM00BR4G85PR40@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 30 Nov 2015 09:40:53 +0000 (GMT)
In-reply-to: <cover.1448874023.git.p.fedin@samsung.com>
In-reply-to: <cover.1448874023.git.p.fedin@samsung.com>
References: <cover.1448874023.git.p.fedin@samsung.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Now at least ARM is able to determine whether the machine has
virtualization support for irqchip or not at runtime. Obviously,
irqfd requires irqchip.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7873d6d..a057d5e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2716,13 +2716,15 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_INTERNAL_ERROR_DATA:
 #ifdef CONFIG_HAVE_KVM_MSI
 	case KVM_CAP_SIGNAL_MSI:
+		/* Fallthrough */
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
