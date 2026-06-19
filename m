Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AB240D561
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 13:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781875926; cv=none; b=d0IlbvhNH4tbMRCnwjvb7JYloWxXO2z2LAYIBoulrjKq+B59ERLbzPII6bs7/YsCZWufKLdsnwfvn9UQRnQGleMYTFyYaYc59G4slo1uKMBHhQ1r+nAnyQEVK/yzglMJ9X0SZw9yuVj1/bsDXFlvG2HQIRmYhJMxawVLRHYZLDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781875926; c=relaxed/simple;
	bh=Hq9ey9uzs+3MJ9Yw4ltOLbUxORnNpSEbpKgD6w0aGrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXidJbuOAZA6oa47I4dYVoWoTFrQLAcKJrVkFzhubinGH1eJLqaBCcN15sBQ/m2fPKJ7MRF6ZmiGRLvSYBn4fMd7cozb6F6WKNkhAX522sljW0eJ1x2j+V9F6B7offfinI+TKDvFir3Ind7pfmett9kjxCz6JfLm8uEy0Tb+qqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DVTbPuhK; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DVTbPuhK"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-462bb734793so1529266f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 06:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781875924; x=1782480724; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IAgiiNcrQNm379JlHAgcT50PxnyZ9fON8VGxnlQuPrI=;
        b=DVTbPuhK+xBX32fTeOPtGl9SR8ZYzTQEV364dI7MgVn+b2AFsVz0JdgBRCPF0kBMjw
         ejWsFcZuh7B1XbkDJTjavuZTvW1o+3rVqPZEVzYiUbtXsKeC+lRywvUrgG7BACC/SUxU
         28b2M+2VWlgSjftbZzLC2XB4nRhLC0FcJr3+x7Ufyprc+7AIxpKGNgc316lmE8b2m3w2
         Hfcc1tHaTEgDvuINmsamX+8kHuC7i5ykkhxHg8fDDlH9Ki+zY5HdHGbxnOPuyrERMRxa
         X5ICho3X8tuTpqgRbEBvRWimLjppxU+Dn8PKEn3bWXlw4fLsSltRlxq6MqeSJ4xmt0y7
         qxSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781875924; x=1782480724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IAgiiNcrQNm379JlHAgcT50PxnyZ9fON8VGxnlQuPrI=;
        b=Ih5YeGP3dXB3XLz4n0ZO6PQWj0Q0Gpi1R1y1oJOtF//zoc3fTVBBLR5O4Vm0RMehhP
         VH7Hr5gFRvHa4ggSUF1DS3a5O+iD7EpDMVVVV6U/Gdks+x9m4UcgWvdbDVBdlvQCB//L
         KfwcgIIS498xjvzBS+WVC2DWn54DmLC5W2nK7J7R6dcQb2vytmwZTg5gghu/y9elnjzZ
         +Ij+3EVCjK4g89wuHbuLZrLjJ9RvOAwNUYDRW40BhUjaaKdimiv9JwvDdNt9uHcccYhA
         Ahm/Hb+ddG+YK0J4YEWN0lUpWeN0IPH5Jn9+ueLBmMCRqC/0Z2LTtamA6pv9dtmcNq72
         7nXQ==
X-Forwarded-Encrypted: i=1; AFNElJ86v4h+EzqghbzDqEnbQfw49pO27rcqeyT7V6yhM4YweCT5SEHL0gydSDMkYIAXCnm2gnNtBPk=@lists.linux.dev
X-Gm-Message-State: AOJu0YycAbmheSXkomEmoEDgf4tdGBMNBJ5klUi0XTOi9v81jd2HL5tS
	UG4RQ5WIF8GUu0ic6jCNtQZPblDnoCcs4uivr/gJuHSXJrqu2FO28yjUsGllL0g1tQ==
X-Gm-Gg: AfdE7cm0QaMceuU0GvPcHtbEhMvrcPNERIWlo+rua2iQIk+n3KXWOuijwCzgb9r3Trz
	yzWFfXH+NCwUpN+IwoFQy0+8iOEnGyl+snqEK37PfVdoZv2wPBSDF40i6nc8cWv3f5TkmaJgSlF
	kYRrJutPlJcNKpZLe3FxLHc4u6R2sqFr536GEsX68KhzWiVtD69ZYIdUT4qPSJ3RKwhykZXEu1C
	Lq5x3S51xng9BoGo3zH+xIViaBwN5M6lMoGks1UWwWkfzEdu1pLHs2V9Tj9gvhtgUVE/tRYACre
	ohnKN80wZC75myJ9F9eEb8rsnBP/C5aVD+ygllvYUClIBwqYQ91dLq7/Z3TYoN8SWm489cxzcdA
	zPMOoYiGUbkiWqU/Eci55y/ExAh2KCGJdFAdUvxl9esQOywLZMea/bLP88m4LKXecLzneBunO7a
	C3P/cEVQ8mK9oW5xyz9RLfiBv5+sUnCfIu71zesbQh5WZG/YOtks9QKzEv
