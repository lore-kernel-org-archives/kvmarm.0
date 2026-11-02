Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793584259;
	b=43gPoCAxeP17UjAHLJjrM4s0Zlo8Em8ir2/CDqPG//esN3zZJT+FE9oPYwUAZn3oZRZb
	 BPEmsi6t8egLLL24pCFyFlQru4yMYueDZXIPNei2lKWfVJ5YVb0ha8PuJADKraVlg1F2/
	 7/p1xDcno2l2TTNan/xg3AlYp4m48NHQoAEvQK+gMLnMfvGfv4ZiuDvXGGAjOjyNq3XnH
	 X8movZDeNos97IQ0J67HaO0s9Qlqi2EayRofxVjtsX+E4c/K6JvLFMK5eiJ4W2drkx64O
	 J7b6icLDi3A6nVfFyg+fPxNfGvdMlZgZCTCP6MSmde0vDRxryWJ4Vm8tub/hy7YJkfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793584259;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=uyg0B8ei3Mf4zbb08LWnZuHIxG8bAH3PwXAWr4Dyrgs=;
	b=iTuHyWHwZHiF8qgtvfCNz+2J6Jyb/C4ffd+fUVLUHsi09hMcttN5rJErKFKUtxd16iVO
	 dz+qdyk6RAQY3OhR+C2tYVz56g1JyCmf9D/rkugfgQMOIVK4GrDE7vtX+9yccF4mqkxFC
	 5jluzs9/Vw3OvVhRsxxhWEUdMAC7C9502ZEHY7Gn4MgoH9m4eYFnLs1KCSygarc5/FTAc
	 oDKHLLSWCpcjOf8Z4BMipRssetU8ci69V5+ieJ1mXNqPu/zOqYRA8zxqkMMoEDoVaBz9C
	 GwDtsQhbvFKkqveh8d5x+i5xKCuycvyw65HCFOJJK7sDvz5adK/+rYQNbmvCaKENgkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=p+FKN8ot;
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE52606A327
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 01:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BE52606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=p+FKN8ot
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793584250; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=uyg0B8ei3Mf4zbb08LWnZuHIxG8bAH3PwXAWr4Dyrgs=;
	b=p+FKN8otQ7xNVORWIWqYsvdNoNKc9aHVvDhE8BxQigmE7QaEh3zcrvp/Vjy2mcSOriHJ7dmbUuYLRF0Co+lFvEkDBSa8aa0jdTeQE4gkrJp2QktV39UN/Bs4N29/pDccklShLZDv61Wkzm/gYmhakvjUT1wrj8wQ9ePUkpwiLxY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XDrTvp6_1793584248;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0XDrTvp6_1793584248 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 09:50:48 +0800
Date: Mon, 2 Nov 2026 09:50:48 +0800
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
Subject: Re: [PATCH v2 4/5] KVM: arm64: Enable ST64BV0 for guests with
 FEAT_LS64_ACCDATA
Message-ID: <qqspcqmrtdx6xj4efvaq6v36pmz7xks27dzev2qqmovq3kw6jp@vn5yptbp7hfs>
References: <20261025075138.2919734-1-fuad.tabba@linux.dev>
 <20261025075138.2919734-5-fuad.tabba@linux.dev>
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
In-Reply-To: <20261025075138.2919734-5-fuad.tabba@linux.dev>

On Sun, Oct 25, 2026 at 07:51:37AM +0800, Fuad Tabba wrote:
> Since commit 58ce78667a641 ("arm64: Add support for FEAT_{LS64,
> LS64_V}"), a guest sees the host's ID_AA64ISAR1_EL1.LS64, but KVM only
> enables the FEAT_LS64 and FEAT_LS64_V instructions in HCRX_EL2. On a
> host with FEAT_LS64_ACCDATA, a guest's ST64BV0 therefore traps and hits
> the WARN_ON_ONCE() in handle_other().
>
> Set HCRX_EL2.EnAS0 when the guest has FEAT_LS64_ACCDATA, now that
> ACCDATA_EL1 is context-switched.
>
> Fixes: 58ce78667a641 ("arm64: Add support for FEAT_{LS64, LS64_V}")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

lgtm.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

> ---
>  arch/arm64/include/asm/kvm_emulate.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index a3c1928bdf743..d07f72082531c 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -712,6 +712,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>  		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
>
> +		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnAS0;
> +
>  		/*
>  		 * NV3 is a host-specific extension, and we always use
>  		 * it when present and that the guest uses NV. It may
> --
> 2.47.3
>
