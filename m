From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 13/13] vfio: check reserved regions before mapping
 DMA
Date: Mon, 18 Jun 2018 19:42:11 +0100
Message-ID: <20180618184211.43904-14-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 849A64A0D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:32:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M0ndrzJJXukb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADB92402B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:46 -0400 (EDT)
In-Reply-To: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: lorenzo.pieralisi@arm.com, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, alex.williamson@redhat.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Use the new reserved_regions API to ensure that RAM doesn't overlap any
reserved region. This prevents for instance from mapping an MSI doorbell
into the guest IPA space. For the moment we reject any overlapping. In the
future, we might carve reserved regions out of the guest physical
space.

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 vfio/core.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/vfio/core.c b/vfio/core.c
index a4a257a70..17b5b0cfc 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -379,6 +379,51 @@ static int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void
 	return 0;
 }
 
+static int vfio_configure_reserved_regions(struct kvm *kvm,
+					   struct vfio_group *group)
+{
+	FILE *file;
+	int ret = 0;
+	char type[9];
+	char filename[PATH_MAX];
+	unsigned long long start, end;
+
+	snprintf(filename, PATH_MAX, IOMMU_GROUP_DIR "/%lu/reserved_regions",
+		 group->id);
+
+	/* reserved_regions might not be present on older systems */
+	if (access(filename, F_OK))
+		return 0;
+
+	file = fopen(filename, "r");
+	if (!file)
+		return -errno;
+
+	while (fscanf(file, "0x%llx 0x%llx %8s\n", &start, &end, type) == 3) {
+		ret = kvm__reserve_mem(kvm, start, end - start + 1);
+		if (ret)
+			break;
+	}
+
+	fclose(file);
+
+	return ret;
+}
+
+static int vfio_configure_groups(struct kvm *kvm)
+{
+	int ret;
+	struct vfio_group *group;
+
+	list_for_each_entry(group, &vfio_groups, list) {
+		ret = vfio_configure_reserved_regions(kvm, group);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static struct vfio_group *vfio_group_create(struct kvm *kvm, unsigned long id)
 {
 	int ret;
@@ -597,6 +642,10 @@ static int vfio__init(struct kvm *kvm)
 	if (ret)
 		return ret;
 
+	ret = vfio_configure_groups(kvm);
+	if (ret)
+		return ret;
+
 	ret = vfio_configure_devices(kvm);
 	if (ret)
 		return ret;
-- 
2.17.0
