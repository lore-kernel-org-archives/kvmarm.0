From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 2/6] HACK: linux header update
Date: Fri,  6 Mar 2015 13:53:34 -0500
Message-ID: <1425668018-3649-3-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425668018-3649-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5F8647FF0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id irNbPFNMeVmV for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:47:40 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECA3E48011
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:39 -0500 (EST)
In-Reply-To: <1425668018-3649-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Should do a proper update-linux-headers.sh update.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 linux-headers/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 12045a11c036b..d04e2d781c43b 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -108,6 +108,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_INCOHERENT	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
-- 
1.8.3.1
