Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46AD7F
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 04:28:03 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58BD71FB;
	Mon, 12 Jun 2023 21:28:48 -0700 (PDT)
Received: from [10.162.42.9] (unknown [10.162.42.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16A713F587;
	Mon, 12 Jun 2023 21:27:59 -0700 (PDT)
Message-ID: <34360cc9-b2ef-ec44-db93-b93b224fe1cb@arm.com>
Date: Tue, 13 Jun 2023 09:57:57 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH V2 00/14] arm64/sysreg: Convert TRBE registers to
 automatic generation
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, broonie@kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Rob Herring <robh@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
 coresight@lists.linaro.org, linux-kernel@vger.kernel.org
References: <20230602062552.565992-1-anshuman.khandual@arm.com>
 <ZIISaXnrhDtauY2G@arm.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ZIISaXnrhDtauY2G@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/8/23 23:09, Catalin Marinas wrote:
> Hi Anshuman,
> 
> On Fri, Jun 02, 2023 at 11:55:38AM +0530, Anshuman Khandual wrote:
>> Changes in V2:
>>
>> - Renamed each individual TRBE register fields as per auto-gen tools
>> - Converted each individual TRBE registers as per auto-gen tools
>> - Added new register fields as per DDI0601 2023-03
> 
> Mark had some comments about using Enum for some bitfields. While not
> essential, it would be nice to have those fixed. It's probably easier to
> do an incremental patch fixing those, so please post one (or repost the
> whole series, whatever is easier for you).

Sure, will fold in those suggested changes and re-post the series soon.
