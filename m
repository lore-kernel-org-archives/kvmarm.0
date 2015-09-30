From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [RFC PATCH v5 2/3] vfio: platform: access device property as a list
 of strings
Date: Wed, 30 Sep 2015 11:09:06 +0200
Message-ID: <1443604149-3242-2-git-send-email-b.reynal@virtualopensystems.com>
References: <1443604149-3242-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DA644117E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:07:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KEW3sLMK5Cz0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2015 05:07:42 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66A23412F3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:07:42 -0400 (EDT)
Received: by wiclk2 with SMTP id lk2so51661954wic.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 02:09:18 -0700 (PDT)
In-Reply-To: <1443604149-3242-1-git-send-email-b.reynal@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org, alex.williamson@redhat.com, christoffer.dall@linaro.org, eric.auger@linaro.org
Cc: tech@virtualopensystems.com, open list <linux-kernel@vger.kernel.org>, "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis@virtualopensystems.com>

Certain device properties (e.g. the device node name, the compatible
string), are available as a list of strings (separated by the null
terminating character). Let the VFIO user query this type of properties.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>

---
v4 -> v5:
 - return ENOSPC when the buffer size is too small
 - remove strlen call

v3 -> v4:
 - The list length is computed before strings copy. If the entire list
   doesn't fit, no strings are copied to the user.
---
 drivers/vfio/platform/properties.c | 43 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platform/properties.c
index 48c90c5..212755f 100644
--- a/drivers/vfio/platform/properties.c
+++ b/drivers/vfio/platform/properties.c
@@ -22,7 +22,48 @@ static int dev_property_get_strings(struct device *dev,
 				    char *name, unsigned *lenp,
 				    void __user *datap, unsigned long datasz)
 {
-	return -EINVAL;
+	const char **val;
+	int n, i, ret;
+
+	if (lenp == NULL)
+		return -EFAULT;
+
+	*lenp = 0;
+
+	n = device_property_read_string_array(dev, name, NULL, 0);
+	if (n < 0)
+		return n;
+
+	val = kcalloc(n, sizeof(char *), GFP_KERNEL);
+	if (!val)
+		return -ENOMEM;
+
+	ret = device_property_read_string_array(dev, name, val, n);
+	if (ret < 0)
+		goto out;
+
+	for (i = 0; i < n; i++)
+		*lenp += strlen(val[i]) + 1;
+
+	if (datasz < *lenp) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	for (i = 0; i < n; i++) {
+		size_t len = strlen(val[i]) + 1;
+
+		if (copy_to_user(datap, val[i], len)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		datap += len;
+	}
+
+out:
+	kfree(val);
+	return ret;
 }
 
 static int dev_property_get_uint(struct device *dev,
-- 
2.6.0
