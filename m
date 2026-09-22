Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BD4560AB1
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092544; cv=none; b=PtmebJhRyRwoNjMPsRDcyY30SanS76bxedvcnx9PgaRMwcqO1GgRRAmqp7b1JR4zupAHAeCt0mDNASIpjFS4cM3CPHVuAlyQWhLDsnmg1t3qM6yUndUBDbV/s+Z4M9IwzczKv9Ok5uZqMlQpofRFambOMAA4Op59Df5WjFttsCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092544; c=relaxed/simple;
	bh=VVkOHEfpLNHHPekd6apPADeBF484ltkflWoqjU0FKWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOPrT48F9h+JdMB54o8FOe8Z0m5QYAcaEbEiqx5F4rxuBah7xAmyAUgDvgLwo0AvK0Y0C1XdetxEP/l5HkR7hmbs8d2siuf8OS7RKjGKttcMyqe2UM8RFWzLkwoczsfOCqnmx8HYiN5GeTLX5QFIvC/cJC4aWbQMBBEDaEsyUp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YGjAMV6S; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YGjAMV6S"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49ccf12bed0so55585e9.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 08:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790092540; x=1790697340; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cpMsG9oOzAQyeQrLMHpiW+jZDIl7k+NHgCmMQE42PTc=;
        b=YGjAMV6SkZEXgepHbn8c/itK17ZGxN2PJ7WYf3nu6JirX31g81bqL5A7XCV8PAOncW
         nmAmSaJ1vwkTs0RaUxeHrX3kOPexVJt1Ty2j8g08p10r9fGosR21Kl2BqdHFjO8tSqg0
         Kc5Oofy6V8o3qN9SC9ZNqOjpNWJf4tMdIV2m4/5YZ2VeYPnVnIgvEyWuxHl/nnxRhaxk
         +lI6V9+HcZMJcR+KCO97jV7udev0mdXby+R0EQFJRCmnKBAV8kweheq0EkPInXkTIaom
         D9hj4LisbGilJvcYTMqf7sAFjQR/piUA/SRJ6rFBWW4cmKivIB8YE3anlws8xikpf+aW
         7M9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790092540; x=1790697340;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cpMsG9oOzAQyeQrLMHpiW+jZDIl7k+NHgCmMQE42PTc=;
        b=OnZ2EEuReWBoQ3SCEb1HlegTpGfNSOnC8aL5KeWhHPclyF+D0qDI/003IjFIgAQV+H
         5njfijVhTg5OUTzDGTpFc99EWD1DW2LiTqqOQw8WF9PWo5hkWJkXkA76U0mUETUx46Pt
         faQNyuf7E5E3jiIekzdSrZj4Do+o75zvZuM83oY0aQaSkyt+hOAS6v70gwvELJDDcEOV
         BR2GXwfZ1qpwzux5pO6RsQlVx+dSkak3QMuZ9+oBOraTiZytL//s2cfyWXblCcFNhfRK
         FORHZr9scybGj8URdMLa/3w9JC5iwxvFikyFwyxJfEdCI6F1XeyQQaM/GtJVP1msVdqL
         njhg==
X-Forwarded-Encrypted: i=1; AKwUvBx7yMh4Kg+OKekEL6RUG1M6K87HGeuqTlNv99964INHKdwtl9fGkV3BlBqUdOP8ybH83CwxpYw=@lists.linux.dev
X-Gm-Message-State: AFuF++mziTONJXGFx3wbmDfjQlo2lts8DFrJSKvpjs/46ulGLRwAu4dy
	VfVZeJihcR0UD2+mPxXkOt1CKHA9LeFJYP+KDR2smixQGTnpqSA27T8oO1scmdBs1F44Rfz6Jsq
	Y9HqV8g==
X-Gm-Gg: AYBFou2CXk8oLfwMaLaZevhtUsjVHpUMKC3MpBalK53DGQevCjK6cC4EvQpMjLf0GyX
	8YbBlo/Jk3WcHiX3ZvRHS+R3Lw+Af+WKm5zuPdsM9ptflJLA+BNhl0De/KZ6neCzNTgnnTw9GZl
	QYy2Q/F2L2Fzq5WaTUiWZJU8Z8FNy3M203uvA4MazpjjXXc3KhuCQLT3IXt31eKG/5GwYUADSy9
	1DrKCHRBksXfBK2p3OIxRPHjJef9WHvvywDGACxbp5t4Xcb+gQNcSXWTigNhiM7gggbLomNqxos
	MEYnx5OA09qhmHJvp9hHNn98uPyHijPVjqvXKh5Y9wwL15FUJDfOICV6KY7+AQNuUDzxr/TOQpe
	kkjT2BtCj8f0P8IkvA3xxBBuJY1ID3UrKQZfJ0C32eJwv0RZCLVYUD3yR6lZ3Fnp2iePa85l9D7
	vwj3IQ0vIxOF6KNpSB7dNkJnkwlSJDP89AzK1rfF4iv3JgscW0wefe54fJ6Nz/BaTTX+PVhniXj
	OQVfw9tYVGec7tpxVbYHq3g7XcAQLhScTQdf/ue
X-Received: by 2002:a05:600c:6005:b0:49e:642a:9279 with SMTP id 5b1f17b1804b1-49fdd97d911mr142685e9.4.1790092539769;
        Tue, 22 Sep 2026 08:55:39 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde199c21sm204675e9.9.2026.09.22.08.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:55:38 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:55:35 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v8 23/25] iommu/arm-smmu-v3-kvm: Invalidate the SMMU TLBs
Message-ID: <arKk9x6Oy8hFQiyp@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-24-smostafa@google.com>
 <20260922134512.180151F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922134512.180151F000FF@smtp.kernel.org>

