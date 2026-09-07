Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4984CA279
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 12:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788785553; cv=none; b=AET6q+6APVErlhO0GaecyzpwbCh5IyosAmveEd4inZMaNd0jN8mqln5+vfiEd+X3cC9rtfX3Y+a1WgP2JQYC48JJNmBHfT+LtsyBXmgYvigjQ/DUQIdhLIoh0TXvNtWkX72cVrhkIcb/s4u+3H0ZJBv8r0u5PTVoyY3MNbmCb/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788785553; c=relaxed/simple;
	bh=CgrQA9S1BOTEaFZVDiNZT9Jb/LSdMZymbY+ZFIFj53A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MmfuZJWC8OF/BE1ibaeHi3KxbVA2OINTxIAtrOevwIf3g6ASe00+s7fBaA6wHAKMbKqmK18XHVe1NzpyyJ0bRghXxPK8KP9McXDCDkXJPgigKkGvFkSnCg6nlWeJ+S/Bohs9s7VjDdAVVmnxXi6Me36lnOrNDUNMJHezcXHcSzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=IBromfFw; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IBromfFw"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-90e7bde5596so45739476d6.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 05:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788785550; x=1789390350; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iapkYXlIeb7+hecWmdI0rbQoSearWcjPGJwbmVo5xUM=;
        b=IBromfFwyzYPQXbxz/H9yY8ph+Lni6CFu1nS5fdLaYWWU8dUgXnfWzRd4545WJ2hmv
         iqQ7KOgfgRh7hEt9Z0BaFnzOuVW/pWk6tR4he2gEhxajG4GhgMYaj4hsCeCqZUWFHYGq
         SEQ2R6TBAMg/HzEYdGn0gROJ87l1J1rQMI5pAX7s4Eb1YEpT0+OiVGaElERRSik4Hyve
         bdthzSRLbSplHXhOxXq3NJdkEbNvbUNd4HM3L/jLTvBgeGRgocbnPyfRVylZ0S+AkfgL
         s2gRGoTp4aHqyuRHllwPcIjcXfULPlUJzIJTGUxdoNwA8gkf/ZW9DNjk8wUCexVHVZnd
         sJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788785550; x=1789390350;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iapkYXlIeb7+hecWmdI0rbQoSearWcjPGJwbmVo5xUM=;
        b=CbfCjkj4a5dGTbfK+I2F2b8S/Iw8H+AaA2P68kGHNDvHzkte9Qm1920RrOii1YQp8l
         k0zbi++VrAO6gidBKs17oePQ5vIx+9tfHOLDG/cCraDPWnPHccrG0ecGiWuKOog6b6SB
         aER2gjct1v3HlFLLCtnxNPHSd+retdhg06rP4rG23hknAN1wXh9GkjpVCFz1LnNaNBmS
         i8Y4J/B3OfQn6asFNP/cs1v52r799oakPS7P6HJQV/IDGGd5spOEGbRyz1xfVQsOXjKr
         dVucnvPVE5958pOjDIdgXBdHQk51GsXyFVURWkfUcTdkYZQohy1WMkv9PHk6VM/FfYCb
         P6FQ==
X-Forwarded-Encrypted: i=1; AKwUvBx5o+7yc2/iW/kd2rNhsFKMyT1FgDLX6M3B5gYp4pnrDC6u6mel51LSQzCeFmQJEKOvCTjygYk=@lists.linux.dev
X-Gm-Message-State: AFuF++l5jwODNJDey04SibpTaY7J+fb9Ud3cs/E3UGVnI6lOibC0WtXV
	J0nrrSkfIMmGrLI3H1q/cesnXHzHsJ7eui6WA/Yi55wgUFkgT8zhbWrau0sHDLREbsY=
