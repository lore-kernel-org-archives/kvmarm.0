Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D983F9F51
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 08:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784017791; cv=none; b=Ou4DYcz3b5HXQq5hCL3rdrlRavPQl+lS4Magg4/Xn4nsPHXd76ykK6wgBlgycsq6I6nz7M0Li2BlleBJmng5BCphjZpt4aiWsY1I07rhaVMzWkydFoS1XSnquZwEpXpntjr5KjZHPS6RLXogkElx90cVq4c/srO0gWwMW1kicj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784017791; c=relaxed/simple;
	bh=ocFVzAC3/f6XF2JEGGnEYrZo88e1CemFP3AD9C04FJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZ2yKh0OOP3vpno6NMmec/uPkAJN81K/iz9V3oTB14YbujP0tMfmCZtHwXHrI+OXHcjoGI7x4u919qDXlf19RrJCbPbBJHEQ+1TR7MzBBYiGytFnSmzcWHpmkufZeyhjtJ0CEJTLTbicWeBN022UeAa7lSDrjmQoZNC25OGL3YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VBk7WNbY; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VBk7WNbY"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493b8d92a4eso42095e9.1
        for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 01:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784017783; x=1784622583; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h1XR0xXH676IkskJiy7lkXwYtMlnQ7GpPOPMnybj7LE=;
        b=VBk7WNbYb5ZWsMvaqgk2ev0etQ/Nmsme1N6T2oS6D68bsGFTEwfFtU72XEM4OnO9PP
         XNQ7yLo0izG1WzOfmjbSYj2+hf5ls5xcQQReY639QqM3uyow9N1yHPav5Vt50o2jRf0O
         Yc/i4xfsEm+kklN6xMVdc+OTGPL5SDghh7hYHvGhLMWoOrvLoAzKuQV08m2zAgD/rUCd
         DIUdLT1MoRMOvph2bWDc8MlIJJD/sV08J8zDB5HVXjLa8cN/lo1e3/Dsp/uwl3Xpqo3y
         7sFtmMnxEkRwwwg2hyPuhJXPzvJF4HBiNnVL/ds2iFCL3pGVmwjSUH2CvPXcuLWPNZ/j
         KBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784017783; x=1784622583;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h1XR0xXH676IkskJiy7lkXwYtMlnQ7GpPOPMnybj7LE=;
        b=e++HPyVrIr+NxlK3tnM/3TAMijnp9wd3WbIG8rCyaphGdR9X2lOGseCnpeJHT//LIl
         f5rYtrC4VpNdsglOYrcbOJcsThvWVHKjh2KqjyWf925Mf7SJ4VOD9pRFjoVzEPwoSRV7
         qQZId+4KExJSTETas+8f12lqRdnlin/ZmaI2lSUMQJt6fdnbvtgFBKj3KC/5N8BvwMZl
         eoSRFpmJF7uJnQnitm5o2zmq9rExU+04U7Zv8BPK1eQOSPbImzHiGWZhaBwjUiw3RySP
         xXwGRU8LReJtEWqEzuoSVqOOco7itV8s5GzCRLVN5oDj9qPZ7fY2Dmrl+YuMf3SXVQDL
         jdjQ==
X-Forwarded-Encrypted: i=1; AHgh+RrimQsyhkcnQbXTystlLVHQOjsmnHrqsAObe7Ma29PpIJGwptnzUh6YxLs5prPuLniwQLdA1Mk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxcu8JNnBfTFw1cC1P2twQbauRcDgYRdJQTI2cYD1fsw4Qi1Abv
	gqNJrGjrb/UsHV/RhDi/l5vAzkgd9JZjQvV6efriKOoymf3wAwhOhzMIlXIc3u7aZA==
