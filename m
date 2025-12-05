Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FCB2F363A
	for <kvmarm@lists.linux.dev>; Fri,  5 Dec 2025 06:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764915921; cv=none; b=mMRU8MuWeZR3/ZT5lZs7r6WtfZVrSBghSGZe01DXhhzdIvpmZktp+TTbQyAD2WsTKbDxV3Up9E/ohWzLVm8pQ1FhiO2QvNIBi3FP2JAFrfdMFo1f7gx5TLZbB9LaOpEA92V38rX2C5mr8Tf1s/j1AqR+Q3hzaaqnasAPN1jx4Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764915921; c=relaxed/simple;
	bh=0FpdJeGy3Q0ZrF6Dc/ArhnOePdc5iqrV2NpUYVBM9Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUiHPTZgWHY/nFqHFy0fDuvCEkAI6WHv8V1XYhghRCqnY7CFz305MyYk6Os69Ndzunavc1M4O5JBe82FVcyQBns+d5e1bCls4b5+74ifKW0jIwtj1Vpin2v6QAKuUBVMDqRxaD7rlFSIIjgMIloR1x0PCTi0PtPlFhtF/tMYD98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EANK0zxv; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EANK0zxv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764915908; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=pOM8ESUhCgXHF3aPTqSUKOu9YbGu/eNZGcUrooc+AG8=;
	b=EANK0zxvKNJhZUt+SpGFFeSl/OGbDVUGnvQlM+fVpzM0O9H1zOQH+NF8DfaIemH9f3lMjHojCmMC77c49Zy7OoKlzUVK2D53U43aqM/8OCLtKL7s7NMudJFlAGlFy53NwoLHxP/Dqpwqvjyl/rh+6CNQoXMk00ydT50mQPUpfaw=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0Wu6x.ch_1764915907 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 05 Dec 2025 14:25:08 +0800
Date: Fri, 5 Dec 2025 14:25:07 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v3 5/9] KVM: arm64: Handle CSSIDR2_EL1 and SMIDR_EL1 in a
 generic way
Message-ID: <csa7ttcducyjm5z7tdnw7kimry7obkhflo4zknenw267b3shlp@t37ltcp6flps>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204094806.3846619-6-maz@kernel.org>

On Thu, Dec 04, 2025 at 09:48:02AM +0800, Marc Zyngier wrote:
> Now that we can handle ID registers using the FEAT_IDST infrastrcuture,
> get rid of the handling of CSSIDR2_EL1 and SMIDR_EL1.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ec3fbe0b8d525..ae1e72df1ed45 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3399,8 +3399,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
>  	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
>  	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
> -	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
> -	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
Hi Marc,

I checked the arm ARM to make sure these 2 belong to ID space.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  	IMPLEMENTATION_ID(AIDR_EL1, GENMASK_ULL(63, 0)),
>  	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
>  	ID_FILTERED(CTR_EL0, ctr_el0,
> --
> 2.47.3
