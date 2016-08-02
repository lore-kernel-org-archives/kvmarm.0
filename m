From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: ITS: return 1 on successful MSI injection
Date: Tue, 2 Aug 2016 15:57:40 +0200
Message-ID: <20160802135740.GI32244@cbox>
References: <20160802111058.31496-1-andre.przywara@arm.com>
 <20160802122309.GH32244@cbox> <57A091FC.9070607@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B426E49B1A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2016 09:49:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3L62R4V1GfN3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Aug 2016 09:49:15 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CB8C411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2016 09:49:14 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id f65so410358669wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Aug 2016 06:56:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57A091FC.9070607@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 02, 2016 at 01:28:44PM +0100, Marc Zyngier wrote:
> On 02/08/16 13:23, Christoffer Dall wrote:
> > On Tue, Aug 02, 2016 at 12:10:58PM +0100, Andre Przywara wrote:
> >> According to the KVM API documentation a successful MSI injection
> >> should return a value > 0 on success.
> >> Since we pass the return value of vgic_its_inject_msi() directly on
> >> to upper layers and userland, we need to use the same semantics here.
> >> Briefly tested with QEMU and kvmtool on GICv3 hardware and the model.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >> Applies on top of next-20160728. Let me know if I should use a
> >> different base.
> >>
> >> Cheers,
> >> Andre.
> >>
> >>  virt/kvm/arm/vgic/vgic-its.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> >> index 07411cf..3268250 100644
> >> --- a/virt/kvm/arm/vgic/vgic-its.c
> >> +++ b/virt/kvm/arm/vgic/vgic-its.c
> >> @@ -468,6 +468,7 @@ static void vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
> >>   * Queries the KVM IO bus framework to get the ITS pointer from the given
> >>   * doorbell address.
> >>   * We then call vgic_its_trigger_msi() with the decoded data.
> >> + * According to the KVM_SIGNAL_MSI API description returns > 0 on success.
> >>   */
> >>  int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
> >>  {
> >> @@ -493,7 +494,7 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
> >>  	vgic_its_trigger_msi(kvm, iodev->its, msi->devid, msi->data);
> >>  	mutex_unlock(&iodev->its->its_lock);
> >>  
> >> -	return 0;
> >> +	return 1;
> >>  }
> >>  
> >>  /* Requires the its_lock to be held. */
> > 
> > Do we have a clear understanding of what 'guest blocked the MSI'
> > constitutes in the ARM world?
> 
> I would define it as "the guest has not configured the ITS so that the
> corresponding LPI could be successfully delivered". Which is any of the
> conditions where the interrupt cannot make it into the pending table,
> and is dropped on the floor.
> 
sounds good to me.

-Christoffer
