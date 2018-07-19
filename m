From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 06/10] KVM: arm/arm64: vgic: Permit uaccess writes to
 return errors
Date: Thu, 19 Jul 2018 18:31:55 +0200
Message-ID: <20180719163155.atqejnaf63njizyj@kamzik.brq.redhat.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
 <1531746387-7033-7-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3FBA49E14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 12:18:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qqgSwC-JnuH3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 12:18:53 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C1D140196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 12:18:53 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1531746387-7033-7-git-send-email-christoffer.dall@arm.com>
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

On Mon, Jul 16, 2018 at 03:06:23PM +0200, Christoffer Dall wrote:
> Currently we do not allow any vgic mmio write operations to fail, which
> makes sense from mmio traps from the guest.  However, we should be able
> to report failures to userspace, if userspace writes incompatible values
> to read-only registers.  Rework the internal interface to allow errors
> to be returned on the write side for userspace writes.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 12 +++++++-----
>  virt/kvm/arm/vgic/vgic-mmio.c    | 18 +++++++++++++-----
>  virt/kvm/arm/vgic/vgic-mmio.h    | 19 +++++++++++--------
>  3 files changed, 31 insertions(+), 18 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
