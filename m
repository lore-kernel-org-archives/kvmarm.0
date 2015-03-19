From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v12 1/9] linux-headers: update VFIO header for VFIO
 platform/amba drivers
Date: Thu, 19 Mar 2015 17:16:33 +0000
Message-ID: <1426785402-2091-2-git-send-email-eric.auger@linaro.org>
References: <1426785402-2091-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8360E4933A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 13:10:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JTCLeqrQtrF0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2015 13:10:08 -0400 (EDT)
Received: from mail-wg0-f54.google.com (mail-wg0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C9EA49330
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 13:10:07 -0400 (EDT)
Received: by wgbcc7 with SMTP id cc7so68262372wgb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 10:16:49 -0700 (PDT)
In-Reply-To: <1426785402-2091-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: patches@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Update according to the vfio.h header found in
ssh://git@git.linaro.org/people/eric.auger/linux.git
branch 4.0-rc3-v14

---

v10 -> v11:
- only includes header modifications related to vfio platform
  driver v14 and not those related to
  "vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1"
---
 linux-headers/linux/vfio.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 95ba870..b57b750 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -8,8 +8,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#ifndef VFIO_H
-#define VFIO_H
+#ifndef _UAPIVFIO_H
+#define _UAPIVFIO_H
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
@@ -160,6 +160,8 @@ struct vfio_device_info {
 	__u32	flags;
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
+#define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
+#define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
@@ -495,4 +497,4 @@ struct vfio_eeh_pe_op {
 
 /* ***************************************************************** */
 
-#endif /* VFIO_H */
+#endif /* _UAPIVFIO_H */
-- 
1.8.3.2
