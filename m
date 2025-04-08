Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7468225764
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 15:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125420; cv=none; b=oLEDTmqROJJehj8wA2T+Dlqg7qyEG/LlHMGDOwQlCazTKjaQn+4v7OWShQ9o48Vc0y5LsQLNS73JbGh93B4R+qY9leB2I4UQgLWqebOjBSXGiESKfIllS/8VM99sxQW0d09x5lkY5K21l82nWSJ/p2aGLX7j3ihk+iVnzn/HFPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125420; c=relaxed/simple;
	bh=eljeVUsj4Y3afj7HjvRD6nP+JhnnN+HA3/2dP1hlEgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfY37vblFGby6TqvD0M7ba3jguU1rGaiCDFSvnOQbUpT92fRUIgLkU3F7UeK99IK99cZsO6D2wGJPeuVUocV7Ux45W0KGhTwUewoSCfgG5dca4STIlz+9outVZFOmbdMoFjhhkeRjE/v8KJjUX6x62DGvrrLU2T7dv7kjPWU+2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vxXUXp/T; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vxXUXp/T"
Date: Tue, 8 Apr 2025 17:16:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744125416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=howVdPIkMfOUgO+Gwm1Gb4UXrK3hJ8RVN2V9iJFtutg=;
	b=vxXUXp/TemNNzwVVqKvbX0gR0WSzQIT1ipFzYkoMxOqjDgqnnW9DNK5Bz95vG7sg0apf7G
	RHmrZVP8WMAe4VEtDsmsAxddWvumwcyeCwqC+pdbU64DnYJj0/tvVvDh4OxqdI+fJGmM1j
	WPrL/+5SoDDNm42oHoXgDx/aoKBqVvI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	jean-philippe@linaro.org
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: efi: Bump number of memregions
Message-ID: <20250408-bd9dcf82f26d72cee5d8013c@orel>
References: <20250408150413.97104-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408150413.97104-2-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 08, 2025 at 05:04:14PM +0200, Andrew Jones wrote:
> When using QEMU's 'max' cpu type additional EFI memory regions are
> present. Just like riscv's commit f35fe0ee486a ("riscv: efi: Bump
> number of memregions"), bump the number we allow to ensure we don't
> hit the assert in memregions_add().
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/arm/setup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index aaa0da9804a2..67b5db07ba8f 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -31,7 +31,7 @@
>  #include "io.h"
>  
>  #define MAX_DT_MEM_REGIONS	16
> -#define NR_EXTRA_MEM_REGIONS	64
> +#define NR_EXTRA_MEM_REGIONS	128
>  #define NR_MEM_REGIONS		(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
>  
>  extern unsigned long _text, _etext, _data, _edata;
> -- 
> 2.49.0
>

Merged through arm/queue.

Thanks,
drew
