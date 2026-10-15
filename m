Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3841D468C2E
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 21:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792098684; cv=none; b=iJU2aCB07uWQND/dP5bD+nnCaFboglUhJ6P0t3Xb48OtmMQBkaNsTJv4sgGxsBFqnCEm/Y5/fFg6E0DhRwbMqC42uJfM/chfY4ywh8l/iqIpX46BeuG+37EBEaTFV547q6tfIo+66fjDWlPSfK49CpmbfWwVBwWgOk6yKSGLhAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792098684; c=relaxed/simple;
	bh=JjP/EokpswoFwaDs1/CL0b5eTA9ELthAAPeLzPL29K4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xz/RoobMZicpH3FY0svYlsK9sfbc9hiqKh0w6mXt6MuiWPRwoEi7gRHTBeRJBWIt9mvxX+J7PWa2Q/gSv0QQLTkl2TFKfUdp1L+YU3aiyJDW6Jdcszar7eWTt202/E5DMVDMIpTYrA6EqSQJZjp3mZJD6KTv5toxU1XwZFLFbxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M/ouPCf0; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M/ouPCf0"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a021c28046so4895e9.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792098677; x=1792703477; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SgzekR1/yEOPUyZ+mesYeN33QvO4P+oxwoRz+ghpTK8=;
        b=M/ouPCf0tqjUXNrkqHllatC3p1B3FLfULVccToYI+GzeoGz8xDc7PdTXP3K22P3QBn
         4QiCeFtfVhooFplaLGLFaqKQH7OcSmf0PoLS6m4dHdtx6a6nKtBgwkX5e6Cpb3aQOclv
         wIEcm1DPuAKDow9sZZInkXooySfGCWkuMl4DPlBwxIe7jpGtjJkdn7Zy0rVmm2Yxq7/h
         d9BY4QPfOH2ZeE8nl6Y+GeQ/q5MZR7ELBFOVZqgqmvgOVS8nak/Kl/I5Ac3dQEELd/wU
         d7U2Sq+E3O1CDGgfocwditL/h2QjXnuIpswbtbIV/iweD1alYNwLwWqWS803htq/VvwY
         GYlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792098677; x=1792703477;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SgzekR1/yEOPUyZ+mesYeN33QvO4P+oxwoRz+ghpTK8=;
        b=EFWau22nWG9eTElkcdRi/VN2wnYJdhE3UBU08xZCDQ1+4aiEhQr7HZJ7sBTmhA1JER
         sbdCAFIjjxRKULrh4VyuRANpRmWaRKinOxiEFfJQ4ZHTqQWaaGA8Ta9ky6oTxwoLY5Sf
         vmX0KIxOtb3rn8/2HH+SHXhIUry3CCFds/ftmvI4FhXpvU+dCtrUGU3ywORqmLlP3v5E
         ZuJv0QN1wfCUcNxLP7Vgep5oy78PBv4W3y4dIBKEIwBCV0EZMnU6gwIlcLwZ6ddz89xi
         PmqnO9odu9jkhEQ06zjYakDC/1pJ0UOUDLB4M4wELbd1a5HICoQ6/ElMHiKgWHwB26iv
         F2pA==
X-Gm-Message-State: AFq9FYLuWGDEUdlLTuetRBmUs5pkEVBvjyM1j5HC3bykxDBvjCjhTdx+
	Ll3L/ws493kWvq+5A0rwqo5FQ5gux9GwxHx1qPP4YNUKAEtPJqhEhz2sGxbGtgXaBQ==
X-Gm-Gg: AYBFou2Ky1TjlJ9I0delYdgWCJizSJr7LYblba5ink5V3TZToGTVWL7s5Jjz7fvDQzi
	xDgvVCXHII6GmMF/ybDMJCd1JLFYLHGWVZs2XWskeusZg/1gUSAjd9dyWr3RY2gD/dMaprCONVe
	BamiAMtj+oOr69nke/x6u9NrFehKiQbp5FjFNTWp8/Mgs9UozehxO0J5thGSUT3tjuLVk/HClj5
	hXi/fPr6SZewXfG4K0Ba9p4TDxBWBYwfIuvuXRVzlLX1XYMsRRRCGMvB9o5KpyF8t/aXF5rAfZp
	A2UUUb32FKjIKSPtUrqBqauMvlJRWR7/kdwsGVaSWyA0Q7LoG7HYf7S+4nAM/Ujn2+eV7ykRf4T
	ofZgHXQvhaDY3jdHtCVvotjfJ5V+fAgtbGN91ljCvDv+dSlcGawiktB5VhDSasIaLbf587EoVkC
	z1YD0/GOEQL14pmeHSLjIOqJ0VYQmT/TjOIRnHWJlItNWqLhz4VmllspE1IPs9t82jPjedUq5IX
	Vqp4TrgX0uoTcCqx7yFZZFc/0M70F4dhX7Z3nW0zwVSzER3ivyw
