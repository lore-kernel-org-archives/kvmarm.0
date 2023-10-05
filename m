Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39EC43B7A7
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0338C15;
	Thu,  5 Oct 2023 11:05:15 -0700 (PDT)
Received: from [10.57.2.226] (unknown [10.57.2.226])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35C893F641;
	Thu,  5 Oct 2023 11:04:34 -0700 (PDT)
Message-ID: <03b59965-b00e-8b91-0cdc-3c9ce996a284@arm.com>
Date: Thu, 5 Oct 2023 19:04:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/6] arm64: KVM: Rename DEBUG_STATE_SAVE_TRBE to
 DEBUG_STATE_SAVE_TRFCR
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: James Clark <james.clark@arm.com>, coresight@lists.linaro.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 broonie@kernel.org, maz@kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>, Leo Yan <leo.yan@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Rob Herring
 <robh@kernel.org>, Jintack Lim <jintack.lim@linaro.org>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Fuad Tabba <tabba@google.com>,
 Joey Gouly <joey.gouly@arm.com>, linux-kernel@vger.kernel.org
References: <20231005125757.649345-1-james.clark@arm.com>
 <20231005125757.649345-3-james.clark@arm.com>
 <f33a9903-4c6e-53b4-8a24-f5afe2e1cced@arm.com>
In-Reply-To: <f33a9903-4c6e-53b4-8a24-f5afe2e1cced@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/10/2023 17:41, Suzuki K Poulose wrote:
> On 05/10/2023 13:57, James Clark wrote:
>> This flag actually causes the TRFCR register to be saved, so rename it
>> to that effect.
>>
>> Currently it only happens when TRBE is used, but in a later commit
>> TRFCR will be saved and restored even if TRBE isn't used, so the new
>> name will be more accurate.
>>
>> Signed-off-by: James Clark <james.clark@arm.com>
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewing the patch 5, this change may need to be dropped
and instead we need to add a new flag for TRFCR.

Suzuki

> 
> 

