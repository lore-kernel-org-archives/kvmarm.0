From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 4/4] KVM: arm64: Add support for PUD hugepages at
 stage 2
Date: Tue, 15 May 2018 18:22:01 +0100
Message-ID: <20180515172200.hw24lgd6qh436xvy@armageddon.cambridge.arm.com>
References: <20180514144304.10484-1-punit.agrawal@arm.com>
 <20180514144304.10484-5-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180514144304.10484-5-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com, marc.zyngier@arm.com, Will Deacon <will.deacon@arm.com>, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 14, 2018 at 03:43:04PM +0100, Punit Agrawal wrote:
> KVM only supports PMD hugepages at stage 2. Extend the stage 2 fault
> handling to add support for PUD hugepages.
> 
> Addition of pud hugepage support enables additional hugepage
> sizes (e.g., 1G with 4K granule) which can be useful on cores that
> support mapping larger block sizes in the TLB entries.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/include/asm/kvm_mmu.h         | 19 ++++++++++++
>  arch/arm64/include/asm/kvm_mmu.h       | 15 ++++++++++
>  arch/arm64/include/asm/pgtable-hwdef.h |  4 +++
>  arch/arm64/include/asm/pgtable.h       |  2 ++
>  virt/kvm/arm/mmu.c                     | 40 ++++++++++++++++++++++++--
>  5 files changed, 77 insertions(+), 3 deletions(-)

It looks like I acked an earlier version. I'll ack it again here:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
