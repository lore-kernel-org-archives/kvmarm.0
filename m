Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53AB29B0
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 12:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744807931; cv=none; b=Ohg1ETodJHGBKdioQYXVChiV/FIGjesyrPDk6teWJ2Gdfr/AgPBlL6U5Sb2xBV/Fu2iVv2FxLWsPQMxS7Tkn+zw+GmiLWHaMyxVLq9TlkuN9XklAC0nhcOEGwlsTBtOh0YeKe3QroktcDehHNusuuc2IUK5pDLuHPoM4qUdNKVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744807931; c=relaxed/simple;
	bh=3kSX/OQFb4HV8HuQvNebltvPOcMaC+6CHpFP3ePlcQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WO3MhyDWv44DqYppX7yt+SENcAkaLeNmP64+MdY/qyRfzDcrc7MmeTWHeg222wsXzgqfW6QM+IdqQxkqP+t89+IZDgRkJR/jatKkIkHNb7DWCp3g1wRz87cC27kPLLcDXS0zZOiSo60PCFuQRjVyZ7dz++C4mXjhW57geqAdOHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A42C4CEE2;
	Wed, 16 Apr 2025 12:52:09 +0000 (UTC)
Date: Wed, 16 Apr 2025 13:52:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] arm64: Remove checks for broken Cavium HW from the PI
 code
Message-ID: <Z_-n92KXv38WCWWx@arm.com>
References: <20250416123534.1108220-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250416123534.1108220-1-maz@kernel.org>

On Wed, Apr 16, 2025 at 01:35:34PM +0100, Marc Zyngier wrote:
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
> Rather than adding extra complexity for something that is actually
> a very dead horse, let's simply drop that check. On my own machine,
> the firmware doesn't provide a KASLR seed, preventing the pathological
> case to show up.
> 
> And if someone does have a broken box that passes a seed to the kernel,
> "nokaslr" on the command-line is an easy enough workaround.
> 
> Fixes: c8c2647e69bed ("arm64: Make  _midr_in_range_list() an exported function")
> Reported-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/3d97e45a-23cf-419b-9b6f-140b4d88de7b@arm.com
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

The fixed commit went in via the KVM tree. Oliver, Marc, let me know if
you'd like me to take this as a fix via the arm64 tree (either way is
fine by me).

Thanks.

-- 
Catalin
