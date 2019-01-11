From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC v3 09/21] iommu/smmuv3: Get prepared for nested stage
 support
Date: Fri, 11 Jan 2019 16:04:17 +0000
Message-ID: <0d766261-119b-0802-4c09-e601b5abe727@arm.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-10-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108102633.17482-10-eric.auger@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, kevin.tian@intel.com, ashok.raj@intel.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 08/01/2019 10:26, Eric Auger wrote:
> To allow nested stage support, we need to store both
> stage 1 and stage 2 configurations (and remove the former
> union).
> 
> arm_smmu_write_strtab_ent() is modified to write both stage
> fields in the STE.
> 
> We add a nested_bypass field to the S1 configuration as the first
> stage can be bypassed. Also the guest may force the STE to abort:
> this information gets stored into the nested_abort field.
> 
> Only S2 stage is "finalized" as the host does not configure
> S1 CD, guest does.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - invalidate the STE before moving from a live STE config to another
> - add the nested_abort and nested_bypass fields
> ---
>  drivers/iommu/arm-smmu-v3.c | 43 ++++++++++++++++++++++++++++---------
>  1 file changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index 9af68266bbb1..9716a301d9ae 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -212,6 +212,7 @@
>  #define STRTAB_STE_0_CFG_BYPASS		4
>  #define STRTAB_STE_0_CFG_S1_TRANS	5
>  #define STRTAB_STE_0_CFG_S2_TRANS	6
> +#define STRTAB_STE_0_CFG_NESTED		7
>  
>  #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
>  #define STRTAB_STE_0_S1FMT_LINEAR	0
> @@ -491,6 +492,10 @@ struct arm_smmu_strtab_l1_desc {
>  struct arm_smmu_s1_cfg {
>  	__le64				*cdptr;
>  	dma_addr_t			cdptr_dma;
> +	/* in nested mode, tells s1 must be bypassed */
> +	bool				nested_bypass;
> +	/* in nested mode, abort is forced by guest */
> +	bool				nested_abort;
>  
>  	struct arm_smmu_ctx_desc {
>  		u16	asid;
> @@ -515,6 +520,7 @@ struct arm_smmu_strtab_ent {
>  	 * configured according to the domain type.
>  	 */
>  	bool				assigned;
> +	bool				nested;
>  	struct arm_smmu_s1_cfg		*s1_cfg;
>  	struct arm_smmu_s2_cfg		*s2_cfg;
>  };
> @@ -629,10 +635,8 @@ struct arm_smmu_domain {
>  	bool				non_strict;
>  
>  	enum arm_smmu_domain_stage	stage;
> -	union {
> -		struct arm_smmu_s1_cfg	s1_cfg;
> -		struct arm_smmu_s2_cfg	s2_cfg;
> -	};
> +	struct arm_smmu_s1_cfg	s1_cfg;
> +	struct arm_smmu_s2_cfg	s2_cfg;
>  
>  	struct iommu_domain		domain;
>  
> @@ -1139,10 +1143,11 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,

Could you also update the "This is hideously complicated..." comment
with the nested case? This function was complicated before, but it
becomes hell when adding nested and SVA support, so we really need the
comments :)

>  			break;
>  		case STRTAB_STE_0_CFG_S1_TRANS:
>  		case STRTAB_STE_0_CFG_S2_TRANS:
> +		case STRTAB_STE_0_CFG_NESTED:
>  			ste_live = true;
>  			break;
>  		case STRTAB_STE_0_CFG_ABORT:
> -			if (disable_bypass)
> +			if (disable_bypass || ste->nested)
>  				break;
>  		default:
>  			BUG(); /* STE corruption */
> @@ -1154,7 +1159,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
>  
>  	/* Bypass/fault */
>  	if (!ste->assigned || !(ste->s1_cfg || ste->s2_cfg)) {
> -		if (!ste->assigned && disable_bypass)
> +		if ((!ste->assigned && disable_bypass) ||
> +				(ste->s1_cfg && ste->s1_cfg->nested_abort))

I don't think we're ever reaching this, given that ste->assigned is true
and ste->s2_cfg is set.

Something I find noteworthy is that with STRTAB_STE_0_CFG_ABORT, no
event is recorded in case of DMA fault. For vSMMU you'd want to emulate
the SMMU behavior closely, so you don't want to inject faults if the
guest sets CFG_ABORT, but this way you also can't report errors to the
VMM. If we did want to notify the VMM of faults, we'd need to implement
nested_abort differently, for example by installing an empty context
descriptor with Config=s1translate-s2translate.

>  			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
>  		else
>  			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
> @@ -1172,8 +1178,17 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
>  		return;
>  	}
>  
> +	if (ste->nested && ste_live) {
> +		/*
> +		 * When enabling nested, the STE may be transitionning from

transitioning (my bad)

> +		 * s2 to nested and back. Invalidate the STE before changing it.
> +		 */
> +		dst[0] = cpu_to_le64(0);
> +		arm_smmu_sync_ste_for_sid(smmu, sid);
> +		val = STRTAB_STE_0_V;

val is already STRTAB_STE_0_V

> +	}
> +
>  	if (ste->s1_cfg) {
> -		BUG_ON(ste_live);
>  		dst[1] = cpu_to_le64(
>  			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
>  			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
> @@ -1187,12 +1202,12 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
>  		   !(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
>  			dst[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
>  
> -		val |= (ste->s1_cfg->cdptr_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
> -			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS);
> +		if (!ste->s1_cfg->nested_bypass)
> +			val |= (ste->s1_cfg->cdptr_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
> +				FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS);

In patch 10/21, you're handling cfg->bypass == 1 by clearing ste->s1_cfg
(which I think is the best way - resetting the STE like it was when
initializing the nested domain). So can we get rid of
s1_cfg->nested_bypass and this change?

>  	}
>  
>  	if (ste->s2_cfg) {
> -		BUG_ON(ste_live);
>  		dst[2] = cpu_to_le64(
>  			 FIELD_PREP(STRTAB_STE_2_S2VMID, ste->s2_cfg->vmid) |
>  			 FIELD_PREP(STRTAB_STE_2_VTCR, ste->s2_cfg->vtcr) |
> @@ -1454,6 +1469,10 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>  		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
>  		cmd.tlbi.asid	= smmu_domain->s1_cfg.cd.asid;
>  		cmd.tlbi.vmid	= 0;
> +	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED) {
> +		cmd.opcode      = CMDQ_OP_TLBI_NH_ASID;
> +		cmd.tlbi.asid   = smmu_domain->s1_cfg.cd.asid;

Using s1_cfg.cd.asid as interface between cache_invalidate() and
tlb_inv_context() seems racy. In nested mode, s1_cfg.cd really shouldn't
be used. I'd rather cache_invalidate() crafted the commands itself
instead of going through these callbacks. Or you could add a leaf
function that takes asid as argument and is called by both
arm_smmu_tlb_inv_context() and cache_invalidate().

Thanks,
Jean

> +		cmd.tlbi.vmid   = smmu_domain->s2_cfg.vmid;
>  	} else {
>  		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
>  		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
> @@ -1484,6 +1503,10 @@ static void arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
>  	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>  		cmd.opcode	= CMDQ_OP_TLBI_NH_VA;
>  		cmd.tlbi.asid	= smmu_domain->s1_cfg.cd.asid;
> +	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED) {
> +		cmd.opcode      = CMDQ_OP_TLBI_NH_VA;
> +		cmd.tlbi.asid   = smmu_domain->s1_cfg.cd.asid;
> +		cmd.tlbi.vmid   = smmu_domain->s2_cfg.vmid;
>  	} else {
>  		cmd.opcode	= CMDQ_OP_TLBI_S2_IPA;
>  		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
> 
