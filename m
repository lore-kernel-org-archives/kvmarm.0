From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 2/6] arm64: KVM: Handle Set/Way CMOs as NOPs if FWB is
 present
Date: Thu, 31 May 2018 12:51:27 +0100
Message-ID: <20180531115127.2ymmtlwemz6g5qzj@lakrids.cambridge.arm.com>
References: <20180530124706.25284-1-marc.zyngier@arm.com>
 <20180530124706.25284-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92E224A0ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 May 2018 07:40:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iHKTnG-C39Oj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 May 2018 07:40:31 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC17A49EA2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 May 2018 07:40:31 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180530124706.25284-3-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 30, 2018 at 01:47:02PM +0100, Marc Zyngier wrote:
> Set/Way handling is one of the ugliest corners of KVM. We shouldn't
> have to handle that, but better safe than sorry.
> 
> Thankfully, FWB fixes this for us by not requiering any maintenance
> whatsoever, which means we don't have to emulate S/W CMOs, and don't
> have to track VM ops either.
> 
> We still have to trap S/W though, if only to prevent the guest from
> doing something bad.

S/W ops *also* do I-cache maintenance, so we'd still need to emulate
that. Though it looks like we're missing that today...

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6e3b969391fd..9a740f159245 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -195,7 +195,13 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
>  	if (!p->is_write)
>  		return read_from_write_only(vcpu, p, r);
>  
> -	kvm_set_way_flush(vcpu);
> +	/*
> +	 * Only track S/W ops if we don't have FWB. It still indicates
> +	 * that the guest is a bit broken...
> +	 */
> +	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> +		kvm_set_way_flush(vcpu);
> +

Assuming we implement I-cache maintenance, we can have something like:

	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
		kvm_set_way_flush_dcache(vcpu);

	kvm_set_way_flush_icache(vcpu);

Thanks,
Mark.

>  	return true;
>  }
>  
> -- 
> 2.17.1
> 
