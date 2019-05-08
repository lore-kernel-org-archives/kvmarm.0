Return-Path: <SRS0=Kjqu=TI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679DAC46470
	for <kvmarm@archiver.kernel.org>; Wed,  8 May 2019 14:24:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF3FA21530
	for <kvmarm@archiver.kernel.org>; Wed,  8 May 2019 14:24:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF3FA21530
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 696984A4CB;
	Wed,  8 May 2019 10:24:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hbl-IenCm1E4; Wed,  8 May 2019 10:24:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A684A483;
	Wed,  8 May 2019 10:24:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFBE54A36B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 May 2019 10:24:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p5PJLcCY9OOV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 May 2019 10:24:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 596C64A32E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 May 2019 10:24:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C235CA78;
 Wed,  8 May 2019 07:24:05 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DBF313F238;
 Wed,  8 May 2019 07:24:02 -0700 (PDT)
Subject: Re: [PATCH v7 12/23] iommu/smmuv3: Get prepared for nested stage
 support
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-13-eric.auger@redhat.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <66f873eb-35c0-d1e9-794e-9150dbdb13fe@arm.com>
Date: Wed, 8 May 2019 15:24:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408121911.24103-13-eric.auger@redhat.com>
Content-Language: en-GB
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com,
 marc.zyngier@arm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 08/04/2019 13:19, Eric Auger wrote:
> To allow nested stage support, we need to store both
> stage 1 and stage 2 configurations (and remove the former
> union).
> 
> A nested setup is characterized by both s1_cfg and s2_cfg
> set.
> 
> We introduce a new ste.abort field that will be set upon
> guest stage1 configuration passing. If s1_cfg is NULL and
> ste.abort is set, traffic can't pass. If ste.abort is not set,
> S1 is bypassed.
> 
> arm_smmu_write_strtab_ent() is modified to write both stage
> fields in the STE and deal with the abort field.
> 
> In nested mode, only stage 2 is "finalized" as the host does
> not own/configure the stage 1 context descriptor, guest does.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v4 -> v5:
> - reset ste.abort on detach
> 
> v3 -> v4:
> - s1_cfg.nested_abort and nested_bypass removed.
> - s/ste.nested/ste.abort
> - arm_smmu_write_strtab_ent modifications with introduction
>    of local abort, bypass and translate local variables
> - comment updated
> 
> v1 -> v2:
> - invalidate the STE before moving from a live STE config to another
> - add the nested_abort and nested_bypass fields
> ---
>   drivers/iommu/arm-smmu-v3.c | 35 ++++++++++++++++++++---------------
>   1 file changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index 21d027695181..e22e944ffc05 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -211,6 +211,7 @@
>   #define STRTAB_STE_0_CFG_BYPASS		4
>   #define STRTAB_STE_0_CFG_S1_TRANS	5
>   #define STRTAB_STE_0_CFG_S2_TRANS	6
> +#define STRTAB_STE_0_CFG_NESTED		7
>   
>   #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
>   #define STRTAB_STE_0_S1FMT_LINEAR	0
> @@ -514,6 +515,7 @@ struct arm_smmu_strtab_ent {
>   	 * configured according to the domain type.
>   	 */
>   	bool				assigned;
> +	bool				abort;
>   	struct arm_smmu_s1_cfg		*s1_cfg;
>   	struct arm_smmu_s2_cfg		*s2_cfg;
>   };
> @@ -628,10 +630,8 @@ struct arm_smmu_domain {
>   	bool				non_strict;
>   
>   	enum arm_smmu_domain_stage	stage;
> -	union {
> -		struct arm_smmu_s1_cfg	s1_cfg;
> -		struct arm_smmu_s2_cfg	s2_cfg;
> -	};
> +	struct arm_smmu_s1_cfg	s1_cfg;
> +	struct arm_smmu_s2_cfg	s2_cfg;
>   
>   	struct iommu_domain		domain;
>   
> @@ -1108,12 +1108,13 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
>   				      __le64 *dst, struct arm_smmu_strtab_ent *ste)
>   {
>   	/*
> -	 * This is hideously complicated, but we only really care about
> -	 * three cases at the moment:
> +	 * We care about the following transitions:
>   	 *
>   	 * 1. Invalid (all zero) -> bypass/fault (init)
> -	 * 2. Bypass/fault -> translation/bypass (attach)
> -	 * 3. Translation/bypass -> bypass/fault (detach)
> +	 * 2. Bypass/fault -> single stage translation/bypass (attach)
> +	 * 3. single stage Translation/bypass -> bypass/fault (detach)
> +	 * 4. S2 -> S1 + S2 (attach_pasid_table)
> +	 * 5. S1 + S2 -> S2 (detach_pasid_table)
>   	 *
>   	 * Given that we can't update the STE atomically and the SMMU
>   	 * doesn't read the thing in a defined order, that leaves us
> @@ -1124,7 +1125,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
>   	 * 3. Update Config, sync
>   	 */
>   	u64 val = le64_to_cpu(dst[0]);
> -	bool ste_live = false;
> +	bool abort, bypass, translate, ste_live = false;
>   	struct arm_smmu_cmdq_ent prefetch_cmd = {
>   		.opcode		= CMDQ_OP_PREFETCH_CFG,
>   		.prefetch	= {
> @@ -1138,11 +1139,11 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
>   			break;
>   		case STRTAB_STE_0_CFG_S1_TRANS:
>   		case STRTAB_STE_0_CFG_S2_TRANS:
> +		case STRTAB_STE_0_CFG_NESTED:
>   			ste_live = true;
>   			break;
>   		case STRTAB_STE_0_CFG_ABORT:
> -			if (disable_bypass)
> -				break;
> +			break;
>   		default:
>   			BUG(); /* STE corruption */
>   		}
> @@ -1152,8 +1153,13 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
>   	val = STRTAB_STE_0_V;
>   
>   	/* Bypass/fault */
> -	if (!ste->assigned || !(ste->s1_cfg || ste->s2_cfg)) {
> -		if (!ste->assigned && disable_bypass)
> +
> +	abort = (!ste->assigned && disable_bypass) || ste->abort;
> +	translate = ste->s1_cfg || ste->s2_cfg;
> +	bypass = !abort && !translate;
> +
> +	if (abort || bypass) {
> +		if (abort)
>   			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
>   		else
>   			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
> @@ -1172,7 +1178,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
>   	}
>   
>   	if (ste->s1_cfg) {
> -		BUG_ON(ste_live);

Hmm, I'm a little uneasy about just removing these checks altogether, as 
there are still cases where rewriting a live entry is bogus, that we'd 
really like to keep catching. Is the problem that it's hard to tell when 
you're 'rewriting' the S2 config of a nested entry with the same thing 
on attaching/detaching its S1 context?

Robin.

>   		dst[1] = cpu_to_le64(
>   			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
>   			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
> @@ -1191,7 +1196,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
>   	}
>   
>   	if (ste->s2_cfg) {
> -		BUG_ON(ste_live);
>   		dst[2] = cpu_to_le64(
>   			 FIELD_PREP(STRTAB_STE_2_S2VMID, ste->s2_cfg->vmid) |
>   			 FIELD_PREP(STRTAB_STE_2_VTCR, ste->s2_cfg->vtcr) |
> @@ -1773,6 +1777,7 @@ static void arm_smmu_detach_dev(struct device *dev)
>   	}
>   
>   	master->ste.assigned = false;
> +	master->ste.abort = false;
>   	arm_smmu_install_ste_for_dev(fwspec);
>   }
>   
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
