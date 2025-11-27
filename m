Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780E127A45C
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 05:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764222777; cv=none; b=kHoB5Sd8x4PJ2GwizILMNF+SY1iFllSKiftcNQaTaMIdaH1Ozd7AgpkWVUXnZwgxlPDuy8glDFU+WOPNE/eptX8UHmkxkkrel5NsFjh0Ci6fP+NhNazKOsOPFjYOsC9Pkf0zvsHdDpUB+IAehod4uWgXSuEHuAECgDRumyX/JdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764222777; c=relaxed/simple;
	bh=ISAFkZ0HmitTgmmDConEYXzcz7D+u6fWEkB3O+gmCY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TguQh7cInCBYnqim1zL9ErfSLr5WxXOCyKKM7vGWaJ/zhq/aggOi0/h39u8YteKmOQBtsUmY9qsS7DdGthHrgxRzQl7Ho9lQomErny2XRHPisOuWvUxw3mTa8J+fMSVH1c0MK0mkwuakaslicVV3i71ZbHcQVd+yEB8cyhX9+Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HGkNCLD3; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HGkNCLD3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764222764; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=8n0RK31A+ec3zN8vE8zvo+3qlTZfSr6qORtM7xzltbs=;
	b=HGkNCLD3LPQ5CZf0cKx3a5ucoQrgHAF4bgPZ1MCS5+Pt48TuPJML98cpgIsXFVZ8El+qbCW7dYkgeIwQ+NGDj7kehDmHBptCYRs8mxBM6HEdfOudS1cCLLyTk0abDWI0fNKe0NpnX5SoYj94bLg7yotEdIbtcMuMs8Q/lqMWmcc=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WtW0l1z_1764222762 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Nov 2025 13:52:43 +0800
Date: Thu, 27 Nov 2025 13:52:42 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: Force trap of GMID_EL1 when the guest
 doesn't have MTE
Message-ID: <itxexyotztmtvuvcbs4wjcdod3tfpufqe5t2gmz6vyky3vtihs@a3atxxjadgfq>
References: <20251126155951.1146317-1-maz@kernel.org>
 <20251126155951.1146317-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126155951.1146317-3-maz@kernel.org>

Hi Marc,

On Wed, Nov 26, 2025 at 03:59:48PM +0800, Marc Zyngier wrote:
> If our host has MTE, but the guest doesn't, make sure we set HCR_EL2.TID5
> to force GMID_EL1 being trapped.
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9e4c46fbfd802..2ca6862e935b5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5561,6 +5561,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
>
>  	if (kvm_has_mte(vcpu->kvm))
>  		vcpu->arch.hcr_el2 |= HCR_ATA;
> +	else if (id_aa64pfr1_mte(read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1)))
> +		vcpu->arch.hcr_el2 |= HCR_TID5;

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
>  	/*
>  	 * In the absence of FGT, we cannot independently trap TLBI
> --
> 2.47.3
>
