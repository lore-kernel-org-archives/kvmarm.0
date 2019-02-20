From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v5 07/26] arm64/sve: Clarify role of the VQ map
 maintenance functions
Date: Wed, 20 Feb 2019 11:43:24 +0000
Message-ID: <f8a56d62-3b45-e369-ed4a-187895a178c0@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-8-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1550519559-15915-8-git-send-email-Dave.Martin@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 18/02/2019 19:52, Dave Martin wrote:
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
> ---
>  arch/arm64/kernel/fpsimd.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 64729e2..92c2331 100644
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
> @@ -656,6 +660,7 @@ void __init sve_init_vq_map(void)
>  /*
>   * If we haven't committed to the set of supported VQs yet, filter out
>   * those not supported by the current CPU.
> + * This function is called during the bring-up of early secondary CPUs only.
>   */
>  void sve_update_vq_map(void)
>  {
> @@ -666,7 +671,10 @@ void sve_update_vq_map(void)
>  	bitmap_or(sve_vq_partial_map, sve_vq_partial_map, tmp_map, SVE_VQ_MAX);
>  }
>  
> -/* Check whether the current CPU supports all VQs in the committed set */
> +/*
> + * Check whether the current CPU supports all VQs in the committed set.
> + * This function is called during the bring-up of late secondary CPUs only.

Oh I see, this is for late CPUs. So you can probably disregard my
comment on the warning in the previous patch.

If you respin this series, I feel it would be more useful to have this
patch before the current patch 6.

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

-- 
Julien Thierry
