Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7652D7DC4
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 09:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763025321; cv=none; b=A3pag3MfBY3LBRrJ7CNWbbGAkWXvaPfnBseAC0U4bowi/1UnHN0mX51rX6nnxuB/tr1ybblZb0M5+opBHpyQlas2kM2yCQJQ6s1CUWiSrKTnl6hwxgvUxaehUG5liiB3tTuCYQssYMegYE3wBHoWYFMd1D/gEoHU2mw0Vus4vT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763025321; c=relaxed/simple;
	bh=3hmQRfgvx7M+6uMJyFffDNMDcKUDOkBaIwJEzd063FI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sfyS5r9FaclPxRexMhLcYb+L20VpZmm4yLzGk0qaFTtWbGxAGOdr8iJrgg0B2SztaCOw4Q7KOOasa1NYWWTtc9U3ANkGS+f6iyL36Q2hq4rErjaUUs+CeXfy2/0hYfE3P275+bxkQrdwTOBn97Ud1DS+5oP93wTg8BvUyaMxZ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E72F812FC;
	Thu, 13 Nov 2025 01:15:11 -0800 (PST)
Received: from [10.163.74.57] (unknown [10.163.74.57])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 066DD3F66E;
	Thu, 13 Nov 2025 01:15:15 -0800 (PST)
Message-ID: <116d9f13-b82a-4361-9a62-c0207da25576@arm.com>
Date: Thu, 13 Nov 2025 14:45:12 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] arm64/mm: Add remaining TLBI_XXX_MASK macros
To: linux-arm-kernel@lists.infradead.org
Cc: ben.horgan@arm.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251024040207.137480-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251024040207.137480-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/10/25 9:32 AM, Anshuman Khandual wrote:
> Add remaining TLBI_XXX_MASK macros. But before that drop one redundant
> 'level' trimming operation in __tlbi_level().
> 
> Changes in V2:
> 
> - Added KVM changes required to accommodate TLBI_TTL_MASK split
> - Updated the commit message
> 
> Changes in V1:
> 
> https://lore.kernel.org/all/20251021052022.2898275-1-anshuman.khandual@arm.com/
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org> 
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvmarm@lists.linux.dev
> 
> Anshuman Khandual (2):
>   arm64/mm: Drop redundant 'level' range trimming in __tlbi_level()
>   arm64/mm: Add remaining TLBI_XXX_MASK macros
> 
>  arch/arm64/include/asm/tlbflush.h | 26 ++++++++++++++++++--------
>  arch/arm64/kvm/nested.c           |  8 +++++---
>  2 files changed, 23 insertions(+), 11 deletions(-)
> 

Gentle ping. Any updates or concerns regarding these changes ?
