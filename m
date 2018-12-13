From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 0/7] Add virtio-iommu driver
Date: Thu, 13 Dec 2018 06:17:46 -0800
Message-ID: <20181213141746.GA19757@infradead.org>
References: <20181211182104.18241-1-jean-philippe.brucker@arm.com>
 <20181212103545.GV16835@8bytes.org>
 <9110873f-d344-b6b9-c722-9accfc329db2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0DD4A2BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Dec 2018 09:18:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sa5PQXNBko1X for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Dec 2018 09:18:03 -0500 (EST)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43C3B4A1D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Dec 2018 09:18:02 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <9110873f-d344-b6b9-c722-9accfc329db2@arm.com>
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
Cc: "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "kevin.tian@intel.com" <kevin.tian@intel.com>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "mst@redhat.com" <mst@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Will Deacon <Will.Deacon@arm.com>, "frowand.list@gmail.com" <frowand.list@gmail.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "bhelgaas@google.com" <bhelgaas@google.com>, Robin Murphy <Robin.Murphy@arm.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 13, 2018 at 12:50:29PM +0000, Jean-Philippe Brucker wrote:
> * DMA ops for x86 (see "HACK" commit). I'd like to use dma-iommu but I'm
> not sure how to implement the glue that sets dma_ops properly.

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma-iommu-ops
