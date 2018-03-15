From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v6 25/26] arm64: KVM: Allow mapping of vectors outside of
 the RAM region
Date: Thu, 15 Mar 2018 18:08:15 +0100
Message-ID: <20180315170815.vl53dw5hqr5agmuo@kamzik.brq.redhat.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-26-marc.zyngier@arm.com>
 <20180315155436.vgmd772scihojwz4@kamzik.brq.redhat.com>
 <941a937f-6466-4c8f-6952-d26c3142102d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C225A49F88
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 13:01:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1tcsF9wWggZb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Mar 2018 13:00:43 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 502494047F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 13:00:43 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <941a937f-6466-4c8f-6952-d26c3142102d@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 15, 2018 at 04:17:53PM +0000, Marc Zyngier wrote:
> On 15/03/18 15:54, Andrew Jones wrote:
> > On Wed, Mar 14, 2018 at 04:50:48PM +0000, Marc Zyngier wrote:
> >>  static inline void *kvm_get_hyp_vector(void)
> >>  {
> >>  	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
> >> -	void *vect = kvm_ksym_ref(__kvm_hyp_vector);
> >> +	void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
> >> +	int slot = -1;
> >>  
> >> -	if (data->fn) {
> >> -		vect = __bp_harden_hyp_vecs_start +
> >> -		       data->hyp_vectors_slot * SZ_2K;
> >> +	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn) {
> > 
> > Now that I'm trying to consider heterogeneous systems, I'm wondering why
> > harden BP isn't checked with this_cpu_has_cap() like harden EL2 vectors.
> > I'm also wondering if it's even possible for CPUs to come up without all
> > of them having harden EL2 vectors if the boot CPU has it. Won't
> > verify_local_cpu_errata_workarounds() require it? I'm probably just
> > getting lost in all the capability stuff...
> 
> Checking harden BP on this particular CPU will only tell you if this CPU
> is affected, but won't give you any additional information (i.e. you'd
> still need to check obtain the stuff pointed to by data).
> 
> Checking for *all* CPUs in one go has some advantages: it is a static
> key, which means that unaffected platforms will fly (this is a hot path
> on VHE), and you can check data if you're affected.

Is there a problem with using the static key to check
ARM64_HARDEN_EL2_VECTORS below? (Sorry, I'm still confused why we're not
using the same functions for both.) If we can't use the static key
below, then should we swap the check with !has_vhe() to ensure the
compiler will avoid emitting the this_cpu_has_cap() call on VHE's fast
path?

I also noticed that calling this_cpu_has_cap() puts a constraint on
kvm_get_hyp_vector() that it must never be called without preemption
disabled. It's not, but it's one more thing to think about. If there's
no reason not to use the static key with cpus_have_const_cap() then
maybe we should?

> 
> > 
> >> +		vect = __bp_harden_hyp_vecs_start;
> >> +		slot = data->hyp_vectors_slot;
> >> +	}
> >>  
> >> -		if (!has_vhe())
> >> -			vect = lm_alias(vect);
> >> +	if (this_cpu_has_cap(ARM64_HARDEN_EL2_VECTORS) && !has_vhe()) {
> >> +		vect = __kvm_bp_vect_base;
> >> +		if (slot == -1)
> >> +			slot = __kvm_harden_el2_vector_slot;
> >>  	}

Thanks,
drew
