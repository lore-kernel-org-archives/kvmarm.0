Return-Path: <SRS0=SFjg=T6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE27DC28CC0
	for <kvmarm@archiver.kernel.org>; Thu, 30 May 2019 17:45:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3884E25EAB
	for <kvmarm@archiver.kernel.org>; Thu, 30 May 2019 17:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3884E25EAB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96D034A4DF;
	Thu, 30 May 2019 13:45:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jt428rpoF0IU; Thu, 30 May 2019 13:45:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D91A4A332;
	Thu, 30 May 2019 13:45:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA1884A332
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 May 2019 13:45:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4E9E4tZgVoPK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 May 2019 13:45:37 -0400 (EDT)
Received: from mail-qt1-f194.google.com (mail-qt1-f194.google.com
 [209.85.160.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 813D24A2E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 May 2019 13:45:37 -0400 (EDT)
Received: by mail-qt1-f194.google.com with SMTP id a15so5905032qtn.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 May 2019 10:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UgEoJIEOWgKSmNpnwJapd7xKMVBGEnMvpNqFuwdcHSY=;
 b=GM0mkvKc3Y0vOzaZi/0omyTZF9xzQxV4t/po6wzPvbna6y64GwucfVxxOeMgKw0KZF
 nrCxTVFAOum6uENh1upnpc/JZ4ijAZyJnYpJTFfet/7qJPJtS8o2vz3T6/cZ2CGMllxc
 wBR7J1DUVWedOlEHnwQC1FkFBLOcoiXHha9cyYtNo4jOnoptpIFSEN62x5My0jYFWVq0
 VttYDjT7oru9IYI5sQOmjvPjJE03Dl2lphor30OfmVGGl6mC/sKkCQfxLC3gqi71bBgw
 6MEL/laCoFfP5PZtsHvUfusbfS5m+LkHd8Jb9IRb4FoM87P+PQHPkE8TXbnlOESl6SaF
 UbTQ==
X-Gm-Message-State: APjAAAVWvc9KBCwtINbf6jcpCUHIqtPDeesgoXOu/FyKDu9xT+WZc+3D
 6nvIjBPd6OWj+expPCHv/jc77w==
X-Google-Smtp-Source: APXvYqy9DfCkbHWFwnoJIZhnJEIk9jBDmoJOESod/F/vQr9Iv7gjOGLceZ55BmbRJubgQEOI/tivJw==
X-Received: by 2002:aed:3b5a:: with SMTP id q26mr4641355qte.158.1559238337003; 
 Thu, 30 May 2019 10:45:37 -0700 (PDT)
Received: from redhat.com (pool-100-0-197-103.bstnma.fios.verizon.net.
 [100.0.197.103])
 by smtp.gmail.com with ESMTPSA id r186sm691141qkb.9.2019.05.30.10.45.34
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Thu, 30 May 2019 10:45:35 -0700 (PDT)
Date: Thu, 30 May 2019 13:45:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v8 2/7] dt-bindings: virtio: Add virtio-pci-iommu node
Message-ID: <20190530133523-mutt-send-email-mst@kernel.org>
References: <20190530170929.19366-1-jean-philippe.brucker@arm.com>
 <20190530170929.19366-3-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190530170929.19366-3-jean-philippe.brucker@arm.com>
Cc: virtio-dev@lists.oasis-open.org, kevin.tian@intel.com,
 Lorenzo.Pieralisi@arm.com, tnowicki@caviumnetworks.com, frowand.list@gmail.com,
 devicetree@vger.kernel.org, linux-pci@vger.kernel.org, joro@8bytes.org,
 virtualization@lists.linux-foundation.org, iommu@lists.linux-foundation.org,
 robh+dt@kernel.org, kvmarm@lists.cs.columbia.edu, bhelgaas@google.com,
 robin.murphy@arm.com, jasowang@redhat.com, bauerman@linux.ibm.com
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

On Thu, May 30, 2019 at 06:09:24PM +0100, Jean-Philippe Brucker wrote:
> Some systems implement virtio-iommu as a PCI endpoint. The operating
> system needs to discover the relationship between IOMMU and masters long
> before the PCI endpoint gets probed. Add a PCI child node to describe the
> virtio-iommu device.
> 
> The virtio-pci-iommu is conceptually split between a PCI programming
> interface and a translation component on the parent bus. The latter
> doesn't have a node in the device tree. The virtio-pci-iommu node
> describes both, by linking the PCI endpoint to "iommus" property of DMA
> master nodes and to "iommu-map" properties of bus nodes.
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

So this is just an example right?
We are not defining any new properties or anything like that.

I think down the road for non dt platforms we want to put this
info in the config space of the device. I do not think ACPI
is the best option for this since not all systems have it.
But that can wait.

> ---
>  .../devicetree/bindings/virtio/iommu.txt      | 66 +++++++++++++++++++
>  1 file changed, 66 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/virtio/iommu.txt
> 
> diff --git a/Documentation/devicetree/bindings/virtio/iommu.txt b/Documentation/devicetree/bindings/virtio/iommu.txt
> new file mode 100644
> index 000000000000..2407fea0651c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/virtio/iommu.txt
> @@ -0,0 +1,66 @@
> +* virtio IOMMU PCI device
> +
> +When virtio-iommu uses the PCI transport, its programming interface is
> +discovered dynamically by the PCI probing infrastructure. However the
> +device tree statically describes the relation between IOMMU and DMA
> +masters. Therefore, the PCI root complex that hosts the virtio-iommu
> +contains a child node representing the IOMMU device explicitly.
> +
> +Required properties:
> +
> +- compatible:	Should be "virtio,pci-iommu"
> +- reg:		PCI address of the IOMMU. As defined in the PCI Bus
> +		Binding reference [1], the reg property is a five-cell
> +		address encoded as (phys.hi phys.mid phys.lo size.hi
> +		size.lo). phys.hi should contain the device's BDF as
> +		0b00000000 bbbbbbbb dddddfff 00000000. The other cells
> +		should be zero.
> +- #iommu-cells:	Each platform DMA master managed by the IOMMU is assigned
> +		an endpoint ID, described by the "iommus" property [2].
> +		For virtio-iommu, #iommu-cells must be 1.
> +
> +Notes:
> +
> +- DMA from the IOMMU device isn't managed by another IOMMU. Therefore the
> +  virtio-iommu node doesn't have an "iommus" property, and is omitted from
> +  the iommu-map property of the root complex.
> +
> +Example:
> +
> +pcie@10000000 {
> +	compatible = "pci-host-ecam-generic";
> +	...
> +
> +	/* The IOMMU programming interface uses slot 00:01.0 */
> +	iommu0: iommu@0008 {
> +		compatible = "virtio,pci-iommu";
> +		reg = <0x00000800 0 0 0 0>;
> +		#iommu-cells = <1>;
> +	};
> +
> +	/*
> +	 * The IOMMU manages all functions in this PCI domain except
> +	 * itself. Omit BDF 00:01.0.
> +	 */
> +	iommu-map = <0x0 &iommu0 0x0 0x8>
> +		    <0x9 &iommu0 0x9 0xfff7>;
> +};
> +
> +pcie@20000000 {
> +	compatible = "pci-host-ecam-generic";
> +	...
> +	/*
> +	 * The IOMMU also manages all functions from this domain,
> +	 * with endpoint IDs 0x10000 - 0x1ffff
> +	 */
> +	iommu-map = <0x0 &iommu0 0x10000 0x10000>;
> +};
> +
> +ethernet@fe001000 {
> +	...
> +	/* The IOMMU manages this platform device with endpoint ID 0x20000 */
> +	iommus = <&iommu0 0x20000>;
> +};
> +
> +[1] Documentation/devicetree/bindings/pci/pci.txt
> +[2] Documentation/devicetree/bindings/iommu/iommu.txt
> -- 
> 2.21.0
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
