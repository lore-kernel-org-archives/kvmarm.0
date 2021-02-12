Return-Path: <SRS0=FDJp=HO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14931C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 12 Feb 2021 17:12:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 831AB64E57
	for <kvmarm@archiver.kernel.org>; Fri, 12 Feb 2021 17:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 831AB64E57
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03A0B4B390;
	Fri, 12 Feb 2021 12:12:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NIW+7-O2ifaB; Fri, 12 Feb 2021 12:12:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB5714B3F9;
	Fri, 12 Feb 2021 12:12:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 051CB4B3AE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2021 12:12:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id im9f6r8WpsQB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Feb 2021 12:12:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DEAC4B390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Feb 2021 12:12:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0D751063;
 Fri, 12 Feb 2021 09:12:08 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B8C23F73B;
 Fri, 12 Feb 2021 09:12:07 -0800 (PST)
Subject: Re: [PATCH] KVM: arm64: Handle CMOs on Read Only memslots
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20210211142738.1478292-1-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4bfd380b-a654-c104-f424-a258bb142e34@arm.com>
Date: Fri, 12 Feb 2021 17:12:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211142738.1478292-1-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

I've been trying to get my head around what the architecture says about CMOs, so
please bare with me if I misunderstood some things.

On 2/11/21 2:27 PM, Marc Zyngier wrote:
> It appears that when a guest traps into KVM because it is
> performing a CMO on a Read Only memslot, our handling of
> this operation is "slightly suboptimal", as we treat it as
> an MMIO access without a valid syndrome.
>
> The chances that userspace is adequately equiped to deal
> with such an exception being slim, it would be better to
> handle it in the kernel.
>
> What we need to provide is roughly as follows:
>
> (a) if a CMO hits writeable memory, handle it as a normal memory acess
> (b) if a CMO hits non-memory, skip it
> (c) if a CMO hits R/O memory, that's where things become fun:
>   (1) if the CMO is DC IVAC, the architecture says this should result
>       in a permission fault
>   (2) if the CMO is DC CIVAC, it should work similarly to (a)

When you say it should work similarly to (a), you mean it should be handled as a
normal memory access, without the "CMO hits writeable memory" part, right?

>
> We already perform (a) and (b) correctly, but (c) is a total mess.
> Hence we need to distinguish between IVAC (c.1) and CIVAC (c.2).
>
> One way to do it is to treat CMOs generating a translation fault as
> a *read*, even when they are on a RW memslot. This allows us to
> further triage things:
>
> If they come back with a permission fault, that is because this is
> a DC IVAC instruction:
> - inside a RW memslot: no problem, treat it as a write (a)(c.2)
> - inside a RO memslot: inject a data abort in the guest (c.1)
>
> The only drawback is that DC IVAC on a yet unmapped page faults
> twice: one for the initial translation fault that result in a RO
> mapping, and once for the permission fault. I think we can live with
> that.

I'm trying to make sure I understand what the problem is.

gfn_to_pfn_prot() returnsKVM_HVA_ERR_RO_BAD if the write is to a RO memslot.
KVM_HVA_ERR_RO_BAD is PAGE_OFFSET + PAGE_SIZE, which means that
is_error_noslot_pfn() return true. In that case we exit to userspace with -EFAULT
for DC IVAC and DC CIVAC. But what we should be doing is this:

- For DC IVAC, inject a dabt with ISS = 0x10, meaning an external abort (that's
what kvm_inject_dabt_does()).

- For DC CIVAC, exit to userspace with -EFAULT.

Did I get that right?

Thanks,

Alex

>
> Reported-by: Jianyong Wu <jianyong.wu@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>
> Notes:
>     I have taken the option to inject an abort in the guest when
>     it issues a DC IVAC on a R/O memslot, but another option would
>     be to just perform the invalidation ourselves as a DC CIAVAC.
>     
>     This would have the advantage of being consistent with what we
>     do for emulated MMIO.
>
>  arch/arm64/kvm/mmu.c | 53 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 41 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7d2257cc5438..c7f4388bea45 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -760,7 +760,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	struct kvm_pgtable *pgt;
>  
>  	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
> -	write_fault = kvm_is_write_fault(vcpu);
> +	/*
> +	 * Treat translation faults on CMOs as read faults. Should
> +	 * this further generate a permission fault on a R/O memslot,
> +	 * it will be caught in kvm_handle_guest_abort(), with
> +	 * prejudice. Permission faults on non-R/O memslot will be
> +	 * gracefully handled as writes.
> +	 */
> +	if (fault_status == FSC_FAULT && kvm_vcpu_dabt_is_cm(vcpu))
> +		write_fault = false;
> +	else
> +		write_fault = kvm_is_write_fault(vcpu);
>  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>  	VM_BUG_ON(write_fault && exec_fault);
>  
> @@ -1013,19 +1023,37 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		}
>  
>  		/*
> -		 * Check for a cache maintenance operation. Since we
> -		 * ended-up here, we know it is outside of any memory
> -		 * slot. But we can't find out if that is for a device,
> -		 * or if the guest is just being stupid. The only thing
> -		 * we know for sure is that this range cannot be cached.
> +		 * Check for a cache maintenance operation. Three cases:
> +		 *
> +		 * - It is outside of any memory slot. But we can't find out
> +		 *   if that is for a device, or if the guest is just being
> +		 *   stupid. The only thing we know for sure is that this
> +		 *   range cannot be cached.  So let's assume that the guest
> +		 *   is just being cautious, and skip the instruction.
> +		 *
> +		 * - Otherwise, check whether this is a permission fault.
> +		 *   If so, that's a DC IVAC on a R/O memslot, which is a
> +		 *   pretty bad idea, and we tell the guest so.
>  		 *
> -		 * So let's assume that the guest is just being
> -		 * cautious, and skip the instruction.
> +		 * - If this wasn't a permission fault, pass it along for
> +		 *   further handling (including faulting the page in if it
> +		 *   was a translation fault).
>  		 */
> -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
> -			kvm_incr_pc(vcpu);
> -			ret = 1;
> -			goto out_unlock;
> +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> +			if (kvm_is_error_hva(hva)) {
> +				kvm_incr_pc(vcpu);
> +				ret = 1;
> +				goto out_unlock;
> +			}
> +
> +			if (fault_status == FSC_PERM) {
> +				/* DC IVAC on a R/O memslot */
> +				kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
> +				ret = 1;
> +				goto out_unlock;
> +			}
> +
> +			goto handle_access;
>  		}
>  
>  		/*
> @@ -1039,6 +1067,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		goto out_unlock;
>  	}
>  
> +handle_access:
>  	/* Userspace should not be able to register out-of-bounds IPAs */
>  	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
>  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
