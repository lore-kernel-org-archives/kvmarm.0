Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793583948;
	b=JVrke6SAf2inv7ayH0ZtkllTW91NUkaxaDpwgLKpBLfht7yNmGsjMhwQQuY1j0Gw0ZkB
	 Pr0O5H0jO5kQISAZxk3us1IQVPrRsLVyLcG11d3K5HVPj1S1hQfL1t9Uihtj7yFzNMyPa
	 4s+vHUMwIh71HYC2r0L05KAcqmyBjzuGYqv0Noz2kRXEKiaEBERjNoTfxc9VpU6rY/8N+
	 kE45Qj59NF2m4K7W10KUq5qr1+llMT4gJhc6hP8mytqEROt7VxvQgnnV6BrWUKAY/d1Uj
	 3ANG66SC5OV2mY+OnknwHdln2r1RxapbjDOjGd0UeO9fx8dq1j0+xhVzclzlQZrEakQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793583948;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=9uLkggi5jeL9sGYQHyTyByYxkgZ/xZRTq5JwmLkTNLA=;
	b=UpQ01HbiJT4/c+F9EEIepVuu/GCg+bO3JHa5ovSB607fRdSOIMD/iJB91GYo0JvUBSHC
	 Dl/9lNRxJpU2nXAesPjNklw3rYR8GENv9Ecu3BHC4uH4+DEV4/je8XaFaZDO+ExPTwW+6
	 AcCo95h90QI6KVUGOevfQf/UR0wo/rpVhYn8OX111o2s7XhymFGU7f74cnvcCRSNoDOm7
	 XwSsZSerfOE0em4jtP/UR2OGt5Jp/D1zKIWSslr/XRF65BiFrRu9Jakcdz28wpzqxIOIx
	 ks/GZX2aNpAw32X90gH2OKAg6pwka0sJ+UW7QCAMLG0P9OUxvR40JTuPGh1SkNABTLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HoplrZB8;
	arc=none smtp.remote-ip=115.124.30.101
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E0E606A32C
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 01:45:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98E0E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HoplrZB8
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793583939; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=9uLkggi5jeL9sGYQHyTyByYxkgZ/xZRTq5JwmLkTNLA=;
	b=HoplrZB8Ir17a8gq+0Um4Dv9B9qGQab9LlnOpq7Gc0nTVwO0ZgshKeHXVJr/KnBnlP+Tr8RSFxPlCtPdFPFsPVUfzSU1w6I9bYWTFgsZS8p4676cjm4hnSwWKEQWuQoi66EzoYavtcRiNHZWRfIKPjDqdalHq3RWk8nayHTdNHY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XDrYjc._1793583936;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0XDrYjc._1793583936 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 09:45:36 +0800
Date: Mon, 2 Nov 2026 09:45:36 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Yicong Yang <yangyicong@hisilicon.com>, Zhou Wang <wangzhou1@hisilicon.com>, 
	Arnd Bergmann <arnd@arndb.de>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] KVM: arm64: Add ACCDATA_EL1 to the sysreg array
Message-ID: <7s5ptzeolghvb6aplrf4cy3kwxeh6hvca5clneexutbvz3u3rr@g5ejdynebrnk>
References: <20261025075138.2919734-1-fuad.tabba@linux.dev>
 <20261025075138.2919734-3-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025075138.2919734-3-fuad.tabba@linux.dev>

On Sun, Oct 25, 2026 at 07:51:35AM +0800, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
>
> Make ACCDATA_EL1 a first-class citizen, and add it to the sysreg
> array. Visibility is conditioned on the feature being enabled.
>

Hi Tabba,

LGTM.
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20240815125959.2097734-4-maz@kernel.org
> [Fuad: rebased]
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/sys_regs.c         | 12 +++++++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7a..5b1cd1f502b7d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -498,6 +498,9 @@ enum vcpu_sysreg {
>  	GCR_EL1,	/* Tag Control Register */
>  	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
>
> +	/* Random stuff */
> +	ACCDATA_EL1,	/* Accelerator Data */
> +
>  	POR_EL0,	/* Permission Overlay Register 0 (EL0) */
>
>  	/* FP/SIMD/SVE */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d7..40f8be41da3a4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2914,6 +2914,15 @@ static unsigned int sve_el2_visibility(const struct kvm_vcpu *vcpu,
>  	return __el2_visibility(vcpu, rd, sve_visibility);
>  }
>
> +static unsigned int accdata_visibility(const struct kvm_vcpu *vcpu,
> +				       const struct sys_reg_desc *rd)
> +{
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
> +		return 0;
> +
> +	return REG_HIDDEN;
> +}
> +
>  static unsigned int vncr_el2_visibility(const struct kvm_vcpu *vcpu,
>  					const struct sys_reg_desc *rd)
>  {
> @@ -3601,7 +3610,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
>  	{ SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
>
> -	{ SYS_DESC(SYS_ACCDATA_EL1), undef_access },
> +	{ SYS_DESC(SYS_ACCDATA_EL1), undef_access, reset_val, ACCDATA_EL1, 0,
> +	  .visibility = accdata_visibility},
>
>  	{ SYS_DESC(SYS_SCXTNUM_EL1), undef_access },
>
> --
> 2.47.3
>
