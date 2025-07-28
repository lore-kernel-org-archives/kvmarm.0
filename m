Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EA9272E7F
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753717127; cv=none; b=KqkBTMLqmcDZecIP59tC5KJLWIuo6FJ4atAOMSYvqvPsYDMP+fNceB3o8i03Q87bbz2/dsbLQSw6PQzSgeSq0kw56KvBEfXmzvtyAsn6OKZZWFjCFRoxRY9WXx/bD76pL54RaHsWYjQwAtHH4KDsNNhzTLG89OJBn3VGzW+X/gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753717127; c=relaxed/simple;
	bh=aLqhT21D05X5tUAM/Tre2xIEH65eXqzR5N2lYQFTYjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LnnYMhiNOwRqnPpsVULg4AYrqmmwF3K728cU+pYkx/Dob2lfH1coJn9Iq339nYDdl6hVieozdjuyRSFYKabGcFlbanZZJrf2u0A69d4gOtuzq0+rK2sx3fV57xCXNTHOLU1Jt/MTNMVxOPwUgJzaE8jTLBr8/Fu0MzUO1Lm6pm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xk7RlCyw; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xk7RlCyw"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5561c20e2d5so6254926e87.0
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 08:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753717123; x=1754321923; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rNLH1XGynTNpYBFmaK8XIye+5/rKMPGnnVK77mDGOUE=;
        b=Xk7RlCywgNr262fUR9gBwtcrJBbgHdsbAeL0JAOC1UA5dt714Xez4bMxOBPjRg1BCH
         uvp++SM/RRFotkhiz11jY4slyWhZyFKEZ3bN3vBfBJZcrQJN8umltPDfsT2d9JqPxq7s
         HiYfeGlqdn9aGPP/Ocpnx8jp7yL1J1Y0a+7gL8Bo4PhUa4M2U8C+xa1CL2rGLuy6DH1I
         1j/h3XrBTjN1Ln/74xkM8wH5I9ml8ZcmhzKAaxcTxrr2qK+nmDvSy92nh5VQLytYV1G1
         I4ZnRKnB9/GE6mxdztH5497XyKDw0ccv9EeLtUPudcgrBR4ss+YCGo3qI/VLdBujN+iP
         3R4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753717123; x=1754321923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNLH1XGynTNpYBFmaK8XIye+5/rKMPGnnVK77mDGOUE=;
        b=f39u/R1RAVLdjQ9/0v1Wc/cNipiIaZM2Mu0EAe9+x0+/sBsM8vS9f8nfEOItTUPbwX
         cwa7ltmRGxC9FAZoepoCIhHaXJO9IGvvWVmBjxTmMV+SXJ8N+teY04JWX4zrMKpTvSgx
         f3QJpIpJJ0x/tJ9qKsuUBd8zLhRJEltCsnZkJkUHB7XM6HdxCQ1YogOEbbbK39p9R7ET
         KQM9OiPutR+yGGQ9EB7Ok92cDEAr0xGHwjHX08+Q/y2ES5plzkxlq/xABv3KCM24XzfO
         WWPLrDgjulfhgLwrvISKMXuB/L6zhkMWwvq3HXze1xbkPKCpcwmkR61aZivpAEWTkqGE
         EAyg==
X-Forwarded-Encrypted: i=1; AJvYcCUyJKrzbWHHdt+xtvMna4pIn4QZ2M4weBgJfgHXTOd/wHcui4lKC+zDxq2zNn5u0tOEeigwEjs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuU4hJ+IDqZGG3kKxu1sh2pmQQteZSE1Kclr+MCxavbIHjxwC5
	/n9cUYdslxs0+C/tmuj7EfxeWZxc3/sP9sFQNLbPK10SXP7utmTrLmh4UEHwu95SCQ==
