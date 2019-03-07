From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 10/16] ref_cnt: Add simple ref counting API
Date: Thu,  7 Mar 2019 08:36:11 +0000
Message-ID: <1551947777-13044-11-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30B144A4DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b1yilOvTUFs2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 799034A4CD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:39 -0500 (EST)
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

Provide a simple API with structure and function for reference counting.
This is inspired by the linux kref.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 include/kvm/ref_cnt.h | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 include/kvm/ref_cnt.h

diff --git a/include/kvm/ref_cnt.h b/include/kvm/ref_cnt.h
new file mode 100644
index 0000000..1c8194c
--- /dev/null
+++ b/include/kvm/ref_cnt.h
@@ -0,0 +1,53 @@
+#ifndef KVM__REF_CNT_H
+#define KVM__REF_CNT_H
+
+#include "kvm/mutex.h"
+
+#ifdef __ATOMIC_ACQUIRE
+
+#define KVM_ATOMIC_ACQUIRE __ATOMIC_ACQUIRE
+#define KVM_ATOMIC_RELEASE __ATOMIC_RELEASE
+
+#define kvm_atomic_add_fetch(ptr, val, memorder)	\
+	__atomic_add_fetch((ptr), (val), (memorder))
+
+#define kvm_atomic_sub_fetch(ptr, val, memorder)	\
+	__atomic_sub_fetch((ptr), (val), (memorder))
+#else
+
+#define KVM_ATOMIC_ACQUIRE 0
+#define KVM_ATOMIC_RELEASE 0
+
+#define kvm_atomic_add_fetch(ptr, val, memorder)	\
+	__sync_fetch_and_add((ptr), (val))
+
+#define kvm_atomic_sub_fetch(ptr, val, memorder)	\
+	__sync_fetch_and_sub((ptr), (val))
+
+#endif
+
+struct ref_cnt {
+	int cnt;
+};
+
+#define REF_CNT_INIT (struct ref_cnt) { .cnt = 1 }
+
+static inline void ref_cnt_init(struct ref_cnt *ref_cnt)
+{
+	ref_cnt->cnt = 1;
+}
+
+static inline void ref_get(struct ref_cnt *ref_cnt)
+{
+	kvm_atomic_add_fetch(&ref_cnt->cnt, 1, KVM_ATOMIC_ACQUIRE);
+
+}
+
+static inline void ref_put(struct ref_cnt *ref_cnt,
+			   void (*release)(struct ref_cnt *ref_cnt))
+{
+	if (!kvm_atomic_sub_fetch(&ref_cnt->cnt, 1, KVM_ATOMIC_RELEASE))
+		release(ref_cnt);
+}
+
+#endif /* KVM__REF_CNT_H */
-- 
1.9.1
