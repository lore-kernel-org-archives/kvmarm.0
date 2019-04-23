From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH AUTOSEL 5.0 29/98] KVM: arm/arm64: Enforce PTE mappings at
 stage2 when needed
Date: Tue, 23 Apr 2019 10:27:26 +0100
Message-ID: <e166bc0d-5184-6dda-15ef-2f24d2e42203@arm.com>
References: <20190422194205.10404-1-sashal@kernel.org>
 <20190422194205.10404-29-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190422194205.10404-29-sashal@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: sashal@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: yuzenghui@huawei.com, christoffer.dall@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Sasha,

On 04/22/2019 08:40 PM, Sasha Levin wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> [ Upstream commit a80868f398554842b14d07060012c06efb57c456 ]
> 
> commit 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
> made the checks to skip huge mappings, stricter. However it introduced
> a bug where we still use huge mappings, ignoring the flag to
> use PTE mappings, by not reseting the vma_pagesize to PAGE_SIZE.
> 
> Also, the checks do not cover the PUD huge pages, that was
> under review during the same period. This patch fixes both
> the issues.
> 
> Fixes : 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>

Please be aware that we need a follow up fix for this patch to fix the
problem for THP backed memory.

http://lists.infradead.org/pipermail/linux-arm-kernel/2019-April/645324.html


It should appear upstream soon.


Cheers
Suzuki
