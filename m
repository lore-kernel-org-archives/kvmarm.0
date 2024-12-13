Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C39518C002
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 19:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119340; cv=none; b=U0Wct8+alhSGR07IYv/D3LJVgnE7jmwFK5HKu4bjDN2gEXKiGnNLxwdyhjtYvTcT7O1RyysLxldW13TJ7trdx7YoAq8NJ7W/SyadYwWXjwvVc95G26VUk1RThv2ta35Z88rwo/XDi2uZ+h7T6Z5F7M2hZqurrQSHkNcVQFZoOdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119340; c=relaxed/simple;
	bh=Hcu+xxfk93UjbX+XANzHa25tjGomPC71CobQm6FJoQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltJAu7fHEotP0vi7Ot+MeFf8zC9ANjpuTwwPeg1Vu8YETkHl2xC2iRCWy8Q158IkQ1OKDXhH8HOK8RIIUQNiY7Gkt/QWJQ62+2vA6wY+eqeyZVLo+xAvnGW+BNK5j4PrOGDwuXYihwW8fiqTaIgGZIDXKP1seOiru4YQVOSN+v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QctuGGte; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QctuGGte"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43621d2dd4cso10445e9.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 11:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734119337; x=1734724137; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wTudxL7akG15arLWgUhGBbqBkCySihKjSTxtiyHKj/M=;
        b=QctuGGteSG/mZiFanCFZJJeIlNzf7Quj5UTkl/TTvk3g8MpHddGGl/YsiQxlLsA+Rv
         YEwA4LiQhlNxNzPwG8jhlRjpHZrdRxjV3uo55LNLq2gE/smBN6d4eEo7Mn4WyIfPkF6D
         jF4CNPPW70n07Xl9BLoooRJGGuNbAghP+IaTO6fWonGesuoxlk8rxVsk4zrxnWhtwObf
         5ZWPDDPJiJk6bGjZI95JyPBEaign5wFkxIxW9ySknvTXtiRTPiDHQCaTBZpK2i+YLXW1
         AkRB2YilKOSsJvASHpoDA2FH5gcPSfYOMh7rdVbEkQCEbIB8vmIyQVIR9G1dcD+QqD/F
         1JZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734119337; x=1734724137;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wTudxL7akG15arLWgUhGBbqBkCySihKjSTxtiyHKj/M=;
        b=eEOfKE9aMVqrmISE/pMJBnTeK96AIYyvlS5SmAj9As9preWdDiFQ0TsglezDtpdIDK
         1UBZ3cIOUtkem2TWvhNUHx7OjXdbyhhb7qXOwjMPs401j5dz2NY5m6LrejYrwd+MCoAW
         8bKByJlEnhNOAHChf4g/50M8gByUsYRDoyek46bQ6yzXxPeLTpgv7XZHQo9tBaAa6Ms/
         wbNLXj2Vh80ymxm70IlHI7gu/dZPg28rClrU36C4pH1n0iqdQBTfO11BWIQMudt4GX/c
         YKsQCoXR3KLzI5qQHHPpU68Kb2RSI2uiv4KZ8WZTJVpyiQrF4pb2bFKtDtuY/cyc2I5r
         gzVw==
X-Forwarded-Encrypted: i=1; AJvYcCXnMdkbUtBAN3wsb0aRI57gUXiTYqonEMDBD8ZpxgGLvWgL8UZuGvNp768eG5MTBjGuX21OAnw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyElDzD3qYLb3hHQg/YjFAAjpf4ZTqKjjH+I7kCWMtEPvVTSjJc
	pbMI1r7blwZIyTT4eQTns2a2XZ0ahhHdfZIujnMqg2KbYXtvwjHaa43HVan6cw==
X-Gm-Gg: ASbGncsjAX31DBJj9gtfhby3aFeyk5LVqXeM/HyEwahd3jAv5Tz52pn2rlnRXS0lVR9
	edP3bcNgHittnWlRlrfQC3xa19HqtK2MgwSX0IkQ++gOM13fDkHXfO1zzqqeOm9UReUBLRyjufQ
	1sUgyb9Lr8ZsVdjSYzYKQr01tnKKTFrJ3DW/1pYce+r15TAJ62BjQf+tCSSj6VjrnX4blI32+ux
	n2dpWSGomotgFShfmRRJ3cIm8izlXxijo9jtT4oLqcJ+nbEDIMWnzYf4HuABgpFn9iGFoaBbPcJ
	ccMPEwtZ3MxjDVWHzTI=
X-Google-Smtp-Source: AGHT+IFh74AH+6TGpxyM/Uf5omXCGX0AECGGvFVa2XBNN6YOFzqhpkphP8YdxRAEn5U+Y5leBLnhfw==
X-Received: by 2002:a05:600c:35c5:b0:428:e6eb:1340 with SMTP id 5b1f17b1804b1-436367928cfmr106175e9.4.1734119337464;
        Fri, 13 Dec 2024 11:48:57 -0800 (PST)
Received: from google.com (158.100.79.34.bc.googleusercontent.com. [34.79.100.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c806ce56sm342452f8f.111.2024.12.13.11.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 11:48:56 -0800 (PST)
Date: Fri, 13 Dec 2024 19:48:52 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
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
Message-ID: <Z1yPpEn_MElCRzLG@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-41-smostafa@google.com>
 <20241212194435.GA5484@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241212194435.GA5484@ziepe.ca>

Hi Jason,

On Thu, Dec 12, 2024 at 03:44:35PM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 12, 2024 at 06:04:04PM +0000, Mostafa Saleh wrote:
> > Add map_pages and iova_to_phys HVC code, which
> > mainly calls the io-pgtable.
> > 
> > For unmap_pages, we rely on IO_PGTABLE_QUIRK_UNMAP_INVAL, where the
> > driver first calls unmap_pages which invalidate all the pages as
> > a typical unmap, issuing all the necessary TLB invalidations.
> > Then, we will start a page table with 2 callbacks:
> > - visit_leaf: for each unmapped leaf, it would decrement the refcount
> >   of the page using __pkvm_host_unuse_dma(), reversing the what IOMMU
> >   core does in map.
> > - visit_post_table: this would free any invalidated tables as they
> >   wouldn't be freed because of the quirk.
> 
> I don't know if the timelines will work out, but the pagetable stuff
> I'm working on will let you write a much more appropriate
> implementation for pkvm's usage than trying to hack it into the
> iopgtable code like this.

I didn’t check your new page table patches yet, but I would say it’s
more likely your patches would land first, because as mentioned in the
cover letter, there are still many dependencies for pKVM before IOMMU
support lands, so I don’t mind converging if possible.

Thanks,
Mostafa

> 
> Even the iommu focused routines I have got now would solve this
> problem because they allways spit out a linked list of all the memory
> to free after map/unmap and never internally free it..

> 
> Jason
