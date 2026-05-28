Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED933F1AB1
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 13:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779973846; cv=none; b=PZPa1/oQ+Jv6+YP8S7q6ShC60UxT3lA4WrSd0gJBEcqa69wlpwC582tbXNO7ygPMDIOk/mkcXHMozLNZgbYuRDl41jQB5Qvy/TE5NDr9GPLHBZvp4Y+/xrS+aMn39mYO+pvTrLnubsPJpgQDk3lBkpN4UBdM9IoXKxcdDEirAjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779973846; c=relaxed/simple;
	bh=Jnt9KuLkWsuC6eedPcxmoBMiPXplBzGlOfT17H7n1LM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cz1WefeZMowg+sJ7/MR+I8D1RCxFbDh5pkELe2FRsPPOt6doMmLws04Wxw0UIZE49NuJ5tMG8HjjmEZqTZnH3+OfGcQ3FPx9lReRvu5ix9qK1ooyYwyqDIEV9ewlx23AgCRMLqHV4Q3LLiuY7dAuMBnlF1D9ujSr0jnEhudzdHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dzScRJIw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dzScRJIw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D33894402;
	Thu, 28 May 2026 06:10:36 -0700 (PDT)
Received: from [10.1.28.164] (unknown [10.1.28.164])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 284773F632;
	Thu, 28 May 2026 06:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779973841; bh=Jnt9KuLkWsuC6eedPcxmoBMiPXplBzGlOfT17H7n1LM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dzScRJIw6z6dqFSw/alsZGKm9XCM3JEeBgdW4TX3T2n1qvhE0Ym/MbhsoJMrBtahc
	 E610HSZPjokTNSjkGNC+BmJ2ORn01+gvBNCestwL+Xsz1gOgUawkIV1xC/RfqC083v
	 BnQyeUqT6X0hrUq7IuZN3SIVUDTEoI3799vQbFTk=
Message-ID: <6f03bcd0-f46c-4cc7-b08e-85fb6a81e9a3@arm.com>
Date: Thu, 28 May 2026 14:10:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/18] arm64: fpsimd: Remove <asm/fpsimdmacros.h>
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-19-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521132556.584676-19-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/26 14:25, Mark Rutland wrote:
> We no longer need any of the remaining macros in <asm/fpsimdmacros.h>.
> 
> Remove all of it.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimdmacros.h | 64 ---------------------------
>  1 file changed, 64 deletions(-)
>  delete mode 100644 arch/arm64/include/asm/fpsimdmacros.h
> 
> diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
> deleted file mode 100644
> index a763fd03ffef3..0000000000000
> --- a/arch/arm64/include/asm/fpsimdmacros.h
> +++ /dev/null
> @@ -1,64 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * FP/SIMD state saving and restoring macros
> - *
> - * Copyright (C) 2012 ARM Ltd.
> - * Author: Catalin Marinas <catalin.marinas@arm.com>
> - */
> -
> -#include <asm/assembler.h>
> -
> -/* Sanity-check macros to help avoid encoding garbage instructions */
> -
> -.macro _check_general_reg nr
> -	.if (\nr) < 0 || (\nr) > 30
> -		.error "Bad register number \nr."
> -	.endif
> -.endm
> -
> -.macro _sve_check_zreg znr
> -	.if (\znr) < 0 || (\znr) > 31
> -		.error "Bad Scalable Vector Extension vector register number \znr."
> -	.endif
> -.endm
> -
> -.macro _sve_check_preg pnr
> -	.if (\pnr) < 0 || (\pnr) > 15
> -		.error "Bad Scalable Vector Extension predicate register number \pnr."
> -	.endif
> -.endm
> -
> -.macro _check_num n, min, max
> -	.if (\n) < (\min) || (\n) > (\max)
> -		.error "Number \n out of range [\min,\max]"
> -	.endif
> -.endm
> -
> -.macro _sme_check_wv v
> -	.if (\v) < 12 || (\v) > 15
> -		.error "Bad vector select register \v."
> -	.endif
> -.endm
> -
> -.macro __for from:req, to:req
> -	.if (\from) == (\to)
> -		_for__body %\from
> -	.else
> -		__for %\from, %((\from) + ((\to) - (\from)) / 2)
> -		__for %((\from) + ((\to) - (\from)) / 2 + 1), %\to
> -	.endif
> -.endm
> -
> -.macro _for var:req, from:req, to:req, insn:vararg
> -	.macro _for__body \var:req
> -		.noaltmacro
> -		\insn
> -		.altmacro
> -	.endm
> -
> -	.altmacro
> -	__for \from, \to
> -	.noaltmacro
> -
> -	.purgem _for__body
> -.endm
> -- 2.30.2
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

