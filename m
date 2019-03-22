From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH] vfio-pci: Fix MSI IRQ forwarding for without per-vector
 masking
Date: Fri, 22 Mar 2019 13:23:08 +0800
Message-ID: <20190322052308.28254-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5784A2E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Mar 2019 01:23:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zXzmK9PQps1F for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Mar 2019 01:23:27 -0400 (EDT)
Received: from mail-yw1-f68.google.com (mail-yw1-f68.google.com
 [209.85.161.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F0244A2B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Mar 2019 01:23:27 -0400 (EDT)
Received: by mail-yw1-f68.google.com with SMTP id l15so480307ywe.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 22:23:27 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Eric Auger <eric.auger@redhat.com>, Robin Murphy <robin.murphy@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

If MSI doesn't support per-vector masking capability and
PCI_MSI_FLAGS_MASKBIT isn't set in message control field, the function
vfio_pci_msi_vector_write() will directly bail out for this case and
every vector's 'virt_state' keeps setting bit VFIO_PCI_MSI_STATE_MASKED.

This results in the state maintained in 'virt_state' cannot really
reflect the MSI hardware state; finally it will mislead the function
vfio_pci_update_msi_entry() to skip IRQ forwarding with below flow:

vfio_pci_update_msi_entry() {

  [...]

  if (msi_is_masked(entry->virt_state) == msi_is_masked(entry->phys_state))
      return 0;  ==> skip IRQ forwarding

  [...]
}

To fix this issue, when detect PCI_MSI_FLAGS_MASKBIT is not set in the
message control field, this patch simply clears bit
VFIO_PCI_MSI_STATE_MASKED for all vectors 'virt_state'; at the end
vfio_pci_update_msi_entry() can forward MSI IRQ successfully.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 vfio/pci.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index ba971eb..4fd24ac 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -363,8 +363,18 @@ static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
 	struct vfio_pci_device *pdev = &vdev->pci;
 	struct msi_cap_64 *msi_cap_64 = PCI_CAP(&pdev->hdr, pdev->msi.pos);
 
-	if (!(msi_cap_64->ctrl & PCI_MSI_FLAGS_MASKBIT))
+	if (!(msi_cap_64->ctrl & PCI_MSI_FLAGS_MASKBIT)) {
+		/*
+		 * If MSI doesn't support per-vector masking capability,
+		 * simply unmask for all vectors.
+		 */
+		for (i = 0; i < pdev->msi.nr_entries; i++) {
+			entry = &pdev->msi.entries[i];
+			msi_set_masked(entry->virt_state, false);
+		}
+
 		return 0;
+	}
 
 	if (msi_cap_64->ctrl & PCI_MSI_FLAGS_64BIT)
 		mask_pos = PCI_MSI_MASK_64;
-- 
2.19.1
