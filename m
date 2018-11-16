From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH 4/4] arm64: KVM: Enable support for :G/:H perf event
 modifiers
Date: Fri, 16 Nov 2018 12:12:52 +0000
Message-ID: <20181116121251.GE19420@e119886-lin.cambridge.arm.com>
References: <1542286549-4501-1-git-send-email-andrew.murray@arm.com>
 <1542286549-4501-5-git-send-email-andrew.murray@arm.com>
 <79000795-971d-22fa-6264-f85f2d528477@arm.com>
 <20181115155742.GA19420@e119886-lin.cambridge.arm.com>
 <29cd37da-5ee9-545e-a456-b8811b0e063a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <29cd37da-5ee9-545e-a456-b8811b0e063a@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 15, 2018 at 05:40:24PM +0000, Suzuki K Poulose wrote:
> 
> 
> On 15/11/2018 15:57, Andrew Murray wrote:
> > On Thu, Nov 15, 2018 at 02:00:39PM +0000, Julien Thierry wrote:
> > > Hi Andrew,
> > > 
> > > On 15/11/18 12:55, Andrew Murray wrote:
> > > > Enable/disable event counters as appropriate when entering and exiting
> > > > the guest to enable support for guest or host only event counting.
> > > > 
> > > > For both VHE and non-VHE we switch the counters between host/guest at
> > > > EL2. EL2 is filtered out by the PMU when we are using the :G modifier.
> > > > 
> > > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > > ---
> > > >    arch/arm64/kvm/hyp/switch.c | 38 ++++++++++++++++++++++++++++++++++++++
> > > >    1 file changed, 38 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > > > index d496ef5..ebf0aac 100644
> > > > --- a/arch/arm64/kvm/hyp/switch.c
> > > > +++ b/arch/arm64/kvm/hyp/switch.c
> > > > @@ -373,6 +373,32 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
> > > >    	return true;
> > > >    }
> > > > +static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> > > > +{
> > > > +	u32 host_only = host_ctxt->events_host_only;
> > > > +	u32 guest_only = host_ctxt->events_guest_only;
> > > > +
> > > > +	if (host_only)
> > > > +		write_sysreg(host_only, pmcntenclr_el0);
> > > > +
> > > > +	if (guest_only)
> > > > +		write_sysreg(guest_only, pmcntenset_el0);
> > > > +
> > > > +	return (host_only || guest_only);
> > > > +}
> > > > +
> > > > +static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
> > > > +{
> > > > +	u32 host_only = host_ctxt->events_host_only;
> > > > +	u32 guest_only = host_ctxt->events_guest_only;
> > > > +
> > > > +	if (guest_only)
> > > > +		write_sysreg(guest_only, pmcntenclr_el0);
> > > > +
> > > > +	if (host_only)
> > > > +		write_sysreg(host_only, pmcntenset_el0);
> > > 
> > > In the perf_event code, there is an ISB after enabling an event. I guess we
> > > don't need it when setting the guest events since I believe the eret to the
> > > guess give us the context synchronization. But don't we need one here when
> > > restoring host only events?
> > 
> > It's not really clear to me why the isb is present in the existing code,
> > this was only recently introduced when adding the chained events support.
> > 
> > Ideally for chained events you'd want to start the overflow counter first
> > (idx) followed by the low counter second (idx-1) as to not miss overflows
> > so an isb inbetween may be helpful. Though the isb is after both enables, this
> > sets a clear line of where event counting starts - but ideally this would be
> > symmetrical with an isb after the disable.
> 
> I think the isb() in the armv8_pmu_enable_event_counter() is
> unnecessary, and might have been a left over from earlier versions
> of the series. Please feel free to remove it.

OK I'll do that.

> 
> > 
> > At present chained counters aren't supported in the guest but in any case
> > we turn them all on/off atomically rather than individually.
> > 
> > I guess we get a trivial gain in accuracy by adding ISB's at some performance
> > cost - I'm not sure I see the benefit - unless I'm missing something?
> 
> But, I think Julien has a valid point here. When we modify the
> pmcnten{set/clr} registers, the PMU could be enabled. (i.e, PMCR_E set).
> 
> So in order to synchronize the changes to the counters, we need an isb()
> in the switch to host case to take immediate effect of the counter
> changes.

For VHE we already do an isb in kvm_arm_vhe_guest_exit (next line of code
to kvm_arm_vhe_guest_exit).

For !VHE as I understand we will eret from EL2 (due to kvm_call_hyp call
completing) and thus also implicitly isb.

If that's correct we don't need to add any isb's right?

Thanks,

Andrew Murray

> 
> Cheers
> Suzuki
