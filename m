From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 02/10] KVM: arm/arm64: vgic: Keep track of
 implementation revision
Date: Thu, 19 Jul 2018 18:11:01 +0200
Message-ID: <20180719161101.jitjn46xtlwmzwrd@kamzik.brq.redhat.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
 <1531746387-7033-3-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2A8402AA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 11:58:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zd0BCSQC6IkC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 11:57:59 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 712AF40196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 11:57:59 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1531746387-7033-3-git-send-email-christoffer.dall@arm.com>
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

On Mon, Jul 16, 2018 at 03:06:19PM +0200, Christoffer Dall wrote:
> As we are about to tweak implementation aspects of the VGIC emulation,
> while still preserving some level of backwards compatibility support,
> add a field to keep track of the implementation revision field which is
> reported to the VM and to userspace.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  include/kvm/arm_vgic.h           | 3 +++
>  virt/kvm/arm/vgic/vgic-init.c    | 1 +
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 6 ++++--
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 6 ++++--
>  4 files changed, 12 insertions(+), 4 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
