From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 07/13] Add fls_long and roundup_pow_of_two helpers
Date: Mon, 18 Jun 2018 19:42:05 +0100
Message-ID: <20180618184211.43904-8-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 965394A0D4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:32:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nic2WDCz6piy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21F454A0DE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:36 -0400 (EDT)
In-Reply-To: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: lorenzo.pieralisi@arm.com, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, alex.williamson@redhat.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

It's always nice to have a log2 handy, and the vfio-pci code will need to
perform power of two allocation from an arbitrary size. Add fls_long and
roundup_pow_of_two, based on the GCC builtin.

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/util.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/kvm/util.h b/include/kvm/util.h
index 0df9f0dfd..4ca7aa939 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -90,6 +90,20 @@ static inline void msleep(unsigned int msecs)
 	usleep(MSECS_TO_USECS(msecs));
 }
 
+/*
+ * Find last (most significant) bit set. Same implementation as Linux:
+ * fls(0) = 0, fls(1) = 1, fls(1UL << 63) = 64
+ */
+static inline int fls_long(unsigned long x)
+{
+	return x ? sizeof(x) * 8 - __builtin_clzl(x) : 0;
+}
+
+static inline unsigned long roundup_pow_of_two(unsigned long x)
+{
+	return x ? 1UL << fls_long(x - 1) : 0;
+}
+
 struct kvm;
 void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
-- 
2.17.0
