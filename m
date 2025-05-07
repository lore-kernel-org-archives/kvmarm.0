Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599671A2390
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 16:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746636308; cv=none; b=la5xhlooTkWJ/DvgJbJXTqBtH0inIDkYdmZKl9jhbBfQdmlHwfhIJqpwgKgakICS+5tgO3/asYWfaqaR2KyIiKXfYsziiHSx/orsVMvgpjOFMNz6Tva1v4EbI0yI7x9UK14mV/gm87xXaKM6xuAm7fmi27rk75OPfvE2WO2JK7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746636308; c=relaxed/simple;
	bh=0zsYuFN8DRkz8lqbILKSMTWHcv36y+5twrs9DHVJ8+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H85XDdHiUT0tn7m8gJeUvmK32zHWz4OdGKbYSSJC+lQm5tYEMgOdKfnAgBgogIRw4OQ+/WKa54WTOPwvGoIkUryml9GuUil9AhfBhcFz8nR7V+meNFgORGrqGrcfkGtpvnO/acKFxYTdIb9v3zaIgesSnd2DT4ls7vQ+XNlwCZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ppfvQ4wR; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ppfvQ4wR"
Date: Wed, 7 May 2025 18:45:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746636304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l9xZ23DhdLI0tbSuD9vBHZtbbRiWB81u/rHKaK7rVJo=;
	b=ppfvQ4wRMLDsUxyr+O0llP8JyXWNDUSciVcC0yPy+dqT/scr0F4U50Zn7zq8E/n9V0XxXq
	Ztb8arjgyvckv2/XO/3fF703zzQV3e8Kbpi480DoyCpGhLDg7laYTqjvJaN5X2bvEWOc2C
	7cr2CDvyLf5ltGMDtZJLQCjWCthSg54=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 11/16] scripts: Add KVMTOOL environment
 variable for kvmtool binary path
Message-ID: <20250507-1ad6b4b9396d8da573c960f2@orel>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-12-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507151256.167769-12-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 07, 2025 at 04:12:51PM +0100, Alexandru Elisei wrote:
> kvmtool is often used for prototyping new features, and a developer might
> not want to install it system-wide. Add a KVMTOOL environment variable to
> make it easier for tests to use a binary not in $PATH.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  run_tests.sh          | 1 +
>  scripts/arch-run.bash | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index dd9d27377905..150a06a91064 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -36,6 +36,7 @@ The following environment variables are used:
>      TIMEOUT         Timeout duration for the timeout(1) command
>      CHECK           Overwrites the 'check' unit test parameter (see
>                      docs/unittests.txt)
> +    KVMTOOL         Path to kvmtool binary for ARCH-run
>  EOF
>  }
>  
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 8cf67e4f3b51..d4fc7116abbe 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -372,7 +372,7 @@ search_kvmtool_binary ()
>  {
>  	local kvmtoolcmd kvmtool
>  
> -	for kvmtoolcmd in lkvm vm lkvm-static; do
> +	for kvmtoolcmd in ${KVMTOOL:-lkvm vm lkvm-static}; do
>  		if "$kvmtoolcmd" --help 2>/dev/null| grep -q 'The most commonly used'; then
>  			kvmtool="$kvmtoolcmd"
>  			break
> @@ -381,6 +381,7 @@ search_kvmtool_binary ()
>  
>  	if [ -z "$kvmtool" ]; then
>  		echo "A kvmtool binary was not found." >&2
> +		echo "You can set a custom location by using the KVMTOOL=<path> environment variable." >&2
>  		return 2
>  	fi
>  
> -- 
> 2.49.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