X-Gm-Gg: AfdE7cllprYlMs5jgNEDK1yw0+MK+pVVcKi8FwLsESsS/KWPi/blyo4tfdyCAv+qQDp
	66i2F5C52aV/jC88dZyvCkxMvk8e/g2F6u0hbEpyeosdypYhwMTvxTp62G8BvEDP+GNH1d8PspR
	icYLtuQrB9A+g5YbfRZ936xRGjuJw+jQgnHkB+nJNNF3aN5bPmr0upBe8SpziLVHyZQKs87YRdk
	b81GxMFLLqXZ6vkSzwjf+gzyQ2xTAmLuTKAmvhfTeU+zxDWgT3zsSSu1W79CA19AMpejapmLfMN
	4R+/0UsbWEe87qgulPNkfjT/8b3zHLL3tGk6Ug0yEXIfKSXHskinbK2PbGuPxLzcS1T2hQlzFrq
	lMK1TmH+myLGuqufuMmpWaWIl9n2Fzi6nV7PcA+ryAcKj5memqQr9GTGWGbgU9azWLI0QyX/MKR
	bAfMj+4qoYEJStCW7aeij3bAaQZAsY9rGATqgkQJrHHYlvfQHy
X-Received: by 2002:a05:600c:621b:b0:493:b169:784d with SMTP id 5b1f17b1804b1-49462165300mr1774335e9.8.1784017783083;
        Tue, 14 Jul 2026 01:29:43 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c9cc3sm6301185f8f.35.2026.07.14.01.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 01:29:42 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:29:38 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 08/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <alXzcrnxWADIEL2H@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <alTnAy7jvjUamwUA@google.com>
 <alTvf7iiOWn4PKE8@google.com>
 <alUA7zsJO1FGnss-@google.com>
 <alUJa5cbjjqZ8n72@google.com>
 <alUMVU7DYcrvgAYi@google.com>
 <alUsLFBQ5qKFOgwQ@google.com>
 <alXwXRGqECTUZ3ou@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alXwXRGqECTUZ3ou@google.com>

On Tue, Jul 14, 2026 at 09:16:29AM +0100, Vincent Donnefort wrote:
> On Mon, Jul 13, 2026 at 06:19:24PM +0000, Mostafa Saleh wrote:
> > 
> > That would walk the table twice, first time with a massive map, then
> > to unmap the pages that was just mapped, issuing TLB invalidations
> > for all of those, also as the IOMMU page table code never frees tables
> > that means we would immediately exahust the IOMMU pool.
> 
> Well the massive map is pretty quick we would mostly just allocate the PGD? And
> then it would be just for the subsequent unmaps to split the blocks. So nothing
> to be freed really and no risk to exhaust the pool. But if you put the calls to
> the host_stage2_* functions that's pretty transparent.

Not for the IOMMU, everything is mapped with a leaf mapping, because
the pgtable code does not support splitting blocks, this is something
I plan to add support for in a follow up series after this one is
merged along side other optimizations.

> 
> Just to make sure I am clear. Here's what it could look like:
> 
> in iommu.c:
> 
> int kvm_iommu_stage2_idmap_init(struct kvm_s2_mmu *host_mmu)
> {
> 	u64 addr = 0;
> 
> 	for (i = 0; i < hyp_memblock_nr; i++) { 
> 		kvm_iommu_stage2_idmap(addr, reg->start, IOMMU_MMIO);
> 
> 		addr = reg->start + reg->size;
> 		kvm_iommu_stage2_idmap(reg->start, addr, IOMMU_READ | IOMMU_WRITE);
> 	}
> 
> 	kvm_iommu_stage2_idmap(addr, kvm_phys_size(host_mmu), IOMMU_MMIO);
> }
> 
> in mem_protect.c:
> 
> int kvm_host_prepare_stage2(void *pgt_pool_base)
> {
> 	...
> 
> 	return kvm_iommu_stage2_idmap_init(mmu);
> 
> 	/* 
> 	 * From here, all the changes to the host stage-2 will be reported to
> 	 * the iommu driver
> 	 */
> }
> 
> On the pro side: no custom walker and we really couple the iommu idmap to the
> host stage-2 map.
> 
> On the con side: As you've pointed out, we'd need indeed the iommu to be ready
> early enough.
> 
> If you want to stick to the snapshot function, could we have the walker to
> first walk the hyp_memblock? the .arg could just pass if we are walking a MMIO
> region? That would avoid that find_mem_range_from() and I believe would
> massively simplify the snapshot walker.
> 

I see, let me try that.


Unrelated to this, but while looking into option#2 I see that
__pkvm_guest_share_host() does not call either of the
host_stage2_set_owner* so that requires another explicit
pkvm_iommu_host_stage2_idmap() call.

I still plan to use option#2 in v7.

Thanks,
Mostafa

