Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B1B2DFA49
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744808783; cv=none; b=Es71DyfbaZMo/i/VfcExW7zJk3BUOaBkqKrwYOciZCMt+zGVE0a3N1tpjjDFid2NIqMBL2Vn+DnAv1U1L1r2o9WKxfVwEiHkYXnP/op32AMan6SdNiQ7P1yotDveEOUqK1WhhLc6QlOFmZKX0rUhyP7kBASvUr+EIWtYdHLXBiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744808783; c=relaxed/simple;
	bh=8wYm8UTHOfT5CbotW4lJEIJDAeRDZ93kTAruvLSO6Gs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YQk3OQh+oiPtVuufv8L8uBhkVy0xWz7VrYkVKzbOC2soVh2hfooiZeIE01HWryZh0Xgq0EPdnj9Qwd1nn/gLuIoQmruecB9M4sjL59PP+bfMLGwTidfuP3vjO8NIv879QzOwu4ElBeu7eMZFK5E3f7VOy1W/Ho92FYlfxa4BKdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FF9C1595;
	Wed, 16 Apr 2025 06:06:17 -0700 (PDT)
Received: from [10.57.43.31] (unknown [10.57.43.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 979713F694;
	Wed, 16 Apr 2025 06:06:17 -0700 (PDT)
Message-ID: <3690bbfd-a426-4fa7-b2ae-5a665c4d5c7a@arm.com>
Date: Wed, 16 Apr 2025 14:05:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: Remove checks for broken Cavium HW from the PI
 code
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Oliver Upton <oliver.upton@linux.dev>
References: <20250416123534.1108220-1-maz@kernel.org>
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Content-Language: en-US
Organization: Arm Ltd.
In-Reply-To: <20250416123534.1108220-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/04/2025 13:35, Marc Zyngier wrote:

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

Tested-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>

Thanks for the fix ! I can confirm that it resolves all boot failures I 
was observing previously.
No instances of firmware seeding KASRL in the couple of machines I am 
testing either.

Regards,
Ada

