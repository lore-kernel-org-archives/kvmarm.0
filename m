Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57CC22EFE
	for <kvmarm@lists.linux.dev>; Tue, 14 Nov 2023 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1129C15;
	Tue, 14 Nov 2023 03:26:10 -0800 (PST)
Received: from [10.1.27.144] (XHFQ2J9959.cambridge.arm.com [10.1.27.144])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFB0B3F641;
	Tue, 14 Nov 2023 03:25:23 -0800 (PST)
Message-ID: <250a02ea-c350-4752-89b2-aa75e5232c32@arm.com>
Date: Tue, 14 Nov 2023 11:25:22 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/3] Update tlb invalidation routines for FEAT_LPA2
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ardb@google.com>, Ard Biesheuvel <ardb@kernel.org>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Mark Rutland <mark.rutland@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Kees Cook <keescook@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231027115634.1432154-1-ryan.roberts@arm.com>
 <3800df70-73f2-44b7-a6ed-15ec0bd63f5f@arm.com> <ZVIkPm4uxbCNsOgh@arm.com>
 <1bdcdd85-9470-408c-aaac-fa4548bb2385@arm.com> <ZVJhxF4y2Tds2dRn@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ZVJhxF4y2Tds2dRn@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/11/2023 17:49, Catalin Marinas wrote:
> On Mon, Nov 13, 2023 at 04:44:58PM +0000, Ryan Roberts wrote:
>> On 13/11/2023 13:27, Catalin Marinas wrote:
>>> If these patches are needed for Ard's series (I think they do), they
>>> could be posted together. But first we need to split Ard's series into
>>> at least two: reworking the memory map together with moving (some of)
>>> the init code to C and the actual LPA2 stage 1 support. We might even
>>> through LPA2 stage 2 on top if we feel brave ;). We can queue them all
>>> together but having separate series gives us an option to drop bits if
>>> needed.
>>
>> Sorry I'm not completely sure what you are suggesting I do here. In the context
>> of the lpa2/kvm series, Marc previously said he would merge it for v6.8 if I
>> posted against v6.7-rc1 (which is what I'm gearing up for now).
> 
> If we merge your series independently of Ard's, that's fine, these three
> patches can go together as a prefix.
> 
>> My series and Ard's are independent except that they both depend on the 3
>> patches in this RFC. Ard has just suggested he would prefix his series with
>> these 3 patches and I would continue to do the same, then they can be handled as
>> 2 independent series (or more if Ard is splitting his) - the first 3 patches
>> will just desolve to nothing for the series that goes in second.
>>
>> Does that work for you, are are you suggesting I should re-post this as an
>> independent series?
> 
> No need to. Just post your LPA2 patches with these three as a prefix.
> Ard can include them as well and if it gets to merging both, we'll sort
> out a small stable branch for these three patches.
> 

Great - thanks for the clarification!
