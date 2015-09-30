From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [RFC PATCH v5 3/3] vfio: platform: return device properties as arrays
	of unsigned integers
Date: Wed, 30 Sep 2015 11:09:07 +0200
Message-ID: <1443604149-3242-3-git-send-email-b.reynal@virtualopensystems.com>
References: <1443604149-3242-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1443604149-3242-1-git-send-email-b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:VFIO PLATFORM DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>

Certain properties of a device are accessible as an array of unsigned
integers, either u64, u32, u16, or u8. Let the VFIO user query this
type of device properties.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Signed-off-by: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>

---
v4 -> v5:
 - fix return error when the buffer size is too small
---
 drivers/vfio/platform/properties.c | 62 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platform/properties.c
index 212755f..a4b6955 100644
--- a/drivers/vfio/platform/properties.c
+++ b/drivers/vfio/platform/properties.c
@@ -70,7 +70,67 @@ static int dev_property_get_uint(struct device *dev,
 				 char *name, uint32_t type, unsigned *lenp,
 				 void __user *datap, unsigned long datasz)
 {
-	return -EINVAL;
+	int ret, n;
+	u8 *out;
+	size_t sz;
+	int (*func)(const struct device *, const char *, void *, size_t)
+		= NULL;
+
+	switch (type) {
+	case VFIO_DEV_PROPERTY_TYPE_U64:
+		sz = sizeof(u64);
+		func = (int (*)(const struct device *,
+				const char *, void *, size_t))
+			device_property_read_u64_array;
+		break;
+	case VFIO_DEV_PROPERTY_TYPE_U32:
+		sz = sizeof(u32);
+		func = (int (*)(const struct device *,
+				const char *, void *, size_t))
+			device_property_read_u32_array;
+		break;
+	case VFIO_DEV_PROPERTY_TYPE_U16:
+		sz = sizeof(u16);
+		func = (int (*)(const struct device *,
+				const char *, void *, size_t))
+			device_property_read_u16_array;
+		break;
+	case VFIO_DEV_PROPERTY_TYPE_U8:
+		sz = sizeof(u8);
+		func = (int (*)(const struct device *,
+				const char *, void *, size_t))
+			device_property_read_u8_array;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/* get size of array */
+	n = func(dev, name, NULL, 0);
+	if (n < 0)
+		return n;
+
+	if (lenp)
+		*lenp = n * sz;
+
+	if (n * sz > datasz)
+		return -ENOSPC;
+
+	out = kcalloc(n, sz, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	ret = func(dev, name, out, n);
+	if (ret)
+		goto out;
+
+	if (copy_to_user(datap, out, n * sz))
+		ret = -EFAULT;
+
+out:
+	kfree(out);
+	return ret;
 }
 
 int vfio_platform_dev_properties(struct device *dev,
-- 
2.6.0
