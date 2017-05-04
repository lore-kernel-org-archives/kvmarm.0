From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 21/22] KVM: arm64: vgic-its: Fix pending table sync
Date: Thu, 4 May 2017 09:32:15 +0200
Message-ID: <20170504073215.GB5923@cbox>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-22-git-send-email-eric.auger@redhat.com>
 <20170430211033.GD1499@lvm>
 <03432fc8-5e39-2f50-1e36-1c4b2f9be773@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AEDE40AF5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 03:29:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UcWlkNfn--gw for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 03:29:13 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2850240992
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 03:29:12 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id w64so9625583wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 May 2017 00:32:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <03432fc8-5e39-2f50-1e36-1c4b2f9be773@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 12:20:13AM +0200, Auger Eric wrote:
> Hi,
> 
> On 30/04/2017 23:10, Christoffer Dall wrote:
> > On Fri, Apr 14, 2017 at 12:15:33PM +0200, Eric Auger wrote:
> >> In its_sync_lpi_pending_table() we currently ignore the
> >> target_vcpu of the LPIs. We sync the pending bit found in
> >> the vcpu pending table even if the LPI is not targeting it.
> >>
> >> Also in vgic_its_cmd_handle_invall() we are supposed to
> >> read the config table data for the LPIs associated to the
> >> collection ID. At the moment we refresh all LPI config
> >> information.
> >>
> >> This patch passes a vpcu to vgic_copy_lpi_list() so that
> >> this latter returns a snapshot of the LPIs targeting this
> >> CPU and only those.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> ---
> >>  virt/kvm/arm/vgic/vgic-its.c | 24 ++++++++++++------------
> >>  1 file changed, 12 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> >> index 86dfc6c..be848be 100644
> >> --- a/virt/kvm/arm/vgic/vgic-its.c
> >> +++ b/virt/kvm/arm/vgic/vgic-its.c
> >> @@ -252,13 +252,13 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> >>  }
> >>  
> >>  /*
> >> - * Create a snapshot of the current LPI list, so that we can enumerate all
> >> - * LPIs without holding any lock.
> >> - * Returns the array length and puts the kmalloc'ed array into intid_ptr.
> >> + * Create a snapshot of the current LPIs targeting @vcpu, so that we can
> >> + * enumerate those LPIs without holding any lock.
> >> + * Returns their number and puts the kmalloc'ed array into intid_ptr.
> >>   */
> >> -static int vgic_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
> >> +static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
> >>  {
> >> -	struct vgic_dist *dist = &kvm->arch.vgic;
> >> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> >>  	struct vgic_irq *irq;
> >>  	u32 *intids;
> >>  	int irq_count = dist->lpi_list_count, i = 0;
> >> @@ -277,14 +277,14 @@ static int vgic_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
> >>  	spin_lock(&dist->lpi_list_lock);
> >>  	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
> >>  		/* We don't need to "get" the IRQ, as we hold the list lock. */
> >> -		intids[i] = irq->intid;
> >> -		if (++i == irq_count)
> >> -			break;
> >> +		if (irq->target_vcpu != vcpu)
> >> +			continue;
> >> +		intids[i++] = irq->intid;
> > 
> > were we checking the ++i == irq_count condition for no good reason
> > before since we can just drop it now?
> I didn't get why we had that check.
> 

ok, Andre is cc'ed so unless he complains let's just get rid of it.

Thanks,
-Christoffer
