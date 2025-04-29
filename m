Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FD1154BE2
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 13:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745933683; cv=none; b=Fb+nYVO5DumBynBFxFLdKmZyffFCBAjuPNH6JcHKTPkaxLUNZUxXLlxXx5FpnqkoVJJQhUaYDMX3mu3/aKhVktGBbBHC95n99idhDOajRAYA08eXzOm0x6tN6gLcIBwA1eeQGBrviuiWWbBrq13zhkq4qCAQbyptPKykqwspoSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745933683; c=relaxed/simple;
	bh=D6JBBbUQDZG/CPoNWeIlzaW5z9Ba5ZRvycIS7RbdHMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPE6ESYNi8+ulKgEzH7fgOp99i65AXOk2EZClRKYeNNpSjsgN0qDIL3oYULzB45nX8+n3+JMWx+X9J7GC5VuijBJN/xkcCjOTNMZVQ7RdE6hiKygieWIjuYUKTjH6aeALvP16h3ODZBjYaV0MVfl6PQHXZMEJh3NHIVMNPuLXeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82F3D1515;
	Tue, 29 Apr 2025 06:34:33 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7898F3F673;
	Tue, 29 Apr 2025 06:34:38 -0700 (PDT)
Date: Tue, 29 Apr 2025 14:34:32 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 01/42] arm64: sysreg: Add ID_AA64ISAR1_EL1.LS64
 encoding for FEAT_LS64WB
Message-ID: <20250429133432.GA1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-2-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:27:55PM +0100, Marc Zyngier wrote:
> The 2024 extensions are adding yet another variant of LS64
> (aptly named FEAT_LS64WB) supporting LS64 accesses to write-back
> memory, as well as 32 byte single-copy atomic accesses using pairs
> of FP registers.
> 
> Add the relevant encoding to ID_AA64ISAR1_EL1.LS64.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/sysreg | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index bdf044c5d11b6..e5da8848b66b5 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1466,6 +1466,7 @@ UnsignedEnum	63:60	LS64
>  	0b0001	LS64
>  	0b0010	LS64_V
>  	0b0011	LS64_ACCDATA
> +	0b0100	LS64WB
>  EndEnum
>  UnsignedEnum	59:56	XS
>  	0b0000	NI

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
