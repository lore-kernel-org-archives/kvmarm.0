Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCAFD8820
	for <kvmarm@lists.linux.dev>; Sat,  5 Aug 2023 10:28:43 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B78DD1FB;
	Sat,  5 Aug 2023 03:29:25 -0700 (PDT)
Received: from [10.57.90.200] (unknown [10.57.90.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF54B3F5A1;
	Sat,  5 Aug 2023 03:28:40 -0700 (PDT)
Message-ID: <a80bdc12-96f9-bdf4-8253-bf0ea305e00d@arm.com>
Date: Sat, 5 Aug 2023 11:28:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [RFC PATCH 0/3] coresight: Support exclude_guest with Feat_TRF
 and nVHE
To: Marc Zyngier <maz@kernel.org>, James Clark <james.clark@arm.com>
Cc: coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>, Leo Yan <leo.yan@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Rob Herring
 <robh@kernel.org>, linux-kernel@vger.kernel.org
References: <20230804101317.460697-1-james.clark@arm.com>
 <86edki62vz.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86edki62vz.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc

On 04/08/2023 20:09, Marc Zyngier wrote:
> On Fri, 04 Aug 2023 11:13:10 +0100,
> James Clark <james.clark@arm.com> wrote:
>>
>> Hi,
>>
>> I'm looking for help in testing this and for feedback on whether it's
>> useful to anyone. Testing it requires hardware that has Feat_TRF (v8.4)
>> but no TRBE. This is because TRBE usage is disabled in nVHE guests.
>>
>> I don't currently have any access to any hardware, and the FVP model
>> can only do self hosted trace using TRBE.
>>
>> Currently with nVHE you would always get trace from guests, and
>> filtering out isn't possible without this patchset. In comparison, with
>> VHE guests, they never generate guest trace without [1]. I think the
>> existence of trace rather than lack of could suggest that this change is
>> less useful than [1]. Also the restricted set of hardware that it works
>> on supports that too.
> 
> It'd be nice to have some sort of feature parity, but it seems like a
> vanishingly small target of users having access to an ETM sink.
> 
>>
>> Apart from compilation and checking that the exclude guest settings
>> are correctly programmed on guest switch, this is untested by me.
> 
> I'll have a look at the series, but none of my HW fits in this
> description (my ARMv8.4+ boxes don't have any form of tracing).

While I have your attention, we have another series that manages the
trace filtering for Guests on VHE, completely within the Coresight etm4x
driver here [0]. I personally think, it is good to have the guest
filtering for both nVHE and VHE under the KVM control, like we do
in this series. I would like your opinion on this.

[0] https://lkml.kernel.org/r/20230804085219.260790-1-james.clark@arm.com


Suzuki


> 
> Thanks,
> 
> 	M.
> 

