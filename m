From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 01/10] KVM: arm/arm64: vgic-its: Fix return value for
 device table restore
Date: Mon, 23 Oct 2017 16:08:20 +0200
Message-ID: <1508767709-15256-2-git-send-email-eric.auger@redhat.com>
References: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2AB849D26
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 10:07:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1ZVV+uJiP1TD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Oct 2017 10:07:31 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1066749D27
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Oct 2017 10:07:31 -0400 (EDT)
In-Reply-To: <1508767709-15256-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: wanghaibin <wanghaibin.wang@huawei.com>

If ITT only contains invalid entries, vgic_its_restore_itt
returns 1 and this is considered as an an error in
vgic_its_restore_dte.

Also in case the device table only contains invalid entries,
the table restore fails and this is not correct.

This patch fixes those 2 issues:
- vgic_its_restore_itt now returns <= 0 values. If all
  ITEs are invalid, this is considered as successful.
- vgic_its_restore_device_tables also returns <= 0 values.

We also simplify the returned value computation in
handle_l1_dte.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

need to CC'ed stable

v2 -> v3:
- add comments
- vgic_its_restore_itt don't return +1 anymore
- reword the commit message

v1 -> v2:
- if (ret > 0) ret = 0
---
 virt/kvm/arm/vgic/vgic-its.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f51c1e1..d27a301 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1940,6 +1940,14 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 	return 0;
 }
 
+/**
+ * vgic_its_restore_itt - restore the ITT of a device
+ *
+ * @its: its handle
+ * @dev: device handle
+ *
+ * Return 0 on success, < 0 on error
+ */
 static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
@@ -1951,6 +1959,10 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 	ret = scan_its_table(its, base, max_size, ite_esz, 0,
 			     vgic_its_restore_ite, dev);
 
+	/* scan_its_table returns +1 if all ITEs are invalid */
+	if (ret > 0)
+		ret = 0;
+
 	return ret;
 }
 
@@ -2107,10 +2119,7 @@ static int handle_l1_dte(struct vgic_its *its, u32 id, void *addr,
 	ret = scan_its_table(its, gpa, SZ_64K, dte_esz,
 			     l2_start_id, vgic_its_restore_dte, NULL);
 
-	if (ret <= 0)
-		return ret;
-
-	return 1;
+	return ret;
 }
 
 /**
@@ -2140,8 +2149,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 				     vgic_its_restore_dte, NULL);
 	}
 
+	/* scan_its_table returns +1 if all entries are invalid */
 	if (ret > 0)
-		ret = -EINVAL;
+		ret = 0;
 
 	return ret;
 }
-- 
2.5.5
