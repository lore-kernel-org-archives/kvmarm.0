From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v6 0/7] Add virtio-iommu driver
Date: Wed, 12 Dec 2018 11:35:45 +0100
Message-ID: <20181212103545.GV16835@8bytes.org>
References: <20181211182104.18241-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E925B4A1DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 05:35:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wq+MHRjwsDig for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 05:35:47 -0500 (EST)
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 850E64A1DC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 05:35:47 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181211182104.18241-1-jean-philippe.brucker@arm.com>
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
Cc: virtio-dev@lists.oasis-open.org, kevin.tian@intel.com, lorenzo.pieralisi@arm.com, tnowicki@caviumnetworks.com, mst@redhat.com, marc.zyngier@arm.com, linux-pci@vger.kernel.org, jasowang@redhat.com, will.deacon@arm.com, robin.murphy@arm.com, virtualization@lists.linux-foundation.org, iommu@lists.linux-foundation.org, robh+dt@kernel.org, bhelgaas@google.com, frowand.list@gmail.com, kvmarm@lists.cs.columbia.edu, devicetree@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

to make progress on this, we should first agree on the protocol used
between guest and host. I have a few points to discuss on the protocol
first.

On Tue, Dec 11, 2018 at 06:20:57PM +0000, Jean-Philippe Brucker wrote:
> [1] Virtio-iommu specification v0.9, sources and pdf
>     git://linux-arm.org/virtio-iommu.git virtio-iommu/v0.9
>     http://jpbrucker.net/virtio-iommu/spec/v0.9/virtio-iommu-v0.9.pdf

Looking at this I wonder why it doesn't make the IOTLB visible to the
guest. the UNMAP requests seem to require that the TLB is already
flushed to make the unmap visible.

I think that will cost significant performance for both, vfio and
dma-iommu use-cases which both do (vfio at least to some degree),
deferred flushing.

I also wonder whether the protocol should implement a
protocol version handshake and iommu-feature set queries.

> [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.9.1
>     git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.9

Unfortunatly gitweb seems to be broken on linux-arm.org. What is missing
in this patch-set to make this work on x86?

Regards,

	Joerg
