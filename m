From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
Date: Wed, 02 Dec 2015 14:32:59 -0700
Message-ID: <1449091979.15753.134.camel@redhat.com>
References: <cover.1448372839.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F68E49721
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 16:31:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0XoIbLTegIq1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 16:31:32 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81BCA496AC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 16:31:32 -0500 (EST)
In-Reply-To: <cover.1448372839.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, Manish Jaggi <mjaggi@caviumnetworks.com>, Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 2015-11-24 at 16:50 +0300, Pavel Fedin wrote:
> On some architectures (e.g. ARM64) if the device is behind an IOMMU, and
> is being mapped by VFIO, it is necessary to also add mappings for MSI
> translation register for interrupts to work. This series implements the
> necessary API to do this, and makes use of this API for GICv3 ITS on
> ARM64.
> 
> v1 => v2:
> - Adde dependency on CONFIG_GENERIC_MSI_IRQ_DOMAIN in some parts of the
>   code, should fix build without this option
> 
> Pavel Fedin (3):
>   vfio: Introduce map and unmap operations
>   gicv3, its: Introduce VFIO map and unmap operations
>   vfio: Introduce generic MSI mapping operations
> 
>  drivers/irqchip/irq-gic-v3-its.c   |  31 ++++++++++
>  drivers/vfio/pci/vfio_pci_intrs.c  |  11 ++++
>  drivers/vfio/vfio.c                | 116 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c    |  29 ++++++++++
>  include/linux/irqchip/arm-gic-v3.h |   2 +
>  include/linux/msi.h                |  12 ++++
>  include/linux/vfio.h               |  17 +++++-
>  7 files changed, 217 insertions(+), 1 deletion(-)


Some good points and bad.  I like that you're making this transparent
for the user, but at the same time, directly calling function pointers
through the msi_domain_ops is quite ugly.  There needs to be a real,
interface there that isn't specific to vfio.  The down side of making it
transparent to the user is that parts of their IOVA space are being
claimed and they have no way to figure out what they are.  In fact, the
IOMMU mappings bypass the rb-tree that the type1 driver uses, so these
mappings might stomp on existing mappings for the user or the user might
stomp on these.  Neither of which would be much fun to debug.

There have been previous efforts to support MSI mapping in VFIO[1,2],
but none of them have really gone anywhere.  Whatever solution we use
needs to support everyone who needs it.  Thanks,

Alex

[1] http://www.spinics.net/lists/kvm/msg121669.html, http://www.spinics.net/lists/kvm/msg121662.html
[2] http://www.spinics.net/lists/kvm/msg119236.html
