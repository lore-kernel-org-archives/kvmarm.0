Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C211317158
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 10:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779876645; cv=none; b=jA+GJCWLQct4ydg8MjMObgFAXeoNag0tep9IJof11k6U2gLRJaKvKAtm0lBUOr1u/pdI5DLV7erGRTU5Anol2S6cUxyPmPUTeiu9+0f+o8FxMM/TfHirNmejn1dJohhmhnnLGCTqTP7qMFQ5YU9iz59KvfdLbCUgAYQy0q3rdZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779876645; c=relaxed/simple;
	bh=jzeLhz2a6Zamxi++A3SvLG1E0JdfhURZoHMnNCLeFzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NWs1JqF5+PnQkIZPvgN/rNSB0vuXWlliDkkedVptOKCujmt7Lczsqgu9L2hQD3JvEc+rbjO4V+9D+uwcrGRUbpUgxJQLnT4trQ1Hg3AkURthc8ZCAT9+vOCPpPIRrWW1EIibnTjdJT+qa3ntwC4Cnr0qTd1FMkN15IPmRz5l83E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hkWQ4ZPA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hkWQ4ZPA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CBD03169C;
	Wed, 27 May 2026 03:10:25 -0700 (PDT)
Received: from [10.1.38.169] (e121487-lin.cambridge.arm.com [10.1.38.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FC323F7D8;
	Wed, 27 May 2026 03:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779876630; bh=jzeLhz2a6Zamxi++A3SvLG1E0JdfhURZoHMnNCLeFzg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hkWQ4ZPAAgkQFFXqsQ6BuC+udJPCK3XUNTH2KhHVCjkOE0p/hfdLgNuZ398zv2W3c
	 rn/zSF6GPkto869UyJKMdZhIuA2iUXqflxcP0KrfUCmdUvRDT1y60HIj7d4RVrWcwA
	 hzwWFYZkvfpF61CO6dR3TKefiljovE0gCgJBn6hE=
Message-ID: <8c36ddb9-bc54-4c68-ba34-bb5ac5912427@arm.com>
Date: Wed, 27 May 2026 11:10:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/18] KVM: arm64: Don't include <asm/fpsimdmacros.h>
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-2-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521132556.584676-2-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/26 14:25, Mark Rutland wrote:
> There's no need for hyp/entry.S to include <asm/fpsimdmacros.h>.
> 
> The fpsimd macros have never been used by code in hyp/entry.S, and were
> instead used by code in hyp/fpsimd.S.
> 
> Remove the unnecessary include.
> 
> There should be no functional change as a result of this patch.
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
>  arch/arm64/kvm/hyp/entry.S | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 11a10d8f5beb2..308100ed25de9 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -8,7 +8,6 @@
>  
>  #include <asm/alternative.h>
>  #include <asm/assembler.h>
> -#include <asm/fpsimdmacros.h>
>  #include <asm/kvm.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
> -- 2.30.2
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
