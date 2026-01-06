Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D2232D0D0
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767710887; cv=none; b=jYCkcAtdp53vn7qr1Xa4yW3rp/TIOwZnsKb7pyOkujmHwdV1gS4zJ9cBNfwDAfu4AsaBKCl67xOEgDGGN7IXVOdjWGoO/prSFmiRjI60wMYPPDWEBnJhOwkmLJP8E1jsqrtcKpNMeLdIhrN2zDnIQsT9CYvBwTjx+7jS3ubdCWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767710887; c=relaxed/simple;
	bh=TXja+g84lBFzfCg39Ld0bqd+8DnKMoAmTqWY8UQ3uho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLlN18olE2tToGH54JfryzRSGht8Qrx9mPCapmJtCpP52gN3lfIF1mRCXnkATisOkue1U2m6gEeLe3J3BBywjMyux3LYl1rtTMlxSKP92E402+I+Pd/hdu7I979CjzcD5IMAyd8UcgFF4xEsbw/RSh1F96mj235HSr9WPOM/J3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yVO3ARg7; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yVO3ARg7"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-382fa0dc9f4so2788361fa.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 06:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767710883; x=1768315683; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FtDur45tUpvGHBeODYEpZIXDPSFkzMbSKKzV/vunzJU=;
        b=yVO3ARg7B6KneNv2jXcyykP+XKvGKFrN3SpCHf+qfx+uAQGmXRwS1HGLS+W3x7NY96
         j7rar8kRPIRaZJKYBe4AolaC/HGbVKK+gVuv6EostuaBcFciKkUiZ02melKHUumM9yTD
         8bWeyTB2uXdhX1FrftcTXcn2Guqg1ITC4bDp3+cEGIUUdg2f4yGnjVNGf1KGA3vG/XW4
         ZN6EUY8SW4UvWgY4VM3AOb7AdPUXFPfHew5kGjrLvywuJ7jROCVbHRQ4hLC+gHbtsFok
         WD19GAfGvkviM4QytFnVa/uQWuEUOGNVADjfi+nqzCd6sHfPEkM+ZG0NSPSxMoJozWaJ
         x+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767710883; x=1768315683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FtDur45tUpvGHBeODYEpZIXDPSFkzMbSKKzV/vunzJU=;
        b=uj7BoDUxT7Yeg+NmWgr+VlRqHTetOwSw6eMvf7k44EAKhc5BOLAwzZsQtvADEwMkth
         b5Zupcy2hkmpuyVKFVGF69JED9UyPve9g9XJ+krFsiHyJyHt4MDcccvOhS9Q7sOt4yt/
         v2ZM27dDmpeJ1s07wHdLTFoPoHLToMoJmWcMdheFmAlxamUogpimZvg+jaS2iTvjY1Gw
         WRijKrd2K72O+I7jstvs/f2NB+yh7XPvcfjY/x8R+3TFsOPl57rqagXTTiof+T/eNnLD
         6+9e+mrwPSNG21/aYTyWNMQdY/RsAHdVI+LG9n/m2WeUzSaOnl/QzzDMtgt2wLBGqQHO
         7uTQ==
X-Gm-Message-State: AOJu0YxyG9hszbUdV9FuJ8na9YTIpf0TejZ1QlIEJGtdc6H+0/QLTmtT
	51dkHVpOsgnCgZNTbE3obLLaPhskLHQmtP6aPwQa68liO7/AzBo3eHg0++1VPsh7hQ==
X-Gm-Gg: AY/fxX6dgrykZnJiBjn+bvRM5D88WSa5gxMgAgqOjih4eFyQedyvZeyRpXf0GSvXK2m
	8LEoT9g6864T3TFnPpfzOJSriGJVCOWLodO9L7ib6IWx0TWX038Lzdgu8TiBZ9bgkwKmPL+NPoz
	QMsl/LYRXYA5ZlJsszWYrfCCL51tMgf+Re1ymJSFftiiNVxKdzdOE4rSD6CyG5RNfRiof/+L2PM
	KS77BJxi5deEJZAsxd7pr+tJ4LwUP29iZ3inlP+hxVeaugjGSRkk4tanhJjnj24iTgp0eLKXo2+
	AvqXCWPYXDN22tDsFXLWOrUODaWqfex0UrTfs5QNKJS29+2+QdjjIwi5YSKsV7Ag2exkvgfzImK
	U+7EqG/hv2n4TY4ZIFGoo05HiV1M14a/Znr5NyaAWlqgg2BqKHwbYPeMjBJtoZKm5VFLKfyZzyX
	+Z2T/D7vOOFax59IutX6vJNUao5TcIz1uGhJNPNnRTENlaQvrcZcbASJIaMDA=