X-Received: by 2002:a05:600c:244:b0:4a1:6d8d:208c with SMTP id 5b1f17b1804b1-4a1c8522843mr192755e9.6.1792098676669;
        Thu, 15 Oct 2026 14:11:16 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd503d78sm455680f8f.50.2026.10.15.14.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:11:16 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:11:12 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 15/25] iommu/arm-smmu-v3-kvm: Add CMDQ functions
Message-ID: <atFBcILmWPOZYbdk@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-16-smostafa@google.com>
 <sashiko-outbox-173394@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-173394@kernel.org>

On Thu, Oct 15, 2026 at 08:30:05PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] iommu/arm-smmu-v3-kvm: swapped WFE logic causes queue polling delays
> --
> 
> commit 533e5a914cd22f171b26c2c5c0e2acfb11756ea5
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Add CMDQ functions
> 
> This commit adds command queue accessors for the ARM SMMUv3 in the
> hypervisor. It includes command queuing and synchronization functions,
> with a 1 ms polling timeout that sleeps in WFE when SEV is supported.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > index 02e7c61758329..c9fc21e405e79 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> [ ... ]
> > @@ -77,6 +113,85 @@ static int smmu_unshare_pages(phys_addr_t addr, size_t size)
> [ ... ]
> > +static int smmu_add_cmd(struct hyp_arm_smmu_v3_device *smmu,
> > +			struct arm_smmu_cmd *cmd)
> > +{
> > +	int ret;
> > +
> > +	hyp_assert_lock_held(&smmu->hw_lock);
> > +	ret = smmu_wait(smmu->features & ARM_SMMU_FEAT_SEV,
> > +			!smmu_cmdq_full(&smmu->cmdq));
> 
> [Severity: High]
> Does this cause the CPU to stall until a timer event?
> 
> When the hypervisor inserts a batch of commands that exceeds the command
> queue size, smmu_add_cmd() waits for queue space and passes
> smmu->features & ARM_SMMU_FEAT_SEV as the __use_wfe argument to
> smmu_wait(), executing wfe().
> 
> However, the SMMU only generates an SEV on a CMD_SYNC with CS_SEV. Since
> hw_lock prevents concurrent insertions and the hypervisor only inserts
> CMD_SYNC at the end of the batch, no SEVs are generated while the queue
> drains. The CPU sleeps in wfe() and relies solely on the timer event
> stream to wake up, introducing massive artificial delays. Stalling EL2
> with interrupts masked for milliseconds degrades system stability and
> risks triggering timeouts.
> 

Not true, the SMMU generates an event when queue become non-full check:
arm_smmu_cmdq_poll_until_not_full()

Also in the spec: 4.1.2
    When SMMU_IDR0.SEV == 1, the SMMU triggers a WFE wake-up event
    when a Command queue becomes non-full and an agent external to the SMMU
    could have observed that the queue was previously full.

> > +	if (ret)
> > +		return ret;
> > +
> > +	smmu_add_cmd_raw(smmu, cmd->data);
> > +	writel(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
> > +	return 0;
> > +}
> > +
> > +static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
> > +{
> > +	int ret;
> > +	struct arm_smmu_cmd cmd;
> > +
> > +	hyp_assert_lock_held(&smmu->hw_lock);
> > +	cmd = arm_smmu_make_cmd_sync(CMDQ_SYNC_0_CS_SEV, 0);
> > +	ret = smmu_add_cmd(smmu, &cmd);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return smmu_wait(false, smmu_cmdq_empty(&smmu->cmdq));
> 
> [Severity: High]
> Is the WFE logic swapped between smmu_add_cmd() and smmu_sync_cmd()?
> 
> Here, smmu_sync_cmd() inserts a CMD_SYNC with CS_SEV, which will
> explicitly generate an SEV upon completion. Yet it passes false for
> __use_wfe to smmu_wait(), forcing a busy-wait (cpu_relax()) and ignoring
> the precise hardware SEV wakeup it requested.

I guess the sync command can leverage the WFE also, as I was focused
on the empty condition when I wrote it, but that is just an
optimization.

Thanks,
Mostafa

> 
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015200903.2735565-1-smostafa@google.com?part=15
