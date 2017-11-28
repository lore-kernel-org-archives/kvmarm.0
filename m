From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm: arm: don't treat unavailable HYP mode as an error
Date: Tue, 28 Nov 2017 15:26:30 +0000
Message-ID: <6e5efe9a-cd2f-c717-f2e3-6a05679a5e2e@arm.com>
References: <20171128151819.18669-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EED349D09
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Nov 2017 10:23:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yyAe+XeZzsvX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Nov 2017 10:23:43 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B22C40D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Nov 2017 10:23:43 -0500 (EST)
In-Reply-To: <20171128151819.18669-1-ard.biesheuvel@linaro.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/11/17 15:18, Ard Biesheuvel wrote:
> Since it is perfectly legal to run the kernel at EL1, it is not
> actually an error if HYP mode is not available when attempting to
> initialize KVM, given that KVM support cannot be built as a module.
> So demote the kvm_err() to kvm_info(), which prevents the error from
> appearing on an otherwise 'quiet' console.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  virt/kvm/arm/arm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 772bf74ac2e9..988c888a9667 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1460,7 +1460,7 @@ int kvm_arch_init(void *opaque)
>  	bool in_hyp_mode;
>  
>  	if (!is_hyp_mode_available()) {
> -		kvm_err("HYP mode not available\n");
> +		kvm_info("HYP mode not available\n");
>  		return -ENODEV;
>  	}
>  
> 

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
