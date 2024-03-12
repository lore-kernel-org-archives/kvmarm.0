Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F0620304
	for <kvmarm@lists.linux.dev>; Tue, 12 Mar 2024 11:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710242483; cv=none; b=KDlrXx2tPLLIbEZsayDs1nfGj073AGakLlmqHX3YReyWOvDCLVfh1lD3DYc6ooLMgD7ny7HExPhfW6kjXKMnirK3twxCMwrmaqoo3l6R6K7Zhn/nyHpCgUvFl9PzIakOjNiZi0LYl1ErmBXUobz5ZdA5VPrMQ8vvHaTlbssWCvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710242483; c=relaxed/simple;
	bh=VD+u/mTQbHdfGQYJdiBTABEeUInY9Bcb1Gf2r50b/tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8M8jeaOyC7d4+KwHHuF4tw0T6I4tYzNG+iLT0ap+BbNnRgswfApSK2atUAqOHaY64+aa+H170GsOPEi8UYVWFC0nWMMtNVvkLo/fabbUVZEZaiBM1pANTC9m0o9Pne/Ek40JRzUNp4OjJbxn7iVax61tVqjXVnz+zaRV88s00k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A67EC1007;
	Tue, 12 Mar 2024 04:21:57 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4B343F762;
	Tue, 12 Mar 2024 04:21:18 -0700 (PDT)
Date: Tue, 12 Mar 2024 11:21:16 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 13/13] KVM: arm64: nv: Advertise support for PAuth
Message-ID: <20240312112116.GB1635791@e124191.cambridge.arm.com>
References: <20240226100601.2379693-1-maz@kernel.org>
 <20240226100601.2379693-14-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226100601.2379693-14-maz@kernel.org>

On Mon, Feb 26, 2024 at 10:06:01AM +0000, Marc Zyngier wrote:
> Now that we (hopefully) correctly handle ERETAx, drop the masking
> of the PAuth feature (something that was not even complete, as
> APA3 and AGA3 were still exposed).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index ced30c90521a..6813c7c7f00a 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -35,13 +35,9 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
>  		break;
>  
>  	case SYS_ID_AA64ISAR1_EL1:
> -		/* Support everything but PtrAuth and Spec Invalidation */
> +		/* Support everything but Spec Invalidation */
>  		val &= ~(GENMASK_ULL(63, 56)	|
> -			 NV_FTR(ISAR1, SPECRES)	|
> -			 NV_FTR(ISAR1, GPI)	|
> -			 NV_FTR(ISAR1, GPA)	|
> -			 NV_FTR(ISAR1, API)	|
> -			 NV_FTR(ISAR1, APA));
> +			 NV_FTR(ISAR1, SPECRES));
>  		break;
>  
>  	case SYS_ID_AA64PFR0_EL1:

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
