Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439004C92
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714776; cv=none; b=Bf4KvuZDATRa35yQM88iLSxdBQK9bP45OJY0Z7ig1M3sK4UbrVIMY+N9JXZPBaeuFS6Iq0U6fCH9N8/znn/YFYhAgLyNxUUSvTg45nZ3sbLolRSDvfK3xAIPi2qFTwIEzw9UZaX+UXmiek4ePyY7MmX5PIivQKil9a61jN6OLio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714776; c=relaxed/simple;
	bh=bCtVsknzzZlL7c6hHCrnnwdsXQ+7Eh4/XZfEWm+iadM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2JAxNPTBH+MHaGWTbQX64MtSsCE6fpNlFkY+XmR5uRwLmXauw/FgiExAIedS8CT64TwL5E7Qv+kHMxgYGNfeQegqVNmHLYnFEuqJHkGDdEzTC9VUE8IyYMsX2RDt2IVn/a3oWInmJ4Pr78c6Ha2OyQ+b5o6EhYaaoTPE9Hwog0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0RNT4duK; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0RNT4duK"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47d182a8c6cso6713115e9.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 07:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767714773; x=1768319573; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=REzMItOKRjoF4vczIgVji7C5aDimDWmguKzGPV8mrrY=;
        b=0RNT4duKcFAGYC96Pg92ttg1sryvWdUJ8aMi4aHkFtILbi6uo5PqsP9t64e5yiex5i
         P6txI+2y38wKNnoUiLy3d/TUbRa8DCRjBEbEr4TjXzc4McHkV/sZz29jkcyYRvFbhNRm
         Dvdp8DzW57khOIvZ9aalstCjdGUgIypWIfteNq3E6k6oNnHwn32VXGL8mYUZrYZZJxJe
         dpecRL3Aa2wt0X00sKVVZ/UznobVLfF9fFWiLKgh8dzJBWiusy/C79/ot6NTuuwt8JZ3
         vloiAqeMNAlZuy/bfSWYxaDnHVYkdFvgRcaNrVQ5nel4wDNnZnnF78Uf2yoXN6za8LH8
         w0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714773; x=1768319573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=REzMItOKRjoF4vczIgVji7C5aDimDWmguKzGPV8mrrY=;
        b=KJgIxIPcbSVI0mXlGrM3P9PODqm7SBax2oGF/IZvUXt9mVZhJZV1GTaCtbi/hBTC0K
         rG4h9oB45ChjUYG24kGKcWTkT9V4SSdtU6341hkgfLOxKVAtGKDwymnKe9l8hU0l12ds
         ghF5B/X+ZCJQG6SQlHoRIxTpXCKc/4rD4nON+sxtKRkDASwx5MXt6E+C4wvrMPtPI/cL
         z7yzOmVbOjY4kVdudU1hkFHypYhj4MbqSHOge5I+rM4pc9gqg8cIGfrTx/eeDN/WCm0R
         xfAoPdTRqP7KT9gmWgOpQIwNPiEdsjfkdbEIIX/EzXaaU3BHIjpCK2C1Np0647b6Dlqr
         6WDA==
X-Gm-Message-State: AOJu0Yx7nkdKl9YAXEbz4xJ1Y7MCMU6VgIPW+S+9GoeQNZoCoJMOTfMw
	hOjhtIvEUtctAR2wrYQ5cG+N8b9LvMOvwqaPCp9CRzQAqQLuhoA5rT2sjRn2YdvQ2A==
