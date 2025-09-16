Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D762BD015
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 14:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031858; cv=none; b=CbTbyC6Iqc2WDbBfPDIFzKKJjBXoLvlD0mdjRQNCiPbCpYeYeAdrY8wgOvcZXH7pHIOQ8sUCNeOvuCMpemnc8x6pzmAUVX5JMRzhJ4TGoOuuIKs8XLyCE5MEiIwV43lxiXEekIqh5J+GSss3yJI9rhTA8ffQi3tdRpcEzdxZuE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031858; c=relaxed/simple;
	bh=Uxf8MqdO1X/OQcBfHGqc0vs8bgkDRlBb7pU7mDzTtxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UN5m/1/VEGAagWR8dr4Aa6vYy69WBzlOhja4A0SqTb46GcTFq42BPmbBxbZQ8KgamDnCh7jUj9HVoSeVJPni10n/Ze7S1pvBvR8bg2bssCwjqY1BsuUVwM9YaCfcfzYh1rm5vMQWS3ikOSNkhNhktDzPSS8MZ7poLU7w2J3G5xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SigRcDlQ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SigRcDlQ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45f28aba94cso53895e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 07:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758031854; x=1758636654; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LAXPi8+KuwRaa3qx04ySFQpznpxpBD4ALEEO3wmFkAo=;
        b=SigRcDlQ5PPkC0qdP0yhdZiLlOvVQOfWuGbfdKNWNRN8En+czF4FXJIyEG0JjQ4R9Z
         cce1yV3NBdlz2XrQ4QBpWZ4GVGDBaUUAJN8ZvP/G9LeiW08GLuktebxevh6BYa9H74Fe
         d+k3grlZ158i7wGPps5w1t+uXy8gj5JBat+H0CWQEC9Fxd24PsuxjaADtCVuKh6ikRKc
         Uvf227IAiXiYR2eE9dtvpg7UGCFtP8CVLSIRZIq35M8+ibcQtW7BX4H1vi8Usl4FNY7t
         b2gXDOcX5FKTfTBQYkxgm42ncSkw4BBm90FYitE4l51rNUL98arEChzFu1/zCFXcxuuo
         kM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031854; x=1758636654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LAXPi8+KuwRaa3qx04ySFQpznpxpBD4ALEEO3wmFkAo=;
        b=rzlU9RlHKARw0nFB46tGfNlHEoxi49xodgiylnBILimeYwH9UUULXT3iPo05WSEs95
         sp9UKrR2Dv5HMU7yT7TLflPuhx0M7nlLXY/k5jJSsGkhluh0hpfbuSpxG78WXDBjBBrW
         MuLm2QQGCThM7x1+0TGomdgfoRfomC394tjze4Vu0xn+eoT6KYKffH8+54X1CksAv05H
         cMD7I2Rgngq+Q7FjIMqbmD+bMP/aDU44VD6KWoj0pYTWUdJzSU+67aTm3pabf8v1ntQD
         uEIYXFX91rnNfS2RF6WRm2GvKakvhBH5EasmUoefKwnl/rnfq0p92HF9Pc+xGrLRF17b
         RiUA==
X-Forwarded-Encrypted: i=1; AJvYcCUv8P9EhHcpw6C5fcm2VA5Yj7FfZ10rku9rdDi09nqUNpbjaTxnU+zSUzqORbdtoG0oVCEmVsA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPeTHjxVsAKMsRXC83oQYdUwDdchn9DTeMYL9F29BP+JWaVGpC
	LHSVUXmY9npmHkG2hRDiY1sefUN7fF0QnzJnbI7vIe44AH1wQUyPG/WNBSw1XCNVxtKT5bmhJWP
	qt/08DA==
X-Gm-Gg: ASbGncv0nk7qfU9wTX8XQ7gx2Hz3ImCJe7DyM3egUZCLHXQ9tNcYplia/QEGIte15zr
	bXK2U96Wo8Nehb9qokTPk0mTkoxQr5TM5IzNlON8eZLqG1T47DBbdoH2uEmTBXxLg1LLzAFJ6Bb
	Q4Zp1/PqTvVALn2qO3qAq4Dqz4VWJ4vafet/7b5u8XBtEHxc8ZTJDg1ZcVB/RjDMqF6ZURO6UEX
	QQDko/2lzfPUGTNgQIjx1Q3NAJO3YMWdXtHh7OyPvSsY3ZNBdUXgN53OVo4nnpM5l+rQusVOwdL
	GokB29c1PNTaWSxSD77YN+hT6RMpP2bxH9amGWDqb6FxT2S4QJ9m4KXP2D7ccWmv+pOFgyH2Uw+
	Mga6WnAjUZtg5sxy/xKutzMueaEc+qyEgA6DZfr4np93PqICyf0w65HYxE+zOCiwQtFkOiDyI1r
	1dJRzl
X-Google-Smtp-Source: AGHT+IGcTe1ECO2GamWj51rf4zuyd3cbzaJnBRpBuslk+LBrCQjMJhqgUMk66hHXtNsu5/Krbmp77Q==
X-Received: by 2002:a05:600c:3b85:b0:45c:b4fb:f0b3 with SMTP id 5b1f17b1804b1-45f3278c3admr1396305e9.3.1758031854210;
        Tue, 16 Sep 2025 07:10:54 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037c9d91sm219090395e9.20.2025.09.16.07.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:10:53 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:10:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 06/28] iommu/arm-smmu-v3: Split code with hyp
Message-ID: <aMlv6rLaZ80j33OV@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-7-smostafa@google.com>
 <aMA4UpDgLDuiGYf8@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMA4UpDgLDuiGYf8@willie-the-truck>

On Tue, Sep 09, 2025 at 03:23:14PM +0100, Will Deacon wrote:
> On Tue, Aug 19, 2025 at 09:51:34PM +0000, Mostafa Saleh wrote:
> > The KVM SMMUv3 driver would re-use some of the cmdq code inside
> > the hypervisor, move these functions to a new common c file that
> > is shared between the host kernel and the hypervisor.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +-
> >  .../arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c  | 114 ++++++++++++++
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 146 ------------------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  44 ++++++
> >  4 files changed, 159 insertions(+), 147 deletions(-)
> >  create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
> > index 493a659cc66b..1918b4a64cb0 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/Makefile
> > +++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
> > @@ -1,6 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
> > -arm_smmu_v3-y := arm-smmu-v3.o
> > +arm_smmu_v3-y := arm-smmu-v3.o arm-smmu-v3-common-hyp.o
> >  arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
> >  arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
> >  arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c
> > new file mode 100644
> > index 000000000000..62744c8548a8
> > --- /dev/null
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c
> > @@ -0,0 +1,114 @@
> 
> Given that this thie is linked into both the kernel and the hypervisor
> objects, I think I'd drop the '-hyp' part from the filename. Maybe
> something like 'arm-smmu-v3-lib.c' instead?
> 

Yes, that makes more sense, will do that.

Thanks,
Mostafa

> Let the bike-shedding begin!
> 
> Will
