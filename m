From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v1 14/16] kvm: arm64: Switch to per VM IPA
Date: Fri, 9 Feb 2018 09:12:44 +0100
Message-ID: <20180209081244.GB7339@cbox>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-15-suzuki.poulose@arm.com>
 <20180208110035.GG29286@cbox>
 <94aae952-d6c0-0a69-955f-81885ddb2f06@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94aae952-d6c0-0a69-955f-81885ddb2f06@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 08, 2018 at 05:22:29PM +0000, Suzuki K Poulose wrote:
> On 08/02/18 11:00, Christoffer Dall wrote:
> >On Tue, Jan 09, 2018 at 07:04:09PM +0000, Suzuki K Poulose wrote:
> >>Now that we can manage the stage2 page table per VM, switch the
> >>configuration details to per VM instance. We keep track of the
> >>IPA bits, number of page table levels and the VTCR bits (which
> >>depends on the IPA and the number of levels).
> >>
> >>Cc: Marc Zyngier <marc.zyngier@arm.com>
> >>Cc: Christoffer Dall <cdall@linaro.org>
> >>Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> >>---
> >>  arch/arm/include/asm/kvm_mmu.h          |  1 +
> >>  arch/arm64/include/asm/kvm_host.h       | 12 ++++++++++++
> >>  arch/arm64/include/asm/kvm_mmu.h        | 22 ++++++++++++++++++++--
> >>  arch/arm64/include/asm/stage2_pgtable.h |  1 -
> >>  arch/arm64/kvm/hyp/switch.c             |  3 +--
> >>  virt/kvm/arm/arm.c                      |  2 +-
> >>  6 files changed, 35 insertions(+), 6 deletions(-)
> >>
> >>diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> >>index 440c80589453..dd592fe45660 100644
> >>--- a/arch/arm/include/asm/kvm_mmu.h
> >>+++ b/arch/arm/include/asm/kvm_mmu.h
> >>@@ -48,6 +48,7 @@
> >>  #define kvm_vttbr_baddr_mask(kvm)	VTTBR_BADDR_MASK
> >>  #define stage2_pgd_size(kvm)	(PTRS_PER_S2_PGD * sizeof(pgd_t))
> >>+#define kvm_init_stage2_config(kvm)	do { } while (0)
> >>  int create_hyp_mappings(void *from, void *to, pgprot_t prot);
> >>  int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
> >>  void free_hyp_pgds(void);
> >>diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >>index 9a9ddeb33c84..1e66e5ab3dde 100644
> >>--- a/arch/arm64/include/asm/kvm_host.h
> >>+++ b/arch/arm64/include/asm/kvm_host.h
> >>@@ -64,6 +64,18 @@ struct kvm_arch {
> >>  	/* VTTBR value associated with above pgd and vmid */
> >>  	u64    vttbr;
> >>+	/* Private bits of VTCR_EL2 for this VM */
> >>+	u64    vtcr_private;
> >
> >As to my comments in the previous patch, why isn't this simply u64 vtcr;
> 
> nit: I haven't received your response to the previous patch.

It got stuck in my drafts folder somehow, hopefully you received it now.

> 
> We could. I thought this gives a bit more clarity on what changes per-VM.
> 

Since there's a performance issue involved, I think it's cleaner to just
calculate the vtcr once per VM and store it.

Thanks,
-Christoffer
