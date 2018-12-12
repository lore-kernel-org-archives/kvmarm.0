From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v8 5/5] arm64: KVM: Enable support for :G/:H perf event
 modifiers
Date: Wed, 12 Dec 2018 14:46:06 +0000
Message-ID: <20181212144606.GB48249@e119886-lin.cambridge.arm.com>
References: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
 <1544610573-28446-6-git-send-email-andrew.murray@arm.com>
 <9aaf29ba-b320-fb5e-cbc8-3e6067e3ef26@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <9aaf29ba-b320-fb5e-cbc8-3e6067e3ef26@arm.com>
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

On Wed, Dec 12, 2018 at 10:53:35AM +0000, Suzuki K Poulose wrote:
> 
> 
> On 12/12/2018 10:29, Andrew Murray wrote:
> > Enable/disable event counters as appropriate when entering and exiting
> > the guest to enable support for guest or host only event counting.
> > 
> > For both VHE and non-VHE we switch the counters between host/guest at
> > EL2. EL2 is filtered out by the PMU when we are using the :G modifier.
> > 
> > The PMU may be on when we change which counters are enabled however
> > we avoid adding an isb as we instead rely on existing context
> > synchronisation events: the isb in kvm_arm_vhe_guest_exit for VHE and
> > the eret from the hvc in kvm_call_hyp.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >   arch/arm64/kvm/hyp/switch.c | 52 +++++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 52 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index d496ef5..9732ef7 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -373,6 +373,46 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
> >   	return true;
> >   }
> > +static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	struct kvm_host_data *host;
> > +	struct kvm_pmu_events *pmu;
> > +	u32 clr, set;
> > +
> > +	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> > +	pmu = &host->pmu_events;
> > +
> > +	clr = pmu->events_host & ~pmu->events_guest;
> > +	set = pmu->events_guest & ~pmu->events_host;
> 
> It may make sense to add in a comment explaining why we only set:
> 
> 	events_guest & ~events_host
> 

Yes I'll add a comment, especially as I've just spend 5 minutes trying to
remember why I did this.

Instead of assigning 'pmu->events_guest & ~pmu->events_host' to 'set' we
could have just assigned 'pmu->events_guest'. However consider the scenario
where an event is enabled for both host and guest - this would have resulted
in us always writing the (already set) bit to the system register. Therefore
with my approach we can potentially avoid any system register writes on a 
hypervisor switch when the only events enabled are those for both host and
guest.

Thanks,

Andrew Murray

> Either way:
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
