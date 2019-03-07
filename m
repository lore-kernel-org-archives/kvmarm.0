From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 09/16] brlock: Use rwlock instead of pause
Date: Thu,  7 Mar 2019 08:36:10 +0000
Message-ID: <1551947777-13044-10-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 081944A4C8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zabgLeMieojy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:39 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 130034A500
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:38 -0500 (EST)
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

Pausing all vcpus when reconfiguring something at run time is a big
overhead. Use rwlock to allow vcpu not accessing ressources being
reconfigured to continue running.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/brlock.h | 11 -----------
 include/kvm/kvm.h    |  2 --
 2 files changed, 13 deletions(-)

diff --git a/include/kvm/brlock.h b/include/kvm/brlock.h
index 1862210..7d81056 100644
--- a/include/kvm/brlock.h
+++ b/include/kvm/brlock.h
@@ -17,8 +17,6 @@
 #define barrier()		__asm__ __volatile__("": : :"memory")
 #endif
 
-#ifdef KVM_BRLOCK_DEBUG
-
 #include "kvm/rwsem.h"
 
 #define br_read_lock(kvm)	down_read(&(kvm)->brlock_sem);
@@ -27,13 +25,4 @@
 #define br_write_lock(kvm)	down_write(&(kvm)->brlock_sem);
 #define br_write_unlock(kvm)	up_write(&(kvm)->brlock_sem);
 
-#else
-
-#define br_read_lock(kvm)	barrier()
-#define br_read_unlock(kvm)	barrier()
-
-#define br_write_lock(kvm)	kvm__pause(kvm)
-#define br_write_unlock(kvm)	kvm__continue(kvm)
-#endif
-
 #endif
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 7a73818..2f1679e 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -82,9 +82,7 @@ struct kvm {
 
 	int			vm_state;
 
-#ifdef KVM_BRLOCK_DEBUG
 	pthread_rwlock_t	brlock_sem;
-#endif
 };
 
 void kvm__set_dir(const char *fmt, ...);
-- 
1.9.1