X-Gm-Gg: ASbGncs+wi7StKXAOCHIKb4B7Ba7EJ+yYdcPlEnAqOaxza+3T4CXm2RZ9RHTsr5YXfc
	BtAsDrjvjr7SQHrfNioGyem7O8J4x+lXpyIHxU+Xj0857PLDGK2wEaveoucBNtCbgC4u7h0W+em
	bb9V954j77WRxJiqGy0DfII7NQDBHm0pG22cSyWIv0qIhvGwuhQcd/lbzgfVEWQAcRqCUhEJbB0
	71e2n4J1oYDecGbj7uZlMxutVS8k3FhbJLQQq/67NwiQ6aWDWw02Gzg10auoEq8aW0Oqq9g7j96
	JzGtTonaxVwLitBNkHQEBe9pwNxi60xgS4HB3+1Xw69DKzNnItWcJ6vnUhbFXN5KS6bJuIyydTx
	0dNDOStbOCFFAvsYBmARHOaE4hHeIBonUnZXhIDti5cYVkithBU6AlJ7S1P0LPA==
X-Google-Smtp-Source: AGHT+IH6F0Hy391rO/cn41nSe03RC63gIk43a9xDAqTl5D1CjpIWHOxWG5o4zt9CXrYkBVmu/NZp4Q==
X-Received: by 2002:a05:6512:2242:b0:553:d9ba:a171 with SMTP id 2adb3069b0e04-55b5f4abb6dmr3149291e87.43.1753717122920;
        Mon, 28 Jul 2025 08:38:42 -0700 (PDT)
Received: from google.com (103.245.228.35.bc.googleusercontent.com. [35.228.245.103])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b63363a80sm1316646e87.85.2025.07.28.08.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 08:38:42 -0700 (PDT)
Date: Mon, 28 Jul 2025 15:38:39 +0000
From: Quentin Perret <qperret@google.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, "yuzenghui@huawei.com >> Zenghui Yu" <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, vdonnefort@google.com, 
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Ryan.Roberts@arm.com
Subject: Re: [bug report] KVM: arm64: Add a range to
 __pkvm_host_unshare_guest()
Message-ID: <qos5jspmx6p7js3eflgrv62ocn5guhoaqoz7pnlsn5ylkjlusk@klq26b5l7wdz>
References: <17b526ff-b824-4c24-8ac0-6821e5cc8900@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17b526ff-b824-4c24-8ac0-6821e5cc8900@arm.com>

Hi Ben,

On Tuesday 22 Jul 2025 at 13:59:06 (+0100), Ben Horgan wrote:
> Hi,
> 
> On trying to boot a pkvm guest when using transparent huge pages I see the
> crash below. I'm using v6.6-rc7.
>
> kvm [141]: nVHE hyp BUG at: arch/arm64/kvm/hyp/nvhe/mem_protect.c:1088!
> 
> It looks pkvm_pgtable_stage_relax_perms() can be called with a block mapping
> but in __pkvm_host_relax_perms_guest() it assumes page size for the
> assert_host_shared_guest() check. With the following patch, I no longer see
> the crash:
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 8957734d6183..52c802da4172 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1010,9 +1010,12 @@ static int __check_host_shared_guest(struct
> pkvm_hyp_vm *vm, u64 *__phys, u64 ip
>                 return ret;
>         if (!kvm_pte_valid(pte))
>                 return -ENOENT;
> -       if (kvm_granule_size(level) != size)
> +       if (size && kvm_granule_size(level) != size)
>                 return -E2BIG;
> 
> +       if (!size)
> +               size = kvm_granule_size(level);
> +
>         state = guest_get_page_state(pte, ipa);
>         if (state != PKVM_PAGE_SHARED_BORROWED)
>                 return -EPERM;
> @@ -1100,7 +1103,7 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct
> pkvm_hyp_vcpu *vcpu, enum kvm_
>         if (prot & ~KVM_PGTABLE_PROT_RWX)
>                 return -EINVAL;
> 
> -       assert_host_shared_guest(vm, ipa, PAGE_SIZE);
> +       assert_host_shared_guest(vm, ipa, 0);
>         guest_lock_component(vm);
>         ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
>         guest_unlock_component(vm);

Aha, indeed, that looks broken with CONFIG_NVHE_EL2_DEBUG=y...

Your patch has the correct approach, but we have the same issue in
__pkvm_host_mkyoung_guest() which needs s/PAGE_SIZE/0 too I think.

Thanks for the report!
Quentin
