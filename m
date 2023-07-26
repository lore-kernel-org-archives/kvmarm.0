Received: from out-36.mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A449B7C
	for <kvmarm@lists.linux.dev>; Wed, 26 Jul 2023 00:43:28 +0000 (UTC)
Date: Wed, 26 Jul 2023 00:43:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690332206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HALqmBHRxoZoYPJqgL7xjsvgfgeFmUbg3TJ4ODnZZro=;
	b=EfORBpjPvpXYjl4NGyW2BixT1TdSAvXT4OKf98DUAJA2ftRZmx1p8sXagv8iU26PvNoe0o
	h0qg4t2iDVR4XuU9Jc5gVCpBl8NIDWxyg+CPJp83UqwWgZDRBHAY/SDRgo9jALpiibh4iN
	ik+F/zCxUzRsbqw2Ql1ZIyNzLsRWdKQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
	wanghaibin.wang@huawei.com
Subject: Re: [PATCH] KVM: arm64: Drop HCR_VIRT_EXCP_MASK
Message-ID: <ZMBsKr4473sNnRS8@linux.dev>
References: <20230724142257.1551-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724142257.1551-1-yuzenghui@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 24, 2023 at 10:22:57PM +0800, Zenghui Yu wrote:
> This was introduced in commit 0369f6a34b9f ("arm64: KVM: EL2 register
> definitions") and for more than 10 years nobody used. Remove it.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/include/asm/kvm_arm.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 58e5eb27da68..d04ef89ca6a0 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -89,7 +89,6 @@
>  			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
>  			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
>  			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3)
> -#define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
>  #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
>  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
>  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
> -- 
> 2.33.0
> 

-- 
Thanks,
Oliver
