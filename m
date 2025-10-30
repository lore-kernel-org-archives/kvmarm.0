Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DE3277C96
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761846602; cv=none; b=EJzYUEHsw6Ifhde54pHRToZCNG6UXIydC6IjhvyTdAa9E1Jzs9CByyU5rbYCMo9Hgkk9HlIhn9JKMV4HCT+mnTnjyRmQ34GaozG5IvIevIM9ZfH4rnDNAlk/NkbfWBqsazx5azKW0gCkOr0nlfEda2llGjOW1+ouR9CfVTtm2B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761846602; c=relaxed/simple;
	bh=PmlVtuLRMUGlPaXNotA+Y+vL38gowXndZOXkWJxEguk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IFMsH76KWwkAPPtRg/86U+CzU1E8toFq788xKl0Q+ItoVMrVRSZPvVL+HkGnVTa7sYs9RgG4fbTM5ASR7P6mhS57Ep0p+guEYpbMoqfBN2yvPBpkooLUtjoWYSdWQjuMtLFTXxltk5JWCeVYgz8ute12iUMoUJR39azlJ5dBRQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37EDC2C40;
	Thu, 30 Oct 2025 10:49:51 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01E493F673;
	Thu, 30 Oct 2025 10:49:56 -0700 (PDT)
Date: Thu, 30 Oct 2025 17:49:51 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Brazdil <dbrazdil@google.com>,
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki Poulouse <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Use pointer from memcpy() call for
 assignment in init_hyp_mode()
Message-ID: <aQOlPy7W6xljdkJW@J2N7QTR9R3>
References: <6e962260-5069-490a-89fb-908a4342ccd9@web.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e962260-5069-490a-89fb-908a4342ccd9@web.de>

On Thu, Oct 30, 2025 at 06:11:03PM +0100, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 30 Oct 2025 18:01:41 +0100
> 
> A pointer was assigned to a variable. The same pointer was used for
> the destination parameter of a memcpy() call.
> This function is documented in the way that the same value is returned.
> Thus convert two separate statements into a direct variable assignment for
> the return value from a memory copy action.
> 
> The source code was transformed by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  arch/arm64/kvm/arm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 870953b4a8a7..feab88c31703 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2600,8 +2600,8 @@ static int __init init_hyp_mode(void)
>  			goto out_err;
>  		}
>  
> -		page_addr = page_address(page);
> -		memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size());
> +		page_addr = memcpy(page_address(page), CHOOSE_NVHE_SYM(__per_cpu_start),
> +				   nvhe_percpu_size());

This change makes the code harder to read, and harder to modify. It
saves no space.

As Dan said [1]:

| No one will thank you for making these changes...  :(  Please don't do
| it.

[1] https://lore.kernel.org/lkml/aQNsecHJSO2U68Fc@stanley.mountain/

Mark.
