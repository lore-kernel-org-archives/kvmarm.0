From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [RFC PATCH 1/5] KVM: arm64: Remove pgd_lock
Date: Wed, 15 Aug 2018 17:52:32 +0100
Message-ID: <57835dc1-c8ab-d440-d16d-849bf1334547@arm.com>
References: <20180813160453.38032-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 146A94A0CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Aug 2018 12:51:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QE50pPnepssL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Aug 2018 12:51:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7BF449FA8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Aug 2018 12:51:50 -0400 (EDT)
In-Reply-To: <20180813160453.38032-1-steven.price@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Steve

On 08/13/2018 05:04 PM, Steven Price wrote:
> The lock has never been used and the page tables are protected by
> mmu_lock in struct kvm.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> CC: Marc Zyngier <marc.zyngier@arm.com>
> CC: Christoffer Dall <christoffer.dall@arm.com>
> 
>   arch/arm64/include/asm/kvm_host.h | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index fe8777b12f86..8150a7f8a50f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -61,8 +61,7 @@ struct kvm_arch {
>   	u64    vmid_gen;
>   	u32    vmid;
>   
> -	/* 1-level 2nd stage table and lock */
> -	spinlock_t pgd_lock;
> +	/* 1-level 2nd stage table, protected by kvm->mmu_lock */
>   	pgd_t *pgd;
>   
>   	/* VTTBR value associated with above pgd and vmid */
> 

I have a patch which already does this, though not a dedicated patch [1] 
in the dynamic IPA series. As such I am fine with this patch being
merged if it gets there first, as we are still working out the userspace
API for dynamic IPA.

FWIW,

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



[1] 
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-July/591778.html
