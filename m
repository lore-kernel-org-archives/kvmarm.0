Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50FA023DC
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 08:37:46 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36B88DA7;
	Tue, 26 Sep 2023 01:38:23 -0700 (PDT)
Received: from [192.168.1.3] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D74EF3F5A1;
	Tue, 26 Sep 2023 01:37:42 -0700 (PDT)
Message-ID: <70867968-55c1-a1f2-58d5-cc332b4a51df@arm.com>
Date: Tue, 26 Sep 2023 09:37:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 1/2] arm64/sysreg: Move TRFCR definitions to sysreg
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, broonie@kernel.org, maz@kernel.org,
 Will Deacon <will@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Mike Leach <mike.leach@linaro.org>, Leo Yan <leo.yan@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 James Morse <james.morse@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Rob Herring
 <robh@kernel.org>, Jintack Lim <jintack.lim@linaro.org>,
 Joey Gouly <joey.gouly@arm.com>, linux-kernel@vger.kernel.org
References: <20230905102117.2011094-1-james.clark@arm.com>
 <20230905102117.2011094-2-james.clark@arm.com> <ZRGuUSkwKqeZ3+ot@arm.com>
Content-Language: en-US
From: James Clark <james.clark@arm.com>
In-Reply-To: <ZRGuUSkwKqeZ3+ot@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 25/09/2023 16:59, Catalin Marinas wrote:
> On Tue, Sep 05, 2023 at 11:21:14AM +0100, James Clark wrote:
>> Add separate definitions for ELx and EL2 as TRFCR_EL1 doesn't have CX.
>> This also mirrors the previous definition so no code change is required.
>>
>> Signed-off-by: James Clark <james.clark@arm.com>
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> I assume these patches would go in via the coresight tree.

Possibly, but I'm working on a V4 that combines the nVHE version and
Suzuki's comment from here [1]. There will be more kvm patches in that
one so I'm not sure.

[1]:
https://lists.linaro.org/archives/list/coresight@lists.linaro.org/message/A6OVUHKZZXJZG5MQ2T7VYHBAD6NOSBD7/
