Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD65F531AEB
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074417; cv=none; b=XZWz5RK3fEmHKzINey3g6mIdBvK0z+h1U8yJcWboHsmJ7PkFC63TiA3JASY4xYoq4ud7cgbPEN82VTfIfuW2n75OVrPXQzS+uSflVbJ6SKQIHAtVmuuB0TPdQXpFK7geXXu7e3w5KYKj7ViGflhZaKxwKgWrslI6jzdw2VIi7wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074417; c=relaxed/simple;
	bh=PXqy5CTIvVyabhSobcDo5UynTRm8mgLyLlhfsHWhUkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EltEB3McGX1Q/FEsWFd+PMfxSxDM7iUMFy0tggfefpmbUsr2wm0YryKPTvOpI4oz2AqjJlh88XEJpgP4FNqsj0/lHLUGjYg9oMQxqhpDGj2/PNxcmxjopa4IEeeSeaX60hK2+V0Cne+SQrKjzTjkpT/3m3368Skk2xpg0G17AVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S5ZNRTzf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S5ZNRTzf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70C36175A;
	Thu, 15 Oct 2026 07:26:42 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 823663F871;
	Thu, 15 Oct 2026 07:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074405; bh=PXqy5CTIvVyabhSobcDo5UynTRm8mgLyLlhfsHWhUkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5ZNRTzfTolZ+Gox3+EeghnFvOjOfvisyiJqfkcRnXbzdW9A9ndtPBMqlauFmqpdz
	 rg6I6zNLJIjuTgVkZBSLh1Xffq/q77Q/SDEhlFVQ98mbDoAgIy3LrXdki0Pdf9LDui
	 f246UeemzOG1S0I1I8k1XtVaOzqh6IFG3XaYQNCg=
From: Ryan Roberts <ryan.roberts@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 12/15] vfio: Support VFIO devices that access the CPU MMU
Date: Thu, 15 Oct 2026 15:25:46 +0100
Message-ID: <20261015142552.4128028-13-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015142552.4128028-1-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jpb@kernel.org>

Support devices that are attached to a CPU and perform DMA through a
MMU. They do not have an IOMMU and do not use a VFIO container.
The VMM needs device-specific knowledge in order to create a virtual
device (device tree, ACPI tables), so it also knows not to allocate a
container.

Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
---
 drivers/vfio/group.c     | 37 +++++++++++++++++++++++++++++--------
 drivers/vfio/vfio.h      |  5 +++++
 drivers/vfio/vfio_main.c | 16 +++++++++++++++-
 include/linux/vfio.h     |  1 +
 4 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index b2299e5bc6df..99d85880a41c 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -120,7 +120,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 		return -EBADF;
 
 	mutex_lock(&group->group_lock);
-	if (vfio_group_has_iommu(group)) {
+	if (vfio_group_has_iommu(group) || group->type == VFIO_CPU_MMU) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -173,7 +173,8 @@ static int vfio_df_group_open(struct vfio_device_file *df)
 	int ret;
 
 	mutex_lock(&device->group->group_lock);
-	if (!vfio_group_has_iommu(device->group)) {
+	if (!vfio_group_has_iommu(device->group) &&
+	    device->group->type != VFIO_CPU_MMU) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -635,7 +636,8 @@ static bool vfio_group_has_device(struct vfio_group *group, struct device *dev)
 	return false;
 }
 
-static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
+static struct vfio_group *vfio_group_find_or_alloc(struct device *dev,
+						   enum vfio_group_type type)
 {
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
@@ -662,12 +664,13 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	mutex_lock(&vfio.group_lock);
 	group = vfio_group_find_from_iommu(iommu_group);
 	if (group) {
-		if (WARN_ON(vfio_group_has_device(group, dev)))
+		if (WARN_ON(vfio_group_has_device(group, dev)) ||
+		    WARN_ON(group->type != type))
 			group = ERR_PTR(-EINVAL);
 		else
 			refcount_inc(&group->drivers);
 	} else {
-		group = vfio_create_group(iommu_group, VFIO_IOMMU);
+		group = vfio_create_group(iommu_group, type);
 	}
 	mutex_unlock(&vfio.group_lock);
 
@@ -681,10 +684,18 @@ int vfio_device_set_group(struct vfio_device *device,
 {
 	struct vfio_group *group;
 
-	if (type == VFIO_IOMMU)
-		group = vfio_group_find_or_alloc(device->dev);
-	else
+	switch (type) {
+	case VFIO_IOMMU:
+	case VFIO_CPU_MMU:
+		group = vfio_group_find_or_alloc(device->dev, type);
+		break;
+	case VFIO_EMULATED_IOMMU:
+	case VFIO_NO_IOMMU:
 		group = vfio_noiommu_group_alloc(device->dev, type);
+		break;
+	default:
+		group = ERR_PTR(-EINVAL);
+	}
 
 	if (IS_ERR(group))
 		return PTR_ERR(group);
@@ -761,6 +772,11 @@ int vfio_device_group_use_iommu(struct vfio_device *device)
 
 	lockdep_assert_held(&group->group_lock);
 
+	if (group->type == VFIO_CPU_MMU) {
+		get_file(group->opened_file);
+		return 0;
+	}
+
 	if (WARN_ON(!group->container))
 		return -EINVAL;
 
@@ -777,6 +793,11 @@ void vfio_device_group_unuse_iommu(struct vfio_device *device)
 
 	lockdep_assert_held(&group->group_lock);
 
+	if (group->type == VFIO_CPU_MMU) {
+		fput(group->opened_file);
+		return;
+	}
+
 	if (WARN_ON(!group->container))
 		return;
 
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 7728bc99b63d..07c5223612d3 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -64,6 +64,11 @@ enum vfio_group_type {
 	 * taint the kernel.
 	 */
 	VFIO_NO_IOMMU,
+
+	/*
+	 * Physical devices using the CPU MMU
+	 */
+	VFIO_CPU_MMU,
 };
 
 #if IS_ENABLED(CONFIG_VFIO_GROUP)
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 423ead48aafe..41fee81a14cb 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -344,7 +344,8 @@ static int __vfio_register_dev(struct vfio_device *device,
 {
 	int ret;
 
-	if (WARN_ON(IS_ENABLED(CONFIG_IOMMUFD) &&
+	if (type != VFIO_CPU_MMU &&
+	    WARN_ON(IS_ENABLED(CONFIG_IOMMUFD) &&
 		    (!device->ops->bind_iommufd ||
 		     !device->ops->unbind_iommufd ||
 		     !device->ops->attach_ioas ||
@@ -415,6 +416,19 @@ int vfio_register_emulated_iommu_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
 
+/*
+ * Register a devices that accesses memory through the CPU MMU. Although it
+ * doesn't use an IOMMU, the device must have an IOMMU group.
+ */
+int vfio_register_cpu_mmu_dev(struct vfio_device *device)
+{
+	if (!IS_ENABLED(CONFIG_VFIO_GROUP))
+		return -EOPNOTSUPP;
+
+	return __vfio_register_dev(device, VFIO_CPU_MMU);
+}
+EXPORT_SYMBOL_GPL(vfio_register_cpu_mmu_dev);
+
 /*
  * Decrement the device reference count and wait for the device to be
  * removed.  Open file descriptors for the device... */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 45f08986359e..7d3a5ff1ad00 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -337,6 +337,7 @@ static inline void vfio_put_device(struct vfio_device *device)
 	put_device(&device->device);
 }
 
+int vfio_register_cpu_mmu_dev(struct vfio_device *device);
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
-- 
2.43.0

