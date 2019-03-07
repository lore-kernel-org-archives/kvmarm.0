From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 03/16] brlock: fix build with KVM_BRLOCK_DEBUG
Date: Thu,  7 Mar 2019 08:36:04 +0000
Message-ID: <1551947777-13044-4-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 015524A4C1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EauAOiAOamQq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:29 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 167FB4A49D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:29 -0500 (EST)
In-Reply-To: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Andre.Przywara@arm.com, Sami.Mujawar@arm.com, will.deacon@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Build breaks when using KVM_BRLOCK_DEBUG because the header was seamingly
conceived to be included in a single .c file...

Fix this by moving the definition of the read/write lock into the kvm
struct.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/brlock.h | 10 ++++------
 include/kvm/kvm.h    |  4 ++++
 kvm.c                |  4 ++++
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/kvm/brlock.h b/include/kvm/brlock.h
index 29f72e0..1862210 100644
--- a/include/kvm/brlock.h
+++ b/include/kvm/brlock.h
@@ -21,13 +21,11 @@
 
 #include "kvm/rwsem.h"
 
-DECLARE_RWSEM(brlock_sem);
+#define br_read_lock(kvm)	down_read(&(kvm)->brlock_sem);
+#define br_read_unlock(kvm)	up_read(&(kvm)->brlock_sem);
 
-#define br_read_lock(kvm)	down_read(&brlock_sem);
-#define br_read_unlock(kvm)	up_read(&brlock_sem);
-
-#define br_write_lock(kvm)	down_write(&brlock_sem);
-#define br_write_unlock(kvm)	up_write(&brlock_sem);
+#define br_write_lock(kvm)	down_write(&(kvm)->brlock_sem);
+#define br_write_unlock(kvm)	up_write(&(kvm)->brlock_sem);
 
 #else
 
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 1edacfd..7a73818 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -81,6 +81,10 @@ struct kvm {
 	int                     nr_disks;
 
 	int			vm_state;
+
+#ifdef KVM_BRLOCK_DEBUG
+	pthread_rwlock_t	brlock_sem;
+#endif
 };
 
 void kvm__set_dir(const char *fmt, ...);
diff --git a/kvm.c b/kvm.c
index d5249a0..57c4ff9 100644
--- a/kvm.c
+++ b/kvm.c
@@ -160,6 +160,10 @@ struct kvm *kvm__new(void)
 	kvm->sys_fd = -1;
 	kvm->vm_fd = -1;
 
+#ifdef KVM_BRLOCK_DEBUG
+	kvm->brlock_sem = (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
+#endif
+
 	return kvm;
 }
 
-- 
1.9.1
