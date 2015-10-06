From: Wei Huang <wei@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix memory leak if timer initialization
 fails
Date: Tue, 6 Oct 2015 09:45:36 -0500
Message-ID: <5613DE90.2070901@redhat.com>
References: <1444119275-8972-1-git-send-email-p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1444119275-8972-1-git-send-email-p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu



On 10/06/2015 03:14 AM, Pavel Fedin wrote:
> Jump to correct label and free kvm_host_cpu_state
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm/kvm/arm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index dc017ad..78b2869 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -1080,7 +1080,7 @@ static int init_hyp_mode(void)
>  	 */
>  	err = kvm_timer_hyp_init();
>  	if (err)
> -		goto out_free_mappings;
> +		goto out_free_context;
>  
>  #ifndef CONFIG_HOTPLUG_CPU
>  	free_boot_hyp_pgd();
> 


kvm_host_cpu_state was allocated before kvm_timer_hyp_init() is called.
So it needs to be freed when kvm_timer_hyp_init() fails.

Reviewed-by: Wei Huang <wei@redhat.com>

Thanks,
-Wei
