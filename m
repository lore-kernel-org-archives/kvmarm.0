Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22813DBB7
	for <kvmarm@lists.linux.dev>; Tue, 16 Jul 2024 11:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721127763; cv=none; b=G09akmghyJTcOtIv9GNWsaLliu1p+coeVaMP/vRvW4dtYT/9926/750I6C6I+Jgny2rn6AXMFUrAjpP99PsNmBLle1KZiRopOPGYerDbCjk/RN08c9RjApm+8GAUaT9ESORFCVl3AzGJCI2lcaOsJX1nRzpw9ng/IzV5upnqWgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721127763; c=relaxed/simple;
	bh=m3biLndg6y0xxrbLEN615sKWlh8MfryZ1KC48e0NBiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bhR0nvvhLnqxY0ZLd9xfcCWuAF91My30Nm3SJb0j5fvGyAucAbw8kfW/lXFymDcZyuVEFe2PHDbl6vHU9xoOqCAaFaiI8qZj+aNkh8moOwKhZNEvQL5nOrvfgiPSKbGR1CraFvOq9D+3NKQ+aJ9ymbgfqtfN8rLgKZ+jsSZ5IbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A4621063;
	Tue, 16 Jul 2024 04:03:06 -0700 (PDT)
Received: from [10.163.52.225] (unknown [10.163.52.225])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DDED3F73F;
	Tue, 16 Jul 2024 04:02:32 -0700 (PDT)
Message-ID: <87eba7de-b267-49ad-92fe-dcf3638b75d9@arm.com>
Date: Tue, 16 Jul 2024 16:32:29 +0530
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
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240503130147.1154804-23-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/3/24 18:31, Joey Gouly wrote:
> Now that support for POE and Protection Keys has been implemented, add a
> config to allow users to actually enable it.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

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

Agree with Kevin regarding need for an empty line here.

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
