Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7654233F8AA
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 10:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407028; cv=none; b=Hoemwc1q2wAg5vsggtAFBnWkOFYVFdOT6XJpxOkNafe/nwneWgbKOkiZJy6enPzND9vrrl95loFz6TjBg7zKzidy+c62EqDSjUdfX5BvO0M8+Z6KNHXKYSZbK6oPOCk4Fz8ddXaOnz2MGQQRNk5LpPD724/vHYhsZIaALpuisKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407028; c=relaxed/simple;
	bh=uH4MR0Zg/NqoAeMyBzzpHF9m5BvkJlfRvuhGQocyqtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBg2Ft6Z8vZ0I2qGroGWJmj2nI/undhIBPIgNdO3VqvIgIM7Dj9o37hcWsCrPg2MKpJ/pkghzDoE5qgwwf0oNVJlfPROI4EywUxM7iVXOVxmPEfb/G3SS91c0thq2gtvrx3Wh/tvOfYr/mnHouwLiRojRdAZsZ1NBehPiY8SrOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mCO9sUzh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mCO9sUzh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC3D01688;
	Thu, 30 Jul 2026 03:23:41 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5281C3F86F;
	Thu, 30 Jul 2026 03:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785407025; bh=uH4MR0Zg/NqoAeMyBzzpHF9m5BvkJlfRvuhGQocyqtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mCO9sUzhXc9haZg1Qh0zm54Xivj09WSrUfF6UjjIxzLY50xh5kVrMAMUYaj/bFryo
	 XNvD7U3kyHyxD1YE4NriBO0KT1NdXv3fJRU+o0YklQLBII5K7Y15AQXiwr6ksXhne7
	 QjQ1OlmuHkisD+t2uSD9v8Y2uGny5nuAJ/2hTX7c=
Date: Thu, 30 Jul 2026 11:23:34 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v4 01/29] arm64: sysreg: Emit RESx/UNKN values for
 Mapping/Fields definitions
Message-ID: <amsmJo0gsaj5DAJd@J2N7QTR9R3.cambridge.arm.com>
References: <20260730071022.296811-1-maz@kernel.org>
 <20260730071022.296811-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730071022.296811-2-maz@kernel.org>

On Thu, Jul 30, 2026 at 08:09:54AM +0100, Marc Zyngier wrote:
> The sysreg file is using the Mapping or Fields qualifiers to indicate
> that a given encoding is only a mapping to a particular register (or
> an instance of a more generic register definition).
> 
> As a result, we don't output any definition, and instead expect
> the canonical definitions to be used.
> 
> This works rather well for individual fields, but creates problems
> for macros that refer to more generic classes of bits such as RESx.
> 
> Relax the above rule by emitting the RESx and UNKN values for Mapping
> and Fields qualifiers as well.

It might be worth stating a bit more explicitly, something like:

  Emit RESx and UNKN values for Mapping and Fields qualifiers as well,
  defining these in terms of the RESx and UNKN values for the canonical
  Sysreg or SysregFields definition.

  For example, the following defintion:

  | Sysreg FOO ...
  | Fields BAR
  | EndSysreg
  
  ... will generate:
  
  | #define FOO_RES0	(BAR_RES0)
  | #define FOO_RES1	(BAR_RES1)
  | #define FOO_RES0	(BAR_UNKN)

Regardless of the above, the patch looks reasonable to me, so:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/gen-sysreg.awk | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
> index 86860ab672dc7..53844f5c5e525 100755
> --- a/arch/arm64/tools/gen-sysreg.awk
> +++ b/arch/arm64/tools/gen-sysreg.awk
> @@ -228,7 +228,7 @@ $1 == "EndSysreg" && block_current() == "Sysreg" {
>  }
>  
>  # Currently this is effectivey a comment, in future we may want to emit
> -# defines for the fields.
> +# defines for the fields. We do emit RESx and UNKN values in any case.
>  ($1 == "Fields" || $1 == "Mapping") && block_current() == "Sysreg" {
>  	expect_fields(2)
>  
> @@ -239,9 +239,9 @@ $1 == "EndSysreg" && block_current() == "Sysreg" {
>  	print ""
>  
>  	next_bit = -1
> -	res0 = null
> -	res1 = null
> -	unkn = null
> +	res0 = $2 "_RES0"
> +	res1 = $2 "_RES1"
> +	unkn = $2 "_UNKN"
>  
>  	next
>  }
> -- 
> 2.47.3
> 
> 
