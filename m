From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 2/7] dt-bindings: virtio: Add virtio-pci-iommu node
Date: Wed, 17 Oct 2018 19:35:02 -0500
Message-ID: <20181018003502.GA28260@bogus>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
 <20181012145917.6840-3-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 942A64A1D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Oct 2018 20:35:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IDVZ+wQNdoWU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Oct 2018 20:35:04 -0400 (EDT)
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com
 [209.85.210.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C33E849F87
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Oct 2018 20:35:04 -0400 (EDT)
Received: by mail-ot1-f66.google.com with SMTP id x4so26689385otg.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Oct 2018 17:35:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20181012145917.6840-3-jean-philippe.brucker@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: kevin.tian@intel.com, lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com, devicetree@vger.kernel.org, jasowang@redhat.com, linux-pci@vger.kernel.org, joro@8bytes.org, mst@redhat.com, will.deacon@arm.com, virtualization@lists.linux-foundation.org, iommu@lists.linux-foundation.org, robh+dt@kernel.org, marc.zyngier@arm.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 12 Oct 2018 15:59:12 +0100, Jean-Philippe Brucker wrote:
> Some systems implement virtio-iommu as a PCI endpoint. The operating
> systems needs to discover the relationship between IOMMU and masters long
> before the PCI endpoint gets probed. Add a PCI child node to describe the
> virtio-iommu device.
> 
> The virtio-pci-iommu is conceptually split between a PCI programming
> interface and a translation component on the parent bus. The latter
> doesn't have a node in the device tree. The virtio-pci-iommu node
> describes both, by linking the PCI endpoint to "iommus" property of DMA
> master nodes and to "iommu-map" properties of bus nodes.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> ---
>  .../devicetree/bindings/virtio/iommu.txt      | 66 +++++++++++++++++++
>  1 file changed, 66 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/virtio/iommu.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
