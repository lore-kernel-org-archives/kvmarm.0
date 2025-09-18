Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0862523C507
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758206214; cv=none; b=Etx9bi5tKuLDQ4aI4VYjKDTWzsN5TBBodap2hZKr27JsTpJxacFsmnJVh6EKhC1mL2rYyEOfdlsyaIEeRQOy5eQM3ppm8A3bWU1xf/Nz5w106BLUUAvgc068d9vpCyYeGMAprxTluMWRrwSWUjgqW+F4dmDIg9kc1QmRida8G4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758206214; c=relaxed/simple;
	bh=5IK6dxmlUx1MjIUb26gztFgKXFnJCShruWZFcwG3LWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qoPSkv1xKLdCGEdWeeg/M/X8sCu2z6Z5GHE3KJV97H25I1fMUgmOZSp9S5rcCxm2QlkUEIso7e0qRSSJbv4hftTXy9hxjorPkDOxtrQ603tJuuyCQRJWMFz+P7TIk5SnxZBL5p9dkyyuvQPhcOlYC5cjE24qHq+8Z3Sqvjh2QhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=arO0gZmr; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="arO0gZmr"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-80a6937c8c6so124364585a.2
        for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 07:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1758206212; x=1758811012; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zrVmh9WioYbmEoq4Y4G7QBMqeKPDVKPWX4R50WAG25o=;
        b=arO0gZmr0c6jBo6Z3EBeAd3MTN7VKk/RONkNsoV1bf0Fhh+CYqdkfQaGDQzL/nTElJ
         3cxOxjiPzLx5zm4OounBu5PHPQFSguHV1/VP8rb66PwnKqpidpUWW/5veE/JDOQm9Ne8
         hFbd/ahCMe+3GLbn1iqdoO4eTvALZN9gMHQ0Qeflw9CNLtEBzM0zPVyl1wlrvlpIX3Ri
         EGJAS2mGkvOyPjBCMpJZzkdhLSy5jGdUxd3bcAzmzCqQ2D+rP1uJm5/Ic+WVfoCp08hW
         /6T7gyg/cBOROy3kLCEXIqFty33VrmpWT8HgwRTr/G6j5E6+AMYpsniphf4aM6np2gZI
         nnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758206212; x=1758811012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrVmh9WioYbmEoq4Y4G7QBMqeKPDVKPWX4R50WAG25o=;
        b=YUrOjHbCMvh/4elJCOJyciEftzLctSPzUxvfSiqyItmsT1SQ1gJb6jbw0Dw8rLVrGR
         u09Yr/ocivbwrdm4vG+vDadQY4YmFpCYgMITF1px6L8ohDWvyj+DaaLYksdaJHbnfaXS
         3idrcrJvy1kW6vdcWKHrDnWTNnqDGJSCyyBuvWBVp7ROSxMIYUFhjuV8ZDatPA3VMHqq
         am3ZU28sNX6o9pzULbY4lF1Ew5LFpTRjNUOaBeMRWRcPbllNfRrLAFM618jG3cSwmZZV
         PjurrllC4YphNWQqzz97Xy+7tZ0H4hqE3PpgER402RPCJ+IpCrQfsASfuGlePHA3eis7
         FDjA==
X-Forwarded-Encrypted: i=1; AJvYcCVvvvI2nYn1aPR5FC0IK34B/zuKAsl2VPX/hBDcUH/qJicoA+pkwE6SmRYkqxaaKChv3t/DfVw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuFVJGhqWGs2YM/0/RauBY/dGRQ1wojIFyGjjjo9+AotyVRLi9
	PShMiQzaePF+XuzEps+/oauTTa7iisfz+XAWRUnn+djNx4g3GiHrJertG84R/lTMXL8=
X-Gm-Gg: ASbGncubZ76QtGWTCETVJflSyE8tWEsUfGaHOgl0fFGTu82IIgZoaQX6YHt9d3AP7tw
	bEtd/X81jrzpq70Kfr1G8mqirCaN+c0llNobrKB41okr67NObilTek1ybEwEaT6Lf9WLFIJBhqR
	E5YE18njhcWeASQMJGndE2JAi8Q5m1MwHhWBERdWuYJshUhB6hcnUf6YMsRHeCv4kX8JgQvd20D
	5ETJEFaMd2mVY9fg96kM/e8c8Or5VN0E/Q3h5icd9LlYSoUtN5ipFUN7kcAHHVrOtfwOnIOnylG
	yVUbd21S2p62D2j8yPFMHY9k5j6Iu1nPrsv4+WMU/jaENDeZcp6RQ0CV51xsweizgi9+g9bh/Cq
	gXy9ICDPeeWRYMQ+Ljv6nm/WW+7vwn/9kykTUc7wo0dzzNcrwLzAfGTlnmmzHPeRcfgLW5LrXyT
	0e48HEBaG6lwc=
X-Google-Smtp-Source: AGHT+IE8/5Ud/i8k8I1bre3zwyW5lDIdJBqEnB52NPRTieNqwTGZ6V2Ab0vPLtj2VgmwLHtb5fpg9w==
X-Received: by 2002:a05:620a:4152:b0:806:a07:9fc5 with SMTP id af79cd13be357-831085ab77fmr631920785a.24.1758206211361;
        Thu, 18 Sep 2025 07:36:51 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-83633b04dadsm168450785a.64.2025.09.18.07.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 07:36:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uzFkg-00000008wHU-1PaB;
	Thu, 18 Sep 2025 11:36:50 -0300
Date: Thu, 18 Sep 2025 11:36:50 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Will Deacon <will@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 22/28] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
Message-ID: <20250918143650.GQ1326709@ziepe.ca>
References: <20250819215156.2494305-23-smostafa@google.com>
 <aMQroI4NDu74PDGT@willie-the-truck>
 <20250915163858.GK882933@ziepe.ca>
 <aMl_5j8G3IGulAC6@google.com>
 <20250917123601.GA1326709@ziepe.ca>
 <aMrNTny9jgZJd_Ef@willie-the-truck>
 <20250917151612.GH1326709@ziepe.ca>
 <aMrS71vQ_MaVonzi@willie-the-truck>
 <20250917155931.GI1326709@ziepe.ca>
 <aMveas3QWXUk6xpm@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMveas3QWXUk6xpm@willie-the-truck>

On Thu, Sep 18, 2025 at 11:26:50AM +0100, Will Deacon wrote:
> On Wed, Sep 17, 2025 at 12:59:31PM -0300, Jason Gunthorpe wrote:
> > On Wed, Sep 17, 2025 at 04:25:35PM +0100, Will Deacon wrote:
> > 
> > > Ah right, so the driver would unnecessarily issue CMOs for the structures
> > > that are just shared with the hypervisor. At least it's _functional_ that
> > > way, but I'm sure people will complain!
> > 
> > Yes, functional, why would anyone complain? STE and CD manipulation is
> > not fast path for anything?
> 
> Won't it also apply to cmdq insertion?

Oh, changing CMDQ wasn't on my mind..

Yeah, OK I don't know what the performance delta would be like there.

However, to get peak performance out of pkvm we really do want the
SMMU driver to write CMDQ as cachable, pkvm to read it as cachable and
then copy it to a non-cachable HW queue.

Otherwise pkvm will be issuing CMOs on fast paths :\

If we convert the slow speed stuff, STE, CD, Fault to do CMOs then we
could make a fairly small change for pkvm mode to force the guest CMDQ
to be cachable without CMO. Some special feature triggered by pkvm
detection during probe.

Jason
