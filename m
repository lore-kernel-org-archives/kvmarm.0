Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C983624A5
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 07:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789457696; cv=none; b=f5XsoP7GOAWHF5xnO6AltvNnrM5hjf3cQVuBE0TPFVqFG4wBqKBvepDO+t0KQ30gg8qyP1EeWzpiERh2af7mSHu9piXSUFnndRC+xqTRGVOQj+6TC70YCsn3Srt+GTMhX48pHWn2PCwSxIa8K92fk8pEIgRX08ABx3KD6Z4cXh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789457696; c=relaxed/simple;
	bh=1Rx3K6NjcaYr7X9/zKmWEltz4krh7XzXKYH9gyxPsjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sV8BnoFCzAEWSWP8MI8QUE4M9xrKLCmV8ER4eeUoEJgLJZ7NuSYpfDLguIQMemiOiLN5oEpmSb+bnEyd7WmpcJ/GHhRcEuQSwu9fd9TfFTeSTMaEj/vB9bA51TOk8xZHS1ot1Q7wmhRx3+vqw95qxlFy77n8LXm2xqvHJElRb6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ctIeWkci; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ctIeWkci"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6356f6bso2283956f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 00:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789457693; x=1790062493; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=62UkEF2WigrS8Qx3ZV8XeKxYeA/oVOGI4GnA4AVT89E=;
        b=ctIeWkcishlBORChKbgGuxrjG1BOXk/iTF7jy+MREufP8P8o/HmmJ3eiRBQ5FFPp/g
         KQx1vKdIINsmHPZh8RiaMWXVhIM0lCqDnhNV7EYqmhl1RXF7EkPHnXGpkPSD8sx6mKek
         VMss1mKdG2hOo4Ch+eH9F6DChPr0FIeWrT4/btcxSOm+/VCBaU3HSb09uaVPh5ufnrHx
         pxzn5jji66QjAWO8J75kthJttadDk2zsr69lN6m7QInDPqCHmSqiAhb0sdFdFg62ckgK
         oWbGctdLhKi52TzLUFlCpQI6YIq4LkLsASvgnCWh0zFfMCR5Jj+L+rgsgeey6A734UYw
         NaZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789457693; x=1790062493;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=62UkEF2WigrS8Qx3ZV8XeKxYeA/oVOGI4GnA4AVT89E=;
        b=TB76N9DOuP4tVtPLipulW8SaxER1ZWXzZGCr5kiH8yCxonPiGafOaMQWRYQ0Mw6x3B
         93N9EuChlRPhb9bbz5bGeTmndNEKJqvaZS+zAoJBEdnI962ZVRsH907NUiC8220be0KD
         +OuCvk7yocBNaqO8gVKtOhPqkQBCr20Gpa5vmZ/wOOcbEK8syS4ZIn09yaOf1rNT5Xw5
         FN55QjsvubPWBrGY+MEiXZwPCcIpspu+OxE8Jyhg6B5Q+HOO+syKMWMMN/7Oiw9WNwqK
         adCnXuFVG1voaU6WFaafag1CzXuiuafCnw01LmCS7ELhhrLGex+1Q8QcPWWlAjNMwc2g
         vzXA==
X-Forwarded-Encrypted: i=1; AKwUvBwy7pW7ur+P6H+9zWL33N3sLlCpFXblKm6FNm3QDnLcFtf2qre4YkbZi/bdxdLyTlQcvfelQk0=@lists.linux.dev
X-Gm-Message-State: AFuF++mk3pGwrnQDD/hKp39fvQD7gCDlBb912nsqNYZRGvmGeFw4vTnj
	miwpJUwzle5p1/J/ehHT7UjoPDmqU8XzqPMdplK5GDxyTBvyTmlkv3xhcY/svSFOrg==
X-Gm-Gg: AYBFou1wDN9w2/Mr7jx4JNNi5Csuyz0jTrW7B1BeollTQQB3T48P/lXcJJSJ7HZjgy1
	H2QtDNE+EbRrKgIDwQQaSaaL08TiSx+UVYCpDz1hJq3kXHJIKMPx087rGGkND3VF4z90RvGQrZV
	yIzSlWlHVDU7zNAp45ULm9oADPQi3iSWIAoYsao8GCxLezFfFDNOufLIa81jG+LASHdvSoLmGsz
	yzxxvPgCSdznmFNzoMIu3w04qnBn8+PCPFJrBVd7TJ6PZVnPjtN825SRJVw38SiyvwneH14NT2D
	0w6+eFnNb3ZjDfvNh6+TZa/Jp8+0RJRblSXPJSHS6qEVE/2dPD9ptN2QHPwtQbn+HU1ew1hIQqz
	zFidy0B+VvkU21JJR5Fsf+BRLpemVr0UFYU9K4exrvcjROelo7Tb4gTPqJbvnnAd6OoNNVvyKER
	uV1G9J2tn3GuR45VR2XFeF9+aYZCxnoumfPfBxHYdUmxebfV+QPkP3e3RtMIvbJ2nM7DGTeqTmX
	vF8g+Qqv5JW7AyZzb4Gx+9AQNJu/A0RJQfB7EgiZ0g=
X-Received: by 2002:a05:600c:a00d:b0:49e:663c:c69f with SMTP id 5b1f17b1804b1-49e7a686db5mr168895005e9.15.1789457692234;
        Tue, 15 Sep 2026 00:34:52 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e7d66ab6esm51074165e9.2.2026.09.15.00.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 00:34:51 -0700 (PDT)
