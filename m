Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90E529ACDB
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 19:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774639239; cv=none; b=lPVpFqkODPM8PB96chWSmKleHl6dfqdkzUYWWIHuwNQTqeSp5o6WOByq9TWyLK6fML+N81pU17XhYWVtavMRqI8/YSBuFfgXMfcmNafqkP6eNAdDRjRtYbkfNXs+pMbmI2UmRX9A8dkifU5koN6Otx3VhBhomTkE8ZKx1IjZPLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774639239; c=relaxed/simple;
	bh=pgd264vHItCz+8HKmURdPzTDMcEbMwsjqx6znfulYR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4o4Dp/pXwgSa53kM34nVKq2dLuh00dk3Dqtn5U4SkVhg9gCY9lpdSt7au88iYuAjyPRSBB883Yp8uwhe6jZ/JVsjXt4Uf3UeLtjiywQSuSJxT7stXkSDjDtxtHXRlV7mjPxOxGhQA7nL9tuztdV7fKL7waI7q7nd9I1Id5gNgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O7yDXUUF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O7yDXUUF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 763B63D64;
	Fri, 27 Mar 2026 12:20:31 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F9023F99C;
	Fri, 27 Mar 2026 12:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774639237; bh=pgd264vHItCz+8HKmURdPzTDMcEbMwsjqx6znfulYR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O7yDXUUF3NY9AOFm5HMuWmHqrUt5k2gYeuhkdm32MDk3V0RHCeL0MlNbSG5QdsTIe
	 KgTqJ+y6twH8Di37UoHtcFzkLDLAkfHeHBarfZKG8TzZ2eiSb90xbdY57ISBpfhoj8
	 +oDnzCIetfUpLrLtc2rfw45w/NMtaAQg1y2BGk/0=
Date: Fri, 27 Mar 2026 19:20:31 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH V2 0/2] arm64/mm: Drop TTBR_CNP_BIT and TTBR_ASID_MASK
Message-ID: <177463910135.2669909.9878459656482435980.b4-ty@arm.com>
References: <20260302064437.2791034-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302064437.2791034-1-anshuman.khandual@arm.com>

On Mon, 02 Mar 2026 06:44:35 +0000, Anshuman Khandual wrote:
> Directly use existing tools sysreg format field macros TTBRx_EL1_CNP_BIT/
> TTBRx_EL1_ASID_MASK, while also dropping off now redundant custom macros
> TTBR_CNP_BIT and TTBR_ASID_MASK. With this change in place, there are no
> more TTBR_EL1 register based custom macros left in the tree.
> 
> This was discussed and suggested earlier.
> 
> [...]

Applied to arm64 (for-next/ttbr-macros-cleanup), thanks!

[1/2] arm64/mm: Directly use TTBRx_EL1_ASID_MASK
      (no commit info)
[2/2] arm64/mm: Directly use TTBRx_EL1_CnP
      (no commit info)

-- 
Catalin
