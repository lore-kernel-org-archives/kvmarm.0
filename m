From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v6 6/8] KVM: arm64: Support handling access faults for PUD
 hugepages
Date: Mon, 16 Jul 2018 13:49:40 +0100
Message-ID: <fb38da83-e1b6-ed8e-3008-d4b8af103321@arm.com>
References: <20180716110857.19310-1-punit.agrawal@arm.com>
 <20180716110857.19310-7-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716110857.19310-7-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/07/18 12:08, Punit Agrawal wrote:
> In preparation for creating larger hugepages at Stage 2, extend the
> access fault handling at Stage 2 to support PUD hugepages when
> encountered.
> 
> Provide trivial helpers for arm32 to allow sharing of code.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
