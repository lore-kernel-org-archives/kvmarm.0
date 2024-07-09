Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54CF21607BD
	for <kvmarm@lists.linux.dev>; Tue,  9 Jul 2024 13:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720530531; cv=none; b=t2C5IYci3sgsY9aW+nZENDuhPNUNolmpnJD6bYJQYmNlWGII6vQz7m51Zudol8AjJsxXtdoC1o/jfTSaNLjQDmMiTa9GXmPZS+4/c5p03HEqqabHUQJ5ac/nbfpkUzXsPAOMBq5yUSwl/8tdpZS+wxjnCxpAoqOrfO6YBTejVe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720530531; c=relaxed/simple;
	bh=It04Ff28MPxtGvF0HXZwYBt4Qj3dD0PWE+ocyzIoqi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AZIfvUbSWvItxBCGyHtkcaOijvsn7jE5G0HdPIx7PKmOghq+9uh0ihiaza8odcYYhTfa9iuZznNNE7BAE6tXL7xEZHJB0tyCI9if9h0z8wo3h4f3qc7wSU2a0MT6rQ1CVX6U8IDGb9Pm/nf6ppSjMSAGntgvRjVdWlEDiEC+J4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D281A1650;
	Tue,  9 Jul 2024 06:09:14 -0700 (PDT)
Received: from [10.44.160.75] (e126510-lin.lund.arm.com [10.44.160.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E8F63F766;
	Tue,  9 Jul 2024 06:08:43 -0700 (PDT)
Message-ID: <87b5070e-c85c-4585-b223-e48e5556cbac@arm.com>
Date: Tue, 9 Jul 2024 15:08:40 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 22/29] arm64: add Permission Overlay Extension Kconfig
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 aneesh.kumar@linux.ibm.com, bp@alien8.de, broonie@kernel.org,
 catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
 dave.hansen@linux.intel.com, hpa@zytor.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, maz@kernel.org,
 mingo@redhat.com, mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com,
 npiggin@gmail.com, oliver.upton@linux.dev, shuah@kernel.org,
 szabolcs.nagy@arm.com, tglx@linutronix.de, will@kernel.org, x86@kernel.org,
 kvmarm@lists.linux.dev
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-23-joey.gouly@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20240503130147.1154804-23-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/05/2024 15:01, Joey Gouly wrote:
> Now that support for POE and Protection Keys has been implemented, add a
> config to allow users to actually enable it.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/Kconfig | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 7b11c98b3e84..676ebe4bf9eb 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -2095,6 +2095,28 @@ config ARM64_EPAN
>  	  if the cpu does not implement the feature.
>  endmenu # "ARMv8.7 architectural features"
>  
> +menu "ARMv8.9 architectural features"

Nit: empty line here to be consistent with other menu entries.

Kevin

> +config ARM64_POE
> +	prompt "Permission Overlay Extension"
> +	def_bool y
> +	select ARCH_USES_HIGH_VMA_FLAGS
> +	select ARCH_HAS_PKEYS
> +	help
> +	  The Permission Overlay Extension is used to implement Memory
> +	  Protection Keys. Memory Protection Keys provides a mechanism for
> +	  enforcing page-based protections, but without requiring modification
> +	  of the page tables when an application changes protection domains.
> +
> +	  For details, see Documentation/core-api/protection-keys.rst
> +
> +	  If unsure, say y.
> +
> +config ARCH_PKEY_BITS
> +	int
> +	default 3
> +
> +endmenu # "ARMv8.9 architectural features"
> +
>  config ARM64_SVE
>  	bool "ARM Scalable Vector Extension support"
>  	default y

