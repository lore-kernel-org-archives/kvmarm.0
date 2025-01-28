Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778D51DF73D
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 09:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738055486; cv=none; b=FirJQEwDGbniTNDW+5arf4pXK93CArnX9YqaBSahBuLZEyzzGpOz6IUVix44ZBljyxAUTYOx64J45c/TAzz18ZCriTAQkrMszvSBq3+kQy6KSSJ5LK8K6RVmUXKW1Gy1jLJR1nuafSdeYPfdVarIHTx5HNUxrzAIGZ4wigygMvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738055486; c=relaxed/simple;
	bh=FltoNwx1CJICDVmBGovb3tzHU01UgL7Ot70tmwww9PY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozXl8OL9cTvM04JXVaR3VekVR593A69aRFUv7HkePoVomtYx76eDmytA2fHiHesQ5SFEyIBO9W3kn8VISJBH51kj6fcTmSa7p4IanBSYnJkPJUg7N6dx7UXw3ULroK2fYAjbQDT94p3gDio8jd3CMdvB/109+rnqQ6Bqims26DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EE0F497;
	Tue, 28 Jan 2025 01:11:50 -0800 (PST)
Received: from [10.162.16.94] (a077893.blr.arm.com [10.162.16.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BC663F528;
	Tue, 28 Jan 2025 01:11:20 -0800 (PST)
Message-ID: <7f5c68c7-8036-4d18-950f-80e55ac8ea11@arm.com>
Date: Tue, 28 Jan 2025 14:41:17 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
To: Rob Herring <robh@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Eric Auger <eric.auger@redhat.com>,
 kvmarm@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241220072240.1003352-1-anshuman.khandual@arm.com>
 <20250102160402.GB3990035-robh@kernel.org> <Z30adHnQ7ZFaU9UR@arm.com>
 <CAL_JsqLLnh1o4L1=PpNt5brBwZZCgp7mOygByOYakchrzc29Ow@mail.gmail.com>
 <86wmf5wo8u.wl-maz@kernel.org>
 <CAL_JsqKKiEOj=a1k6U-bB0F6-ht7QokDnh3bspHupp-QG=haSg@mail.gmail.com>
 <Z4kmlhnlpKjS_MII@arm.com>
 <CAL_JsqK1k7fG=yDZSbTbV63yRP5U9=GpuAiv=NWZJWdppUtRwA@mail.gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <CAL_JsqK1k7fG=yDZSbTbV63yRP5U9=GpuAiv=NWZJWdppUtRwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/18/25 03:37, Rob Herring wrote:
> On Thu, Jan 16, 2025 at 9:32 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>>
>> On Wed, Jan 08, 2025 at 07:47:16AM -0600, Rob Herring wrote:
>>> On Wed, Jan 8, 2025 at 5:15 AM Marc Zyngier <maz@kernel.org> wrote:
>>>> On Tue, 07 Jan 2025 22:13:47 +0000,
>>>> Rob Herring <robh@kernel.org> wrote:
>>>>> On Tue, Jan 7, 2025 at 6:13 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>>>>>> But does KVM actually expose the feature to EL1 in ID_AA64DFR1_EL1 and
>>>>>> than traps it at EL2?
>>>>>
>>>>> As Marc pointed out KVM only advertises PMUv3.8. Regardless, guest
>>>>> accesses to these registers are trapped with or without this series.
>>>>
>>>> And most probably generates a nice splat in the kernel log, as nobody
>>>> updated KVM to handle *correctly* PMICNTR_EL0 traps, let alone deal
>>>> with the FGT2 registers.
>>>
>>> Isn't that this series[1]? Should that have come first, I guess I know
>>> that *now*.
>> [...]
>>> [1] https://lore.kernel.org/all/20241210055311.780688-1-anshuman.khandual@arm.com/
>>
>> It's not any clearer to me. Does this series depend on the 46-patch one?
>> Or, if we had the other, is this no longer needed? Or none of these,
>> they are independent.
> 
> They are independent. I think ideally we'd want everything landing at
> the same time, but we're past ideal at this point. Without this
> series, if someone uses PMU on v8.9 and firmware enabled FGT2, then
> the kernel will crash. Without the above series, KVM will have
> warnings in the kernel log, but otherwise function.

Right, they are independent. Just that Rob had observed this PMU v3.8 boot
requirement while reviewing the HW breakpoint series earlier. I should just
respin this series after the upcoming v6.14-rc1 release is out ?
