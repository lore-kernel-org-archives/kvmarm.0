From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 06/16] VFIO: Introduce vfio_device_external_ops
Date: Mon, 13 Apr 2015 14:29:21 +0200
Message-ID: <1428928171-18884-7-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7554C411
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yYcwhjvI8sCB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:24:57 -0400 (EDT)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 845284C3D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:55 -0400 (EDT)
Received: by wgso17 with SMTP id o17so79115289wgs.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:32:42 -0700 (PDT)
In-Reply-To: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com
Cc: feng.wu@intel.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

New bus callbacks are introduced. They correspond to external
functions. To avoid messing up the main vfio_device_ops
struct, a new vfio_device_external_ops struct is introduced.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v6: creation
---
 include/linux/vfio.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b18c38f..b0ec474 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -19,6 +19,23 @@
 #include <uapi/linux/vfio.h>
 
 /**
+ * struct vfio_device_external_ops - VFIO bus driver device callbacks
+ * used as external API
+ * @mask: mask any IRQ defined by triplet
+ * @is_active: returns whether any IRQ defined by triplet is active
+ * @set_automasked: sets the automasked flag of triplet's IRQ
+ */
+struct vfio_device_external_ops  {
+	int (*mask)(void *device_data, unsigned index, unsigned start,
+		    unsigned count);
+	int (*is_active)(void *device_data, unsigned index, unsigned start,
+			 unsigned count);
+	int (*set_automasked)(void *device_data, unsigned index,
+			      unsigned start, unsigned count,
+			       bool automasked);
+};
+
+/**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
  * @open: Called when userspace creates new file descriptor for device
@@ -42,6 +59,7 @@ struct vfio_device_ops {
 			 unsigned long arg);
 	int	(*mmap)(void *device_data, struct vm_area_struct *vma);
 	void	(*request)(void *device_data, unsigned int count);
+	struct vfio_device_external_ops *external_ops;
 };
 
 extern int vfio_add_group_dev(struct device *dev,
-- 
1.9.1
