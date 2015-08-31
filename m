From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v3 04/10] VFIO: platform: add
 vfio_platform_set_automasked
Date: Mon, 31 Aug 2015 08:54:34 -0600
Message-ID: <1441032874.20355.126.camel@redhat.com>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
	 <1439212864-12954-5-git-send-email-eric.auger@linaro.org>
	 <1439405794.4023.528.camel@redhat.com> <55D1FFE8.9050104@linaro.org>
	 <1439919864.4023.626.camel@redhat.com> <55E43DFC.8050608@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55E43DFC.8050608@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Antonios Motakis <antonios.motakis@huawei.com>
Cc: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, feng.wu@intel.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 2015-08-31 at 13:43 +0200, Antonios Motakis wrote:
> 
> On 18-Aug-15 19:44, Alex Williamson wrote:
> > On Mon, 2015-08-17 at 17:38 +0200, Eric Auger wrote:
> >> On 08/12/2015 08:56 PM, Alex Williamson wrote:
> >>> On Mon, 2015-08-10 at 15:20 +0200, Eric Auger wrote:
> >>>> This function makes possible to change the automasked mode.
> >>>>
> >>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >>>>
> >>>> ---
> >>>>
> >>>> v1 -> v2:
> >>>> - set forwarded flag
> >>>> ---
> >>>>  drivers/vfio/platform/vfio_platform_irq.c | 19 +++++++++++++++++++
> >>>>  1 file changed, 19 insertions(+)
> >>>>
> >>>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> >>>> index b31b1f0..a285384 100644
> >>>> --- a/drivers/vfio/platform/vfio_platform_irq.c
> >>>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> >>>> @@ -186,6 +186,25 @@ static irqreturn_t vfio_handler(int irq, void *dev_id)
> >>>>  	return ret;
> >>>>  }
> >>>>  
> >>>> +static int vfio_platform_set_automasked(struct vfio_platform_irq *irq,
> >>>> +					   bool automasked)
> >>>> +{
> >>>> +	unsigned long flags;
> >>>> +
> >>>> +	spin_lock_irqsave(&irq->lock, flags);
> >>>> +	if (automasked) {
> >>>> +		irq->forwarded = true;
> >>>> +		irq->flags |= VFIO_IRQ_INFO_AUTOMASKED;
> >>>> +		irq->handler = vfio_automasked_irq_handler;
> >>>> +	} else {
> >>>> +		irq->forwarded = false;
> >>>> +		irq->flags &= ~VFIO_IRQ_INFO_AUTOMASKED;
> >>>> +		irq->handler = vfio_irq_handler;
> >>>> +	}
> >>>> +	spin_unlock_irqrestore(&irq->lock, flags);
> >>>> +	return 0;
> >>>
> >>> In vfio-speak, automasked means level and we're not magically changing
> >>> the IRQ from level to edge, we're simply able to handle level
> >>> differently based on a hardware optimization.  Should the user visible
> >>> flags therefore change based on this?  Aren't we really setting the
> >>> forwarded state rather than the automasked state?
> >>
> >> Well actually this was following the discussion we had a long time ago
> >> about that topic:
> >>
> >> http://lkml.iu.edu/hypermail/linux/kernel/1409.1/03659.html
> >>
> >> I did not really know how to conclude ...
> >>
> >> If it is preferred I can hide this to the userspace, no problem.
> > 
> > I think that was based on the user being involved in enabling forwarding
> > though, now that it's hidden and automatic, it doesn't make much sense
> > to me to toggle any of the interrupt info details based on the state of
> > the forward.  The user always needs to handle the interrupt as level
> > since the bypass can be torn down at any point in time.  We're taking
> > advantage of the in-kernel path to make further optimizations, which
> > seems like they should be transparent to the user.  Thanks,
> 
> I wonder if it makes sense to rename VFIO_IRQ_INFO_AUTOMASKED to
> VFIO_IRQ_INFO_LEVEL_TRIGGERED, and reintroduce VFIO_IRQ_INFO_AUTOMASKED as
> an alias, so compatibility with user space can be maintained? This way
> this semantic misunderstanding could be left behind.

Is there really a misunderstanding here?  I think the change is that the
user was previously involved and updating the flag reinforced that.  Now
the user is not involved and the flag changing is just unexpected noise.
"automasked" is intentionally not "level" because being level triggered
may not be the only reason we'd need to mask an interrupt upon receiving
it.  We could actually have automasked edge triggered interrupts if we
wanted.  We don't do that, so we can equate automasked to level
currently, but technically automasked simply indicates that an unmask is
required to get the next interrupt.  In this case the VM is able to
effectively do the unmask itself.  Thanks,

Alex

