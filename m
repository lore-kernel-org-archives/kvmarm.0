From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 0/6] ARM64: KVM: PMU infrastructure support
Date: Mon, 16 Feb 2015 13:23:09 +0100
Message-ID: <20150216122309.GA23821@cbox>
References: <20141125134239.GI31297@cbox>
 <CAAhSdy32G+-BVQk-=dWjfM1S-cytGavp4qq942m=3y7HUudguw@mail.gmail.com>
 <5476FFAF.2010601@arm.com>
 <CAAhSdy3US4H9DZLDmwawR6D22GUpQ8H5NqrZ8XvYJjhsnPzzRQ@mail.gmail.com>
 <547705BF.5040609@arm.com>
 <CAAhSdy32-MsRORQ9j3YfH4Fn7xCEEFV5O7D43sYbXZCsF4VgaQ@mail.gmail.com>
 <20150111191131.GC3868@cbox>
 <CAAhSdy0FjX0TfkzThkmCz0k=mbnhJiE7tHU=jYUTFpxgDZZXeQ@mail.gmail.com>
 <20150215153337.GB8034@cbox>
 <CAAhSdy1Nj1THsdF6UeM--ihmk8mnDR38Bi9v_ri3Y-MRKD34zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAhSdy1Nj1THsdF6UeM--ihmk8mnDR38Bi9v_ri3Y-MRKD34zg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Anup Patel <anup@brainfault.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, patches <patches@apm.com>, Will Deacon <Will.Deacon@arm.com>, "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 16, 2015 at 05:46:54PM +0530, Anup Patel wrote:
