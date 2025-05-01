Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D0E22C35B
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 10:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746094302; cv=none; b=E6eIyJsm3uO4F5iFw3BXBXCeKC+v2BQVGWT+TBldzIJKT/ZQ5JtF/WUopJjQy2HnfoDdLaiQEudpISWBhE4hBws6noWlCqzDFL7IYz2HttYTOCeGEizn8pvJq+7TcsBJLJBp2wjreD+QjgBxtWZD+fNWMWobHIXTv2UaBH7w1MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746094302; c=relaxed/simple;
	bh=iyZ16sdGQsP82p+qCPamyEMebM2WjIzBkFmhKiJG1Ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ai78xOOvdBhDQ4GXyVrdkXNNg+9tbdKoKnnFLjBnpgiGj+2gtezErkKIq+E85j2Q2s9kTg2j0smsR6Mo+Wn+mvi66xhKm58lFQKX3C9BIAp1Etda3XzV3fHmpzPYVzOUTJBX4lwHpW6orxoP8utYkS69g3mBraFgoRiu0wFFsCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06365106F;
	Thu,  1 May 2025 03:11:33 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A25C13F673;
	Thu,  1 May 2025 03:11:38 -0700 (PDT)
Date: Thu, 1 May 2025 11:11:36 +0100
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
Subject: Re: [PATCH v3 08/42] arm64: sysreg: Add registers trapped by
 HFG{R,W}TR2_EL2
Message-ID: <20250501101136.GE1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-9-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-9-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:28:02PM +0100, Marc Zyngier wrote:
> Bulk addition of all the system registers trapped by HFG{R,W}TR2_EL2.
> 
> The descriptions are extracted from the BSD-licenced JSON file part
> of the 2025-03 drop from ARM.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/sysreg | 395 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 395 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 6433a3ebcef49..7969e632492bb 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2068,6 +2068,26 @@ Field	1	A
>  Field	0	M
>  EndSysreg
>  
> +Sysreg	SCTLR_EL12      3	5	1	0	0
> +Mapping	SCTLR_EL1
> +EndSysreg
> +
> +Sysreg	SCTLRALIAS_EL1  3	0	1	4	6
> +Mapping	SCTLR_EL1
> +EndSysreg
> +
> +Sysreg	ACTLR_EL1	3	0	1	0	1
> +Field   63:0    IMPDEF
> +EndSysreg
> +
> +Sysreg	ACTLR_EL12      3	5	1	0	1
> +Mapping	ACTLR_EL1
> +EndSysreg
> +
> +Sysreg	ACTLRALIAS_EL1  3	0	1	4	5
> +Mapping	ACTLR_EL1
> +EndSysreg
> +

Do you want to update CPACR_EL1 while you're at it, so that it matches
CPACRMASK_EL1?

>  Sysreg	CPACR_EL1	3	0	1	0	2
>  Res0	63:30
>  Field	29	E0POE
> @@ -2081,6 +2101,323 @@ Field	17:16	ZEN
>  Res0	15:0
>  EndSysreg
>  
> +Sysreg	CPACR_EL12      3	5	1	0	2
> +Mapping	CPACR_EL1
> +EndSysreg
> +
> +Sysreg	CPACRALIAS_EL1  3	0	1	4	4
> +Mapping	CPACR_EL1
> +EndSysreg
> +
> +Sysreg	ACTLRMASK_EL1	3	0	1	4	1
> +Field	63:0	IMPDEF
> +EndSysreg
> +
> +Sysreg	ACTLRMASK_EL12	3	5	1	4	1
> +Mapping	ACTLRMASK_EL1
> +EndSysreg
> +
> +Sysreg	CPACRMASK_EL1	3	0	1	4	2
> +Res0	63:32
> +Field	31	TCPAC
> +Field	30	TAM
> +Field	29	E0POE
> +Field	28	TTA
> +Res0	27:25	
> +Field	24	SMEN
> +Res0	23:21	
> +Field	20	FPEN
> +Res0	19:17	
> +Field	16	ZEN
> +Res0	15:0
> +EndSysreg
> +
> +Sysreg	CPACRMASK_EL12	3	5	1	4	2
> +Mapping CPACRMASK_EL1
> +EndSysreg
> +

[..]

Thanks,
Joey
