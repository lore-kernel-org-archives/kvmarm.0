Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB0B1C2AF
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 12:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91E29FEC;
	Mon, 13 Nov 2023 04:43:01 -0800 (PST)
Received: from [10.57.73.13] (unknown [10.57.73.13])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 352703F6C4;
	Mon, 13 Nov 2023 04:42:14 -0800 (PST)
Message-ID: <78a3fd4d-4712-482d-94ea-54009ba41462@arm.com>
Date: Mon, 13 Nov 2023 12:42:12 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/3] Update tlb invalidation routines for FEAT_LPA2
Content-Language: en-GB
To: Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc: Ard Biesheuvel <ardb@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Mark Rutland <mark.rutland@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Kees Cook <keescook@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231027115634.1432154-1-ryan.roberts@arm.com>
 <3800df70-73f2-44b7-a6ed-15ec0bd63f5f@arm.com> <868r7126bp.wl-maz@kernel.org>
 <CAMj1kXFw1J2JgSj6MH+Y0m3VBZ_GU2=W8DtN637pOLQvwm1zwQ@mail.gmail.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <CAMj1kXFw1J2JgSj6MH+Y0m3VBZ_GU2=W8DtN637pOLQvwm1zwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/11/2023 12:29, Ard Biesheuvel wrote:
> On Mon, 13 Nov 2023 at 22:20, Marc Zyngier <maz@kernel.org> wrote:
>>
>> On Mon, 13 Nov 2023 11:55:01 +0000,
>> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>>
>>> On 27/10/2023 12:56, Ryan Roberts wrote:
>>>> Hi All,
>>>>
>>>> As raised yesterday against Ard's LPA2 series [1], we need to address the TLBI
>>>> changes to properly support LPA2 before Ard's changes get merged. So far those
>>>> changes have been part of my KVM LPA2 series [2]. So this is an attempt to split
>>>> the TLBI changes to make them independent. The idea is that this series would go
>>>> in first, then Ard's and the rest of my series can race eachother and it doesn't
>>>> really matter who wins.
>>>>
>>>> I've attempted to address all of Marc's feedback against the versions of these
>>>> patches posted at [2], including adding benchmark data (see patch 1). Although
>>>> if people are still nervous that this could regress non-lpa2 performance in some
>>>> cases, I could rework so that there are lpa2 and non-lpa2 variants of
>>>> __flush_tlb_range_op(), and the correct version is chosen at the higher level
>>>> (based on lpa2_is_enabled() / kvm_lpa2_is_enabled()).
>>>>
>>>> It turns out that we won't be able to key LPA2 usage off the same static key for
>>>> both the kernel and kvm usage because the kernel usage additionally depends on
>>>> CONFIG_ARM64_LPA2 being enabled. So I've introduced 2 stub functions
>>>> (lpa2_is_enabled() and kvm_lpa2_is_enabled()) to advertise it. Ard already
>>>> defines and implements lpa2_is_enabled() in his series, so there will be a minor
>>>> conflict to resolve there. I plan to define kvm_lpa2_is_enabled() to be the
>>>> static key for kvm in my series. Marc, would you be happy with this approach?
>>>>
>>>> Anyway, I wanted to put this out there as an RFC. If we are happy with it, then
>>>> I'll re-post on 6.7-rc1.
>>>
>>> Marc, All,
>>>
>>> I polite bump; I never heard back on this. I'm planning to post my LPA2/KVM
>>> series on top of v6.7-rc1 in the next day or 2. By default, these 3 patches will
>>> be the first 3 of the series. But if you have an issue with the approach it
>>> would be good to work out an alternative plan to avoid wasting effort preparing
>>> the series.
>>
>> No specific concern on the approach. Having a static-key for the KVM
>> side is good, and the uplift on the range stuff seems compelling.
>>
> 
> OK, I'll put these at the start of my ++v as well.

Great - thanks both!

> 
> Thanks,
> 

