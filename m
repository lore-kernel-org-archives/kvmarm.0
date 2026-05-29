Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703FA34F259
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 08:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780044146; cv=none; b=HgshHaHGXqtM1K+eDxL/nf1EP89quwiBVVAp/6rHCgaeA+thX1aJfExWqvAktnEZuq8RQ2nrcLgbeLi3j7SLyR0KeTPypGoKzWY+rJokidSfEgzGKq6RX7mlI6rjMvGhGMFWiz/y7ju8sFzaBDb83wKjhaSr4IakRTOUYaPqu5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780044146; c=relaxed/simple;
	bh=AqR1rgWXEAXIlDqc3S6o5bYfI/ctZcgtp61gxbnNDAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dIvlQp96ZpbztidZ5GVuBmbXGIBTX4sfdqN+SiBrIejBqh/O8ig+fuOwxKAT/769+Fpa6tDXXOKAd8YaG2B+t/Uv+19qfMEV4ZRGo39AEhbW70AYILTcUz6Z6SpUPLCBN2UbsyVwda+IcQ0HMRBwplai1fqzudDCWNPej9dFw1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jUImnIYE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jUImnIYE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A376E204C;
	Fri, 29 May 2026 01:42:19 -0700 (PDT)
Received: from [10.1.26.144] (unknown [10.1.26.144])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93BE83F632;
	Fri, 29 May 2026 01:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780044144; bh=AqR1rgWXEAXIlDqc3S6o5bYfI/ctZcgtp61gxbnNDAM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jUImnIYEBKOSJQYKz4x0DaqpeEuJ9Qr9MWkEiUoVlXISyZLeGWboNtVdv107aJtWp
	 LTyx6SzO+LnBvYKDBDg5u7ci/lQi63GA/SoHgDZKce8rCceTGyyTdJOSk8z1q/gpvo
	 PF/Je2bUH9nlgCJs8wQ8XuDc3jDe3tRwN2v5IAtA=
Message-ID: <b097ee0f-e517-47e3-9bfc-167f72e177a3@arm.com>
Date: Fri, 29 May 2026 09:42:20 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/18] arm64: sysreg: Add FPCR and FPSR
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260528165446.701944-1-mark.rutland@arm.com>
 <20260528165446.701944-11-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260528165446.701944-11-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/26 17:54, Mark Rutland wrote:
> Add sysreg definitions for FPCR and FPSR.
> 
> Some versions of LLVM will refuse to assemble accesses to FPCR and FPSR
> unless the "fp" arch extension is enabled, which we don't currently do
> for read_sysreg() and write_sysreg(). In general, handling feature
> dependencies would complicate read_sysreg() and write_sysreg(), and it's
> simpler to use read_sysreg_s() and write_sysreg_s() instead, requiring
> sysreg definitions.
> 
> The values used can be found in ARM ARM issue M.b:
> 
>   https://developer.arm.com/documentation/ddi0487/mb/
> 
> ... in sections:
> 
> * C5.2.8 ("FPCR, Floating-point Control Register")
> * C5.2.10 ("FPSR, Floating-point Status Register")
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
>  arch/arm64/tools/sysreg | 45 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 6c3ff14e561e6..8b219d6566608 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3790,6 +3790,51 @@ Field	1	ZA
>  Field	0	SM
>  EndSysreg
>  
> +Sysreg	FPCR	3	3	4	4	0
> +Res0	63:27
> +Field	26	AHP
> +Field	25	DN
> +Field	24	FZ
> +Enum	23:22	RMode
> +	0b00	RN
> +	0b01	RP
> +	0b10	RM
> +	0b11	RZ
> +EndEnum
> +Field	21:20	Stride
> +Field	19	FZ16
> +Field	18:16	Len
> +Field	15	IDE
> +Res0	14
> +Field	13	EBF
> +Field	12	IXE
> +Field	11	UFE
> +Field	10	OFE
> +Field	9	DZE
> +Field	8	IOE
> +Res0	7:3
> +Field	2	NEP
> +Field	1	AH
> +Field	0	FIZ
> +EndSysreg
> +
> +Sysreg	FPSR	3	3	4	4	1
> +Res0	63:32
> +Field	31	N
> +Field	30	Z
> +Field	29	C
> +Field	28	V
> +Field	27	QC
> +Res0	26:8
> +Field	7	IDC
> +Res0	6:5
> +Field	4	IXC
> +Field	3	UFC
> +Field	2	OFC
> +Field	1	DZC
> +Field	0	IOC
> +EndSysreg
> +
>  Sysreg	FPMR	3	3	4	4	2
>  Res0	63:38
>  Field	37:32	LSCALE2
> -- 2.30.2
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

