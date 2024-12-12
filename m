Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACA025948B
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 19:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734032679; cv=none; b=GtcIRwien0AhzrVbrkf5qWJ45POyGM/pFIB3aEXCMAZni7hTlyZ+R5gXwn+2Edm7Dh5dn5g7WF/vhniygAsHqWLZ9sNcQlljGsazaNvvsQrGKNGXj2N1HhdvHPo2vaJDRG0vctvwjIzTXaG0eSK0HGwu9thnHoCmMKyL6Hn/COA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734032679; c=relaxed/simple;
	bh=45Ud0Mn2aNdFEQLclVcWubuH1Q8UAhrJeGlwWksFBLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sz7pQcKOaWDkjpii4eOE8i3Tt+1JZSLiKYg/wd0g6M6WYuh/BwOtJ5qIMHU/BLYIsFsUdhZeKf9/vo6PBi2txqCG0iuX9EWr1OvrPJIj4ZsRnwI8NYmi+kg2AkZ0QEo9C3uw0tl93YAl/CBIrShIjUkKsenHt6sqMl7pJAmGXZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=VgGQt2FV; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="VgGQt2FV"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-46677ef6910so10453221cf.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 11:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1734032677; x=1734637477; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mtig8lXsoUwLD51T1aq3aT1xZ4mrN3No+06U1nAA6eA=;
        b=VgGQt2FVgYubZ3Ke51YqBmIbTKU0ikl8bHTrYfIkjUghdWGFXBHw2s34LkExgNM2E2
         YGfVWhoaRdoaXav0ywccchACKOSBVLco5DvoyIiCHiecH2G4H2ctIOG8sMoQgXtEDShN
         pxz1wlAZrxf44MqSNxIc0w0eWIZ5/9wRabn4d9aZPNwk/6jfNvy/72/XAqUdlQo3oJ2O
         KWhpEsQOfr8FXZt7PeUe6kLSjscNdCvR5JIvDz/W19zoOsdAP8hWdfET8fYU5TPR9T6W
         QSS5imnGv0HJG99l7BBcoviYzxE5Bk2yQksoujO7dpw4H9VxumnZLYdEA4gVEbnJGNt9
         H7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734032677; x=1734637477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mtig8lXsoUwLD51T1aq3aT1xZ4mrN3No+06U1nAA6eA=;
        b=F2jN3lOL8ZRRrG4ZEzGLUZRoA10LM6gDZlmKpr/D7PlptT40/7nb0l7N9Ummux17dG
         7Pk4H7qmcuASYRCnsmioDSJ2f3EbZvsfsqvhngKn3cVfyZQpPlDbq7ppkSe8iiGssNVi
         vb9I4yri262/Meh3sw+zIuLRdwJvOijw7ssNF5e5TVa3fdGvBLUT9ITi0vWQh9Tz9Ril
         lTHhDIpJHILCDRK+whxDc2Enuor6LIMPz/uBPrIfPZHkvmHqd3QdKJhlw4iAvuE0EFsu
         +CIW4+XHgBsif6WABzfxjWGPBQncL+oiwOCO95JRFcW1UGUzI8t03ZMDQ6W6RC2R5LrR
         Jykw==
X-Forwarded-Encrypted: i=1; AJvYcCVYiumc3gctnwyJCrGylrAJ3JA8r0siZWiAzcixVr1jrb7wsXGRGnD8e8huaiZ8IjV+XOf0NrU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz58WZvrlyg7EEIhjft3YlsvDOKVPUhWHRnh9Bpm8BRoboFafWv
	GuveWCg1rBXeXarC0zMbvoURuGQTgHN23I8zQLtbqIU95aeGCz7byGhDgglaZwU=
X-Gm-Gg: ASbGncvQwuHdBJP44ZC1totCadOGy8wyH3ixzIW9xFFPtmfnzqIF0ls/2TKnDKZ58xZ
	iViyIuPHALQlkmJLDc7YBzM9bXNQynjRXIpu2/SjHqHMShgyus4xBrKLiWtjqRevGK/Hx9iJck4
	NvhDKAz2Fbry7kDfhSbjVd+vJ3nAhMQONRdDx8xk1RKNYAZI3meh+egmt+0eHJ3UZWtxy0Z3Oau
	pQ3pq/7Y6PQPGyChrMIJYBS5EGD6woBcPWMZUWUUpKyWw+qXW512FdSptYxP7z9c4ymopptH3oO
	FqFEFj4LmDniyDqn0n1quL31jstDtQ==
X-Google-Smtp-Source: AGHT+IE1sxaWouFki1wTNuqW4Mldx9O5wExQbsXpYwJ4pEsT62nJIL+C/8F//xL6ak8oICXCgpkwJg==
X-Received: by 2002:a05:622a:1114:b0:466:9f89:3d6b with SMTP id d75a77b69052e-467a156ffb2mr26650471cf.24.1734032676656;
        Thu, 12 Dec 2024 11:44:36 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46783eb0d91sm28376531cf.63.2024.12.12.11.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 11:44:35 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tLp6x-000000001Zr-0B7D;
	Thu, 12 Dec 2024 15:44:35 -0400
Date: Thu, 12 Dec 2024 15:44:35 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
	robin.murphy@arm.com, jean-philippe@linaro.org, nicolinc@nvidia.com,
	vdonnefort@google.com, qperret@google.com, tabba@google.com,
	danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 40/58] KVM: arm64: smmu-v3: Add map/unmap pages
 and iova_to_phys
Message-ID: <20241212194435.GA5484@ziepe.ca>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-41-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212180423.1578358-41-smostafa@google.com>

On Thu, Dec 12, 2024 at 06:04:04PM +0000, Mostafa Saleh wrote:
> Add map_pages and iova_to_phys HVC code, which
> mainly calls the io-pgtable.
> 
> For unmap_pages, we rely on IO_PGTABLE_QUIRK_UNMAP_INVAL, where the
> driver first calls unmap_pages which invalidate all the pages as
> a typical unmap, issuing all the necessary TLB invalidations.
> Then, we will start a page table with 2 callbacks:
> - visit_leaf: for each unmapped leaf, it would decrement the refcount
>   of the page using __pkvm_host_unuse_dma(), reversing the what IOMMU
>   core does in map.
> - visit_post_table: this would free any invalidated tables as they
>   wouldn't be freed because of the quirk.

I don't know if the timelines will work out, but the pagetable stuff
I'm working on will let you write a much more appropriate
implementation for pkvm's usage than trying to hack it into the
iopgtable code like this.

Even the iommu focused routines I have got now would solve this
problem because they allways spit out a linked list of all the memory
to free after map/unmap and never internally free it..

Jason
