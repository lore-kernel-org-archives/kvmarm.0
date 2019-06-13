Return-Path: <SRS0=T7gh=UM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862D5C31E45
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jun 2019 15:54:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B4F120851
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jun 2019 15:54:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B4F120851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 614894A483;
	Thu, 13 Jun 2019 11:54:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XIIaPK66gDtq; Thu, 13 Jun 2019 11:54:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 514E94A4F5;
	Thu, 13 Jun 2019 11:54:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FF7E4A483
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jun 2019 11:54:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lj9VzYIF+tk4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jun 2019 11:54:34 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AC304A418
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jun 2019 11:54:34 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id C5F033086204;
 Thu, 13 Jun 2019 15:54:24 +0000 (UTC)
Received: from [10.36.116.67] (ovpn-116-67.ams2.redhat.com [10.36.116.67])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7664E6061E;
 Thu, 13 Jun 2019 15:54:15 +0000 (UTC)
Subject: Re: [PATCH v8 0/7] Add virtio-iommu driver
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, joro@8bytes.org,
 mst@redhat.com
References: <20190530170929.19366-1-jean-philippe.brucker@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <42408240-81a1-fe25-72da-5a93c9e1cb89@redhat.com>
Date: Thu, 13 Jun 2019 17:54:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190530170929.19366-1-jean-philippe.brucker@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.42]); Thu, 13 Jun 2019 15:54:28 +0000 (UTC)
Cc: virtio-dev@lists.oasis-open.org, kevin.tian@intel.com,
 Lorenzo.Pieralisi@arm.com, frowand.list@gmail.com, devicetree@vger.kernel.org,
 linux-pci@vger.kernel.org, jasowang@redhat.com,
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

Hi,

On 5/30/19 7:09 PM, Jean-Philippe Brucker wrote:
> Implement the virtio-iommu driver, following specification v0.12 [1].
> Since last version [2] we've worked on improving the specification,
> which resulted in the following changes to the interface:
> * Remove the EXEC flag.
> * Add feature bit for the MMIO flag.
> * Change domain_bits to domain_range.
> 
> Given that there were small changes to patch 5/7, I removed the review
> and test tags. Please find the code at [3].
> 
> [1] Virtio-iommu specification v0.12, sources and pdf
>     git://linux-arm.org/virtio-iommu.git virtio-iommu/v0.12
>     http://jpbrucker.net/virtio-iommu/spec/v0.12/virtio-iommu-v0.12.pdf
>     http://jpbrucker.net/virtio-iommu/spec/diffs/virtio-iommu-dev-diff-v0.11-v0.12.pdf
> 
> [2] [PATCH v7 0/7] Add virtio-iommu driver
>     https://lore.kernel.org/linux-pci/0ba215f5-e856-bf31-8dd9-a85710714a7a@arm.com/T/
> 
> [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.12
>     git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.12

SERIES
Tested-by: Eric Auger <eric.auger@redhat.com>

with QEMU branch:
https://github.com/eauger/qemu/tree/v4.0-virtio-iommu-v0.12

and kernel branch:
https://github.com/eauger/linux/tree/virtio-iommu-v0.12
(where I just added the rebased iort patches on top of Jean-Philippe's
virtio-iommu/v0.12 branch). So I also tested the ACPI boot.

I will formally submit the QEMU series ASAP.

Thanks

Eric

> 
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
>  drivers/iommu/virtio-iommu.c                  | 1176 +++++++++++++++++
>  drivers/of/base.c                             |   10 +-
>  drivers/pci/of.c                              |    6 +
>  include/uapi/linux/virtio_ids.h               |    1 +
>  include/uapi/linux/virtio_iommu.h             |  165 +++
>  10 files changed, 1470 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/virtio/iommu.txt
>  create mode 100644 drivers/iommu/virtio-iommu.c
>  create mode 100644 include/uapi/linux/virtio_iommu.h
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
