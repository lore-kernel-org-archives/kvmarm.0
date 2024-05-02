Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484285025A
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 09:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714640758; cv=none; b=mAxSlniey0IdZZRVjMzIH3qvFStel+aCOKajPgX9Ryh0+a5bkQCoxrNsbqluMGHX5PNVhlgq19B/GsOku08nWjRahkK1cPHq140gXG9qrgwz7EWC12e9AOC0kgfxuuVZQmKeQp/SZWsrMtQc1gjY0TZuCfa9M858U/8NLhCo1k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714640758; c=relaxed/simple;
	bh=raCWB4wu4X/HydTHJtlHR7UkkQKRzYd+JrrVZKNc5us=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RAo1hqSLduczGnltxRsejUziYO/g6+osOibqaUyaCh6dQh+6/hMqcc08Q2f+rkaiPrEgxyuCGnMf+iO+VfTUDlDvwlxT1T0K3FR8/N2N0u8T1rIXEIEmuNMCVcpEbF2BWj9xlFmwPvJqwPl1GXfA5hO3lhb2s3ezU+yVqtTUkS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=On4Ul2hr; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="On4Ul2hr"
Date: Thu, 2 May 2024 11:05:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714640755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4BD7u+E4fo5H0RPACm1/Cr8Sod7384r4iX9H+qoX0LI=;
	b=On4Ul2hr0EN5cicHAOH5uBgVUp+Yycb6Br0GqaoSvvwLVZff0kK5Pch2aB2Ddn03pKKOqv
	If4er+mhaaA5DCoHlmAy+Ewv6igc+qVyZr4uaJnjbDwoL9Na6xtoSgHdmeteU45Us3c1Cp
	2T4yiH/LU6zFox62MYY3byeYzMCvOBM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: Default to 4K translation granule
Message-ID: <20240502-d67a14b9ac3dd606a52af562@orel>
References: <20240502074156.1346049-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502074156.1346049-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 07:41:56AM GMT, Oliver Upton wrote:
> Some arm64 implementations in the wild, like the Apple parts, do not
> support the 64K translation granule. This can be a bit annoying when
> running with the defaults on such hardware, as every test fails
> before getting the MMU turned on.
> 
> Switch the default page size to 4K with the intention of having the
> default setting be the most widely applicable one.

Yeah, this makes sense. The original 64k default didn't have any real
justification. I only selected it since I had been drinking the "64k
pages will rule the world" Kool-Aid for too long. The effects of that
Kool-Aid have already long worn off though, so I'll get this merged.

Thanks,
drew

> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  configure | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/configure b/configure
> index 49f047cb2d7d..4ac2ff3e6106 100755
> --- a/configure
> +++ b/configure
> @@ -75,7 +75,7 @@ usage() {
>  	                           (s390x only)
>  	    --page-size=PAGE_SIZE
>  	                           Specify the page size (translation granule) (4k, 16k or
> -	                           64k, default is 64k, arm64 only)
> +	                           64k, default is 4k, arm64 only)
>  	    --earlycon=EARLYCON
>  	                           Specify the UART name, type and address (optional, arm and
>  	                           arm64 only). The specified address will overwrite the UART
> @@ -243,11 +243,7 @@ if [ "$efi" ] && [ "$arch" = "riscv64" ] && [ -z "$efi_direct" ]; then
>  fi
>  
>  if [ -z "$page_size" ]; then
> -    if [ "$efi" = 'y' ] && [ "$arch" = "arm64" ]; then
> -        page_size="4096"
> -    elif [ "$arch" = "arm64" ]; then
> -        page_size="65536"
> -    elif [ "$arch" = "arm" ]; then
> +    if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>          page_size="4096"
>      fi
>  else
> -- 
> 2.45.0.rc1.225.g2a3ae87e7f-goog
> 
