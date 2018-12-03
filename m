From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v3 2/4] arm64: KVM: add accessors to track guest/host
 only counters
Date: Mon, 3 Dec 2018 15:05:52 +0000
Message-ID: <20181203150551.GC16311@e119886-lin.cambridge.arm.com>
References: <1542885950-23816-3-git-send-email-andrew.murray@arm.com>
 <20181203143114.GA26831@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 249104A2AC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 10:05:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6TVGT6aAJ1Cb for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 10:05:55 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A95924A200
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 10:05:55 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203143114.GA26831@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 03, 2018 at 02:31:14PM +0000, Will Deacon wrote:
> On Thu, Nov 22, 2018 at 11:25:48AM +0000, Andrew Murray wrote:
> > In order to effeciently enable/disable guest/host only perf counters
> > at guest entry/exit we add bitfields to kvm_cpu_context for guest and
> > host only events as well as accessors for updating them.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 1550192..4a828eb 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -203,6 +203,8 @@ struct kvm_cpu_context {
> >  	};
> >  
> >  	struct kvm_vcpu *__hyp_running_vcpu;
> > +	u32 events_host_only;
> > +	u32 events_guest_only;
> >  };
> >  
> >  typedef struct kvm_cpu_context kvm_cpu_context_t;
> > @@ -472,6 +474,24 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> >  {
> >  	return kvm_arch_vcpu_run_map_fp(vcpu);
> >  }
> > +static inline void kvm_clr_set_host_pmu_events(u32 clr, u32 set)
> > +{
> > +	kvm_cpu_context_t *ctx = this_cpu_ptr(&kvm_host_cpu_state);
> > +
> > +	ctx->events_host_only &= ~clr;
> > +	ctx->events_host_only |= set;
> > +}
> 
> Do you actually need this clr/set function, or can you just use the
> facilities provided by bitfield.h at the callsites?

This modifies events_{host|guest}_only which is conditionally defined
(CONFIG_KVM) yet used by arch/arm64/kernel/perf_events which is also
conditionally defined (CONFIG_HW_PERF_EVENTS). By moving this away
from the callsite we avoid a load of horrible #ifdef's and allow this
function to become a nop when KVM isn't enabled.

Is there value in updating this function to use set_bit/clear_bit
functions in bitops/atomic.h ?

Andrew Murray

> 
> Will