X-Received: by 2002:a05:600c:21c4:b0:490:ce99:d2ee with SMTP id 5b1f17b1804b1-4923f437203mr47993525e9.15.1781875923118;
        Fri, 19 Jun 2026 06:32:03 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46508a04b55sm8348813f8f.5.2026.06.19.06.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 06:32:01 -0700 (PDT)
Date: Fri, 19 Jun 2026 14:31:58 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: Re: [PATCH v2 5/8] KVM: arm64: Add host and hypervisor vCPU lookup
 primitives
Message-ID: <ajVEzllsP9OIswhS@google.com>
References: <20260619070719.812227-1-tabba@google.com>
 <20260619070719.812227-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619070719.812227-6-tabba@google.com>

On Fri, Jun 19, 2026 at 08:07:16AM +0100, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> The nVHE hypervisor repeatedly resolves a host vCPU into the EL2
> address space and validates that the loaded hyp vCPU matches it, with
> that logic open-coded in each handler.
> 
> Add __get_host_hyp_vcpus() and the get_host_hyp_vcpus() macro, which
> translate the host vCPU into the hypervisor's address space and, when
> pKVM is enabled, also return the loaded hyp vCPU if it matches. If pKVM
> is enabled but the loaded hyp vCPU does not correspond to the requested
> host vCPU, both the host and hyp vCPU are returned as NULL. Convert
> handle___kvm_vcpu_run() to use it.
> 
> No functional change intended.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 52 ++++++++++++++++++++++--------
>  1 file changed, 38 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 1d01c6e547f5..8923f594c264 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -212,14 +212,45 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
>  		pkvm_put_hyp_vcpu(hyp_vcpu);
>  }
>  
> -static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
> +static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
> +					     struct pkvm_hyp_vcpu **hyp_vcpup)
>  {
> -	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
> -	int ret;
> +	struct kvm_vcpu *host_vcpu = kern_hyp_va(arg);
> +	struct pkvm_hyp_vcpu *hyp_vcpu = NULL;
>  
>  	if (unlikely(is_protected_kvm_enabled())) {
> -		struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> +		hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
>  
> +		if (!hyp_vcpu || hyp_vcpu->host_vcpu != host_vcpu) {
> +			hyp_vcpu = NULL;
> +			host_vcpu = NULL;
> +		}
> +	}
> +
> +	*hyp_vcpup = hyp_vcpu;
> +	return host_vcpu;
> +}
> +
> +#define get_host_hyp_vcpus(ctxt, regnr, hyp_vcpup)			\
> +	({								\
> +		DECLARE_REG(struct kvm_vcpu *, __vcpu, ctxt, regnr);	\
> +		__get_host_hyp_vcpus(__vcpu, hyp_vcpup);		\
> +	})
> +
> +static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
> +{
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	struct kvm_vcpu *host_vcpu;
> +	int ret;
> +
> +	host_vcpu = get_host_hyp_vcpus(host_ctxt, 1, &hyp_vcpu);
> +
> +	if (!host_vcpu) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (unlikely(hyp_vcpu)) {
>  		/*
>  		 * KVM (and pKVM) doesn't support SME guests for now, and
>  		 * ensures that SME features aren't enabled in pstate when
> @@ -231,23 +262,16 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
>  			goto out;
>  		}
>  
> -		if (!hyp_vcpu) {
> -			ret = -EINVAL;
> -			goto out;
> -		}
> -
>  		flush_hyp_vcpu(hyp_vcpu);
>  
>  		ret = __kvm_vcpu_run(&hyp_vcpu->vcpu);
>  
>  		sync_hyp_vcpu(hyp_vcpu);
>  	} else {
> -		struct kvm_vcpu *vcpu = kern_hyp_va(host_vcpu);
> -
>  		/* The host is fully trusted, run its vCPU directly. */
> -		fpsimd_lazy_switch_to_guest(vcpu);
> -		ret = __kvm_vcpu_run(vcpu);
> -		fpsimd_lazy_switch_to_host(vcpu);
> +		fpsimd_lazy_switch_to_guest(host_vcpu);
> +		ret = __kvm_vcpu_run(host_vcpu);
> +		fpsimd_lazy_switch_to_host(host_vcpu);
>  	}
>  out:
>  	cpu_reg(host_ctxt, 1) =  ret;
> -- 
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
> 
