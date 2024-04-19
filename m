Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA7613C9A9
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 20:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713558517; cv=none; b=r389iqc+uM6gH3XgKzI+2Re+zZBkF8cOJHUw5HOmYGKCFGDJm3aWHa0E0e4I1Xeczw99pDjH0GQ3uvRNlq4QKEZgTj6LZf+f4OQIaZq3mh4HDETfm7JTw5Y92iHEDznPQynQRBZGOLFkbnbhhrZt0IequugEqRqIr47PLVuFizg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713558517; c=relaxed/simple;
	bh=SIPps9l19veXeqLixG/EgzcVgtnRd7Z2TJCgrZwsk6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kc6OBppmDmDj/G9v5Sf0sy1rg/OcsksbSjOXwwzRXf/qlgQalJzmieqU07SLyv1sQkt5Mg2zGYTa0bDRGnhDyBpTDFyQ8JSubF6hgjTFXtds1D/riLrJLoK+stIORatDXRWffd01PF2Ijx9Pf4ZkXMAtL2vsgDzy5n86d+78RN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s3HA2KZF; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s3HA2KZF"
Date: Fri, 19 Apr 2024 20:28:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713558513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j0uI/vNEx8qrmDcmzbPuTiCYrYl22dhkjt1PcfXZmvo=;
	b=s3HA2KZFaDrTspy9XgPI1CsUremK+bJEtCK6N2+4vIl6RRlWSNfMVb20prjnryzV8d04Tb
	SCv32QkmXQtyX/HgTrQmicDp+L78+wHihX+s0MpSzfgc/l1wpf4TB1ZLzxbTofD5O8YtEE
	3cdlqOytydwe2TvHQ0aD+LEeDZDL+OQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v3 31/31] KVM: arm64: Force injection of a data abort on
 NISV MMIO exit
Message-ID: <ZiLT60yvCMcJmK5T@linux.dev>
References: <20240419075941.4085061-1-tabba@google.com>
 <20240419075941.4085061-32-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419075941.4085061-32-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 08:59:41AM +0100, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> If a vcpu exits for a data abort with an invalid syndrome, the
> expectations are that userspace has a chance to save the day if
> it has requested to see such exits.
> 
> However, this is completely futile in the case of a protected VM,
> as none of the state is available. In this particular case, inject
> a data abort directly into the vcpu, consistent with what userspace
> could do.
> 
> This also helps with pKVM, which discards all syndrome information when
> forwarding data aborts that are not known to be MMIO.
> 
> Finally, hide the RETURN_NISV_IO_ABORT_TO_USER cap from userspace on
> protected VMs, and document this tweak to the API.

Are there going to be more KVM caps that we hide from protected VMs in
the future? If so, it might be better to have a common helper that
enforces a denylist of capabilities not supported by pKVM.

That way we can avoid adding kvm_vm_is_protected() checks all over the
shop.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 66301131d5a9..750386a84968 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -80,9 +80,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  
>  	switch (cap->cap) {
>  	case KVM_CAP_ARM_NISV_TO_USER:
> -		r = 0;
> -		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> -			&kvm->arch.flags);
> +		if (kvm_vm_is_protected(kvm)) {
> +			r = -EINVAL;
> +		} else {
> +			r = 0;
> +			set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> +				&kvm->arch.flags);
> +		}

nitpick: initialize r = -EINVAL and get rid of all the error-path
initializations in kvm_vm_ioctl_enable_cap()

>  		break;
>  	case KVM_CAP_ARM_MTE:
>  		mutex_lock(&kvm->lock);
> @@ -237,7 +241,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_IMMEDIATE_EXIT:
>  	case KVM_CAP_VCPU_EVENTS:
>  	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
> -	case KVM_CAP_ARM_NISV_TO_USER:
>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_VCPU_ATTRIBUTES:
> @@ -247,6 +250,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_COUNTER_OFFSET:
>  		r = 1;
>  		break;
> +	case KVM_CAP_ARM_NISV_TO_USER:
> +		r = !kvm || !kvm_vm_is_protected(kvm);
> +		break;
>  	case KVM_CAP_SET_GUEST_DEBUG2:
>  		return KVM_GUESTDBG_VALID_MASK;
>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index 5e1ffb0d5363..75e1072948cd 100644
> --- a/arch/arm64/kvm/mmio.c
> +++ b/arch/arm64/kvm/mmio.c
> @@ -133,11 +133,19 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  	/*
>  	 * No valid syndrome? Ask userspace for help if it has
>  	 * volunteered to do so, and bail out otherwise.
> +	 *
> +	 * In the protected VM case, there isn't much userspace can do
> +	 * though, so directly deliver an exception to the guest.
>  	 */
>  	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
>  		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
>  				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
>  
> +		if (is_protected_kvm_enabled() && vcpu_is_protected(vcpu)) {

You can drop the is_protected_kvm_enabled() now that it got folded in to
kvm_vm_is_protected().

-- 
Thanks,
Oliver
