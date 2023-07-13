Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3ADA1ED23
	for <kvmarm@lists.linux.dev>; Thu, 13 Jul 2023 15:22:18 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 751AE1570;
	Thu, 13 Jul 2023 08:23:00 -0700 (PDT)
Received: from [10.57.36.17] (unknown [10.57.36.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 864113F73F;
	Thu, 13 Jul 2023 08:22:16 -0700 (PDT)
Message-ID: <c4a6509b-b77f-fdc5-9605-cf677ce961d1@arm.com>
Date: Thu, 13 Jul 2023 16:22:15 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v5 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
References: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
 <20230712-kvm-arm64-fgt-v5-2-dae3ec236288@kernel.org>
 <740731b6-5f3f-7acd-6d9f-8adfcef833ab@arm.com>
 <9dedca62-7821-461f-805f-9550b17efd48@sirena.org.uk>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <9dedca62-7821-461f-805f-9550b17efd48@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/07/2023 16:15, Mark Brown wrote:
> On Thu, Jul 13, 2023 at 10:48:54AM +0100, Suzuki K Poulose wrote:
>> On 12/07/2023 13:50, Mark Brown wrote:
> 
>>> +	/* We currently assume the host configuration never changes */
>>> +	vcpu->arch.hfgrtr_el2_host = read_sysreg_s(SYS_HFGRTR_EL2);
>>> +	vcpu->arch.hfgwtr_el2_host = read_sysreg_s(SYS_HFGWTR_EL2);
> 
>> Doesn't this crash an nVHE host ?
> 
> This series is probably moot given Marc's nv series (or at least needs
> another rework) but could you expand on the issue you're seeing please?

I haven't tried it. But we are reading a EL2 register and this could be
executed from EL1 in nVHE/protected mode and could crash the host ?

Suzuki
