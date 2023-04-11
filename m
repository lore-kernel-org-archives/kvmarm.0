Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB858F6C
	for <kvmarm@lists.linux.dev>; Tue, 11 Apr 2023 16:58:05 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BED4D75;
	Tue, 11 Apr 2023 09:58:49 -0700 (PDT)
Received: from [10.1.38.164] (e126864.cambridge.arm.com [10.1.38.164])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 04A943F73F;
	Tue, 11 Apr 2023 09:58:01 -0700 (PDT)
Message-ID: <ed690c50-5188-e5f5-962a-b2b87d7ecf60@arm.com>
Date: Tue, 11 Apr 2023 17:57:34 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 04/10] arm64: mops: document boot requirements for MOPS
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Mark Brown <broonie@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Vladimir Murzin <vladimir.murzin@arm.com>, linux-kernel@vger.kernel.org
References: <20230216160012.272345-1-kristina.martsenko@arm.com>
 <20230216160012.272345-5-kristina.martsenko@arm.com>
 <ZBSCObGmIXjyeMA6@arm.com> <61b0e30a-568c-d7f6-7b67-e9fc8b68de25@arm.com>
 <ZCwA+rbmFT2HaZ7G@arm.com>
From: Kristina Martsenko <kristina.martsenko@arm.com>
In-Reply-To: <ZCwA+rbmFT2HaZ7G@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/04/2023 11:50, Catalin Marinas wrote:
> On Fri, Mar 24, 2023 at 01:00:43AM +0000, Kristina Martsenko wrote:
>> On 17/03/2023 15:07, Catalin Marinas wrote:
>>> On Thu, Feb 16, 2023 at 04:00:06PM +0000, Kristina Martsenko wrote:
>>>> +  For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
>>>> +
>>>> +  - If the kernel is entered at EL1 and EL2 is present:
>>>> +
>>>> +    - HCRX_EL2.MSCEn (bit 11) must be initialised to 0b1.
>>>> +
>>>> +    - HCRX_EL2.MCE2 (bit 10) must be initialised to 0b0.
>>>
>>> Regarding MCE2, does EL1 actually care if EL2 wants to handle all the
>>> memcpy/memset exceptions? 
>>
>> Note that this series does not add support for mops in guests yet. 
> 
> You mean there's no KVM support. But Linux may be run under a different
> hypervisor (e.g. Hyper-V) as a guest.
> 
>> I think booting.txt can be updated when that support is added.
> 
> In booting.txt, when you say the kernel entered at EL1, it implies that
> it may be run as a guest under a random hypervisor.
> 
> So maybe we should detail the MCE2 requirement a bit, saying that it can
> be either 0 or 1 but, for the latter, the hypervisor must handle the
> corresponding exceptions.

That makes sense. I was going to add this, but then realized that MCE2 only
traps memcpy exceptions from EL1, not EL0, so it does not have any effect with
this series. So I think we can just drop the MCE2 requirement entirely for now
and specify the requirement later when we add memcpy instructions into the
kernel itself.

Thanks,
Kristina

