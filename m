Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EA4148FF5
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 15:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741275935; cv=none; b=VntZdGjDEJeBHNVIrN0AB3l8LbuOW8FZzpt17/2390LTD5iQ8hTqb4uKhLqsiODg3Y+qjacuUFWyUyzGgew87zsrIpwcHooX7bKUejT3FaMwwUJNxO+ZJcE0pKXbvTitmrfW8J+6TeVOZws4ZDEzY1AyNbvcfel0CFcOfiKQgrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741275935; c=relaxed/simple;
	bh=oJb31Hzwm1uhNBur0riNFahQXXOghZuPxLTmnyDpTNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q9eg/zC10OVVRKG1je4YgF1GuP+/JXHp/HrDYSyf6k3OQR9RLoiu1vHCU1t45fi08ZkN8T+RNUTlLSpULbQj1EmNiJWcLRH+o1y3wOL5hN2xDIjRUlp3WFno19DXEY2IM4+uu5LluiA6QlgJ6W3zGrhQR3WDuZA0ruXUIFdrTpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ivsvJTx+; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ivsvJTx+"
Date: Thu, 6 Mar 2025 16:45:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741275931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eCeSCVrjKevx8njgqni78iIcFR3H8Z+fRmIiAdymOKg=;
	b=ivsvJTx+XTpYKudqDTI//7KpiYur9SxzZb9VaMKOusv7h3wpn7DtK24SjgWZylmWjHodqe
	cU/vYR/GnOdsBbUAq22IfnL5yDmYG6IDFaTubObZbq5T0QVhuu68nONrZLFfV2zc1NdfRY
	zUeBEwncwrO87NH9/HxOCd6OFd2OiRs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH v4] arm64: Add basic MTE test
Message-ID: <20250306-e90b77df70c0a9be913a4e08@orel>
References: <20250227152240.118721-1-vladimir.murzin@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227152240.118721-1-vladimir.murzin@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 27, 2025 at 03:22:40PM +0000, Vladimir Murzin wrote:
> Test tag storage access and tag mismatch for different MTE modes.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arm/Makefile.arm64            |   8 +
>  arm/cstart64.S                |   4 +-
>  arm/mte.c                     | 313 ++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg             |  19 +++
>  lib/arm64/asm/mmu.h           |   1 +
>  lib/arm64/asm/pgtable-hwdef.h |   3 +
>  lib/arm64/asm/sysreg.h        |  14 ++
>  7 files changed, 361 insertions(+), 1 deletion(-)
>  create mode 100644 arm/mte.c
>

Unfortunately this is failing builds with clang.

arm/mte.c:65:18: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
   65 |                       : "=&r" (r)
      |                                ^
arm/mte.c:63:21: note: use constraint modifier "w"
   63 |         asm volatile ("ldr %0,[%1]\n"
      |                            ^~
      |                            %w0
arm/mte.c:65:18: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
   65 |                       : "=&r" (r)
      |                                ^
arm/mte.c:64:14: note: use constraint modifier "w"
   64 |                       "str %0,[%2]\n"
      |                            ^~
      |                            %w0
arm/mte.c:75:16: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
   75 |                       : "r" (val), "r" (addr)
      |                              ^
arm/mte.c:72:21: note: use constraint modifier "w"
   72 |         asm volatile ("str %0,[%1]\n"
      |                            ^~
      |                            %w0

Thanks,
drew
