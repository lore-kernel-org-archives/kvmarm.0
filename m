Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE42527057D
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 21:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099494; cv=none; b=iam4G6IhJIRcf5S7zirVHI0EdcHXEEHxYHDWfw3M5gF+xlAu8f2gMI1hInV2kB5Pa8JY0/e3+beObGfvNHSKcalS4GTsNBKFON40Anh2U0OU9lvxweq7OyLlc2VfjRUNIiP4zz7e38pLcKP8s7lqJxHmhGOok8Fz0vvgBk+VhAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099494; c=relaxed/simple;
	bh=TkXwC6R+EndTetkst/D63lP4L+OGrSsZEzFiPRMyMRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJ0yAanclhtwfxAYoDuKAtxfJX29sRDC/QKhsh6/fdwH0eBW0wt24AQkdKw0AcrHu9iEoAI6uV7GuS49TGRGxKi3xkRaNyrmlNgeEVYePHwSI5hC+S3bq3qA5lUvkzIlbKv+ucxmk/dcFnR6d+3tF+GEQrzHi8G9V36+pjVW4sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HBU9/f+v; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HBU9/f+v"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a18617ae90so22955e9.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792099491; x=1792704291; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bq4PgBio1E8gV2wDn/JrOT5yHUjnH8pSBRTBpqMY8oM=;
        b=HBU9/f+v6gpiQNfRv+VLzw7/LOs+GGM6ZW+TSAKkWkfYI8zCU2BIuxV4DzhKVUeatt
         6Yec8LgXYi6XI+yIc1l3RxBny1ck5oWIEvTWHuo30rPXeuk9ZBs0VGevqfpSfK8v3ALp
         1JXb8VzilEvsJ8MrFrobDDP/6Ps/JJ+du13lUFUHdxM8ThiHhn9fFsD/HOrGhVLYgNp/
         kt9i8wqy5aqVFNnvX8GPjcSDIpe8dNoyasd5pwEDbnHx7jgVtJYDDW1gOTkFy/Ni2uiD
         lmLrn8bt6bX/0PjI64JZzmgtYtcxshaStoD0WcxcNAGOSO5xhlbVtn99Mofh/kOVEPHy
         RshA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792099491; x=1792704291;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Bq4PgBio1E8gV2wDn/JrOT5yHUjnH8pSBRTBpqMY8oM=;
        b=EMzNKNxJkd059K213lQVojdE5nqzRfMcEy7mHhAtBGMl2UunwFGhPTlg9FLWjN69GL
         /a9y4mPodSAlLmfhXhmhVgo43mvQsETIGkDc824PMs/wgWPSxRlPSLpxmdSEo48gqjyK
         WzAaEkpzPpD05VTb2hjZUQKYZfikHwGOGKgaAOtcLaVXCqQr/o0hCyZBn0icTQVci0br
         wt1uunELMqnfUOPLPPwzrFHiQqY4uUC5ELr3ax2lpIi1gi9rhKBDkgbUOElIECo7wo0G
         I0mdKFOY8O7GocXwxXJaXs5bXhK/S/608hvSIzXkqAZIEbux9r2xRt/s1kd84UBVfnol
         LbeA==
X-Gm-Message-State: AFq9FYJbbRXpgtmekKSRV8xXkzgYowkNUniLC4em8LqXpbWzJ6rCLcyO
	MIF6uS4X5xi9Xawqgvx8cMd/8u+9rhEgYoEnuyVk46otwOEA4lFybDpJ8xv3ba1Wrw==
