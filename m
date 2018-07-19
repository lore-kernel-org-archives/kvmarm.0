From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 05/10] KVM: arm/arm64: vgic: Signal IRQs using their
 configured group
Date: Thu, 19 Jul 2018 18:28:40 +0200
Message-ID: <20180719162840.gakzztsbrwdnu5x3@kamzik.brq.redhat.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
 <1531746387-7033-6-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98F7C49F87
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 12:15:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D1fRHUxMjcYj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 12:15:36 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAC5B40196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 12:15:36 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1531746387-7033-6-git-send-email-christoffer.dall@arm.com>
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

On Mon, Jul 16, 2018 at 03:06:22PM +0200, Christoffer Dall wrote:
> Now when we have a group configuration on the struct IRQ, use this state
> when populating the LR and signaling interrupts as either group 0 or
> group 1 to the VM.  Depending on the model of the emulated GIC, and the
> guest's configuration of the VMCR, interrupts may be signaled as IRQs or
> FIQs to the VM.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  include/linux/irqchip/arm-gic.h | 1 +
>  virt/kvm/arm/vgic/vgic-v2.c     | 3 +++
>  virt/kvm/arm/vgic/vgic-v3.c     | 6 +-----
>  3 files changed, 5 insertions(+), 5 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
