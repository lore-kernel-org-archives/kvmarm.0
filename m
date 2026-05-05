Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F15492503
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 16:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777999409; cv=none; b=SoiLSefbRf6jDG0i2KrdByVgNrvNtnGoufReqYiZhB0y7fVx8Y54bSDD46bBySgEtZaq959cO3p8zVxdrkunEUrLZEFvstjkEUXDwwK+CDYpZbGKCEYnnXmmaLx0/gkBa0WGrMs43YG0T61qUfXlgXgPfqjLqzmizv8UTAyUIYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777999409; c=relaxed/simple;
	bh=faS2CkT9BSZJpclVo/IT6hgfVCE3Khrz9KkbYaXxOUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQrkyrvw1Dt1WTAVpSKK6ZV70q72IPTSA1FWZsIFWcrRv9nnqz+ldP+C9WOQokHnQy3n6kwF44IR8XSvpzfKzboj+9FIIN59mgnFNesuvC3CiG8e5HwYBmuY7chbu+1M5xm+d6UQMcXEIePmz2jfZawHsFJT86WsORqB8ThnYlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DA3hSj8Y; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DA3hSj8Y"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48d1c670255so2845e9.0
        for <kvmarm@lists.linux.dev>; Tue, 05 May 2026 09:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777999403; x=1778604203; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HIyq5XxnZOa3QCDQC431jNPLKmCFh6Pbs13KNByKE/o=;
        b=DA3hSj8Yk1WdO2v+YERP5St+6lFkyXNOWoVeacVJAoRXB05f+EgQh52xzrshavxcTc
         jq2iuO7XvZJu5VrXqmsV9jYdlx1XN8Z2tW34Fy8+2t3hPUVa6BzlrDMyMS4/QjVL8GDx
         04ztG0hZcSu5WkrxGbZB+ljaB+2goG21grKr/a8jbGmCppOmB5BdyiAfBY/3gSoKFzPb
         Z9jz/edbn1O3L697cvyNCFTJ3l7X0J08ZSbv4dZDVqvFRxesKYFXcKM7Irq7d1QRaBSb
         a3JiXxeiweNSo67GcTBu6wLTwPOQJSJhU6w3P8W+1+ZG3RyQ7bwpoHp1pmO1wrdY9D+E
         pyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777999403; x=1778604203;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HIyq5XxnZOa3QCDQC431jNPLKmCFh6Pbs13KNByKE/o=;
        b=GDbIu1NA1dnGG0U3lA0G9AkWPOtfdFbAlkGAD8WXs0Z+DdRcGRu7fsgm1QV+B1gglq
         5O1Lj4S05JqmuP/L2gLcMYeB4DK4rhNJ403EgQW8jKNlptCX0G3syGnO/TX4n1TbKfJ5
         CQiphaeVKRbJtaaLPyX0hPZ+F+ZVu2E9A2F2a7u5FZ6wXvzahaQkCy7Bnc5s5o1mL7Ye
         YD59WXvAiJrxzBQW9apU9yQicB3X01SgYHSW/9wX6yw0LdSr6mbmY/F4XBlBi28Zz2QP
         9yRVeH+cI4P85knBO+4dsak2gAAll7NOE00AiwyQQicQDS7Q1EBghkh6iKG3aPsGE8zr
         3DfA==
X-Forwarded-Encrypted: i=1; AFNElJ+kvkTK6jhcDuq9SU5DR+DMVAV1f3Q9Bo6aTKraOUWvCV6VNHbL29s/53pTN8+FDh7Oh8ol8sc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzNZolW5DQSAK4ycQkPOC/JKoHSkHnaPJ6qHHafFu+utXYiIv4
	xh+BLk1VLi4Sgzr1bQXqhKxB0jlhGZFHuJyUYRPcor+zJeFC3RCOzs/X2JW8yYOgog==
X-Gm-Gg: AeBDiev6AyWX/BZ4goB7B3mkXVU86BnvIjdqesd4werLJLBQKIwIYj65F/ehfOaEOyo
	B3XaPDHuejYyUpgbtLtpv1Jcitk98ZJAjZ9gLTTqYC3S/OC/RCrZu+xsOpanjXbyi/I62viHgYA
	4TyMZ+llepKVNexZFTxAlPinSIVTgSEv5+xMWjnsrVkZOEXsMc2z63N01s1NNVO31Ltqy+Uwdn1
	IY3GPafypG2HSMT28Ak8Sp2TPY4ZVrbcXZAph8y+i2nfIdywv5WQFa1GNmQ3JSWwIQg0gw94q4z
	5kp6lK1MMN84sEfl2NkfD2FaUufc38sYghz6P4sajFTsBp/hx3urfWVnbzPMjyqsz9+ntP+1YSf
	j7NQBjlp5dMwhCUIyfR97mGWxXnYs21k8Btw5joCN7FkCxlyad7yZJJOytt9gPEwl5UQvlDMbJI
	aHUGEoazgnbrF5rPziXohup7Hmq6XLirPJGf3RTU/MLIpel9XLqo4rYEVrSqLW69wsTXCfyFve4
	aCO/g==
X-Received: by 2002:a05:600c:2214:b0:48a:6321:87f7 with SMTP id 5b1f17b1804b1-48d147423acmr907145e9.8.1777999402201;
        Tue, 05 May 2026 09:43:22 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48d14e15ce9sm22679075e9.13.2026.05.05.09.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 09:43:21 -0700 (PDT)
Date: Tue, 5 May 2026 16:43:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 04/25] iommu/arm-smmu-v3: Move TLB range invalidation
 into common code
Message-ID: <afoeIVIGE-JjYy22@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-5-smostafa@google.com>
 <20260501124143.GB6912@ziepe.ca>
 <afiN1UwS9q6F6A_v@google.com>
 <afoYBYIJOTClsdLS@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afoYBYIJOTClsdLS@ziepe.ca>

On Tue, May 05, 2026 at 01:17:09PM -0300, Jason Gunthorpe wrote:
> On Mon, May 04, 2026 at 12:15:17PM +0000, Mostafa Saleh wrote:
> 
> > I am not sure if it’s worth it, the hypervisor is much simpler, there
> > is a single page table, it’s locked (also identity mapped), it’s
> > updated on VM boot/teardown only, we don’t even use iotlb_gather at
> > the moment, although possible but I wanted to keep this series as
> > simple as I can then we can add more features later.
> > So this patch is the least intrusive change, as whatever the main SMMUv3
> > driver does, the range tlb invalidation logic is the same.
> > But I am happy to experiment with that when posted.
> 
> Okay, then maybe just always push a full invalidation?

Like full address space invalidation? that will not be optimal and will
affect every device on the system, why would we do that if we know the address?

> 
> I didn't like seeing the range invalidation lifted out, especially how
> ugly that will turn into after my next series. So, don't use range or
> use the proper full gather flow seem like the right two options.
> 
> I'm not so interested in minimal change, but maximum forward
> maintainability. It is much easier to manage if you double compile
> more of the driver exactly the same, and call functions in a fairly
> normal way vs make special cases and special functions..

Let me try with your series, but the core range invalidation shouldn’t
be changed often as it is tied to the hardware and wrapping it in a macro
is reasonable (just like the CPU tlb invalidation)
The last time this code was changed was in 2023.
I am happy to use higher level functions to improve the driver maintainability,
but I don’t see what is the problem at the moment.

Thanks,
Mostafa

> 
> Jason
