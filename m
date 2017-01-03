From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 4/5] arm64: Use __tlbi_dsb() macros in KVM code
Date: Tue, 3 Jan 2017 15:57:56 +0000
Message-ID: <20170103155756.GB14183@leverpostej>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-4-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 217CE40797
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2017 10:57:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NiTXVM+-69Mp for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2017 10:57:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10FE7406A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2017 10:57:18 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161229224335.13531-4-cov@codeaurora.org>
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

On Thu, Dec 29, 2016 at 05:43:34PM -0500, Christopher Covington wrote:
> Refactor the KVM code to use the newly introduced __tlbi_dsb macros, which
> will allow an errata workaround that repeats tlbi dsb sequences to only
> change one location. This is not intended to change the generated assembly
> and comparing before and after vmlinux objdump shows no functional changes.

> @@ -40,9 +41,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
>  	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
>  	 * the Stage-1 invalidation happened first.
>  	 */
> -	dsb(ish);

Looks like this got accidentally removed. AFAICT it is still necessary.

> -	asm volatile("tlbi vmalle1is" : : );
> -	dsb(ish);
> +	__tlbi_dsb(vmalle1is, ish);
>  	isb();

Thanks,
Mark.