X-Google-Smtp-Source: AGHT+IE+ZL+V7gktGnlm7LVqMvKTrTGnblhmHNM9MbGSbRXG1yK3rUURQTo8Ey8bV8cdhAW0kWdHlA==
X-Received: by 2002:a05:651c:31c6:b0:361:5fa3:1d58 with SMTP id 38308e7fff4ca-382eaa1fda6mr9231971fa.18.1767710883332;
        Tue, 06 Jan 2026 06:48:03 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-382f969cc6bsm1910641fa.0.2026.01.06.06.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:48:02 -0800 (PST)
Date: Tue, 6 Jan 2026 14:48:00 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 10/30] KVM: arm64: Introduce __pkvm_host_donate_guest()
Message-ID: <ocpyeygxhp52jt2mcqq4tmdodubrfdwo4xqvbphmr34x4etrkk@f3ag3a7j5fru>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-11-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-11-will@kernel.org>

On Monday 05 Jan 2026 at 15:49:18 (+0000), Will Deacon wrote:
> +static void handle___pkvm_host_donate_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(u64, pfn, host_ctxt, 1);
> +	DECLARE_REG(u64, gfn, host_ctxt, 2);
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	int ret = -EINVAL;
> +
> +	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> +	if (!hyp_vcpu)

I guess we should check this is a protected VM here, else a malicious
host could donate pages to an np-guest. I didn't try to think through
the implications, perhaps it's fine, but it feels unecessary so I'd say
let's be restrictive here.

Cheers,
Quentin

> +		goto out;
> +
> +	ret = pkvm_refill_memcache(hyp_vcpu);
> +	if (ret)
> +		goto out;
> +
> +	ret = __pkvm_host_donate_guest(pfn, gfn, hyp_vcpu);
> +out:
> +	cpu_reg(host_ctxt, 1) =  ret;
> +}
> +
>  static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(u64, pfn, host_ctxt, 1);
> @@ -580,6 +600,7 @@ static const hcall_t host_hcall[] = {
>  
>  	HANDLE_FUNC(__pkvm_host_share_hyp),
>  	HANDLE_FUNC(__pkvm_host_unshare_hyp),
> +	HANDLE_FUNC(__pkvm_host_donate_guest),
>  	HANDLE_FUNC(__pkvm_host_share_guest),
>  	HANDLE_FUNC(__pkvm_host_unshare_guest),
>  	HANDLE_FUNC(__pkvm_host_relax_perms_guest),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 49db32f3ddf7..ae126ab9febf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -958,6 +958,36 @@ static int __guest_check_transition_size(u64 phys, u64 ipa, u64 nr_pages, u64 *s
>  	return 0;
>  }
>  
> +int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
> +{
> +	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> +	u64 phys = hyp_pfn_to_phys(pfn);
> +	u64 ipa = hyp_pfn_to_phys(gfn);
> +	int ret;
> +
> +	host_lock_component();
> +	guest_lock_component(vm);
> +
> +	ret = __host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_OWNED);
> +	if (ret)
> +		goto unlock;
> +
> +	ret = __guest_check_page_state_range(vm, ipa, PAGE_SIZE, PKVM_NOPAGE);
> +	if (ret)
> +		goto unlock;
> +
> +	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_GUEST));
> +	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> +				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
> +				       &vcpu->vcpu.arch.pkvm_memcache, 0));
> +
> +unlock:
> +	guest_unlock_component(vm);
> +	host_unlock_component();
> +
> +	return ret;
> +}
> +
>  int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
>  			    enum kvm_pgtable_prot prot)
>  {
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
