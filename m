From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 07/10] limit number of VCPUs on demand
Date: Fri,  3 Jul 2015 12:26:35 +0100
Message-ID: <1435922798-14375-8-git-send-email-andre.przywara@arm.com>
References: <1435922798-14375-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFCD657923
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 07:15:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oIvPoh4No+NK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 07:15:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBA085794E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 07:15:36 -0400 (EDT)
In-Reply-To: <1435922798-14375-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: penberg@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently the ARM GIC checks the number of VCPUs against a fixed
limit, which is GICv2 specific. Don't pretend we know better than the
kernel and let's get rid of that explicit check.
We now fail if the number of requested VCPUs could not be
instantiated instead of limiting the number of VCPUs.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 99f0d2b..05f85a2 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -84,12 +84,6 @@ int gic__create(struct kvm *kvm)
 {
 	int err;
 
-	if (kvm->nrcpus > GIC_MAX_CPUS) {
-		pr_warning("%d CPUS greater than maximum of %d -- truncating\n",
-				kvm->nrcpus, GIC_MAX_CPUS);
-		kvm->nrcpus = GIC_MAX_CPUS;
-	}
-
 	/* Try the new way first, and fallback on legacy method otherwise */
 	err = gic__create_device(kvm);
 	if (err)
-- 
2.3.5
