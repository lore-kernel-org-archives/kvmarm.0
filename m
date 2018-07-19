From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 08/10] KVM: arm/arm64: vgic: Allow configuration of
 interrupt groups
Date: Thu, 19 Jul 2018 19:26:21 +0200
Message-ID: <20180719172621.3ti7xfpvcrn3waww@kamzik.brq.redhat.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
 <1531746387-7033-9-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0730E40196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 13:13:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A4IedIP8wirT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 13:13:19 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C45F40192
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 13:13:19 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1531746387-7033-9-git-send-email-christoffer.dall@arm.com>
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

On Mon, Jul 16, 2018 at 03:06:25PM +0200, Christoffer Dall wrote:
> Implement the required MMIO accessors for GICv2 and GICv3 for the
> IGROUPR distributor and redistributor registers.
> 
> This can allow guests to change behavior compared to running on previous
> versions of KVM, but only to align with the architecture and hardware
> implementations.
> 
> This also allows userspace to configure the interrupts groups for GICv3.
> We don't allow userspace to write the groups on GICv2 just yet, because
> that would result in GICv2 guests not receiving interrupts after
> migrating from an older kernel that exposes GICv2 interrupts as group 1.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-init.c    |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 13 ++++++++++++-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 11 +++++++++--
>  virt/kvm/arm/vgic/vgic-mmio.c    | 38 ++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h    |  6 ++++++
>  5 files changed, 66 insertions(+), 4 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