X-Gm-Gg: AYBFou3SBRRBp/tDB2fArQaC1A0JKWviHGk8VjNn/n8lm/xfCYiY1Mhk6jG62HgIifB
	tqilXEYl9tIQIC7TUxXlODPwM6YJ3qBaXDuK6yzxkZPQDR1AMspy/doug4t0d/fDFT+nPaIwNi8
	SHSYsm3dzhZBO65/g/CGhwO9DXA1rGvNuH57+b81ZCtAZcq+Lh6KzadMNTRqgPht7GbwhUSJSD7
	wtMBTtMIU+ImG6AkuZR+2O6Phd3r3RdyMhVOSzlgoSHYAYKD7ot2CaXpOMhfyxVGEb221YnJTsy
	3EAFJ1d/2GhefXpTmy1SaA2t0JvJaDS6MRi359wx5BV30ndicPnv616/kgSRMxWFPX8SGBcCeZq
	yMaInsQPyncC3Av8WyQtD0fh+SggUUJsdfFZzZD33g5tQ8K/KRqV7qUYB1Z/ifep+7KCDD4gD4h
	kECFVIu4xvYI5Hj5BcVFDNSZ4SlnbZUDXCoSHC+vONG1mgG7OnQ+OEGU8Z7GdDEsSHlXBSKX8Wx
	j3q/oqRw1Wt9+kmnqQxfqY8x+NGCd/kR7/OPJTM004GGA==
X-Received: by 2002:a05:6214:3d8b:b0:910:479a:f7a7 with SMTP id 6a1803df08f44-910479af8camr173644776d6.30.1788785550029;
        Mon, 07 Sep 2026 05:52:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91048476220sm62621416d6.31.2026.09.07.05.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 05:52:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x3Ypo-0000000AfMt-2MmF;
	Mon, 07 Sep 2026 09:52:28 -0300
Date: Mon, 7 Sep 2026 09:52:28 -0300
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
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <20260907125228.GB667892@ziepe.ca>
References: <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org>
 <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org>
 <yq5aecfbzjyk.fsf@kernel.org>
 <20260902235609.GG2890729@ziepe.ca>
 <yq5a8q5izxz4.fsf@kernel.org>
 <20260903171704.GK2890729@ziepe.ca>
 <yq5acxupjsy2.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5acxupjsy2.fsf@kernel.org>

On Mon, Sep 07, 2026 at 03:15:25PM +0530, Aneesh Kumar K.V wrote:

> I looked into this, and it becomes fairly complicated. We can move all
> vdev/TDI-related code to arm-smmu-realm-v3.c, but that would result in:

I was going for the opposite, you'd move everything out of arm-smmu-v3
and into the arm-cca-host and obtain the viommu through tsm_ops not
through iommu_ops.

I guess I pointed to that in another email.

The only thing arm-smmu-v3 should provide is a simple function to give
the pdev phys and irq parameters. arm-cca-host calls that when it
creates an viommu object.

> 1. Adding more CCA-specific code to the SMMU driver.
> 2. arm-cca-host continuing to own the TSM link setup (IDE).
> 3. Adding callbacks from the device communication helpers back into
>    arm-cca-host, since device communication still goes through DOE.
> 4. Moving the device communication helpers to firmware/arm-rmm and adding
>    something like:

With the above change you don't need to do any of this.

> The locking also becomes more complex. Unlocking a vdev can trigger a
> stream key refresh, which is owned by arm-cca-host. Currently, the locking
> is simpler, using pci_tsm_rwsem and pci_tsm_pf0::lock. With the SMMU driver
> owning the vdev/TDI, we would have:

You can't really avoid something, the vdev *IS* the TDI and the ops to
effect it come in through the iommufd path. The ideal version is the
tdi is never used outside the iommufd path so you don't need to mesh
the locking quite as carefully.

> - pci_tsm_rwsem protecting the lifetime and registration state of
>   pdev->tsm.
> - pci_tsm::tdi_lock protecting the function's pci_tdi pointer.

Like here, why is there a pci_tdi linked to pci_tsm? Anything coming
in outside the iommufd locking is very suspect.

And the iommufd locking should spill over to the TSM, you should not
be able to remove a tsm while a viommu object exists.

Jason
