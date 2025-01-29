Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058AD19DF60
	for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 11:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738149351; cv=none; b=dviZh/QhOHhOqXCQTAhZmVBGJMedKAUgREehiwkJlCmftaLKHJ7kSZr3vk1px9SFsM3YRegqQqLpnP7Bz965UjZlKL3SvH+ciMNQ2oAbC8DFT2R+NMDDROUTMzWwFIXZRfPBA5Q1Ova4wJElHLODawdWGi7tRHF7K9Htbja8bFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738149351; c=relaxed/simple;
	bh=9LklkQyZ4FLpGPXHWHvasvNafazcgSsZ9+b3vACuhhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdsLVVnaXlNJhug/Pe4A2E22gcw3vatJD4zeplI/JIoQ3KKFbAe1ruH8AqoF7XY30cbN4pb88uaT2NW3r5qFG9aRwdF5FJg1DS+r106h7y1LjiOgUxs/GJBn5lyJar6/XfoOxakf5e/l03RKL2rk9RWX/3VvmZLAvdd0uLv4otI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OKWnu1bU; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OKWnu1bU"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4368a290e0dso105985e9.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 03:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738149347; x=1738754147; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lIj0S75Nq583PWPyqj5G995an+ZD2/gTQqnPSbczUig=;
        b=OKWnu1bUZFSY43uKddtIF6LSNhwiLbP105aRAUDf4lS/0uacqSaet59xR0oM2w+93x
         04rdoMzyUr4ouOV7LLrtodP2EKQUesQ7Xj00KdSzDCTALTW7pce9L2Vlbf+YyTS+EhVO
         Y2HXQHiStHVZA2h4hzo6bJnAo9PTjHxNsvthMsiP8oLpcE/NWGbDpGVQ5sJk4UjrQ9iA
         99zZNBlD1eKnL8AvJQYZ7EhatvWj9AW6ox298qGVCCWvx0miJIV4NkfNqVq65Kf1Lltv
         gqT142AvydD/v5wnSeaYFhV7KrhHfk2WIHjHFGCRUjSChg+mFfuxQ6O0vrHnqDHqROZs
         zhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738149347; x=1738754147;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lIj0S75Nq583PWPyqj5G995an+ZD2/gTQqnPSbczUig=;
        b=p79lpvaGqbt/is3O1iRPyE5lojRvvHYrJhxYn4lJBQvriFi2RVU1alyvqAGvqvbH8O
         MhcDCzTo48QXntwsRQjbbAsJVjGHVnZFbZF9cMNa3EkCgMqkWsiOIJQRk4eOuQnUto+k
         Frh7Bm94xiwbt93O56leRoZPU9UxMHDIxNoW4eO302F1gXTI4eDy0zGBpKtFFVLtPHqP
         YKEUzEBlOKerhIW3MXZnEUYbZnASdLwGluxUNSb9eSjj2tnXlzo17AbRAYgIEF4sGlu2
         7DyC5D32s/3nNwfoIlbAEKcRu2cjqCAwLdGW7+QhPr1a0fWusb0dsZOjFw6xOIXK3i01
         J0Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWvg3P3xX5FzVdvcDXaT1gYceq+BKtK1KOwj2R7FFE8c6iPJqznv++uGM/La9Nqywcp9u7J35Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6t5GN34CxF2G4omCSZRm3C8h4VyYVperTexF5G/XIu3g4aNz5
	5bzB8NZ1u7EiNUPj+AZKvlJMip81sVaaatw1DYGFKisNDU4jSs2kfniJOcm7V5hud7zZMdUTUM3
	kTQ==
X-Gm-Gg: ASbGncvEWpFKfqDS/oDSuDOZJXiCToG1tQjsoT4Zfr7wdAEfrWfAO3NXds096HGcP3F
	bbopu94FxilFJ57wBMKbX6SQ3YzoOo2y9kRn7RgKspHHUwdIU0FQTsmpz04VEaQQ4Um9Mt2ckby
	hwkXamVQx1etUmAQe18bhwEkKHZneY0QMuVvPa1KnYtkzwLHiBLgmfJldyQxoJKSdpb0JvHXD6H
	wtPTsWNAZsAb16o49SyawXhVL+o/fHKSrCntJleoOZduyZkN3Wy1S5ON0FaXCuTtaXQZtZze4Mk
	CCP3/a0FlnhjyCIdACVuMhH7PDPU01k99N+Es/nl254nefiZbb8=
X-Google-Smtp-Source: AGHT+IHxyZfWztzZgfuJiUeDYUFJ1Qtfo43qMHUxbq5Zh05k0OwXtJFs0omeilOH7fX0Bdxckb3jCg==
X-Received: by 2002:a05:600c:1f84:b0:42b:a961:e51 with SMTP id 5b1f17b1804b1-438dc21f186mr939945e9.0.1738149347033;
        Wed, 29 Jan 2025 03:15:47 -0800 (PST)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc52096sm19488465e9.39.2025.01.29.03.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 03:15:46 -0800 (PST)
