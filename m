Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED190136351
	for <kvmarm@lists.linux.dev>; Wed, 10 Dec 2025 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765391912; cv=none; b=GPzQV/4t1ngycjQacWqcuRtNSJr0DL5XMmezgWFGFr3VvaDGu0Fk89/THQP62bw+dulfnCw/Fmgf6TazEH6S0QfBHwQhaCMWj+iQb4X7sWF/L8a+IJTOKQ1CXlIW2RTg+aSmyvnL3AovXiBeBDk8tGDufVnz0qXvq2YWkS6gkiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765391912; c=relaxed/simple;
	bh=5nYPc9x60yr2tzS6GGLvfdDFPgLa9LNEOlQpb20fvCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZ4MMnXZPVhKd4SxvS1OtV1s7PrNAibmlIe3zSvZGIYDDDWhLPHEW6aUTkakv7eRpadtxdBjGMaCJVk0zp8/ic3D5QQx7XvxTTR5rKUubIhs3vDS2YG+sXZh0CgOGXXDMVmSibU8/VpsLU8M+VF1yCDWK4Ugm7QapmQZSJ0hB4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 999FD153B;
	Wed, 10 Dec 2025 10:38:22 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 735EF3F762;
	Wed, 10 Dec 2025 10:38:29 -0800 (PST)
Date: Wed, 10 Dec 2025 18:38:27 +0000
From: Leo Yan <leo.yan@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, james.clark@linaro.org,
	mark.rutland@arm.com, james.morse@arm.com
Subject: Re: [RFC PATCH v6 01/35] arm64/sysreg: Add new SPE fields
Message-ID: <20251210183827.GA3920451@e132581.arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-2-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114160717.163230-2-alexandru.elisei@arm.com>

On Fri, Nov 14, 2025 at 04:06:42PM +0000, Alexandru Elisei wrote:

[...]

>  Sysreg	PMBIDR_EL1	3	0	9	10	7
> -Res0	63:12
> +Res0	63:48
> +Field	47:32	MaxBuffSize
> +Res0	31:12
>  Enum	11:8	EA
>  	0b0000	NotDescribed
>  	0b0001	Ignored
>  	0b0010	SError
>  EndEnum
> -Res0	7:6
> +Enum	7:6	AddrMode
> +	0b00	VM_ONLY
> +	0b01	BOTH
> +	0b10	RESERVED
> +	0b11	nVM_ONLY
> +EndEnum

Not sure how to select the enum names, but seems names above don't match
well to the definitions.  How about:

  Enum  7:6     AddrMode
        0b00    VA_ONLY         // Virtual address only
        0b01    VA_PA           // Virtual and physical address supported
        0b10    RESERVED
        0b11    VM_PA_ONLY      // Physical address only in VM

Thanks,
Leo
