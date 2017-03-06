From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] arm64: kvm: Use has_vhe() instead of
 hyp_alternate_select()
Date: Mon, 06 Mar 2017 08:34:00 +0000
Message-ID: <87bmte3itj.fsf@on-the-bus.cambridge.arm.com>
References: <1488767598-2055-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55A5C40B5E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 03:32:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K8P37u2ISZpd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 03:32:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1E640A6A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 03:32:48 -0500 (EST)
In-Reply-To: <1488767598-2055-1-git-send-email-shankerd@codeaurora.org>
 (Shanker Donthineni's message of "Sun, 5 Mar 2017 20:33:18 -0600")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: kvm <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shanker,

On Mon, Mar 06 2017 at  2:33:18 am GMT, Shanker Donthineni <shankerd@codeaurora.org> wrote:
> Now all the cpu_hwcaps features have their own static keys. We don't
> need a separate function hyp_alternate_select() to patch the vhe/nvhe
> code. We can achieve the same functionality by using has_vhe(). It
> improves the code readability, uses the jump label instructions, and
> also compiler generates the better code with a fewer instructions.

How do you define "better"? Which compiler? Do you have any benchmarking data?

>
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
> v2: removed 'Change-Id: Ia8084189833f2081ff13c392deb5070c46a64038' from commit
>
>  arch/arm64/kvm/hyp/debug-sr.c  | 12 ++++++----
>  arch/arm64/kvm/hyp/switch.c    | 50 +++++++++++++++++++-----------------------
>  arch/arm64/kvm/hyp/sysreg-sr.c | 23 +++++++++----------
>  3 files changed, 43 insertions(+), 42 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index f5154ed..e5642c2 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -109,9 +109,13 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
>  	dsb(nsh);
>  }
>  
> -static hyp_alternate_select(__debug_save_spe,
> -			    __debug_save_spe_nvhe, __debug_save_spe_vhe,
> -			    ARM64_HAS_VIRT_HOST_EXTN);
> +static void __hyp_text __debug_save_spe(u64 *pmscr_el1)
> +{
> +	if (has_vhe())
> +		__debug_save_spe_vhe(pmscr_el1);
> +	else
> +		__debug_save_spe_nvhe(pmscr_el1);
> +}

I have two worries about this kind of thing:
- Not all compilers do support jump labels, leading to a memory access
on each static key (GCC 4.8, for example). This would immediately
introduce a pretty big regression
- The hyp_alternate_select() method doesn't introduce a fast/slow path
duality. Each path has the exact same cost. I'm not keen on choosing
what is supposed to be the fast path, really.

Thanks,

	M.
-- 
Jazz is not dead, it just smell funny.