Date: Wed, 29 Jan 2025 11:15:42 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
	jean-philippe@linaro.org, jgg@ziepe.ca, nicolinc@nvidia.com,
	vdonnefort@google.com, qperret@google.com, tabba@google.com,
	danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 27/58] KVM: arm64: smmu-v3: Setup command queue
Message-ID: <Z5oN3sAk2RY4vyOr@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-28-smostafa@google.com>
 <4e9d04e4-729d-483d-8533-06b3e0a2fb04@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e9d04e4-729d-483d-8533-06b3e0a2fb04@arm.com>

On Thu, Jan 23, 2025 at 01:01:55PM +0000, Robin Murphy wrote:
> On 2024-12-12 6:03 pm, Mostafa Saleh wrote:
> > From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > 
> > Map the command queue allocated by the host into the hypervisor address
> > space. When the host mappings are finalized, the queue is unmapped from
> > the host.
> 
> Don't forget the fun of reimplementing the errata workarounds to avoid
> generating certain problematic command sequences - beware it's mostly
> implicit in the current kernel driver :)

Thanks, I see I missed “ARM_SMMU_OPT_CMDQ_FORCE_SYNC”, I will try to re-use
as much of the command queue code as possible in v3, although it’s unlikely
the hypervisor will have the some insertion algorithm as the host, but at
least for the command population.

Thanks,
Mostafa

