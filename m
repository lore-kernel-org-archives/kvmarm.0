From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 06/14] KVM: arm/arm64: Factor out VMID into struct kvm_vmid
Date: Fri, 25 Jan 2019 11:05:04 +0000
Message-ID: <b0606f1e-b39a-0ec9-b706-f60832acaced@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
 <20190124140032.8588-7-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190124140032.8588-7-christoffer.dall@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 24/01/2019 14:00, Christoffer Dall wrote:
> In preparation for nested virtualization where we are going to have more
> than a single VMID per VM, let's factor out the VMID data into a
> separate VMID data structure and change the VMID allocator to operate on
> this new structure instead of using a struct kvm.
> 
> This also means that udate_vttbr now becomes update_vmid, and that the
> vttbr itself is generated on the fly based on the stage 2 page table
> base address and the vmid.
> 
> We cache the physical address of the pgd when allocating the pgd to
> avoid doing the calculation on every entry to the guest and to avoid
> calling into potentially non-hyp-mapped code from hyp/EL2.
> 
> If we wanted to merge the VMID allocator with the arm64 ASID allocator
> at some point in the future, it should actually become easier to do that
> after this patch.
> 
> Note that to avoid mapping the kvm_vmid_bits variable into hyp, we
> simply forego the masking of the vmid value in kvm_get_vttbr and rely on
> update_vmid to always assign a valid vmid value (within the supported
> range).
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 13 ++++---
>  arch/arm/include/asm/kvm_mmu.h    | 11 ++++++
>  arch/arm/kvm/hyp/switch.c         |  2 +-
>  arch/arm/kvm/hyp/tlb.c            |  4 +--
>  arch/arm64/include/asm/kvm_host.h |  9 +++--
>  arch/arm64/include/asm/kvm_hyp.h  |  3 +-
>  arch/arm64/include/asm/kvm_mmu.h  | 11 ++++++
>  virt/kvm/arm/arm.c                | 57 +++++++++++--------------------
>  virt/kvm/arm/mmu.c                |  2 ++
>  9 files changed, 63 insertions(+), 49 deletions(-)
> 

[...]

> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 3a875fc1b63c..fadbd9ad3a90 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -426,6 +426,17 @@ static inline bool kvm_cpu_has_cnp(void)
>  	return false;
>  }
>  
> +static __always_inline u64 kvm_get_vttbr(struct kvm *kvm)
> +{
> +	struct kvm_vmid *vmid = &kvm->arch.vmid;
> +	u64 vmid_field, baddr;
> +	u64 cnp = kvm_cpu_has_cnp() ? VTTBR_CNP_BIT : 0;
> +

Nit:
As James pointed out, we're not merging this one with the 64-bit
version. The question is, since we don't merge it, can't we simplify
this one by removing the CNP related code from it? (we know CNP is
always false for 32-bit ARM).

> +	baddr = kvm->arch.pgd_phys;
> +	vmid_field = (u64)vmid->vmid << VTTBR_VMID_SHIFT;
> +	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
> +}
> +
>  #endif	/* !__ASSEMBLY__ */

Otherwise, things look good to me:

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Cheers,

-- 
Julien Thierry
