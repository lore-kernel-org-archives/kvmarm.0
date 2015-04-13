From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 11/16] KVM: kvm-vfio: wrappers for
 vfio_external_{mask|is_active|set_automasked}
Date: Mon, 13 Apr 2015 14:29:26 +0200
Message-ID: <1428928171-18884-12-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D7A84C44B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:25:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J3AgMP68ZJY2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:25:04 -0400 (EDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
 [209.85.212.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B47994C443
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:25:04 -0400 (EDT)
Received: by widdi4 with SMTP id di4so49678939wid.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:32:51 -0700 (PDT)
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

Those 3 new wrapper functions call the respective VFIO external
functions.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

- v4: creation
- v5 -> v6:
  x vfio.h modifications duly moved in "VFIO: platform: add
    vfio_external_{mask|is_active|set_automasked}"
  x all external functions use vfio_device handle
  x change proto of above function (unsigned index, unsigned start,
    unsigned count); also return int.
---
 virt/kvm/vfio.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 80a45e4..f4e86d3 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -134,6 +134,58 @@ static void kvm_vfio_put_vfio_device(struct vfio_device *vdev)
 	kvm_vfio_device_put_external_user(vdev);
 }
 
+int kvm_vfio_external_is_active(struct vfio_device *vdev,
+				unsigned index, unsigned start, unsigned count)
+{
+	int (*fn)(struct vfio_device *, unsigned index, unsigned start,
+			   unsigned count);
+	bool active;
+
+	fn = symbol_get(vfio_external_is_active);
+	if (!fn)
+		return -ENXIO;
+
+	active = fn(vdev, index, start, count);
+
+	symbol_put(vfio_external_is_active);
+	return active;
+}
+
+int kvm_vfio_external_mask(struct vfio_device *vdev, unsigned index,
+			   unsigned start, unsigned count)
+{
+	int ret;
+	int (*fn)(struct vfio_device *, unsigned index, unsigned start,
+		  unsigned count);
+
+	fn = symbol_get(vfio_external_mask);
+	if (!fn)
+		return -ENXIO;
+
+	ret = fn(vdev, index, start, count);
+
+	symbol_put(vfio_external_mask);
+	return ret;
+}
+
+int kvm_vfio_external_set_automasked(struct vfio_device *vdev,
+				      unsigned index, unsigned start,
+				      unsigned count, bool automasked)
+{
+	int ret;
+	int (*fn)(struct vfio_device *, unsigned index, unsigned start,
+		  unsigned count, bool automasked);
+
+	fn = symbol_get(vfio_external_set_automasked);
+	if (!fn)
+		return -ENXIO;
+
+	ret = fn(vdev, index, start, count, automasked);
+
+	symbol_put(vfio_external_set_automasked);
+	return ret;
+}
+
 static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
 {
 	long (*fn)(struct vfio_group *, unsigned long);
-- 
1.9.1
