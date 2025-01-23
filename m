Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F2BE2010E1;
	Thu, 23 Jan 2025 13:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737637323; cv=none; b=N3ol0VReO8LIeXCbL0pqIhxooylnCzfqFQUQ66VUIPYQ03N4I0c4NeZjFw13blCxwX00FRpltTeDkG27o08C7DxN6dJrEcKtG6IzUBeqJ75+5d3p/YLhopHB1hb4//QknaJJF/yC4qYdf4lRjSbUOc1qJop9nBog3hRYf4uj+iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737637323; c=relaxed/simple;
	bh=AZS9dA4WXvNHAWHnlRjBjcSSFi4rs7s/75a9Bvr294w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GbB4u0iGtc3XlVneasjm2CpUNPAsD6ktCHai3BCXjlz3D7aCkRXsWicP/QdDot1ShtYpoldnAetv+tMPaT7DgP2YFe5OLoYj3o3GuIYIJQNby04C5I0T4tnSnuHaLCNgxTBGqgHFqAHV6cXeZjtjdXu+q+zjwi9rorO8G8o3Rzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96B851063;
	Thu, 23 Jan 2025 05:02:27 -0800 (PST)
Received: from [10.57.6.148] (unknown [10.57.6.148])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 404D03F694;
	Thu, 23 Jan 2025 05:01:56 -0800 (PST)
Message-ID: <4e9d04e4-729d-483d-8533-06b3e0a2fb04@arm.com>
Date: Thu, 23 Jan 2025 13:01:55 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 27/58] KVM: arm64: smmu-v3: Setup command queue
To: Mostafa Saleh <smostafa@google.com>, iommu@lists.linux.dev,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
 jean-philippe@linaro.org, jgg@ziepe.ca, nicolinc@nvidia.com,
 vdonnefort@google.com, qperret@google.com, tabba@google.com,
 danielmentz@google.com, tzukui@google.com
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-28-smostafa@google.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20241212180423.1578358-28-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-12-12 6:03 pm, Mostafa Saleh wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Map the command queue allocated by the host into the hypervisor address
> space. When the host mappings are finalized, the queue is unmapped from
> the host.

Don't forget the fun of reimplementing the errata workarounds to avoid 
generating certain problematic command sequences - beware it's mostly 
implicit in the current kernel driver :)

Thanks,
Robin.

> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>   arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 165 ++++++++++++++++++++
>   include/kvm/arm_smmu_v3.h                   |   4 +
>   2 files changed, 169 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> index f7e60c188cb0..e15356509424 100644
> --- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> @@ -41,6 +41,15 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
>   	__ret;							\
>   })
>   
> +#define smmu_wait_event(_smmu, _cond)				\
> +({								\
> +	if ((_smmu)->features & ARM_SMMU_FEAT_SEV) {		\
> +		while (!(_cond))				\
> +			wfe();					\
> +	}							\
> +	smmu_wait(_cond);					\
> +})
> +
>   static int smmu_write_cr0(struct hyp_arm_smmu_v3_device *smmu, u32 val)
>   {
>   	writel_relaxed(val, smmu->base + ARM_SMMU_CR0);
> @@ -60,6 +69,123 @@ static void smmu_reclaim_pages(u64 phys, size_t size)
>   	WARN_ON(__pkvm_hyp_donate_host(phys >> PAGE_SHIFT, size >> PAGE_SHIFT));
>   }
>   
> +#define Q_WRAP(smmu, reg)	((reg) & (1 << (smmu)->cmdq_log2size))
> +#define Q_IDX(smmu, reg)	((reg) & ((1 << (smmu)->cmdq_log2size) - 1))
> +
> +static bool smmu_cmdq_full(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	u64 cons = readl_relaxed(smmu->base + ARM_SMMU_CMDQ_CONS);
> +
> +	return Q_IDX(smmu, smmu->cmdq_prod) == Q_IDX(smmu, cons) &&
> +	       Q_WRAP(smmu, smmu->cmdq_prod) != Q_WRAP(smmu, cons);
> +}
> +
> +static bool smmu_cmdq_empty(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	u64 cons = readl_relaxed(smmu->base + ARM_SMMU_CMDQ_CONS);
> +
> +	return Q_IDX(smmu, smmu->cmdq_prod) == Q_IDX(smmu, cons) &&
> +	       Q_WRAP(smmu, smmu->cmdq_prod) == Q_WRAP(smmu, cons);
> +}
> +
> +static int smmu_add_cmd(struct hyp_arm_smmu_v3_device *smmu,
> +			struct arm_smmu_cmdq_ent *ent)
> +{
> +	int i;
> +	int ret;
> +	u64 cmd[CMDQ_ENT_DWORDS] = {};
> +	int idx = Q_IDX(smmu, smmu->cmdq_prod);
> +	u64 *slot = smmu->cmdq_base + idx * CMDQ_ENT_DWORDS;
> +
> +	if (smmu->iommu.power_is_off)
> +		return -EPIPE;
> +
> +	ret = smmu_wait_event(smmu, !smmu_cmdq_full(smmu));
> +	if (ret)
> +		return ret;
> +
> +	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
> +
> +	switch (ent->opcode) {
> +	case CMDQ_OP_CFGI_ALL:
> +		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
> +		break;
> +	case CMDQ_OP_CFGI_CD:
> +		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SSID, ent->cfgi.ssid);
> +		fallthrough;
> +	case CMDQ_OP_CFGI_STE:
> +		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
> +		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
> +		break;
> +	case CMDQ_OP_TLBI_NH_VA:
> +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
> +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
> +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
> +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
> +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
> +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
> +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
> +		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_VA_MASK;
> +		break;
> +	case CMDQ_OP_TLBI_NSNH_ALL:
> +		break;
> +	case CMDQ_OP_TLBI_NH_ASID:
> +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
> +		fallthrough;
> +	case CMDQ_OP_TLBI_S12_VMALL:
> +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
> +		break;
> +	case CMDQ_OP_TLBI_S2_IPA:
> +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
> +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
> +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
> +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
> +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
> +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
> +		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_IPA_MASK;
> +		break;
> +	case CMDQ_OP_CMD_SYNC:
> +		cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < CMDQ_ENT_DWORDS; i++)
> +		slot[i] = cpu_to_le64(cmd[i]);
> +
> +	smmu->cmdq_prod++;
> +	writel(Q_IDX(smmu, smmu->cmdq_prod) | Q_WRAP(smmu, smmu->cmdq_prod),
> +	       smmu->base + ARM_SMMU_CMDQ_PROD);
> +	return 0;
> +}
> +
> +static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	int ret;
> +	struct arm_smmu_cmdq_ent cmd = {
> +		.opcode = CMDQ_OP_CMD_SYNC,
> +	};
> +
> +	ret = smmu_add_cmd(smmu, &cmd);
> +	if (ret)
> +		return ret;
> +
> +	return smmu_wait_event(smmu, smmu_cmdq_empty(smmu));
> +}
> +
> +__maybe_unused
> +static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
> +			 struct arm_smmu_cmdq_ent *cmd)
> +{
> +	int ret = smmu_add_cmd(smmu, cmd);
> +
> +	if (ret)
> +		return ret;
> +
> +	return smmu_sync_cmd(smmu);
> +}
> +
>   static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
>   {
>   	u64 val, old;
> @@ -94,6 +220,41 @@ static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
>   	return 0;
>   }
>   
> +static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	u64 cmdq_base;
> +	size_t cmdq_nr_entries, cmdq_size;
> +	int ret;
> +	enum kvm_pgtable_prot prot = PAGE_HYP;
> +
> +	cmdq_base = readq_relaxed(smmu->base + ARM_SMMU_CMDQ_BASE);
> +	if (cmdq_base & ~(Q_BASE_RWA | Q_BASE_ADDR_MASK | Q_BASE_LOG2SIZE))
> +		return -EINVAL;
> +
> +	smmu->cmdq_log2size = cmdq_base & Q_BASE_LOG2SIZE;
> +	cmdq_nr_entries = 1 << smmu->cmdq_log2size;
> +	cmdq_size = cmdq_nr_entries * CMDQ_ENT_DWORDS * 8;
> +
> +	cmdq_base &= Q_BASE_ADDR_MASK;
> +
> +	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
> +		prot |= KVM_PGTABLE_PROT_NORMAL_NC;
> +
> +	ret = ___pkvm_host_donate_hyp_prot(cmdq_base >> PAGE_SHIFT,
> +					   PAGE_ALIGN(cmdq_size) >> PAGE_SHIFT,
> +					   false, prot);
> +	if (ret)
> +		return ret;
> +
> +	smmu->cmdq_base = hyp_phys_to_virt(cmdq_base);
> +
> +	memset(smmu->cmdq_base, 0, cmdq_size);
> +	writel_relaxed(0, smmu->base + ARM_SMMU_CMDQ_PROD);
> +	writel_relaxed(0, smmu->base + ARM_SMMU_CMDQ_CONS);
> +
> +	return 0;
> +}
> +
>   static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
>   {
>   	int ret;
> @@ -113,6 +274,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
>   	if (ret)
>   		return ret;
>   
> +	ret = smmu_init_cmdq(smmu);
> +	if (ret)
> +		return ret;
> +
>   	return kvm_iommu_init_device(&smmu->iommu);
>   }
>   
> diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
> index fb24bcef1624..393a1a04edba 100644
> --- a/include/kvm/arm_smmu_v3.h
> +++ b/include/kvm/arm_smmu_v3.h
> @@ -16,8 +16,12 @@ struct hyp_arm_smmu_v3_device {
>   	struct kvm_hyp_iommu	iommu;
>   	phys_addr_t		mmio_addr;
>   	size_t			mmio_size;
> +	unsigned long		features;
>   
>   	void __iomem		*base;
> +	u32			cmdq_prod;
> +	u64			*cmdq_base;
> +	size_t			cmdq_log2size;
>   };
>   
>   extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);

