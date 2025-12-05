Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7914286A9
	for <kvmarm@lists.linux.dev>; Fri,  5 Dec 2025 06:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764914584; cv=none; b=dHRo+iR5ewj9oK2QvfBGRHEpY/o3Al9AcMTV+QGlx9ptGJrxuQmyDR2iMOSu34gG8MgkK/zkKEUEyrrciG/6/VVjdzYdUu9JfOwkmZm5sL76rH0hXewfOSEsV5EzxgZxvJSlewj45z6AOXr8R81iKwz5tzx/7AbmZU+6sR8jJ3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764914584; c=relaxed/simple;
	bh=L1CiO1rK2mXY9kEcjCfxk6MEVgo37ZeR+IQVh7VQlmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5RWh53l0xC8lOHG36+oYdC8w1dJPMu+YsAsBlb5fJ1hNCJDNvNMx6afG88nGTnAupXukgTl0hGl0759t8rV2aMXL0cT1kTkHvfWSYKb5evmT3gMOBBhUYKdtElKkhSygbqWilyZZra4B1VqNlpWsMRM5YktKpgW5wUdJIjaaIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=K9x7KRnW; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="K9x7KRnW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764914572; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=zIo92LZ9GBEyQzV+BFKrFnfKVkO6IQsZzGx3HuizYL0=;
	b=K9x7KRnWZEIJ5GC/6iD2bLn25ZlrWZcWTss+O/eb3QEnUiiVFWcJLX0yQBBLO0E7DMjuSdvT+kqP+fxiadbbDYIGne9znYCoSgqxehSThdQrqstnx1kj6dsxv+MzwQEJvmugpaGSojeomX51i5B+rdRSNj0tpcJ7EWMEH4uwELA=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0Wu6mAy7_1764914571 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 05 Dec 2025 14:02:51 +0800
Date: Fri, 5 Dec 2025 14:02:50 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v3 6/9] KVM: arm64: Force trap of GMID_EL1 when the guest
 doesn't have MTE
Message-ID: <3v4gqr3eghu6gcruhhp2255pqq5s5nsaaowobaaqecpkp7an5v@vrntb3ggwecp>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204094806.3846619-7-maz@kernel.org>

Hi Marc,
On Thu, Dec 04, 2025 at 09:48:03AM +0800, Marc Zyngier wrote:
> If our host has MTE, but the guest doesn't, make sure we set HCR_EL2.TID5
> to force GMID_EL1 being trapped. Such trap will be handled by the
> FEAT_IDST handling.
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ae1e72df1ed45..2e94c423594eb 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5558,6 +5558,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
>
>  	if (kvm_has_mte(vcpu->kvm))
>  		vcpu->arch.hcr_el2 |= HCR_ATA;
> +	else
> +		vcpu->arch.hcr_el2 |= HCR_TID5;

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
>  	/*
>  	 * In the absence of FGT, we cannot independently trap TLBI
> --
> 2.47.3
