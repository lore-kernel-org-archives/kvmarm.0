Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5AA5616C0
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092381; cv=none; b=uETiwHQLfTYN8XeYYaigCwtTqe6zVzfpv/gTOCPm2LpCCP/jKl7XLM7Fb770gn6AvxiuXDGATKDZFOQP5LjfPDP5La8qNfpFqJ3OPabYKab9qH2uHDyKhoDptqsWRqX/06zkjPWeSt3k6uRFZEKWf5TTBdHruLaKqNl3GCqT1jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092381; c=relaxed/simple;
	bh=F3Akm1fxeCyQo5jkMhk8hUJ91HO8muQx4UmIHFtxLeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUsCjVTchZ+1xfJz2oGLiUxeEMGN/jFSwKJcvFyw/OZaxu1h8SfISdLmVlsuZs/ItTaeNeE8sSTDD+q/3BXLMfAcVcrNvN+NJaSygJzTQLJVcrxHsQAKuohKiyjm8XlllSdNxZZe+DVfOqKXv+5HAnnuJ63MLJocvF+mm3NItqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NsArKcDT; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NsArKcDT"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49ccf12bed0so55335e9.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 08:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790092377; x=1790697177; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lo9R5p1e+ZdfS591vCz//NO2NPPbPOnHUyt7PCl3j0s=;
        b=NsArKcDTYXbOakahUUkYZmKNdVHy4a0O5a9K5WWtaDhL2jzIWdxqlWhxtG3I6mhkgm
         EzqMdlCPPHfQfduMnE1tnqkBDhmFJeoodEjk0xERjKVT/B5qsWxn4qReKBKHLC0JpCN2
         0jp6FK38BE5uNjC9lr8GsKJ+1r9bZa61KV9Z6MMOsLLO3hmEpjsUeeTu1/FZGnXCBdGp
         cYezdrrJO1sy/zh2urCvAFSl6vfLaaRz5qjpjq8439ujTV3ZSrFyEoKD9R2jzX+0rj2+
         LSQHU1UCHf0eAJ2uWoLXTG3RBO/QvtwNGblWVIvl7yg+Es+eV0X1I+4x1WnWwsXlFI49
         ZvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790092377; x=1790697177;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lo9R5p1e+ZdfS591vCz//NO2NPPbPOnHUyt7PCl3j0s=;
        b=wpcfA6lFCY/mJlXQ8g5x/CyhZqX1Zm4FowRmmxv7toEuT4T+GuFX6myL3q3tQZ9cNp
         4uiO//34NW4petaxIKiolZwcf6wgsNjFSKe++ODpcCYFt0yw28kgT0NrjjV+p4H4zM/c
         pRc7mGHPkhmB/Xk/jRcTpPNEGggN4cQDyKVN/y2aALcZ974hIMGlXY4uTG/i6HWn3h9z
         TV1Kr3eYaOsUARgSrd1VRc6SJ0Hy/K5O40CKFlzu1Ej90/M7ArseLwHZexDxDW6PSfuB
         K1vouavXxU+c5LPJHAcgHGspybErqoF0BTYJnrcEyexEjs/9rSlRM9BsGSSGpS5KFJiB
         sjtg==
X-Gm-Message-State: AFuF++lsbtPCO1O8TLDbDuD7COQQtIeBuwMASvFDB0gPWmamyDJ9FLGm
	MPTXVovxE7bsxzD/Phnldk4SZrTskdJoARufTPLxHALhW48aJZRR5R4ObxS9ACgxFw==
