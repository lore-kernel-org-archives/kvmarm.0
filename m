Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B2C210F0
	for <kvmarm@lists.linux.dev>; Mon, 20 Nov 2023 17:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBF661042;
	Mon, 20 Nov 2023 09:29:08 -0800 (PST)
Received: from arm.com (e121798.cambridge.arm.com [10.1.197.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A0073F7A6;
	Mon, 20 Nov 2023 09:28:21 -0800 (PST)
Date: Mon, 20 Nov 2023 17:28:19 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	andrew.jones@linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	jarichte@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/2] arm: pmu: Declare pmu_stats as
 volatile
Message-ID: <ZVuXM98kh2r0AmEj@arm.com>
References: <20231113174316.341630-1-eric.auger@redhat.com>
 <20231113174316.341630-2-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113174316.341630-2-eric.auger@redhat.com>

Hi,

On Mon, Nov 13, 2023 at 06:42:40PM +0100, Eric Auger wrote:
> Declare pmu_stats as volatile in order to prevent the compiler
> from caching previously read values. This actually fixes
> pmu-overflow-interrupt failures on some HW.

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index a91a7b1f..86199577 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -328,7 +328,7 @@ asm volatile(
>  	: "x9", "x10", "cc");
>  }
>  
> -static struct pmu_stats pmu_stats;
> +static volatile struct pmu_stats pmu_stats;
>  
>  static void irq_handler(struct pt_regs *regs)
>  {
> -- 
> 2.41.0
> 