> 
> Thanks,
> Robin.
> 
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >   arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 165 ++++++++++++++++++++
> >   include/kvm/arm_smmu_v3.h                   |   4 +
> >   2 files changed, 169 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> > index f7e60c188cb0..e15356509424 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
> > @@ -41,6 +41,15 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
> >   	__ret;							\
> >   })
> > +#define smmu_wait_event(_smmu, _cond)				\
> > +({								\
> > +	if ((_smmu)->features & ARM_SMMU_FEAT_SEV) {		\
> > +		while (!(_cond))				\
> > +			wfe();					\
> > +	}							\
> > +	smmu_wait(_cond);					\
> > +})
> > +
> >   static int smmu_write_cr0(struct hyp_arm_smmu_v3_device *smmu, u32 val)
> >   {
> >   	writel_relaxed(val, smmu->base + ARM_SMMU_CR0);
> > @@ -60,6 +69,123 @@ static void smmu_reclaim_pages(u64 phys, size_t size)
> >   	WARN_ON(__pkvm_hyp_donate_host(phys >> PAGE_SHIFT, size >> PAGE_SHIFT));
> >   }
> > +#define Q_WRAP(smmu, reg)	((reg) & (1 << (smmu)->cmdq_log2size))
> > +#define Q_IDX(smmu, reg)	((reg) & ((1 << (smmu)->cmdq_log2size) - 1))
> > +
> > +static bool smmu_cmdq_full(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	u64 cons = readl_relaxed(smmu->base + ARM_SMMU_CMDQ_CONS);
> > +
> > +	return Q_IDX(smmu, smmu->cmdq_prod) == Q_IDX(smmu, cons) &&
> > +	       Q_WRAP(smmu, smmu->cmdq_prod) != Q_WRAP(smmu, cons);
> > +}
> > +
> > +static bool smmu_cmdq_empty(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	u64 cons = readl_relaxed(smmu->base + ARM_SMMU_CMDQ_CONS);
> > +
> > +	return Q_IDX(smmu, smmu->cmdq_prod) == Q_IDX(smmu, cons) &&
> > +	       Q_WRAP(smmu, smmu->cmdq_prod) == Q_WRAP(smmu, cons);
> > +}
> > +
> > +static int smmu_add_cmd(struct hyp_arm_smmu_v3_device *smmu,
> > +			struct arm_smmu_cmdq_ent *ent)
> > +{
> > +	int i;
> > +	int ret;
> > +	u64 cmd[CMDQ_ENT_DWORDS] = {};
> > +	int idx = Q_IDX(smmu, smmu->cmdq_prod);
> > +	u64 *slot = smmu->cmdq_base + idx * CMDQ_ENT_DWORDS;
> > +
> > +	if (smmu->iommu.power_is_off)
> > +		return -EPIPE;
> > +
> > +	ret = smmu_wait_event(smmu, !smmu_cmdq_full(smmu));
> > +	if (ret)
> > +		return ret;
> > +
> > +	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
> > +
> > +	switch (ent->opcode) {
> > +	case CMDQ_OP_CFGI_ALL:
> > +		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
> > +		break;
> > +	case CMDQ_OP_CFGI_CD:
> > +		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SSID, ent->cfgi.ssid);
> > +		fallthrough;
> > +	case CMDQ_OP_CFGI_STE:
> > +		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
> > +		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
> > +		break;
> > +	case CMDQ_OP_TLBI_NH_VA:
> > +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
> > +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
> > +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
> > +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
> > +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
> > +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
> > +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
> > +		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_VA_MASK;
> > +		break;
> > +	case CMDQ_OP_TLBI_NSNH_ALL:
> > +		break;
> > +	case CMDQ_OP_TLBI_NH_ASID:
> > +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
> > +		fallthrough;
> > +	case CMDQ_OP_TLBI_S12_VMALL:
> > +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
> > +		break;
> > +	case CMDQ_OP_TLBI_S2_IPA:
> > +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
> > +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
> > +		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
> > +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
> > +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
> > +		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
> > +		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_IPA_MASK;
> > +		break;
> > +	case CMDQ_OP_CMD_SYNC:
> > +		cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	for (i = 0; i < CMDQ_ENT_DWORDS; i++)
> > +		slot[i] = cpu_to_le64(cmd[i]);
> > +
> > +	smmu->cmdq_prod++;
> > +	writel(Q_IDX(smmu, smmu->cmdq_prod) | Q_WRAP(smmu, smmu->cmdq_prod),
> > +	       smmu->base + ARM_SMMU_CMDQ_PROD);
> > +	return 0;
> > +}
> > +
> > +static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	int ret;
> > +	struct arm_smmu_cmdq_ent cmd = {
> > +		.opcode = CMDQ_OP_CMD_SYNC,
> > +	};
> > +
> > +	ret = smmu_add_cmd(smmu, &cmd);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return smmu_wait_event(smmu, smmu_cmdq_empty(smmu));
> > +}
> > +
> > +__maybe_unused
> > +static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
> > +			 struct arm_smmu_cmdq_ent *cmd)
> > +{
> > +	int ret = smmu_add_cmd(smmu, cmd);
> > +
> > +	if (ret)
> > +		return ret;
> > +
> > +	return smmu_sync_cmd(smmu);
> > +}
> > +
> >   static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
> >   {
> >   	u64 val, old;
> > @@ -94,6 +220,41 @@ static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
> >   	return 0;
> >   }
> > +static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	u64 cmdq_base;
> > +	size_t cmdq_nr_entries, cmdq_size;
> > +	int ret;
> > +	enum kvm_pgtable_prot prot = PAGE_HYP;
> > +
> > +	cmdq_base = readq_relaxed(smmu->base + ARM_SMMU_CMDQ_BASE);
> > +	if (cmdq_base & ~(Q_BASE_RWA | Q_BASE_ADDR_MASK | Q_BASE_LOG2SIZE))
> > +		return -EINVAL;
> > +
> > +	smmu->cmdq_log2size = cmdq_base & Q_BASE_LOG2SIZE;
> > +	cmdq_nr_entries = 1 << smmu->cmdq_log2size;
> > +	cmdq_size = cmdq_nr_entries * CMDQ_ENT_DWORDS * 8;
> > +
> > +	cmdq_base &= Q_BASE_ADDR_MASK;
> > +
> > +	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > +		prot |= KVM_PGTABLE_PROT_NORMAL_NC;
> > +
> > +	ret = ___pkvm_host_donate_hyp_prot(cmdq_base >> PAGE_SHIFT,
> > +					   PAGE_ALIGN(cmdq_size) >> PAGE_SHIFT,
> > +					   false, prot);
> > +	if (ret)
> > +		return ret;
> > +
> > +	smmu->cmdq_base = hyp_phys_to_virt(cmdq_base);
> > +
> > +	memset(smmu->cmdq_base, 0, cmdq_size);
> > +	writel_relaxed(0, smmu->base + ARM_SMMU_CMDQ_PROD);
> > +	writel_relaxed(0, smmu->base + ARM_SMMU_CMDQ_CONS);
> > +
> > +	return 0;
> > +}
> > +
> >   static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
> >   {
> >   	int ret;
> > @@ -113,6 +274,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
> >   	if (ret)
> >   		return ret;
> > +	ret = smmu_init_cmdq(smmu);
> > +	if (ret)
> > +		return ret;
> > +
> >   	return kvm_iommu_init_device(&smmu->iommu);
> >   }
> > diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
> > index fb24bcef1624..393a1a04edba 100644
> > --- a/include/kvm/arm_smmu_v3.h
> > +++ b/include/kvm/arm_smmu_v3.h
> > @@ -16,8 +16,12 @@ struct hyp_arm_smmu_v3_device {
> >   	struct kvm_hyp_iommu	iommu;
> >   	phys_addr_t		mmio_addr;
> >   	size_t			mmio_size;
> > +	unsigned long		features;
> >   	void __iomem		*base;
> > +	u32			cmdq_prod;
> > +	u64			*cmdq_base;
> > +	size_t			cmdq_log2size;
> >   };
> >   extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
> 
