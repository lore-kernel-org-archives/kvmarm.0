Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC4221127E
	for <kvmarm@lists.linux.dev>; Fri, 18 Apr 2025 20:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745009344; cv=none; b=HZTXPI0UN/pbsZQuycE0fxKoGVLl6s7VWoNR8e7XQuP8xCkA+Z7nSRTTsGHaVngmNONfreN1/7Ye7QOhcA2b1PrCT7jqlwWJcawMaBHCT4CrzXrrlLidDbBQ51AUmq+EXFajuNIwL62oUmDVbxF/CxsMH3HOjPmCdFJh+jfuzwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745009344; c=relaxed/simple;
	bh=o6rWC2OdM2Kqh/YVF0TxD6ZhXq/Hm3vxJRNKeDi3SB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nRFPtCM1G+dD1tS6+oUHnP9lKUYZAnE2+N8khRowRcD/CD7tmUyLvTRyyDALzEeHwaHy10mNlsQrQT8w+4ZqXHyAamMzqX+JUpHPcgOVaMRjXVI3dtVCoNUcYvaDUxQlHIs1nCchaMzY+URrxpn9TjuzyX1dCQDTd47GnNGZ6sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E07CC4CEE2;
	Fri, 18 Apr 2025 20:49:02 +0000 (UTC)
Date: Fri, 18 Apr 2025 21:49:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2] arm64: Rework checks for broken Cavium HW in the PI
 code
Message-ID: <aAK6vPL0pizysMtH@arm.com>
References: <20250418093129.1755739-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250418093129.1755739-1-maz@kernel.org>

On Fri, Apr 18, 2025 at 10:31:29AM +0100, Marc Zyngier wrote:
> Calling into the MIDR checking framework from the PI code has recently
> become much harder, due to the new fancy "multi-MIDR" support that
> relies on tables being populated at boot time, but not that early that
> they are available to the PI code. There are additional issues with
> this framework, as the code really isn't position independend *at all*.
> 
> This leads to some ugly breakages, as reported by Ada.
> 
> It so appears that the only reason for the PI code to call into the
> MIDR checking code is to cope with The Most Broken ARM64 System Ever,
> aka Cavium ThunderX, which cannot deal with nG attributes that result
> of the combination of KASLR and KPTI as a consequence of Erratum 27456.
> 
> Duplicate the check for the erratum in the PI code, removing the
> dependency on the bulk of the MIDR checking framework. This allows
> dropping that same check from kaslr_requires_kpti(), as the KPTI code
> already relies on the ARM64_WORKAROUND_CAVIUM_27456 cap.
> 
> Fixes: c8c2647e69bed ("arm64: Make  _midr_in_range_list() an exported function")
> Reported-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/3d97e45a-23cf-419b-9b6f-140b4d88de7b@arm.com
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Oliver, if you are in a timezone where you are still working, please
pick it up. I might not have time until Monday otherwise.

Thanks.

-- 
Catalin
