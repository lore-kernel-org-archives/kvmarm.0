From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 4/5] arm64: Use __tlbi_dsb() macros in KVM code
Date: Fri, 6 Jan 2017 16:05:15 +0000
Message-ID: <20170106160515.GB17642@leverpostej>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-4-cov@codeaurora.org>
 <20170103155756.GB14183@leverpostej>
 <f5020a04-5fc7-26b5-1ded-c58e159bc722@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00D6740455
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 11:04:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vzFegZPsy2oD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jan 2017 11:04:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BB984044B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 11:04:34 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <f5020a04-5fc7-26b5-1ded-c58e159bc722@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 06, 2017 at 10:51:53AM -0500, Christopher Covington wrote:
> On 01/03/2017 10:57 AM, Mark Rutland wrote:
> > On Thu, Dec 29, 2016 at 05:43:34PM -0500, Christopher Covington wrote:
> >> Refactor the KVM code to use the newly introduced __tlbi_dsb macros, which
> >> will allow an errata workaround that repeats tlbi dsb sequences to only
> >> change one location. This is not intended to change the generated assembly
> >> and comparing before and after vmlinux objdump shows no functional changes.
> 
> @@ -32,7 +33,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
>  	 * whole of Stage-1. Weep...
>  	 */
>  	ipa >>= 12;
> -	asm volatile("tlbi ipas2e1is, %0" : : "r" (ipa));
> +	__tlbi_dsb(ipas2e1is, ish, ipa);
>  
>  	/*
>  	 * We have to ensure completion of the invalidation at Stage-2,
> 
> >> @@ -40,9 +41,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
> >>  	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
> >>  	 * the Stage-1 invalidation happened first.
> >>  	 */
> >> -	dsb(ish);
> > 
> > Looks like this got accidentally removed. AFAICT it is still necessary.
> 
> Not removed, just hoisted above the comment block to the previous patch hunk.

Ah, sorry. I hadn't spotted that it got folded into the __tlbi_dsb()
above.

Given the comment was previously attached to the DSB, it might make more
sense to fold it into the prior comment block, so that it remains
attached to the __tlbi_dsb(), which guarantees the completion that the
comment describes.

Thanks,
Mark.
