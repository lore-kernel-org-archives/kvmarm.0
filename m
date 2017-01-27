From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 3/4] arm64: Use __tlbi() macros in KVM code
Date: Fri, 27 Jan 2017 15:03:22 +0000
Message-ID: <20170127150321.GM21144@arm.com>
References: <20170125155232.10277-1-cov@codeaurora.org>
 <20170125155232.10277-3-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DA4B405DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 10:03:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rQ1PiHdFzdAB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Jan 2017 10:03:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D29B44018B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 10:03:10 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170125155232.10277-3-cov@codeaurora.org>
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
Cc: Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Neil Leeder <nleeder@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 25, 2017 at 10:52:31AM -0500, Christopher Covington wrote:
> Refactor the KVM code to use the __tlbi macros, which will allow an errata
> workaround that repeats tlbi dsb sequences to only change one location.
> This is not intended to change the generated assembly and comparing before
> and after vmlinux objdump shows no functional changes.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arch/arm64/kvm/hyp/tlb.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

[...]

> @@ -82,7 +83,7 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
>  void __hyp_text __kvm_flush_vm_context(void)
>  {
>  	dsb(ishst);
> -	asm volatile("tlbi alle1is	\n"
> -		     "ic ialluis	  ": : );
> +	__tlbi(alle1is);
> +	asm volatile("ic ialluis" : : );
>  	dsb(ish);

Should be a separate patch, but this can now be a __flush_icache_all instead
of the open-coded asm.

Will
