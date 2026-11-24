Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795519980;
	b=45vrA/piqiSujggMvInbYBusm+yrRJRQzHXt1dEnXd785QsBDIdQXXI5LxvWLWKa9hkk
	 q9MG1GRVpmQY6b7/GobO/hL+t+hRFfDly37xsgXEgV8xRcpTjiXMfqGoDd6QiWGWYjRXY
	 X37M9/Z5ALe17Y9XaYzSG7UyblnsFNJ717572r/ACdf0mhW0BtCccULPF3IZ633xa/EBd
	 d5hN/2hNv8KI1Ud5fLE6nugp8LmEkQg843b9mxw+0UASslKqwZV8WFdDphS3/ysKtOmgC
	 kbsXIpLHHYYu4DamhbihbKin1fJX/IsTMuvE5ZYhwncZhcdWmyklIbhUE+WEgQCpiUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795519980;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=SSz1UkrPYOtP7qjRzAhNmZAnsxclw+c33mPfbQ/t5hM=;
	b=YQGpMQWd742czK5kmLDNrby/Ygs0nLKFhL7AX3JMAtgQOubRG8k4cExTWrPzKFji6y82
	 Zp2Sv7y2JTWuA7uIAMyjCKz1Ws/1UNCTdIG+2hBKK+5dSFgCOPE4IgKop3p72ktsKvbV1
	 ftdrJxq1kDhaSxuAVMiI4JWP4qmypXUnxmy72XarX9ABI2N2eaDG6FAC+wK9Lz52r+W4M
	 iIsa5HHLUzMIBrrFXPDgUch6uNCfcjj9fDdmW20UJ0jHpFQ4iaErQi1lskOpptIlwNkLM
	 JqsB6ewueuu7G9IQjsmPjN8tWrb/9q0rmUIjy1myf2wXEQyK/rPs1Pg6DJR+fM2Ov/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=H5MXMBDM;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850F5606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 11:32:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 850F5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=H5MXMBDM
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6785C339;
	Tue, 24 Nov 2026 03:32:55 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5906B3F86F;
	Tue, 24 Nov 2026 03:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795519978; bh=v3Pi6dD8yf3tjc5InZwV+u8P5LclNlEmMiAiF4I5Szk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H5MXMBDMJKVCFIyGahPkkVnBRk2zGUz5hPAU1GIsup9V1bpYv2c/A7RVEs05X4yR5
	 UHBKcGMJ/KeicUdin1Q4DVsFxIbV39gmdD3c9YRrru+iuVV9tAv9/9jegJT1JdBnxt
	 tOLjTds56EIfwL8EX+LGaPXSAno4XavXzNqROgUA=
Date: Tue, 24 Nov 2026 11:32:53 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: will@kernel.org, mark.rutland@arm.com, maz@kernel.org,
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, anshuman.khandual@arm.com, tabba@google.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: Use symbolic constants for the ccmp NZCV
 immediates
Message-ID: <awV15Rv-caDclC9K@arm.com>
References: <20261009072147.474952-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009072147.474952-1-fuad.tabba@linux.dev>

On Fri, Oct 09, 2026 at 08:21:47AM +0100, Fuad Tabba wrote:
> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index f7dc5fb9427d6..15c381ef7d2c2 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -30,6 +30,10 @@
>  #define PSR_MODE_THREAD_BIT	(1 << 0)
>  #define PSR_IL_BIT		(1 << 20)
>  
> +/* CCMP NZCV immediates that make the named condition hold */
> +#define CCMP_NZCV_EQ		(PSR_Z_BIT >> 28)
> +#define CCMP_NZCV_LT		(PSR_N_BIT >> 28)
> +
>  /* AArch32-specific ptrace requests */
>  #define COMPAT_PTRACE_GETREGS		12
>  #define COMPAT_PTRACE_SETREGS		13

One nit: I'd place the definitions above (or below) the
ARM64_S390_COMMON block, the generated s390 header shouldn't need them.
Otherwise it greatly improves clarity.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
