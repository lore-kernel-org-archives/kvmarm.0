From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 5/8] KVM: arm/arm64: vgic-its: Fix return value for device
 table restore
Date: Mon, 30 Oct 2017 03:56:00 +0100
Message-ID: <20171030025603.23550-6-christoffer.dall@linaro.org>
References: <20171030025603.23550-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3738349D61
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tAeZcIIFdC4s for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Oct 2017 22:54:44 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52E5049D5D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:44 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id p75so12932809wmg.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 19:56:16 -0700 (PDT)
In-Reply-To: <20171030025603.23550-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 77652885a7c1..76685f4c6261 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1936,6 +1936,14 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
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
@@ -1947,6 +1955,10 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 	ret = scan_its_table(its, base, max_size, ite_esz, 0,
 			     vgic_its_restore_ite, dev);
 
+	/* scan_its_table returns +1 if all ITEs are invalid */
+	if (ret > 0)
+		ret = 0;
+
 	return ret;
 }
 
@@ -2103,10 +2115,7 @@ static int handle_l1_dte(struct vgic_its *its, u32 id, void *addr,
 	ret = scan_its_table(its, gpa, SZ_64K, dte_esz,
 			     l2_start_id, vgic_its_restore_dte, NULL);
 
-	if (ret <= 0)
-		return ret;
-
-	return 1;
+	return ret;
 }
 
 /**
@@ -2136,8 +2145,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 				     vgic_its_restore_dte, NULL);
 	}
 
+	/* scan_its_table returns +1 if all entries are invalid */
 	if (ret > 0)
-		ret = -EINVAL;
+		ret = 0;
 
 	return ret;
 }
-- 
2.14.2
