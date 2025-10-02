Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ADA13A3ED
	for <kvmarm@lists.linux.dev>; Thu,  2 Oct 2025 15:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759417992; cv=none; b=Igpa0TwezdbUjMB5V71DHflAahBliJlwVR9GX3oYDROw6LbVA+n2xLr6y+Yp7Nn9USEumXocIU8ItFcuBstbj5MGMBe912oDrqS/8LzaPKmDeWr0cmqh/ck7J8aD1sbnIdR8cqfsoQCMM0k1Z/2UQeIb6paKV+gcUUGKU9sBcrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759417992; c=relaxed/simple;
	bh=XJdd5gCENWxVBNzk0LITi7rBVPLt55cKg02vaft5zSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WKVTDOSpkaN+wxSmutMj29d2+SCiCUkAKa5k/94xbJvk6ZXRJig3bY71r6gv6R8T4xh/i9iAI+a0nEJILUvbwnO81cQHo9KLwF/izbgbaiJaIGyzCptBFCgPCm0pbh/BEmyq+W0r67hQFsrNSMTZLth4UVmu3Fbwxmgs9A0aJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ozZlq+CB; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ozZlq+CB"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-875d55217a5so120734185a.2
        for <kvmarm@lists.linux.dev>; Thu, 02 Oct 2025 08:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1759417990; x=1760022790; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XJdd5gCENWxVBNzk0LITi7rBVPLt55cKg02vaft5zSo=;
        b=ozZlq+CBYIDW705C1qQ1msoxIe8tPau7T14wivo6nkeCnGAGtPRP5YjjAPFHqxDG9g
         Y3JlSd7aB2DROA+cHtX2wIZd5m+jENeT5iFaTrPgoNaf8FoC8twLMJDY1dqwqmddkOYr
         57t1HRbL0iuq9HTTfzqWh7FJPZoNlF4d3dsrwpxb7tpvsFkd9SaREvmWBeF1B6ey+nGH
         mvZIOvxWZF25L8GF1NS+gh7Z4iWDKb9sLoDg+eG8nE3UwcoKZ4j7ip0ribFcobrHTS4b
         yvwEwa+0mSdhL0LGQuZ1M/dGRIDG3ZZnnrj5//8teTqmiKN/nBk+bjRjrLz4IhGExVr6
         JktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759417990; x=1760022790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJdd5gCENWxVBNzk0LITi7rBVPLt55cKg02vaft5zSo=;
        b=XfCk8cOVnrl20uLo9vtoUPyrGbJZ//ZcynVq2qAL9qofMGm6Hj6FtSd5PLZBRf7OSB
         8JGbfABVTAX4u0NyPPFw6RMhLRbPJigSWgxIRL/lW+053+acLgTqLjpYqPEcMEBDqowO
         gCq7M16DUa4RXsuL17Oo+Deov22gPjH10rnmVdhc1ctfNK05/joGhNO3GuMpF5/A+ja8
         AKph6J7WKJyksjC9cg57PSueFeCIcSSfUg0ncYESjD81U/mDQqvYdRfhASvU2f5+r5ym
         +NUBdqzTQ1ZDsXHxKUKcv9ct8NmRoCZ6QTMmPSejC2qHRBAav7PDJCOThz+iXaKKUyN6
         BarQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwK0DNcQrH4qxK+z6LlBfWL7EOknK2TlQSicbZl+DK/fZJN2w/vYCmJWQriL11oXVBkAbfcJE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJn5mBMzXmOOLSmIATEweQiNvKkStcRlUOoB0RbwTIoRLCo7jw
	cxDfGqgAmPL5ZCwlbY3RILePdki4rWsOVCirVAT/rqZnd0Veyj2N3PdxneEHWsAWWtA=
X-Gm-Gg: ASbGnctPRspkV6i36RJgDBxz3VVlCAJTxuN4ZBVHOrfOJxFA7/24KaEExailtB016zy
	qHjo8WvV89Quz6CNP/LEOzbfagfHaAp0CMmrJUI4/73TVZQm7k+TYqyN3SnOVFYJD5tsoAvLYZi
	ZHfWR1zUCRFiBrIVQxXMH/milTXBytwi0ppBg3S4N+V5SplFuwRorjZ8z8+AyS6reCsicxnbnAx
	VXw8ANfvorJq9kKpbSyMtp451u82NJmJJmrwnWiKs2gtA1LGCkjgobUtYrIy8K/G5iSP2GmprMa
	FGgzo5gW+koI4KyIYZ7DtcgDrQqcrLaajHScYJ5tbp5DGpP3u7d0esJeLJQ7jTJD04kJz4xV9XF
	LvYnJA+LVZ2OulTVut9Epo/dV9s3Jxc64tfzqbIM7MIIiIHRKcs3Jj4iBMOAu4JBPVL1c88XDR+
	ZUfJGWbJTwDgbZqcb+
X-Google-Smtp-Source: AGHT+IG0oPe5CNlBpr3wJjmSULJ8S5uq9PiyYd4xVRPRgnIUY7cEyRWUA/GTHx85PtOoXdDh+uje/A==
X-Received: by 2002:a05:620a:1a0c:b0:85e:5022:33b7 with SMTP id af79cd13be357-8737780ae60mr1108818085a.72.1759417989421;
        Thu, 02 Oct 2025 08:13:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8777aabeac7sm224623585a.64.2025.10.02.08.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 08:13:08 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v4KzU-0000000DqDS-0i6h;
	Thu, 02 Oct 2025 12:13:08 -0300
Date: Thu, 2 Oct 2025 12:13:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 15/28] iommu/arm-smmu-v3: Load the driver later in KVM
 mode
Message-ID: <20251002151308.GG3195829@ziepe.ca>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-16-smostafa@google.com>
 <aMQmA9cLaeYWG5_C@willie-the-truck>
 <aNKwROPzDCWgJBGQ@google.com>
 <20250923173806.GF2547959@ziepe.ca>
 <aNppE9A3PDiDg_1W@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNppE9A3PDiDg_1W@google.com>

On Mon, Sep 29, 2025 at 11:10:11AM +0000, Mostafa Saleh wrote:
> Another possible solution, to keep a device bound to the KVM driver,
> is to probe the SMMUs from the KVM driver, then to create child devices;
> possibly use something as device_set_of_node_from_dev to bind those to
> the main SMMUv3 or find another way to probe the main SMMUv3 without
> changes.

I do prefer something more like this one, I think it is nice that the
kvm specific driver will remain bound and visible so there is some
breadcrumbs about what happened to the system for debugging/etc.

Not sure how to do it, but I think it should be achievable..

Maybe even a simple faux/aux device and just pick up the of_node from
the parent..

Jason