Date: Tue, 15 Sep 2026 08:34:48 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	mark.rutland@arm.com, steven.price@arm.com, qperret@google.com,
	tabba@google.com
Subject: Re: [PATCH v2 1/2] KVM: arm64: Validate the host vCPU's VM before
 reading it under pKVM
Message-ID: <aqj1GKamuBraiub0@google.com>
References: <20260915070418.3209779-1-fuad.tabba@linux.dev>
 <20260915070418.3209779-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915070418.3209779-2-fuad.tabba@linux.dev>

On Tue, Sep 15, 2026 at 08:04:17AM +0100, Fuad Tabba wrote:
> On an MTE-capable host under pKVM, enter_exception64() reads the VM's
> MTE flag through vcpu->kvm, which for a host vCPU is a host-writable
> pointer nothing validates. The host can point it at any address in the
> hyp linear map and read back bit 1 of that word through PSR_TCO in the
> vCPU's CPSR, or panic the hypervisor with an unmapped one.
> 
> Get the VM through a get/put pair around the read: a loaded vCPU's is
> the hyp VM, an unloaded host vCPU's is read once and pinned, and a
> pointer the host never shared leaves TCO clear.
> 
> Fixes: ea7fc1bb1cd1b ("KVM: arm64: Introduce MTE VM feature")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/20260914070536.877D91F000FF@smtp.kernel.org/
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/hyp/exception.c             |  5 ++-
>  arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 18 ++++++++++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c             | 39 ++++++++++++++++++++++
>  3 files changed, 61 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 754e2dc1df54a..6e60d890afa4a 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -70,6 +70,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  			      enum exception_type type)
>  {
>  	unsigned long sctlr, vbar, old, new, mode;
> +	struct kvm *kvm;
>  	u64 exc_offset;
>  
>  	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
> @@ -109,8 +110,10 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  	new |= (old & PSR_C_BIT);
>  	new |= (old & PSR_V_BIT);
>  
> -	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
> +	kvm = vcpu_get_kvm(vcpu);
> +	if (kvm && kvm_has_mte(kvm))
>  		new |= PSR_TCO_BIT;
> +	vcpu_put_kvm(vcpu, kvm);
>  
>  	new |= (old & PSR_DIT_BIT);
>  
> diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> index 4fdfeabefeb43..a4fb04faa7d09 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
> @@ -13,6 +13,24 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_host.h>
>  
> +/*
> + * Under pKVM a host vCPU's ->kvm is host-writable: the nVHE pair
> + * validates it.
> + */
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +struct kvm *vcpu_get_kvm(struct kvm_vcpu *vcpu);
> +void vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm);
> +#else
> +static inline struct kvm *vcpu_get_kvm(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->kvm;
> +}
> +
> +static inline void vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm)
> +{
> +}
> +#endif
> +
>  static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu_mode_is_32bit(vcpu)) {
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 459bd9eb7e4bc..9bdc7a9b84b8c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -11,6 +11,8 @@
>  
>  #include <asm/kvm_emulate.h>
>  
> +#include <hyp/adjust_pc.h>
> +
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/memory.h>
>  #include <nvhe/pkvm.h>
> @@ -304,6 +306,43 @@ struct pkvm_hyp_vcpu *pkvm_get_loaded_hyp_vcpu(void)
>  
>  }
>  
> +static struct pkvm_hyp_vm *loaded_hyp_vm_of(struct kvm_vcpu *vcpu)

pkvm_get_loaded_hyp_vm()? to align with the other.

> +{
> +	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> +
> +	if (hyp_vcpu &&
> +	    (vcpu == &hyp_vcpu->vcpu || vcpu == hyp_vcpu->host_vcpu))
> +		return pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> +
> +	return NULL;
> +}
> +
> +/* An unloaded host vCPU's VM is mapped at EL2 only while pinned. */

Could we get the last paragraph of the commit here? As this describes quite well
what this is doing.

> +struct kvm *vcpu_get_kvm(struct kvm_vcpu *vcpu)
> +{
> +	struct pkvm_hyp_vm *hyp_vm;
> +	struct kvm *kvm;
> +
> +	if (!is_protected_kvm_enabled())
> +		return kern_hyp_va(vcpu->kvm);
> +
> +	hyp_vm = loaded_hyp_vm_of(vcpu);
> +	if (hyp_vm)
> +		return &hyp_vm->kvm;
> +
> +	kvm = kern_hyp_va(READ_ONCE(vcpu->kvm));
> +	if (hyp_pin_shared_mem(kvm, kvm + 1))
> +		return NULL;
> +
> +	return kvm;
> +}
> +
> +void vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm)
> +{
> +	if (kvm && is_protected_kvm_enabled() && !loaded_hyp_vm_of(vcpu))
> +		hyp_unpin_shared_mem(kvm, kvm + 1);
> +}
> +

It seems strange for pkvm.c to provides function that aren't prefixed with pkvm_
and declared into adjust_pc.h and not pkvm.h. I wonder if adjust_pc.h should't
just

struct kvm *vcpu_get_kvm(struct kvm_vcpu *vcpu)
{
	if (is_protected_kvm_enabled())
		return pkvm_vcpu_get_kvm()
	else
		kern_hyp_va(vcpu->kvm);
}

>  struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
>  {
>  	struct pkvm_hyp_vm *hyp_vm;
> -- 
> 2.39.5
> 

Beside those nits:

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

-- 
Vincent
