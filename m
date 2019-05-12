Return-Path: <SRS0=MMrp=TM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD4EC04A6B
	for <kvmarm@archiver.kernel.org>; Sun, 12 May 2019 17:15:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 514CB20C01
	for <kvmarm@archiver.kernel.org>; Sun, 12 May 2019 17:15:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 514CB20C01
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CDC64A4BE;
	Sun, 12 May 2019 13:15:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VkbmKALolybk; Sun, 12 May 2019 13:15:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF7E4A4CA;
	Sun, 12 May 2019 13:15:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4EA54A4AA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 May 2019 13:15:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u+IiwOkp6Hqo for <kvmarm@lists.cs.columbia.edu>;
 Sun, 12 May 2019 13:15:20 -0400 (EDT)
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com
 [209.85.222.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 863844A3A3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 May 2019 13:15:20 -0400 (EDT)
Received: by mail-qk1-f193.google.com with SMTP id g190so4548052qkf.8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 May 2019 10:15:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Sz6oXhk1MUAcDMqhVgJnZ+u8Zwtmv3OV0JGi1Y8CWDw=;
 b=gqJIIpz4/4A3kjC/wa4uewd1ZspgaDS0qKrDwsmGebiYumq1esrQerhLm3YwRImAJZ
 G/vYjDryyZPWzv3IpsOXzHy9wltyJiZ4GkigeUjwSeaKWyANVv4z12qZn7PFc55YCDYA
 h8KlHSR/QV0sJ9D2CDn8xn+lyLQ549Kgt1HyCDRhFxj24KOn0OdgVRHzRi6+8JjjS0IT
 ZCUaWjav4xsMAb7T/hbytxdKAPm6JxAnyEU4ygwffD9IdQkgARLdzkqwX3VUTEwNKa5P
 gjTPRRBQLAS7/kRRq9p+W9qiieRnwMLU+lnc5ilyHB1zqD7wWnAfgcrQaZTmtWbLtHOm
 TEGQ==
X-Gm-Message-State: APjAAAXzBAJvCRQrjNDRu9KBUJFvlxlXWlZ8dvpFwXyNCyIws3ZCEX/8
 abYIKSmiwdpo/UzNHjBWe09bnw==
X-Google-Smtp-Source: APXvYqxLzieYropX9DXBLnvbsudc9FJW0WQmQVUd/9WRnEbpC2BiYAyAKTnxKUBxw7ns2tMNztADiw==
X-Received: by 2002:a37:b3c5:: with SMTP id c188mr18807278qkf.97.1557681320186; 
 Sun, 12 May 2019 10:15:20 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net.
 [173.76.105.71])
 by smtp.gmail.com with ESMTPSA id c32sm6064980qte.2.2019.05.12.10.15.18
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Sun, 12 May 2019 10:15:19 -0700 (PDT)
Date: Sun, 12 May 2019 13:15:16 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v7 0/7] Add virtio-iommu driver
Message-ID: <20190512131500-mutt-send-email-mst@kernel.org>
References: <20190115121959.23763-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190115121959.23763-1-jean-philippe.brucker@arm.com>
Cc: virtio-dev@lists.oasis-open.org, kevin.tian@intel.com,
 lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com,
 devicetree@vger.kernel.org, marc.zyngier@arm.com, linux-pci@vger.kernel.org,
 joro@8bytes.org, will.deacon@arm.com, robin.murphy@arm.com,
 virtualization@lists.linux-foundation.org, iommu@lists.linux-foundation.org,
 robh+dt@kernel.org, kvmarm@lists.cs.columbia.edu, bhelgaas@google.com,
 frowand.list@gmail.com, jasowang@redhat.com
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

On Tue, Jan 15, 2019 at 12:19:52PM +0000, Jean-Philippe Brucker wrote:
> Implement the virtio-iommu driver, following specification v0.9 [1].
> 
> This is a simple rebase onto Linux v5.0-rc2. We now use the
> dev_iommu_fwspec_get() helper introduced in v5.0 instead of accessing
> dev->iommu_fwspec, but there aren't any functional change from v6 [2].
> 
> Our current goal for virtio-iommu is to get a paravirtual IOMMU working
> on Arm, and enable device assignment to guest userspace. In this
> use-case the mappings are static, and don't require optimal performance,
> so this series tries to keep things simple. However there is plenty more
> to do for features and optimizations, and having this base in v5.1 would
> be good. Given that most of the changes are to drivers/iommu, I believe
> the driver and future changes should go via the IOMMU tree.
> 
> You can find Linux driver and kvmtool device on v0.9.2 branches [3],
> module and x86 support on virtio-iommu/devel. Also tested with Eric's
> QEMU device [4]. Please note that the series depends on Robin's
> probe-deferral fix [5], which will hopefully land in v5.0.
> 
> [1] Virtio-iommu specification v0.9, sources and pdf
>     git://linux-arm.org/virtio-iommu.git virtio-iommu/v0.9
>     http://jpbrucker.net/virtio-iommu/spec/v0.9/virtio-iommu-v0.9.pdf
> 
> [2] [PATCH v6 0/7] Add virtio-iommu driver
>     https://lists.linuxfoundation.org/pipermail/iommu/2018-December/032127.html
> 
> [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.9.2
>     git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.9.2
> 
> [4] [RFC v9 00/17] VIRTIO-IOMMU device
>     https://www.mail-archive.com/qemu-devel@nongnu.org/msg575578.html
> 
> [5] [PATCH] iommu/of: Fix probe-deferral
>     https://www.spinics.net/lists/arm-kernel/msg698371.html

For virtio things:

Acked-by: Michael S. Tsirkin <mst@redhat.com>



> Jean-Philippe Brucker (7):
>   dt-bindings: virtio-mmio: Add IOMMU description
>   dt-bindings: virtio: Add virtio-pci-iommu node
>   of: Allow the iommu-map property to omit untranslated devices
>   PCI: OF: Initialize dev->fwnode appropriately
>   iommu: Add virtio-iommu driver
>   iommu/virtio: Add probe request
>   iommu/virtio: Add event queue
> 
>  .../devicetree/bindings/virtio/iommu.txt      |   66 +
>  .../devicetree/bindings/virtio/mmio.txt       |   30 +
>  MAINTAINERS                                   |    7 +
>  drivers/iommu/Kconfig                         |   11 +
>  drivers/iommu/Makefile                        |    1 +
>  drivers/iommu/virtio-iommu.c                  | 1158 +++++++++++++++++
>  drivers/of/base.c                             |   10 +-
>  drivers/pci/of.c                              |    7 +
>  include/uapi/linux/virtio_ids.h               |    1 +
>  include/uapi/linux/virtio_iommu.h             |  161 +++
>  10 files changed, 1449 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/virtio/iommu.txt
>  create mode 100644 drivers/iommu/virtio-iommu.c
>  create mode 100644 include/uapi/linux/virtio_iommu.h
> 
> -- 
> 2.19.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
