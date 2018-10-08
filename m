From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm64: remove the unnecessary function check
Date: Mon, 8 Oct 2018 17:18:18 +0100
Message-ID: <afbb853e-ef22-dde4-d17d-6802264f1ce9@arm.com>
References: <1535708579-12233-1-git-send-email-zhangshaokun@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F29954A1FC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Oct 2018 12:18:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UzHTgHqkz6Np for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Oct 2018 12:18:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC2544A1E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Oct 2018 12:18:21 -0400 (EDT)
In-Reply-To: <1535708579-12233-1-git-send-email-zhangshaokun@hisilicon.com>
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
To: Shaokun Zhang <zhangshaokun@hisilicon.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 31/08/18 10:42, Shaokun Zhang wrote:
> init_common_resources always return 0 and it is redundant to check the
> return value, let's make it void to simplify the code.
> 
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>   virt/kvm/arm/arm.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index c92053b..66a29c9 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1406,13 +1406,11 @@ static inline void hyp_cpu_pm_exit(void)
>   }
>   #endif
>   
> -static int init_common_resources(void)
> +static void init_common_resources(void)
>   {
>   	/* set size of VMID supported by CPU */
>   	kvm_vmid_bits = kvm_get_vmid_bits();
>   	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
> -
> -	return 0;
>   }
>   
>   static int init_subsystems(void)
> @@ -1655,9 +1653,7 @@ int kvm_arch_init(void *opaque)
>   		}
>   	}
>   
> -	err = init_common_resources();
> -	if (err)
> -		return err;
> +	init_common_resources();
>   
>   	in_hyp_mode = is_kernel_in_hyp_mode();
>   
> 

Although I agree this looks pretty superfluous at the moment, I'd rather 
keep init_common_resources as it is at the moment, as we may well end-up 
with more stuff in it, which could fail.

Another possibility would be to merge everything in init_subsystems, but 
that'd require careful investigation, specially with the stuff that is 
currently pending for 4.20.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
