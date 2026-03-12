Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4333C4576
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773326528; cv=none; b=OMLPXEFKoIDS15q1LnKESoXb3LVkqRIyRlXlWDE0Y6QAxAG0gzcPUvG6vXOV8GwREMLGpBMjrApQHYEo5nJYw1yzQ8lqoQeKdh/DHpIudzrWl3sCDkQ67cYLB6UmPjE9RVQK4aMPkND9aZMmGUZ4wS6+BIjyK3e0KrvA4b6s6+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773326528; c=relaxed/simple;
	bh=sNP0bK+hPdXgYqMGGdNC15eIC/I9ohCbielxEYspqow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfoLtmOtNkb7YYi23ZaY+DQUBqXTzsSeMVa5TYigmTfHkhQVIM6IQZ41vU2VR9hZLewDyEnM85duWJ1mpu/vMVORlAVIjpa2Cno4wmF5R5ny+DsCfE2BS9XMa2oBxuaFICeXMZAFEKOqw5KQZVFK0n0Vap7FahMecF7yslTZtSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 587F2165C;
	Thu, 12 Mar 2026 07:41:55 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6134B3F7BD;
	Thu, 12 Mar 2026 07:41:59 -0700 (PDT)
Date: Thu, 12 Mar 2026 14:41:57 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 4/8] arm64: futex: refactor futex atomic operation
Message-ID: <abLQtbbYidcmPg-7@arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-5-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227151705.1275328-5-yeoreum.yun@arm.com>

On Fri, Feb 27, 2026 at 03:17:01PM +0000, Yeoreum Yun wrote:
> Refactor futex atomic operations using ll/sc method with
> clearing PSTATE.PAN to prepare to apply FEAT_LSUI on them.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/futex.h | 137 +++++++++++++++++++++------------
>  1 file changed, 87 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index bc06691d2062..9a0efed50743 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -7,21 +7,25 @@
>  
>  #include <linux/futex.h>
>  #include <linux/uaccess.h>
> +#include <linux/stringify.h>

Nit: what needs stringify.h in this file? It get removed (or rather
moved to lsui.h) in the next patch.

-- 
Catalin
