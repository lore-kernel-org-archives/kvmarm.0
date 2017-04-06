From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 0/5] Support userspace irqchip with arch timers
Date: Thu, 6 Apr 2017 21:13:20 +0200
Message-ID: <20170406191320.GI27123@cbox>
References: <20170405092815.22503-1-cdall@linaro.org>
 <a41d1e18-dea7-5cfa-5783-09f02d9ce194@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a41d1e18-dea7-5cfa-5783-09f02d9ce194@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Alexander Graf <agraf@suse.de>, Peter Maydell <peter.maydell@linaro.org>, Pekka Enberg <penberg@iki.fi>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 06, 2017 at 06:31:59PM +0100, Marc Zyngier wrote:
> On 05/04/17 10:28, Christoffer Dall wrote:
> > This series is the second version of the rework of the patches to support
> > architected timers with a userspace irqchip sent by Alexander Graf [1].
> > 
> > We first cleanup some of the timer code to make it easier to understand
> > what is being done in the later patches, and then define the ABI,
> > implement timers support, implement PMU support, and finally advertise
> > the features.
> > 
> > These patches are based on the recent work from Jintack to support the
> > physical timer in addition to the virtual timer.  This series including
> > its dependencies can be found here:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git irqs-to-user-v3
> > 
> > I tested this using Alex's QEMU patch with his fixes for SMP applied.  This
> > seems to be rock-solid.  The temporary-not-for-upstream-but-for-testing patch
> > can be found here (force-pushed and rebased since v2):
> > 
> > https://git.linaro.org/people/christoffer.dall/qemu-arm.git no-kvm-irqchip
> > 
> > I also tested it on 32-bit and it looks good there as well.
> > 
> > Changes since v2:
> >  - Actually push the right content to the kernel branch, sorry.
> >  - Rebased on kvmarm/queue as of this morning (v4.11-rc1+ stuff)
> >  - Changed IOCTL numbers as needed
> > 
> > Changes since v1:
> >  - Rework the ABI to support devices in general as opposed to just
> >    timers
> >  - Support the PMU in addition to timers
> >  - Also support the physical timer (rebased on Jintack's work)
> >  - Updated some comments where I noticed things were out of date.
> > 
> > Several changes have been made compared to v7 of the original single
> > patch, including:
> >  - Rewording ABI documentation to be more in line with the ARM
> >    architecture
> >  - Add an explicit check for needing to notify userspace of a level
> >    change instead of propagating the value
> >  - Changes to commenting throughout to more accurately describe the
> >    architecture concepts we try to maintain
> >  - Reword of functions, for example from sync to update when the date
> >    only flows one direction
> > 
> > [1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2016-September/021867.html
> > [2]: git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> 
> The couple of nits I mentioned notwithstanding, for the whole series:
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Thanks.   I have applied this to kvmarm/queue.

-Christoffer
