From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v4 4/4] arm64: KVM: Enable support for :G/:H perf event
 modifiers
Date: Wed, 5 Dec 2018 14:11:08 +0000
Message-ID: <20181205141108.GB26114@e119886-lin.cambridge.arm.com>
References: <1543935500-23207-1-git-send-email-andrew.murray@arm.com>
 <1543935500-23207-5-git-send-email-andrew.murray@arm.com>
 <4ddb1abb-441d-b504-790d-f2bc45c52db9@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F91D4A327
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Dec 2018 09:11:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TeyQQKaLXWxB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Dec 2018 09:11:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FB864A1E5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Dec 2018 09:11:11 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <4ddb1abb-441d-b504-790d-f2bc45c52db9@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 04, 2018 at 04:16:01PM +0000, Julien Thierry wrote:
> Hi Andrew,
> 
> On 04/12/18 14:58, Andrew Murray wrote:
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
> >  arch/arm64/kvm/hyp/switch.c | 41 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index d496ef5..5e03921 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -373,6 +373,35 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
> >  	return true;
> >  }
> >  
> > +static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	u32 host = host_ctxt->events_host;
> > +	u32 guest = host_ctxt->events_guest;
> > +
> > +	if (host == guest)
> > +		return false;
> > +
> > +	if (host)
> > +		write_sysreg(host, pmcntenclr_el0);
> 
> Nit:
> Instead of clearing host counters we could clear non-guest counters:
> 
> 	u32 clear_events = host_ctxt->events_hosts & ~guest;
> 		
> 	if (clear_events)
> 		write_sysreg(clear_events, pmcntenclr_el0);
> 
> Don't know if it makes a lot of difference.

In the case where an event is enabled for both host and guest, your
suggested change prevents us from unnecessarily clearing and then setting
the same bit. Thus is may prevent a call to write_sysreg.

> 
> > +
> > +	if (guest)
> > +		write_sysreg(guest, pmcntenset_el0);
> > +
> > +	return (host || guest);
> 
> We know this is true. If both (host == 0 && guest == 0) then (host ==
> guest) meaning we returned false.

Doh.

> 
> 
> > +}
> > +
> > +static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	u32 host = host_ctxt->events_host;
> > +	u32 guest = host_ctxt->events_guest;
> > +
> > +	if (guest)
> > +		write_sysreg(guest, pmcntenclr_el0);
> 
> Nit:
> Same as above, we could just clear the counters that are exclusive to
> the guest.

Thanks,

Andrew Murray

> 
> Cheers,
> 
> -- 
> Julien Thierry
