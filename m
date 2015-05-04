From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 2/4] hw/vfio/common: vfio_kvm_device_fd moved in the common
 header
Date: Mon,  4 May 2015 13:49:56 +0100
Message-ID: <1430743798-8839-3-git-send-email-eric.auger@linaro.org>
References: <1430743798-8839-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C0354F787
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2015 08:41:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id POoVo3GKe-VB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2015 08:41:26 -0400 (EDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 488944F78B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2015 08:41:26 -0400 (EDT)
Received: by wgin8 with SMTP id n8so148763900wgi.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 May 2015 05:50:08 -0700 (PDT)
In-Reply-To: <1430743798-8839-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

the device is now used in platform for forwarded IRQ setup

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/vfio/common.c              | 2 +-
 include/hw/vfio/vfio-common.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index b012620..18ad67c 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -44,7 +44,7 @@ struct vfio_as_head vfio_address_spaces =
  * initialized, this file descriptor is only released on QEMU exit and
  * we'll re-use it should another vfio device be attached before then.
  */
-static int vfio_kvm_device_fd = -1;
+int vfio_kvm_device_fd = -1;
 #endif
 
 /*
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 59a321d..53d0e68 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -40,6 +40,10 @@
 #define VFIO_ALLOW_KVM_MSI 1
 #define VFIO_ALLOW_KVM_MSIX 1
 
+#ifdef CONFIG_KVM
+extern int vfio_kvm_device_fd;
+#endif
+
 enum {
     VFIO_DEVICE_TYPE_PCI = 0,
     VFIO_DEVICE_TYPE_PLATFORM = 1,
-- 
1.8.3.2
