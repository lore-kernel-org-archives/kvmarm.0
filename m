From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH] kvm: arm: Skip stage2 huge mappings for unaligned ipa
 backed by THP
Date: Tue, 2 Apr 2019 16:53:07 +0100
Message-ID: <20190402155307.GE53702@e119886-lin.cambridge.arm.com>
References: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 02, 2019 at 12:06:16PM +0100, Suzuki K Poulose wrote:
> With commit a80868f398554842b14, we no longer ensure that the
> THP page is properly aligned in the guest IPA. Skip the stage2
> huge mapping for unaligned IPA backed by transparent hugepages.
> 
> Fixes: a80868f398554842b14 ("KVM: arm/arm64: Enforce PTE mappings at stage2 when needed")
> Reported-by: Eric Auger <eric.auger@redhat.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Chirstoffer Dall <christoffer.dall@arm.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Zheng Xiang <zhengxiang9@huawei.com>
> Tested-by: Eric Auger <eric.auger@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 27c9583..4a22f5b 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1412,7 +1412,9 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
>  		 * page accordingly.
>  		 */
>  		mask = PTRS_PER_PMD - 1;
> -		VM_BUG_ON((gfn & mask) != (pfn & mask));
> +		/* Skip memslots with unaligned IPA and user address */
> +		if ((gfn & mask) != (pfn & mask))
> +			return false;
>  		if (pfn & mask) {
>  			*ipap &= PMD_MASK;
>  			kvm_release_pfn_clean(pfn);
> -- 
> 2.7.4

I was able to reproduce this issue on v5.1-rc3 on a SoftIron Overdrive 1000
(AMD Seattle (Rev.B1)) with defconfig+ARM64_64K_PAGES with:

qemu-system-aarch64 -cpu host -machine type=virt,accel=kvm -nographic -smp 4
-m 4096 -kernel /boot/vmlinuz-4.9.0-7-arm64 --append "console=ttyAMA0
default_hugepagesz=2M hugepages=256"

The 'default_hugepagesz=2M hugepages=256' had no effect on the reproducibility,
however the guest only intermittently failed to boot. Applying the above
patch fixed this and the guest boots every time.

Tested-by: Andrew Murray <andrew.murray@arm.com>

Thanks,

Andrew Murray

> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
