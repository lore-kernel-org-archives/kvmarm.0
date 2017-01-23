From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/2] arm64: kvm: upgrade csselr and ccsidr to 64-bit values
Date: Mon, 23 Jan 2017 22:08:59 +0100
Message-ID: <20170123210859.GJ15850@cbox>
References: <1484909410-11673-1-git-send-email-sudeep.holla@arm.com>
 <1484909410-11673-2-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F04334097B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 16:09:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HZ0nUtuklJHB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jan 2017 16:08:59 -0500 (EST)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3020408EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 16:08:59 -0500 (EST)
Received: by mail-lf0-f46.google.com with SMTP id x1so13760494lff.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 13:09:05 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1484909410-11673-2-git-send-email-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 20, 2017 at 10:50:10AM +0000, Sudeep Holla wrote:
> csselr and ccsidr are treated as 64-bit values already elsewhere in the
> kernel. It also aligns well with the architecture extensions that allow
> 64-bit format for ccsidr.
> 
> This patch upgrades the existing accesses to csselr and ccsidr from
> 32-bit to 64-bit in preparation to add support to those extensions.
> 
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5dca1f10340f..a3559a8a2b0c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -58,15 +58,15 @@
>   */
>  
>  /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
> -static u32 cache_levels;
> +static u64 cache_levels;
>  
>  /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
>  #define CSSELR_MAX 	((MAX_CACHE_LEVEL - 1) >> 1)
>  
>  /* Which cache CCSIDR represents depends on CSSELR value. */
> -static u32 get_ccsidr(u32 csselr)
> +static u64 get_ccsidr(u64 csselr)
>  {
> -	u32 ccsidr;
> +	u64 ccsidr;
>  
>  	/* Make sure noone else changes CSSELR during this! */
>  	local_irq_disable();
> @@ -1952,9 +1952,9 @@ static int set_invariant_sys_reg(u64 id, void __user *uaddr)
>  	return 0;
>  }
>  
> -static bool is_valid_cache(u32 val)
> +static bool is_valid_cache(u64 val)
>  {
> -	u32 level, ctype;
> +	u64 level, ctype;
>  
>  	if (val >= CSSELR_MAX)
>  		return false;
> @@ -1979,8 +1979,8 @@ static bool is_valid_cache(u32 val)
>  
>  static int demux_c15_get(u64 id, void __user *uaddr)
>  {
> -	u32 val;
> -	u32 __user *uval = uaddr;
> +	u64 val;
> +	u64 __user *uval = uaddr;
>  
>  	/* Fail if we have unknown bits set. */
>  	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
> @@ -2004,8 +2004,8 @@ static int demux_c15_get(u64 id, void __user *uaddr)
>  
>  static int demux_c15_set(u64 id, void __user *uaddr)
>  {
> -	u32 val, newval;
> -	u32 __user *uval = uaddr;
> +	u64 val, newval;
> +	u64 __user *uval = uaddr;

Doesn't converting these uval pointers to u64 cause us to break the ABI
as we'll now be reading/writing 64-bit values to userspace with the
get_user and put_user following the declarations?

>  
>  	/* Fail if we have unknown bits set. */
>  	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
> -- 
> 2.7.4
> 

Thanks,
-Christoffer
