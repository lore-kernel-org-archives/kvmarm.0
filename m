Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75591CD215
	for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756462264; cv=none; b=iRR5lKxkeTAq6dYODCxtzCwuijjQun9UoFxCq6q8gXlJRPeLvywFMQoxpQ/LfGHqSUvConJmF7IrHg1+DYud+ZoJpnCzYP2E0owE6R9eIlyve2Lq5deJtWlxFchJUtHLnV2KsD4RUvAjd5hRRo7TrL19yMFTHievvnTh8BufQOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756462264; c=relaxed/simple;
	bh=eH6BKRKwOTjkJywNwq4bGs8NT2i7bK1YZgAubN8xarA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOWGCmrll8F9ZyaOhWb7UVfW2SAUReILJMIJ/riCcmsPKjavTKt7OufbbI/cd0ARudqvnc1r5Xky/Awsi94GjJPCjapn9/g1X1q5qnkgrdFbg6olPkvYwfOjs3DbW1SfXo3MzPPZqFz5K1yJ7RIVEwQS6/it6z/Bal0D1kIAGbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB06F1758;
	Fri, 29 Aug 2025 03:10:53 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 725AE3F694;
	Fri, 29 Aug 2025 03:10:49 -0700 (PDT)
Date: Fri, 29 Aug 2025 11:10:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com,
	sebastianene@google.com, keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v3 2/3] arm64: sysreg: Correct sign definitions for EIESB
 and DoubleLock
Message-ID: <aLF8pU4k5chetsDy@J2N7QTR9R3>
References: <20250829095143.123476-1-tabba@google.com>
 <20250829095143.123476-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829095143.123476-3-tabba@google.com>

On Fri, Aug 29, 2025 at 10:51:42AM +0100, Fuad Tabba wrote:
> The `ID_AA64MMFR4_EL1.EIESB` field, is an unsigned enumeration, but was
> incorrectly defined as a `SignedEnum` when introduced in commit
> cfc680bb04c5 ("arm64: sysreg: Add layout for ID_AA64MMFR4_EL1"). This is
> corrected to `UnsignedEnum`.
> 
> Conversely, the `ID_AA64DFR0_EL1.DoubleLock` field, is a signed
> enumeration, but was incorrectly defined as an `UnsignedEnum`. This is
> corrected to `SignedEnum`, which wasn't correctly set when annotated as
> such in commit ad16d4cf0b4f ("arm64/sysreg: Initial unsigned annotations
> for ID registers").
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> Note: No active users in the kernel for these two fields yet. pKVM
> checks DoubleLock, but only for protected VMs, which aren't enabled
> upstream yet. Hence no Fixes tag.

I have no strong feelings either way on that, so FWIW:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/tools/sysreg | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index f1a012ee0db6..d396fa587ec1 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1693,7 +1693,7 @@ UnsignedEnum	43:40	TraceFilt
>  	0b0000	NI
>  	0b0001	IMP
>  EndEnum
> -UnsignedEnum	39:36	DoubleLock
> +SignedEnum	39:36	DoubleLock
>  	0b0000	IMP
>  	0b1111	NI
>  EndEnum
> @@ -2409,7 +2409,7 @@ UnsignedEnum	11:8	ASID2
>  	0b0000	NI
>  	0b0001	IMP
>  EndEnum
> -SignedEnum	7:4	EIESB
> +UnsignedEnum	7:4	EIESB
>  	0b0000	NI
>  	0b0001	ToEL3
>  	0b0010	ToELx
> -- 
> 2.51.0.338.gd7d06c2dae-goog
> 
> 
