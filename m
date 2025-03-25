Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC3B25D204
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 16:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742919666; cv=none; b=tretY3PiOuqcMBF50KZJi0x4VfNIsfGk0SQmnUFKq3Ld50CdYRxTdNo8wsdECnscphvl/dl3x/pQtFoatTKr2N0lNA1RagScYdhJja8QtKb00TMrTiFFTsKzhtZBhqrEmajLV+Mn9sxTqIQLH4PelOwyxCJNL1+g/kZqGPQvaG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742919666; c=relaxed/simple;
	bh=1qXbnHV2qk8Y71BXOizilDEhNN/aAPZZl8nOTeF6WC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pGbCdLjPw4ofBaWtBK/gATeLNQpexu6ChoN3FYgPcxC0V0vZ14P6sSghFyFzUeFaSVNe3WAWuwSsHDuzgPOXaTw1DEZwlQWMH/Gf3LcmWymFVQxyqopx08YEwuSun3QKMAdJEh3l2xrLFyX2pxfsrsp81XITRmUz4hvVyMVxY00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M4LypvG3; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M4LypvG3"
Date: Tue, 25 Mar 2025 09:20:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742919661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kH82AWI1DJslhjV0Iug+U9xXkzn8ELqhzK9jzJCrPWc=;
	b=M4LypvG3T8toQIUrvERxsZVnUA5+eQ36UPuhS1X6f5JNdlprDLSjniBaiyNKYW/UgQNwIX
	eaeymRtM4z2Z91mNNqyzNY04RHsh9LpwE+ReNtxrxuPKxKUb8drKWRY5bUZFMHYeAGsQU/
	yf4+4dAga4Sy8JusJswBXqZ5pWyO6y8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jinqian Yang <yangjinqian1@huawei.com>
Cc: maz@kernel.org, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com,
	shameerali.kolothum.thodi@huawei.com, liuyonglong@huawei.com,
	jiangkunkun@huawei.com
Subject: Re: [PATCH] KVM: arm64: Make HCX writable from userspace
Message-ID: <Z-LX5H5mjGyTQ9N4@linux.dev>
References: <20250325121126.1380681-1-yangjinqian1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325121126.1380681-1-yangjinqian1@huawei.com>
X-Migadu-Flow: FLOW_OUT

Hi Jinqian,

On Tue, Mar 25, 2025 at 08:11:26PM +0800, Jinqian Yang wrote:
> Allow userspace to modify guest visible value for HCX in
> ID_AA64MMFR1_EL1.
> 
> Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>

This is fine, but I would rather we handle all the features like FEAT_HCX
instead of a trickle of one-off patches.

So, could you please:

 - Identify all of the features that describe an *EL2* feature which
   we've exposed to non-nested VMs
 
 - Implement patch(es) to make those fields writable (i.e. allow them to
   be downgraded)

 - Add corresponding test cases to the set_id_regs selftest

Thanks,
Oliver

> ---
>  arch/arm64/kvm/sys_regs.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 82430c1e1dd0..b105f156bdf6 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2666,7 +2666,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  					ID_AA64MMFR0_EL1_TGRAN16_2 |
>  					ID_AA64MMFR0_EL1_ASIDBITS)),
>  	ID_WRITABLE(ID_AA64MMFR1_EL1, ~(ID_AA64MMFR1_EL1_RES0 |
> -					ID_AA64MMFR1_EL1_HCX |
>  					ID_AA64MMFR1_EL1_TWED |
>  					ID_AA64MMFR1_EL1_XNX |
>  					ID_AA64MMFR1_EL1_VH |
> -- 
> 2.33.0
> 
