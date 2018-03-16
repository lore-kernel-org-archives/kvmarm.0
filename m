From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v6 25/26] arm64: KVM: Allow mapping of vectors outside of
 the RAM region
Date: Fri, 16 Mar 2018 13:33:05 +0100
Message-ID: <20180316123305.rw2owlb5zsdjmgbd@kamzik.brq.redhat.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-26-marc.zyngier@arm.com>
 <20180315155436.vgmd772scihojwz4@kamzik.brq.redhat.com>
 <941a937f-6466-4c8f-6952-d26c3142102d@arm.com>
 <20180315170815.vl53dw5hqr5agmuo@kamzik.brq.redhat.com>
 <c2da044e-f2b4-6981-33b4-7362f3182f04@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <c2da044e-f2b4-6981-33b4-7362f3182f04@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 15, 2018 at 06:47:22PM +0000, Marc Zyngier wrote:
> On 15/03/18 17:08, Andrew Jones wrote:
> > On Thu, Mar 15, 2018 at 04:17:53PM +0000, Marc Zyngier wrote:
> >> On 15/03/18 15:54, Andrew Jones wrote:
> >>> On Wed, Mar 14, 2018 at 04:50:48PM +0000, Marc Zyngier wrote:
> >>>>  static inline void *kvm_get_hyp_vector(void)
> >>>>  {
> >>>>  	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
> >>>> -	void *vect = kvm_ksym_ref(__kvm_hyp_vector);
> >>>> +	void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
> >>>> +	int slot = -1;
> >>>>  
> >>>> -	if (data->fn) {
> >>>> -		vect = __bp_harden_hyp_vecs_start +
> >>>> -		       data->hyp_vectors_slot * SZ_2K;
> >>>> +	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn) {
> >>>
> >>> Now that I'm trying to consider heterogeneous systems, I'm wondering why
> >>> harden BP isn't checked with this_cpu_has_cap() like harden EL2 vectors.
> >>> I'm also wondering if it's even possible for CPUs to come up without all
> >>> of them having harden EL2 vectors if the boot CPU has it. Won't
> >>> verify_local_cpu_errata_workarounds() require it? I'm probably just
> >>> getting lost in all the capability stuff...
> >>
> >> Checking harden BP on this particular CPU will only tell you if this CPU
> >> is affected, but won't give you any additional information (i.e. you'd
> >> still need to check obtain the stuff pointed to by data).
> >>
> >> Checking for *all* CPUs in one go has some advantages: it is a static
> >> key, which means that unaffected platforms will fly (this is a hot path
> >> on VHE), and you can check data if you're affected.
> > 
> > Is there a problem with using the static key to check
> > ARM64_HARDEN_EL2_VECTORS below? (Sorry, I'm still confused why we're not
> > using the same functions for both.) 
> 
> Consider the following case: heterogeneous system with CPU0 that has
> HBP, and CPU1 that has HEL. CPU0 is using its own vector slot, and CPU1
> should be using an extra one (it doesn't have a dedicated slot).
> 
> When CPU0 claims its vectors, it will get the "normal" version of the
> mapping. And then, if we're using cpus_have_cap, we turn that into an
> out-of-line mapping. That's not completely wrong (the system still runs
> fine), but that's not the expected behaviour. If we restrict the second
> phase to this_cpu_has_cap(), we get the expected CPU0 using the normal
> mapping, and CPU1 does the exact opposite (which we also want).

Thanks for the additional explanation. I've finally got my head wrapped
around this and it looks good to me. And, I see now that my comment about
verify_local_cpu_errata_workarounds() only applies to CPUs plugged after
boot. The comment in check_local_cpu_capabilities() states clearly each
CPU present at boot gets a chance to update cpu_hwcaps - which also
clarifies why kvm_map_vectors() *must* use cpus_have_const_cap(), else
risk the el2 vector slot not being allocated.

Thanks,
drew
