Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670F4291C33
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 16:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410238; cv=none; b=Uyrrj3rEHP91SKmLC8EMsLhtQx3Bj0yaCsPDIYGWVpS/OEkHATHpErzRHreglBfDZE3rjVQ8jwKlsgSC/eXLM8Z+UCi+diGDVlpZCaR3+ed8DzsFtDZzptTiW8FZlHsyFb+oyFZOoqcizJuutJ6R6mXMzzDgCTh/xoIRrdFC2Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410238; c=relaxed/simple;
	bh=MSerwvz14RWslmARCsAjgCCXLaUZEmefMPtv/CC0p44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zi8n+jQTn3hGcmIIaOpLmG5ETV68msIyampqYSMryTs+bhvbm0szULRHgm1cgWP8RslYvYoqsecyzqb3cfd265uzzDiXsc0JaXmVqtVwZNFMhj8Pn/t8BNF49D7QnZDqnBNbnRbgnuq2Q9APtQ4Ua5eVV7EEA8iYxLRSMa+F9Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=PqbyuVzn; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PqbyuVzn"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7e2c1dc6567so283164785a.1
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 09:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754410236; x=1755015036; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GUQiiaWDlCWs+LVMgQEGU5eYzs+NIuuvY+XiZIK97rA=;
        b=PqbyuVznROU9qZuAvDnFpvqXsilWsxkHLDWx78X1qTy3id8pKRTajOOH59ZjsrFbkh
         cL48cWBBWHh4GGP+bu/2OMKTfUI6ivk1+SAdzTgUXmSG/k7dG9ZiVdojJkRjgozYRir2
         iOSxAaOrpd9aaPjAVmSME6qp127B0hDwvtpwK0WdPAhJgm17bm9LH9kuO4L++brcPoO6
         Hetyn9ZtZgSRXMEbxd69t27TWZdvsf4kwYjY11h+2/cxkZodNEpY5lT2FINt9j1P091U
         mbYXeQB9x08pJOU33w3vhMfydb+j+g5GMJQuZA/FGlRmO1JAODPg2s0nhvMl5oV7g8MX
         G37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754410236; x=1755015036;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GUQiiaWDlCWs+LVMgQEGU5eYzs+NIuuvY+XiZIK97rA=;
        b=f42tIdjCu3JePdSnPYjtwp54OTimIt0ETv8kJxApOFryB7auwKr2ZG+AW2Fbuy4n8+
         ca+XnVIFzznzG2uUGSd0UHrvcW1K5ZSOKt/B79hil+cntDKfeTGfcQ1RnMOnum7EPurY
         soL2GcYG2zzOopDbMFlvAnmeajcJnt0pLEUxLLY6lDnee5hivJn8PEI/d2PRecvPTMl9
         iwx+Ee1TsjBOEQkvNrviP1FuuShbXv3Xu0Zov2etNFYIJe5R0FIPLW2Xh3iqA7PcSrt4
         L93Y47Vpzuecd6iKRolIEv+XkSuBiTz81zukZNryVp39Nu5ybFE1QOabPXS4tXZIjrhB
         Rj6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWe/maUQzl2T1JEC/W7ArNJHKuX5glP4Ymyk/75415qvMI8bTWpLV/16rnVjB5wgsxIJRzd2So=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxrb794gbyDxzb0L4OJVJMo1zcPvzeq1mx3iXTlqmpXsOmHrxfh
	AW4yR+BcNSXigELOR/HInPpCltGB1of3QyfvGVfnMz8yzQC2Rs5uxIVJjEvQQsHnY6E=
X-Gm-Gg: ASbGncsd8pLzJvlyLMG6ZPkfiQuSOzjLHiILFtihcHBSF7LJlaiyKK1eLTVYZzqW1mQ
	66JeUyhNb7KS1TDy0M7HCrGDpXXHE7PB3fE6IZGlPgHvav0YIvLjDuS2tJuopEP3RnQcc3lNxMV
	vOLTKpzAKbedAq7nYEkKHahDu13+MyrW2uMC7pe6Fm9jWD3Qb3AwxCL72sJFX1L8SYGV0r7MvGv
	cj6eQfaNAcYRxP/bVZyStt6Fv2NREO/Exqyt3kAiKE6Bqb94Q13E79uzBvboA0a24Emyw0VYnvy
	KIWYFjxOaFTQJFOO5EHnTDCOepjxFLpbOS04y6nTZqnalV/H+uSmu3DEO0Av4A5DrYFiolI83Jn
	2TD4eSv5wWT0Kq84hh1GDbmHLdWcFVFTr9clfCD/1Fd0c+petOEYGagSnPHU9W6ZSEjHsAnS2/S
	sAWSQ=
X-Google-Smtp-Source: AGHT+IEjj+v1rIgRJqmyVkBhYcdet0WfxL50iTtkAjLR8rDt3iZUkWBN7QnPGs1X6WJS44VAtI66Gw==
X-Received: by 2002:a05:620a:2649:b0:7e6:252b:9b28 with SMTP id af79cd13be357-7e69636eee2mr1728455785a.33.1754410236229;
        Tue, 05 Aug 2025 09:10:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e69e15f5e0sm369670685a.69.2025.08.05.09.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 09:10:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ujKFH-00000001YwL-0rt1;
	Tue, 05 Aug 2025 13:10:35 -0300
Date: Tue, 5 Aug 2025 13:10:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 06/38] iommufd: Add and option to request for bar
 mapping with IORESOURCE_EXCLUSIVE
Message-ID: <20250805161035.GW26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-7-aneesh.kumar@kernel.org>
 <20250728140841.GA26511@ziepe.ca>
 <yq5a34afbdtl.fsf@kernel.org>
 <20250729142917.GF26511@ziepe.ca>
 <aInBxnVIu+lnkzlV@yilunxu-OptiPlex-7050>
 <20250731122217.GR26511@ziepe.ca>
 <aJFrvsURkhpTJgh8@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJFrvsURkhpTJgh8@yilunxu-OptiPlex-7050>

On Tue, Aug 05, 2025 at 10:26:06AM +0800, Xu Yilun wrote:
> > IMHO there is no use case for that, it should arguably be global to
> > the whole kernel.
> 
> I think there are 2 topics here:
> 
> 1. Prevent VFIO mmap
> 2. Prevent /sys/../resource, /dev/mem users
> 
> I assume you are refering to the 2nd, then I agree.

Yes, the region stuff is only about #2.

> > 
> > > The original purpose of this pci_region_request_*() is to prevent
> > > further mmap/read/write against a vfio_cdev FD which would be used
> > 
> > No way, the VFIO internal mmap should be controled by VFIO not by
> 
> I assume your point is never to use more than one request region in the
> same driver to achieve some mutual exclusion. I'm good to it. We could
> switch to some bound flag.

Yes and yes

> > The only thing request region should do is prevent /sys/../resource,
> > /dev/mem users and so on, which is why it can and should be
> > global. Arguably VFIO should always block those things but
> > historically hasn't..
> 
> Agree. So seems no need a global option?

I'd ask Alex if he is OK with a global behavior change to make vfio
exclusive, after any required fixing to make vfio only request the
regions once at driver probe time..

Jason