X-Gm-Gg: AYBFou1ZrvBMIEZfyvkT0gHJy99LR1xJ4vvaiwB9nismVPCUmuWMlzAmgVrHSIqijpo
	Wk22oagtrUIFxYGpxhl1KNR8ERP2I+fKf75GSf+Zq9Iym51M0aOBePUJ+5eCgTYVQ6Rag9x0csV
	JKxQuIpEJCq7FbBbXb2pfAy8DwInyRNmaN7GbX+wdV6QDWTYu0gk8V0xHx3i7w1xXpc30CGRGFS
	IG7M/5+7kAT8yJzLNLHIQpcI8xUunUuyPHESlDpHGqNvnV8JW9GlObE0Ir7+3ZclXpmxmFxfvLb
	hxs54KLiGg+f0y2dh0B09oxv5kQo6iPTEpPPmmxcZt2jG9DrNz0Qq2J/h0Ywo2o3f5XP/XDlM4W
	mTRQBWGqWuy5SlD6leXe+nL8MG1kLEaOA/CIXQlAdc9UntTgibm3Avd1KQ4kjIU9JpgnP0T1u4Z
	e6wfXdZDodY5ZLjHTyVOgu1if+46vJzXB0Rf+y3E00zz9FeaHWKM1hjheJrflfdPd7mW6kO2QAy
	xOLd+Gh5z4LruJ3y+fCu1oKI2eWs7xq3x2w2VGw
X-Received: by 2002:a05:600c:a40a:b0:4a1:98b1:1de9 with SMTP id 5b1f17b1804b1-4a1c8adda89mr155615e9.13.1792099490706;
        Thu, 15 Oct 2026 14:24:50 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8bb6sm566051f8f.34.2026.10.15.14.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:24:49 -0700 (PDT)
Date: Thu, 15 Oct 2026 21:24:46 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 21/25] iommu/io-pgtable-arm: Support io-pgtable-arm in
 the hypervisor
Message-ID: <atFEnvRG2-AyPuTe@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-22-smostafa@google.com>
 <sashiko-outbox-173386@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-173386@kernel.org>

On Thu, Oct 15, 2026 at 08:26:45PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] arch: layering violation by including SMMUv3 header in generic io-pgtable-arm.h
> --
> 
> commit 251567dd4618edfaa4984ef7282b71a0da331297
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/io-pgtable-arm: Support io-pgtable-arm in the hypervisor
> 
> To be able to populate the shadow stage-2 in the hypervisor, compile
> io-pgtable-arm object for the hypervisor. This requires the hypervisor
> to provide the iommu-pages allocator, redefine the address conversion
> helpers, and stub out the DMA API.
> 
> [ ... ]
> 
> > diff --git a/drivers/iommu/io-pgtable-arm.h b/drivers/iommu/io-pgtable-arm.h
> > index ba7cfdf7afa03..4278da41e406d 100644
> > --- a/drivers/iommu/io-pgtable-arm.h
> > +++ b/drivers/iommu/io-pgtable-arm.h
> > @@ -27,4 +27,13 @@
> >  #define ARM_LPAE_TCR_PS_48_BIT		0x5ULL
> >  #define ARM_LPAE_TCR_PS_52_BIT		0x6ULL
> >  
> > +#ifndef __KVM_NVHE_HYPERVISOR__
> > +#include "iommu-pages.h"
> > +#define arm_lpae_alloc_data(obj)	kmalloc_obj(obj)
> > +#define arm_lpae_free_data(p)		kfree(p)
> > +
> > +#else
> > +#include "arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h"
> 
> [Severity: Low]
> Is this an intended architecture layering violation? The generic ARM LPAE page
> table header drivers/iommu/io-pgtable-arm.h explicitly includes the
> driver-specific header arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h when
> compiled for the hypervisor. This tightly couples generic IOMMU framework code
> directly to the SMMUv3 driver path.
> 
> Should the hypervisor stubs be placed in a generic NVHE include directory
> (e.g., arch/arm64/kvm/hyp/include/nvhe/) to maintain subsystem independence,
> even if SMMUv3 is currently the only user?
> 

No strong opinion, I think keeping it anywhere under drivers/iommu is
fine.

Thanks,
Mostafa

> > +#endif
> > +
> >  #endif /* IO_PGTABLE_ARM_H_ */
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015200903.2735565-1-smostafa@google.com?part=21
