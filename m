From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7 0/7] Add virtio-iommu driver
Date: Wed, 23 Jan 2019 09:34:35 +0100
Message-ID: <20190123083435.x3svwqp472mdgglw@8bytes.org>
References: <20190115121959.23763-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73A954A3CE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jan 2019 03:34:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GNn99vRfMARV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Jan 2019 03:34:40 -0500 (EST)
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2C174A3A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jan 2019 03:34:39 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190115121959.23763-1-jean-philippe.brucker@arm.com>
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

Hi Jean-Philippe,

thanks for all your hard work on this!

On Tue, Jan 15, 2019 at 12:19:52PM +0000, Jean-Philippe Brucker wrote:
> Implement the virtio-iommu driver, following specification v0.9 [1].

To make progress on this I think the spec needs to be close to something
that can be included into the official virtio-specification. Have you
proposed the specification for inclusion there?

This is because I can't merge a driver that might be incompatible to
future implementations because the specification needs to be changed on
its way to an official standard.

I had a short discussion with Michael S. Tsirkin about that and from
what I understood the spec needs to be proposed for inclusion on the
virtio-comment[1] mailing list and later the TC needs to vote on it.
Please work with Michael on this to get the specification official (or
at least pretty close to something that will be part of the official
virtio standard).

Regards,

	Joerg

[1] https://www.oasis-open.org/committees/comments/index.php?wg_abbrev=virtio
