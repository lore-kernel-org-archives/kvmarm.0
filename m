Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A535258
	for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 10:06:14 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67CD31FB;
	Wed, 17 May 2023 03:06:56 -0700 (PDT)
Received: from [10.57.58.217] (unknown [10.57.58.217])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1B3E3F663;
	Wed, 17 May 2023 03:06:09 -0700 (PDT)
Message-ID: <fe6f3e07-e24e-65a9-510f-00bdb25ae807@arm.com>
Date: Wed, 17 May 2023 11:06:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 0/2] KVM: arm64: Handle MTE Set/Way CMOs
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20230515204601.1270428-1-maz@kernel.org>
Content-Language: en-GB
From: Steven Price <steven.price@arm.com>
In-Reply-To: <20230515204601.1270428-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/05/2023 21:45, Marc Zyngier wrote:
> When the MTE support was added, it seens the handling of MTE Set/Way
> was ommited, meaning that the guest will get an UNDEF if it tries to
> do something that is quite stupid, but still allowed by the
> architecture...

Sorry about that, as you say it's quite a stupid thing for a guest to
attempt and it hadn't occurred to me when implementing KVM support.

Both patches:

Reviewed-by: Steven Price <steven.price@arm.com>

Thanks,

Steve

> 
> Found by inspection while writting the trap support for NV.
> 
> Marc Zyngier (2):
>   arm64: Add missing Set/Way CMO encodings
>   KVM: arm64: Handle trap of tagged Set/Way CMOs
> 
>  arch/arm64/include/asm/sysreg.h |  6 ++++++
>  arch/arm64/kvm/sys_regs.c       | 19 +++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 

