From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool 5/6] arm: pmu: Improve PMU error reporting
Date: Fri, 25 Jan 2019 18:08:00 +0000
Message-ID: <20190125180801.209910-6-andre.przywara@arm.com>
References: <20190125180801.209910-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF704A3F4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 13:08:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KYn8sF8pxIcI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 13:08:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C43204A3F2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 13:08:13 -0500 (EST)
In-Reply-To: <20190125180801.209910-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The KVM ioctls mostly just return -1 in the error case, leaving the
actual error code in errno.

Change the output of the PMU error message to actually print this error
code instead of the generic -1.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 69c37fae..ffd152e2 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -18,7 +18,7 @@ static int set_pmu_attr(struct kvm *kvm, int vcpu_idx,
 	if (!ret) {
 		ret = ioctl(fd, KVM_SET_DEVICE_ATTR, attr);
 		if (ret)
-			pr_err("PMU KVM_SET_DEVICE_ATTR failed (%d)\n", ret);
+			perror("PMU KVM_SET_DEVICE_ATTR failed");
 	} else {
 		pr_err("Unsupported PMU on vcpu%d\n", vcpu_idx);
 	}
-- 
2.17.1
