Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81B77F48C;
	Mon, 10 Jun 2024 14:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718029017; cv=none; b=UksmM9LelVygUbXvafifNOGGOHix7wX/C1I4ttRCMjIERivB2LJhWrb3To0lW5k+PSBxWUvSZHlsVcC92BlQNnogHIP5G7l66biZG2BmP6UF3/lASLVya2DNmiSRXS+dBaVP9ZN/HV+jMu1N7xipUqCghxX2M96morkLXREY9r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718029017; c=relaxed/simple;
	bh=4HS81ASWp6hOMozhfLKqK3VhDPIEvMdvM0yobdh++Ys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O0g0qyDqOzO5CA6Z/smmrldKMFqSB7i9sb/eDzQh1hdu+rbR8QzBsOeCrDtqyYHzNkeCb2qQRzNXLcJeD+12UZ+m2UhzqkTgrYqnO5yu1bI7ciluHcvjGa8cvAM+NuqIIUB77adPNnS/UsLmizTLypjZEWTyJaJ20Ek5r5WXp/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9807A106F;
	Mon, 10 Jun 2024 07:17:18 -0700 (PDT)
Received: from [10.1.35.41] (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 875323F73B;
	Mon, 10 Jun 2024 07:16:50 -0700 (PDT)
Message-ID: <dd86dbe3-689e-4488-b2bc-100d0f5fac04@arm.com>
Date: Mon, 10 Jun 2024 15:16:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/14] arm64: Detect if in a realm and set RIPAS RAM
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-3-steven.price@arm.com> <ZmcJmvBDtjaLay5k@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZmcJmvBDtjaLay5k@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/06/2024 15:11, Catalin Marinas wrote:
> On Wed, Jun 05, 2024 at 10:29:54AM +0100, Steven Price wrote:
>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>> index 9b5ab6818f7f..9d8d38e3bee2 100644
>> --- a/arch/arm64/mm/init.c
>> +++ b/arch/arm64/mm/init.c
>> @@ -41,6 +41,7 @@
>>  #include <asm/kvm_host.h>
>>  #include <asm/memory.h>
>>  #include <asm/numa.h>
>> +#include <asm/rsi.h>
>>  #include <asm/sections.h>
>>  #include <asm/setup.h>
>>  #include <linux/sizes.h>
> 
> What's this random include here? It looks like a leftover from the
> previous version.
> 

Whoops - indeed that shouldn't be there.

Thanks,
Steve

