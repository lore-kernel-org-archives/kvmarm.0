Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB652F6171
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 10:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759227192; cv=none; b=t9s2gdrTMInSbach7x3h36ZuwZdpTozanhHuxze67/FRR3TRRSXUNUK9pAW1idiWKl0ZbHrB8QLnN7f5b1C+l82fOGJrqER9GCRdxp829tWjIBrfz4lYLNZKBVPt/PLDxTQxzfuY5MoNGz3H7g2ejIbg4y72MAv3hlKH3W9YD/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759227192; c=relaxed/simple;
	bh=oYIAf+0OJAX/Jhq2Y/GzSe2lZx3Dl1A7OM1VbraNduU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YKb5CCelxWGW7AWYkRIJMfIRxK7X4lb87JGFltrxpjoty+fVmKTrPM95CFVYT6/1HeM0GE+gw2yUX71Lk2CTYhlhvvWsZCEH+VOnQk4mMejpfvZybtTmSQ88Mt+Gu/fr0IY+5XZkrJb0FsNMOykuHjdVsAmfXWYbVhrZVDWRaLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07E161424;
	Tue, 30 Sep 2025 03:13:02 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEC843F66E;
	Tue, 30 Sep 2025 03:13:08 -0700 (PDT)
Date: Tue, 30 Sep 2025 11:13:03 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 03/13] KVM: arm64: Replace timer context vcpu pointer
 with timer_id
Message-ID: <20250930101303.GA1093338@e124191.cambridge.arm.com>
References: <20250929160458.3351788-1-maz@kernel.org>
 <20250929160458.3351788-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929160458.3351788-4-maz@kernel.org>

On Mon, Sep 29, 2025 at 05:04:47PM +0100, Marc Zyngier wrote:
> Having to follow a pointer to a vcpu is pretty dumb, when the timers
> are are a fixed offset in the vcpu structure itself.
> 
> Trade the vcpu pointer for a timer_id, which can then be used to
> compute the vcpu address as needed.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/arch_timer.c  |  4 ++--
>  include/kvm/arm_arch_timer.h | 11 ++++++-----
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index e5a25e743f5be..c832c293676a3 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -149,7 +149,7 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>  static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  {
>  	if (!ctxt->offset.vm_offset) {
> -		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
> +		WARN(offset, "timer %d\n", arch_timer_ctx_index(ctxt));
>  		return;
>  	}
>  
> @@ -1064,7 +1064,7 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>  	struct arch_timer_context *ctxt = vcpu_get_timer(vcpu, timerid);
>  	struct kvm *kvm = vcpu->kvm;
>  
> -	ctxt->vcpu = vcpu;
> +	ctxt->timer_id = timerid;
>  
>  	if (timerid == TIMER_VTIMER)
>  		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index d188c716d03cb..d8e400cb2bfff 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -51,8 +51,6 @@ struct arch_timer_vm_data {
>  };
>  
>  struct arch_timer_context {
> -	struct kvm_vcpu			*vcpu;
> -
>  	/* Emulated Timer (may be unused) */
>  	struct hrtimer			hrtimer;
>  	u64				ns_frac;
> @@ -71,6 +69,9 @@ struct arch_timer_context {
>  		bool			level;
>  	} irq;
>  
> +	/* Who am I? */
> +	enum kvm_arch_timers		timer_id;
> +
>  	/* Duplicated state from arch_timer.c for convenience */
>  	u32				host_timer_irq;
>  };
> @@ -127,9 +128,9 @@ void kvm_timer_init_vhe(void);
>  #define vcpu_hvtimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HVTIMER])
>  #define vcpu_hptimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HPTIMER])
>  
> -#define arch_timer_ctx_index(ctx)	((ctx) - vcpu_timer((ctx)->vcpu)->timers)
> -#define timer_context_to_vcpu(ctx)	((ctx)->vcpu)
> -#define timer_vm_data(ctx)		(&(ctx)->vcpu->kvm->arch.timer_data)
> +#define arch_timer_ctx_index(ctx)	((ctx)->timer_id)
> +#define timer_context_to_vcpu(ctx)	container_of((ctx), struct kvm_vcpu, arch.timer_cpu.timers[(ctx)->timer_id])
> +#define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer_data))
>  #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx)])
>  
>  u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
> -- 
> 2.47.3
> 
