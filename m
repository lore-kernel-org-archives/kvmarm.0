From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 4/9] arm64: KVM: Make unexpected reads from WO
 registers inject an undef
Date: Tue, 28 Mar 2017 14:45:13 +0200
Message-ID: <20170328124513.GD31156@cbox>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
 <20170327160345.12402-5-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DE0E40C30
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 08:43:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8+U55hwKARgA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 08:43:17 -0400 (EDT)
Received: from mail-wr0-f172.google.com (mail-wr0-f172.google.com
 [209.85.128.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 591E340C33
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 08:43:17 -0400 (EDT)
Received: by mail-wr0-f172.google.com with SMTP id u1so103528616wra.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 05:45:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170327160345.12402-5-marc.zyngier@arm.com>
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
Cc: Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 27, 2017 at 05:03:40PM +0100, Marc Zyngier wrote:
> Reads from write-only system registers are generally confined to
> EL1 and not propagated to EL2 (that's what the architecture
> mantates). In order to be sure that we have a sane behaviour
> even in the unlikely event that we have a broken system, we still
> handle it in KVM.
> 
> In that case, let's inject an undef into the guest.
> 
> Let's also remove write_to_read_only which isn't used anywhere.
> 

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c |  9 +++++++++
>  arch/arm64/kvm/sys_regs.h | 18 ------------------
>  2 files changed, 9 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5e3ce7890b35..19a036b4f6ac 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -55,6 +55,15 @@
>   * 64bit interface.
>   */
>  
> +static bool read_from_write_only(struct kvm_vcpu *vcpu,
> +				 const struct sys_reg_params *params)
> +{
> +	WARN_ONCE(1, "Unexpected sys_reg read to write-only register\n");
> +	print_sys_reg_instr(params);
> +	kvm_inject_undefined(vcpu);
> +	return false;
> +}
> +
>  /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
>  static u32 cache_levels;
>  
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 9c6ffd0f0196..638f724e45af 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -83,24 +83,6 @@ static inline bool read_zero(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -static inline bool write_to_read_only(struct kvm_vcpu *vcpu,
> -				      const struct sys_reg_params *params)
> -{
> -	kvm_debug("sys_reg write to read-only register at: %lx\n",
> -		  *vcpu_pc(vcpu));
> -	print_sys_reg_instr(params);
> -	return false;
> -}
> -
> -static inline bool read_from_write_only(struct kvm_vcpu *vcpu,
> -					const struct sys_reg_params *params)
> -{
> -	kvm_debug("sys_reg read to write-only register at: %lx\n",
> -		  *vcpu_pc(vcpu));
> -	print_sys_reg_instr(params);
> -	return false;
> -}
> -
>  /* Reset functions */
>  static inline void reset_unknown(struct kvm_vcpu *vcpu,
>  				 const struct sys_reg_desc *r)
> -- 
> 2.11.0
> 
