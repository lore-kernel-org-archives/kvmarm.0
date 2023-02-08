Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D096AAD
	for <kvmarm@lists.linux.dev>; Wed,  8 Feb 2023 18:01:14 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id j23so2430006wra.0
        for <kvmarm@lists.linux.dev>; Wed, 08 Feb 2023 10:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QsaledRgqtR8MThisrbwNQQMiogQzEIa1ri2xN8U5x4=;
        b=cg0MVG6I6Y76rF/CZvC25sdPVewyNWnsbfa7pgSc2FzuvBEF1nJRYSbvtTtvCpyBYJ
         HVLVtYnuT2OXWBj247C60aUx18fMk60nfUTiPvyx4vWWIhhiFEXg1o5dZyYT2/CaBTHP
         Rk2W5EmObgDHnqXG6uH8g+U60GFuUN5xmPtLp+yaC9KRyVxJF0lsGEdkb3hXs1k4BBWs
         iXNRGDCeD6nJQ4LykFmzgC8UAm19GyMoUamSPNDWn8i1D9ZOfuf2RdGy1ji+r3lnwDIr
         AagVGYdSSv5vJlQaz0Ywkho2nGWBLCoeb1NwcamBM2qwdKm8oT1IJM430mbbdShhBRYB
         BaSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QsaledRgqtR8MThisrbwNQQMiogQzEIa1ri2xN8U5x4=;
        b=E3zYipQNa19vLEV5mL2KpQVZvwVtR+xff2aX4ZIcvP+sj+G2wFwkmEzqftWqQKHANw
         Kitd4bfVdAdApiAY0DweEOyT0cNHdeVhTmUn5Cl2i+HwXSutsnRnFhsy7lHZpnRBzvnQ
         2hiBlxc2KP133DdpCK9XVXhwjfWkkVru/oAj3/sky1OoVovjBgKQzfGoB+3zd47qIXfn
         Ojp4QdHr4jPuzqKB3A/n7U07WNtpgAEKveqllBbgyuc/tltC53glc5S3bxauvnMA/wpU
         LoTtsbbq4zj7NOBRX5Tru3SRzCD8k62uledgmeJzezoAFBxl34vG3EV8wjxehSGNaQcS
         Fr+g==
X-Gm-Message-State: AO0yUKVOOQEj1vmjpheA1Ghhgqi6TzggRsoLq0J/S4MVhyO+G3Eu1ApT
	Vh48IJfkLDdH46OVyDvbhMsA4g==
X-Google-Smtp-Source: AK7set+3IM5sAOEuhaAPwVF0OVGRlrlPx7WqR8A8ToS+qIOpKQFwoXaZmbDkTQkIZJClDWGbpxR0/g==
X-Received: by 2002:adf:e80e:0:b0:2bf:f44b:7a29 with SMTP id o14-20020adfe80e000000b002bff44b7a29mr7118746wrm.40.1675879273302;
        Wed, 08 Feb 2023 10:01:13 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id l13-20020adffe8d000000b002bfbda53b98sm11081478wrr.35.2023.02.08.10.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:01:12 -0800 (PST)
Date: Wed, 8 Feb 2023 18:01:07 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Daniel Vetter <daniel@ffwll.ch>, David Airlie <airlied@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hector Martin <marcan@marcan.st>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Rob Clark <robdclark@gmail.com>, Rob Herring <robh@kernel.org>,
	Sean Paul <sean@poorly.run>, Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Yong Wu <yong.wu@mediatek.com>
Subject: Re: [RFC PATCH 05/45] iommu/io-pgtable: Split io_pgtable structure
Message-ID: <Y+PjY34M9M4cQRg3@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-6-jean-philippe@linaro.org>
 <Y+JBDIF+IaEPiwR8@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+JBDIF+IaEPiwR8@google.com>

Hi Mostafa,

On Tue, Feb 07, 2023 at 12:16:12PM +0000, Mostafa Saleh wrote:
> > +static inline size_t
> > +iopt_unmap_pages(struct io_pgtable *iop, unsigned long iova, size_t pgsize,
> > +		 size_t pgcount, struct iommu_iotlb_gather *gather)
> > +{
> > +	if (!iop->ops || !iop->ops->map_pages)
> Should this be !iop->ops->unmap_pages?

Oh right, good catch!

Sorry about the size of this patch by the way. If we decide to keep this
change I'll reduce it by first introducing these helpers and then
splitting the structure in another patch.

Thanks,
Jean

