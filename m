From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Fix memory leak if timer initialization
 fails
Date: Thu, 8 Oct 2015 10:56:41 +0200
Message-ID: <20151008085641.GG14315@cbox>
References: <1444119275-8972-1-git-send-email-p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E7E94155B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 04:54:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MxvDteS3UPCN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 04:54:30 -0400 (EDT)
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com
 [209.85.217.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C43D041338
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 04:54:29 -0400 (EDT)
Received: by lbwr8 with SMTP id r8so38920074lbw.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Oct 2015 01:56:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1444119275-8972-1-git-send-email-p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 06, 2015 at 11:14:35AM +0300, Pavel Fedin wrote:
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

Nice catch.

Applied, thanks.

-Christoffer
