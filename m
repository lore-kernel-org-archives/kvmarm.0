From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v6 1/8] KVM: arm/arm64: Share common code in
 user_mem_abort()
Date: Mon, 16 Jul 2018 13:45:05 +0100
Message-ID: <c28e1aa4-c0f1-8010-6a11-005e7f1db01c@arm.com>
References: <20180716110857.19310-1-punit.agrawal@arm.com>
 <20180716110857.19310-2-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716110857.19310-2-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 16/07/18 12:08, Punit Agrawal wrote:
> The code for operations such as marking the pfn as dirty, and
> dcache/icache maintenance during stage 2 fault handling is duplicated
> between normal pages and PMD hugepages.
> 
> Instead of creating another copy of the operations when we introduce
> PUD hugepages, let's share them across the different pagesizes.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>

Thanks for splitting the patch. It looks much simpler this way.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
