Received: from mail-oi2-f43.google.com (mail-oi2-f43.google.com [74.125.231.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE14577E47
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098008; cv=none; b=h3dZ6hGENDTCebB1p8QBPWIjSHcMC47Z4HMVrZSDJeXzttVpTgEIiUSqL6diCkece/jEyxm/sfk2kJpwdj/1YkKVGJm1NewaRlu4TYTu8BvmvQkBkkZZKhSfLfNq19xq/909VT5Son61SSoTdDQivtkhtXDuRMjhQSBeXQGmwsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098008; c=relaxed/simple;
	bh=ZsMda0uwAQyf/r755/L9LfI3ibTlAaDp5ifNzI89+Ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZYYI27691CP4Z8jvW3jHlWoDbX85QObxH7m1s7ZtFc1EKs45TCphNSUkj5j9UalY1gXIjQe0EdwK2xdpVyxVy+hOy75RCDJYiOiY3e6LUOxaUDx3cTiA2oLz8sBoH6n/SPBSNAZRuRrueUZ4WyUsR88StCAf9KLcJf+RCbKL2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TAA+MgB5; arc=none smtp.client-ip=74.125.231.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TAA+MgB5"
Received: by mail-oi2-f43.google.com with SMTP id 46e09a7af769-8137b129131so138451a34.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 10:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790098005; x=1790702805; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZsMda0uwAQyf/r755/L9LfI3ibTlAaDp5ifNzI89+Ro=;
        b=TAA+MgB5i3cj5yTmEWtVqFhtQ64ZDiqeHgy6UZGJ03kUNPjdmLb0ZCE7n/yjJYMM1m
         phFG0a+ZHJO7whgI3lU5UKeyeYguMaZxJ6+L8V56K1aMGKekK6b94dM2iyGco+r0NRvC
         1OZCOPVzFU7zeZ+CCE9lDDPooBBSiEMAJlnqKtPA4yDVWFN6Kf/QeNFjESVxVDxVWL2G
         y2zR9vS7crazIU8I4BnupTjsUVtDkAFP5CTelWMs4y+6vdyh5kNsT0Z/o+V6l280QkJG
         sNhTBtksjk1GKBAHXLL9e4dRx0s+qHaSfGiI7act45TzAASFOWxDDbtX9BhFADV/dsWL
         VQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790098005; x=1790702805;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZsMda0uwAQyf/r755/L9LfI3ibTlAaDp5ifNzI89+Ro=;
        b=uPfkjsYc8ohsvaZFov79XfQFxMwTbfja9MvVnFhsV7CNYJWI/eKa5APg0Jp9oX1GEB
         Yl6+GSpTUZ7RJsztdWDQkrBzIDgDcvLRFpp2aarjyXrWrGTWZmPPl5bjBYm5CZoDB8uq
         BNGHwTOdTrd1cI8MTEAVUJUO6HYM8uWmto5XD8xoozgQJOBkPxKKPEkCfnIUwPntQNzX
         6Fjoi+94AmgxOKMoxK9c+SWTHB0t4q6+0IjnbPbzetc+LPZW473OZJU3L3ycgeyw+GA0
         oCFIThA8QHwwwpSazgmfrHawY8YyQRvZYM2OMcIwvFBmtP1uiBHGColXCV3UQsfmbPpO
         5tcw==
X-Forwarded-Encrypted: i=1; AKwUvBwjwHd/cDp83oYUpydIYK5wuo/m2DqckdcJRHLVC5TDGdnjrpVqIKsStpt+GwsLe9p89d3lkl8=@lists.linux.dev
X-Gm-Message-State: AFuF++l6zcGfiM66iEuMIMMO0QIESAvBA0rIVYFImkv4pVE+L2oQcrMq
	PQhZFHKhsHgTtB0+tDywajPaWst6dhCAuSNjQjrcBmRjwcVvRkZu049mnHyKOWCteeE=
X-Gm-Gg: AYBFou2GUDeoYHdmLeI/AMQG/ai8G/+oa9XKjGzw4dXSwlsFkjOU+18FQkzim/CtM6i
	t+9IcBvh7VdaN04twCvKYBP0wKWa2zYLabyQpuAMDhls0YIeuzNKA5m5jolBZI3WgJDWKgFaixK
	lpCKEIkmn5yEmn/QPW478BJhN7r4FexStB7JG87I9d7UvXLxLjh1PDhhs00Wgm8MN6n1GIZhcdU
	mOrNR1YZF1Re8hqQwYdyvGTK3c+r2i8ANTPQw7z/yJTdOhFGaDl0WKbd0X9H6b0lCb6XkX40Oo8
	KqyDQ6k2cBWcEQKsuPVol6KRUQr9OhiYOmnV6w2oatIeCx0zSbsqJZ4357vEf/zgfdYHbKSzDkv
	0t3aedjJvStPoOxtyP/iwp4W/zgjjmVl8Gv07qg0dYQyDY8wYNmLfI0hIFEUt21oKQwg8SFreoT
	jwJMvneZZMSt+2R3a9y0K3Ck+n4pybQP2B1Mrj2MS8m46i
X-Received: by 2002:a05:6830:82ee:b0:7e9:e488:3bce with SMTP id 46e09a7af769-815f0071c0bmr324985a34.6.1790098005310;
        Tue, 22 Sep 2026 10:26:45 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-81603fc79dcsm103564a34.14.2026.09.22.10.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 10:26:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x93id-0000000AWlt-1Oeu;
	Tue, 22 Sep 2026 13:51:47 -0300
Date: Tue, 22 Sep 2026 13:51:47 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <20260922165147.GD1540250@ziepe.ca>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arKsFofudnTYpXj1@arm.com>

On Tue, Sep 22, 2026 at 05:25:58PM +0100, Catalin Marinas wrote:
> Does the memset() post sharing logic work for pKVM as well? If nothing
> clears it, we have a small window where guest data is leaked to the
> host.

Same question for RMM? Or did they define that the RMM zeros on these
transitions?

Jason
