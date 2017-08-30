From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 44/59] KVM: arm/arm64: GICv4: Handle MOVI applied to a
 VLPI
Date: Wed, 30 Aug 2017 22:04:58 +0200
Message-ID: <20170830200458.GK24522@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-45-marc.zyngier@arm.com>
 <20170828181817.GE24649@cbox>
 <954a7441-c91e-5d1b-98b7-2978291c5259@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE0C649C25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 16:02:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SyKvsmUiA7EG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Aug 2017 16:02:47 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1D6440A86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 16:02:47 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id a80so16589306wma.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 13:05:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <954a7441-c91e-5d1b-98b7-2978291c5259@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 30, 2017 at 03:08:01PM +0100, Marc Zyngier wrote:
> On 28/08/17 19:18, Christoffer Dall wrote:
> > On Mon, Jul 31, 2017 at 06:26:22PM +0100, Marc Zyngier wrote:
> >> When the guest issues a MOVI, we need to tell the physical ITS
> >> that we're now targetting a new vcpu. This is done by extracting
> >> the current mapping, updating the target, and reapplying the
> >> mapping. The core ITS code should do the right thing.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  virt/kvm/arm/vgic/vgic-its.c | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> >> index 79bac93d3e7d..aaad577ce328 100644
> >> --- a/virt/kvm/arm/vgic/vgic-its.c
> >> +++ b/virt/kvm/arm/vgic/vgic-its.c
> >> @@ -706,6 +706,19 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
> >>  	ite->irq->target_vcpu = vcpu;
> >>  	spin_unlock(&ite->irq->irq_lock);
> >>  
> >> +	if (ite->irq->hw) {
> >> +		struct its_vlpi_map map;
> >> +		int ret;
> >> +
> >> +		ret = its_get_vlpi(ite->irq->host_irq, &map);
> >> +		if (ret)
> >> +			return ret;
> >> +
> >> +		map.vpe_idx = vcpu->vcpu_id;
> >> +
> >> +		return its_map_vlpi(ite->irq->host_irq, &map);
> > 
> > Since you're not holding the irq_lock across these two calls, would it
> > be possible that the forwarding was removed through some other call path
> > here, and could you end up passing an invalid host_irq to its_map_vlpi?
> I believe we should be OK here, as we hold the ITS mutex during any
> command processing, and both the forward/unforward paths take that same
> mutex.

ok, yes, as long as the only other modifirs are the forward/unforward
paths and they hold the mutex, we should be fine.

> 
> On a slightly different note, it looks like the MOVI code could benefit
> from using vgic_its_resolve_lpi(), which has been introduce earlier in
> this series.

Only problem is you'd need to get a handle to the ite as well to change
the collection pointer.  I suppose you could add another pointer
pointer.

-Christoffer
