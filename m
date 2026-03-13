Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47886372EF6
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 09:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773395822; cv=none; b=QSGO/rpcee52r7BMas08amDryLvknmQ03Hqe0LwMN96UqUZjmgOYk+WLs6AUGl8HL1RpQn16GO903SaienA4iukMpUDAbHG7yJurBj12oz8ce1Yyek6JM7g6BZHLTVX2zYHQKLaNRuFoQrZA2uo6VyhTSpZlOyEd90bNuXezH7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773395822; c=relaxed/simple;
	bh=sUSsb3ixnzGIpyB3xgyXUrK7xtZKxUpeLNCxPEMMnvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TmW2ZkEQgJtzV5shGeAqp+dXkL7Xl7FuCu35wDXbPVRYvyWS7JBean7TnyoHn6Llk56alE15D4dxkwvZU2oRbmRsFB+1n1Kx+GFVNVthjGY0CUY3yKK+32Zbb4VvROnKz0QNZyjCJINOV5pNyYIXkcwxkTuk1mLUJwrZBn5fdM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3533165C;
	Fri, 13 Mar 2026 02:56:54 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 697293F73B;
	Fri, 13 Mar 2026 02:56:58 -0700 (PDT)
Date: Fri, 13 Mar 2026 09:56:55 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 7/8] KVM: arm64: use CAST instruction for swapping
 guest descriptor
Message-ID: <abPfZ27gbcBoAhEi@arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-8-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227151705.1275328-8-yeoreum.yun@arm.com>

On Fri, Feb 27, 2026 at 03:17:04PM +0000, Yeoreum Yun wrote:
> +static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
> +{
> +	u64 tmp = old;
> +	int ret = 0;
> +
> +	/*
> +	 * FEAT_LSUI is supported since Armv9.6, where FEAT_PAN is mandatory.
> +	 * However, this assumption may not always hold:
> +	 *
> +	 *   - Some CPUs advertise FEAT_LSUI but lack FEAT_PAN.
> +	 *   - Virtualisation or ID register overrides may expose invalid
> +	 *     feature combinations.
> +	 *
> +	 * Rather than disabling FEAT_LSUI when FEAT_PAN is absent, wrap LSUI
> +	 * instructions with uaccess_ttbr0_enable()/disable() when
> +	 * ARM64_SW_TTBR0_PAN is enabled.
> +	 */
> +	uaccess_ttbr0_enable();
> +
> +	asm volatile(__LSUI_PREAMBLE

I haven't tried, so just asking. Does the toolchain complain if it does
not support LSUI or is this path eliminated (due to
cpucap_is_possible()) before being handed over to gas? It's probably
fine but worth checking.

-- 
Catalin
