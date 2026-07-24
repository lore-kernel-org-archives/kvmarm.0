Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC12361977
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 06:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873501; cv=none; b=evnaQREDuFK0PiZB/JfQm6lXJB+pha24gIvaTodtJoPyYQh2ki6s4F6jjNDc1pdaHru5E8Nou+Z8UHu0I+IDwpTRktG8BQEFq/6YfQK+/sF4bbMqLGBvlS4KXV5sTO5R6JGY/Bj2jVLOREzWdai5achm0MAbh07mqxn0KloVN2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873501; c=relaxed/simple;
	bh=5EyeQBTFmUPY/dVRSasx7MIZ0Kss7kGzKgfjpD0oyrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWAteZ4IacQaV1QHhaxZ2mpVY6IHM32Ye4b9OjZK6L8OtVzfVYXBUsDr1vum8pL6zeh1RCUmo50OFTZD5FQWLTLt3kCUeBSyK6I3yuLoi5IgGZR6BmkO6gx73jW86lLfFoq5RdIBGrotTFJGGC4zgLkd7UATyYdKpPd6ZQzm8Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sVTT+Dox; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sVTT+Dox"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784873497; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=BKg6VK9RqPImUYGMS477AME02hlbupA9/UkMQE70Rmo=;
	b=sVTT+Doxo0Q0AEyZHxVW7UFd9LpJJQuAh+TELJgObi2Y4P/bkPFjHzt2wC09ylS/OTZXNISm75dRpYHSjA+trYWFHOln/kqF+b1KoSYE9BaJfwdBQtRfcL8RyHqSzkFuliNqBP5OIRQqx7DCRQx+UBpuqdgYoV3ZxypuZoQAbAE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X7iE9hJ_1784873496;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X7iE9hJ_1784873496 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Jul 2026 14:11:36 +0800
Date: Fri, 24 Jul 2026 14:11:35 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 16/28] KVM: arm64: Split NV-specific exit fixups from
 the non-NV handling
Message-ID: <bs3c4cdx7pqd4u3kszy5tvje5to6b5y5ztfcyies6ancgtwgqs@v4nxtyvc2bud>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-17-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722074234.3330999-17-maz@kernel.org>

On Wed, Jul 22, 2026 at 08:42:22AM +0800, Marc Zyngier wrote:
> In order to facilitate further changes, move the NV handling of
> early fixups in its own helper. This also makes the code slightly
> simpler to parse.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index a8da40568a048..53af19212895d 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -539,18 +539,15 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>  	[0x3F]				= kvm_hyp_handle_impdef,
>  };
>
> -static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
>  {
> -	synchronize_vcpu_pstate(vcpu);
> -
>  	/*
>  	 * If we were in HYP context on entry, adjust the PSTATE view
>  	 * so that the usual helpers work correctly. This enforces our
>  	 * invariant that the guest's HYP context status is preserved
>  	 * across a run.
>  	 */
> -	if (vcpu_has_nv(vcpu) &&
> -	    unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {
> +	if (unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {
>  		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
>
>  		switch (mode) {
> @@ -567,8 +564,15 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	}
>
>  	/* Apply extreme paranoia! */
> -	BUG_ON(vcpu_has_nv(vcpu) &&
> -	       !!host_data_test_flag(VCPU_IN_HYP_CONTEXT) != is_hyp_ctxt(vcpu));
> +	BUG_ON(!!host_data_test_flag(VCPU_IN_HYP_CONTEXT) != is_hyp_ctxt(vcpu));
> +}
> +
> +static bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> +{
> +	synchronize_vcpu_pstate(vcpu);
> +
> +	if (vcpu_has_nv(vcpu))
> +		fixup_nv_guest_exit(vcpu);
>
>  	return __fixup_guest_exit(vcpu, exit_code, hyp_exit_handlers);
>  }
> --
> 2.47.3