On Tue, Sep 22, 2026 at 01:45:11PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] iommu/arm-smmu-v3-kvm: dead-branch traps and incorrect WARN_ON usage at EL2
> --
> 
> commit 12e407f77295df6bfe7066853a3a177e9465aaf7
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Invalidate the SMMU TLBs
> 
> This commit implements the io-pgtable flush operations to invalidate the
> shadow stage-2 in every SMMU. It tracks whether the SMMU command queue is
> enabled and issues invalidation commands to the hardware when active.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > index 6f0ea3a4e48df..5417a5c2bf58a 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> 
> [ ... ]
> 
> > @@ -221,17 +220,139 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
> >  	return smmu_sync_cmd(smmu);
> >  }
> >  
> > +static int smmu_tlb_inv_vmid(struct hyp_arm_smmu_v3_device *smmu)
> 
> [ ... ]
> 
> > +static void smmu_tlb_inv_range(unsigned long iova, size_t size, size_t granule,
> > +			       bool leaf)
> > +{
> > +	struct hyp_arm_smmu_v3_device *smmu;
> > +
> > +	for_each_smmu(smmu) {
> > +		hyp_spin_lock(&smmu->hw_lock);
> > +		/*
> > +		 * Don't bother if CMDQ is disabled, this would be useful for the case
> > +		 * when RPM is supported to avoid touching the SMMU MMIO when disabled.
> > +		 * The hypervisor also asserts CMDQEN is enabled before the SMMU is
> > +		 * enabled. As otherwise the host can prevent the hypervisor from doing
> > +		 * TLB invalidations.
> > +		 * When the SMMU is re-enabled the hypervisor cleans the TLBs.
> > +		 */
> > +		if (smmu->cmdq_active)
> > +			WARN_ON(smmu_tlb_inv_range_smmu(smmu, iova, size,
> > +							granule, leaf));
> 
> [Severity: Medium]
> Does this WARN_ON() panic the hypervisor if the hardware command queue
> stalls?
> 
> At EL2, WARN_ON() expands to a fatal BRK instruction. If the SMMU command
> queue is full or stalls for >1ms, smmu_wait() returns -ETIMEDOUT, which
> will bubble up here and cause an unrecoverable hypervisor panic.

There is no way to recover a command queue timeout, ignoring the error
might lead to TLB not being invalidated and leaking the memory content
so WARN_ON() is suitable for that.

> 
> > +		hyp_spin_unlock(&smmu->hw_lock);
> > +	}
> > +}
> 
> [ ... ]
> 
> > @@ -725,6 +873,8 @@ static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
> >  		return;
> >  
> >  	WARN_ON(smmu_update_ste_shadow(smmu, true));
> > +	/* Clean the TLBs each time the SMMU is enabled. */
> > +	WARN_ON(smmu_flush_all_tlb(smmu));
> >  }
> 
> [Severity: Medium]
> This isn't a bug introduced by this patch, but looking at the existing code
> just above this in smmu_emulate_enable():
> 
> 	if (WARN_ON(!is_cmdq_enabled(smmu)))
> 		return;
> 
> Does this create a dead-branch trap? Because WARN_ON() is fatal at EL2, the
> intended graceful return on an invalid host state is unreachable, as the
> warning itself panics the hypervisor.
> 

Same as discussed before.

> [ ... ]
> 
> > @@ -745,6 +895,13 @@ static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
> >  
> >  static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smmu)
> >  {
> > +	/*
> > +	 * We can not enable the SMMU if the CMDQ is disabled and similarly
> > +	 * we can not disable the CMDQ if the SMMU is enabled, as that can
> > +	 * lead to stale TLBs.
> > +	 */
> > +	WARN_ON(is_smmu_enabled(smmu));
> 
> [Severity: Medium]
> Does this allow the host to trivially panic the hypervisor by issuing an
> invalid sequence?
> 
> Since WARN_ON() expands to a panic at EL2, asserting directly on
> host-controlled state (disabling the CMDQ while the SMMU is enabled)
> turns a host misconfiguration into a hypervisor panic, bringing down the
> host and all protected guests.

Yes, the host can panic the system in many ways.

> 
> > +
> >  	WARN_ON(smmu_unshare_pages(smmu->cmdq_host.base_dma,
> >  				   cmdq_size(&smmu->cmdq_host)));
> >  }
> 
> [ ... ]
> 
> > @@ -1020,6 +1177,20 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
> >  		else
> >  			writel_relaxed(val & mask, smmu->base + off);
> >  
> > +		/*
> > +		 * Make sure writes to CR0 are immediately observed, that is important
> > +		 * when synchronizing with TLB invalidation as reading CR0 is not enough
> > +		 * to deduce the SMMU state, and we have to enforce the ack with the
> > +		 * hw_lock acquired.
> > +		 */
> > +		if (off == ARM_SMMU_CR0) {
> > +			u32 cr0 = val;
> > +
> > +			WARN_ON(smmu_wait(false,
> > +					  readl_relaxed(smmu->base + ARM_SMMU_CR0ACK) == cr0));
> 
> [Severity: Medium]
> Could this strict equality check predictably time out and panic the
> hypervisor if the host writes reserved bits?
> 
> If the host writes RES0 bits to CR0, the hardware drops them, making the
> strict readl_relaxed(...) == cr0 check fail. The poll will then time out,
> and the WARN_ON() will fatally panic the hypervisor.

See above.

Thanks,
Mostafa

> 
> > +			smmu->cmdq_active = !!(cr0 & CR0_CMDQEN);
> > +		}
> > +
> >  		hyp_spin_unlock(&smmu->hw_lock);
> >  		return true;
> >  	}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922131259.2975334-1-smostafa@google.com?part=23
