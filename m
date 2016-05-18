From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] kvm: arm64: Fix EC field in inject_abt64
Date: Wed, 18 May 2016 21:53:47 +0200
Message-ID: <20160518195347.GA26840@cbox>
References: <5739C320.6010602@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEAFA41145
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 15:49:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CLvZ-SEy51o1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 15:49:44 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F6BB4113E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 15:49:44 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id n129so200684543wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 12:53:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5739C320.6010602@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Matt Evans <matt.evans@arm.com>
Cc: marc.zyngier@arm.com, nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 01:54:56PM +0100, Matt Evans wrote:
> The EC field of the constructed ESR is conditionally modified by ORing in
> ESR_ELx_EC_DABT_LOW for a data abort.  However, ESR_ELx_EC_SHIFT is missing
> from this condition.
> 
> Signed-off-by: Matt Evans <matt.evans@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/arm64/kvm/inject_fault.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index 4d1ac81..e9e0e6d 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -162,7 +162,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
>  		esr |= (ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
>  
>  	if (!is_iabt)
> -		esr |= ESR_ELx_EC_DABT_LOW;
> +		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
>  
>  	vcpu_sys_reg(vcpu, ESR_EL1) = esr | ESR_ELx_FSC_EXTABT;
>  }
> -- 
> 1.9.1
> 

Applied to queue.

Thanks!
-Christoffer
