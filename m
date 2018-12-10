From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 7/8] arm64: KVM: Handle ARM erratum 1165522 in TLB
 invalidation
Date: Mon, 10 Dec 2018 12:50:21 +0100
Message-ID: <20181210115021.GO30263@e113682-lin.lund.arm.com>
References: <20181206173126.139877-1-marc.zyngier@arm.com>
 <20181206173126.139877-8-marc.zyngier@arm.com>
 <20181210101912.GK30263@e113682-lin.lund.arm.com>
 <50e6a07d-868b-db43-fd4e-4b6359a5128e@arm.com>
 <c71d902b-c748-770a-5e6e-f33a204dcb8d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 464D54A341
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 06:50:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pNmcpcI8qNXw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 06:50:25 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3E9F4A33B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 06:50:24 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <c71d902b-c748-770a-5e6e-f33a204dcb8d@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 10, 2018 at 11:15:00AM +0000, James Morse wrote:
> Hi Marc, Christoffer,
> 
> On 10/12/2018 10:46, Marc Zyngier wrote:
> > On 10/12/2018 10:19, Christoffer Dall wrote:
> >> On Thu, Dec 06, 2018 at 05:31:25PM +0000, Marc Zyngier wrote:
> >>> In order to avoid TLB corruption whilst invalidating TLBs on CPUs
> >>> affected by erratum 1165522, we need to prevent S1 page tables
> >>> from being usable.
> >>>
> >>> For this, we set the EL1 S1 MMU on, and also disable the page table
> >>> walker (by setting the TCR_EL1.EPD* bits to 1).
> >>>
> >>> This ensures that once we switch to the EL1/EL0 translation regime,
> >>> speculated AT instructions won't be able to parse the page tables.
> 
> >>> @@ -64,11 +93,18 @@ static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
> >>>  	write_sysreg(0, vttbr_el2);
> >>>  	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
> >>>  	isb();
> >>> -	local_irq_restore(flags);
> >>> +
> >>> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1165522)) {
> >>> +		/* Restore the guest's registers to what they were */
> >>
> >> host's ?
> > 
> > Hum... Yes, silly thinko.
> 
> I thought these were the guests registers because they are EL1 registers and
> this is a VHE-only path.
> 'interrupted guest' was how I read this. This stuff can get called if memory is
> allocated for guest-A while a vcpu is loaded, and reclaims memory from guest-B
> causing an mmu-notifier call for stage2. This is why we have to put guest-A's
> registers back as we weren't pre-empted, and we expect EL1 to be untouched.
> 
> I agree they could belong to no-guest if a vcpu isn't loaded at all... is host
> the term used here?
> 

Ah, you're right.  Host is not the right term either.

I haven't done the call path analysis, so not sure about all the
possible contexts where all this can be called, but if it's really truly
only in guest context, then we don't need to save the values to a
temporary struct at all, but can save them on the vcpu.

We can also just side-step the whole thing and just say "Restore the
registers to what they were".


Thanks,

    Christoffer
