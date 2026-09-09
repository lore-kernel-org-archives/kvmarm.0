Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659521D4606;
	Wed,  9 Sep 2026 03:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924422; cv=none; b=Bio7s61KQVWFjnGLKiECTQt9GqmTmVu/IHJPbJ+YYKSMr2OgkRxltsOOK6VwApj/AJr4xjmHjP8uOkcymOgf5JcCoze5STrhnMGuOEbtrBjE8f/SX/JwTcD+SJYskof92KbvL17MviygVOCRwnhDq+BFegcA8wIVInP9yO/xZXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924422; c=relaxed/simple;
	bh=KSyW9PSmayMg2D+RSx0FNS4dlNPtfBwvV/djeGs+FPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PX+vH23+1WzJQRqdYibVeCnNk/gBOecPo2ZlLCJN6HeuUSSbllsyyuu/vkHv+0+RrInGK6+2MS166jCufb7OSdX10cARUaLWGwc/QKAmF5j8ZwjzOFbBmJpTYRyRNxKv1tf/WNidZfH26iCi6eCOhOnN1/1CKkl+pRI0dDFnIIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=bzqLdWAn; arc=none smtp.client-ip=207.54.90.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="bzqLdWAn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1788924421; x=1820460421;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KSyW9PSmayMg2D+RSx0FNS4dlNPtfBwvV/djeGs+FPo=;
  b=bzqLdWAn/ndfcsMGTU0GBvbmIsEzFv1pU1LZAxt64w/iF+8YmLqkpl+8
   pDvISkLP9oiLletxU5WpmxxeuGyD3OEHXV4oIOtdjAq2E7VcpVzc+tHbD
   M8JEmxLqvL6DRng6gOOtr0M1kAGx9cQnEMYXlhYTcrrVW9LWGJUG897ml
   zFhln1VgNpGeW35GJ7pLVQPsED6A85V4UlhiJveDvimGn5t+MordDtATQ
   f6zqUKANMLuf3ubf/iEiUuIuj2RkkRPUnl3S0lpQknlObYKj0BtfUqE/t
   SeTHDtwDwKq1EcQhOr59fRr6Xy6UHRZMA/+n5DziP8U8SvfrOx/JDMVvq
   g==;
X-CSE-ConnectionGUID: CQFml76FSxCDkoZsg4iLsw==
X-CSE-MsgGUID: ozLW+8PKSrieP452JNQGNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="254420907"
X-IronPort-AV: E=Sophos;i="6.25,270,1779116400"; 
   d="scan'208";a="254420907"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 12:26:53 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id B326B407542;
	Wed,  9 Sep 2026 03:26:52 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id 683E8100086A;
	Wed,  9 Sep 2026 03:26:52 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.24.243])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with SMTP id E82DC1802ED5;
	Wed,  9 Sep 2026 03:26:44 +0000 (UTC)
Date: Wed, 9 Sep 2026 12:26:41 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org, 
	gshan@redhat.com, joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com, 
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org
Subject: Re: [PATCH v17 06/20] KVM: arm64: CCA: Add a new mode for supporting
 Realm guests
Message-ID: <aqDFcgzXOTWUkPtp@FCCLS0092175.localdomain>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-7-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260908162223.1683432-7-suzuki.poulose@arm.com>

Hi Suzuki,

On 09/08 17:22, Suzuki K Poulose wrote:
> Add an explicit mode to support Arm CCA guests.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 3 +++
>  arch/arm64/include/asm/kvm_host.h               | 1 +
>  arch/arm64/kvm/arm.c                            | 5 +++++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 68647ff4bdd24..1afe3df3b923e 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3256,6 +3256,9 @@ Kernel parameters
>  			nested: VHE-based mode with support for nested
>  				virtualization. Requires at least ARMv8.4
>  				hardware (with FEAT_NV2).
> +			rmm: Support for running confidential guests in Realm
> +			     world using RMM, as defined by Arm Confidential
> +			     Compute Architecture (CCA)
>  
>  			Defaults to VHE/nVHE based on hardware support. Setting
>  			mode to "protected" will disable kexec and hibernation
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b2e99c5cb1cd3..31ae9d8d8e92f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -69,6 +69,7 @@ enum kvm_mode {
>  	KVM_MODE_DEFAULT,
>  	KVM_MODE_PROTECTED,
>  	KVM_MODE_NV,
> +	KVM_MODE_RMM,
>  	KVM_MODE_NONE,
>  };
>  #ifdef CONFIG_KVM
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9af3bbb2f8c24..50f0adfadab38 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -3264,6 +3264,11 @@ static int __init early_kvm_mode_cfg(char *arg)
>  		return 0;
>  	}
>  
> +	if (strcmp(arg, "rmm") == 0 && !WARN_ON(!is_kernel_in_hyp_mode())) {
> +		kvm_mode = KVM_MODE_RMM;
> +		return 0;
> +	}

Does this make NV support and CCA Realm VM support mutually exclusive?

Until the v16 series, we could run Realm VMs with:
  'kvm-arm.mode=nested'

As far as the AArch64 architecture is concerned, there does not seem to
be a reason to make them mutually exclusive. I am therefore wondering
whether this restriction is intentional.

Thanks,
Kohei

> +
>  	return -EINVAL;
>  }
>  early_param("kvm-arm.mode", early_kvm_mode_cfg);
> -- 
> 2.43.0
> 