X-Gm-Gg: AY/fxX6NjilM4SXlMWfiOY4SHJv2VTDXPzhTEoV5kfA1KBs277HGL477YG/Ek0Io4e4
	9lDB3MVJL7TKrh+merGKvk3ELe2xJdUSIP2u7nX3412mNCK0/hy+CP6hocwJYGGH2dDt/W/JpCm
	oJjwi7mcVZod+UKMgT5c6brsPy5Nr19zI5U33XoDOo6snWrkUNiQD3hmHWNxmKzBivx0vGvD1IW
	EJBDefKnAeNYuim62H+oOy+IDMvbgkrmitCICKomQT13Je0aEEPPDIJHQRsEjkivdxnjo37/Ssz
	saD0Z5L7B6dP8ZiqqDKHoRtEzgQoSqrONZot/JtSo7j+7qUMuM9kNn9Nwl/YdXG8v6AxLgBKK0Z
	ILs+ezNqzeq1lkvH0AtIcJkaI7NOt02LLdtqXCXL9Ezp+EaIGPMQ3LLB8eN54xdZm+g4mGyl+04
	UVRJpz+7J+lPmJuv+pHTZrC/ja/I141qdURTJ0bdDKvpBo9+dfrw==
X-Google-Smtp-Source: AGHT+IEMfxjN3FxPle45sdSpE9DcCNTEP+ANJOmomnv50tX3o9Ne4hQ0H16mskrmCeiSoTeIbY2MCQ==
X-Received: by 2002:a05:600c:34c6:b0:47d:3ffa:980e with SMTP id 5b1f17b1804b1-47d7f09b759mr32272115e9.28.1767714772302;
        Tue, 06 Jan 2026 07:52:52 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e199bsm5154284f8f.16.2026.01.06.07.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:52:51 -0800 (PST)
Date: Tue, 6 Jan 2026 15:52:48 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 23/30] KVM: arm64: Add hvc handler at EL2 for hypercalls
 from protected VMs
Message-ID: <aV0v0CaUvhaYdavG@google.com>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-24-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-24-will@kernel.org>

On Mon, Jan 05, 2026 at 03:49:31PM +0000, Will Deacon wrote:
> Add a hypercall handler at EL2 for hypercalls originating from protected
> VMs. For now, this implements only the FEATURES and MEMINFO calls, but
> subsequent patches will implement the SHARE and UNSHARE functions
> necessary for virtio.
> 
> Unhandled hypercalls (including PSCI) are passed back to the host.
> 
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 37 ++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c       |  1 +
>  3 files changed, 39 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index a5a7bb453f3e..c904647d2f76 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -88,6 +88,7 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle);
>  struct pkvm_hyp_vm *get_np_pkvm_hyp_vm(pkvm_handle_t handle);
>  void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm);
>  
> +bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
>  bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
>  bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
>  void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index df340de59eed..5cdec49e989b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -4,6 +4,8 @@
>   * Author: Fuad Tabba <tabba@google.com>
>   */
>  
> +#include <kvm/arm_hypercalls.h>
> +
>  #include <linux/kvm_host.h>
>  #include <linux/mm.h>
>  
> @@ -934,3 +936,38 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>  	hyp_spin_unlock(&vm_table_lock);
>  	return err;
>  }
> +/*
> + * Handler for protected VM HVC calls.
> + *
> + * Returns true if the hypervisor has handled the exit (and control
> + * should return to the guest) or false if it hasn't (and the handling
> + * should be performed by the host).
> + */
> +bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
> +{
> +	u64 val[4] = { SMCCC_RET_INVALID_PARAMETER };
> +	bool handled = true;
> +
> +	switch (smccc_get_function(vcpu)) {
> +	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> +		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID:
> +		if (smccc_get_arg1(vcpu) ||
> +		    smccc_get_arg2(vcpu) ||
> +		    smccc_get_arg3(vcpu)) {
> +			break;
> +		}
> +
> +		val[0] = PAGE_SIZE;
> +		break;
> +	default:
> +		/* Punt everything else back to the host, for now. */
> +		handled = false;
> +	}
> +
> +	if (handled)
> +		smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> +	return handled;
> +}
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index d3b9ec8a7c28..b62e25e8bb7e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -190,6 +190,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>  
>  static const exit_handler_fn pvm_exit_handlers[] = {
>  	[0 ... ESR_ELx_EC_MAX]		= NULL,
> +	[ESR_ELx_EC_HVC64]		= kvm_handle_pvm_hvc64,
>  	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
>  	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
>  	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
