Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5576153594;
	Mon, 22 Apr 2024 15:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713800902; cv=none; b=nGlRSjNiysUIrxRqYf5YUV87LCx2mLpQEaRUW0iQij3SO83SxE7AmHMhvzTUoVjwO4IgyjtyLEeNiTFVVV1OUEA43FN/QfsRTw/12/NY1/kzuq3cpda20GTaSZKg+nYCIm6gvGB79P/bFN0UDusgfUr2MZrKaAsZmIXRnhxAxdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713800902; c=relaxed/simple;
	bh=a8/HxN4LeYC6wAGy+xyDNNo3BK/fu39NEQB5hddsTMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MukWyLiol9lIXcibvc9DroltLqERMB7sg5u6Jj3/MM/qYm6h0ATmypjs2UdYPC3jKGLHUqj+aLa17UIxTaZtY8ff9PkMol6lsNEkbA3yXPjQ5d0QtkV23i2YtQPFIg0OPrW0IvfYOOODbD76RD3HNtxdsmdQ3Iot3sMolfw2WO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C9312F;
	Mon, 22 Apr 2024 08:48:48 -0700 (PDT)
Received: from arm.com (e121798.cambridge.arm.com [10.1.197.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B2F63F73F;
	Mon, 22 Apr 2024 08:48:18 -0700 (PDT)
Date: Mon, 22 Apr 2024 16:48:16 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	joey.gouly@arm.com, steven.price@arm.com, james.morse@arm.com,
	oliver.upton@linux.dev, yuzenghui@huawei.com,
	andrew.jones@linux.dev, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 14/33] arm: selftest: realm: skip pabt
 test when running in a realm
Message-ID: <ZiaGwP7Dvg8y4Bwu@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
 <20240412103408.2706058-15-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412103408.2706058-15-suzuki.poulose@arm.com>

Hi,

On Fri, Apr 12, 2024 at 11:33:49AM +0100, Suzuki K Poulose wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> The realm manager treats instruction aborts as fatal errors, skip this
> test.

I wrote the commit message, and now I don't remember if this was a
limitation of the (at the time) implementation for the realm manager that I
used for developing the patch or if this was specified in the architecture
:(

Would you mind clearing that up?

Thanks,
Alex

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arm/selftest.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 1553ed8e..8caadad3 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -19,6 +19,7 @@
>  #include <asm/smp.h>
>  #include <asm/mmu.h>
>  #include <asm/barrier.h>
> +#include <asm/rsi.h>
>  
>  static cpumask_t ready, valid;
>  
> @@ -393,11 +394,17 @@ static void check_vectors(void *arg __unused)
>  					  user_psci_system_off);
>  #endif
>  	} else {
> +		if (is_realm()) {
> +			report_skip("pabt test not supported in a realm");
> +			goto out;
> +		}
> +
>  		if (!check_pabt_init())
>  			report_skip("Couldn't guess an invalid physical address");
>  		else
>  			report(check_pabt(), "pabt");
>  	}
> +out:
>  	exit(report_summary());
>  }
>  
> -- 
> 2.34.1
> 
