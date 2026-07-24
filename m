Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC96231E84F
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 06:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873337; cv=none; b=tkeL36hvZIYu83BrOUBgTXZDd2Jl0reSJxuB7MjPYN5z4dhCYJFPUvs18A31KUwKqnTc9ZlzMGVrHFpk+SrU7iMeU9HP1fRkNQmzG98BLLJns9Q/LrpxaT/NnWZPYIVBcxkt4lXqO+5gaBRgaUoKZPLNfMxYI9Twj6Ob3VDIFJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873337; c=relaxed/simple;
	bh=Hw04bIfEXoXTWpyFkxflns81CCKMz2nggQEOefHSpPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buz4Yf95zB3sW4vvUKuTu9637vn1G3cfw+bgtoRVp7kPpW+DeRYqUfgOuViaWaeKlgCfmJS3Bk3Uzddup3El9czbV5CZ1EIgRjs7OWudCweu9+1+w/iqRyB0Wp5H5s8e8aQD/coRKbUH0lIeYohLRN3CpKJcclAgR5P2+bYy9Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XntnDc9A; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XntnDc9A"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784873333; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=hVYebm7zqhPMZpfjWSWykRmUcK/0WDHp7LsTyzYba7M=;
	b=XntnDc9A1nUUnMJ73d8lzlMSwc8H/ZQtI0GKWCzSlWUbuA0VZVfuDkuRFXMDNRU7zPeaFO44+kox6YdYjSEEkPUNZAQ6kS9x9sLTpMuQFwz5QANioHcLiE3V7ZHmZgPTxz7b0Z7oUkUw9UJeCWxCkibcHx0UGxy+JhxFSN27uRM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X7iAqQz_1784873331;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X7iAqQz_1784873331 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Jul 2026 14:08:52 +0800
Date: Fri, 24 Jul 2026 14:08:51 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 13/28] arm64: sysreg: Add NVHCR_EL2 description as a
 mirror of HCR_EL2
Message-ID: <ymjztstct52bfytetjtuen5rkmmqtghgdrcioysap4udfcwevr@5wptbt56mgv3>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-14-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722074234.3330999-14-maz@kernel.org>

On Wed, Jul 22, 2026 at 08:42:19AM +0800, Marc Zyngier wrote:
> FEAT_NV3 introduces a new register that contains the HCR_EL2 value
> exposed to a NV guest. As such, it has the exact same layout as
> HCR_EL2.
>
> Describe NVHCR_EL2 as a mapping to HCR_EL2.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/sysreg | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 28755f70f0bf0..42839d2b15ae4 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -4266,6 +4266,9 @@ Field	1	E2TRE
>  Field	0	E0HTRE
>  EndSysreg
>
> +Sysreg	NVHCR_EL2	3	4	1	5	0

3 4 1 5 0, right.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

> +Mapping	HCR_EL2
> +EndSysreg
>
>  Sysreg HDFGRTR2_EL2	3	4	3	1	0
>  Res0	63:25
> --
> 2.47.3
