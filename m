From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC PATCH 6/7] arm64: KVM: Handle trappable TLB instructions
Date: Fri, 19 Aug 2016 16:18:47 +0100
Message-ID: <20160819151846.GE9893@arm.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
 <1471344312-26685-7-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471344312-26685-7-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Punit,

On Tue, Aug 16, 2016 at 11:45:11AM +0100, Punit Agrawal wrote:
> The ARMv8 architecture allows trapping of TLB maintenane instructions
> from EL0/EL1 to higher exception levels. On encountering a trappable TLB
> instruction in a guest, an exception is taken to EL2.
> 
> Add functionality to handle emulating the TLB instructions.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>

[...]

> +void __hyp_text
> +__kvm_emulate_tlb_invalidate(struct kvm *kvm, u32 sys_op, u64 regval)
> +{
> +	kvm = kern_hyp_va(kvm);
> +
> +	/*
> +	 * Switch to the guest before performing any TLB operations to
> +	 * target the appropriate VMID
> +	 */
> +	__switch_to_guest_regime(kvm);
> +
> +	/*
> +	 *  TLB maintenance operations broadcast to inner-shareable
> +	 *  domain when HCR_FB is set (default for KVM).
> +	 */
> +	switch (sys_op) {
> +	case TLBIALL:
> +	case TLBIALLIS:
> +	case ITLBIALL:
> +	case DTLBIALL:
> +	case TLBI_VMALLE1:
> +	case TLBI_VMALLE1IS:
> +		__tlbi(vmalle1is);
> +		break;
> +	case TLBIMVA:
> +	case TLBIMVAIS:
> +	case ITLBIMVA:
> +	case DTLBIMVA:
> +	case TLBI_VAE1:
> +	case TLBI_VAE1IS:
> +		__tlbi(vae1is, regval);

I'm pretty nervous about this. Although you've switched in the guest stage-2
page table before the TLB maintenance, we're still running on a host stage-1
and it's not clear to me that the stage-1 context is completely ignored for
the purposes of a stage-1 TLBI executed at EL2.

For example, if TCR_EL1.TBI0 is set in the guest but cleared in the host,
my reading of the architecture is that it will be treated as zero when
we perform this invalidation operation. I worry that we have similar
problems with the granule size, where bits become RES0 in the TLBI VA
ops.

Finally, we should probably be masking out the RES0 bits in the TLBI
ops, just in case some future extension to the architecture defines them
in such a way where they have different meanings when executed at EL2
or EL1.

The easiest thing to do is just TLBI VMALLE1IS for all trapped operations,
but you might want to see how that performs.

Will
