From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v3 05/20] kvm: arm/arm64: Fix stage2_flush_memslot for 4
 level page table
Date: Fri, 29 Jun 2018 16:50:57 +0200
Message-ID: <0820efa5-1524-9039-2340-421aad88b3c5@redhat.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-6-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530270944-11351-6-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, julien.grall@arm.com, james.morse@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 06/29/2018 01:15 PM, Suzuki K Poulose wrote:
> So far we have only supported 3 level page table with fixed IPA of 40bits.
> Fix stage2_flush_memslot() to accommodate for 4 level tables.
in 06/30 you add the justification for this change I think. worth to put
in here as well?

> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Acked-by: Christoffer Dall <cdall@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 1d90d79..061e6b3 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -379,7 +379,8 @@ static void stage2_flush_memslot(struct kvm *kvm,
>  	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>  	do {
>  		next = stage2_pgd_addr_end(addr, end);
> -		stage2_flush_puds(kvm, pgd, addr, next);
> +		if (!stage2_pgd_none(*pgd))
> +			stage2_flush_puds(kvm, pgd, addr, next);
>  	} while (pgd++, addr = next, addr != end);
>  }
>  
> 

Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
