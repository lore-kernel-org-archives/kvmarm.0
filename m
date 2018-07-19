From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 04/10] KVM: arm/arm64: vgic: Add group field to struct
 irq
Date: Thu, 19 Jul 2018 18:16:59 +0200
Message-ID: <20180719161659.zd6cc3xyqxp2rwju@kamzik.brq.redhat.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
 <1531746387-7033-5-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4EF49F87
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 12:03:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4mvwwCSlqJCG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 12:03:56 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3053140196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 12:03:56 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1531746387-7033-5-git-send-email-christoffer.dall@arm.com>
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

On Mon, Jul 16, 2018 at 03:06:21PM +0200, Christoffer Dall wrote:
> In preparation for proper group 0 and group 1 support in the vgic, we
> add a field in the struct irq to store the group of all interrupts.
> 
> We initialize the group to group 0 when emulating GICv2 and to group 1
> when emulating GICv3, just like we treat them today.  LPIs are always
> group 1.  We also continue to ignore writes from the guest, preserving
> existing functionality, for now.
> 
> Finally, we also add this field to the vgic debug logic to show the
> group for all interrupts.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  include/kvm/arm_vgic.h         |  1 +
>  virt/kvm/arm/vgic/vgic-debug.c |  8 +++++---
>  virt/kvm/arm/vgic/vgic-init.c  | 19 +++++++++++++++++--
>  virt/kvm/arm/vgic/vgic-its.c   |  1 +
>  4 files changed, 24 insertions(+), 5 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