X-Gm-Gg: AYBFou2zUbrO8lSO+BTebDcD7vmiSs11Ag/2c0thXIDf3LL58hb9WZq/z+iv9sFJfKB
	Jqs/41uWlNIfbgBPc6LlFXkZjvHpqraRlytrpsj5IuUAd6OSCWd2JUTFwBqpuLzd2cgwXlOSg5F
	HBialrnpzQN4BMo7bVo6+xCnanpjVaCWzsJEasj+K9PV90tBFXKjYLi8WpdLIDDBaXt4TxOD+Ew
	dmiWlr8VnfKbeClAto+K9sWT8mhYB5SnJIOVmbP7uqsykp9w166O3YnpUf8N9COdjDk4i8XmyWy
	y0trntBoyRVwym1BqtnUmRKDmXuJcfxI+1uzDnfgfU9wf+TQW+0gpsl4B7EH4382wDzwp7D0DND
	iQ2ADWrT8hO4cG5+2IE0d9bqUyviL7qn3zie+WPxTefmM1PtnIt6JPmqF1cwqXeaPJdkl9q6B+0
	XpIyoDrrg8FPd8ZncE1DV9/jv9KBoyY7AZC5qGAgIpFgI9x4c66AXZDxja/3AmQgejx2A7T2HF9
	EA+4i9E8ZphzyMZWRdkOrX9twRud4SYLyhOvitW
X-Received: by 2002:a05:600c:b4c:b0:499:fa56:f542 with SMTP id 5b1f17b1804b1-49fdd993088mr146495e9.8.1790092376207;
        Tue, 22 Sep 2026 08:52:56 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde180a39sm266765e9.1.2026.09.22.08.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:52:55 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:52:52 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v8 22/25] iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2
 page table
Message-ID: <arKkVCOoSbPxj0Pu@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-23-smostafa@google.com>
 <20260922133815.C415D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922133815.C415D1F000FF@smtp.kernel.org>

On Tue, Sep 22, 2026 at 01:38:15PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] arm-smmu-v3-kvm: panic on EL2 allocation failure during STE reshadow
> --
> 
> commit 866d2f52e473ce62e2402494a1198d807826d481
> Author: Mostafa Saleh <smostafa@google.com>
> Subject: iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table
> 
> The hypervisor calls back into the driver on every change to the host
> stage-2 page table.
> Mirror those changes into an identity mapped stage-2 for the SMMUv3,
> That would be attached to all active SIDs.
> 
> [ ... ]
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > index 6e023e968ed3a..6f0ea3a4e48df 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> 
> [ ... ]
> 
> [Severity: High]
> Can a routine allocation failure lead to a hypervisor panic here?
> 
> Looking at smmu_reshadow_ste() in drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c,
> the dynamic allocation can legitimately fail with -ENOMEM when the pool is
> exhausted:
> 
> drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c:smmu_reshadow_ste() {
> 	...
> 			l2table = pkvm_iommu_alloc_pages(get_order(sizeof(*l2table)));
> 			if (!l2table)
> 				return -ENOMEM;
> 	...
> }
> 
> This -ENOMEM error is mapped to a true return value in smmu_filter_command():
> 

-ENOMEM shouldn't happen here as the pool should cover the worst case
and there is no way to recover from it so it panics.

> drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c:smmu_filter_command() {
> 	...
> 		ret = smmu_reshadow_ste(smmu, sid, leaf);
> 		hyp_spin_lock(&smmu->hw_lock);
> 		if (ret)
> 			return true;
> 	...
> }
> 
> Which is then wrapped in a WARN_ON() in smmu_emulate_cmdq_insert():
> 
> drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c:smmu_emulate_cmdq_insert() {
> 	...
> 		skip = smmu_filter_command(smmu, cmd);
> 		if (WARN_ON(skip))
> 			continue;
> 	...
> }
> 
> Does this WARN_ON() turn the -ENOMEM condition into a fatal hypervisor
> panic?
> 
> At EL2, WARN_ON() expands to a fatal BRK instruction, crashing the hypervisor.
> Host userspace processes can trigger this path (e.g., via VFIO device
> assignment) by configuring multiple devices to exhaust the L2 table pool,
> leading to a host-userspace-reachable panic.

User space can not invent new SIDs, the kernel need to allocate for
those regardless.

Thanks,
Mostafa

> 
> Could this be updated to handle hyp_alloc_pages() failures without
> triggering a fatal assertion?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922131259.2975334-1-smostafa@google.com?part=22
