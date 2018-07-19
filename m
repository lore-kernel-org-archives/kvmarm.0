From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 01/10] KVM: arm/arm64: vgic: Define GICD_IIDR fields
 for GICv2 and GIv3
Date: Thu, 19 Jul 2018 18:08:46 +0200
Message-ID: <20180719160846.gvguydoolpn2olzz@kamzik.brq.redhat.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
 <1531746387-7033-2-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4992349FA8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 11:55:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZK2F8Z3-aq+t for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 11:55:43 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A7F449F8C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 11:55:43 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1531746387-7033-2-git-send-email-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 16, 2018 at 03:06:18PM +0200, Christoffer Dall wrote:
> Instead of hardcoding the shifts and masks in the GICD_IIDR register
> emulation, let's add the definition of these fields to the GIC header
> files and use them.
> 
> This will make things more obvious when we're going to bump the revision
> in the IIDR when we'll make guest-visible changes to the implementation.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  include/linux/irqchip/arm-gic-v3.h | 10 ++++++++++
>  include/linux/irqchip/arm-gic.h    | 10 ++++++++++
>  virt/kvm/arm/vgic/vgic-mmio-v2.c   |  3 ++-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c   |  3 ++-
>  4 files changed, 24 insertions(+), 2 deletions(-)
> 

Reviewed-by: Andrew Jones <drjones@redhat.com>
