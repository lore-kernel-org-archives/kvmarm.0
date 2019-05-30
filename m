Return-Path: <SRS0=SFjg=T6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA9DC28CC0
	for <kvmarm@archiver.kernel.org>; Thu, 30 May 2019 17:12:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7435725E18
	for <kvmarm@archiver.kernel.org>; Thu, 30 May 2019 17:12:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7435725E18
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ABCC4A4F2;
	Thu, 30 May 2019 13:12:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XMqIOHyyd5l1; Thu, 30 May 2019 13:12:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B534A4E1;
	Thu, 30 May 2019 13:12:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0824A2E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 May 2019 13:12:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TSNOV9iE7nqD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 May 2019 13:12:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 499574A49F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 May 2019 13:12:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8CD315AD;
 Thu, 30 May 2019 10:12:38 -0700 (PDT)
Received: from ostrya.cambridge.arm.com (ostrya.cambridge.arm.com
 [10.1.196.129])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8B5EA3F5AF;
 Thu, 30 May 2019 10:12:35 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To: joro@8bytes.org,
	mst@redhat.com
Subject: [PATCH v8 1/7] dt-bindings: virtio-mmio: Add IOMMU description
Date: Thu, 30 May 2019 18:09:23 +0100
Message-Id: <20190530170929.19366-2-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530170929.19366-1-jean-philippe.brucker@arm.com>
References: <20190530170929.19366-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Cc: virtio-dev@lists.oasis-open.org, kevin.tian@intel.com,
 Lorenzo.Pieralisi@arm.com, tnowicki@caviumnetworks.com, frowand.list@gmail.com,
 devicetree@vger.kernel.org, linux-pci@vger.kernel.org, jasowang@redhat.com,
 virtualization@lists.linux-foundation.org, iommu@lists.linux-foundation.org,
 robh+dt@kernel.org, bhelgaas@google.com, robin.murphy@arm.com,
 kvmarm@lists.cs.columbia.edu, bauerman@linux.ibm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The nature of a virtio-mmio node is discovered by the virtio driver at
probe time. However the DMA relation between devices must be described
statically. When a virtio-mmio node is a virtio-iommu device, it needs an
"#iommu-cells" property as specified by bindings/iommu/iommu.txt.

Otherwise, the virtio-mmio device may perform DMA through an IOMMU, which
requires an "iommus" property. Describe these requirements in the
device-tree bindings documentation.

Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 .../devicetree/bindings/virtio/mmio.txt       | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/devicetree/bindings/virtio/mmio.txt b/Documentation/devicetree/bindings/virtio/mmio.txt
index 5069c1b8e193..21af30fbb81f 100644
--- a/Documentation/devicetree/bindings/virtio/mmio.txt
+++ b/Documentation/devicetree/bindings/virtio/mmio.txt
@@ -8,10 +8,40 @@ Required properties:
 - reg:		control registers base address and size including configuration space
 - interrupts:	interrupt generated by the device
 
+Required properties for virtio-iommu:
+
+- #iommu-cells:	When the node corresponds to a virtio-iommu device, it is
+		linked to DMA masters using the "iommus" or "iommu-map"
+		properties [1][2]. #iommu-cells specifies the size of the
+		"iommus" property. For virtio-iommu #iommu-cells must be
+		1, each cell describing a single endpoint ID.
+
+Optional properties:
+
+- iommus:	If the device accesses memory through an IOMMU, it should
+		have an "iommus" property [1]. Since virtio-iommu itself
+		does not access memory through an IOMMU, the "virtio,mmio"
+		node cannot have both an "#iommu-cells" and an "iommus"
+		property.
+
 Example:
 
 	virtio_block@3000 {
 		compatible = "virtio,mmio";
 		reg = <0x3000 0x100>;
 		interrupts = <41>;
+
+		/* Device has endpoint ID 23 */
+		iommus = <&viommu 23>
 	}
+
+	viommu: iommu@3100 {
+		compatible = "virtio,mmio";
+		reg = <0x3100 0x100>;
+		interrupts = <42>;
+
+		#iommu-cells = <1>
+	}
+
+[1] Documentation/devicetree/bindings/iommu/iommu.txt
+[2] Documentation/devicetree/bindings/pci/pci-iommu.txt
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
