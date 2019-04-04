From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 06/27] arm64/sve: Clarify role of the VQ map
 maintenance functions
Date: Thu, 4 Apr 2019 23:21:52 +0200
Message-ID: <20190404212152.klzpajagtqp5rpdz@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-7-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09DF24A41A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 17:21:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jgzW6uE8URHL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 17:21:58 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE19A4A319
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 17:21:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1553864452-15080-7-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 29, 2019 at 01:00:31PM +0000, Dave Martin wrote:
> The roles of sve_init_vq_map(), sve_update_vq_map() and
> sve_verify_vq_map() are highly non-obvious to anyone who has not dug
> through cpufeatures.c in detail.
> 
> Since the way these functions interact with each other is more
> important here than a full understanding of the cpufeatures code, this
> patch adds comments to make the functions' roles clearer.
> 
> No functional change.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> Reviewed-by: Julien Grall <julien.grall@arm.com>
> Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> 
> ---
> 
> Changes since v5:
> 
>  * [Julien Thierry] This patch is useful for explaining the previous
>    patch (as per the v5 ordering), and is anyway non-functional.
>    Swapped it with the previous patch to provide a more logical reading
>    order for the series.
> ---
>  arch/arm64/kernel/fpsimd.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 62c37f0..f59ea67 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -647,6 +647,10 @@ static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
>  	}
>  }
>  
> +/*
> + * Initialise the set of known supported VQs for the boot CPU.
> + * This is called during kernel boot, before secondary CPUs are brought up.
> + */
>  void __init sve_init_vq_map(void)
>  {
>  	sve_probe_vqs(sve_vq_map);
> @@ -655,6 +659,7 @@ void __init sve_init_vq_map(void)
>  /*
>   * If we haven't committed to the set of supported VQs yet, filter out
>   * those not supported by the current CPU.
> + * This function is called during the bring-up of early secondary CPUs only.
>   */
>  void sve_update_vq_map(void)
>  {
> @@ -662,7 +667,10 @@ void sve_update_vq_map(void)
>  	bitmap_and(sve_vq_map, sve_vq_map, sve_secondary_vq_map, SVE_VQ_MAX);
>  }
>  
> -/* Check whether the current CPU supports all VQs in the committed set */
> +/*
> + * Check whether the current CPU supports all VQs in the committed set.
> + * This function is called during the bring-up of late secondary CPUs only.
> + */
>  int sve_verify_vq_map(void)
>  {
>  	int ret = 0;
> -- 
> 2.1.4

Reviewed-by: Andrew Jones <drjones@redhat.com>
