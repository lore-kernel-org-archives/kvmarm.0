Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325C3475340
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 11:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151525; cv=none; b=HY2uRwQuULfzEM8iIpR4AKpT4OqUY1NEbDPGPhiRXn8DZVoC12wW/kOe2Eh0GMkGxyHQZdiST4mALJ2rc2eG+UlForm+JfIJij3IvaYrs2pAx68m4xxBRTlDd+fro6PebpWR6wZY6MoJOV6wKRj70v+2sxOdqEXyJkaq3m7BnW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151525; c=relaxed/simple;
	bh=9oLt4k0yVG4pSkU/NV7m6aM4jq0+mfviic4Sf4D4cz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heEbCJlDRWpKC51Fz6PpQEPPJY4r+uh2VWHSRDQoPlah4H4Ug+xdpcYF2jeo0D+63GCyTwhKkUzVkPHBmE1QdRO+f9VdYRZHgGWCILcesl1i9A3N4Pq5w3HTu/5oLHN4iw+eVxIdfoTCEF0KmMuL/f78lhq56YlJaxWjARF+V7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jV16h8Rc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jV16h8Rc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 403E914BF;
	Fri, 16 Oct 2026 04:52:00 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 829943F673;
	Fri, 16 Oct 2026 04:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792151523; bh=9oLt4k0yVG4pSkU/NV7m6aM4jq0+mfviic4Sf4D4cz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jV16h8Rc7BeWT5F78lALDJYh/DElPXM6sce1x1m+hoI6BuDMfTH4IZ7w3BRzR8jJ3
	 NxAKZLUPf/4OfQahSHLbAb01qvG4Pieh+f9m9YYMIXpjAC0ROLZLGjtpvQpwQfvqdA
	 60XbyRpbRzv7kkL8H/w4VcfLgUuVV0y1C/gCwdq0=
Date: Fri, 16 Oct 2026 12:51:58 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Kohei Enju <enju.kohei@fujitsu.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 1/4] arm64: cputype: Add FUJITSU MONAKA definition
Message-ID: <atIP3ub81suIRX2g@J2N7QTR9R3.cambridge.arm.com>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-1-fc7ede7f9f48@fujitsu.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-monaka-fix-for-upstream-v2-1-fc7ede7f9f48@fujitsu.com>

On Fri, Oct 16, 2026 at 07:00:45PM +0900, Tomohiro Misono wrote:
> Add cpu part definition for FUJITSU-MONAKA.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>

FWIW, this looks fine, so:

Acked-by: Mark Rutland <mark.rutland@arm.com>

I assume that Will and Catalin pick up along with the other patches,
when folk are happy they're all ready.

Mark.

> ---
>  arch/arm64/include/asm/cputype.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index 1fa29616e586e..3f648cb10e61c 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -138,6 +138,7 @@
>  #define NVIDIA_CPU_PART_OLYMPUS		0x010
>  
>  #define FUJITSU_CPU_PART_A64FX		0x001
> +#define FUJITSU_CPU_PART_MONAKA		0x003
>  
>  #define HISI_CPU_PART_TSV110		0xD01
>  #define HISI_CPU_PART_HIP09			0xD02
> @@ -235,6 +236,7 @@
>  #define MIDR_NVIDIA_CARMEL MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_CARMEL)
>  #define MIDR_NVIDIA_OLYMPUS MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_OLYMPUS)
>  #define MIDR_FUJITSU_A64FX MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_A64FX)
> +#define MIDR_FUJITSU_MONAKA MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_MONAKA)
>  #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
>  #define MIDR_HISI_HIP09 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP09)
>  #define MIDR_HISI_HIP12 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP12)
> 
> -- 
> 2.43.0
> 
