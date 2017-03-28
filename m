From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 8/9] arm: KVM: Make unexpected register accesses
 inject an undef
Date: Tue, 28 Mar 2017 14:46:09 +0200
Message-ID: <20170328124609.GH31156@cbox>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
 <20170327160345.12402-9-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E53240C36
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 08:44:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XD5DOFa9UTI2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 08:44:12 -0400 (EDT)
Received: from mail-wr0-f173.google.com (mail-wr0-f173.google.com
 [209.85.128.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2748640B8C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 08:44:12 -0400 (EDT)
Received: by mail-wr0-f173.google.com with SMTP id u1so103569422wra.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 05:46:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170327160345.12402-9-marc.zyngier@arm.com>
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

On Mon, Mar 27, 2017 at 05:03:44PM +0100, Marc Zyngier wrote:
> Reads from write-only system registers are generally confined to
> EL1 and not propagated to EL2 (that's what the architecture
> mantates). In order to be sure that we have a sane behaviour
> even in the unlikely event that we have a broken system, we still
> handle it in KVM. Same goes for write to RO registers.
> 
> In that case, let's inject an undef into the guest.
> 

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/coproc.c | 18 ++++++++++++++++++
>  arch/arm/kvm/coproc.h | 18 ------------------
>  2 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index 3e5e4194ef86..519aac12b365 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -40,6 +40,24 @@
>   * Co-processor emulation
>   *****************************************************************************/
>  
> +static bool write_to_read_only(struct kvm_vcpu *vcpu,
> +			       const struct coproc_params *params)
> +{
> +	WARN_ONCE(1, "CP15 write to read-only register\n");
> +	print_cp_instr(params);
> +	kvm_inject_undefined(vcpu);
> +	return false;
> +}
> +
> +static bool read_from_write_only(struct kvm_vcpu *vcpu,
> +				 const struct coproc_params *params)
> +{
> +	WARN_ONCE(1, "CP15 read to write-only register\n");
> +	print_cp_instr(params);
> +	kvm_inject_undefined(vcpu);
> +	return false;
> +}
> +
>  /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
>  static u32 cache_levels;
>  
> diff --git a/arch/arm/kvm/coproc.h b/arch/arm/kvm/coproc.h
> index eef1759c2b65..3a41b7d1eb86 100644
> --- a/arch/arm/kvm/coproc.h
> +++ b/arch/arm/kvm/coproc.h
> @@ -81,24 +81,6 @@ static inline bool read_zero(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -static inline bool write_to_read_only(struct kvm_vcpu *vcpu,
> -				      const struct coproc_params *params)
> -{
> -	kvm_debug("CP15 write to read-only register at: %08lx\n",
> -		  *vcpu_pc(vcpu));
> -	print_cp_instr(params);
> -	return false;
> -}
> -
> -static inline bool read_from_write_only(struct kvm_vcpu *vcpu,
> -					const struct coproc_params *params)
> -{
> -	kvm_debug("CP15 read to write-only register at: %08lx\n",
> -		  *vcpu_pc(vcpu));
> -	print_cp_instr(params);
> -	return false;
> -}
> -
>  /* Reset functions */
>  static inline void reset_unknown(struct kvm_vcpu *vcpu,
>  				 const struct coproc_reg *r)
> -- 
> 2.11.0
> 
