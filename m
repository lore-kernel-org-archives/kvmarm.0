Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910FC23A2
	for <kvmarm@lists.linux.dev>; Sat,  5 Aug 2023 10:14:50 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E5BE1FB;
	Sat,  5 Aug 2023 03:15:32 -0700 (PDT)
Received: from [10.57.90.200] (unknown [10.57.90.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5BD03F5A1;
	Sat,  5 Aug 2023 03:14:46 -0700 (PDT)
Message-ID: <63e20343-b95c-308f-ac43-8285ef164caf@arm.com>
Date: Sat, 5 Aug 2023 11:14:45 +0100
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
To: James Clark <james.clark@arm.com>, coresight@lists.linaro.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>, Leo Yan <leo.yan@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Rob Herring
 <robh@kernel.org>, linux-kernel@vger.kernel.org,
 Steve Clevenger <scclevenger@os.amperecomputing.com>,
 Tanmay Jagdale <tanmay@marvell.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20230804101317.460697-1-james.clark@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230804101317.460697-1-james.clark@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Cc: Ganpatrao, Steve, Tanmay

On 04/08/2023 11:13, James Clark wrote:
> Hi,
> 
> I'm looking for help in testing this and for feedback on whether it's
> useful to anyone. Testing it requires hardware that has Feat_TRF (v8.4)
> but no TRBE. This is because TRBE usage is disabled in nVHE guests.
> 
> I don't currently have any access to any hardware, and the FVP model
> can only do self hosted trace using TRBE.


If you have a v8.4+ (and not v9) HW, please could you give this a spin ?

Suzuki


> 
> Currently with nVHE you would always get trace from guests, and
> filtering out isn't possible without this patchset. In comparison, with
> VHE guests, they never generate guest trace without [1]. I think the
> existence of trace rather than lack of could suggest that this change is
> less useful than [1]. Also the restricted set of hardware that it works
> on supports that too.
> 
> Apart from compilation and checking that the exclude guest settings
> are correctly programmed on guest switch, this is untested by me.
> 
> Applies to kvmarm/next (3b4e3afb2032)
> 
> [1]: https://lore.kernel.org/linux-arm-kernel/20230804085219.260790-3-james.clark@arm.com/
> 
> James Clark (3):
>    arm64: KVM: Add support for exclude_guest and exclude_host for ETM
>    arm64: KVM: Support exclude_guest for Coresight trace in nVHE
>    coresight: Support exclude_guest with Feat_TRF and nVHE
> 
>   arch/arm64/include/asm/kvm_host.h             | 10 +++-
>   arch/arm64/kvm/Makefile                       |  1 +
>   arch/arm64/kvm/arm.c                          |  1 +
>   arch/arm64/kvm/debug.c                        |  7 +++
>   arch/arm64/kvm/etm.c                          | 48 ++++++++++++++++
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c            | 56 +++++++++++++++++--
>   .../hwtracing/coresight/coresight-etm-perf.c  |  4 ++
>   include/kvm/etm.h                             | 43 ++++++++++++++
>   8 files changed, 165 insertions(+), 5 deletions(-)
>   create mode 100644 arch/arm64/kvm/etm.c
>   create mode 100644 include/kvm/etm.h
> 

