Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A0822F772;
	Fri, 14 Nov 2025 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763137500; cv=none; b=bWgNGM3MVVAPtG39wOJURbGQN/dXBbY27imKkQ2MU6GXycy7j5APucarmnu1lbbx4SQwudazy0zeGqZ9ZmupBYeChdAnfICJh9JwLseRh93Orb6l3YMIAOt4nQk4BAdTFxChANjIKFIl6ZJCYjs9THhO+CZFSB8MDVJ22MhITPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763137500; c=relaxed/simple;
	bh=9ADDlwiObOzy6aRdDxf35MgMRl6YQt/8mloSpSA44HY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjyG08q7cHcGDRPpmiTLIoEMLCF/XZs/jyfxJuISAVaaCABMbK/QpQlG773oJy9YLA1+hgANjyQjHx9xVBA/P/f+2vJCu7XduJjMl122hWu1KxsjBJPOHFy9m6FlBuarPMOrHRiwYtX+V5HXy+kYfeHqBnGv5t9Fgj8BYwzdXuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l5mJIe1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l5mJIe1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA69C4CEF5;
	Fri, 14 Nov 2025 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763137499;
	bh=9ADDlwiObOzy6aRdDxf35MgMRl6YQt/8mloSpSA44HY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l5mJIe1DWlBXSMgELsnOTYDVlb5JEtqKs3y0KjBE5zQgrbn7GM0bSKHJ7mXten+WS
	 ZZthJR6fmmcDceL3yMb1Yc0iMdf6N2HCQvJZPK75slYDXD2spgYkkCTnWNc7cbClDS
	 VKM2/2f0Ji8KcB/cce0d65t0G0A8IG35ced5I3aq5WvU0vwdU17xrxJffNdAYaYlzm
	 HEQkSM+EdT9qumGnQLZxmCeotn8GAltCR31E3I0TOpJs31J1hyksakve3zuoAACkl1
	 SPwLSaNbORtMZu2+IDPWja5nvV+RrrthXZBBM2TKomzmEJeEMBFSy1SJrFBOCoxYIV
	 F0yUmTwUjMfgw==
Date: Fri, 14 Nov 2025 16:24:53 +0000
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, perlarsen@google.com, ayrton@google.com,
	ben.horgan@arm.com, sudeep.holla@arm.com, stuart.yoder@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: fix FF-A call failure when ff-a
 driver is built-in
Message-ID: <aRdX1YM0Y8WMP05w@willie-the-truck>
References: <20251030102245.2313898-1-yeoreum.yun@arm.com>
 <20251030102245.2313898-2-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251030102245.2313898-2-yeoreum.yun@arm.com>

On Thu, Oct 30, 2025 at 10:22:44AM +0000, Yeoreum Yun wrote:
> Until has_version_negotiated is set to true,
> all FF-A function calls fail except FFA_VERSION.
> The has_version_negotiated flag is set to true when
> the first FFA_VERSION call is made after init_hyp_mode().
> 
> This works fine when the FF-A driver is built as a module,
> since ffa_init() is invoked after kvm_arm_init(), allowing do_ffa_version()
> to set has_version_negotiated to true.
> 
> However, when the FF-A driver is built-in (CONFIG_ARM_FFA_TRANSPORT=y),
> all FF-A calls fail. This happens because ffa_init() runs before
> kvm_arm_init() — the init level of ffa_init() is rootfs_initcall.
> As a result, the hypervisor cannot set has_version_negotiated,
> since the FFA_VERSION call made in ffa_init() does not trap to the hypervisor
> (HCR_EL2.TSC is cleared before kvm_arm_init()).
> 
> Consequently, this causes failures when using EFI variable services
> with secure partitions that rely on FFA_SEND_DIRECT_MSG.
> 
> To fix this, call hyp_ffa_post_init() and set has_version_negotiated
> during hyp_ffa_init() when the FF-A driver is built-in (CONFIG_ARM_FFA_TRANSPORT=y).
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 4e16f9b96f63..0ae87ff61758 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -984,5 +984,17 @@ int hyp_ffa_init(void *pages)
>  	};
>  
>  	version_lock = __HYP_SPIN_LOCK_UNLOCKED;
> +
> +	if (IS_BUILTIN(CONFIG_ARM_FFA_TRANSPORT)) {
> +		hyp_spin_lock(&version_lock);
> +		if (hyp_ffa_post_init()) {
> +			hyp_spin_unlock(&version_lock);
> +			return -EOPNOTSUPP;
> +		}
> +
> +		smp_store_release(&has_version_negotiated, true);
> +		hyp_spin_unlock(&version_lock);
> +	}
> +

I don't think this is the right approach.

If the host starts using FF-A before pKVM has initialised, then we've
got bigger problems than the version because we have no way of knowing
which pages have been shared with TZ before we initialised.

Why can't FFA defer initialisation until after the proxy has initialised
when pKVM is enabled? The fact that the driver is modular indicates that
this should be do-able.

Will
