Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809FA3546C8
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 01:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788313907; cv=none; b=dCShzgSXjeNMBffnY9RxMW6aroSD6pn1+pFNAzsid1N2j5Ah2wWw7/icbfKo9QeYKAkJr/X+z4xMiftxC6ZCnSji4PGtLuz1peDyNhtzYjU27uTCBcTESgHUCgthLkHQ7llohRnr/UgqeFD4kqYzf/wJhFVFCFCQQOFV2Thcd98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788313907; c=relaxed/simple;
	bh=E+oXMdrF2sleLVDXDyRpoFuZgDFkHIlL9VN1wy6t690=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PknIR0tO3CWOW+gDO2+aNyl5OnLlwHGBRljoD2iTnYf3n5LpcY4XTnLshF3AxEF+/UpV7ZompSvZPOW1ha/RFvf9nYOpsnfqOqbmJQKfPnG3lVCQZBMuELU/jZsYKpXWfQoB8BFGZa6OHG5V0IQq/rZuw9gd+3pXJCmRCpNWUdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Cokh/1k8; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Cokh/1k8"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-90e8535619bso5656686d6.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 18:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788313900; x=1788918700; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E+oXMdrF2sleLVDXDyRpoFuZgDFkHIlL9VN1wy6t690=;
        b=Cokh/1k85vJ4CHgv5xK2B6hIC0TBeuhQwpiDPs/T6jzFx4j3tSi7FxhK/fuEvlQJpV
         PgJwRJPA29geLfVJFt9nIH/L/Ep+i9sendCwtO27hjtPQJe/Q9ddQRyIAPkwcfg4jZ5w
         lIMAtNsKQ26s64ofj9UIYqkeXP9QFuEtUoYpfxdijkLiZHG+VvmcTe9JmBvIdJbg91rh
         DSxOusKi5yjI2HL9XBTXqNEJRuHLGevNFEgCv+Hkk7NE0pXnvTwRxr8XJiL8pZCoICgp
         OxNZ7S3Kd5fjQITLcgeixgJEVstV/UKqf67D7/AOutS/eCV5TM5/kU1mIy9mJLBior2o
         xFAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788313900; x=1788918700;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E+oXMdrF2sleLVDXDyRpoFuZgDFkHIlL9VN1wy6t690=;
        b=FVg4KkXlcBE1od9BQxouQS4F1Chwn4YZP+qj8Y1VqKs2/UmoRVj+vpRCcRbEKPazCJ
         f9n4uN2DHBLzpA9hinNzTS9TpnIeLsMNCm9+fnGbxypF3M3k87Z7rZdSzPQ6RcpNfT+z
         oNSRD1mVpJqd/9o4obUdpNFvU/TsYDjZFZDlhmygNCcXctExGyNVe/YlC+ZR0fE/pKVt
         k2OtKg84AkOTzv0rTshdueyBKmSmFTmnTojTmDAPbDkbWz6JYwhPCGM48g67ApcuSl2K
         urUYHrmZEs2tASjexlXE5SYfUii+L0OdEtody5GAe8rrQDo3x6DEiY2NlHA4Uw/xeXlD
         sfXw==
X-Forwarded-Encrypted: i=1; AKwUvBzQ2xwAH09eW9ZhsiJMEVLrFf9kvPalAc064UEENws9ou1ac3rRR/N0JrOGk7hsA+QuKNNDBR8=@lists.linux.dev
X-Gm-Message-State: AFuF++lf/gB3gwQ2roF770Xb3+Nu5mebhGggylN9oIPCMzpyOPcqCX2v
	ItEvzSc6+yUI47kdr9DBWBDU0aysWX5CE8xBPe+0/rp0uOacRbQ2ZYKdQYD46cMoLrk=
X-Gm-Gg: AR+sD11Xj520RaWwmAG7VDK2GpFXe7Q22cFjIDtwE2NsY0+tZWofDNfc3g4rp38hisc
	AbXobOQ3vhMRsM/yE/CiGU4Slc9PniYJEr98Cg4hY0m+mHG/ANjLkYb6O5GnqF5RG42IdjBfcba
	1J94bdKSy6mYumgy2jrPFgc11DPLq6ZJXKnN5Z6Agf9hV07hiATd2fTNTV6Orj1cnfMav2nYJdx
	Vec0YE+BCAVhwUEhaEhtR/76U8Tbp7kN24U5/E0sxkrAAuoS93ks7J+P9glgssYeROrXzle7h5y
	gcsgykS7K7cod3p0JLMBOV9taoTJs1jV4QW5TDXCmgUUN2PJDaSlJFTBxNHowfDvjiTvWhT1p8w
	gRnc8iRucsxHkIsLijysmC2WRcSMmaq9YPxcGEOdRqrTBtaLABx3tq573+/8512Aj7Ox5kDK7P6
	JyNe8joHrZ+Vj4aoVCK+LsUTQ4lT0cdXRb/CLhbMHvOqgIOWZGkv6Suo6gOVmSTene17ajdGu8X
	b+sk6ypLy20aYZ3WZ5sJYvRvIhuV+vEnLka5l/cou3XQg==
X-Received: by 2002:a05:6214:2584:b0:90c:c53c:a032 with SMTP id 6a1803df08f44-90ebabce888mr24156306d6.25.1788313899587;
        Tue, 01 Sep 2026 18:51:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eef4f20sm7284946d6.41.2026.09.01.18.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 18:51:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x1a8X-0000000Czw5-2tb4;
	Tue, 01 Sep 2026 22:51:37 -0300
Date: Tue, 1 Sep 2026 22:51:37 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <20260902015137.GA2890729@ziepe.ca>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <apcHoHKGoI7WNFXp@nvidia.com>
 <20260901174230.GA2847102@ziepe.ca>
 <apcitkpASOREamQs@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apcitkpASOREamQs@nvidia.com>

On Tue, Sep 01, 2026 at 12:08:38PM -0700, Nicolin Chen wrote:

> The viommu object here is an empty vehicle that almost has no use
> but to allow another vehicle (vdevice) on top to forward vBDF. It
> makes VMM code a bit awkward: there is no iommu instance, so VMM
> doesn't enable iommu driver, then there is no good place to alloc
> the viomu object for VIOMMU_TYPE_ARM_REALM_SMMUV3.

It would have to allocate singletons viommu for each psmmu as part of
setting up the vdevices.

Somehow I'd rather the vmm deal with that then invent a whole new set
of uapis and flows..

At best maybe we can invent a kernel side helper to create the
singletons like the auto domains, but IDK if it is really so hard for
the VMM (especially compared with how hard everything else is in CC)

Jason
