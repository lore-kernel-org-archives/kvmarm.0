From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 07/16] VFIO: pci: initialize vfio_device_external_ops
Date: Mon, 13 Apr 2015 14:29:22 +0200
Message-ID: <1428928171-18884-8-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91AFA4C409
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EBMLeHN5-rZh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:24:57 -0400 (EDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
 [209.85.212.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 729B34C3F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:57 -0400 (EDT)
Received: by wiax7 with SMTP id x7so63536413wia.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:32:44 -0700 (PDT)
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

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v6: creation
---
 drivers/vfio/pci/vfio_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 2f865d07..755897f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -855,6 +855,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.write		= vfio_pci_write,
 	.mmap		= vfio_pci_mmap,
 	.request	= vfio_pci_request,
+	.external_ops	= NULL,
 };
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
1.9.1
