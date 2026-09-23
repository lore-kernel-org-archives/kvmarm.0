Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB06542ED0
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 15:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176888; cv=none; b=XWqjw40aGuHsNg5hVfqbQlftIkW4iwzB92nFp+IYxgdBqicEgm3Ih0ftLHsq8g5Q4u/klBVWfzyBtij9z8XFGZjRLFHTzKlU06CiGOqawEXtwtniEqdUVZGAgPBkfHJ4mTFDu+sqZKeOUBY0n+6kVXrk0ZfI6qXHVXIxVqMgKNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176888; c=relaxed/simple;
	bh=FuSi1oPqqK51hcEmla4NiGsVvsoifIYHIz4OYEHBKSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=blKFQYIYla29v+eNZCvLKasLk5CyQf4WEIcKw/jKU57vY+TRMowqnIrZe962n8aOgx1YVLJGnfKgZtpe2b5wLsgkhlz4XMgbik34+CJV2KsVSRvQiVVTQFXjx922MfEHluvAcF6v94LTxBI/rgTKpMc0DE09oruH4S+Nn1PvucE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=WazqBqdf; arc=none smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="WazqBqdf"
Received: by mail-vs2-f12.google.com with SMTP id 71dfb90a1353d-5c67e5292fdso442461e0c.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 08:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790176885; x=1790781685; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SIwOLjI09a3UXj303jplkjBLREygxuyiG19PHUNbQ2o=;
        b=WazqBqdfOjk/1vFgMamnuTKMuLarB00T9YyDHGvpIbBBwMP/Wbp1cXAv3BO1k+E7kZ
         Ulz24RMyIhhlQx/hSj3wlqm7ZasPr3QR1AmfZITe6n6c7OBn3iw3PlA34KOLvHFyXXzQ
         76rlPDPOj6wDfYqEHypYpo+GsTxAnoBg5vGBIusxYNGAU/Wy13Up7LuJX5vaZ6+k9mPT
         BooQfKpwkY4PDn03NRvcCbSsAcPSrGa0gx+NueKR/bsLXn4UYj4bpPo2ifWjhfxRKnPS
         nMPVy7kNJs4/4LBoouR6Q9x0AMQ/9yRYBDrQEzNVombg+xJlF8EjlynRtBDPAVnZZRbi
         xxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790176885; x=1790781685;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SIwOLjI09a3UXj303jplkjBLREygxuyiG19PHUNbQ2o=;
        b=MWT02IT9Rxeo8Rw2CdUKqfIPrF507vlly/BRWcUbB3lbHxG6gflfQ3HStw6w9P+38V
         pwvD4Qqp8H2EvIaUOfjR7NIT3+xtdAEyhrU30pzOVkz2gYFPzEoQiOMLJqLN3j5Pu7d4
         UZaf5dHNSlLV1hlouqxx1w60Ub548BsuF9dVKe1Tu7P9dtXir5GCDNl2VkZe5/syFobQ
         Xo/voq4eVrws58MDPj6fOfAkRyFFi5LibG531WTljLVpvKdGUIhzrJNs2TjBTV55x4s3
         yytRJ5bIt6vkLiZLaDhwXYS2q+np1z7UbDM4ZAmAvs/Df2DSBaOQr2VUdV25SgdGu9/D
         NcZg==
X-Forwarded-Encrypted: i=1; AKwUvBx/gyZMp59XgsTmoDq1HgAmZqLjhOQAAVS/ROLsY7L7DKCnNcZVIql/py/6A+GuYIYbFLas88s=@lists.linux.dev
X-Gm-Message-State: AFuF++lI2hr/31aXeU+eCqgmSJ7ZPAx3IQUw/Ox8zZRzOJbWD9HGm3BT
	uJp6ADHS/wrMGpLQMZvwf+ip0v7CHezHoTPiwX1Jsq+ZyMb+R5bRzewdnPT60ugn3Ac=
X-Gm-Gg: AYBFou1vgij7ugbbn2JfOU4BLijDgCFjY2XxSXI1uyUgJTEHkkklaonE7QKYOZEGNhc
	PjLSZ6NbewXTwixPyMnwjSKaUv0DYeL6YfQ+pRgqs3bMO45PrkU+xthwvfZPv9ddXY/CqC/eZwe
	f7Nd5/lxMsznnzNmTzwbx6WliBYoBqTx1tt0GVBX5V2GbMIZDQKV4o1gzYG5duUMgqVHZfCFdk/
	827y9VgQBkgprFZN2x3IaCWCs2UkznDjiN3VSU2bD+tHBj8tryx+z/LBDR0DGsE4A5+7vNy48qf
	YShLetwyCJwfG1caNmbPl+1BFUPrcaYJXYM8zwV3bwL5QCHDm488tWgo6tOBcbXFn874EXRWh+A
	wv15lsyApBFhisCFGHXlL4zmlmd1eYyeBVS6pSqak+ePcUVLiZh26IRNZz5X+hD4+rKx8yyke/k
	lhaqX61jUJ6o5xhrF5Nl0kIS7xkGspKJkrRdZHdkxYlT3Z
X-Received: by 2002:a05:6122:4896:b0:5c9:a60d:22cc with SMTP id 71dfb90a1353d-5c9f16b9729mr3999503e0c.21.1790176885467;
        Wed, 23 Sep 2026 08:21:25 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c277636e4sm181224485a.41.2026.09.23.08.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:21:25 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9Omi-0000000DrJM-1RIj;
	Wed, 23 Sep 2026 12:21:24 -0300
Date: Wed, 23 Sep 2026 12:21:24 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, christian.koenig@amd.com,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <20260923152124.GG1540250@ziepe.ca>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
 <yq5a5wzw2ree.fsf@kernel.org>
 <arOspFxWZ1DjgcAr@arm.com>
 <20260923130611.GF1540250@ziepe.ca>
 <yq5atsng10b2.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5atsng10b2.fsf@kernel.org>

On Wed, Sep 23, 2026 at 08:28:57PM +0530, Aneesh Kumar K.V wrote:

> I'm also considering requiring the address passed to cc_make_shared() to
> be in the linear map. This is currently required by both TDX and CCA,
> while AMD SNP appears to support vmalloc addresses. The only user of
> that vmalloc support is Hyper-V VMBus GPADL setup
> (vmbus_establish_gpadl()). How should the generic CoCo shared-memory
> allocator handle this?

vmbus_establish_gpadl() is the the same wrong abstraction as the arch
code. Get rid of it and use vmbus_establish_gpadl_caller_decrypted():

		pdata->recv_buf = vzalloc(RECV_BUFFER_SIZE);
		if (!pdata->recv_buf) {
			ret = -ENOMEM;
			goto fail_free_ring;
		}

		ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
					    RECV_BUFFER_SIZE, &pdata->recv_gpadl);


So you made an allocator that returns folios, now you just need to
use that allocator to implement a kvzalloc wrapper. ARM can call vmap
on decrypted memory with pgprot_decrypted(), right?

Or maybe this can use vmbus_alloc_buffer(), it already does it.

Jason
