From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests v2 2/2] arm/pmu: don't run tcg tests
Date: Thu,  8 Dec 2016 18:05:49 +0100
Message-ID: <20161208170549.8793-3-drjones@redhat.com>
References: <20161208170549.8793-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F776404FF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 12:04:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id px4jROWcoTA0 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2016 12:04:55 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A77AD4050E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 12:04:55 -0500 (EST)
In-Reply-To: <20161208170549.8793-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

The TCG PMU is barely implemented for ARM and not at all implemented
for AArch64. Let's not bother running the TCG-only tests yet. We'll
likely move them to a new TCG-only unittests.cfg at some point before
re-enabling them too.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/unittests.cfg | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 044d97c9e73d..65f9c4c0b9eb 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -65,15 +65,15 @@ file = pmu.flat
 groups = pmu
 
 # Test PMU support (TCG) with -icount IPC=1
-[pmu-tcg-icount-1]
-file = pmu.flat
-extra_params = -icount 0 -append '1'
-groups = pmu
-accel = tcg
+#[pmu-tcg-icount-1]
+#file = pmu.flat
+#extra_params = -icount 0 -append '1'
+#groups = pmu
+#accel = tcg
 
 # Test PMU support (TCG) with -icount IPC=256
-[pmu-tcg-icount-256]
-file = pmu.flat
-extra_params = -icount 8 -append '256'
-groups = pmu
-accel = tcg
+#[pmu-tcg-icount-256]
+#file = pmu.flat
+#extra_params = -icount 8 -append '256'
+#groups = pmu
+#accel = tcg
-- 
2.9.3