> Hi Christoffer,
> 
> On Sun, Feb 15, 2015 at 9:03 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > Hi Anup,
> >
> > On Mon, Jan 12, 2015 at 09:49:13AM +0530, Anup Patel wrote:
> >> On Mon, Jan 12, 2015 at 12:41 AM, Christoffer Dall
> >> <christoffer.dall@linaro.org> wrote:
> >> > On Tue, Dec 30, 2014 at 11:19:13AM +0530, Anup Patel wrote:
> >> >> (dropping previous conversation for easy reading)
> >> >>
> >> >> Hi Marc/Christoffer,
> >> >>
> >> >> I tried implementing PMU context-switch via C code
> >> >> in EL1 mode and in atomic context with irqs disabled.
> >> >> The context switch itself works perfectly fine but
> >> >> irq forwarding is not clean for PMU irq.
> >> >>
> >> >> I found another issue that is GIC only samples irq
> >> >> lines if they are enabled. This means for using
> >> >> irq forwarding we will need to ensure that host PMU
> >> >> irq is enabled.  The arch_timer code does this by
> >> >> doing request_irq() for host virtual timer interrupt.
> >> >> For PMU, we can either enable/disable host PMU
> >> >> irq in context switch or we need to do have shared
> >> >> irq handler between kvm pmu and host kernel pmu.
> >> >
> >> > could we simply require the host PMU driver to request the IRQ and have
> >> > the driver inject the corresponding IRQ to the VM via a mechanism
> >> > similar to VFIO using an eventfd and irqfds etc.?
> >>
> >> Currently, the host PMU driver does request_irq() only when
> >> there is some event to be monitored. This means host will do
> >> request_irq() only when we run perf application on host
> >> user space.
> >>
> >> Initially, I though that we could simply pass IRQF_SHARED
> >> for request_irq() in host PMU driver and do the same for
> >> reqest_irq() in KVM PMU code but the PMU irq can be
> >> SPI or PPI. If the PMU irq is SPI then IRQF_SHARED
> >> flag would fine but if its PPI then we have no way to
> >> set IRQF_SHARED flag because request_percpu_irq()
> >> does not have irq flags parameter.
> >>
> >> >
> >> > (I haven't quite thought through if there's a way for the host PMU
> >> > driver to distinguish between an IRQ for itself and one for the guest,
> >> > though).
> >> >
> >> > It does feel like we will need some sort of communication/coordination
> >> > between the host PMU driver and KVM...
> >> >
> >> >>
> >> >> I have rethinked about our discussion so far. I
> >> >> understand that we need KVM PMU virtualization
> >> >> to meet following criteria:
> >> >> 1. No modification in host PMU driver
> >> >
> >> > is this really a strict requirement?  one of the advantages of KVM
> >> > should be that the rest of the kernel should be supportive of KVM.
> >>
> >> I guess so because host PMU driver should not do things
> >> differently for host and guest. I think this the reason why
> >> we discarded the mask/unmask PMU irq approach which
> >> I had implemented in RFC v1.
> >>
> >> >
> >> >> 2. No modification in guest PMU driver
> >> >> 3. No mask/unmask dance for sharing host PMU irq
> >> >> 4. Clean way to avoid infinite VM exits due to
> >> >> PMU interrupt
> >> >>
> >> >> I have discovered new approach which is as follows:
> >> >> 1. Context switch PMU in atomic context (i.e. local_irq_disable())
> >> >> 2. Ensure that host PMU irq is disabled when entering guest
> >> >> mode and re-enable host PMU irq when exiting guest mode if
> >> >> it was enabled previously.
> >> >
> >> > How does this look like software-engineering wise?  Would you be looking
> >> > up the IRQ number from the DT in the KVM code again?  How does KVM then
> >> > synchronize with the host PMU driver so they're not both requesting the
> >> > same IRQ at the same time?
> >>
> >> We only lookup host PMU irq numbers from DT at HYP init time.
> >>
> >> During context switch we know the host PMU irq number for
> >> current host CPU so we can get state of host PMU irq in
> >> context switch code.
> >>
> >> If we go by the shard irq handler approach then both KVM
> >> and host PMU driver will do request_irq() on same host
> >> PMU irq. In other words, there is no virtual PMU irq provided
> >> by HW for guest.
> >>
> >
> > Sorry for the *really* long delay in this response.
> >
> > We had a chat about this subject with Will Deacon and Marc Zyngier
> > during connect, and basically we came to think of a number of problems
> > with the current approach:
> >
> > 1. As you pointed out, there is a need for a shared IRQ handler, and
> >    there is no immediately nice way to implement this without a more
> >    sophisticated perf/kvm interface, probably comprising eventfds or
> >    something similar.
> >
> > 2. Hijacking the counters for the VM without perf knowing about it
> >    basically makes it impossible to do system-wide event counting, an
> >    important use case for a virtualization host.
> >
> > So the approach we will be taking now would be to:
> >
> > First, implement a strictly trap-and-emulate in software approach.  This
> > would allow any software relying on access to performance counters to
> > work, although potentially with slightly unprecise values.  This is the
> > approach taken by x86 and would be significantly simpler to support on
> > systems like big.LITTLE as well.
> 
> Actually, trap-and-emulate would also help avoid additions to the
> KVM world switch.
> 
> >
> > Second, if there are values obtained from within the guest that are so
> > skewed by the trap-and-emulate approach that we need to give the guest
> > access to counters, we should try to share the hardware by partitioning
> > the physical counters, but again, we need to coordinate with the host
> > perf system for this.  We would only be pursuing this approach if
> > absolutely necessary.
> 
> Yes, with trap-and-emulate we cannot accurately emulate all types
> of hw counters (particularly cache misses and similar events).
> 
> >
> > Apologies for the change in direction on this.
> >
> > What are your thoughts?  Do you still have time/interest to work
> > on any of this?
> 
> Its a drastic change in direction.
> 
> Currently, I have taken up some different work (not related to KVM)
> so for next few months I wont be able spend time on this.
> 
> Its better if Linaro takes this work to avoid any further delays.
> 
ok, will do, thanks for being responsive and putting in the efforts so
far!

Best,
-Christoffer
