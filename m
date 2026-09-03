Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538824BB5D2
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 14:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788446854; cv=none; b=IA7EPeor02+f0rjHk96VdmWJklQulLdHNuKMPMuk2t80vKQLgrybXdXX0xOvqh7f/3z+b68h2ELY5EAWU5qDDaJX5c0IO2ZGPjsWf7tBB+Xsjkrq8WwWlZqS4QmPN4doT0q/AZjW4v18Ng2Q/g3xCBcet0NEkIdMmRleGK7K/f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788446854; c=relaxed/simple;
	bh=s35i71g40sE6NNYFzd2cEk81BylAH6qoa2XMtwsVrmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trM2sjN6lDS9C9jdqZHw9RttAwVBUnrcnuPKmXTP2qe9XA163Y6E2NjDYr80hseTs6j8xpjo5Bl4zvVb7WBltdWpks4VzkgDkBpeVgR4O426qnUpBDANBoE4dvm824XXE15a+4mOUqsd6cpWT+1iFryCqIpVbEtbc6QxVrGgsS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=kXVKO7Df; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="kXVKO7Df"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-52fa6005224so21833911cf.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 07:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788446851; x=1789051651; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4QmS2bFUIAw9Owot8+v10VgE/MAeq6BqPd7i1PWMP/Q=;
        b=kXVKO7DfzVL9uDGPD++GZMZ49i/iLmUzigR5xouxRPebKRkp0YOLMFD3/1kHe/5wBN
         LYVuZvDSDZIHF39lhGC5ukcdfGLRMC+zQ8W1gSOad+KVSl71aWQEK0JIwksJUvCI7JPC
         HsZa83YvR+A2S/qswtpfkI29sarf22uD8Fd5/UuGSzEOZH4t3nxqEUtUrNS8yQVmvIG8
         cH7mL7FGOxvDzA66uFra9v00k5kbL4IEsXthF+Mdx6IuvSmGG4+034IPOLMGSb42KiLJ
         HU4A1Ay65AjfZw2IJSbE+FQV4D2xFSkkeLhT1fXD9MbFsigWzRnysUTLzsyTABLDioOQ
         nohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788446851; x=1789051651;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4QmS2bFUIAw9Owot8+v10VgE/MAeq6BqPd7i1PWMP/Q=;
        b=llVIPnmDT+ojIIeu1xwiCH9Spb+XSvky+9K9pChVGJMxWXIDNixiVTHcnOlL68lXwy
         MWLzEV2NRn3BbLa6c3n7J52u0wps0Sv01aeWnc+FdO4O5zGew5ORzAXUkAUha0cXME73
         at2VnsxX5N6nJWC0GjkS7sGoSmZRnO+09Q5l+YjWvXE6e7yq5pomdgWcKfZ+WwvV74oI
         MMi40ReRLUMTnHLXtKo34WsDcfevKYHkYIK7pf39xbPcIRf7hVOD7E8WH9sh46L4PQ1P
         2yKdbb3VhIoqqM5yprR+yRl5hXJSAK0Cdt2SDXojEqtLRFXQFG975l29b0xRK1iwENYY
         P1FQ==
X-Forwarded-Encrypted: i=1; AKwUvBzIT3rn2SHwo6KBndM2ev9lYUpzl8Tgtz1V2psiKVloMz4YLRkzsoMCWMynLFRtlgj9vdWqz30=@lists.linux.dev
X-Gm-Message-State: AFuF++l/kUdZBn6cQ1/TgRKR4N+3zbe22RC6wV9wvUve3jDzk8xdREsm
	ocMbZz+80CyiTR4iRppC/uvUv5Xv/heA/9IguGAVzoekAykFxnpl/jF7toK7sNGLm86bB7v/vGa
	gNOv+
X-Gm-Gg: AYBFou2ulbwUnPWZl1oHPO9pLrd5q3XVQ6CxKTtkKVL/TooluVKWO+DK+mL4LpZOf6f
	jKuzm6r9zy89D5fSybWDMu+wXtZ2fM0AztwlQDMpu0Iwyo0GcWIfsLGILgiaKfDFeMShA4XEWoY
	DGgzlvcsWt9Yq8sLFUg/n8FA791fI3o8npW/wyUAz0PxKTofpxtXIeezQ7aqdac1IZKtsDSPON4
	JRyIK/v8rzuQgqt/3q4SYb0dptKQldKeMvJOWUMjRxN+PFH4JQJb+WFOzSfgoP09xnrVyVOcElc
	YsIEtoavAkLg/NxhCT0SePv+obhC7qbMrPVEEgmRKhgtIWleggsCrPoUzcC42PS7ul/rtjRFBAo
	TnG5tMO11ac9MHDhavo2FQA7y3egCnQMXNseBLNWt2hg6ndDcOcZeJdKiCyUWOFgiYmCuSeAZ38
	RqAYHR+87MtpNTWttRLgJkmIpYU1A0lKjUD6halOB0kh1b6alYW8tG8G+iEyecQyMKwCvjLPNkK
	hoFj3Nkk9K24BrkYPSA56agatMZvAwM9TtwP1cQXVrE4uWjmuAgzMYk
X-Received: by 2002:a05:622a:1455:b0:51b:f40b:2fb3 with SMTP id d75a77b69052e-53036be6a5cmr143516721cf.9.1788446850990;
        Thu, 03 Sep 2026 07:47:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5303301ddcdsm44166831cf.9.2026.09.03.07.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 07:47:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x28iv-0000000HFle-2ikl;
	Thu, 03 Sep 2026 11:47:29 -0300
Date: Thu, 3 Sep 2026 11:47:29 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>,
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
Message-ID: <20260903144729.GJ2890729@ziepe.ca>
References: <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org>
 <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org>
 <20260902193014.GF2890729@ziepe.ca>
 <yq5abjaezyxl.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5abjaezyxl.fsf@kernel.org>

On Thu, Sep 03, 2026 at 10:58:06AM +0530, Aneesh Kumar K.V wrote:
> > Do you mean the SMMUv3 driver triggers RD creation? That feels
> > wrong. Did you mean the VMM just does it earlier?
> 
> Currently, CCA creates the realm lazily as part of another operation.
> Realm creation is triggered by kvm_arm_rmi_populate() or
> kvm_arch_vcpu_run_pid_change()

Okay, that's not what I would have guessed. But critically is there
some way for userspace to specify any realm creation parameters (like
rpv, ats_plane and so one) prior to the lazy creation?

Why lazy? Why not just have userspace provide the creation parameters
and create the RD right then?

Jason
