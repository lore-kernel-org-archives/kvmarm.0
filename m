From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 09/10] KVM: arm/arm64: vgic: Let userspace opt-in to
 writable v2 IGROUPR
Date: Thu, 19 Jul 2018 20:17:21 +0200
Message-ID: <20180719181721.k4q2gmzr6wuy6nay@kamzik.brq.redhat.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
 <1531746387-7033-10-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 290C140196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 14:04:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9rO6lGJVX83i for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 14:04:17 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7500640192
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 14:04:17 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1531746387-7033-10-git-send-email-christoffer.dall@arm.com>
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

On Mon, Jul 16, 2018 at 03:06:26PM +0200, Christoffer Dall wrote:
> Simply letting IGROUPR be writable from userspace would break
> migration from old kernels to newer kernels, because old kernels
> incorrectly report interrupt groups as group 1.  This would not be a big
> problem if userspace wrote GICD_IIDR as read from the kernel, because we
> could detect the incompatibility and return an error to userspace.
> Unfortunately, this is not the case with current userspace
> implementations and simply letting IGROUPR be writable from userspace for
> an emulated GICv2 silently breaks migration and causes the destination
> VM to no longer run after migration.
> 
> We now encourage userspace to write the read and expected value of
> GICD_IIDR as the first part of a GIC register restore, and if we observe
> a write to GICD_IIDR we know that userspace has been updated and has had
> a chance to cope with older kernels (VGICv2 IIDR.Revision == 0)
> incorrectly reporting interrupts as group 1, and therefore we now allow
> groups to be user writable.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  include/kvm/arm_vgic.h           |  3 +++
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 16 +++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
