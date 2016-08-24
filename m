From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [RFC PATCH 6/7] arm64: KVM: Handle trappable TLB instructions
Date: Wed, 24 Aug 2016 11:40:39 +0100
Message-ID: <87a8g2sb4o.fsf@e105922-lin.cambridge.arm.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
 <1471344312-26685-7-git-send-email-punit.agrawal@arm.com>
 <20160819151846.GE9893@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3ABC412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 06:32:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AF3S+zERKKRT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2016 06:32:58 -0400 (EDT)
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com
 [217.140.96.140])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7413940C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 06:32:57 -0400 (EDT)
In-Reply-To: <20160819151846.GE9893@arm.com> (Will Deacon's message of "Fri,
 19 Aug 2016 16:18:47 +0100")
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Will Deacon <will.deacon@arm.com> writes:

> Hi Punit,
>
> On Tue, Aug 16, 2016 at 11:45:11AM +0100, Punit Agrawal wrote:
>> The ARMv8 architecture allows trapping of TLB maintenane instructions
>> from EL0/EL1 to higher exception levels. On encountering a trappable TLB
>> instruction in a guest, an exception is taken to EL2.
>> 
>> Add functionality to handle emulating the TLB instructions.
>> 
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>
> [...]
>
>> +void __hyp_text
>> +__kvm_emulate_tlb_invalidate(struct kvm *kvm, u32 sys_op, u64 regval)
>> +{
>> +	kvm = kern_hyp_va(kvm);
>> +
>> +	/*
>> +	 * Switch to the guest before performing any TLB operations to
>> +	 * target the appropriate VMID
>> +	 */
>> +	__switch_to_guest_regime(kvm);
>> +
>> +	/*
>> +	 *  TLB maintenance operations broadcast to inner-shareable
>> +	 *  domain when HCR_FB is set (default for KVM).
>> +	 */
>> +	switch (sys_op) {
>> +	case TLBIALL:
>> +	case TLBIALLIS:
>> +	case ITLBIALL:
>> +	case DTLBIALL:
>> +	case TLBI_VMALLE1:
>> +	case TLBI_VMALLE1IS:
>> +		__tlbi(vmalle1is);
>> +		break;
>> +	case TLBIMVA:
>> +	case TLBIMVAIS:
>> +	case ITLBIMVA:
>> +	case DTLBIMVA:
>> +	case TLBI_VAE1:
>> +	case TLBI_VAE1IS:
>> +		__tlbi(vae1is, regval);
>
> I'm pretty nervous about this. Although you've switched in the guest stage-2
> page table before the TLB maintenance, we're still running on a host stage-1
> and it's not clear to me that the stage-1 context is completely ignored for
> the purposes of a stage-1 TLBI executed at EL2.
>
> For example, if TCR_EL1.TBI0 is set in the guest but cleared in the host,
> my reading of the architecture is that it will be treated as zero when
> we perform this invalidation operation. I worry that we have similar
> problems with the granule size, where bits become RES0 in the TLBI VA
> ops.

Some control bits seem to be explicitly called out to not affect TLB
maintenance operations[0] but I hadn't considered the ones you highlight.

[0] ARMv8 ARM DDI 0487A.j D4.7, Pg D4-1814

>
> Finally, we should probably be masking out the RES0 bits in the TLBI
> ops, just in case some future extension to the architecture defines them
> in such a way where they have different meanings when executed at EL2
> or EL1.

Although, the RES0 bits for TLBI VA ops are currently ignored, I agree
that masking them out based on granule size protects against future
incompatible changes.

>
> The easiest thing to do is just TLBI VMALLE1IS for all trapped operations,
> but you might want to see how that performs.

That sounds reasonable for correctness. But I suspect we'll have to do
more to claw back some performance. Let me run a few tests and come back
on this.

Thanks for having a look.

Punit

>
> Will
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
