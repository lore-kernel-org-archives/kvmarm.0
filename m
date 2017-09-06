From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [RFC PATCH 3/3] kvm: arm/arm64: vgic-its: fix return value for restore
Date: Wed, 6 Sep 2017 21:05:10 +0800
Message-ID: <1504703110-10744-4-git-send-email-wanghaibin.wang@huawei.com>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5167749C42
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 09:04:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oAoKqJSSCqCb for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Sep 2017 09:04:09 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 146E440D8B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 09:04:08 -0400 (EDT)
In-Reply-To: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch fix the migrate restore tables failure.

The same scene, at the destination, the restore tables interface traversal guest
memory, and check the dte/ite is valid or not.
If all dtes/ites are invalid, we will do try next one, and the last it will take
the 1 return value, but currently, it be treated as error. That's not correct.

This patch try to fix this problem.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 5c20352..2c69aeb 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2025,7 +2025,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
 		return PTR_ERR(dev);
 
 	ret = vgic_its_restore_itt(its, dev);
-	if (ret) {
+	if (ret < 0) {
 		vgic_its_free_device(its->dev->kvm, dev);
 		return ret;
 	}
@@ -2147,9 +2147,6 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 				     vgic_its_restore_dte, NULL);
 	}
 
-	if (ret > 0)
-		ret = -EINVAL;
-
 	return ret;
 }
 
-- 
1.8.3.1
