From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 06/10] KVM: arm/arm64: Update the physical timer
 interrupt level
Date: Wed, 1 Feb 2017 09:04:40 +0100
Message-ID: <20170201080440.GB6226@cbox>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-7-git-send-email-jintack@cs.columbia.edu>
 <86sho199jx.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D8C8408EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 03:04:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S99XJidYKLR9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 03:04:24 -0500 (EST)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com
 [209.85.215.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7FB540783
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 03:04:23 -0500 (EST)
Received: by mail-lf0-f48.google.com with SMTP id n124so223786452lfd.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Feb 2017 00:04:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <86sho199jx.fsf@arm.com>
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
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Jan 29, 2017 at 03:21:06PM +0000, Marc Zyngier wrote:
> On Fri, Jan 27 2017 at 01:04:56 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
> > Now that we maintain the EL1 physical timer register states of VMs,
> > update the physical timer interrupt level along with the virtual one.
> >
> > Note that the emulated EL1 physical timer is not mapped to any hardware
> > timer, so we call a proper vgic function.
> >
> > Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> > ---
> >  virt/kvm/arm/arch_timer.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index 0f6e935..3b6bd50 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -180,6 +180,21 @@ static void kvm_timer_update_mapped_irq(struct kvm_vcpu *vcpu, bool new_level,
> >  	WARN_ON(ret);
> >  }
> >  
> > +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
> > +				 struct arch_timer_context *timer)
> > +{
> > +	int ret;
> > +
> > +	BUG_ON(!vgic_initialized(vcpu->kvm));
> 
> Although I've added my fair share of BUG_ON() in the code base, I've
> since reconsidered my position. If we get in a situation where the vgic
> is not initialized, maybe it would be better to just WARN_ON and return
> early rather than killing the whole box. Thoughts?
> 

Could we help this series along by saying that since this BUG_ON already
exists in the kvm_timer_update_mapped_irq function, then it just
preserves functionality and it's up to someone else (me) to remove the
BUG_ON from both functions later in life?

Thanks,
-Christoffer
