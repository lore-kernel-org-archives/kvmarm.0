From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 2/4] HACK: linux header update
Date: Wed, 18 Mar 2015 15:11:46 -0400
Message-ID: <1426705908-2765-3-git-send-email-drjones@redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
 <1426705908-2765-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25FC0491C7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:05:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WBPGdoy+TyL7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 15:05:22 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30F25491C9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:05:21 -0400 (EDT)
In-Reply-To: <1426705908-2765-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com
Cc: catalin.marinas@arm.com, lersek@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Should do a proper update-linux-headers.sh update.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 linux-headers/linux/kvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 60a54c82a3b76..34c03cd80aa69 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -108,6 +108,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_UNCACHED	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -760,6 +761,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_ENABLE_HCALL 104
 #define KVM_CAP_CHECK_EXTENSION_VM 105
 #define KVM_CAP_S390_USER_SIGP 106
+#define KVM_CAP_UNCACHED_MEM 107
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.8.3.1
